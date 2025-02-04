# Solutions to the satellite about epicurves with dates
# Author: the Fetch team
# Creation Date: 03/02/2025
# Last Update: 03/02/2025
# Description: Model code associated with the epicurve with dates lesson.


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
                           "simulated_measles_ll.rds"))


# Check import
str(df_linelist)
head(df_linelist)
View(df_linelist)


# Prepare data ---------------------------------------------

df_linelist <- df_linelist %>%
  mutate(
    # Week NUMBERS
    week_consultation = isoweek(date_consultation),
    week_outcome   = isoweek(date_outcome),    
    
    # First DATE of the week
    week_first_day_cons = floor_date(date_consultation, 
                                     unit = "week",
                                     week_start = 1),   # Start on monday
    
    week_first_day_outcome = floor_date(date_outcome,   
                                        unit = "week",
                                        week_start = 1)
  )  %>% 
  filter(year(date_consultation) == 2022)  # Keep 2022 data


# Aggregated dataset (alternatively you could just summarise 
# data in the same pipe as your plotting command)

df_week <- df_linelist %>% 
  count(week_first_day_cons)

# Plot epicurve --------------------------------------------

# No tweaking axis: it's very similar to what we did in the other session!
df_week %>% 
  ggplot(aes(x = week_first_day_cons,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "Date of consultation",
       y = "Measles cases",
       title = "Measles in Moissala - 2022",
       caption = "Ficticious data") +
  theme_classic(base_size = 15)


# To focus on the new commands, we are going to save that plot 
# in an object (of course it's possible!)
p <- df_week %>% 
  ggplot(aes(x = week_first_day_cons,
             y = n)) +
  geom_col(fill = "#2E4573") +
  labs(x = "Date of consultation",
       y = "Measles cases",
       title = "Measles in Moissala - 2022",
       caption = "Ficticious data") +
  theme_classic(base_size = 15)

# Print the plot
p



# Tweak frequency of the breaks
p + 
  scale_x_date(date_breaks = '1 months') # Force date breaks to one month



# Modify the labels with the scale package
p + 
  scale_x_date( 
    date_breaks = "1 months",               # Force date breaks to one month
    labels = scales::label_date_short())    # Provide labels


# Modify the labels with the strptime syntax
p + 
  scale_x_date(
    date_breaks = "1 months",    # Force date breaks to one month
    date_labels = "%m/%d%n%y")   # strptime syntax