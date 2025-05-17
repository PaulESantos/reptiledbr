
<!-- README.md is generated from README.Rmd. Please edit that file -->

# reptiledbr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/reptiledbr)](https://CRAN.R-project.org/package=reptiledbr)
[![R-CMD-check](https://github.com/PaulESantos/reptiledbr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/PaulESantos/reptiledbr/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/PaulESantos/reptiledbr/graph/badge.svg)](https://app.codecov.io/gh/PaulESantos/reptiledbr)
<!-- badges: end -->

## Overview

**`reptiledbr`** is an R package that provides programmatic access to
data from [The Reptile Database](http://www.reptile-database.org), a
comprehensive and curated source of taxonomic information on all living
reptiles. This includes snakes, lizards, turtles, tuataras,
amphisbaenians, and crocodiles—over 10,000 species and more than 2,800
subspecies.

The goal of `reptiledbr` is to facilitate access to reptile taxonomy,
nomenclature, distribution, and associated scientific literature in a
reproducible and efficient way for researchers, ecologists, educators,
and biodiversity data users.

## Installation

You can install the development version of `reptiledbr` from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("PaulESantos/reptiledbr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(reptiledbr)
#> Welcome to reptiledbr (v0.0.1)
#> This package provides tools to access and query data from the Reptile Database:
#>   https://reptile-database.reptarium.cz/
#> Type ?reptiledbr to get started or visit the documentation for examples and guidance.
## basic example code


reptiledb <- reptiledbr::get_reptiledb_data("Anolis carolinensis", quiet = FALSE)
#> Starting search for 1 species...
#> Maximum wait time per request: 10 seconds
#> ------------------------------------------------------------------------
#> Processing: Anolis carolinensis
#> SUCCESS: Data found for Anolis carolinensis
#> ------------------------------------------------------------------------
#> Search summary:
#>  Species found with data: 1
#>  Species not found: 0
#>  Total errors: 0
#> ------------------------------------------------------------------------

reptiledb |> 
  reptiledbr::format_all_attributes()
#> Starting to format all attributes...
#> Attribute formatting successfully completed.
#> $distribution
#> # A tibble: 11 × 4
#>    input_name          genus  species      distribution                         
#>    <chr>               <chr>  <chr>        <chr>                                
#>  1 Anolis carolinensis Anolis carolinensis USA (E Texas, SE Oklahoma, S Arkansa…
#>  2 Anolis carolinensis Anolis carolinensis Bahamas, Grand Cayman Islands (HR 33…
#>  3 Anolis carolinensis Anolis carolinensis Introduced to Hawaii (fide MCKEOWN 1…
#>  4 Anolis carolinensis Anolis carolinensis Introduced to Japan (Chichizima Is. …
#>  5 Anolis carolinensis Anolis carolinensis Introduced to Micronesia and Guam (G…
#>  6 Anolis carolinensis Anolis carolinensis May have been introduced to Tenerife…
#>  7 Anolis carolinensis Anolis carolinensis Introduced to Northern Mariana Islan…
#>  8 Anolis carolinensis Anolis carolinensis Introduced to Mexico (Nuevo León, Lu…
#>  9 Anolis carolinensis Anolis carolinensis Introduced to California fide Hansen…
#> 10 Anolis carolinensis Anolis carolinensis baccatus: Mexico; Type locality: Mex…
#> 11 Anolis carolinensis Anolis carolinensis seminolus: USA (Florida); Type local…
#> 
#> $synonyms
#> # A tibble: 34 × 4
#>    input_name          genus  species      synonym                              
#>    <chr>               <chr>  <chr>        <chr>                                
#>  1 Anolis carolinensis Anolis carolinensis Anolius carolinensis VOIGT in CUVIER…
#>  2 Anolis carolinensis Anolis carolinensis Lacerta principalis LINNAEUS 1758 (f…
#>  3 Anolis carolinensis Anolis carolinensis Ameiua bullaris MEYER 1795: 29 (erro…
#>  4 Anolis carolinensis Anolis carolinensis Anolis bullaris — DAUDIN 1802: 69 (p…
#>  5 Anolis carolinensis Anolis carolinensis Agama bullaris — LINK 1807: 58       
#>  6 Anolis carolinensis Anolis carolinensis Agama strumosa — LINK 1807: 59       
#>  7 Anolis carolinensis Anolis carolinensis Anolis strumosa — HARLAN 1835: 143   
#>  8 Anolis carolinensis Anolis carolinensis Anolis Carolinensis — DUMÉRIL & BIBR…
#>  9 Anolis carolinensis Anolis carolinensis Anolis podargicus RICHARDSON 1837: 2…
#> 10 Anolis carolinensis Anolis carolinensis Dactyloa (Ctenocercus) carolinensis …
#> # ℹ 24 more rows
#> 
#> $higher_taxa
#> # A tibble: 4 × 4
#>   input_name          genus  species      taxon             
#>   <chr>               <chr>  <chr>        <chr>             
#> 1 Anolis carolinensis Anolis carolinensis Anolidae          
#> 2 Anolis carolinensis Anolis carolinensis Iguania           
#> 3 Anolis carolinensis Anolis carolinensis Sauria            
#> 4 Anolis carolinensis Anolis carolinensis Squamata (lizards)
#> 
#> $subspecies
#> # A tibble: 0 × 4
#> # ℹ 4 variables: input_name <chr>, genus <chr>, species <chr>, subspecies <chr>
#> 
#> $common_names
#> # A tibble: 3 × 4
#>   input_name          genus  species      common_name                           
#>   <chr>               <chr>  <chr>        <chr>                                 
#> 1 Anolis carolinensis Anolis carolinensis E: North American Green Anole, Green …
#> 2 Anolis carolinensis Anolis carolinensis S: Anolis Verde                       
#> 3 Anolis carolinensis Anolis carolinensis G: Rotkehlanolis                      
#> 
#> $reproduction
#> # A tibble: 1 × 4
#>   input_name          genus  species      reproduction_detail                   
#>   <chr>               <chr>  <chr>        <chr>                                 
#> 1 Anolis carolinensis Anolis carolinensis oviparous<br><br>Hybridization: Anoli…
#> 
#> $types
#> # A tibble: 4 × 4
#>   input_name          genus  species      type_detail                           
#>   <chr>               <chr>  <chr>        <chr>                                 
#> 1 Anolis carolinensis Anolis carolinensis Neotype: NCSM 93545 (North Carolina M…
#> 2 Anolis carolinensis Anolis carolinensis Holotype: MVZ (originally as UCMZ) 53…
#> 3 Anolis carolinensis Anolis carolinensis Holotype: MNHN 1126 [baccatus]        
#> 4 Anolis carolinensis Anolis carolinensis Synypes: MCZ 5955, 5956 [principalis] 
#> 
#> $diagnosis
#> # A tibble: 1 × 4
#>   input_name          genus  species      diagnosis_detail                      
#>   <chr>               <chr>  <chr>        <chr>                                 
#> 1 Anolis carolinensis Anolis carolinensis Diagnosis (genus; Anolis s.s.): Suppo…
#> 
#> $comments
#> # A tibble: 17 × 4
#>    input_name          genus  species      comment_detail                       
#>    <chr>               <chr>  <chr>        <chr>                                
#>  1 Anolis carolinensis Anolis carolinensis Synonymy: partly after VANCE 1991. B…
#>  2 Anolis carolinensis Anolis carolinensis Nomenclature: the family that contai…
#>  3 Anolis carolinensis Anolis carolinensis Subspecies: VANCE 1991 described Ano…
#>  4 Anolis carolinensis Anolis carolinensis Similar species: A. porcatus, A. sma…
#>  5 Anolis carolinensis Anolis carolinensis Genetics: In July 2005, the scientif…
#>  6 Anolis carolinensis Anolis carolinensis Evolution: On small islands in Flori…
#>  7 Anolis carolinensis Anolis carolinensis Ecology: The presence of invasive A.…
#>  8 Anolis carolinensis Anolis carolinensis Sexual dimorphism: the carolinensis …
#>  9 Anolis carolinensis Anolis carolinensis Distribution: See maps in Vance 1991…
#> 10 Anolis carolinensis Anolis carolinensis In Japan, the green anole Anolis car…
#> 11 Anolis carolinensis Anolis carolinensis Species group: Anolis carolinensis s…
#> 12 Anolis carolinensis Anolis carolinensis Type species: Anolis bullaris DAUDIN…
#> 13 Anolis carolinensis Anolis carolinensis Key: for a key to (mainland) species…
#> 14 Anolis carolinensis Anolis carolinensis Phylogenetics (genus). For a compreh…
#> 15 Anolis carolinensis Anolis carolinensis Karyotype: 2n=36, XY (males) or XX (…
#> 16 Anolis carolinensis Anolis carolinensis Thermobiology: Salazar et al. 2019 c…
#> 17 Anolis carolinensis Anolis carolinensis Reference images: see Uetz et al. 20…
#> 
#> $etymology
#> # A tibble: 1 × 4
#>   input_name          genus  species      etymology_detail                      
#>   <chr>               <chr>  <chr>        <chr>                                 
#> 1 Anolis carolinensis Anolis carolinensis Named after the Carolinas where the s…
#> 
#> $references
#> # A tibble: 251 × 4
#>    input_name          genus  species      reference                            
#>    <chr>               <chr>  <chr>        <chr>                                
#>  1 Anolis carolinensis Anolis carolinensis Alföldi J, Di Palma F, Grabherr M, W…
#>  2 Anolis carolinensis Anolis carolinensis Alibardi, L. 2021. Limb regeneration…
#>  3 Anolis carolinensis Anolis carolinensis Alibardi, Lorenzo 2021. Immunolocali…
#>  4 Anolis carolinensis Anolis carolinensis Allen, Morrow J. 1932. A survey of t…
#>  5 Anolis carolinensis Anolis carolinensis Andersson, L.G. 1900. Catalogue of L…
#>  6 Anolis carolinensis Anolis carolinensis Andrews, R.M. 1985. Mate Choice by F…
#>  7 Anolis carolinensis Anolis carolinensis Andrews, R.M. 1985. Oviposition freq…
#>  8 Anolis carolinensis Anolis carolinensis Arnold, Debbie M. 1997. Geographic D…
#>  9 Anolis carolinensis Anolis carolinensis Art, G.R. & D.L. Claussen 1982. The …
#> 10 Anolis carolinensis Anolis carolinensis Ballinger, R.E. 1973. Experimental E…
#> # ℹ 241 more rows
```

## Features

- Query species by scientific name or higher taxonomy
- Retrieve synonyms, type localities, and distributions
- Access bibliographic references for species descriptions
- Tools to explore phylogenetic classification (based on Zheng & Wiens,
  2016)
- Fully integrated with the R environment for analysis and visualization

------------------------------------------------------------------------

## Data Source

The package uses data from The Reptile Database, an open and
community-driven resource curated by herpetologists and volunteers
around the world. It focuses on taxonomic data including:

- Scientific names and synonyms

- Type specimens and distribution

- Original literature references

## Data Source

The package uses data from The Reptile Database, an open and
community-driven resource curated by herpetologists and volunteers
around the world. It focuses on taxonomic data including:

- Scientific names and synonyms

- Type specimens and distribution

- Original literature references

- The database was initiated by Peter Uetz in 1995 and is currently
  curated by a volunteer team. For more information, visit:
  www.reptile-database.org

> Note: This package is not officially affiliated with The Reptile
> Database. It provides an independent R interface to facilitate access
> to public data.

## Citing the Data

Please cite the original Reptile Database if you use this package in
published work:

Uetz, P., Freed, P., & Hošek, J. (eds.) (2021). The Reptile Database.
Retrieved from <http://www.reptile-database.org>

## Contributing

Contributions, bug reports, and feature requests are welcome! Please use
the issue tracker to report problems or suggest improvements.

## License

This package is free and open source software, licensed under the MIT
License. See the LICENSE file for more details.

## Acknowledgments

Special thanks to the editors and contributors of The Reptile Database
for their dedication to herpetological taxonomy and for maintaining an
open-access scientific resource for the global community.
