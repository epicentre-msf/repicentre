# INTRODUCTION SESSION
# Author :  The repicentre Team
# Creation Date : 06/05/2025
# Last Update : 06/05/2025
# Description : Model code for the Introduction Session.
# --------------------------------------------------------------------------------------------------


# Data Types ---------------------------------------------------------------------------------------

# get the type of an object
class(28)
class("Mandoul")


# test the type of an object
is.numeric(28)
is.numeric("Mandoul")
is.character("Mandoul")

is.numeric(TRUE)
is.character(TRUE)
is.logical(FALSE)



# Creating an Object -------------------------------------------------------------------------------

# objects are created using the `<-`
region <- "Mandoul"

# they are updated in the same way
region <- "Moyen Chari"



# Atomic Vectors -----------------------------------------------------------------------------------


# vector of length one, this is a numeric vector because it contains an integer (28)
cases <- 28

# vectors can also have multiple values
cases <- c(2, 5, 8, 0, 4)

# vectors can don't have to be numeric, they can also be character
region <- c("Mandoul", "Moyen-Chari", "Logone Oriental",
            "Tibesti", "Logone Occidental")



# [brackets] can be used to access the data in a vector by their numeric index
region[3]          # extract the third value
region[1:2]        # extract the first and second value


# Dataframes ---------------------------------------------------------------------------------------

# creating a dataframe
data_cases <- data.frame(
  cases = c(2, 5, 8, 0, 4),
  region = c("Mandoul", "Sud Kivu", "Kasai oriental",
             "Kasai", "Haut Katanga"))


# alternatively, we can build the dataframe from existing vectors of equal length
data_cases <- data.frame(cases, region)


# some functions to explore the structure of a dataframe
str(iris)          # structure, data types of each column
dim(iris)          # dimensions, number of rows and columns
nrow(iris)         # number of rows
ncol(iris)         # number of columns
names(iris)        # column names


# data frames are indexed using brackets to specify the [rows, columns] you want to extract
data_cases[3, "region"]  # you can specify columns by name
data_cases[3, 2]         # or by their numerical index


# you can also extract multiple rows at once
data_cases[2:3, "cases"]
data_cases[2:3, 1]



# Functions ----------------------------------------------------------------------------------------

# functions can be used to perform a calculation or task
sum(cases)         # calculate the sum of the vector `cases`
min(c(2, 0, 6))    # find the minimum value in the vector `c(2, 0, 6)`

