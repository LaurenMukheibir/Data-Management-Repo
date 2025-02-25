#Raw Data Analysis
#Lauren Mukheibir
#25/02/2025

#Installing Packages 
install.packages("readr")

#Loading Libraries
library(readr)
library(tidyverse)

#Loading in Data 
data <- read.csv("raw_data_species_richness_total_abundance.csv")
view(data)

#Investigating data structure
str(data)
head(data)
tail(data)

data_new <- data[-c(22,23),] #to only be run once
view(data_new)

#data_clean <- na.omit(data_new)
view(data_clean)

#Renaming Columns 
colnames(data_new) <- c("Macrophyte_Type", "Amphipod", "Isopod", "Shrimp","Caprellid", "Copepod", "Tanaid", "Polychaete_Motile", "Hermit_Crab", "Sea_Spider", "Anemone", "Sea_Cucumber", 'Brittle_Star', "Feather_Hydroid", "Urchin", "Gastropod", "Fanworm", "Polychaetes_Sessile", "Ascidian_Colonial", "Fish","SR", "TA", "SW_Index")

data_new <- data_new %>%
  mutate(Macrophyte_Type = case_when (
    str_detect(Macrophyte_Type, "Sarg") ~ "Sargassum",
    str_detect(Macrophyte_Type, "Eck") ~ "Ecklonia",
    str_detect(Macrophyte_Type, "Amph") ~ "Amphibolis",
  ))


# Data Analysis:

ggplot(data_new, aes(x=Macrophyte_Type, y=SR)) +
  geom_bar(stat="identity") +
  labs(title="Species Richness by Macrophyte Type", x= "Macrophyte Type", y= "Species Richness")
