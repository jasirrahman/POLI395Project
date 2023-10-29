##Poli 395 Project
##08/28/23
#Jasir Rahman

####################

##setup

#clear environment
rm(list=ls())  

#setwd
setwd("~/Desktop/R/POLI 395/POLI 395 Project")

#libraries + packages
library(devtools)
library(foreign)
library(qss)
library(ggplot2)
library(dplyr)
library(stargazer)

#Load in data
lobby <- read.csv('lobbying_data_full_2020.csv')
leg_116 <- read.csv('house_legislation_116.csv')
mem_116 <- read.csv('house_members_116.csv')
roll_info_116 <- read.csv('house_rollcall_info_116.csv')
roll_vote_116 <- read.csv('house_rollcall_votes_116.csv')

#filter out unnecessary columns
lobby_filtered <- lobby[, c(3,5,7,8,9,10,15,16,17,20,22,23,25,26,33)]
target_string_lob = 'Firearms/Guns/Ammunition'
target_string_leg = 'Firearms'
gunlobby <- lobby_filtered %>% 
  filter(str_detect(general_issues, target_string_lob))

gvleg <- leg_116 %>% 
  filter(str_detect(subjects, target_string_leg))

#create valences for gvleg
gvleg$valence = rep('restrict', nrow(gvleg))
#find bills that expand firearm access
#create list of rows that expand firearm access
expand.bills = c(3,5,6,18,37,43,45,63,70,72,75,80,85,95,97,98,102)
#create list of rows that are more broad, not necessarily reacting to gun violence
neutral.bills = c(16,31,38,56,57,59,60,61,73,76,77,78,86,94,118,124,132,140)
#assign rows of expansionary legislation label 'expand'
gvleg[expand.bills, "valence"] <- 'expand'
#assign rows of neutral legislation label 'neutral'
gvleg[neutral.bills, "valence"] <- 'neutral'









