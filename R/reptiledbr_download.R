#' Get the Most Recent Download Link from Reptile Database
#'
#' This function scrapes the Reptile Database data download page to retrieve
#' the most recent download link available. It searches for Excel files (.xls, .xlsx)
#' or ZIP archives from the current year and returns the URL for direct download.
#'
#' @param base_url Character string. The base URL of the Reptile Database data page.
#'   Default is "http://www.reptile-database.org/data/".
#' @param current_year Numeric. The current year to search for the most recent files.
#'   Default is the current system year.
#' @param file_types Character vector. File extensions to search for.
#'   Default is c("xls", "xlsx", "zip").
#' @param return_info Logical. If TRUE, returns a list with additional information
#'   about the found link. If FALSE, returns only the URL string. Default is FALSE.
#'
#' @return If return_info is FALSE, returns a character string with the download URL,
#'   or NULL if no recent link is found. If return_info is TRUE, returns a list
#'   containing the URL, filename, file type, and extraction date.
#'
#' @details The function performs web scraping on the Reptile Database download page
#'   to find the most current species checklist file. It prioritizes files from the
#'   current year and looks for standard data formats (Excel and ZIP files).
#'   The function handles both absolute and relative URLs correctly.
#'
#' @keywords internal

get_latest_reptile_download <- function(base_url = "http://www.reptile-database.org/data/",
                                        current_year = as.numeric(format(Sys.Date(), "%Y")),
                                        file_types = c("xls", "xlsx", "zip"),
                                        return_info = FALSE) {

  # Input validation
  if (!is.character(base_url) || length(base_url) != 1) {
    stop("base_url must be a single character string")
  }

  if (!is.numeric(current_year) || length(current_year) != 1) {
    stop("current_year must be a single numeric value")
  }

  if (!is.character(file_types) || length(file_types) == 0) {
    stop("file_types must be a character vector with at least one element")
  }

  if (!is.logical(return_info) || length(return_info) != 1) {
    stop("return_info must be a single logical value")
  }

  # Required packages check
  required_packages <- c("rvest", "dplyr", "stringr")
  missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]

  if (length(missing_packages) > 0) {
    stop(paste("Required packages not found:", paste(missing_packages, collapse = ", ")))
  }

  tryCatch({
    # Read the webpage
    page <- rvest::read_html(base_url)

    # Extract all links
    enlaces <- page |>
      rvest::html_nodes("a") |>
      rvest::html_attr("href")

    # Filter download links for specified file types
    file_pattern <- paste0("\\.(", paste(file_types, collapse = "|"), ")$")
    enlaces_descarga <- enlaces[!is.na(enlaces)]
    enlaces_descarga <- enlaces_descarga[stringr::str_detect(enlaces_descarga,
                                                             file_pattern)]

    # Create complete URLs
    enlaces_completos <- ifelse(
      stringr::str_starts(enlaces_descarga, "http"),
      enlaces_descarga,
      paste0(base_url, enlaces_descarga)
    )

    # Create dataframe with link information
    df_enlaces <- tibble::tibble(
      enlace = enlaces_completos,
      tipo_archivo = stringr::str_extract(enlaces_completos, file_pattern),
      nombre_archivo = basename(enlaces_completos)
    )

    # Search for the most recent link (prioritize current year)
    year_pattern <- paste0(current_year, ".*\\.(", paste(file_types,
                                                         collapse = "|"), ")$")
    all_links <- page |>
      rvest::html_nodes("a") |>
      rvest::html_attr("href")

    current_year_links <- all_links[stringr::str_detect(all_links,
                                                        year_pattern)]
    enlace_reciente <- current_year_links[1]

    # If no current year file found, try previous year
    if (is.na(enlace_reciente)) {
      prev_year_pattern <- paste0((current_year - 1), ".*\\.(", paste(file_types,
                                                                      collapse = "|"), ")$")
      prev_year_links <- all_links[stringr::str_detect(all_links,
                                                       prev_year_pattern)]
      enlace_reciente <- prev_year_links[1]
    }

    # Process the found link
    if (!is.na(enlace_reciente)) {
      # Convert to absolute URL if needed
      if (!stringr::str_starts(enlace_reciente, "http")) {
        enlace_reciente <- paste0(base_url, enlace_reciente)
      }

      # Return based on return_info parameter
      if (return_info) {
        return(list(
          url = enlace_reciente,
          filename = basename(enlace_reciente),
          file_type = stringr::str_extract(enlace_reciente, file_pattern),
          extraction_date = Sys.Date(),
          source_page = base_url
        ))
      } else {
        return(enlace_reciente)
      }
    } else {
      warning("No recent download link found for the specified criteria")
      return(NULL)
    }

  }, error = function(e) {
    stop(paste("Error accessing the webpage:", e$message))
  })
}



