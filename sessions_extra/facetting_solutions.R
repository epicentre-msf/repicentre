# Solutions to the facetting satellite
# Author: the Fetch team
# Creation Date: 04/02/2025
# Last Update: 13/02/2025
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
                           "moissala_linelist_clean_EN.rds"))


# Check import
str(df_linelist)
head(df_linelist)
View(df_linelist)


## Prepare Data ---------------------------------------------

# Prepare an aggregated dataset

df_age <- df_linelist %>% 

  # Remove the NA values for admission week (avoid warning messages when ploting)
  tidyr::drop_na(date_onset) %>% 
  
  # Count the nomber of patients by week and age group
  count(date_onset, age_group)


# Plot Data -------------------------------------------

# Basic plot
df_age %>%
  ggplot(aes(x = date_onset,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = 'Date of onset',
       y = 'Measles Cases',
       title = 'Measles in Mandoul region (Chad)',
       caption = 'Ficticious data') +
  theme_classic(base_size = 15) +
  
  facet_wrap(vars(age_group))  # Make subplots

# Play with options
df_age %>%
  ggplot(aes(x = date_onset,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = 'Date of onset',
       y = 'Measles Cases',
       title = 'Measles in Mandoul region (Chad)',
       caption = 'Ficticious data') +
  theme_classic(base_size = 15) +
  
  facet_wrap(vars(age_group),
             ncol = 2,           # Control the number of columns
             scales = "free_y")  # Controle the range on y axis


# Extra exercice

# Aggregate by weeks only to plot the grey bars, which are the
# same for all subplots
df_cases <- df_linelist %>% 
  count(date_onset) %>% 
  tidyr::drop_na(date_onset)


ggplot(
  # dataframe used for the subplots  (aggregated by week and age)
  data = df_age,     
  aes(x = date_onset,
      y = n)) +
  
  
  # Plot the gray bars: do not use the df_age dataframe, force another one
  geom_col(data = df_cases,    # dataset for just this layer
           fill = "grey80") +
  
  # Plot the blue bars over the grey ones
  geom_col(fill = "#2E4573") +  # uses df_age, inherited by the mail ggplot command
  
  
  labs(x = 'Date of onset',
       y = 'Measles Cases',
       title = 'Measles in Mandoul region (Chad)',
       caption = 'Ficticious data') +
  
  theme_classic(base_size = 15) +
  
  facet_wrap(vars(age_group))

