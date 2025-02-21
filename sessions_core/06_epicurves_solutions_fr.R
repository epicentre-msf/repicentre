# Code modèle pour la session 07_epicurves
# Auteurices : the Fetch team
# Date création : 03/02/2025
# Date modification : 13/02/2025
# Description : Code pour créer une courbe épi du nombre de cas par jour de début des symptomes.


# Setup ----------------------------------------------------

## Charger les paquets -----------------------------

library(here)        # Chemins de fichier
library(rio)         # Import des fichiers
library(dplyr)       # Gestion de données
library(ggplot2)     # THE paquet pour faire des graphes


## Importe les données -------------------------------------
df_linelist <- import(here("data", "clean", 
                           "moissala_linelist_clean_EN.rds"))


# Vérifications de l'import
str(df_linelist)
head(df_linelist)
View(df_linelist)


# Preparer les données -------------------------------------

# Compte le nombre de cas par jour de date de début de symptomes
df_cases <- df_linelist %>%
  count(date_onset)


# Tracer la courbe --------------------------------------------

df_cases %>%
  
  # Initialisation du graphique
  ggplot(aes(x = date_onset,
             y = n)) +
  
  # Ajoute les bares / bâtons
  # L'argument fill est optionnel et remplit les barres
  geom_col(fill = "#2E4573") +
  
  # Ajouter un titre, des titres d'axes, et une légende
  labs(x = "Date of onset",
       y = "Measles Cases",
       title = "Measles cases in Mandoul region (Chad)",
       caption = "Ficticious data") +
  
  # Modifie le thème du graphe
  theme_bw(base_size = 16) 


# Si vous n'utilisez le jeu de données aggrégées qu'une seule fois,
# vous pouvez faire le décompte directement dans le pipe avant de tracer le graphe
df_linelist %>%
  count(date_onset) %>%
  ggplot(aes(x = date_onset,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "Date of onset",
       y = "Measles Cases",
       title = "Measles cases in Mandoul region (Chad)",
       caption = "Ficticious data") +
  theme_bw(base_size = 16)