# Solutions du satellite sur le facetting
# Auteurices : the Fetch team
# Date de création : 04/02/2025
# Dernière mise à jour: 14/02/2025
# Modèle code pour créer des graphes avec de multiples facettes


# Setup ----------------------------------------------------

## Charger les paquets -------------------------------------

library(here)        # Chemins d'accès robustes
library(rio)         # Import de fichiers
library(dplyr)       # Verbes gestion données
library(ggplot2)     # Création de graphiques


## Importer les données ------------------------------------
df_linelist <- import(here("data", "clean", 
                           "moissala_linelist_clean_FR.rds"))


# Vérification de l'import
str(df_linelist)
head(df_linelist)
View(df_linelist)


## Preparer les données  -----------------------------------

# Jeu de données aggrégées : compte le nombre de patients par 
# jour (de début des symptomes)
df_age <- df_linelist %>% 
  count(date_debut, age_groupe)


# Graphiques ------------------------------------------------

# Graphique de base
df_age %>%
  ggplot(aes(x = date_debut,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "Date d'apparition des symptomes",,
       y = "Cas de rougeole",,
       title = "Cas de rougeole dans la région de Mandoul (Tchad)",
       caption =  'Données fictives') +
  theme_classic(base_size = 15) +
  
  facet_wrap(vars(age_groupe))  # Crée les mini plots / facettes


# Modifions des options des facettes
df_age %>%
  ggplot(aes(x = date_debut,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "Date d'apparition des symptomes",,
       y = "Cas de rougeole",,
       title = "Cas de rougeole dans la région de Mandoul (Tchad)",
       caption =  'Données fictives') +
  theme_classic(base_size = 15) +
  
  facet_wrap(vars(age_groupe),
             ncol = 2,           # Controle le nombre de colonnes
             scales = "free_y")  # Controle les extrémités des axes



# Exercice avancé ------------------------------------------------------

# Jeu de données aggrégé seulement par jour. Utilisé pour les
# barres grises qui sont les mêmes pour toutes les cases
df_cases <- df_linelist %>% 
  count(date_debut)


ggplot() +  # Initialise le graphique
  
  # Trace les barres grises
  geom_col(data = df_cases,    # data frame juste pour cette couche
           aes(x = date_debut,
               y = n),
           fill = "grey80") +
  
  # Trace les barres bleues au dessus des barres grises, avec un autre data frame
  geom_col(data = df_age,
           aes(x = date_debut,
               y = n),
           fill = "#2E4573") +
  
  labs(x = "Date d'apparition des symptomes",,
       y = "Cas de rougeole",,
       title = "Cas de rougeole dans la région de Mandoul (Tchad)",
       caption =  'Données fictives') +
  
  theme_classic(base_size = 15) +
  
  facet_wrap(vars(age_groupe))

