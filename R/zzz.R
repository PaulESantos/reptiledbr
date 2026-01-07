utils::globalVariables(c(
  ".", "V1", "V2", "attribute", "attribute_value", "comment_detail",
  "comments_info", "common_name", "common_names_list", "data diagnosis_detail",
  "diagnosis_info", "distribution", "distribution_list", "etymology_detail",
  "etymology_info", "format_external_links", "formatted_data", "genus",
  "input_name", "reference", "references_list", "reproduction_detail",
  "reproduction_info", "species", "status", "subspecies",  "subspecies_list",
  "synonym", "synonym_list", "taxa_list", "taxon", "type_detail", "types_info", "value",
  "data", "diagnosis_detail", "x1", "x2", "author", "ephitetho", "epithet",
  "family", "fuzzy_match", "species_author", "species_match",
  "species_name_year", "has_subspecies",  "id", "original_order", "query",
  "subspecies_name", "subspecies_name_author", "subspecies_year",
  "change", "download.file", "rdb_sp_id", "subspecie_author_info",
  "clean_namesedbr"
))

# ---------------------------------------------------------------
# # Environment for package-level variables
# .pkgenv <- new.env(parent = emptyenv())
#
# #' @keywords internal
# .onAttach <- function(libname, pkgname) {
#   # Display welcome message
#   packageStartupMessage(
#     sprintf(
#       "Welcome to reptiledbr (%s)\n%s\n%s\n%s",
#       utils::packageDescription("reptiledbr", fields = "Version"),
#       "This package provides tools to access and query data from the Reptile Database:",
#       "  https://reptile-database.reptarium.cz/",
#       "Type ?reptiledbr to get started or visit the documentation for examples and guidance."
#     )
#   )
#
#   # Check if reptiledb.data is available
#   if (!requireNamespace("reptiledb.data", quietly = TRUE)) {
#     packageStartupMessage(
#       paste0(
#         "\nNOTE: The 'reptiledb.data' package is **recommended** for full functionality.\n",
#         "It provides the necessary data for the following functions:\n",
#         "  - `reptiledbr_exact()`\n",
#         "  - `reptiledbr_partial()`\n",
#         "  - `search_reptiledbr()`\n",
#         "  - `list_subspecies_reptiledbr()`\n\n",
#         "To install 'reptiledb.data', please use: pak::pak('PaulESantos/reptiledb.data')\n",
#         "Alternatively, if you prefer not to use pak: remotes::install_github('PaulESantos/reptiledb.data')"
#       )
#     )
#   }
# }
#
# #' @keywords internal
# .onLoad <- function(libname, pkgname) {
#   # Silent initialization when the package is loaded
#   invisible()
# }
#
# #' Check if data package is required and available
# #' @keywords internal
# check_data_required <- function() {
#   if (!requireNamespace("reptiledb.data", quietly = TRUE)) {
#     stop(
#       "This function requires the 'reptiledb.data' package to be installed.\n",
#       "Please install it using: pak::pak('PaulESantos/reptiledb.data')\n",
#       "Alternatively: remotes::install_github('PaulESantos/reptiledb.data')",
#       call. = FALSE
#     )
#   }
# }
#=====================================================================
# Environment for package-level variables
# Environment for package-level variables
.pkgenv <- new.env(parent = emptyenv())

#' @keywords internal
.onAttach <- function(libname, pkgname) {
  # Get package version
  pkg_version <- utils::packageDescription("reptiledbr", fields = "Version")

  # Check if reptiledb.data is available
  data_pkg_available <- requireNamespace("reptiledb.data", quietly = TRUE)

  # Build startup message
  startup_msg <- build_startup_message(pkg_version, data_pkg_available)

  # Display message
  packageStartupMessage(startup_msg)
}

