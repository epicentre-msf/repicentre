# Solutions pour le satellite du module surveillance
# Auteurs : l'équipe du FETCH
# Dernière mise à jour :  07/04/2025
# Description : Code modèle associé avec le module de surveillance

# Note : ici nous avons rassemblé le code pour le nettoyage et
# la préparation des données dans un seul script pour faciliter
# le téléchargement. C'est possible de faire ça : le projet est 
# court. Néanmoins, séparer le code du nettoyage des données et
# de l'analyse comme nous vous avons fait faire dans le tutoriel
# est souvent une bonne pratique pour des projets un peu plus longs,
# avec un nettoyage et des analyses plus conséquentes.
# Nous pourrions avoir des documents Rmarkdown ou Quarto dans le
# projet pour créer des raports automatiquement basés sur les
# résultats.


# Mise en place ----------------------------------------------------

## Chargement des paquets-----------------------------------

library(here)      # Chemins d'accès
library(rio)       # Import et export des données
library(dplyr)     # Traitement des données
library(tidyr)     # Traitement des données
library(ggplot2)   # Graphiques
library(stringr)   # Nettoyage des chaînes de caractères
library(lubridate) # Dates
library(zoo)       # Somme cumulée glissante.


## Importation des ddonnées ---------------------------------

## !!! Ouvrez les fichiers dans un tableur avant de tenter l'import !!!

# Données de surveillance
df_surv_brut <- import(here("data", "raw", "data_ids_sem20_2022_fr.xlsx"))

# Données de laboratoire
df_labo_brut <- import(
  here("data", "raw", "data_labo_sem20_2022_fr.xlsx"), 
  skip = 7  # Saute les 7 premières lignes
) 


# vérification importation
str(df_surv_brut)
head(df_surv_brut)
View(df_surv_brut)

str(df_labo_brut)
head(df_labo_brut)
View(df_labo_brut)



# Nettoyage des données ------------------------------------


## Surveillance --------------------------------------------


### Exploration rapide -------------------------------------
names(df_surv_brut)
head(df_surv_brut)

# Compte le nombre de lignes par ZS
zs_check <- df_surv_brut |> count(zone_sante)

# Vérifie qu'il y a bien 68 zones de santé
nrow(zs_check)

## Oups, il n'y en a que 63 : cinq zones n'ont pas fait remonter
# leurs données.

# Est-ce que les semaines vont bien de 1 à 20
min(df_surv_brut$semaine)
max(df_surv_brut$semaine)

# Nombre de cas par semaines
summary(df_surv_brut$totalcas)

# Nombre de décès par semaines
summary(df_surv_brut$totaldeces)


### Nettoyage et prep --------------------------------------

df_surv <- df_surv_brut |> 
  
  ## Nettoie le texte
  mutate(
    
    # Passe en minuscules
    pays       = tolower(pays),
    province   = tolower(province),
    zone_sante = tolower(zone_sante),
    maladie    = tolower(maladie),
    
    # Nettoie les espaces surnuméraires
    province   = str_squish(province),
    zone_sante = str_squish(zone_sante),
    
    # Transforme les espaces ou tirets "haut" en tiret "bas"
    province = str_replace(province, pattern = "-", replacement = "_"), 
    province = str_replace(province, pattern = " ", replacement = "_"),
    zone_sante = str_replace(zone_sante, pattern = "-", replacement = "_"), 
    zone_sante = str_replace(zone_sante, pattern = " ", replacement = "_"),
    
    # Calcule le nombre de cas de moins de cinq mois
    cas_moins_5ans = cas011mois + cas1259mois
  ) |> 
  
  # Trie les données par province, ZS puis semaines (dans cet ordre)
  arrange(province, zone_sante, semaine)


# Crée jeu de donnes de surveillance avec une ligne par semaine
df_surv_sem <- df_surv |> 
  select(province, zone_sante, semaine, totalcas, totaldeces) |>
  
  complete(
    nesting(province, zone_sante),
    semaine = seq(min(semaine, na.rm = TRUE), 
                 max(semaine, na.rm = TRUE)),
    fill = list(totalcas = 0, 
                totaldeces = 0)
  ) |> 
  
  ## Prépare les colonnes d'alerte
  mutate(
    # 20 cases or more
    cas20 = case_when(
      totalcas >= 20 ~ 1, 
      .default = 0)) |>
  
  # Indicateur cumulé, calculé par zone de santé
  mutate(
    
    # Groupe par province et zone de santé
    .by = c(province, zone_sante),
    
    # Somme glissante sur trois semaines (fonction du paquet zoo)
    cas_cumu = rollapply(totalcas, 
                       width = 3,        # Taille semaine
                       sum,              # fonction à appliquer
                       na.rm = TRUE,     # gérer les NA dans la sum
                       align = "right",  # Somme des semaines passées
                       partial = TRUE    # autorise somme partielle au début
                       )
  ) |> 
  
  mutate(    
    # Indicateur binaire pour les 35 cas cumulés
    cas_cumu35 = case_when(
      cas_cumu >= 35 ~ 1, 
      .default = 0),
    
    # Indicateur d'alerte combiné
    # Le OU logique est testé avec l'opérateur `|`
    alerte = case_when(
      (cas20 == 1 | cas_cumu35 == 1) ~ 1, 
      .default = 0)
  )



## Laboratoire ---------------------------------------------

### Exploration rapide -------------------------------------

names(df_labo_brut)
head(df_labo_brut)

