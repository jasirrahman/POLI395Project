##11/04/23
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
library(tidyverse)

#Load in data
og <- read.csv('original_data.csv')
blob <- read.csv('bills_lobbied_on.csv')  
lobby <- read.csv('lobbying_data_full_2020.csv')  #lobbying data
leg_116 <- read.csv('house_legislation_116.csv')  #House legislative data
mem_116 <- read.csv('house_members_116.csv')  #House member data
bills <- read.csv('bills_116.csv')  #House and Senate legislative data

#set filtering strings
filter_string_lob = c('Firearms/Guns/Ammunition','Firearm','firearm','Gun','gun')
#join on id.poli395
blog <- blob %>% 
  full_join(og, by = c('id.poli395' = 'id.poli395'))
#filter data to include only gun violence related legislation
blog <- blog %>% 
  filter(str_detect(specific_issues, paste(filter_string_lob, collapse = "|")))
blog <- blog %>% 
  filter(str_detect(general_issues, paste(filter_string_lob, collapse = "|"))) 
#restrict to the 116th congress
blog <- blog %>% 
  filter(congress == 116)

#subset data to include only necessary columns
blog = blog[, c(1:5,8,10,17,18,20,27,28,30,31,38)]
#rename H.R. in data
blog$bill_name <- gsub("H.R. ", "H.R.", blog$bill_name)

#assign bills to anti-gun stance (for ease of computation)
blog$billstance = rep('restrict', nrow(blog))
#assign bills w/ pro-gun stance to list
pro_gun_filter = c(110,121,155,1761,2179,2443,38,3826,5289,5935,6126,664,69,7715,775,817,877,821)
#assign bills w/ neutral stance to list
neutral_filter = c(1222,1767,2075,2457,2698,3742,7614,7667,94,2492,286,5469)

blog$billstance <- ifelse(blog$bill_number %in% pro_gun_filter, 'expand', blog$billstance)
blog$billstance <- ifelse(blog$bill_number %in% neutral_filter, 'neutral', blog$billstance)

##check laws to see stances towards firearms
blog$lobbystance = rep('restrict', nrow(blog))
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
blog$lobbystance <- ifelse(blog$client_name %in% pro_org_filter, 'expand', blog$lobbystance)
#assign rows of neutral orgs label 'neutral'
blog$lobbystance <- ifelse(blog$client_name %in% neutral_org_filter, 'neutral', blog$lobbystance)

##merging bill statuses on bill names'
bills = bills[, c(3,4,5,7,8,9,10,12)]
bills$bill_number <- gsub("HB", "H.R.", bills$bill_number)
bills <- bills %>% 
  rename(bill_name = bill_number)

#rename variable name to sponsor in mems_116
mem_116 <- mem_116 %>%
  rename(sponsor = name_id)

#create list of strings from all bill names 
leg_116 = leg_116[, c(1,3,4)]


#merge data based on column sponsor for both bills
sponsor <- leg_116 %>%
  full_join(mem_116, by = c("sponsor" = "sponsor"))

#filter data by keeping inclusive to cells in bill_id with data
sponsor <- sponsor[complete.cases(sponsor$bill_id),]
sponsor <- sponsor %>% 
  rename(bill_name= bill_id)

#merge data
data <- inner_join(blog, sponsor, by = "bill_name")
data <- inner_join(data, bills, by = "bill_name")
#filter out data for bills without gvp focus
data <- data %>% 
  filter(str_detect(description, paste(filter_string_lob, collapse = "|")))
