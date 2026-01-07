# Search Reptile Species by Exact Match and Subspecies Presence

This function searches for exact matches of scientific species names and
indicates whether each matched species has associated subspecies in the
dataset.

## Usage

``` r
reptiledbr_exact(species_names)
```

## Arguments

- species_names:

  Character vector of full species names to search for.

## Value

A tibble with taxonomic information and a message indicating subspecies
presence.

The response variable may return different messages depending on the
outcome of the query. Possible values include:

- `"Species not found"` – The specified species could not be matched in
  the database.

- `"Species has subspecies"` – The specified species exists and has one
  or more subspecies registered.

- `"No subspecies found"` – The species was found, but there are no
  subspecies associated with it in the database.

## Examples

``` r
if (FALSE) { # \dontrun{
# These examples require the 'reptiledb.data' package to be installed.
# You can install it from its source if not on CRAN.
reptiledbr_exact(c("Ablepharus alaicus", "Anolis limon"))
} # }
```
