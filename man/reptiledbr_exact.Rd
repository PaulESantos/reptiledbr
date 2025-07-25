% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/search_reptiledbr.R
\name{reptiledbr_exact}
\alias{reptiledbr_exact}
\title{Search Reptile Species by Exact Match and Subspecies Presence}
\usage{
reptiledbr_exact(species_names)
}
\arguments{
\item{species_names}{Character vector of full species names to search for.}
}
\value{
A tibble with taxonomic information and a message indicating subspecies presence.

The response variable may return different messages depending on the outcome of the query.
Possible values include:
\itemize{
\item \code{"Species not found"} – The specified species could not be matched in the database.
\item \code{"Species has subspecies"} – The specified species exists and has one or more subspecies registered.
\item \code{"No subspecies found"} – The species was found, but there are no subspecies associated with it in the database.
}
}
\description{
This function searches for exact matches of scientific species names and indicates
whether each matched species has associated subspecies in the dataset.
}
\examples{
\dontrun{
# These examples require the 'reptiledb.data' package to be installed.
# You can install it from its source if not on CRAN.
reptiledbr_exact(c("Ablepharus alaicus", "Anolis limon"))
}
}
