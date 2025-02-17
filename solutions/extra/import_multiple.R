# Solutions to the satellite session on importing mutliple files
# Author:  the Fetch team
# Creation Date: 17/02/2025
# Last Update: 17/02/2025
# Description: Contains solutions to the coding exercices


# Setup --------------------------

#  Packages 
library(here)
library(rio)

# Paths
path_data_raw <- here("data", "raw", "satellite_multiple")


# Import multiple sheets -----------------------------

# Import and creates a list
lab_data_list <- import_list(here(path_data_raw, "multiple_sheets",
                                  "msf_laboratory_moissala_2023-09-24_first.xlsx")) 

str(lab_data_list)
View(lab_data_list)


# Import and create a dataframe by binding the elements of the list
lab_data <- import_list(here(path_data_raw, "multiple_sheets",
                             "msf_laboratory_moissala_2023-09-24_first.xlsx"),
                        rbind = TRUE) 

str(lab_data)
View(lab_data)


# Import multiple files -------------------------------

# Define a path
path_mult <- here::here(path_data_raw, "multiple_files", "EN") # optional, to shorten the following code



## Listing by hand -------------------------------------

vector_paths <- c(
  here(path_mult, "moissala_linelist_EN_BEDAYA.xlsx"),
  here(path_mult, "moissala_linelist_EN_BEDJONDO.xlsx"),
  here(path_mult, "moissala_linelist_EN_BEKOUROU.xlsx"),
  here(path_mult, "moissala_linelist_EN_BOUNA.xlsx"),
  here(path_mult, "moissala_linelist_EN_GOUNDI.xlsx"),
  here(path_mult, "moissala_linelist_EN_KOUMRA.xlsx"),
  here(path_mult, "moissala_linelist_EN_MOISSALA.xlsx")
)

# Print:
vector_paths

# Import the data and concatenate it:
linelist_data <- import_list(vector_paths,
                             rbind = TRUE)



# Automatic listing -----------------------------------


# Import the data and concatenate it without listing the files one by one in a vector
linelist_data <- import_list(
  list.files(path = path_mult, pattern = "\\.xlsx$",
             full.names = TRUE),
  rbind = TRUE)
