# ==============================================================================
# DATA MANAGEMENT SYSTEM FOR REPTILE DATABASE PACKAGE
# ==============================================================================

#' Download and Setup Reptile Database Data
#'
#' This function downloads the latest reptile database file, sets it up
#' for use within the package, and applies data cleaning procedures.
#' It handles the download, extraction (if needed), cleaning, and storage
#' of the processed data in the package's data directory.
#'
#' @param force_download Logical. If TRUE, forces re-download even if data
#'   already exists. Default is FALSE.
#' @param data_dir Character string. Directory where data should be stored.
#'   Default is the package's extdata directory.
#' @param verbose Logical. If TRUE, prints progress messages. Default is TRUE.
#' @param timeout Numeric. Download timeout in seconds. Default is 300 (5 minutes).
#' @param clean_data Logical. If TRUE, applies data cleaning procedures. Default is TRUE.
#'
#' @return Logical. TRUE if download, setup, and cleaning successful, FALSE otherwise.
#'
#' @details This function:
#' \itemize{
#'   \item Downloads the latest reptile database file
#'   \item Extracts ZIP files if necessary
#'   \item Applies data cleaning using clean_reptile_data()
#'   \item Stores both raw and cleaned data in the package directory
#'   \item Creates metadata about the download and processing
#'   \item Sets up the data for immediate use
#' }
#'
#' @examples
#' \dontrun{
#' # Download and setup data with cleaning
#' setup_reptile_data()
#'
#' # Force re-download with cleaning
#' setup_reptile_data(force_download = TRUE)
#'
#' # Download without cleaning (raw data only)
#' setup_reptile_data(clean_data = FALSE)
#' }
#'
#' @keywords internal
setup_reptile_data <- function(force_download = FALSE,
                               data_dir = NULL,
                               verbose = TRUE,
                               timeout = 300,
                               clean_data = TRUE) {

  # Set default data directory
  if (is.null(data_dir)) {
    # Try to get package name safely
    pkg_name <- tryCatch({
      utils::packageName()
    }, error = function(e) {
      NULL
    })

    if (!is.null(pkg_name) && pkg_name != "") {
      data_dir <- system.file("extdata", package = pkg_name)
    }

    # If package not available or system.file returns empty, use user directory
    if (is.null(data_dir) || data_dir == "") {
      # Use a persistent directory in user's home
      data_dir <- file.path(path.expand("~"), ".reptile_database")
    }
  }

  # Create data directory if it doesn't exist
  if (!dir.exists(data_dir)) {
    dir.create(data_dir, recursive = TRUE)
  }

  # Check if data already exists
  existing_files <- list.files(data_dir, pattern = "\\.(xlsx?|csv|rds)$", full.names = TRUE)
  metadata_file <- file.path(data_dir, "data_metadata.rds")
  cleaned_data_file <- file.path(data_dir, "reptile_data_cleaned.rds")

  if (!force_download && length(existing_files) > 0 && file.exists(metadata_file)) {
    if (verbose) {
      cat("Reptile database data already exists. Use force_download = TRUE to re-download.\n")
    }
    return(TRUE)
  }

  if (verbose) {
    cat("Setting up reptile database data...\n")
  }

  tryCatch({
    # Get the latest download URL
    if (verbose) cat("Finding latest database URL...\n")
    download_url <- get_latest_reptile_download()

    if (is.null(download_url)) {
      stop("Could not find latest database URL")
    }

    if (verbose) cat("Found URL:", download_url, "\n")

    # Set download timeout
    old_timeout <- options("timeout")
    options(timeout = timeout)
    on.exit(options(old_timeout))

    # Download the file
    filename <- basename(download_url)
    local_file <- file.path(data_dir, filename)

    if (verbose) cat("Downloading", filename, "...\n")

    download_result <- download.file(
      url = download_url,
      destfile = local_file,
      mode = "wb",
      quiet = !verbose
    )

    if (download_result != 0) {
      stop("Download failed")
    }

    # Handle ZIP files
    if (tools::file_ext(filename) == "zip") {
      if (verbose) cat("Extracting ZIP file...\n")

      zip_contents <- utils::unzip(local_file, list = TRUE)
      excel_files <- zip_contents$Name[grepl("\\.(xlsx?|csv)$", zip_contents$Name)]

      if (length(excel_files) > 0) {
        utils::unzip(local_file, files = excel_files, exdir = data_dir)
        # Remove the ZIP file after extraction
        file.remove(local_file)
        extracted_file <- file.path(data_dir, excel_files[1])
      } else {
        stop("No Excel or CSV files found in ZIP archive")
      }
    } else {
      extracted_file <- local_file
    }

    # Process and clean the data if requested
    if (clean_data) {
      if (verbose) cat("Loading and cleaning data...\n")

      # Load raw data
      raw_data <- tryCatch({
        if (tools::file_ext(extracted_file) %in% c("xlsx", "xls")) {
          if (!requireNamespace("readxl", quietly = TRUE)) {
            stop("Package 'readxl' is required to read Excel files. Please install it.")
          }
          readxl::read_excel(extracted_file) |>
            janitor::clean_names()
        } else if (tools::file_ext(extracted_file) == "csv") {
          utils::read.csv(extracted_file) |>
            janitor::clean_names()
        } else {
          stop("Unsupported file format for cleaning: ", tools::file_ext(extracted_file))
        }
      }, error = function(e) {
        if (verbose) cat("Warning: Could not load raw data for cleaning:", e$message, "\n")
        NULL
      })

      # Clean the data if successfully loaded
      if (!is.null(raw_data)) {
        if (verbose) cat("Applying data cleaning procedures...\n")

        cleaned_data <- tryCatch({
          clean_reptile_data(raw_data, rename_cols = TRUE)
        }, error = function(e) {
          if (verbose) cat("Warning: Data cleaning failed:", e$message, "\n")
          NULL
        })

        # Save cleaned data
        if (!is.null(cleaned_data)) {
          saveRDS(cleaned_data, cleaned_data_file)
          if (verbose) cat("Cleaned data saved successfully.\n")
        }
      }
    }

    # Create metadata
    metadata <- list(
      download_date = Sys.Date(),
      download_url = download_url,
      filename = basename(extracted_file),
      file_size = file.info(extracted_file)$size,
      cleaned_data_available = clean_data && file.exists(cleaned_data_file),
      cleaning_date = if (clean_data && file.exists(cleaned_data_file)) Sys.Date() else NULL,
      r_version = R.version.string,
      system_info = Sys.info()["sysname"]
    )

    saveRDS(metadata, metadata_file)

    if (verbose) {
      cat("Data setup completed successfully!\n")
      cat("Raw file:", basename(extracted_file), "\n")
      cat("Size:", round(metadata$file_size / 1024^2, 2), "MB\n")
      if (metadata$cleaned_data_available) {
        cat("Cleaned data: Available\n")
      }
    }

    return(TRUE)

  }, error = function(e) {
    if (verbose) {
      cat("Error setting up data:", e$message, "\n")
    }
    return(FALSE)
  })
}
setup_reptile_data()
#' Get Path to Reptile Database Data File
#'
#' Returns the path to the local reptile database data file. Can return either
#' the raw data file or the cleaned data file. If the data hasn't been
#' downloaded yet, prompts the user to run setup_reptile_data().
#'
#' @param data_dir Character string. Directory where data is stored.
#'   Default is the package's extdata directory.
#' @param prefer_cleaned Logical. If TRUE, returns path to cleaned data file
#'   when available. Default is TRUE.
#'
#' @return Character string with the path to the data file, or NULL if not found.
#' @keywords internal

