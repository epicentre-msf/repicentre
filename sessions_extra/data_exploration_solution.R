
# Solutions to the satellite session data exploration
# Author:  the Fetch team
# Creation Date: 09/02/2025
# Last Update: 09/02/2025
# Description: Contains solutions to the coding exercices


# Packages ------------------------------------

library(here)
library(rio)
library(dplyr)

#Import data ------------------------------------
df_linelist <- import(here::here("data", "raw", "moissala_linelist_EN.xlsx"))


# Basic exploration ------------------------------------