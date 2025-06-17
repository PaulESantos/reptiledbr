#' Reptile Checklist with Subspecies Information
#'
#' A comprehensive dataset extracted from [The Reptile Database](http://www.reptile-database.org/)
#' containing taxonomic and nomenclatural information for reptile species and their subspecies.
#' This tibble includes detailed columns related to authorship, type species, and taxonomic changes.
#'
#' @format A tibble with 14,474 rows and 16 columns:
#' \describe{
#'   \item{order}{Taxonomic order of the reptile (e.g., \code{"Sauria"}).}
#'   \item{family}{Taxonomic family (e.g., \code{"Scincidae"}).}
#'   \item{genus}{Genus name.}
#'   \item{epithet}{Species epithet (second part of the species name).}
#'   \item{species}{Full species name (genus + epithet).}
#'   \item{species_author}{Primary author(s) of the species name.}
#'   \item{species_name_year}{Year the species was described.}
#'   \item{subspecies_name}{Epithet of the subspecies (if any).}
#'   \item{subspecie_author_info}{Full author citation of the subspecies.}
#'   \item{subspecies_name_author}{Author(s) of the subspecies name.}
#'   \item{subspecies_year}{Year the subspecies was described.}
#'   \item{type_species}{Name of the type species, if available.}
#'   \item{change}{Text description of any taxonomic or nomenclatural change.}
#'   \item{rdb_sp_id}{Unique identifier assigned by The Reptile Database.}
#'   \item{nomenclature_change}{Logical flag indicating if a nomenclatural change has occurred (\code{TRUE} / \code{FALSE}).}
#'   \item{nomenclature_change_species}{Logical flag indicating if the nomenclatural change affects the species level (\code{TRUE} / \code{FALSE}).}
#' }
#'
#' @details
#' This dataset is part of the `reptiledbr` package and provides structured access to reptile
#' taxonomy data, enabling users to filter, analyze, or visualize species and subspecies information
#' across multiple reptile families and genera.
#'
#' @source \url{http://www.reptile-database.org/}
#' @seealso \code{\link{reptiledbr}}
#'
"reptiledb_012025"
