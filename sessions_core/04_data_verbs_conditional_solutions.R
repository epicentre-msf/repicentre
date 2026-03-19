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

# EXTRA EXERCICES ------------------------------------------------------------------------------

# 1. Conditions
vec1 <- c(1, 2, 3, 4, 5)
vec2 <- c(1, 3, 4, 2, 5)

vec1 == vec2
vec1 >= vec2
vec1 %in% vec2
is.na(vec2)

# 2.

"Moissala Ouest" %in% df$facility

# 3. Filtering

df |> filter(prefecture == "Bedaya")
df |> filter(fever != "Yes")
df |> filter(malaria_rdt == "negative")
df |> filter(!is.na(fever))
df |> filter(year(date_admission) == 2023)
df |> filter(age_years >= 15, hospitalisation == "yes")
df |> filter(prefecture == "Moissala", facility == "Moissala Est", date_admission < as.Date("2023-02-01"))
df |> filter(muac <115, age_months < 59)
df |> filter()
df |> filter()


# 4. Cleaning

df |> 
  mutate(
    hospitalisation = str_to_title(hospitalisation),
    malaria_rdt =  str_to_title(malaria_rdt),
    outcome = case_when(
      outcome %in% c("mort", "death", "died") ~ "Dead",
      outcome  == "gueri" ~ "Recovered",
      outcome == "lost" ~ "Lost to follow-up"
    ),
    is_dead = case_when(
      outcome == "Dead" ~ TRUE,
      outcome %in% c("Recovered", "Lost to follow-up") ~ FALSE,
      .default = NA
    ),
    vacc_status_simple = case_when(
      vacc_status %in% c("Yes - oral", "Yes - card") ~ "Yes",
      vacc_status == "No" ~ "No",
      vacc_status == "Uncertain" ~ "Unknown"
    )
  )

# 5. Simplify

df |> 
  mutate(age_group2 = case_when(
      age_months < 6 ~ "< 6 months",
      age_months < 12  ~ "6 - 11 months",
      age_months < 59 ~ "12 - 59 months",
      age_years <= 15 ~ "5 - 15 years",
      age_years > 15 ~ "> 15 years",
      .default = "Unknown")
  )

# 6. Fix

df |> 
  mutate(age_group2= case_when(
    age_months < 6 ~ '< 6 months',
    age_months < 12 ~ '6 - 11 months',
    age_months < 59 ~ "12 - 59 months",
    age_years <= 15 ~ '5 - 15 years',
    age_years > 15 ~ '> 15 years',
    .default = 'Unknown')
  )

## CHALLENGE
# 1.
df |> 
  filter(prefecture == "Bouna",  year(date_admission) == 2022) |> 
  export(here('data', 'clean', 'data_hospit_bouna.csv'))

# 2.
df |>
  filter(prefecture == "Moissala",
         facility %in% c("Moissala Est", "Moissala Nord", "Moissala Sud", 
                         "Hôpital du District de Moissala")) |> 
  count(facility)

# 3.
df |> 
  count(id) |> 
  filter(n > 1) |> 
  export(here('data', 'clean', 'check_duplicates.xlsx'))
