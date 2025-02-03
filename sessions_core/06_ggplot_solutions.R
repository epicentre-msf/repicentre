# Solutions to the core session 06_ggplot
# Author: the Fetch team
# Creation Date: 03/02/2025
# Last Update: 03/02/2025
# Description: Model code associated with the epicurve session


# Setup ----------------------------------------------------

## Load packages -----------------------------

library(here)        # Better paths
library(rio)         # Import files
library(dplyr)       # Data manipulation
library(lubridate)   # Deal with dates
library(ggplot2)     # Todays workhorse


## Import Data ----------------------------------------------------
df_linelist <- import(here("data", "clean", 
                           "simulated_measles_ll.rds"))


# Check import
str(df_linelist)
head(df_linelist)
View(df_linelist)


# Prepare data ---------------------------------------------

# Add floor date of weeks
df_linelist <- df_linelist %>%
  mutate(week_admission = isoweek(date_admission)) 

# Count numbher of cases per week of admission
df_cases <- df_linelist %>%
  count(week_admission)


# Plot epicurve --------------------------------------------

df_cases %>%
  
  # Initialise the plot
  ggplot(aes(x = week_admission,
             y = n)) +
  
  # Add the columns, with the optional fill argument to add color
  geom_col(fill = "#2E4573") +
  
  # Add title, axes titles and caption
  labs(x = "ISO Week",
       y = "Measles Cases",
       title = "Measles in Moissala",
       caption = "Ficticious data") +
  
  # Modify the general theme to improve appearance
  theme_bw(base_size = 18) # you may have chosen an other theme!


# If you use the aggregated dataset only once, you could count on the fly:
df_linelist %>%
  count(week_admission) %>%
  ggplot(aes(x = week_admission,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "ISO Week",
       y = "Measles Cases",
       title = "Measles in Moissala",
       caption = "Ficticious data") +
  theme_bw(base_size = 18)
