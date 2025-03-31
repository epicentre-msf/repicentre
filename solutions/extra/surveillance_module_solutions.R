# Solutions to the Surveillance Module Satellite
# Author: the Fetch team
# Last Update: 31/03/2025
# Description: Model code associated with Surveillance module case study


# Note: here we gathered the data cleaning and preparation and the analyses
# in only one script. This is fine for a very short project (little
# cleaning, very short analysis...). But it would have been possible
# to separate the following code into several scripts, one dedicated to
# cleaning the data, and one dedicated to exploring and analysing the data.
# We could even have Rmarkdown or Quarto documents in the project to
# run automatic reports based on the results.



# Setup ----------------------------------------------------

## Import packages -----------------------------------------

library(here)      # For paths
library(rio)       # Import and export data
library(dplyr)     # Data manipulation
library(tidyr)     # Data manipulation
library(stringr)   # Text cleaning
library(lubridate) # Dates
library(zoo)       # Rolling sum


## Import data ---------------------------------------------

## !!! Open the dataset in Excel before opening !!!

# Surveillance data
data_surv_raw <- import(here("data", "raw", "data_ids_sem20_2022.xlsx"))

# Laboratory data
data_lab_raw <- import(
  here("data", "raw", "data_labo_sem20_2022.xlsx"), 
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

# Count number of lines per ZS
zs_check <- data_surv_raw |> count(zs)

# Check that there are 68 health zones
nrow(zs_check)

## There are 63 ZS! We are expecting 68. 
# 5 ZS did not report any data

# Check that the number of weeks goes from 1-20
min(data_surv_raw$numsem)
max(data_surv_raw$numsem)

# Check the number of cases per week
summary(data_surv_raw$totalcas)

# Check the number of deaths per week
summary(data_surv_raw$totaldeces)


### Clean data -----------------------------------------

data_surv <- data_surv_raw |> 
  
  ## Straighten strings
  mutate(
    
    # Format strings to lower case
    pays    = tolower(pays),
    prov    = tolower(prov),
    zs      = tolower(zs),
    maladie = tolower(maladie),
    
    # Remove excess spaces with the str_squish() function from 
    # the stringr package, very usefull!
    prov = str_squish(prov),
    zs   = str_squish(zs),
    
    
    # Remove spaces or "-" with the str_replace() function from 
    # the stringr package
    prov = str_replace(prov, pattern = "-", replacement = "_"), 
    prov = str_replace(prov, pattern = " ", replacement = "_"),
    zs   = str_replace(zs,   pattern = "-", replacement = "_"), 
    zs   = str_replace(zs,   pattern = " ", replacement = "_"),
    
    # Number of cases less than 5 months
    cunder_5 = c011mois + c1259mois
  ) %>% 
  
  # Sort data
  arrange(prov, zs, numsem)


# Reformat surveillance data to have 1 line for each week
# filled in with 0 cases 

# Use of tidyr::complete to add new records of weeks 1 to 20 
# for each combined province and zs with 0 value in the 
# totalcas and totaldeces variables

data_surv_weeks <- data_surv |> 
  select(prov, zs, numsem, totalcas, totaldeces) |>
  
  complete(
    nesting(prov, zs),
    numsem = seq(min(numsem, na.rm = TRUE), 
                 max(numsem, na.rm = TRUE)),
    fill = list(totalcas = 0, 
                totaldeces = 0)
  ) %>% 
  
  ## Prepare alert columns
  mutate(
    # 20 cases or more
    cases20 = case_when(
      totalcas >= 20 ~ 1, 
      .default = 0)) |>
  
  # Cumulative indicators, need to be calculated by ZS
  mutate(
    
    # Group by Province and ZS
    .by = c(prov, zs),
    
    # Cumulative cases over 3 week window (zoo::rollapply)
    cumcas = rollapply(totalcas, 
                       width = 3,        # Window width
                       sum,              # function to apply
                       na.rm = TRUE,     # Arguments to pass to the function (here, sum)
                       align = "right",  
                       partial = TRUE)
  ) %>% 
  
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
data_lab_raw |> distinct(igm_rougeole)
data_lab_raw |> distinct(igm_rubeole)


### Clean data ----------------------------------------------

data_lab <- data_lab_raw |> 
  mutate(
    
    # Clean strings
    zs = tolower(zs),                # Format strings to lower case
    zs = str_squish(zs),             # Remove excess spaces
    zs = str_replace(zs, "-", "_"),  # Replace - by _
    zs = str_replace(zs, " ", "_"),  # Replace space by _
    
    # Recode igm modalities
    igm_rougeole = case_when(
      igm_rougeole == 'pos' ~ 'positif', 
      igm_rougeole == 'neg' ~ 'negatif', 
      .default = igm_rougeole),
    
    igm_rubeole = case_when(
      igm_rubeole == 'pos' ~ 'positif', 
      igm_rubeole == 'neg' ~ 'negatif', 
      .default = igm_rubeole),
    
    collecte_echantillon = ymd(collecte_echantillon)
  )


# Did we recoded correctly?
data_lab |> distinct(igm_rougeole)
data_lab |> distinct(igm_rubeole)






# Analyses --------------------------------------------------

## Subset data ----------------------------------------------
# For the case study we ran the analyses on only a subset of the dataset
data_alert <- data_surv_weeks %>% 
  filter(zs %in% c("dilolo", "kowe" ,"kampemba", "lwamba"))


# Which health zones are in alert at week 20?
data_alert |>
  filter(numsem == 20) %>%
  arrange(desc(alert))

# It's 63 if we were looking at the full dataset:
# data_surv_weeks |>
#   filter(numsem == 20) %>%
#   arrange(desc(alert))


# Vector of the ZS that are in alert in week 20 to make a graph
# of these ZS
zs_alert <- data_alert |>
  filter(numsem == 20,
         alert == 1) %>%
  pull(zs) # turn a single column data frame into a vector

# Or type it by hand if there are few alerts: 
# zs_alert <- c("kampemba", "lwamba")



## Epicurve ------------------------------------------------

p_epi <- data_alert |>
  filter(zs %in% zs_alert) |>
  ggplot(aes(x = numsem, 
             y = totalcas)) + 
  geom_col(fill = "#2E4573") + 
  labs(x = "Week",
       y = "N cases",
       title = "Health zones in alert") +
  theme_bw(base_size = 15) +
  facet_wrap(vars(zs))   # One graph by ZS

p_epi


## Key indicators ------------------------------------------

### Week of the first alert -----------------------------
first_alert <- data_alert |>
  filter(alert == 1) |>
  summarise(
    .by = zs,
    min_alert = min(numsem))

first_alert


### Surveillance data ------------------
table_surv <- data_surv |>
  filter(zs %in% zs_alert) |>
  mutate(cunder_5 = c011mois + c1259mois) %>%
  summarise(
    .by = zs,
    
    nb_cas       = sum(totalcas, na.rm = TRUE),
    nb_deces     = sum(totaldeces, na.rm = TRUE),
    nb_under_5   = sum(cunder_5, na.rm = TRUE),
    cfr          = scales::percent(nb_deces / nb_cas, accuracy = 0.1),
    prop_under_5 = scales::percent(nb_under_5 / nb_cas, accuracy = 0.1)
  )

table_surv


### Lab data --------------------------------
table_lab <- data_lab |>
  filter(zs %in% zs_alert) |>
  
  summarise(
    .by = zs,
    
    nb_roug_test  = sum(!is.na(igm_rougeole)),
    nb_roug_pos   = sum(igm_rougeole == "positif", na.rm = TRUE),
    prop_roug_pos = scales::percent(nb_roug_pos / nb_roug_test, 
                                    accuracy = 0.1),
    nb_rub_test   = sum(!is.na(igm_rubeole)),
    nb_rub_pos    = sum(igm_rubeole == "positif", na.rm = TRUE),
    prop_rub_pos  = scales::percent(nb_rub_pos / nb_rub_test, 
                                    accuracy = 0.1)
  )

table_lab




# Save data / Export results -------------------------------

## Save clean data -----------------------------------

# Surveillance data
export(data_surv, 
       file = here("data", "clean", "IDS_clean.rds"))

# Completed weeks
export(data_surv_weeks, 
       file = here("data", "clean", "IDS_data_ts_clean.rds"))

# Lab data
export(data_lab,
       file = here("data", "clean", "lab_clean.rds"))

## Export results ------------------------------------------

# You could export results to reuse them in another document (an
# Rmakdown script for exemple). It is possible to store these 
# different elements (various data frames, ggplot objects...) into
# a list and then to save the list.

# Create list of results
list_results <- list(
  alert_20    = alert_20, 
  first_alert = first_alert, 
  p_epi       = p_epi, 
  table_surv  = table_surv, 
  table_lab   = table_lab)


# Save as RDS file
list_results |>
  export(file = here("output", "list_results.rds"))