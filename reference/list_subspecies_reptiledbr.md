# List Subspecies from ReptileDB

This function processes results from a ReptileDB database search to
extract subspecies information. It identifies species that have
subspecies and returns a tibble with the species name, subspecies name,
and author information.

## Usage

``` r
list_subspecies_reptiledbr(df)
```

## Arguments

- df:

  A dataframe or tibble result from using reptiledbr_exact,
  reptiledbr_partial or search_reptiledbr functions.

## Value

A tibble with three columns:

- species:

  The name of the species

- subspecies_name:

  The full name of the subspecies

- author:

  The author and year of the subspecies description

## Examples

``` r
if (FALSE) { # \dontrun{
# These examples require the 'reptiledb.data' package to be installed.
subspecies_names <- c("Lachesis muta",
  "Anilius scytale",
  "Anolis bahorucoensis")

search_reptiledbr(subspecies_names, use_fuzzy = FALSE) |>
  list_subspecies_reptiledbr()
} # }
```
