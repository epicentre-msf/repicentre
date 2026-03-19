# Solutions du satellite pour importer plusieurs fichiers d'un coup
# Auteurs: La team Fetch
# Date de création : 17/02/2025
# Dernière mise à jour : 17/02/2025
# Description : Solutions des exercices de code


# Préparation --------------------------

#  Paquets 
library(here)
library(rio)

# Chemin d'accès
path_data_raw <- here("data", "raw", "satellite_multiple")


# Importe plusieurs feuilles -----------------------------

# Importe et stocke dans une liste
lab_data_list <- import_list(here(path_data_raw, "multiple_sheets",
                                  "msf_laboratory_moissala_2023-09-24_first.xlsx")) 

str(lab_data_list)
View(lab_data_list)


# Importe et concatène les éléments de la liste pour créer un data frame
lab_data <- import_list(here(path_data_raw, "multiple_sheets",
                             "msf_laboratory_moissala_2023-09-24_first.xlsx"),
                        rbind = TRUE) 

str(lab_data)
View(lab_data)


# Importe plusiers fichiers -------------------------------

# Définir le chemain
# L'étape est optionelle, vous pouvez écrire le chemin (relatif) 
# complet directement dans la commande d'import, mais ça raccourcit
# le code d'après
path_mult <- here::here(path_data_raw, "multiple_files", "FR")



## Lister tous les fichier manuellement --------------------

vector_paths <- c(
  here(path_mult, "moissala_linelist_EN_BEDAYA.xlsx"),
  here(path_mult, "moissala_linelist_EN_BEDJONDO.xlsx"),
  here(path_mult, "moissala_linelist_EN_BEKOUROU.xlsx"),
  here(path_mult, "moissala_linelist_EN_BOUNA.xlsx"),
  here(path_mult, "moissala_linelist_EN_GOUNDI.xlsx"),
  here(path_mult, "moissala_linelist_EN_KOUMRA.xlsx"),
  here(path_mult, "moissala_linelist_EN_MOISSALA.xlsx")
)

# Afficher le vecteur
vector_paths

# Importe tous les fichiers et les concatène (si c'est pertinent !)
linelist_data <- import_list(vector_paths,
                             rbind = TRUE)



# Sans lister les fichiers manuellement --------------------


# Importe les données et les concatène
linelist_data <- import_list(
  list.files(path = path_mult, pattern = "\\.xlsx$",
             full.names = TRUE),
  rbind = TRUE)
