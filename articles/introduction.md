# Introduction to reptiledbr: Accessing The Reptile Database in R

``` r
library(reptiledbr)
#> Welcome to reptiledbr (0.0.2)
#> This package provides tools to access and query data from the Reptile Database:
#>   https://reptile-database.reptarium.cz/
#> Type ?reptiledbr to get started or visit the documentation for examples and guidance.
```

`reptiledbr` is an R package that provides an interface to The Reptile
Database, allowing researchers and reptile enthusiasts to easily access
taxonomic information, distribution data, and other details about
reptile species. This tutorial will walk you through the basic usage of
the package.

## Installation

You can install the `reptiledbr` package from GitHub using:

``` r
# install.packages("pak")
pak::pak("PaulESantos/reptiledbr")
```

## Basic Usage

### 1. Loading the package

Let’s start by loading the package:

``` r
library(reptiledbr)
```

### 2. Retrieving data for specific species

The main function of the package is
[`get_reptiledb_data()`](https://paulesantos.github.io/reptiledbr/reference/get_reptiledb_data.md),
which allows you to search for one or more species:

``` r
# Create a list of species to search
species_list <- c(
  "Lachesis muta",
  "Python bivittatus",
  "Crotalus atrox"
)
```

This function will connect to The Reptile Database, search for each
species, and download the available information. During the process,
you’ll see progress messages like:

``` r
# Get data for these species
reptile_data <- get_reptiledb_data(species_list)
#> Starting search for 3 species...
#> Maximum wait time per request: 10 seconds
#> ------------------------------------------------------------------------
#> Processing: Lachesis muta
#> SUCCESS: Data found for Lachesis muta
#> Processing: Python bivittatus
#> SUCCESS: Data found for Python bivittatus
#> Processing: Crotalus atrox
#> SUCCESS: Data found for Crotalus atrox
#> ------------------------------------------------------------------------
#> Search summary:
#>  Species found with data: 3
#>  Species not found: 0
#>  Total errors: 0
#> ------------------------------------------------------------------------
```

### 3. Understanding the returned data

The
[`get_reptiledb_data()`](https://paulesantos.github.io/reptiledbr/reference/get_reptiledb_data.md)
function returns a tibble with columns containing both metadata about
the search and the actual data retrieved:

``` r
reptile_data
#> # A tibble: 3 × 7
#>   input_name        genus    species    url        status error_message data    
#>   <chr>             <chr>    <chr>      <chr>      <chr>  <chr>         <list>  
#> 1 Lachesis muta     Lachesis muta       http://re… succe… NA            <tibble>
#> 2 Python bivittatus Python   bivittatus http://re… succe… NA            <tibble>
#> 3 Crotalus atrox    Crotalus atrox      http://re… succe… NA            <tibble>
```

The `data` column contains nested tibbles with all the information
scraped from each species page.

### 4. Formatting data with specialized functions

`reptiledbr` provides several specialized functions to extract and
format specific types of information:

#### Synonyms

``` r
format_synonyms(reptile_data)
#> # A tibble: 79 × 4
#>    input_name    genus    species synonym                                       
#>    <chr>         <chr>    <chr>   <chr>                                         
#>  1 Lachesis muta Lachesis muta    Crotalus mutus LINNAEUS 1766: 373             
#>  2 Lachesis muta Lachesis muta    Coluber crotalinus GMELIN 1789: 1094          
#>  3 Lachesis muta Lachesis muta    Scytale catenatus LATREILLE in SONNINI and LA…
#>  4 Lachesis muta Lachesis muta    Scytale ammodytes LATREILLE in SONNINI and LA…
#>  5 Lachesis muta Lachesis muta    Coluber alecto SHAW 1802: 405                 
#>  6 Lachesis muta Lachesis muta    Lachesis mutus — DAUDIN 1803: 351             
#>  7 Lachesis muta Lachesis muta    Lachesis ater — DAUDIN 1803: 354              
#>  8 Lachesis muta Lachesis muta    Trigonocephalus ammodytes — OPPEL 1811: 390   
#>  9 Lachesis muta Lachesis muta    Cophias crotalinus — MERREM 1820: 144         
#> 10 Lachesis muta Lachesis muta    Trigonocephalus crotalinus — SCHINZ 1822: 144 
#> # ℹ 69 more rows
```

#### Distribution information

``` r
format_distribution(reptile_data)
#> # A tibble: 11 × 4
#>    input_name        genus    species    distribution                           
#>    <chr>             <chr>    <chr>      <chr>                                  
#>  1 Lachesis muta     Lachesis muta       "Colombia, E Ecuador, Brazil (Minas Ge…
#>  2 Lachesis muta     Lachesis muta       "rhombeata: Brazil (Alagoas, Bahia, Ri…
#>  3 Lachesis muta     Lachesis muta       "Type locality: Suriname; restricted t…
#>  4 Python bivittatus Python   bivittatus "SE Nepal, India (Assam, Tripura, Sikk…
#>  5 Python bivittatus Python   bivittatus "Introduced to Florida (USA)"          
#>  6 Python bivittatus Python   bivittatus "progschai: Sulawesi; Type locality: S…
#>  7 Python bivittatus Python   bivittatus "Type locality: Java (designated by ME…
#>  8 Crotalus atrox    Crotalus atrox      "USA (SE California, S Nevada [A Heind…
#>  9 Crotalus atrox    Crotalus atrox      "Mexico (Mexico [HR 35: 190], Baja Cal…
#> 10 Crotalus atrox    Crotalus atrox      "Type locality: \"Indianola\" [Indiano…
#> 11 Crotalus atrox    Crotalus atrox      "tortugensis: Mexico (Isla Tortuga in …
```

#### Higher taxonomic classifications

``` r
format_higher_taxa(reptile_data)
#> # A tibble: 20 × 4
#>    input_name        genus    species    taxon            
#>    <chr>             <chr>    <chr>      <chr>            
#>  1 Lachesis muta     Lachesis muta       Viperidae        
#>  2 Lachesis muta     Lachesis muta       Crotalinae       
#>  3 Lachesis muta     Lachesis muta       Colubroidea      
#>  4 Lachesis muta     Lachesis muta       Caenophidia      
#>  5 Lachesis muta     Lachesis muta       Alethinophidia   
#>  6 Lachesis muta     Lachesis muta       Serpentes        
#>  7 Lachesis muta     Lachesis muta       Squamata (snakes)
#>  8 Python bivittatus Python   bivittatus Pythonidae       
#>  9 Python bivittatus Python   bivittatus Henophidia       
#> 10 Python bivittatus Python   bivittatus Pythonoidea      
#> 11 Python bivittatus Python   bivittatus Alethinophidia   
#> 12 Python bivittatus Python   bivittatus Serpentes        
#> 13 Python bivittatus Python   bivittatus Squamata (snakes)
#> 14 Crotalus atrox    Crotalus atrox      Viperidae        
#> 15 Crotalus atrox    Crotalus atrox      Crotalinae       
#> 16 Crotalus atrox    Crotalus atrox      Colubroidea      
#> 17 Crotalus atrox    Crotalus atrox      Caenophidia      
#> 18 Crotalus atrox    Crotalus atrox      Alethinophidia   
#> 19 Crotalus atrox    Crotalus atrox      Serpentes        
#> 20 Crotalus atrox    Crotalus atrox      Squamata (snakes)
```

#### Subspecies information

``` r
format_subspecies(reptile_data)
#> # A tibble: 2 × 4
#>   input_name        genus  species    subspecies                                
#>   <chr>             <chr>  <chr>      <chr>                                     
#> 1 Python bivittatus Python bivittatus Python bivittatus progschai JACOBS, AULYI…
#> 2 Python bivittatus Python bivittatus Python bivittatus bivittatus KUHL 1820
```

#### Common names

``` r
format_common_names(reptile_data)
#> # A tibble: 13 × 4
#>    input_name        genus    species    common_name                            
#>    <chr>             <chr>    <chr>      <chr>                                  
#>  1 Lachesis muta     Lachesis muta       E: South American Bushmaster           
#>  2 Lachesis muta     Lachesis muta       G: Südamerikanischer Buschmeister      
#>  3 Lachesis muta     Lachesis muta       rhombeata: Atlantic Forest bushmaster  
#>  4 Lachesis muta     Lachesis muta       NL: Bosmeester                         
#>  5 Lachesis muta     Lachesis muta       Portuguese: Bico-de-Jaca, Cobra-Topete…
#>  6 Lachesis muta     Lachesis muta       S: Cuaima; Guayma concha de piña       
#>  7 Python bivittatus Python   bivittatus E: Burmese Python                      
#>  8 Python bivittatus Python   bivittatus G: Dunkler Tigerpython                 
#>  9 Python bivittatus Python   bivittatus Chinese: 蟒                            
#> 10 Crotalus atrox    Crotalus atrox      E: Western Diamond-backed Rattlesnake  
#> 11 Crotalus atrox    Crotalus atrox      G: Texas-Klapperschlange, Westliche Di…
#> 12 Crotalus atrox    Crotalus atrox      E: Tortuga Island Rattlesnake (tortuge…
#> 13 Crotalus atrox    Crotalus atrox      S: Cascabel de Diamantes
```

#### Reproduction information

``` r
format_reproduction(reptile_data)
#> # A tibble: 3 × 4
#>   input_name        genus    species    reproduction_detail                     
#>   <chr>             <chr>    <chr>      <chr>                                   
#> 1 Lachesis muta     Lachesis muta       oviparous; one of the few snakes that s…
#> 2 Python bivittatus Python   bivittatus GROOT et al. (2003) and KUHN & SCHMIDT …
#> 3 Crotalus atrox    Crotalus atrox      ovoviviparous. C. atrox and C. horridus…
```

#### Type specimens

``` r
format_types(reptile_data)
#> # A tibble: 6 × 4
#>   input_name        genus    species    type_detail                             
#>   <chr>             <chr>    <chr>      <chr>                                   
#> 1 Lachesis muta     Lachesis muta       "Holotype: NRM = NHRM. According to And…
#> 2 Lachesis muta     Lachesis muta       "Holotype: ZSM, uncatalogued specimen(s…
#> 3 Python bivittatus Python   bivittatus "Holotype: iconotype: Plate in SEBA 173…
#> 4 Python bivittatus Python   bivittatus "Holotype: ZFMK 87481, subadult male [p…
#> 5 Crotalus atrox    Crotalus atrox      "Holotype: USNM 7761"                   
#> 6 Crotalus atrox    Crotalus atrox      "Holotype: CAS 50515 [tortugensis]"
```

#### Diagnosis information

``` r
format_diagnosis(reptile_data)
#> # A tibble: 6 × 4
#>   input_name        genus    species    diagnosis_detail                        
#>   <chr>             <chr>    <chr>      <chr>                                   
#> 1 Lachesis muta     Lachesis muta       Diagnosis (genus): The only oviparous N…
#> 2 Lachesis muta     Lachesis muta       The diagnostic external morphological f…
#> 3 Lachesis muta     Lachesis muta       Unfortunately we had to temporarily rem…
#> 4 Python bivittatus Python   bivittatus Diagnosis: Large serpents; labials sepa…
#> 5 Python bivittatus Python   bivittatus Unfortunately we had to temporarily rem…
#> 6 Crotalus atrox    Crotalus atrox      Unfortunately we had to temporarily rem…
```

#### Comments

``` r
format_comments(reptile_data)
#> # A tibble: 15 × 4
#>    input_name        genus    species    comment_detail                         
#>    <chr>             <chr>    <chr>      <chr>                                  
#>  1 Lachesis muta     Lachesis muta       "Venomous!"                            
#>  2 Lachesis muta     Lachesis muta       "Synonymy: Lachesis muta has been spli…
#>  3 Lachesis muta     Lachesis muta       "Type species: Lachesis mutus is the t…
#>  4 Lachesis muta     Lachesis muta       "Distribution: see maps in Barrio-Amor…
#>  5 Python bivittatus Python   bivittatus "Subspecies: This species has been con…
#>  6 Python bivittatus Python   bivittatus "Hybridization: \"The evidence for the…
#>  7 Python bivittatus Python   bivittatus "Distribution: Records from Sumatra an…
#>  8 Python bivittatus Python   bivittatus "DNA barcodes suggested multiple speci…
#>  9 Python bivittatus Python   bivittatus "Genome: Python (molurus) bivittatus w…
#> 10 Crotalus atrox    Crotalus atrox      "Venomous! Crotalus atrox is responsib…
#> 11 Crotalus atrox    Crotalus atrox      "Nomenclature: Hoser’s 2009 classifica…
#> 12 Crotalus atrox    Crotalus atrox      "Synonymy: AMARAL 1929 synonymed C. to…
#> 13 Crotalus atrox    Crotalus atrox      "Similar species: C. scutulatus."      
#> 14 Crotalus atrox    Crotalus atrox      "Love (2013) reports melanism in C. at…
#> 15 Crotalus atrox    Crotalus atrox      "Habitat: usually terrestrial, occasio…
```

#### Etymology

``` r
format_etymology(reptile_data)
#> # A tibble: 4 × 4
#>   input_name        genus    species    etymology_detail                        
#>   <chr>             <chr>    <chr>      <chr>                                   
#> 1 Lachesis muta     Lachesis muta       "The specific name muta is from the Lat…
#> 2 Lachesis muta     Lachesis muta       "The genus was apparently named after L…
#> 3 Python bivittatus Python   bivittatus "The species epithet, bivittatus, comes…
#> 4 Crotalus atrox    Crotalus atrox      "The specific name, \"atrox,\" is a Gre…
```

#### References

``` r
format_references(reptile_data)
#> # A tibble: 421 × 4
#>    input_name    genus    species reference                                     
#>    <chr>         <chr>    <chr>   <chr>                                         
#>  1 Lachesis muta Lachesis muta    Alves, Fátima Q.; AntÃ´nio J. S. ArgÃ´lo, and…
#>  2 Lachesis muta Lachesis muta    Amaral, A. do 1925. On the Oviparity of Lache…
#>  3 Lachesis muta Lachesis muta    Amaral,A. do 1926. 4.a nota de nomenclatura O…
#>  4 Lachesis muta Lachesis muta    Andersson, L.G. 1899. Catalogue of Linnean ty…
#>  5 Lachesis muta Lachesis muta    ANDRADE LIMA, J.H., DIAS, E.G., COSTA, R.D.L.…
#>  6 Lachesis muta Lachesis muta    Araujo Filho, João Antonio de, Cícero Ricardo…
#>  7 Lachesis muta Lachesis muta    Arteaga, A.; Bustamante, L.; Vieira, J. 2024.…
#>  8 Lachesis muta Lachesis muta    Avila-Pires, Teresa C.S.; Kleiton R. Alves-Si…
#>  9 Lachesis muta Lachesis muta    Barbour, Thomas 1930. The bushmaster in the C…
#> 10 Lachesis muta Lachesis muta    Barrio-Amorós, Cesar L.; Greivin Corrales, Sy…
#> # ℹ 411 more rows
```

## Handling Special Cases

The package provides proper error handling for various cases:

### 1. Trinomial names (subspecies)

If you search for a trinomial name (genus + species + subspecies), the
package will issue a warning and skip the search:

``` r
species_list <- c(
  "Lachesis muta",
  "Bothrops atrox insularis"  # Trinomial name
)
reptile_data <- get_reptiledb_data(species_list)
#> Starting search for 2 species...
#> Maximum wait time per request: 10 seconds
#> ------------------------------------------------------------------------
#> Processing: Lachesis muta
#> SUCCESS: Data found for Lachesis muta
#> Processing: Bothrops atrox insularis
#> WARNING: Trinomial name detected: Bothrops atrox insularis
#>    The database only supports binomial names (genus and species).
#>    No search will be performed for trinomial names.
#> ------------------------------------------------------------------------
#> Search summary:
#>  Species found with data: 1
#>  Species not found: 0
#>  Total errors: 1
#>    - Trinomial names (not supported): 1
#> ------------------------------------------------------------------------
```

### 2. Incomplete species names

The package can also handle incomplete species names, but it will warn
you if no data is found:

``` r
species_list <- c(
  "Lachesis muta",
  "Lachesis sp"  # Incomplete species name
)
reptile_data <- get_reptiledb_data(species_list)
#> Starting search for 2 species...
#> Maximum wait time per request: 10 seconds
#> ------------------------------------------------------------------------
#> Processing: Lachesis muta
#> SUCCESS: Data found for Lachesis muta
#> Processing: Lachesis sp
#> SUCCESS: Data found for Lachesis sp
#> WARNING: No data table found for Lachesis sp
#>    This is considered an error and the URL will be removed.
#> ------------------------------------------------------------------------
#> Search summary:
#>  Species found with data: 1
#>  Species not found: 0
#>  Total errors: 1
#>    - Pages without data tables: 1
#> ------------------------------------------------------------------------
```

## Conclusion

`reptiledbr` provides an easy and structured way to access reptile
species information from [The Reptile
Database](http://www.reptile-database.org/). The package handles many
common edge cases and provides specialized functions to extract and
format specific types of information. This makes it a valuable tool for
herpetologists, ecologists, and other researchers working with reptile
data.

For more information about the package, including advanced usage and
complete function documentation, please refer to the package’s
[documentation](https://github.com/PaulESantos/reptiledbr).
