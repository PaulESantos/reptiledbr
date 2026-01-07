# Clean and standardize column names in a data.frame

This function standardizes column names in a data.frame to make them
syntactically valid and consistent. It converts uppercase to lowercase,
removes spaces and special characters, replaces accents, and ensures
names are unique and valid for R. It is an alternative to the
`janitor::clean_names()` function implemented in base R.

## Usage

``` r
clean_names_rdbr(
  df,
  case = c("snake", "lower_camel", "upper_camel", "screaming_snake"),
  replace_special_chars = TRUE,
  unique_names = TRUE
)
```

## Arguments

- df:

  A data.frame or tibble whose column names you want to clean.

- case:

  The case format for the resulting names. Options: `"snake"` (default):
  names_with_underscores `"lower_camel"`: namesWithCamelCase
  `"upper_camel"`: NamesWithCamelCase `"screaming_snake"`:
  NAMES_WITH_UNDERSCORES

- replace_special_chars:

  Logical. If `TRUE` (default), replaces accented and special characters
  with their ASCII equivalents (e.g., "a with accent" becomes "a").

- unique_names:

  Logical. If `TRUE` (default), ensures the resulting names are unique
  by adding numeric suffixes to duplicates.

## Value

A data.frame with the same data as the input but with clean and
standardized column names according to the specified parameters.

## Details

The cleaning process includes:

- Converting everything to lowercase (except in camel or screaming_snake
  formats)

- Replacing accents and common special characters with their ASCII
  equivalents

- Removing parentheses and their content

- Replacing non-alphanumeric characters with underscores

- Removing redundant underscores (leading, trailing, or duplicated)

- Ensuring names don't start with numbers (adding "x" at the beginning)

- Applying the selected case format

- Ensuring names are unique by adding numeric suffixes
