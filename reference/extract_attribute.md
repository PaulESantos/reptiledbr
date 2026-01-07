# Extract and optionally format a specific attribute

**\[experimental\]**

## Usage

``` r
extract_attribute(reptile_data, attribute_name, format_function = NULL)
```

## Arguments

- reptile_data:

  A data frame obtained using the `get_reptile_species_data()` function.

- attribute_name:

  Name of the attribute to extract (e.g., "Distribution", "Synonym").

- format_function:

  Optional formatting function for custom processing.

## Value

A tibble with formatted information for the specified attribute.

## Details

Extracts and optionally formats structured information for a given
attribute.
