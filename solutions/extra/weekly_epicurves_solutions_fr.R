# Solutions pour la session satellite sur les courbes épidémiques par semaines
# Auteur: l'équipe Fetch
# Date de création: 09/02/2025
# Dernière mise à jour: 24/02/2025
# Description: Contient les solutions des exercices de programmation


# Paquets ------------------------------------

library(here)
library(rio)
library(dplyr)

# Import des données ------------------------------------
df_linelist <- import(here("data", "clean", 
                           "moissala_linelist_clean_FR.rds"))



# Check import
str(df_linelist)
head(df_linelist)
View(df_linelist)


# Préparation des données---------------------------------------------

df_linelist <- df_linelist |>
  mutate(
    # Nombre ISO de la semaine
    sem_symptomes_num = isoweek(date_debut),
    
    # première DATE de la semaine
    sem_symptomes_lundi = floor_date(date_debut, 
                                   unit = "week",
                                   week_start = 1), # Début semaine = lundi
    
    # Année ISO
    # Le premier janvier 2023 a une année ISO 2022 car le premier 
    # janvier 2023 fait partie de la semaine 52 de 2022 (norme ISO)
    annee_symptomes = isoyear(date_debut),
  )   


# Graphe --------------------------------------------

# Le code ressemble à ce que l'on a fait précedement
df_linelist |> 
  
  # Agrège les données 
  # Ici nous avons choisi de le faire directement dans le "pipr"
  # mais nous aurions pu enregistrer le data frame dans la mémoire
  # si nous voulions le réutiliser plus tard.
  count(sem_symptomes_lundi) |> 
  
  # Trace le graphique
  ggplot(aes(x = sem_symptomes_lundi,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "Semaine de début des symptômes",
       y = "Patients",
       title = "Cas de rougeole dans la région de Mandoul (Tchad)",
       caption = "Données fictives") +
  theme_classic(base_size = 15)


# Pour nous concentrer sur les nouvelles commandes, nous llons enregistrer
# notre graphique dans un objet (bien sûr que c'est possible !)
p <- df_linelist |> 
  count(sem_symptomes_lundi) |> 
  ggplot(aes(x = sem_symptomes_lundi,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "Semaine de début des symptômes",
       y = "Patients",
       title = "Cas de rougeole dans la région de Mandoul (Tchad)",
       caption = "Données fictives") +
  theme_classic(base_size = 15)

# Afficher le graphique
p



# Modifier la fréquence des tirets
p + 
  scale_x_date(date_breaks = '4 months')  # Intervalle de 4 mois



# Modifier les étiquettes avec le paquet scales
p + 
  scale_x_date( 
    date_breaks = "1 months",               # Intervalle de 1 mois
    labels = scales::label_date_short())    # Etiquettes automatiques


# Modifier les étiquettes avec la syntaxe strptime
p + 
  scale_x_date(
    date_breaks = "2 months",    # Intervalle de 2 mois
    date_labels = "%m/%d%n%y")   # syntaxe strptime




# Exercices supplémentaires -------------------------------------


# Date de consultation
df_linelist |> 
  mutate(week_start = floor_date(date_consultation, 
                                 unit = "week",
                                 week_start = 1)) |> 
  count(week_start) |> 
  ggplot(aes(x = week_start,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "Semaine de consultation",
       y = "Patients",
        title = "consultations rougeole dans la région de Mandoul (Tchad)",
       caption = "Données fictives") +
  theme_classic(base_size = 15)



# Données 2023 avec numéros de semaine épi
df_linelist |> 
  filter(annee_symptomes == 2023) |>  # Keep 2023 data only
  count(sem_symptomes_num) |> 
  ggplot(aes(x = sem_symptomes_num,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "Semaines ISO",
       y = "Patients",
       title = "Cas rougeole dans la région de Mandoul (Tchad) - 2023",
       caption = "Données fictives") +
  theme_classic(base_size = 15)



# Courbe mensuelle
df_linelist |> 
  mutate(month_start = floor_date(date_debut, 
                                  unit = "month")) |> 
  count(month_start) |> 
  ggplot(aes(x = month_start,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "Mois de début des symptomes",
       y = "Patients",
       title = "Cas de rougeole dans la région de Mandoul (Tchad)",
       caption = "Données fictives") +
  theme_classic(base_size = 15) +
  scale_x_date(
    date_breaks = "2 months",
    date_labels = "%Y\n%b") 

