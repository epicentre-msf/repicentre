# Solutions to the core session 01_introduction
# Author :  the Fetch team
# Creation Date : 06/05/2025
# Last Update : 06/05/2025
# Description : Contains solutions to the coding exercices from the introduction sessions.


# Data types ------------------------------------------

# Usefull functions to explore the type of objects

# Get the Type of an Object
class(28)  
class("Mandoul")

# Test the Type of an Object
is.numeric(28)
is.numeric("Mandoul")
is.character("Mandoul")

is.numeric(TRUE)
is.character(TRUE)
is.logical(FALSE)


# Saving an object ------------------------------------

# Create an object called region that contains the value "Mandoul".
region <- "Mandoul"

# Update the value of region to "Moyen Chari".
region <- "Moyen Chari"



# Data structures -------------------------------------

## Simple vectors --------------------------------------

# Creates a vector of length one, containing the value 28. 
# It is a numeric vector because it contains an integer.
cases <- 28

# Update the cases vector with several values
cases <- c(2, 5, 8, 0, 4)

# Update the region vector with several values
region <- c("Mandoul", "Moyen-Chari", "Logone Oriental",
            "Tibesti", "Logone Occidental")

# Calculate the sum of the cases values
sum(cases)

# Write the region values in lower case
tolower(region)


## Accessing the Values of a Vector --------------------

# Get the 3rd value of `region`:
region[3]

# Access the values "Mandoul" and "Moyen-Chari" in the vector `region`.
region[1:2]


# Data frames -------------------------------------------

# Creating a dataframe ----------------------------------
data_cases <- data.frame(
  cases = c(2, 5, 8, 0, 4),
  region = c("Mandoul", "Sud Kivu", "Kasai oriental", 
             "Kasai", "Haut Katanga"))

# OR
# Since we already had objects that contains these valuses in the environment
data_cases <- data.frame(cases, region) 


## Exploring a data frame -----------------------------------------

# How many rows and columns are there in iris? What are the names of its columns?
str(iris)
dim(iris) 
nrow(iris)
ncol(iris)
names(iris)

## Accessing rows, columns and values of a data frame -------------------

# Access the third value in the region column of your data frame  
data_cases[3, "region"]  # Works if you are sure of the name of the column
# OR:
data_cases[3, 2]         # Works too if you are sure of the position

# Return the second and third values of the `cases` column  
data_cases[2:3, "cases"]
# OR:
data_cases[2:3, 1]

# Calculate the sum of the cases column of your data frame
sum(data_cases[ , "cases"])