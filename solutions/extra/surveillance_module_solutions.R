# Solutions to the Surveillance Module Companion
# Author: the Fetch team
# Last Update: 31/03/2025
# Description: Model code associated with Surveillance Module case study


# Note: here we gathered the data cleaning / prep and the analyses
# in only one script to have only one file to download at the end 
# of the tutorial.
# This is fine because the project is small (short cleaning and analyses).
# That being said, separating the cleaning and data preparation 
# from analyses as we had you do in the tutorial is often a good 
# choice,as soon as the codebase gets larger projects.

# We could even have Rmarkdown or Quarto documents in the project to
# run automatic reports based on the results.



# Setup ----------------------------------------------------

## Load packages -------------------------------------------

library(here)      # For paths
library(rio)       # Import and export data
library(dplyr)     # Data manipulation
library(tidyr)     # Data manipulation
library(ggplot2)   # Graph 
library(stringr)   # Text cleaning
library(lubridate) # Dates
library(zoo)       # Rolling sum


## Import data ---------------------------------------------

## !!! Open the dataset in Excel before importing !!!

# Surveillance data
data_surv_raw <- import(here("data", "raw", "data_ids_week20_2022_en.xlsx"))

# Laboratory data
data_lab_raw <- import(
  here("data", "raw", "data_labo_week20_2022_en.xlsx"), 
  skip = 7  # Skip the first seven lines
)  


# Check import
str(data_surv_raw)
head(data_surv_raw)
View(data_surv_raw)

str(data_lab_raw)
head(data_lab_raw)
View(data_lab_raw)



# Clean data -----------------------------------------------


## Surveillance data ---------------------------------------


### Quick exploration --------------------------------------
names(data_surv_raw)
head(data_surv_raw)

# Count number of lines per health_zone
hz_check <- data_surv_raw |> count(health_zone)

# Check that there are 68 health zones
nrow(hz_check)

## There are 63 health_zone! We are expecting 68. 
# 5 health_zone did not report any data

# Check that the number of week goes from 1-20
min(data_surv_raw$week)
max(data_surv_raw$week)

# Check the number of cases per week
summary(data_surv_raw$totalcases)

# Check the number of deaths per week
summary(data_surv_raw$totaldeaths)


### Clean data -----------------------------------------

data_surv <- data_surv_raw |> 
  
  ## Straighten strings
  mutate(
    
    # Format strings to lower case
    country     = tolower(country),
    province    = tolower(province),
    health_zone = tolower(health_zone),
    disease     = tolower(disease),
    
    # Remove excess spaces with the str_squish() function from 
    # the stringr package, very usefull!
    province    = str_squish(province),
    health_zone = str_squish(health_zone),
    
    
    # Remove spaces or "-" with the str_replace() function from 
    # the stringr package
    province = str_replace(province, pattern = "-", replacement = "_"), 
    province = str_replace(province, pattern = " ", replacement = "_"),
    health_zone = str_replace(health_zone, pattern = "-", replacement = "_"), 
    health_zone = str_replace(health_zone, pattern = " ", replacement = "_"),
    
    # Number of cases less than 5 months
    cases_under_5 = cases_0_11_months + cases_12_59_months
  ) |> 
  
  # Sort data (important for the cumulative sum!)
  arrange(province, health_zone, week)


# Reformat surveillance data to have 1 line for each week
# filled in with 0 cases (important for the cumulative sum later)

# Use of tidyr::complete to add new records of week 1 to 20 
# for each combined province and health_zone with 0 value in the 
# totalcases and totaldeaths variables

data_surv_weeks <- data_surv |> 
  select(province, health_zone, week, totalcases, totaldeaths) |>
  
  complete(
    nesting(province, health_zone),
    week = seq(min(week, na.rm = TRUE), 
                 max(week, na.rm = TRUE)),
    fill = list(totalcases = 0, 
                totaldeaths = 0)
  ) |> 
  
  ## Prepare alert columns
  mutate(
    
    # 20 cases or more
    cases20 = case_when(
      totalcases >= 20 ~ 1, 
      .default = 0)) |>
  
  # Cumulative indicators, need to be calculated by health_zone
  mutate(
    
    # Group by provinceince and health_zone
    .by = c(province, health_zone),
    
    # Cumulative cases over 3 week window (zoo::rollapply)
    cumcas = rollapply(totalcases, 
                       width = 3,        # Window width
                       sum,              # function to apply
                       na.rm = TRUE,     # Arguments to pass to the function (here, sum)
                       align = "right",  # Backward calculation  
                       partial = TRUE)
  ) |> 
  
  mutate(    
    
    # Binary indicator for 35 cumulative cases
    cumcases35 = case_when(
      cumcas >= 35 ~ 1, 
      .default = 0),
    
    # Combined alert indicator
    # The operator | is a logical OR.
    alert = case_when(
      (cases20 == 1 | cumcases35 == 1) ~ 1, 
      .default = 0)
  )



## Laboratory data ------------------------------------------

### Quick exploration ------------------------------------------

