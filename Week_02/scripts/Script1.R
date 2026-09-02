### This is my first script for this class.  
### Created by: Yang An
### Created on: 2026-09-01
###############################################
### Load libraries ##########
library(tidyverse)
library(here)
### Read in data ###
WeightData <- read_csv(here("Week_02", "data", "weightdata.csv"))
### Data Analysis #####

head(WeightData) # Looks at the top 6 lines of the dataframe
tail(WeightData) # Looks at the bottom 6 lines of the dataframe

View(WeightData) # opens a new window to look at the entire dataframe