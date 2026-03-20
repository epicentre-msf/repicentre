# Solutions to the core session Data Manipulation with Conditional Logic
# Author:  the Fetch team
# Creation Date: 10/02/2025
# Last Update: 12/02/2025
# Description: Shows a model output for the concepts in the data manipulation with conditional logic session

# PACKAGES -----------------------------------------------------------------------------------------
library(here)
library(rio)
library(tidyverse)


# IMPORT -------------------------------------------------------------------------------------------
df_raw <- import(file = here("data", "raw", "moissala_linelist_EN.rds"))


# BASIC CLEANING PIPE ------------------------------------------------------------------------------
df <- df_raw |>
  # select what to keep and rename as needed
  select(-full_name, -age_unit) |>
  rename(age_months = age,
         prefecture = sub_prefecture,
         village = village_commune,
         facility = health_facility_name) |>
  # update column formats and add age in years
  mutate(age_years = age_months / 12,
         region = str_to_title(region),
         prefecture = str_to_title(prefecture),
         date_onset = ymd(date_onset),
         date_consultation = ymd(date_consultation),
         date_admission = ymd(date_admission),
         date_outcome = ymd(date_outcome),
         age_group = case_when(age_months < 6 ~ '< 6 months',
                               age_months < 12 ~ '6 - 11 months',
                               age_years < 5 ~ '12 - 59 months',
                               age_years <= 15 ~ '5 - 15 years',
                               age_years > 15 ~ '> 15 years',
                               .default = 'Unknown'),
         sex = case_when(sex %in% c("f", "female", "femme") ~ "Female",
                         sex %in% c("m", "male", "homme") ~ "Male",
                         .default = "Unknown")) |>
  # remove duplicates
  distinct()

