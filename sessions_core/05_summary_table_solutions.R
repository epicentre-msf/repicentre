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

# Extra exercise ---------------------------------------------------------

# 1) a summary table for age groups

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

# 2) summarise vaccination status by age group
df_linelist |>
  summarize(
    .by = age_group,
    n_patients = n(),
    n_vacc = sum(vacc_status %in% c("Yes - oral","Yes - card"), na.rm = TRUE),
    n_vacc_one_dose = sum(vacc_doses %in% c("1 dose"), na.rm = TRUE),
    n_vacc_two_doses = sum(vacc_doses %in% c("2 doses"), na.rm = TRUE),
    prop_vacc = n_vacc / n_patients,
    prop_vacc_one_dose = n_vacc_one_dose / n_patients,
    prop_vacc_two_doses = n_vacc_two_doses / n_patients
  ) 

# 3) summarise malaria test results, signs, symptoms by hospitalisation
df_linelist |>
  drop_na(hospitalisation) |>
  summarize(
    .by = hospitalisation,
    
    n_patients = n(),
    n_malaria = sum(malaria_rdt == "positive", na.rm = TRUE),
    n_fever   = sum(fever, na.rm = TRUE),
    n_rash    = sum(rash, na.rm = TRUE),
    n_cough   = sum(cough, na.rm = TRUE),
    n_red_eye = sum(red_eye, na.rm = TRUE),
    n_pneumonia    = sum(pneumonia, na.rm = TRUE),
    n_encephalitis = sum(encephalitis, na.rm = TRUE),
    n_muac         = sum(muac < 125, na.rm = TRUE),
    
    prop_malaria = n_malaria/n_patients,
    prop_fever   = n_fever/n_patients,
    prop_rash    = n_rash/n_patients,
    prop_cough   = n_cough/n_patients,
    prop_red_eye = n_red_eye/n_patients,
    prop_pneumonia    = n_pneumonia/n_patients,
    prop_encephalitis = n_encephalitis/n_patients,
    prop_muac         = n_muac/n_patients
  ) |>
  select(hospitalisation, n_patients,
         prop_malaria, prop_fever, prop_rash, prop_cough,
         prop_red_eye, prop_pneumonia, prop_encephalitis, prop_muac)

# 4) time from onset to consultation by location
df_linelist |>
     summarize(
         .by = sub_prefecture,
         n   = sum(!is.na(date_consultation) & !is.na(date_onset)),
         lag = mean(date_consultation - date_onset) )

# 5) time from admission to outcome by outcome
df_linelist |>
  mutate(time_in_hosp = date_outcome-date_admission) |>
  drop_na(time_in_hosp,outcome) |>
  summarize(
    .by = outcome,
    n = n(),
    lag = mean(time_in_hosp)
  )