#' Clean and Process Reptile Checklist Data
#'
#' This function processes and cleans raw reptile checklist data by extracting
#' taxonomic information, handling nomenclature changes, and standardizing
#' species and subspecies names with their respective authors and years.
#'
#' @param data A data frame containing the raw reptile checklist data with
#'   columns: type_species, species, author, subspecies, order, family, change, rdb_sp_id
#' @param rename_cols Logical, whether to rename columns to standard names
#'   (default: TRUE)
#'
#' @return A cleaned data frame with the following columns:
#'   \describe{
#'     \item{order}{Taxonomic order (factor)}
#'     \item{family}{Taxonomic family (factor)}
#'     \item{genus}{Genus name (factor)}
#'     \item{epithet}{Species epithet (factor)}
#'     \item{species}{Original species name}
#'     \item{species_author}{Species author name (title case)}
#'     \item{species_name_year}{Year of species description}
#'     \item{subspecies_name}{Subspecies name}
#'     \item{subspecie_author_info}{Raw subspecies author information}
#'     \item{subspecies_name_author}{Subspecies author name (title case)}
#'     \item{subspecies_year}{Year of subspecies description}
#'     \item{change}{Change indicator (factor)}
#'     \item{rdb_sp_id}{Reptile Database species ID}
#'   }
#'
#' @details
#' The function performs the following operations:
#' \enumerate{
#'   \item Renames columns to standard names if requested
#'   \item Handles multiline entries by separating rows on vertical tab characters
#'   \item Removes control characters and extra whitespace
#'   \item Identifies nomenclature changes (names in parentheses)
#'   \item Extracts genus, species epithet, and subspecies names using regex
#'   \item Extracts author names and publication years for both species and subspecies
#'   \item Formats author names to title case
#'   \item Converts appropriate columns to factors for memory efficiency
#' }
#'
#'
#' @keywords internal
clean_reptile_data <- function(data, rename_cols = TRUE) {

  # Validate input
  if (!is.data.frame(data)) {
    stop("Input 'data' must be a data frame")
  }

  # Rename columns if requested
  if (rename_cols) {
    if (ncol(data) != 8) {
      stop("Expected 8 columns in input data for renaming")
    }

    data <- data |>
      purrr::set_names(c("type_species",
                         "species",
                         "author",
                         "subspecies",
                         "order",
                         "family",
                         "change",
                         "rdb_sp_id"))
  }

  # Required columns check
  required_cols <- c("species", "author", "subspecies", "order", "family", "change", "rdb_sp_id")
  missing_cols <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    stop("Missing required columns: ", paste(missing_cols, collapse = ", "))
  }

  # Main data processing pipeline
  processed_data <- data |>
    # Separate multiline entries with safe handling
    tidyr::separate_rows(subspecies, sep = "\v") |>

    # Remove control characters (except \v which was already used)
    dplyr::mutate(
      subspecies = stringr::str_replace_all(subspecies, "[[:cntrl:]]", ""),
      subspecies = stringr::str_squish(subspecies)
    ) |>

    # Flag for nomenclature changes (names in parentheses)
    dplyr::mutate(
      subspecies = as.character(subspecies),
      nomenclature_change = ifelse(stringr::str_detect(subspecies, "\\(.*\\)"), TRUE, FALSE)
    ) |>

    # Clean subspecies text
    dplyr::mutate(
      subspecies = stringr::str_trim(stringr::str_replace_all(subspecies, "\\r", "")),
      subspecies = stringr::str_remove_all(subspecies, "\\(|\\)")
    ) |>

    # Extract components with flexible regex
    tidyr::extract(
      subspecies,
      into = c("genus", "epithet", "subspecies_name", "subspecie_author_info"),
      regex = "([A-Z][a-z]+)\\s+([a-z\\-]+)\\s+([a-z\\-]+)\\s+(.+)",
      remove = FALSE,
      convert = TRUE
    ) |>

    # Handle cases where primary extraction fails
    dplyr::mutate(
      genus = ifelse(is.na(genus),
                     stringr::word(subspecies, 1, 1),
                     genus),
      epithet = ifelse(is.na(epithet),
                       stringr::word(subspecies, 2, 2),
                       epithet),
      subspecies_name = ifelse(is.na(subspecies_name),
                               stringr::word(subspecies, 3, 3),
                               subspecies_name)
    ) |>

    # Clean empty strings
    dplyr::mutate(
      genus = ifelse(nchar(genus) < 1, NA_character_, genus),
      subspecies = ifelse(nchar(subspecies) < 1, NA_character_, subspecies)
    ) |>

    # Fallback to species column for genus and epithet
    dplyr::mutate(
      genus = ifelse(is.na(genus),
                     stringr::word(species, 1, 1),
                     genus),
      epithet = ifelse(is.na(epithet),
                       stringr::word(species, 2, 2),
                       epithet)
    ) |>

    # Extract subspecies year and author
    dplyr::mutate(
      subspecies_year = stringr::str_extract(subspecie_author_info, "[0-9]{4}"),
      subspecies_name_author = stringr::str_trim(
        stringr::str_replace(subspecie_author_info, "[0-9]{4}", "")
      ),
      subspecies_name_author = stringr::str_trim(
        stringr::str_replace_all(subspecies_name_author, "\\s+", " ")
      ),
      subspecies_name_author = stringr::str_to_title(subspecies_name_author)
    ) |>

    # Flag nomenclature changes for species
    dplyr::mutate(
      nomenclature_change_species = ifelse(
        stringr::str_detect(author, "\\(.*\\)"),
        TRUE,
        FALSE
      )
    ) |>

    # Clean author column
    dplyr::mutate(author = stringr::str_remove_all(author, "\\(|\\)")) |>

    # Extract species year and author
    dplyr::mutate(
      species_name_year = stringr::str_extract(author, "[0-9]{4}"),
      species_name_year = dplyr::case_when(
        is.na(species_name_year) & stringr::str_detect(author, "\\([^)]*[0-9]{4}[^)]*\\)") ~
          stringr::str_extract(author, "(?<=\\()[^)]*[0-9]{4}[^)]*(?=\\))"),
        TRUE ~ species_name_year
      ),
      species_name_year = stringr::str_extract(species_name_year, "[0-9]{4}"),
      species_author = stringr::str_remove_all(author, "[0-9]{4}"),
      species_author = stringr::str_remove_all(species_author, "\\(|\\)"),
      species_author = stringr::str_trim(species_author) |>
        stringr::str_to_title()
    ) |>

    # Select and reorganize columns
    dplyr::select(
      order,
      family,
      genus,
      epithet,
      species,
      species_author,
      species_name_year,
      subspecies_name,
      subspecie_author_info,
      subspecies_name_author,
      subspecies_year,
      change,
      rdb_sp_id
    ) |>

    # Convert appropriate columns to factors
    dplyr::mutate(
      dplyr::across(
        .cols = c(order, family, genus, epithet, species_author, change),
        .fns = as.factor
      )
    )

  return(processed_data)
}
