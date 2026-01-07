# Comprehensive Search for Reptile Species with Exact and Fuzzy Matching

This function combines both exact and fuzzy matching approaches to
search for reptile species names in the database. It first attempts
exact matches and then uses fuzzy matching for any species names that
weren't found exactly.

## Usage

``` r
search_reptiledbr(species_names, max_dist = 2, use_fuzzy = TRUE)
```

## Arguments

- species_names:

  Character vector of scientific species names to search for.

- max_dist:

  Maximum string distance allowed for fuzzy matching (default: 2).

- use_fuzzy:

  Logical. If TRUE, performs fuzzy search for species not found exactly.
  If FALSE, only does exact matching (default: TRUE).

## Value

A combined tibble with results from both exact and fuzzy matching
approaches, with a flag indicating the match type. Results maintain the
original order of species_names. The response variable may return
different messages depending on the outcome of the query. Possible
values include:

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
search_reptiledbr(c("Ablepharus alaicus", "Anolis limom"))
} # }
```
