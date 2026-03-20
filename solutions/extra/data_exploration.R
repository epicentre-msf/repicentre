
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

dim(df_linelist) #dimensions
nrow(df_linelist) #number of rows
ncol(df_linelist) #number of columns


# Variables names --------------------------------------------------------

names(df_linelist)


# Visualise the data -----------------------------------------------------

df_linelist #run the object alone

head(df_linelist, n = 15) # first 15 rows
tail(df_linelist, n = 1à) # last 10 rows

View(df_linelist)

# Variable class ---------------------------------------------------------

class(df_linelist$age) #age is numeric 

class(df_linelist$date_admission) # date of admission is a character not a Date

df_linelist$sex # all the values for sex 

class(df_linelist$sex)

# all class at once - increase width of console pane
str(df_linelist)


# Explore continuous variables -------------------------------------------

min(df_linelist$age) # A negative age ! 
max(df_linelist$muac) # muac has NAs so we need to explicitly set na.rm = TRUE
max(df_linelist$muac, na.rm = TRUE)


# Explore categorical variables -------------------------------------------

count(df_linelist, sex) # count all sex values 

count(df_linelist, sub_prefecture)