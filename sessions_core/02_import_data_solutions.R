# Solutions to the core session 02_import_data
# Author:  the Fetch team
# Creation Date: 07/01/2025
# Last Update: 07/01/2025
# Description: Contains solutions to the coding exercices



# Packages ------------------------------------

# Download and install the R package {here}
# This needs to be done once, or when you want to update the package
install.packages("here")

# Load the here package in the session
# Needs to be done each time you restart R.
library(here)
library(rio)



# Define path -----------------------------------------

# Path to the data (not save in an object for now)
here("data", "raw", "xlsx", "Moissalla-measles-linelist-EN.xlsx")


# Import data -----------------------------------------

#### EXCEL ####

# Import data but do not save it in an object
import(file = here("data", "raw", "xlsx",
              "Moissalla-measles-linelist-EN.xlsx"))

# Import data an save it in an object
df_linelist <- import(file = here("data", "raw", "xlsx",
              "Moissalla-measles-linelist-EN.xlsx"))


#### CSV ####
df_linelist_csv <- import(file = here("data", "raw",,
                                      "msf_linelist_moissala_2023-09-24.csv"))
