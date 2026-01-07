# Reptile Data Formatting Tutorial

This tutorial explains how to use our reptile taxonomy functions to
format and access structured information about reptile species in your
research or applications.

## Overview of Functions

Our package provides two main functions for working with reptile
taxonomic data:

1.  [`format_all_attributes()`](https://paulesantos.github.io/reptiledbr/reference/format_all_attributes.md)
2.  [`format_selected_attributes()`](https://paulesantos.github.io/reptiledbr/reference/format_selected_attributes.md)

These functions help researchers efficiently organize and access
taxonomic information about reptile species from various sources into
standardized formats.

## Using `format_all_attributes()`

The
[`format_all_attributes()`](https://paulesantos.github.io/reptiledbr/reference/format_all_attributes.md)
function processes a complete reptile dataset and formats all available
taxonomic attributes into structured tibbles (data frames).

### Syntax

``` r
format_all_attributes(reptile_data)
```

### Parameters

- `reptile_data`: A dataframe or list containing raw reptile taxonomic
  information

### Return Value

The function returns a list of tibbles, with each tibble containing a
specific category of taxonomic information:

- `distribution`: Geographic distribution information
- `synonyms`: Scientific name synonyms throughout taxonomic history
- `higher_taxa`: Taxonomic classification hierarchy
- `subspecies`: Information about recognized subspecies
- `common_names`: Common names in different languages
- `reproduction`: Reproductive biology information
- `types`: Type specimen information
- `diagnosis`: Diagnostic morphological features
- `comments`: Additional taxonomic notes
- `etymology`: Origin and meaning of scientific names
- `references`: Scientific literature references

### Example

``` r
library(reptiledbr)
#> Welcome to reptiledbr (0.0.2)
#> This package provides tools to access and query data from the Reptile Database:
#>   https://reptile-database.reptarium.cz/
#> Type ?reptiledbr to get started or visit the documentation for examples and guidance.
species_list <- c(
  "Lachesis muta",
  "Python bivittatus",
  "Crotalus atrox",
  "Bothrops atrox insularis", # Trinomial (con subespecie) - debería dar error
  "Lachesis sp"
)

# 
reptile_data <- get_reptiledb_data(species_list)
#> Starting search for 5 species...
#> Maximum wait time per request: 10 seconds
#> ------------------------------------------------------------------------
#> Processing: Lachesis muta
#> SUCCESS: Data found for Lachesis muta
#> Processing: Python bivittatus
#> SUCCESS: Data found for Python bivittatus
#> Processing: Crotalus atrox
#> SUCCESS: Data found for Crotalus atrox
#> Processing: Bothrops atrox insularis
#> WARNING: Trinomial name detected: Bothrops atrox insularis
#>    The database only supports binomial names (genus and species).
#>    No search will be performed for trinomial names.
#> Processing: Lachesis sp
#> SUCCESS: Data found for Lachesis sp
#> WARNING: No data table found for Lachesis sp
#>    This is considered an error and the URL will be removed.
#> ------------------------------------------------------------------------
#> Search summary:
#>  Species found with data: 3
#>  Species not found: 0
#>  Total errors: 2
#>    - Trinomial names (not supported): 1
#>    - Pages without data tables: 1
#> ------------------------------------------------------------------------

# 
reptile_data
#> # A tibble: 5 × 7
#>   input_name               genus    species  url   status error_message data    
#>   <chr>                    <chr>    <chr>    <chr> <chr>  <chr>         <list>  
#> 1 Lachesis muta            Lachesis muta     http… succe… NA            <tibble>
#> 2 Python bivittatus        Python   bivitta… http… succe… NA            <tibble>
#> 3 Crotalus atrox           Crotalus atrox    http… succe… NA            <tibble>
#> 4 Bothrops atrox insularis Bothrops atrox    NA    error  Trinomial na… <tibble>
#> 5 Lachesis sp              Lachesis sp       NA    error  Page found b… <tibble>

# Format all attributes
all_attributes <- format_all_attributes(reptile_data)
#> Starting to format all attributes...
#> Attribute formatting successfully completed.

# Access specific attribute categories
all_attributes$distribution
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
all_attributes$common_names
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

## Using `format_selected_attributes()`

If you only need specific taxonomic attributes, the
[`format_selected_attributes()`](https://paulesantos.github.io/reptiledbr/reference/format_selected_attributes.md)
function allows you to extract only the categories you’re interested in.

### Syntax

``` r
format_selected_attributes(reptile_data, attributes, quiet = FALSE)
```

### Parameters

- `reptile_data`: A dataframe or list containing raw reptile taxonomic
  information
- `attributes`: A character vector listing the specific attributes to
  extract
- `quiet`: Logical value. If TRUE, suppresses processing messages

### Return Value

Returns a list containing only the requested attribute tibbles.

### Example

``` r
# Extract only synonyms, higher taxa, and common names
selected_info <- format_selected_attributes(
  reptile_data = reptile_data,
  attributes = c("Synonym", "Higher Taxa", "Common Names"),
  quiet = TRUE
)

# Access the selected information
selected_info$Synonym
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
selected_info$`Higher Taxa`
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
selected_info$`Common Names`
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

## Working with the Formatted Data

Once you have formatted your reptile data, you can use standard R data
manipulation techniques to analyze the information:

``` r
# Find all venomous species
all_attributes$comments |> 
  dplyr::filter(stringr::str_detect(comment_detail, "Venomous"))
#> # A tibble: 2 × 4
#>   input_name     genus    species comment_detail                                
#>   <chr>          <chr>    <chr>   <chr>                                         
#> 1 Lachesis muta  Lachesis muta    Venomous!                                     
#> 2 Crotalus atrox Crotalus atrox   Venomous! Crotalus atrox is responsible for m…


# Extract distribution information for a specific species
all_attributes$distribution |>
  dplyr::filter(input_name == "Crotalus atrox")
#> # A tibble: 4 × 4
#>   input_name     genus    species distribution                                  
#>   <chr>          <chr>    <chr>   <chr>                                         
#> 1 Crotalus atrox Crotalus atrox   "USA (SE California, S Nevada [A Heindl, pers…
#> 2 Crotalus atrox Crotalus atrox   "Mexico (Mexico [HR 35: 190], Baja California…
#> 3 Crotalus atrox Crotalus atrox   "Type locality: \"Indianola\" [Indianola, Cal…
#> 4 Crotalus atrox Crotalus atrox   "tortugensis: Mexico (Isla Tortuga in the Gul…
```

## Data Structure

Each formatted attribute tibble includes at least these standard
columns:

- `input_name`: The original species name provided
- `genus`: The genus name
- `species`: The species epithet
- Attribute-specific column (e.g., `distribution`, `common_name`,
  `synonym`, etc.)

This consistent structure allows for easy filtering, joining, and
analysis across different attribute categories.

## Tips for Effective Use

- When working with large datasets, use
  [`format_selected_attributes()`](https://paulesantos.github.io/reptiledbr/reference/format_selected_attributes.md)
  to improve performance
- Consider that some species may have multiple entries in certain
  categories (e.g., multiple common names or distribution records)
- The `input_name` column provides a reliable key for joining
  information across different attribute tibbles

By effectively using these formatting functions, you can streamline your
reptile taxonomic research and data analysis workflows.
