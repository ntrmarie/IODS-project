# Data wrangling 
# Chapter 4


# read datasets
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# explore datasets
str(hd)
dim(hd)
summary(hd)

str(gii)
dim(gii)
summary(gii)

# rename variables
library(tidyverse)
hd <- hd %>% rename( 
       hdi.rank = HDI.Rank, 
       country = Country, 
       hdi = Human.Development.Index..HDI., 
       leb =  Life.Expectancy.at.Birth, 
       eye = Expected.Years.of.Education, 
       mye = Mean.Years.of.Education,
       gni = Gross.National.Income..GNI..per.Capita, 
       resid = GNI.per.Capita.Rank.Minus.HDI.Rank)

gii <- gii %>% rename(
       gii.rank = GII.Rank,
       country = Country,
       gii = Gender.Inequality.Index..GII.,
       mmr = Maternal.Mortality.Ratio,
       abr = Adolescent.Birth.Rate,
       prp = Percent.Representation.in.Parliament,
       secedu.f = Population.with.Secondary.Education..Female.,
       secedu.m = Population.with.Secondary.Education..Male.,
       lfpr.f = Labour.Force.Participation.Rate..Female.,  
       lfpr.m = Labour.Force.Participation.Rate..Male.)

# mutate gii data
gii <- mutate(gii, edu.rat = secedu.f/secedu.m, lab.rat = lfpr.f/lfpr.m)

# join datasets
human <-inner_join(gii, hd, by = "country")
str(human)
dim(human) # 195*19
write.csv(human, file = "/Users/Maria/R/IODS-project/data/human.csv", row.names = FALSE)

