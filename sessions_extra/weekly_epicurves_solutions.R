# Solutions to the satellite about weekly epicurves
# Author: the Fetch team
# Creation Date: 03/02/2025
# Last Update: 14/02/2025
# Description: Model code associated with the weekly epicurve with dates satellite


# Setup ----------------------------------------------------

## Load packages -----------------------------

library(here)        # Better paths
library(rio)         # Import files
library(dplyr)       # Data manipulation
library(lubridate)   # Deal with dates
library(ggplot2)     # Todays workhorse
library(scales)      # prettier labels


## Import Data ----------------------------------------------------
df_linelist <- import(here("data", "clean", 
                           "moissala_linelist_clean_EN.rds"))


# Check import
str(df_linelist)
head(df_linelist)
View(df_linelist)


# Prepare data ---------------------------------------------

df_linelist <- df_linelist |>
  mutate(
    # Week ISO NUMBERS
    week_onset_number = isoweek(date_consultation),
    
    # First DATE of the week
    week_onset_monday = floor_date(date_consultation, 
                                     unit = "week",
                                     week_start = 1), # Starts on Monday
    
    # ISO year
    # The first of January 2023 has a 2022 iso year, because 
    # it is still in the 52th ISO week of 2022.
    year_onset = isoyear(date_onset),
    )   


# Plot epicurve --------------------------------------------

# It's very similar to what we did in the core session
df_linelist |> 
  
  # Aggregate (we chose to do it on the fly here, but you could
  # save the aggregated data in its own dataset of you plan to reuse it)
  count(week_onset_monday) |> 
  
  # Do the plot
  ggplot(aes(x = week_onset_monday,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "Date of onset",
       y = "Measles cases",
       title = "Measles in Mandoul region (Chad)",
       caption = "Ficticious data") +
  theme_classic(base_size = 15)


# To focus on the new commands, we are going to save that plot 
# in an object (of course it's possible!)
p <- df_linelist |> 
  count(week_onset_monday) |> 
  ggplot(aes(x = week_onset_monday,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "Date of onset",
       y = "Measles cases",
       title = "Measles in Mandoul region (Chad)",
       caption = "Ficticious data") +
  theme_classic(base_size = 15)

# Print the plot
p



# Tweak frequency of the breaks
p + 
  scale_x_date(date_breaks = '4 months') # Force date breaks to 4 months



# Modify the labels with the scale package
p + 
  scale_x_date( 
    date_breaks = "1 months",               # Force date breaks to one month
    labels = scales::label_date_short())    # Provide labels


# Modify the labels with the strptime syntax
p + 
  scale_x_date(
    date_breaks = "2 months",    # Force date breaks to two months
    date_labels = "%m/%d%n%y")   # strptime syntax




# Extra exercices -------------------------------------


# Using date of consultation
df_linelist |> 
  mutate(week_start = floor_date(date_consultation, 
                                 unit = "week",
                                 week_start = 1)) |> 
  count(week_start) |> 
  ggplot(aes(x = week_start,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "Date of consultation",
       y = "Measles cases",
       title = "Measles consultations in Mandoul region (Chad)",
       caption = "Ficticious data") +
  theme_classic(base_size = 15)



# 2023 data with epiweeks
df_linelist |> 
  filter(year_onset == 2023) |>  # Keep 2023 data only
  count(week_onset_number) |> 
  ggplot(aes(x = week_onset_number,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "ISO Week",
       y = "Measles cases",
       title = "Measles cases in Mandoul region (Chad) - 2023",
       caption = "Ficticious data") +
  theme_classic(base_size = 15)



# Monthly cases
df_linelist |> 
  mutate(month_start = floor_date(date_consultation, 
                                  unit = "month")) |> 
  count(month_start) |> 
  ggplot(aes(x = month_start,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "Month of onset",
       y = "Measles cases",
       title = "Measles in Mandoul region (Chad)",
       caption = "Ficticious data") +
  theme_classic(base_size = 15) +
  scale_x_date(
    date_breaks = "2 months",
    date_labels = "%Y\n%b") 

