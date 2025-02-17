# Manipulation de données de base : Solutions
# Author :  the Fetch team
# Creation Date : 10/02/2025
# Last Update : 10/02/2025
# Description : Exemple de code pour les concepts de la session de manipulation de données de base.


# PACKAGES -----------------------------------------------------------------------------------------
library(here)
library(rio)
library(tidyverse)


# IMPORT -------------------------------------------------------------------------------------------
df_raw <- import(file = here("data", "raw", "moissala_linelist_EN.xlsx"))


# BASIC CLEANING PIPE ------------------------------------------------------------------------------
df <- df_raw |>
  # sélectionner ce qu'il faut garder et renommer si nécessaire
  select(-full_name, -age_unit) |>
  rename(age_months = age,
         prefecture = sub_prefecture,
         village = village_commune,
         facility = health_facility_name) |>
  # mettre à jour le format des colonnes et ajouter l'âge en années
  mutate(age_years = age_months / 12,
         region = str_to_title(region),
         prefecture = str_to_title(prefecture),
         date_onset = ymd(date_onset),
         date_consultation = ymd(date_consultation),
         date_admission = ymd(date_admission),
         date_outcome = ymd(date_outcome)) |>
  # supprimer les doublons
  distinct()

