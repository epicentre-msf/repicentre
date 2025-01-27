# A quick file to download the latest data from the {episimdata} into the website 

#install package if required
# remotes::install_github("epicentre-msf/episimdata")

library(episimdata)

# Use the function to export the data 

# Raw Measles Linelist in English
episimdata::export_data("measles_linelist_raw", here::here("downloads", "Moissalla-measles-linelist-EN.xlsx"))

# Raw Measles Linelist in French
episimdata::export_data("measles_linelist_raw_fr", here::here("downloads", "Moissalla-rougeole-liste-lineaire-FR.xlsx"))
