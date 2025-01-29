# Solutions de la session 02_import_data
# Auteur :  La team Fetch
# Date de création : 07/01/2025
# Dernière mise à jour : 29/01/2025
# Description : Contient les solutions pour les exercices de la session 2



# Paquets ------------------------------------

# Télécharge et installe le paquet {here}
# Il n'y a besoin de ne le faire qu'une seule fois (ou si 
# vous voulez mettre à jour le paquet)
install.packages("here")

# Charger le paquet dans la session
# Doit être exécuté à chaque fois que vous redémarez la session R
library(here)
library(rio)



# Chemins d'accès -----------------------------------------

# Chemin d'accès vers les données (pas enregistré dans un objet)
here("data", "raw", "xlsx", "Moissalla-rougeole-liste-lineaire-FR.xlsx")


# Import des données -----------------------------------------

#### EXCEL ####

# Importe les données sans créer d'objet
import(file = here("data", "raw", "xlsx",
                   "Moissalla-rougeole-liste-lineaire-FR.xlsx"))

# Importe les données et les assigne à un objet (sauvegarde le data frame dans l'environement)
df_linelist <- import(file = here("data", "raw", "xlsx",
                                  "Moissalla-rougeole-liste-lineaire-FR.xlsx"))


#### CSV ####
df_linelist_csv <- import(file = here("data", "raw", "csv",
                                      "Moissalla-rougeole-liste-lineaire-FR.csv"))



# Explorer les données ---------------------------------------

# Montrer le haut du data frame
head(df_linelist, n = 12)

dim(df_linelist)    # Dimensions
names(df_linelist)  # Noms des colonnes
str(df_linelist)    # Structure
View(df_linelist)   # Voir le data frame comme une table

summary(df_linelist)  # Résumés basiques des colonnes