# Extract a specific attribute from reptile species data

**\[experimental\]**

## Usage

``` r
get_attribute(reptile_data, attribute_name)
```

## Arguments

- reptile_data:

  A tibble returned by `get_reptile_species_data()`.

- attribute_name:

  A string indicating the name of the attribute to extract (e.g.,
  "Distribution", "Synonym").

## Value

A tibble with columns `input_name`, `genus`, `species`, and
`attribute_value` containing the extracted values.
