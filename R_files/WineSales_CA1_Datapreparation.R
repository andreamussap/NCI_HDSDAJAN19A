##################################################
## Project: Data Visualisation - CA1 - Wine Sales Visual Analysis
## Script: DataPreparation.R
## Purpose: R script to transform BlackFriday dataset into WineSales

## Group: Andrea, Fabio, James and Lucas
##################################################



##################################################
## install.packages("skimr")
##
## install.packages("naniar")
##
## install.packages("kableExtra")
##
## install.packages("pander")
##
## install.packages("pander")
##################################################

#Load packages
library(dplyr)
library(rstudioapi)
library('tidyverse') # a package that contains the most usefull tools for analysis and visualization, including 'readr', 'ggplot2' and 'dplyr'. 
library('skimr') # package for display basic info and stats of data
library('gridExtra') # to arrange multiple plots in a desired number of rows and columns
library('knitr') # better tables for rmarkdown
library('magrittr') #improve readbility, permits the use of %>% pipeline
library('naniar') # nice package to deal with missing values
library('kableExtra') # usefull tools for visualization
library('pander') # to plot nice tables 


# Getting the path of your current open file
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path ))

#load all data from csv files
BlackFriday <- read.csv("../datasources/BlackFriday.csv", header=TRUE)
MarStatLookups <- read.csv("../datasources/MarStatLookups.csv", header=TRUE)
Occupations <- read.csv("../datasources/Occupations.csv", header=TRUE)
LocationLookups <- read.csv("../datasources/LocationLookups.csv", header=TRUE)
Categories <- read.csv("../datasources/Categories.csv", header=TRUE)

#BlackFriday <- BlackFriday[1:1000,] #debug only


#setwd("C:/Users/jhedd/Documents/GitHub/Visualisation CA1/NCI_HDSDAJAN19A_DataViz/R_files")

#Add marital status description
WineSales <- merge(BlackFriday, MarStatLookups,by="Marital_Status")

#Add Occupations
WineSales <- merge(WineSales, Occupations,by="Occupation", all.x = TRUE)

#Add Location data
WineSales <- merge(WineSales, LocationLookups,by="City_Category")

#Add Category data
#WineSales <- merge(WineSales, Categories,by.x = "Product_Category_1", 
# by.y = "Product_Category_ID", all.x = TRUE)
WineSales  <- WineSales %>% left_join(Categories,by = c("Product_Category_1" = "Product_Category_ID"))
colnames(WineSales)[colnames(WineSales)=="Product_Category_Name"] <- "GrapeType"
colnames(WineSales)[colnames(WineSales)=="Stay_In_Current_City_Years"] <- "WineAge"

#convert to Euro values
WineSales$Purchase <- WineSales$Purchase/100

#Add a new column for sale Date
WineSales$saleDate <- as.Date("31/12/2017", "%d/%m/%Y") 
WineSales$saleDate <- WineSales$saleDate + runif(length(WineSales$saleDate), min=1, max=366)

#keep only the columns we actually need
retain_cols <- c("User_ID","Product_ID","Gender","Age","WineAge","Purchase","Status_Desc","OccupationDesc","Location","Latitude","Longitude","GrapeType","Wine_Type","saleDate")
WineSales <- subset(WineSales, select=retain_cols)

#view the new df
glimpse(WineSales)

#save as csv
write.csv(WineSales, "../datasources/WineSales.csv", row.names = FALSE)

#check for missing values
skim_with(numeric = list(hist = NULL))
skim(WineSales)

#check the range
max(WineSales$Purchase); min(WineSales$Purchase)

