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
lobby <- read.csv('lobbying_data_full_2020.csv')  #lobbying data
leg_116 <- read.csv('house_legislation_116.csv')  #House legislative data
mem_116 <- read.csv('house_members_116.csv')  #House member data

#making names of bills identical across datasets so that we can merge
bills$bill_number <- gsub("HB", "H.R.", bills$bill_number)

#filter out unnecessary columns for lobby data
lobby_filtered <- lobby[, c(3,5,7,8,9,10,15,16,17,20,22,23,25,26,33)]
#create lists of strings to isolate firearm related legislation
filter_string_lob = c('Firearms/Guns/Ammunition','Firearm','firearm','Gun','gun')
filter_string = c('Firearm','firearm','Gun','gun','ammunition')
#filter lobbying data to only have firearm lobbying data
gunlobby <- lobby_filtered %>% 
  filter(str_detect(general_issues, paste(filter_string_lob, collapse = "|")))
gunlobby$bills_lobbied_on <- gsub("H.R. ", "H.R.", gunlobby$bills_lobbied_on)
#filter House legislative data to only include firearm House legislation
gvleg <- leg_116 %>% 
  filter(str_detect(subjects, paste(filter_string, collapse = "|")))

#create list of strings from all bill names 
bill_names = c(bills$bill_number)

#isolate gun lobbying data that targets legislation
gunbills_lobbied <- gunlobby %>% 
  filter(str_detect(bills_lobbied_on, paste(bill_names, collapse = "|")))
gvleg[neutral.bills, "valence"] <- 'neutral'
  
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