get_reptile_data_path <- function(data_dir = NULL, prefer_cleaned = TRUE) {

  # Set default data directory
  if (is.null(data_dir)) {
    # Try to get package name safely
    pkg_name <- tryCatch({
      utils::packageName()
    }, error = function(e) {
      NULL
    })

    if (!is.null(pkg_name) && pkg_name != "") {
      data_dir <- system.file("extdata", package = pkg_name)
    }

    # If package not available, use user directory
    if (is.null(data_dir) || data_dir == "") {
      data_dir <- file.path(path.expand("~"), ".reptile_database")
    }
  }

  # Check for cleaned data first if preferred
  if (prefer_cleaned) {
    cleaned_file <- file.path(data_dir, "reptile_data_cleaned.rds")
    if (file.exists(cleaned_file)) {
      return(cleaned_file)
    }
  }

  # Look for raw data files
  data_files <- list.files(data_dir, pattern = "\\.(xlsx?|csv)$", full.names = TRUE)

  if (length(data_files) == 0) {
    message("Reptile database data not found. Please run setup_reptile_data() first.")
    return(NULL)
  }

  # Return the most recent file
  file_info <- file.info(data_files)
  most_recent <- data_files[which.max(file_info$mtime)]

  return(most_recent)
}

#' Load Reptile Database Data
#'
#' Loads the reptile database data into R. Automatically detects whether to
#' load cleaned or raw data, and uses appropriate reading function. If data
#' hasn't been downloaded, prompts user to run setup function.
#'
#' @param data_dir Character string. Directory where data is stored.
#' @param prefer_cleaned Logical. If TRUE, loads cleaned data when available.
#'   Default is TRUE.
#' @param sheet Character string or numeric. For Excel files, which sheet to read.
#'   Default is 1 (first sheet). Only used for raw data.
#' @param ... Additional arguments passed to the reading function (for raw data only).
#'
#' @return A data frame with the reptile database data, or NULL if data not available.
#'
#' @keywords internal
#'
load_reptile_data <- function(data_dir = NULL, prefer_cleaned = TRUE, sheet = 1, ...) {

  # Get data file path
  data_path <- get_reptile_data_path(data_dir, prefer_cleaned = prefer_cleaned)

  if (is.null(data_path)) {
    return(NULL)
  }

  # Determine file type and read accordingly
  file_ext <- tools::file_ext(data_path)

  tryCatch({
    if (file_ext == "rds") {
      # This is cleaned data
      data <- readRDS(data_path)
    } else if (file_ext %in% c("xlsx", "xls")) {
      if (!requireNamespace("readxl", quietly = TRUE)) {
        stop("Package 'readxl' is required to read Excel files. Please install it.")
      }
      data <- readxl::read_excel(data_path, sheet = sheet, ...)

      # Apply cleaning if this is raw data and cleaning is available
      if (prefer_cleaned) {
        message("Loading raw data. Consider running setup_reptile_data() to generate cleaned data.")
      }
    } else if (file_ext == "csv") {
      data <- utils::read.csv(data_path, ...)

      # Apply cleaning if this is raw data and cleaning is available
      if (prefer_cleaned) {
        message("Loading raw data. Consider running setup_reptile_data() to generate cleaned data.")
      }
    } else {
      stop("Unsupported file format: ", file_ext)
    }

    return(data)

  }, error = function(e) {
    message("Error loading data: ", e$message)
    return(NULL)
  })
}