# Check des catégories
df_labo_brut |> distinct(igm_rougeole)
df_labo_brut |> distinct(igm_rubeole)


### Nettoyage et prep ----------------------------------------------

df_labo <- df_labo_brut |> 
  mutate(
    
    # Nettoyage du texte
    zone_sante = tolower(zone_sante),                # Minuscules
    zone_sante = str_squish(zone_sante),             # Espaces surnuméraires
    zone_sante = str_replace(zone_sante, "-", "_"),  # Remplace - par _
    zone_sante = str_replace(zone_sante, " ", "_"),  # Remplace espace par _
    
    # Recode les catgories des tests IGM
    igm_rougeole = case_when(
      igm_rougeole == 'pos' ~ 'positif', 
      igm_rougeole == 'neg' ~ 'negatif', 
      .default = igm_rougeole),
    
    igm_rubeole = case_when(
      igm_rubeole == 'pos' ~ 'positif', 
      igm_rubeole == 'neg' ~ 'negatif', 
      .default = igm_rubeole),
    
    collecte_echantillon = ymd(collecte_echantillon)
  )


# Est-ce que le recodage est correct ?
df_labo |> distinct(igm_rougeole)
df_labo |> distinct(igm_rubeole)




# Analyses --------------------------------------------------

## Quatre zones ----------------------------------------------

# Pour faciliter l'exploration, nous créons un data frame plus
# petit ne contenant que quatre zones de santé
data_alerte <- df_surv_sem |> 
  filter(zone_sante %in% c("dilolo", "kowe" ,"kampemba", "lwamba"))


# Quelles ZS sont en alerte en semaine 20 ?
data_alerte |>
  filter(semaine == 20) |>
  arrange(desc(alerte))

# Il y en aurait 63 si nous regardions le jeu de données complet
# df_surv_sem |>
#   filter(semaine == 20) |>
#   arrange(desc(alerte))


# Vecteur des zones de santé en alerte en semaine 20
alerte_zs <- data_alerte |>
  filter(semaine == 20,
         alerte == 1) |>
  pull(zone_sante) # transformer une colonne de data frame en vecteur

# Ou tapé à la main :
# alerte_zs <- c("kampemba", "lwamba")



## Courbe épidémique ---------------------------------------

p_epi <- data_alerte |>
  filter(zone_sante %in% alerte_zs) |>
  ggplot(aes(x = semaine, 
             y = totalcas)) + 
  geom_col(fill = "#2E4573") + 
  labs(x = "Semaine",
       y = "N cas",
       title = "Zones de santé en alerte") +
  theme_bw(base_size = 15) +
  facet_wrap(vars(zone_sante))   # Un graphe par ZS

p_epi


## Indicateurs clés ----------------------------------------

### Première semaine en alerte -----------------------------
first_alerte <- data_alerte |>
  filter(alerte == 1) |>
  summarise(
    .by = zone_sante,
    min_alerte = min(semaine))

first_alerte


### Surveillance -------------------------------------------
table_surv <- df_surv |>
  filter(zone_sante %in% alerte_zs) |>
  mutate(cas_moins_5ans = cas011mois + cas1259mois) |>
  summarise(
    .by = zone_sante,
    
    n_cas     = sum(totalcas, na.rm = TRUE),
    n_deces   = sum(totaldeces, na.rm = TRUE),
    n_moins_5 = sum(cas_moins_5ans, na.rm = TRUE),
    p_moins_5 = scales::percent(n_moins_5 / n_cas, accuracy = 0.1),
    mortalite = scales::percent(n_deces / n_cas, accuracy = 0.1)
  )

table_surv


### Laboratoire --------------------------------------------
table_lab <- df_labo |>
  filter(zone_sante %in% alerte_zs) |>
  
  summarise(
    .by = zone_sante,
    
    n_test_meas        = sum(!is.na(igm_rougeole)),
    n_test_meas_pos    = sum(igm_rougeole == "positive", na.rm = TRUE),
    positivity_measles = scales::percent(n_test_meas_pos / n_test_meas, 
                                    accuracy = 0.1),
    
    n_test_rub         = sum(!is.na(igm_rubeole)),
    n_test_rub_pos     = sum(igm_rubeole == "positive", na.rm = TRUE),
    positivity_rubella = scales::percent(n_test_rub_pos / n_test_rub, 
                                    accuracy = 0.1)
  )

table_lab




# Sauvegarde les données / exporte les résultats -----------

## Sauvegarde données nettoyées-----------------------------

# Surveillance
export(df_surv, 
       file = here("data", "clean", "data_ids_2022-sem20_propre.rds"))

# Completé avec les semaines manquantes
export(df_surv_sem, 
       file = here("data", "clean", "IDS_clean_complete_semaines.rds"))

# Labo
export(df_labo,
       file = here("data", "clean", "lab_clean.rds"))

## Exporte resultats ---------------------------------------

# Il est utile d'exporter les résultats si vous voulez les utiliser dans
# un autre document (un script Rmarkdown par exemple). Vous pouvez rassembler
# des objets de types différents (graphiques, data frames...) en une liste,
# qui peut être sauvée en une fois.

# Crée une liste contenant des objects divers
list_results <- list(
  alerte_20    = alerte_20, 
  first_alerte = first_alerte, 
  p_epi        = p_epi, 
  table_surv   = table_surv, 
  table_lab    = table_lab)


# Exporte la liste au format RDS
list_results |>
  export(file = here("output", "list_results.rds"))