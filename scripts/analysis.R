#Raw Data Analysis
#Lauren Mukheibir
#25/02/2025

#Installing Packages 
install.packages("readr")
install.packages("report")

#Loading Libraries
library(readr)
library(tidyverse)
library(report)

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

#Renaming Macrophyte Type to full names
data_new <- data_new %>%
  mutate(Macrophyte_Type = case_when (
    str_detect(Macrophyte_Type, "Sarg") ~ "Sargassum",
    str_detect(Macrophyte_Type, "Eck") ~ "Ecklonia",
    str_detect(Macrophyte_Type, "Amph") ~ "Amphibolis",
  ))


# Data Analysis:

ggplot(data_new, aes(x=Macrophyte_Type, y=SR, fill=Macrophyte_Type)) +
  geom_bar(stat="identity") +
  labs(title="Species Richness by Macrophyte Type", x= "Macrophyte Type", y= "Species Richness") +
  scale_fill_manual(values = c("Amphibolis" = "lightpink", "Ecklonia" = "lightblue", "Sargassum" = "lightgreen"))
  

### Boxplot without outliers
ggplot(data_new, aes(x=Macrophyte_Type, y=TA, fill=Macrophyte_Type)) +
  geom_boxplot(outlier.shape = NA) +
  labs(x= "Macrophyte Type", y= "Total Abundance") +
  ylim(0,60) +
  scale_fill_manual(values = c("Amphibolis" = "lightpink", "Ecklonia" = "lightblue", "Sargassum"="lightgreen"))


#Using Amphipod data
ggplot(data_new, aes(x=Macrophyte_Type, y=Amphipod, fill=Macrophyte_Type)) +
  geom_bar(stat="identity") +
  labs( title= "Amphipod Count against Macrophyte Type", x= "Macrophyte Type", y= "Amphipod Count") +
  scale_fill_manual (values= c("Amphibolis" ="lightpink", "Ecklonia" = "lightblue", "Sargassum"="lightgreen"))
  
#Statistical Analysis
aov_SR <- aov(SR ~ Macrophyte_Type, data = data_new)
aov_SR #results of anova test

aov_TA <- aov(TA ~ Macrophyte_Type, data = data_new)
aov_TA

### Understanding the statistical significance
report(aov_SR)
report(aov_TA)

### Running TukeyHSD for statistically significant variables
TukeyHSD(aov_SR)
plot(TukeyHSD(aov_SR), las=1)  # Horizontal labels for readability

### Post-Hoc Test
tukey_results <- TukeyHSD(aov_SR)
tukey_df <- as.data.frame(tukey_results$Macrophyte_Type)
tukey_df$Comparison <- rownames(tukey_df)  
view(tukey_df)

ggplot(tukey_df, aes(y=Comparison, x=diff, xmin=lwr, xmax=upr)) +
  geom_point(size=3, color="purple") +  # Mean difference
  geom_errorbarh(height=0.2, color="black") +  # Horizontal error bars
  geom_vline(xintercept=0, linetype="dashed", color="red") +  # Reference line at 0
  labs(title="Tukey HSD Post-Hoc Test for Species Richness",
       x="Mean Difference (95% CI)",
       y="Macrophyte Type Comparison")


