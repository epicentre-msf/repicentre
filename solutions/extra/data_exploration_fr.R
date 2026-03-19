# Solutions pour la session extra sur l'exploration de données
# Auteur: l'équipe Fetch
# Date de création: 09/02/2025
# Dernière mise à jour: 09/02/2025
# Description: Contient les solutions des exercices de programmation


# Packages ------------------------------------

library(here)
library(rio)
library(dplyr)

# Import des données ------------------------------------
df_linelist <- import(here::here("data", "raw", "moissala_linelist_FR.xlsx"))

# Exploration basique ------------------------------------

dim(df_linelist) # dimensions
nrow(df_linelist) # nombre de lignes
ncol(df_linelist) # nombre de colonnes


# Noms des variables --------------------------------------------------------

names(df_linelist)


# Visualiser les données -----------------------------------------------------

df_linelist # exécuter l'objet seul

head(df_linelist, n = 15) # 15 premières lignes
tail(df_linelist, n = 10) # 10 dernières lignes

View(df_linelist)

# Classe des variables ---------------------------------------------------------

class(df_linelist$age) # l'âge est numérique

class(df_linelist$date_admission) # la date d'admission est un caractère et non une Date

df_linelist$sexe # toutes les valeurs pour le sexe

class(df_linelist$sexe)

# toutes les classes en une fois - augmenter la largeur de la console
str(df_linelist)


# Explorer les variables continues -------------------------------------------

min(df_linelist$age) # Un âge négatif !
max(df_linelist$pb) # pb a des NA donc nous devons explicitement définir na.rm = TRUE
max(df_linelist$pb, na.rm = TRUE)


# Explorer les variables catégorielles -------------------------------------------

count(df_linelist, sexe) # compter toutes les valeurs de sexe

count(df_linelist, sous_prefecture)
