##Poli 395 Project
##08/28/23
#Jasir Rahman

####################

##setup

#clear environment
rm(list=ls())  

#setwd
#change wd to your own
setwd("~/Desktop/R/POLI 395/POLI 395 Project")

#libraries + packages
library(devtools)
library(foreign)
library(qss)
library(ggplot2)
library(dplyr)
library(stargazer)

##Load in data
lobby <- read.csv('lobbying_data_full_2020.csv')
leg_116 <- read.csv('house_legislation_116.csv')
mem_116 <- read.csv('house_members_116.csv')
roll_info_116 <- read.csv('house_rollcall_info_116.csv')
roll_vote_116 <- read.csv('house_rollcall_votes_116.csv')

#filter out unnecessary columns
lobby_filtered <- lobby[, c(3,5,7,8,9,10,15,16,17,20,22,23,25,26,29,30,31,33)]
target_string = 'Firearms/Guns/Ammunition'
gv <- lobby_filtered %>% 
  filter(str_detect(general_issues, target_string))





