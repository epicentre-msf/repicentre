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



# EXERCICES SUPPÉMENTAIRES ------------------------------------------------------------------------------

# 1. Conditions
vec1 <- c(1, 2, 3, 4, 5)
vec2 <- c(1, 3, 4, 2, 5)

vec1 == vec2
vec1 >= vec2
vec1 %in% vec2
is.na(vec2)

# 2.

"Moissala Ouest" %in% df_linelist$structure

# 3. Filtering

df_linelist %>% filter(prefecture == "Bedaya")
df_linelist %>% filter(fievre != "Oui")
df_linelist %>% filter(tdr_paludisme == "negatif")
df_linelist %>% filter(!is.na(fievre))
df_linelist %>% filter(year(date_admission) == 2023)
df_linelist %>% filter(age_ans >= 15, hospitalisation == "oui")
df_linelist %>% filter(prefecture == "Moissala", structure == "Moissala Est", date_admission < as.Date("2023-02-01"))
df_linelist %>% filter(pb <115, age_mois < 59)


# 4. Cleaning

df_linelist %>% 
  mutate(
    hospitalisation = str_to_title(hospitalisation),
    tdr_paludisme =  str_to_title(tdr_paludisme),
    issue = case_when(
      issue %in% c("mort", "death", "died") ~ "Dead",
      issue  == "gueri" ~ "Recovered",
      issue == "lost" ~ "Lost to follow-up"
    ),
    est_mort = case_when(
      issue == "Dead" ~ TRUE,
      issue %in% c("Recovered", "Lost to follow-up") ~ FALSE,
      .default = NA
    ),
    statut_vaccinal_simple = case_when(
      statut_vaccinal %in% c("Oui - carte", "Oui - oral") ~ "Oui",
      statut_vaccinal == "Non" ~ "Non",
      statut_vaccinal == "Incertain" ~ "Inconnu"
    )
  )

# 5. Simplifier

df_linelist %>% 
  mutate(groupe_age2 = case_when(
    age_mois < 6 ~ "< 6 mois",
    age_mois < 12  ~ "6 - 11 mois",
    age_mois < 59 ~ "12 - 59 mois",
    age_ans <= 15 ~ "5 - 15 ans",
    age_ans > 15 ~ "> 15 ans",
    .default = "Inconnu")
  )

# 6. Résoudre les problèmes

df_linelist %>% 
  mutate(groupe_age2= case_when(
    age_mois < 6 ~ "< 6 mois",
    age_mois < 12 ~ "6 - 11 mois",
    age_mois < 59 ~ "12 - 59 mois",
    age_mois <= 15 ~ "5 - 15 ans",
    age_mois > 15 ~ "> 15 ans",
    .default = 'Inconnu')
  )

## DÉFI -------------------------------------------------------------------------
# 1.
df_linelist %>% 
  filter(prefecture == "Bouna",  year(date_admission) == 2022) %>% 
  export(here('data', 'clean', 'data_hospit_bouna.csv'))

# 2.
df_linelist %>%
  filter(prefecture == "Moissala",
         structure %in% c("Moissala Est", "Moissala Nord", "Moissala Sud", 
                         "Hôpital du District de Moissala")) %>% 
  count(structure)

# 3.
df_linelist %>% 
  count(id) %>% 
  filter(n > 1) %>% 
  export(here('data', 'clean', 'check_duplicates.xlsx'))

