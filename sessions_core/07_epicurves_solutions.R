# Solutions to the core session 07_epicurves
# Author: the Fetch team
# Creation Date: 03/02/2025
# Last Update: 13/02/2025
# Description: Model code associated with the epicurve session


# Setup ----------------------------------------------------

## Load packages -----------------------------

library(here)        # Better paths
library(rio)         # Import files
library(dplyr)       # Data manipulation
library(ggplot2)     # Todays workhorse


## Import Data ----------------------------------------------------
df_linelist <- import(here("data", "clean", 
                           "moissala_linelist_clean_EN.rds"))


# Check import
str(df_linelist)
head(df_linelist)
View(df_linelist)


# Prepare data ---------------------------------------------

# Count number of cases per date of onset
df_cases <- df_linelist %>%
  count(date_onset)


# Plot epicurve --------------------------------------------

df_cases %>%
  
  # Initialise the plot
  ggplot(aes(x = date_onset,
             y = n)) +
  
  # Add the columns, with the optional fill argument to add color
  geom_col(fill = "#2E4573") +
  
  # Add title, axes titles and caption
  labs(x = "Date of onset",
       y = "Measles Cases",
       title = "Measles cases in Mandoul region (Chad)",
       caption = "Ficticious data") +
  
  # Modify the general theme to improve appearance
  theme_bw(base_size = 16) # you may have chosen an other theme!


# If you use the aggregated dataset only once, you could count on the fly:
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