## code to prepare `build_data` dataset goes here
reptile_checklist <- readxl::read_excel("D:/rreptiledb/reptile_checklist.xlsx") |>
  janitor::clean_names()
# Improved code for processing reptile checklist with species_name_year extraction


reptiledb_012025 <-
  reptile_checklist |>
  # Separar entradas multilínea con manejo seguro
  tidyr::separate_rows(subspecies, sep = "\\r\\n") |>

  # Flag para cambios de nomenclatura (nombres entre paréntesis)
  dplyr::mutate(
    # Asegurar que subspecies es character para evitar problemas
    subspecies = as.character(subspecies),
    nomenclature_change = ifelse(stringr::str_detect(subspecies, "\\(.*\\)"), TRUE, FALSE)
  ) |>

  # Limpiar texto de subespecies
  dplyr::mutate(
    subspecies = stringr::str_trim(stringr::str_replace_all(subspecies, "\\r", "")),
    subspecies = stringr::str_remove_all(subspecies, "\\(|\\)")
  ) |>

  # Extraer componentes con una expresión regular más flexible
  tidyr::extract(
    subspecies,
    into = c("genus", "ephitetho", "subspecies_name",
             "subspecie_author_info"),
    # Captura: género (1ª palabra), especie (2ª palabra), subespecie (3ª palabra) y toda la info del autor
    regex = "([A-Z][a-z]+)\\s+([a-z\\-]+)\\s+([a-z\\-]+)\\s+(.+)",
    remove = FALSE,
    convert = TRUE
  ) |>

  # Manejar casos donde la extracción primaria falla
  dplyr::mutate(
    # Usar stringr::word() como fallback para casos no capturados por regex
    genus = ifelse(is.na(genus),
                   stringr::word(subspecies, 1, 1),
                   genus),
    ephitetho = ifelse(is.na(ephitetho),
                       stringr::word(subspecies, 2, 2),
                       ephitetho),
    subspecies_name = ifelse(is.na(subspecies_name),
                             stringr::word(subspecies, 3, 3),
                             subspecies_name)
  ) |>

  #  Combinar los resultados de casos especiales y normales
  dplyr::mutate(
    # Extraer el año usando una expresión regular más flexible
    subspecies_year = stringr::str_extract(subspecie_author_info,
                                           "[0-9]{4}"),

    # Extraer el autor eliminando el año
    subspecies_name_author = stringr::str_trim(
      stringr::str_replace(subspecie_author_info, "[0-9]{4}", "")
    ),
    # Limpiar posibles espacios duplicados en el autor
    subspecies_name_author = stringr::str_trim(
      stringr::str_replace_all(subspecies_name_author, "\\s+", " ")
    )
  ) |>
    # Proper case formatting for author names
  dplyr::mutate(
      subspecies_name_author = stringr::str_to_title(subspecies_name_author)) |>
  dplyr::mutate(
    nomenclature_change_species = ifelse(
      stringr::str_detect(author, "\\(.*\\)"),
      TRUE,
      FALSE
    )
  ) |>

  # Limpiar texto de species
  dplyr::mutate(
    # Usar stringr::word() como fallback para casos no capturados por regex
    genus = ifelse(is.na(genus),
                   stringr::word(species, 1, 1),
                   genus),
    ephitetho = ifelse(is.na(ephitetho),
                       stringr::word(species, 2, 2),
                       ephitetho),
  ) |>
  dplyr::mutate(author = stringr::str_remove_all(author,
                                                 "\\(|\\)")) |>
  # Extract species_name_year from species_name_author
  dplyr::mutate(
    # Extract year pattern from species_name_author with proper handling of parentheses
    species_name_year = stringr::str_extract(author,
                                             "[0-9]{4}"),

    # For entries without a direct year match, try to extract from parentheses
    species_name_year = dplyr::case_when(
      is.na(species_name_year) & stringr::str_detect(author,
                                                     "\\([^)]*[0-9]{4}[^)]*\\)") ~
        stringr::str_extract(author, "(?<=\\()[^)]*[0-9]{4}[^)]*(?=\\))"),
      TRUE ~ species_name_year
    ),

    # Further extract just the year from any text
    species_name_year = stringr::str_extract(species_name_year,
                                             "[0-9]{4}"),

    # Create clean species_name from species_name_author by removing year and parentheses
    species_author = stringr::str_remove_all(author,
                                             "[0-9]{4}"),
    species_author = stringr::str_remove_all(species_author, "\\(|\\)"),
    species_author = stringr::str_trim(species_author) |>
      stringr::str_to_title()
  ) |>
  # Seleccionar y reorganizar columnas para mejor legibilidad
  dplyr::select(
    order,
    family,
    genus,
    ephitetho,
    species,
    author,
    species_author,
    species_name_year,
    subspecies_name,
    subspecie_author_info,
    subspecies_name_author,
    subspecies_year,
    dplyr::everything(),
    nomenclature_change_species,
    nomenclature_change
  )

#reptiledb_012025

#reptile_checklist_f |>
#  writexl::write_xlsx("reptile_checklist_clean_012025.xlsx")

usethis::use_data(reptiledb_012025,
                  overwrite = TRUE,
                  compress = "xz")

