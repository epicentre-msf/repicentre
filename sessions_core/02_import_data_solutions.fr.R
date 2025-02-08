# Solutions Solutions pour la session 02 importer données
# Auteur :  the Fetch team
# Date de création : 08/02/2025
# Last Update : 08/02/2025
# Description :  Code modèle pour la session 2 (importer données)

# Charger les Paquets ------------------------------------

# Télécharger et installer les paquet R {here}
# Ceci doit être fait une seule fois par ordinateur ou quand on eut mettre à jour le paquet
install.packages("here")

# Charger le paquet {here}
# Ceci doit être fait à chaque nouvelle session de R
library(here)
library(rio)

# Definir un chemin -----------------------------------------

# Chemin aux données (pas encore assigner à un objet)
here("data", "raw", "Moissalla-rougeole-liste-lineaire-FR.xlsx")

# Importer les données  -----------------------------------------

#### EXCEL ####

# Importer les données mais ne pas encore assigner à un objet 
(file = here("data", "raw",
              "Moissalla-rougeole-liste-lineaire-FR.xlsx"))

# Importer les données et assigner à un objet
df_linelist <- import(file = here("data", "raw",
              "Moissalla-rougeole-liste-lineaire-FR.xlsx"))


#### CSV ####
df_linelist_csv <- import(file = here("data", "raw",,
                                      "Moissalla-rougeole-liste-lineaire-FR.csv"))