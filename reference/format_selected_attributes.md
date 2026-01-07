# Format selected reptile attributes

**\[experimental\]**

## Usage

``` r
format_selected_attributes(reptile_data, attributes, quiet = FALSE)
```

## Arguments

- reptile_data:

  A data frame obtained using the `get_reptile_species_data()` function.

- attributes:

  A character vector specifying which attributes to extract.

- quiet:

  Logical. If TRUE, suppresses informational messages. Default is FALSE.

## Value

A list containing the selected formatted attributes.

## Details

Extracts and formats only the specified attributes from the reptile
dataset.
