# Local Taxonomic Searches with reptiledbr

## Introduction

The `reptiledbr` package allows users to access taxonomic information of
reptiles directly from R without the constant need to make web queries
to [The Reptile Database](http://www.reptile-database.org/) server. This
provides several advantages:

- Faster processing when working offline
- Ability to efficiently verify large taxonomic datasets
- Reduction of requests to The Reptile Database server
- Consistency in results, even without a stable internet connection

This vignette demonstrates how to perform local searches using the
package’s main functions.

## Main Functions for Local Searches

The `reptiledbr` package offers three key functions for performing local
taxonomic searches:

1.  [`reptiledbr_exact()`](https://paulesantos.github.io/reptiledbr/reference/reptiledbr_exact.md):
    For exact searches of scientific names
2.  [`reptiledbr_partial()`](https://paulesantos.github.io/reptiledbr/reference/reptiledbr_partial.md):
    For searches that allow partial matches (fuzzy matching)
3.  [`search_reptiledbr()`](https://paulesantos.github.io/reptiledbr/reference/search_reptiledbr.md):
    Flexible function that combines exact and partial search
    capabilities
4.  [`list_subspecies_reptiledbr()`](https://paulesantos.github.io/reptiledbr/reference/list_subspecies_reptiledbr.md):
    To obtain information about subspecies

## Practical Examples

### Exact Search for Species Names

The
[`reptiledbr_exact()`](https://paulesantos.github.io/reptiledbr/reference/reptiledbr_exact.md)
function verifies if the provided species names exist exactly as written
in the database. This function is useful when you need to verify the
validity of specific taxonomic names.

``` r
library(reptiledbr)
#> Welcome to reptiledbr (0.0.2)
#> This package provides tools to access and query data from the Reptile Database:
#>   https://reptile-database.reptarium.cz/
#> Type ?reptiledbr to get started or visit the documentation for examples and guidance.

# Define a vector of species names to search
species_names <- c(
  "Lachesis muta",
  "Python bivittatus",
  "Crotalus atrox",
  "Bothrops atrox insularis", # Trinomial (with subspecies) - will generate an error
  "Lachesis sp",
  "Crotalus atroxx", # Intentional typo
  "Anolis liogaster",
  "Lachesis mutta", # Intentional typo
  "Python bivitatus" # Intentional typo
)

# Perform exact search
reptiledbr_exact(species_names)
#> # A tibble: 9 × 10
#>      id input_name found species_match order family genus epithet author message
#>   <int> <chr>      <lgl> <chr>         <fct> <fct>  <fct> <fct>   <chr>  <chr>  
#> 1     1 Lachesis … TRUE  Lachesis muta Serp… Viper… Lach… muta    Linna… No sub…
#> 2     2 Python bi… TRUE  Python bivit… Serp… Pytho… Pyth… bivitt… Kuhl … Specie…
#> 3     3 Crotalus … TRUE  Crotalus atr… Serp… Viper… Crot… atrox   Baird… No sub…
#> 4     4 Bothrops … FALSE NA            NA    NA     NA    NA      NA     Specie…
#> 5     5 Lachesis … FALSE NA            NA    NA     NA    NA      NA     Specie…
#> 6     6 Crotalus … FALSE NA            NA    NA     NA    NA      NA     Specie…
#> 7     7 Anolis li… TRUE  Anolis lioga… Saur… Anoli… Anol… liogas… Boule… No sub…
#> 8     8 Lachesis … FALSE NA            NA    NA     NA    NA      NA     Specie…
#> 9     9 Python bi… FALSE NA            NA    NA     NA    NA      NA     Specie…
```

As can be observed, the exact search only returns matches for names that
are correctly written. Names with typos or incorrect formats (such as
trinomials) are not recognized.

### Partial Match Search

The
[`reptiledbr_partial()`](https://paulesantos.github.io/reptiledbr/reference/reptiledbr_partial.md)
function is more flexible and uses fuzzy matching techniques to identify
species even when there are minor typos or variations in spelling.

``` r
# Perform search with partial matching
reptiledbr_partial(species_names)
#> # A tibble: 9 × 11
#>      id input_name         found species_match order family genus epithet author
#>   <int> <chr>              <lgl> <chr>         <fct> <fct>  <fct> <fct>   <chr> 
#> 1     1 Lachesis muta      TRUE  Lachesis muta Serp… Viper… Lach… muta    Linna…
#> 2     2 Python bivittatus  TRUE  Python bivit… Serp… Pytho… Pyth… bivitt… Kuhl …
#> 3     3 Crotalus atrox     TRUE  Crotalus atr… Serp… Viper… Crot… atrox   Baird…
#> 4     4 Bothrops atrox in… FALSE NA            NA    NA     NA    NA      NA    
#> 5     5 Lachesis sp        FALSE NA            NA    NA     NA    NA      NA    
#> 6     6 Crotalus atroxx    TRUE  Crotalus atr… Serp… Viper… Crot… atrox   Baird…
#> 7     7 Anolis liogaster   TRUE  Anolis lioga… Saur… Anoli… Anol… liogas… Boule…
#> 8     8 Lachesis mutta     TRUE  Lachesis muta Serp… Viper… Lach… muta    Linna…
#> 9     9 Python bivitatus   TRUE  Python bivit… Serp… Pytho… Pyth… bivitt… Kuhl …
#> # ℹ 2 more variables: fuzzy_match <lgl>, message <chr>
```

Notice how
[`reptiledbr_partial()`](https://paulesantos.github.io/reptiledbr/reference/reptiledbr_partial.md)
was able to find matches for “Crotalus atroxx”, “Lachesis mutta”, and
“Python bivitatus” despite the typos, but still does not recognize
incorrect formats such as trinomials or incomplete names (e.g.,
“Lachesis sp”).

### Flexible Search with Additional Options

The
[`search_reptiledbr()`](https://paulesantos.github.io/reptiledbr/reference/search_reptiledbr.md)
function offers greater flexibility, allowing you to specify whether to
use partial matching or not:

``` r
# Define a list of valid species
subspecies_names <- c("Lachesis muta", 
                     "Anilius scytale",
                     "Anolis bahorucoensis",
                     "Anolis baleatus",
                     "Crotalus atrox",
                     "Anolis barahonae",
                     "Anolis bremeri")

# Exact search (without fuzzy matching)
search_reptiledbr(subspecies_names, use_fuzzy = FALSE)
#> # A tibble: 7 × 12
#>      id input_name found species_match order family genus epithet author message
#>   <int> <chr>      <lgl> <chr>         <fct> <fct>  <fct> <fct>   <chr>  <chr>  
#> 1     1 Lachesis … TRUE  Lachesis muta Serp… Viper… Lach… muta    Linna… No sub…
#> 2     2 Anilius s… TRUE  Anilius scyt… Serp… Anili… Anil… scytale Linna… Specie…
#> 3     3 Anolis ba… TRUE  Anolis bahor… Saur… Anoli… Anol… bahoru… Noble… Specie…
#> 4     4 Anolis ba… TRUE  Anolis balea… Saur… Anoli… Anol… baleat… Cope … Specie…
#> 5     5 Crotalus … TRUE  Crotalus atr… Serp… Viper… Crot… atrox   Baird… No sub…
#> 6     6 Anolis ba… TRUE  Anolis barah… Saur… Anoli… Anol… baraho… Willi… Specie…
#> 7     7 Anolis br… TRUE  Anolis breme… Saur… Anoli… Anol… bremeri Barbo… Specie…
#> # ℹ 2 more variables: match_type <chr>, fuzzy_match <lgl>
```

### Obtaining Subspecies Information

A particularly useful feature is the ability to list all recognized
subspecies for a given species using
[`list_subspecies_reptiledbr()`](https://paulesantos.github.io/reptiledbr/reference/list_subspecies_reptiledbr.md):

``` r
# List all subspecies for the found species
search_reptiledbr(subspecies_names, use_fuzzy = FALSE) |> 
  list_subspecies_reptiledbr()
#> # A tibble: 20 × 3
#>    species              subspecies_name                    author               
#>    <chr>                <chr>                              <chr>                
#>  1 Anilius scytale      Anilius scytale phelpsorum         Roze 1958            
#>  2 Anilius scytale      Anilius scytale scytale            Linnaeus 1758        
#>  3 Anolis bahorucoensis Anolis bahorucoensis bahorucoensis Noble & Hassler 1933 
#>  4 Anolis bahorucoensis Anolis bahorucoensis southerlandi  Schwartz 1978        
#>  5 Anolis baleatus      Anolis baleatus baleatus           Cope 1864            
#>  6 Anolis baleatus      Anolis baleatus altager            Schwartz 1975        
#>  7 Anolis baleatus      Anolis baleatus caeruleolatus      Schwartz 1974        
#>  8 Anolis baleatus      Anolis baleatus fraudator          Schwartz 1974        
#>  9 Anolis baleatus      Anolis baleatus lineatacervix      Schwartz 1978        
#> 10 Anolis baleatus      Anolis baleatus litorisilva        Schwartz 1974        
#> 11 Anolis baleatus      Anolis baleatus multistruppus      Schwartz 1974        
#> 12 Anolis baleatus      Anolis baleatus samanae            Schwartz 1974        
#> 13 Anolis baleatus      Anolis baleatus scelestus          Schwartz 1974        
#> 14 Anolis baleatus      Anolis baleatus sublimis           Schwartz 1974        
#> 15 Anolis barahonae     Anolis barahonae barahonae         Williams 1962        
#> 16 Anolis barahonae     Anolis barahonae albocellatus      Schwartz 1974        
#> 17 Anolis barahonae     Anolis barahonae ininquinatus      Cullom & Schwartz 19…
#> 18 Anolis barahonae     Anolis barahonae mulitus           Cullom & Schwartz 19…
#> 19 Anolis bremeri       Anolis bremeri bremeri             Barbour 1914         
#> 20 Anolis bremeri       Anolis bremeri insulaepinorum      Garrido 1972
```

We can also combine partial matching search and subspecies retrieval:

``` r
# Partial matching search followed by subspecies listing
reptiledbr_partial(c("Lachesis mutta", 
                    "Python bivitatus",
                    "Anolis barahonae")) |> 
  list_subspecies_reptiledbr()
#> # A tibble: 6 × 3
#>   species           subspecies_name               author                     
#>   <chr>             <chr>                         <chr>                      
#> 1 Anolis barahonae  Anolis barahonae barahonae    Williams 1962              
#> 2 Anolis barahonae  Anolis barahonae albocellatus Schwartz 1974              
#> 3 Anolis barahonae  Anolis barahonae ininquinatus Cullom & Schwartz 1980     
#> 4 Anolis barahonae  Anolis barahonae mulitus      Cullom & Schwartz 1980     
#> 5 Python bivittatus Python bivittatus progschai   Jacobs, Aulyia & Böhme 2009
#> 6 Python bivittatus Python bivittatus bivittatus  Kuhl 1820
```

## Recommended Workflow

For working with large taxonomic datasets, we recommend the following
workflow:

1.  Perform an initial search with
    [`reptiledbr_exact()`](https://paulesantos.github.io/reptiledbr/reference/reptiledbr_exact.md)
    to identify names that match exactly
2.  For names not found, use
    [`reptiledbr_partial()`](https://paulesantos.github.io/reptiledbr/reference/reptiledbr_partial.md)
    to capture possible typos
3.  Finally, use
    [`list_subspecies_reptiledbr()`](https://paulesantos.github.io/reptiledbr/reference/list_subspecies_reptiledbr.md)
    to obtain detailed information about subspecies when needed

## Conclusions

The `reptiledbr` package provides efficient tools for verifying and
obtaining taxonomic information about reptiles without the need to make
constant queries to [The Reptile
Database](http://www.reptile-database.org/) serverusing
[`reptiledbr::search_reptiledbr()`](https://paulesantos.github.io/reptiledbr/reference/search_reptiledbr.md).
This greatly facilitates working with large datasets and allows for
consistent taxonomic verification even without an internet connection.

The local search functions are particularly useful for researchers and
professionals working with herpetological data, enabling efficient
cleaning and validation of species lists, identification of common
typos, and access to up-to-date taxonomic information about reptiles.
