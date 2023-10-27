##Poli 395 Project
##08/28/23
#Jasir Rahman

####################

##clear environment
rm(list=ls())  
#setwd
setwd("~/Desktop/R/POLI 395/POLI 395 Project")
#libraries + packages
library(devtools)
library(foreign)
#install a package from GitHub

#you may need to allow R to update/install additional packages
library(qss)
library(ggplot2)
library(dplyr)
library(stargazer)

##Load in data
lobby <- read.csv('lobbying_data_full_2020.csv')
lobby_filtered <- lobby[, c(3,5,7,8,9,10,15,16,17,20,22,23,25,26,29,30,31,33)]
leg <- read.csv('')

target_string = 'Firearms/Guns/Ammunition'
gv <- lobby_filtered %>% 
  filter(str_detect(general_issues, target_string))






