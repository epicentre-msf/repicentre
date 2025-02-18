# Solutions pour le recodage et le filtrage des données
# Auteur :  l'équipe FETCH-R
# Date de création : 18/02/2025
# Mise à jour : 18/02/2025
# Description :  Code modèle pour nettoyer les données, avec les étapes de la session 3 et 4


# PACKAGES -------------------------------------------------
library(here)
library(rio)
library(tidyverse)


# IMPORT ---------------------------------------------------
df_brut <- import(file = here("data", "raw", "moissala_linelist_FR.rds"))


# PIPELINE DE NETTOYAGE BASIQUE -----------------------------

df_linelist <- df_brut |>
  # Sélectionne les colonnes à garder
  select(-nom_complet, -unite_age) |>
  
  # Renomme certaines colonnes
  rename(
    age_mois = age,
    prefecture = sous_prefecture,
    village = village_commune,
    structure = nom_structure_sante) |>
  
  mutate(
    # Calcule l'age en années et change le format du texte
    age_ans = age_mois / 12,
    region = stringr::str_to_title(region),
    prefecture = stringr::str_to_title(prefecture),
    
    # Passe les dates en format "Date"
    date_debut = lubridate::ymd(date_debut),
    date_consultation = lubridate::ymd(date_consultation),
    date_admission = lubridate::ymd(date_admission),
    date_issue = lubridate::ymd(date_issue),
    
    # Nettoie la colonne sexe
    sexe = case_when(
      sexe %in% c("f", "femme", "femme") ~ "Femme",
      sexe %in% c("h", "homme", "homme") ~ "Homme",
      .default = "Inconnu"),
    
    # Crée une variable contenant les groupes d'âge
    groupe_age = case_when(
      age_mois < 6 ~ '< 6 mois',
      age_mois < 12 ~ '6 - 11 mois',
      age_ans < 5 ~ '12 - 59 mois',
      age_ans <= 15 ~ '5 - 15 ans',
      age_ans > 15 ~ '> 15 ans',
      .default = 'Inconnu'),
    ) |>
  # Enlève les duplicats
  distinct()