#' Load Cleaned Reptile Database Data
#'
#' Specifically loads the cleaned reptile database data. This is a convenience
#' function that ensures you get the processed, cleaned version of the data.
#'
#' @param data_dir Character string. Directory where data is stored.
#' @param auto_setup Logical. If TRUE and cleaned data is not available,
#'   automatically runs setup_reptile_data(). Default is FALSE.
#'
#' @return A cleaned data frame with the reptile database data, or NULL if not available.
#'
#' @keywords internal
load_cleaned_reptile_data <- function(data_dir = NULL, auto_setup = FALSE) {

  # Set default data directory
  if (is.null(data_dir)) {
    # Try to get package name safely
    pkg_name <- tryCatch({
      utils::packageName()
    }, error = function(e) {
      NULL
    })

    if (!is.null(pkg_name) && pkg_name != "") {
      data_dir <- system.file("extdata", package = pkg_name)
    }

    # If package not available, use user directory
    if (is.null(data_dir) || data_dir == "") {
      data_dir <- file.path(path.expand("~"), ".reptile_database")
    }
  }

  cleaned_file <- file.path(data_dir, "reptile_data_cleaned.rds")

  if (!file.exists(cleaned_file)) {
    if (auto_setup) {
      message("Cleaned data not found. Setting up data...")
      success <- setup_reptile_data(data_dir = data_dir, clean_data = TRUE)
      if (!success) {
        message("Failed to setup data.")
        return(NULL)
      }
    } else {
      message("Cleaned reptile data not found. Please run setup_reptile_data() first.")
      return(NULL)
    }
  }

  tryCatch({
    data <- readRDS(cleaned_file)
    return(data)
  }, error = function(e) {
    message("Error loading cleaned data: ", e$message)
    return(NULL)
  })
}

#' Check Reptile Database Data Status
#'
#' Provides information about the current status of the reptile database data,
#' including whether it's downloaded, file details, cleaning status, metadata,
#' and checks if the data is up-to-date by comparing with web availability.
#'
#' @param data_dir Character string. Directory where data is stored.
#' @param check_updates Logical. Whether to check for updates online. Default is TRUE.
#'
#' @return A list with information about the data status, including update status.
#'
#' @keywords internal

