# Solutions de la session sur les bases de la manipulation de données
# Auteurices :  l'équipe du FETCH
# Date de création : 10/02/2025
# Dernière mise à jour : 17/02/2025
# Description : Exemple de code pour les concepts de la session de manipulation de données de base.


# Paquets --------------------------------------------------

library(here)
library(rio)
library(tidyverse)


# Import des données ---------------------------------------------------
df_brut <- import(file = here("data", "raw", "moissala_linelist_FR.xlsx"))


# BASIC CLEANING PIPE --------------------------------------
df_linelist <- df_brut |>
  
  # Ne garder que les colonnes que l'on veut
  select(-nom_complet, -unite_age) |>
  
  # Renommer certaines colonnes
  rename(age_mois = age,
         prefecture = sous_prefecture,
         village = village_commune,
         structure = nom_structure_sante) |>
  
  # Corriger le format de certaines colonnes, ajouter l'age en années
  mutate(age_ans = age_mois / 12,
         region = str_to_title(region),
         prefecture = str_to_title(prefecture),
         date_debut = ymd(date_debut),
         date_consultation = ymd(date_consultation),
         date_admission = ymd(date_admission),
         date_issue = ymd(date_issue)) |>
  
  # supprimer les doublons
  distinct()
  