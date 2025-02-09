# A quick file to download the latest data from the {episimdata} into the website 

#install package if required
# remotes::install_github("epicentre-msf/episimdata")

library(episimdata)

# Use the function to export the data ====================================================================

# .RDS
# Clean Measles Linelist in English 
episimdata::export_data("measles_linelist", here::here("data", "clean", "simulated_measles_ll.rds"))

# Clean Measles Linelist in French
episimdata::export_data("measles_linelist_fr", here::here("data", "clean",  "simulated_measles_ll_fr.rds"))

#.xlsx
# Raw Measles Linelist in English
episimdata::export_data("measles_linelist_raw", here::here("data", "raw", "xlsx", "Moissalla-measles-linelist-EN.xlsx"))

# Raw Measles Linelist in French
episimdata::export_data("measles_linelist_raw_fr", here::here("data", "raw", "xlsx", "Moissalla-rougeole-liste-lineaire-FR.xlsx"))

#.csv
# Raw Measles Linelist in English
episimdata::export_data("measles_linelist_raw", here::here("data", "raw", "csv", "Moissalla-measles-linelist-EN.csv"))

# Raw Measles Linelist in French
episimdata::export_data("measles_linelist_raw_fr", here::here("data", "raw", "csv", "Moissalla-rougeole-liste-lineaire-FR.csv"))
