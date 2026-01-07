# Fuzzy Search for Species Names Using Approximate Matching

This function performs approximate (fuzzy) matching of species names
from a given list of input terms against the species names in the
reptile database, and indicates whether each matched species has
subspecies.

## Usage

``` r
reptiledbr_partial(species_names, max_dist = 2)
```

## Arguments

- species_names:

  Character vector. One or more scientific names or fragments to match
  approximately.

- max_dist:

  Maximum string distance allowed for a match (default: 2).

## Value

A tibble with matched species, taxonomic info, fuzzy match flag, and
subspecies presence. The response variable may return different messages
depending on the outcome of the query. Possible values include:

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
reptiledbr_partial(c("Ablepharus alaicuss", "Anolis limom"))
} # }
```
