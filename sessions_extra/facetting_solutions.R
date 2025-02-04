# Solutions to the facetting satellite
# Author: the Fetch team
# Creation Date: 04/02/2025
# Last Update: 
# Description: Model code associated with the facetting satellite


# Setup ----------------------------------------------------

## Load packages -------------------------------------------

library(here)        # Better paths
library(rio)         # Import files
library(dplyr)       # Data manipulation
library(lubridate)   # Deal with dates
library(ggplot2)     # Todays workhorse


## Import Data ---------------------------------------------
df_linelist <- import(here("data", "clean", 
                           "simulated_measles_ll.rds"))


# Check import
str(df_linelist)
head(df_linelist)
View(df_linelist)


## Prepare Data ---------------------------------------------

# Prepare an aggregated dataset

df_age <- df_linelist %>% 
  # Create week column if not done during the cleaning
  mutate(week_admission = isoweek(date_admission)) %>% 
  
  # Remove the NA values for admission week (avoid warning messages when ploting)
  tidyr::drop_na(week_admission) %>% 
  
  # Count the nomber of patients by week and age group
  count(week_admission, age_group)


# Plot Data -------------------------------------------

# Basic plot
df_age %>%
  ggplot(aes(x = week_admission,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x     = "ISO Week",
       y     = "Measles cases",
       title = 'Measles cases in Chad') +
  theme_classic(base_size = 15) +
  
  facet_wrap(vars(age_group))  # Make subplots

# Play with options
df_age %>%
  ggplot(aes(x = week_admission,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x        = "ISO Week",
       y        = "Measles cases",
       title    = 'Measles cases in Chad',
       subtitle = "Note the y axis") +
  theme_classic(base_size = 15) +
  
  facet_wrap(vars(age_group),
             ncol = 2,           # Control the number of columns
             scales = "free_y")  # Controle the range on y axis


# Extra exercice

# Aggregate by weeks only to plot the grey bars, which are the
# same for all subplots
df_cases <- df_linelist %>% 
  count(week_admission) %>% 
  tidyr::drop_na(week_admission)


ggplot(
  # dataframe used for the subplots  (aggregated by week and age)
  data = df_age,     
  aes(x = week_admission,
      y = n)) +
  
  
  # Plot the gray bars: do not use the df_age dataframe, force another one
  geom_col(data = df_cases,    # dataset for just this layer
           fill = "grey80") +
  
  # Plot the blue bars over the grey ones
  geom_col(fill = "#2E4573") +  # uses df_age, inherited by the mail ggplot command
  
  
  labs(x = "ISO Week",
       y = "Measles Cases",
       title = "Measles in Moissala",
       caption = "Ficticious data") +
  
  theme_classic(base_size = 15) +
  
  facet_wrap(vars(age_group))

