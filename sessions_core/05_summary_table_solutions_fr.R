# Solutions pour la session 05 tableaux-résumés
# Auteur :  l'equipe FETCH
# Date de création : 08/02/2025
# Derniere mise a jour : 08/02/2025
# Description : Code modèle pour la session 5 (tableaux résumés)

# Charger les paquets ------------------------------------

# Charger les paquets requis pour la session
# Doit être effectuer chaque fois que l'on commence une session R
library(here)
library(rio)
library(tidyverse)

# Importer les données -----------------------------------------

# Importer les données propres après les avoir mes dans le dossier data/clean

df_linelist <- import(file = here("data", "clean", "moissala_linelist_clean_FR.rds"))

# Tableaux croisés -----------------------------------------

df_linelist |>
  count(sous_prefecture, age_groupe)

# Filtrer les NAs -----------------------------------------

# proportions des décédés est aussi appelées Taux de fatalité
# Mais il doit être calculé en utilisant les patients dont l'issue est connue
# on peut donc filtrer avant de counter pour ne garder que les patients avec deces/gueri
df_linelist |>
  filter(
    statut_sortie != "sortie contre avis medical",
    !is.na(statut_sortie)
  ) |>
  count(statut_sortie)

# Ces deux filtres sont equivalents:
df_linelist |>
  filter(
    statut_sortie %in% c("deces", "gueri")
  ) |>
  count(statut_sortie)

# Tableau résumé -----------------------------------------

# Voila le tableau résumé que vous devriez avoir a la fin de l'exercise:

df_linelist |>
  summarize(
    .by = sous_prefecture,
    n_patients = n(),
    moy_age = mean(age),
    min_admission = min(date_admission, na.rm = TRUE),
    n_femme = sum(sexe == "f", na.rm = TRUE),
    n_hosp = sum(hospitalisation == "oui", na.rm = TRUE),
    moy_age_hosp = mean(age[hospitalisation == "oui"], na.rm = TRUE),
    moy_age_female = mean(age[sexe == "f"], na.rm = TRUE),
    n_deces_moins_6m = sum(statut_sortie[age_groupe == "< 6 mois"] == "deces", na.rm = TRUE)
  ) |>
  mutate(
    prop_femme = n_femme / n_patients,
    prop_hosp = n_hosp / n_patients
  )