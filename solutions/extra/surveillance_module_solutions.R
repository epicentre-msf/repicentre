# Solutions to the Surveillance Module Satellite
# Author: the Fetch team
# Last Update: 28/03/2025
# Description: Model code associated with Surveillance module case study


# Setup ----------------------------------------------------

## Import packages -----------------------------------------
library(here)      # For paths
library(rio)       # Import and export data
library(dplyr)     # Data manipulation
library(tidyr)     # Data manipulation
library(stringr)   # Text cleaning
library(lubridate) # Dates

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


# Surveillance data ------------------------------------------------------

## Quick exploration --------------------------------------
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



## Clean data ------------------------------------------------

data_surv <- data_surv_raw |> 
  mutate(
    
    # Format strings to lower case
    pays    = tolower(pays),
    prov    = tolower(prov),
    zs      = tolower(zs),
    maladie = tolower(maladie),
    
    # To go further (semi-advanced R): checkout the use of
    # across function in mutate, to replace the four lines
    # above with  across(c(pays, prov, zs, maladie), tolower)!
    
    
    # Remove excess spaces with the str_squish() function from 
    # the stringr package, very usefull!
    prov    = str_squish(prov),
    zs      = str_squish(zs),
    
    
    # Remove spaces or "-" with the str_replace() function from 
    # the stringr package
    prov = str_replace(prov, pattern = "-", replacement = "_"), 
    prov = str_replace(prov, pattern = " ", replacement = "_"),
    zs   = str_replace(zs,   pattern = "-", replacement = "_"), 
    zs   = str_replace(zs,   pattern = " ", replacement = "_")
  )


## Save cleaned data ---------------------------------------
export(data_surv, 
       file = here("data", "clean", "IDS_clean.rds"))



# Laboratory data ------------------------------------------

## Check lab data ------------------------------------------

names(data_lab_raw)
head(data_lab_raw)

# Check lab results categories
data_lab_raw |> distinct(igm_rougeole)
data_lab_raw |> distinct(igm_rubeole)


## Clean data ----------------------------------------------

data_lab <- data_lab_raw |> 
  mutate(
    
    # Clean strings
    zs = tolower(zs),    # Format strings to lower case
    zs = str_squish(zs), # Remove excess spaces
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


## Save cleaned data ---------------
export(data_lab,
       file = here("data", "clean", "lab_clean.rds"))



# Complete Surveillance ----------------------------------------

## Clean data ----------------------------------------------

# Reformat surveillance data to have 1 line for each week
# filled in with 0 cases 

# Use of tidyr::complete to add new records of weeks 1 to 20 
# for each combined province and zs with 0 value in the 
# totalcas and totaldeces variables

data_ts <- data_surv |> 
  select(prov, zs, numsem, totalcas, totaldeces) |>
  complete(
    nesting(prov, zs),
    numsem = seq(min(numsem, na.rm = TRUE), 
                 max(numsem, na.rm = TRUE)),
    fill = list(totalcas = 0, 
                totaldeces = 0)
  ) 

## Save completed IDS data -----------------------------------
export(data_ts, 
       file = here("data", "clean", "IDS_data_ts_clean.rds"))