check_reptile_data_status <- function(data_dir = NULL,
                                      check_updates = TRUE) {

  # Set default data directory
  if (is.null(data_dir)) {
    # Try to get package name safely
    pkg_name <- tryCatch({
      utils::packageName()
    }, error = function(e) {
      NULL
    })
    if (!is.null(pkg_name) && pkg_name != "") {
      data_dir <- system.file("extdata", package = pkg_name)
    }
    # If package not available, use user directory
    if (is.null(data_dir) || data_dir == "") {
      data_dir <- file.path(path.expand("~"), ".reptile_database")
    }
  }

  # Initialize status
  status <- list(
    data_available = FALSE,
    cleaned_data_available = FALSE,
    data_directory = data_dir,
    raw_data_files = character(0),
    cleaned_data_file = NULL,
    metadata = NULL,
    internet_available = FALSE,
    update_check_performed = FALSE,
    is_up_to_date = NULL,
    latest_web_info = NULL,
    update_recommendation = NULL,
    last_check_date = Sys.Date()
  )

  # Check for raw data files
  raw_files <- list.files(data_dir, pattern = "\\.(xlsx?|csv)$", full.names = TRUE)
  status$raw_data_files <- basename(raw_files)
  status$data_available <- length(raw_files) > 0

  # Check for cleaned data
  cleaned_file <- file.path(data_dir, "reptile_data_cleaned.rds")
  if (file.exists(cleaned_file)) {
    status$cleaned_data_available <- TRUE
    status$cleaned_data_file <- "reptile_data_cleaned.rds"
  }

  # Read metadata if available
  metadata_file <- file.path(data_dir, "data_metadata.rds")
  if (file.exists(metadata_file)) {
    status$metadata <- readRDS(metadata_file)
  }

  # Check for updates if requested
  if (check_updates) {
    # Check internet connection
    status$internet_available <- check_internet_connection()

    if (status$internet_available) {
      tryCatch({
        # Get latest web information using the existing function
        web_info <- get_latest_reptile_download(return_info = TRUE)
        status$latest_web_info <- web_info
        status$update_check_performed <- TRUE

        if (!is.null(web_info) && !is.null(status$metadata)) {
          # Compare local metadata with web information
          comparison_result <- compare_data_versions(status$metadata, web_info)
          status$is_up_to_date <- comparison_result$is_up_to_date
          status$update_recommendation <- comparison_result$recommendation

        } else if (!is.null(web_info) && is.null(status$metadata)) {
          # No local metadata but web data available
          status$is_up_to_date <- FALSE
          status$update_recommendation <- "Local metadata not found. Consider downloading fresh data."

        } else if (is.null(web_info)) {
          # Could not retrieve web information
          status$update_recommendation <- "Could not retrieve web information for comparison."
        }

      }, error = function(e) {
        status$update_recommendation <- paste("Error checking for updates:", e$message)
      })
    } else {
      status$update_recommendation <- "No internet connection available. Cannot check for updates."
    }
  }

  return(status)
}

#' Check Internet Connection
#'
#' Helper function to check if internet connection is available
#'
#' @return Logical. TRUE if internet is available, FALSE otherwise.
#'
#' @keywords internal

check_internet_connection <- function() {
  tryCatch(class(httr::GET("http://www.google.com/")) == "response",
           error = function(e) {
             return(FALSE)
           }
  )
}

#' Compare Data Versions
#'
#' Helper function to compare local metadata with web information
#'
#' @param local_metadata List. Local metadata information.
#' @param web_info List. Web information from get_latest_reptile_download.
#'
#' @return List with comparison results.
#'
#' @keywords internal

compare_data_versions <- function(local_metadata, web_info) {

  result <- list(
    is_up_to_date = NULL,
    recommendation = NULL,
    comparison_details = list()
  )

  # Extract comparison elements
  local_filename <- local_metadata$filename %||% local_metadata$source_file
  web_filename <- web_info$filename

  local_date <- local_metadata$download_date %||% local_metadata$extraction_date
  web_date <- web_info$extraction_date

  # Store comparison details
  result$comparison_details <- list(
    local_filename = local_filename,
    web_filename = web_filename,
    local_date = local_date,
    web_date = web_date
  )

  # Compare filenames first
  if (!is.null(local_filename) && !is.null(web_filename)) {
    if (local_filename == web_filename) {
      result$is_up_to_date <- TRUE
      result$recommendation <- "Data appears to be up-to-date (same filename)."
    } else {
      # Check if it's just a different format of the same data
      local_base <- tools::file_path_sans_ext(local_filename)
      web_base <- tools::file_path_sans_ext(web_filename)

      # Extract year patterns
      local_year <- stringr::str_extract(local_base, "\\d{4}")
      web_year <- stringr::str_extract(web_base, "\\d{4}")

      if (!is.na(local_year) && !is.na(web_year)) {
        if (local_year == web_year) {
          result$is_up_to_date <- TRUE
          result$recommendation <- "Data appears current (same year), but different format."
        } else if (as.numeric(web_year) > as.numeric(local_year)) {
          result$is_up_to_date <- FALSE
          result$recommendation <- paste("Newer data available. Local:", local_year,
                                         "vs Web:", web_year)
        } else {
          result$is_up_to_date <- TRUE
          result$recommendation <- "Local data appears newer or current."
        }
      } else {
        result$is_up_to_date <- FALSE
        result$recommendation <- "Different filenames detected. Consider updating."
      }
    }
  }

  # Additional date comparison if available
  if (!is.null(local_date) && !is.null(web_date)) {
    if (is.character(local_date)) local_date <- as.Date(local_date)
    if (is.character(web_date)) web_date <- as.Date(web_date)

    date_diff <- as.numeric(web_date - local_date)

    if (date_diff > 30) {  # More than 30 days difference
      result$is_up_to_date <- FALSE
      result$recommendation <- paste(result$recommendation,
                                     "Local data is more than 30 days old.")
    }
  }

  # Default case
  if (is.null(result$is_up_to_date)) {
    result$is_up_to_date <- FALSE
    result$recommendation <- "Unable to determine update status. Consider refreshing data."
  }

  return(result)
}