names(data_lab_raw)
head(data_lab_raw)

# Check lab results categories
data_lab_raw |> distinct(igm_measles)
data_lab_raw |> distinct(igm_rubella)


### Clean data ----------------------------------------------

data_lab <- data_lab_raw |> 
  mutate(
    
    # Clean strings
    health_zone = tolower(health_zone),                # Format strings to lower case
    health_zone = str_squish(health_zone),             # Remove excess spaces
    health_zone = str_replace(health_zone, "-", "_"),  # Replace - by _
    health_zone = str_replace(health_zone, " ", "_"),  # Replace space by _
    
    # Recode igm modalities
    igm_measles = case_when(
      igm_measles == 'pos' ~ 'positive', 
      igm_measles == 'neg' ~ 'negative', 
      .default = igm_measles),
    
    igm_rubella = case_when(
      igm_rubella == 'pos' ~ 'positive', 
      igm_rubella == 'neg' ~ 'negative', 
      .default = igm_rubella),
    
    sample_collection = ymd(sample_collection)
  )


# Did we recode correctly?
data_lab |> distinct(igm_measles)
data_lab |> distinct(igm_rubella)




# Analyses --------------------------------------------------

## Subset data ----------------------------------------------

# To simplify the exploration during the case study we run 
# the analyses on only a subset of the dataset
data_alert <- data_surv_weeks |> 
  filter(health_zone %in% c("dilolo", "kowe" ,"kampemba", "lwamba"))


# Which health zones are in alert at week 20?
data_alert |>
  filter(week == 20) |>
  arrange(desc(alert))

# It's 63 if we were looking at the full dataset:
# data_surv_weeks |>
#   filter(week == 20) |>
#   arrange(desc(alert))


# Vector of the health_zone that are in alert in week 20 to make a graph
# of these health_zone
hz_alert <- data_alert |>
  filter(week == 20,
         alert == 1) |>
  pull(health_zone) # turn a single column data frame into a vector

# Or type it by hand if there are few alerts: 
# hz_alert <- c("kampemba", "lwamba")



## Epicurve ------------------------------------------------

p_epi <- data_alert |>
  filter(health_zone %in% hz_alert) |>
  ggplot(aes(x = week, 
             y = totalcases)) + 
  geom_col(fill = "#2E4573") + 
  labs(x = "Week",
       y = "N cases",
       title = "Health zones in alert") +
  theme_bw(base_size = 15) +
  facet_wrap(vars(health_zone))   # One graph by health_zone

p_epi


## Key indicators ------------------------------------------

### Week of the first alert -----------------------------
first_alert <- data_alert |>
  filter(alert == 1) |>
  summarise(
    .by = health_zone,
    min_alert = min(week))

first_alert


### Surveillance data ------------------
table_surv <- data_surv |>
  filter(health_zone %in% hz_alert) |>
  mutate(cases_under_5 = cases_0_11_months + cases_12_59_months) |>
  summarise(
    .by = health_zone,
    
    n_cases       = sum(totalcases, na.rm = TRUE),
    n_deaths   = sum(totaldeaths, na.rm = TRUE),
    n_under_5   = sum(cases_under_5, na.rm = TRUE),
    perc_under_5 = scales::percent(n_under_5 / n_cases, accuracy = 0.1),
    cfr          = scales::percent(n_deaths / n_cases, accuracy = 0.1)
  )

table_surv


### Lab data --------------------------------
table_lab <- data_lab |>
  filter(health_zone %in% hz_alert) |>
  
  summarise(
    .by = health_zone,
    
    n_test_meas        = sum(!is.na(igm_measles)),
    n_test_meas_pos    = sum(igm_measles == "positive", na.rm = TRUE),
    positivity_measles = scales::percent(n_test_meas_pos / n_test_meas, 
                                    accuracy = 0.1),
    
    n_test_rub         = sum(!is.na(igm_rubella)),
    n_test_rub_pos     = sum(igm_rubella == "positive", na.rm = TRUE),
    positivity_rubella = scales::percent(n_test_rub_pos / n_test_rub, 
                                    accuracy = 0.1)
  )

table_lab




# Save data / Export results -------------------------------

## Save clean data -----------------------------------

# Surveillance data
export(data_surv, 
       file = here("data", "clean", "IDS_clean.rds"))

# Completed week
export(data_surv_weeks, 
       file = here("data", "clean", "IDS_clean_complete_weeks.rds"))

# Lab data
export(data_lab,
       file = here("data", "clean", "lab_clean.rds"))

## Export results ------------------------------------------

# You could export results to reuse them in another document (an
# Rmarkdown script for example). It is possible to store these 
# different elements (various data frames, ggplot objects...) into
# a list and then to save the list.

# Create list of results
list_results <- list(
  data_alert  = data_alert, 
  first_alert = first_alert, 
  p_epi       = p_epi, 
  table_surv  = table_surv, 
  table_lab   = table_lab)


# Save as RDS file
list_results |>
  export(file = here("outputs", "list_results.rds"))