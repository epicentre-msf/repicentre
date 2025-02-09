# A quick file to download the latest data from the {episimdata} into the website

# install package if required
# remotes::install_github("epicentre-msf/episimdata")

library(episimdata)

# Use the function to export the data ====================================================================

# .RDS
# Clean Measles Linelist in English
episimdata::export_data("moissala_linelist_clean_EN", here::here("data", "clean", "moissala_linelist_clean_EN.rds"))

# Clean Measles Linelist in French
episimdata::export_data("moissala_linelist_clean_FR", here::here("data", "clean", "moissala_linelist_clean_FR.rds"))

# .xlsx
# Raw Measles Linelist in English
episimdata::export_data("moissala_linelist_EN", here::here("data", "raw", "moissala_linelist_EN.xlsx"))

# Raw Measles Linelist in French
episimdata::export_data("moissala_linelist_FR", here::here("data", "raw", "moissala_linelist_FR.xlsx"))

# .csv
# Raw Measles Linelist in English
episimdata::export_data("moissala_linelist_EN", here::here("data", "raw", "moissala_linelist_EN.csv"))

# Raw Measles Linelist in French
episimdata::export_data("moissala_linelist_FR", here::here("data", "raw", "moissala_linelist_FR.csv"))