#' Print Status Summary
#'
#' Helper function to print a formatted summary of the data status
#'
#' @param status List. Output from check_reptile_data_status.
#'
#' @return None. Prints formatted output.
#'
#' @export

print_reptile_status <- function(status) {
  cat("=== Reptile Database Status ===\n")
  cat("Data Directory:", status$data_directory, "\n")
  cat("Raw Data Available:", ifelse(status$data_available, "Yes", "No"), "\n")

  if (status$data_available) {
    cat("Raw Files:", paste(status$raw_data_files, collapse = ", "), "\n")
  }

  cat("Cleaned Data Available:", ifelse(status$cleaned_data_available, "Yes", "No"), "\n")

  if (status$update_check_performed) {
    cat("\n=== Update Status ===\n")
    cat("Internet Available:", ifelse(status$internet_available, "Yes", "No"), "\n")

    if (!is.null(status$is_up_to_date)) {
      cat("Data Up-to-Date:", ifelse(status$is_up_to_date, "Yes", "No"), "\n")
    }

    if (!is.null(status$update_recommendation)) {
      cat("Recommendation:", status$update_recommendation, "\n")
    }

    if (!is.null(status$latest_web_info)) {
      cat("Latest Web File:", status$latest_web_info$filename, "\n")
    }
  }

  cat("Last Check:", as.character(status$last_check_date), "\n")
}

# Null-coalescing operator helper
`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0 || (is.character(x) && x == "")) y else x
}


# ==============================================================================
# PACKAGE INITIALIZATION FUNCTIONS
# ==============================================================================

#' Initialize Reptile Database Package
#'
#' This function is typically called when the package is loaded. It checks
#' if data is available and offers to download it if not. Also ensures
#' cleaned data is available.
#'
#' @param auto_download Logical. If TRUE, automatically downloads data if not present.
#'   If FALSE, only shows a message. Default is FALSE.
#' @param verbose Logical. If TRUE, shows informative messages. Default is TRUE.
#' @param ensure_cleaned Logical. If TRUE, ensures cleaned data is available.
#'   Default is TRUE.
#'
#' @return Logical. TRUE if data is available (either already present or successfully downloaded).
#'
#' @keywords internal
initialize_reptile_package <- function(auto_download = FALSE, verbose = TRUE, ensure_cleaned = TRUE) {

  status <- check_reptile_data_status()

  if (!status$data_available) {
    if (auto_download) {
      if (verbose) {
        cat("Reptile database data not found. Downloading and setting up...\n")
      }
      return(setup_reptile_data(verbose = verbose, clean_data = ensure_cleaned))
    } else {
      if (verbose) {
        message("Welcome to the Reptile Database package!\n",
                "To get started, please run: setup_reptile_data()\n",
                "This will download the latest reptile species data and prepare it for use.")
      }
      return(FALSE)
    }
  } else {
    # Data is available, check if we need to ensure cleaned data
    if (ensure_cleaned && !status$cleaned_data_available) {
      if (auto_download) {
        if (verbose) {
          cat("Raw data found but cleaned data missing. Processing...\n")
        }
        return(setup_reptile_data(force_download = FALSE, verbose = verbose, clean_data = TRUE))
      } else {
        if (verbose) {
          message("Raw reptile database data available. ",
                  "Run setup_reptile_data() to generate cleaned data for better performance.")
        }
      }
    }

    if (verbose && !is.null(status$metadata)) {
      data_info <- paste("Data from:", status$metadata$download_date)
      if (status$cleaned_data_available) {
        data_info <- paste(data_info, "(cleaned data available)")
      }
      message("Reptile database loaded. ", data_info)
    }
    return(TRUE)
  }
}
