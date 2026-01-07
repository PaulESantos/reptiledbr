# Access Reptile Database Taxonomic Information **\[experimental\]**

Retrieves taxonomic information on living reptile species from [The
Reptile Database](https://reptile-database.reptarium.cz/). This function
allows users to explore scientific names, synonyms, distributions, and
taxonomic references for all known species of snakes, lizards, turtles,
amphisbaenians, tuataras, and crocodiles.

## Usage

``` r
get_reptiledb_data(species_names, timeout = 10, quiet = FALSE)
```

## Source

Uetz, P., Freed, P., & Hosek, J. (eds.) (2021). The Reptile Database.
Available at: <https://reptile-database.reptarium.cz>

For more on phylogenetic background see: Zheng, Y., & Wiens, J. J.
(2016). Combining phylogenomics and fossils in higher-level squamate
reptile phylogeny. *BMC Evolutionary Biology*, 16, 1-20.

## Arguments

- species_names:

  A character string with the scientific name of the species (e.g.,
  "Crocodylus acutus").

- timeout:

  Maximum waiting time for each request (in seconds)

- quiet:

  Logical value TRUE or FALSE.

## Value

A list or data frame containing available taxonomic information (e.g.,
accepted name, synonyms, family, distribution, literature references).

## Details

The Reptile Database currently includes more than 10,000 species and
around 2,800 subspecies. It focuses on taxonomic and nomenclatural data,
including valid names, synonyms, type localities, distribution, and
original references. However, ecological and behavioral data are largely
absent.

Data are compiled from peer-reviewed literature, expert contributions,
and curated by an editorial team. Updates and corrections from users are
welcome and help improve the resource.

The classification follows recent phylogenetic studies (e.g., Zheng &
Wiens, 2016), although the database takes a conservative approach to
rapidly changing taxonomic hypotheses. New genera or species proposals
may first appear in the "synonyms" field pending wider scientific
acceptance.

Note: The database does not support species identification by traits,
but users can search by geographical distribution and higher taxonomic
groups.

## See also

<https://reptile-database.reptarium.cz>

## Author

Data curated by P. Uetz and collaborators. Function implementation by
Paul E. Santos Andrade.

## Examples

``` r
get_reptiledb_data("Anolis carolinensis",
                           quiet = TRUE)
#> # A tibble: 1 × 7
#>   input_name          genus  species      url      status error_message data    
#>   <chr>               <chr>  <chr>        <chr>    <chr>  <chr>         <list>  
#> 1 Anolis carolinensis Anolis carolinensis http://… succe… NA            <tibble>
```
