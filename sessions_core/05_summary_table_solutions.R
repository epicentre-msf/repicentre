# Solutions to the core session 05_summary-table
# Author :  the Fetch team
# Creation Date : 08/02/2025
# Last Update : 08/02/2025
# Description : Contains solutions to the coding exercices

# Packages ------------------------------------

# Load the packages required for the session
# Needs to be done each time you restart R.
library(here)
library(rio)
library(tidyverse)

# Import data -----------------------------------------

# Import the clean data stored in data/clean
df_linelist <- import(file = here("data", "clean", "moissala_linelist_clean_EN.rds"))

# Contingency tables -----------------------------------------

df_linelist |>
  count(sub_prefecture, age_group)

# Filtering NAs -----------------------------------------

# proportions of deaths is the CFR -
# but it needs to be calculated using only patients for which we have a known outcome !
# we can perform filter before count to retain only the ones with dead/recovered
df_linelist |>
  filter(
    outcome != "left against medical advice",
    !is.na(outcome)
  ) |>
  count(outcome)

# these two filter statement are equivalent ! :
df_linelist |>
  filter(
    outcome %in% c("dead", "recovered")
  ) |>
  count(outcome)

# Summary table -----------------------------------------

# Here is the summary table you should have built:

df_linelist |>
  summarize(
    .by = sub_prefecture,
    n_patients = n(),
    mean_age = mean(age),
    min_admission = min(date_admission, na.rm = TRUE),
    n_female = sum(sex == "f", na.rm = TRUE),
    n_hosp = sum(hospitalisation == "yes", na.rm = TRUE),
    mean_age_hosp = mean(age[hospitalisation == "yes"], na.rm = TRUE),
    mean_age_female = mean(age[sex == "f"], na.rm = TRUE),
    n_death_u6m = sum(outcome[age_group == "< 6 months"] == "dead", na.rm = TRUE)
  ) |>
  mutate(
    prop_female = n_female / n_patients,
    prop_hosp = n_hosp / n_patients
  )