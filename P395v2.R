##Poli 395 Project v2 (House Data Only)
##11/02/23
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
library(stringr)

#Load in data
lobby <- read.csv('lobbying_data_full_2020.csv')  #lobbying data
leg_116 <- read.csv('house_legislation_116.csv')  #House legislative data
mem_116 <- read.csv('house_members_116.csv')  #House member data

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
bills <- leg_116 %>% 
  filter(str_detect(subjects, paste(filter_string, collapse = "|")))

#create list of strings from all bill names 
bill_names = c(bills$bill_id)

#isolate gun lobbying data that targets legislation
gunlobby <- gunlobby %>% 
  filter(str_detect(bills_lobbied_on, paste(bill_names, collapse = "|")))

#create valences for gvleg
bills$valence = rep('restrict', nrow(bills))
#find bills that expand firearm access
#create list of rows that expand firearm access
expand.bills = c(3,5,6,18,37,43,45,63,70,72,75,80,85,95,97,98,102)
#create list of rows that are more broad, not necessarily reacting to gun violence
neutral.bills = c(16,31,38,56,57,59,60,61,73,76,77,78,86,94,118,124,132,140)
#assign rows of expansionary legislation label 'expand'
bills[expand.bills, "valence"] <- 'expand'
#assign rows of neutral legislation label 'neutral'
bills[neutral.bills, "valence"] <- 'neutral'

gunlobby$lobbystance = rep('restrict', nrow(gunlobby))

##check orgs manually to see general stances towards firearms
#create filter list for pro-gun orgs
pro_org_filter = c('Smith And Wesson Brands Inc.', 'Sig Sauer Inc', 'Shotspotter Inc.','Polymer80, Inc.','Palmetto State Armory, Llc', 
                   'Olin Corporation', 'Nst Global, Llc', 'National Shooting Sports Foundation', 'National Rifle Association Of America', 
                   'National Rifle Association, Institute For Legislative Action', 'Nst Global, Llc (Dba Sb Tactical)',
                   'National Association For Gun Rights', 'Nammo Perry, Inc', 'Mars, Inc.', 'Kongsberg Defence & Aerospace', 'Kelley Drye & Warren Llp',
                   'Hill Country Class 3, Llc', 'Gun Owners Of America Inc', 'Firearms Regulatory Accountability Coalition, Inc. - Frac', 
                   'Firearms Regulatory Accountability Coalition, Inc. (Frac)', 'Firearms Policy Coalition, Inc.', 'Defense Distributed', 
                   'Dallas Safari Club', 'Corporation For The Promotion Of Rifle Practice & Firearm Safety', 
                   'Citizens Committee For The Right To Keep And Bear Arms', 'American Outdoor Brands Corporation', 'Magpul Industries Corp.')
#create filter list for neutral/mixed orgs
neutral_org_filter = c("National Fraternal Order Of Police", "Dick'S Sporting Goods (On Behalf Of Finsbury Llc)")

#assign rows of pro-gun orgs label 'expand'
gunlobby$lobbystance <- ifelse(gunlobby$client_name %in% pro_org_filter, 'expand', gunlobby$lobbystance)
#assign rows of neutral orgs label 'neutral'
gunlobby$lobbystance <- ifelse(gunlobby$client_name %in% neutral_org_filter, 'neutral', gunlobby$lobbystance)