#' Build formatted startup message
#' @keywords internal
build_startup_message <- function(pkg_version, data_pkg_available) {
  # Header - simplified to avoid cli::rule issues
  header <- paste0(
    cli::style_bold(
      paste0(cli::symbol$line, cli::symbol$line, " reptiledbr ", pkg_version, " ")
    ),
    paste0(rep(cli::symbol$line, 30), collapse = "")
  )

  # Core information
  core_info <- paste0(
    cli::symbol$pointer, " Reptile Database: ",
    cli::col_cyan("https://reptile-database.reptarium.cz/")
  )

  # Data package status
  if (data_pkg_available) {
    # Check update status
    update_status <- check_update_status_silent()

    if (!is.null(update_status)) {
      if (update_status$status == "current") {
        data_status <- paste0(
          cli::col_green(cli::symbol$tick), " ",
          "reptiledb.data ",
          format(update_status$local_date, "%B %Y"),
          " (up to date)"
        )
      } else if (update_status$status == "outdated") {
        data_status <- paste0(
          cli::col_yellow(cli::symbol$warning), " ",
          "reptiledb.data ",
          format(update_status$local_date, "%B %Y"),
          " (update available: ",
          format(update_status$remote_date, "%B %Y"),
          ")"
        )
      } else {
        data_status <- paste0(
          cli::col_green(cli::symbol$tick), " ",
          "reptiledb.data installed"
        )
      }
    } else {
      data_status <- paste0(
        cli::col_green(cli::symbol$tick), " ",
        "reptiledb.data installed"
      )
    }
  } else {
    data_status <- paste0(
      cli::col_red(cli::symbol$cross), " ",
      "reptiledb.data not installed"
    )
  }

  # Build complete message
  msg <- paste0(
    header, "\n",
    core_info, "\n",
    data_status, "\n"
  )

  # Add installation instructions if needed
  if (!data_pkg_available) {
    install_msg <- paste0(
      "\n",
      cli::col_silver("Install reptiledb.data for full functionality:"), "\n",
      cli::col_silver("  pak::pak('PaulESantos/reptiledb.data')")
    )
    msg <- paste0(msg, install_msg, "\n")
  } else if (!is.null(update_status) && update_status$status == "outdated") {
    update_msg <- paste0(
      "\n",
      cli::col_silver("Download latest version:"), "\n",
      cli::col_silver("  "),
      cli::col_cyan(update_status$download_url)
    )
    msg <- paste0(msg, update_msg, "\n")
  }

  # Add help tip
  help_tip <- paste0(
    "\n",
    cli::col_silver("Type ?reptiledbr to get started")
  )
  msg <- paste0(msg, help_tip)

  return(msg)
}

#' Check update status silently (for startup message)
#' @keywords internal
check_update_status_silent <- function() {
  if (!requireNamespace("reptiledb.data", quietly = TRUE)) {
    return(NULL)
  }

  if (!exists("check_data_update",
              where = asNamespace("reptiledb.data"),
              mode = "function")) {
    return(NULL)
  }

  tryCatch({
    reptiledb.data::check_data_update(silent = TRUE, check_connection = TRUE)
  }, error = function(e) {
    NULL
  })
}

#' @keywords internal
.onLoad <- function(libname, pkgname) {
  # Silent initialization when the package is loaded
  invisible()
}

#' Check if data package is required and available
#' @keywords internal
check_data_required <- function() {
  if (!requireNamespace("reptiledb.data", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "This function requires the {.pkg reptiledb.data} package",
      "i" = "Install it with: {.code pak::pak('PaulESantos/reptiledb.data')}",
      "i" = "Or use: {.code remotes::install_github('PaulESantos/reptiledb.data')}"
    ))
  }
}

#' Manually check for reptiledb.data updates
#'
#' @description
#' This function checks if there's a newer version of the reptiledb.data
#' package available. It's automatically called when reptiledbr loads, but
#' can also be called manually by users.
#'
#' @param silent Logical. If TRUE, suppresses messages and returns only the
#'   result object. Default is FALSE.
#'
#' @return Invisibly returns the update check result object from
#'   reptiledb.data::check_data_update(), or NULL if the package is not installed.
#'
#' @examples
#' \donttest{
#' # Check for updates with user-friendly messages
#' check_reptiledb_update()
#'
#' # Silent check for programmatic use
#' result <- check_reptiledb_update(silent = TRUE)
#' if (!is.null(result) && result$needs_update) {
#'   message("Update available!")
#' }
#' }
#'
#' @export
check_reptiledb_update <- function(silent = FALSE) {
  # Check if reptiledb.data is installed
  if (!requireNamespace("reptiledb.data", quietly = TRUE)) {
    if (!silent) {
      cli::cli_alert_warning("{.pkg reptiledb.data} is not installed")
      cli::cli_text("")
      cli::cli_text("Install it with:")
      cli::cli_code("pak::pak('PaulESantos/reptiledb.data')")
    }
    return(invisible(NULL))
  }

  # Check if the function exists
  if (!exists("check_data_update",
              where = asNamespace("reptiledb.data"),
              mode = "function")) {
    if (!silent) {
      cli::cli_alert_warning(
        "Your version of {.pkg reptiledb.data} does not support update checking"
      )
      cli::cli_text("Please update the package to get this feature")
    }
    return(invisible(NULL))
  }

  # Call the check function
  result <- tryCatch({
    reptiledb.data::check_data_update(silent = silent, check_connection = TRUE)
  }, error = function(e) {
    if (!silent) {
      cli::cli_alert_danger("Error checking for updates")
      cli::cli_text("{.emph {e$message}}")
    }
    NULL
  })

  return(invisible(result))
}
