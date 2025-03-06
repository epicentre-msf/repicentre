# Solutions pour la session 05 tableaux résumés
# Auteurs : l'equipe FETCH
# Date de création : 08/02/2025
# Derniere mise a jour : 06/03/2025
# Description : code modèle pour la session 5 (tableaux résumés)


# Charger les paquets --------------------------------------

# Doit être effectuer chaque fois que l'on commence une session R
library(here)
library(rio)
library(tidyverse)


# Importer les données -------------------------------------

# Importer les données propres après les avoir mises dans le dossier data/clean
df_linelist <- import(file = here("data", "clean", "moissala_linelist_clean_FR.rds"))



# Tableaux d'effectifs -------------------------------------

# Effectifs croisés entre deux variables (tableau croisé)
df_linelist |>
  count(sous_prefecture, age_groupe)



## Létalité --------------------------------------------

# Proportions des décédés (aussi appelé létalité ou mortalité)
# Doit être calculé sur les patients dont le statut à la sortie est connu
# Il faut donc filtrer avant de compter pour ne garder que les patients avec déces/gueri
df_linelist |>
  filter(
    statut_sortie != "sortie contre avis medical",
    !is.na(statut_sortie)  # N'est pas NA
  ) |>
  count(statut_sortie)


# Solution alternative :
df_linelist |>
  filter(
    statut_sortie %in% c("deces", "gueri")
  ) |>
  count(statut_sortie)


## Tableau final -----------------------------------------

df_linelist |>
  summarize(
    .by = sous_prefecture,
    
    n_patients       = n(),
    moy_age          = mean(age),
    min_admission    = min(date_admission, na.rm = TRUE),
    n_femme          = sum(sexe == "f", na.rm = TRUE),
    n_hosp           = sum(hospitalisation == "oui", na.rm = TRUE),
    moy_age_hosp     = mean(age[hospitalisation == "oui"], na.rm = TRUE),
    moy_age_female   = mean(age[sexe == "f"], na.rm = TRUE),
    n_deces_moins_6m = sum(statut_sortie[age_groupe == "< 6 mois"] == "deces", na.rm = TRUE)
  ) |>
  
  # Ajoute des proportions :
  mutate(
    prop_femme = n_femme / n_patients,
    prop_hosp  = n_hosp / n_patients
  )


# Exercices supplémentaires --------------------------------


# 1) Table par classe d'âge

df_linelist |>
  summarize(
    .by = age_groupe,
    n_patients = n(),
    n_homme    = sum(sexe == "m", na.rm = TRUE),
    prop_homme = n_homme / n_patients,
    n_deces    = sum(statut_sortie == "deces", na.rm = TRUE),
    
    # Récupère le nombre de patients avec sortie connue (dénominateur létalité)
    n_sorties_valides = sum(statut_sortie %in% c("deces", "gueri"), na.rm = TRUE),
    letalite = n_deces / n_sorties_valides * 100,
    n_mort_pneumo = sum(statut_sortie[pneumonie == 1] == "deces", na.rm = TRUE)
  ) |>
  
  # Garde seulement les variables qui nous intéressent
  select(
    age_groupe,
    prop_homme,
    n_deces,
    letalite,
    n_mort_pneumo
  )



# 2) Table de la vaccination par classe d'âge
df_linelist |>
  summarize(
    .by = age_groupe,
    
    n_patients = n(),
    n_vacc = sum(vacc_status %in%c("Oui - oral","Oui - carte"), na.rm = TRUE),
    n_vacc_une_dose = sum(vacc_doses %in% c("1 dose"), na.rm = TRUE),
    n_vacc_deux_doses = sum(vacc_doses %in% c("2 doses"), na.rm = TRUE),
    
    # Ajoute les proportions : on peut le faire à l'intérieur du summarise aussi
    prop_vacc            = n_vacc / n_patients,
    prop_vacc_une_dose   = n_vacc_une_dose / n_patients,
    prop_vacc_deux_doses = n_vacc_deux_doses / n_patients
  ) 

# 3) Tableau des signes, symptomes et statut palu en fonction du statut d'hospitalisation

df_linelist |>
  # Enlever les patients sans statut d'hospitalisation
  drop_na(hospitalisation) |>
  
  summarize(
    .by = hospitalisation,
    
    n_patients = n(),
    
    n_malaria    = sum(rdt_palu == "positif", na.rm = TRUE),
    prop_malaria = n_malaria / n_patients,
    
    n_fievre    = sum(fievre, na.rm = TRUE),
    prop_fievre = n_fievre / n_patients,
    
    n_eruption    = sum(eruption_cutanee, na.rm = TRUE),
    prop_eruption = n_eruption / n_patients,
    
    n_cough = sum(toux, na.rm = TRUE),
    prop_cough = n_cough / n_patients,
    
    n_yeux_rouges = sum(yeux_rouges, na.rm = TRUE),
    prop_yeux_rouges = n_yeux_rouges / n_patients,
    
    n_pneumonie = sum(pneumonie, na.rm = TRUE),
    prop_pneumonie = n_pneumonie / n_patients,
    
    n_encephalite = sum(encephalite, na.rm = TRUE),
    prop_encephalite = n_encephalite / n_patients,
    
    n_mag = sum(pb < 125, na.rm = TRUE),  # Malnutrition Aïgue Globale
    prop_mag = n_mag / n_patients
  ) |>
  select(hospitalisation, n_patients, 
         prop_malaria, prop_fievre, prop_eruption, prop_cough, 
         prop_yeux_rouges, prop_pneumonie, prop_encephalite, 
         prop_mag)


# 4) Délai de consultation par sous-préfecture
df_linelist |>
  summarize(
    .by = sous_prefecture,
    n   = sum(!is.na(date_consultation) & !is.na(date_debut)),
    delai_moyen = mean(date_consultation - date_debut) )


# 5) Durée de séjour par type de sortie
df_linelist|>
  mutate(duree_sejour = date_sortie - date_admission)|>
  drop_na(duree_sejour, statut_sortie)|>
  summarize(
    .by = statut_sortie,
    n = n(),
    duree_sejour_moyenne = mean(duree_sejour)
  )

