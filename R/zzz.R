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
  "subspecies_name", "subspecies_name_author", "subspecies_year"
))

# ---------------------------------------------------------------
.pkgenv <- new.env(parent = emptyenv())

.onAttach <- function(lib, pkg) {
  packageStartupMessage(
    paste0(
      "Welcome to reptiledbr (", utils::packageDescription("reptiledbr", fields = "Version"), ")\n",
      "This package provides tools to access and query data from the Reptile Database:\n",
      "  https://reptile-database.reptarium.cz/\n",
      "Type ?reptiledbr to get started or visit the documentation for examples and guidance."
    )
  )
}
