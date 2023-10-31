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
mem_116 <- read.csv('house_members_116.csv')  #House member data
bills <- read.csv('bills_116.csv')  #House and Senate legislative data

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

#filter House + Senate data to only include firearm data
gunbills <- bills %>% 
  filter(str_detect(description, paste(filter_string, collapse = "|")))
#create list of strings from all bill names 
bill_names = c(bills$bill_number)

#isolate gun lobbying data that targets legislation
gunbills_lobbied <- gunlobby %>% 
  filter(str_detect(bills_lobbied_on, paste(bill_names, collapse = "|")))

#create valences for gunbills
gunbills$valence = rep('restrict', nrow(gunbills))
#create list of rows that expand firearm access
expand.bills = c(3,5,6,16,23,31,33,56,65,67,68,71,84,90,98,123,124,134,135,137,139,140,144,146,150,156,183,185,194,215,226,231,232,237,239,245)
#create list of rows that are more broad, not necessarily reacting to gun violence
neutral.bills = c(9,38,153,154,188)
#create list of rows that are to be dropped because of their irrelevancy
todrop.bills = c(52,53,60,70,159,175,186,187,191,195,197,220)
#assign rows of expansionary legislation label 'expand'
gunbills[expand.bills, "valence"] <- 'expand'
#assign rows of neutral legislation label 'neutral'
gunbills[neutral.bills, "valence"] <- 'neutral'
#drop unnecessary legislation
gvbills <- gunbills[-todrop.bills,]
#drop unnecessary columns
gvbills <- gvbills[,-2]




