# Solutions to the core session 05_summaries
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
df_linelist <- import(file = here("data", "clean", "simulated_measles_ll.rds"))

# Contingency tables -----------------------------------------

df_linelist |>
  count(sub_prefecture, age_group)


df_linelist |>
  count(sub_prefecture, hospitalisation)

# changing the order changes the variable order
df_linelist |>
  count(hospitalisation, sub_prefecture)

# Questions:

# 2529 females (49.8%)
df_linelist |>
  count(sex) |>
  mutate(prop = n / sum(n))

# Outcome possible values
df_linelist |>
  count(outcome)

# 1225 patients were 1 - 4 yo and recovered
df_linelist |>
  count(
    age_group,
    outcome
  )

# Filtering NAs -----------------------------------------

# proportions of deaths is the CFR -
# but it needs to be calculated using only patients for which we have a known outcome !
df_linelist |>
  count(outcome) |>
  mutate(prop = n / sum(n))

# we can perform filter before count to retain only the ones with dead/recovered
df_linelist |>
  filter(
    outcome != "left against medical advice",
    !is.na(outcome)
  ) |>
  count(outcome)

# these two filter statement are equivalent ! :

cfr_df <- df_linelist |>
  filter(
    outcome %in% c("dead", "recovered")
  ) |>
  count(outcome)

# drop_na() is also useful to remove NAs from a variable

df_linelist |>
  drop_na(outcome) |>
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

# Extra exercise ---------------------------------------------------------

# a summary table for age groups

df_linelist |>
  summarize(
    .by = age_group,
    n_patients = n(),
    n_male = sum(sex == "m", na.rm = TRUE),
    prop_male = n_male / n_patients,
    n_deaths = sum(outcome == "dead", na.rm = TRUE),
    # get number of patients with a valid outcome to compute CFR
    n_outcome_valid = sum(outcome %in% c("dead", "recovered"), na.rm = TRUE),
    CFR = n_deaths / n_outcome_valid * 100,
    n_deaths_pneumo = sum(outcome[pneumonia == 1] == "dead", na.rm = TRUE)
  ) |>
  # only keep variable of interest
  select(
    age_group,
    prop_male,
    n_deaths,
    CFR,
    n_deaths_pneumo
  )
