# Data wrangling 
# Chapter 4 and 5


# First part

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



# Second part

# load data
read.table(file = "/Users/Maria/R/IODS-project/data/human.csv", sep = ",", header = TRUE)
str(human)
dim(human) # 195*19

# We explore the Human Development data  a summary measure of average achievement in key dimensions of human development: a long and healthy life, being knowledgeable and have a decent standard of living. 
# Original data from: http://hdr.undp.org/en/content/human-development-index-hdi
# The data combines several indicators from most countries in the world

# We use the following variables:

#country = Country name
#hdi.rank = HDI.Rank, 
#hdi = Human.Development Index, 
#leb =  Life.Expectancy.at.Birth, 
#eye = Expected.Years.of.Education, 
#mye = Mean.Years.of.Education,
#gni = Gross.National.Income..GNI..per.Capita, 
#resid = GNI.per.Capita.Rank.Minus.HDI.Rank)
#gii.rank = GII.Rank,
#gii = Gender.Inequality.Index..GII.,
#mmr = Maternal.Mortality.Ratio,
#abr = Adolescent.Birth.Rate,
#prp = Percent.Representation.in.Parliament.Female,
#secedu.f = Population.with.Secondary.Education..Female.,
#secedu.m = Population.with.Secondary.Education..Male.,
#lfpr.f = Labour.Force.Participation.Rate..Female.,  
#lfpr.m = Labour.Force.Participation.Rate..Male.


# mutate data
library(dplyr)
library(stringr)
library(GGally)
library(corrplot)
library(stringr)
human$gni <- str_replace(string = human$gni, pattern=",", replace ="") %>% as.numeric
human$gni <- as.numeric(human$gni)
human

# exclude variables with N/A values
keep <- c("country", "gni", "leb", "eye", "mmr","abr", "prp", "edu.rat", "lab.rat")
human <- select(human, one_of(keep))
human <- filter(human, complete.cases(human))
human



#remove the observations which relate to regions instead of countries
# look at the last 10 observations
tail(human, 10)
# last indice we want to keep
last <- nrow(human) - 7
# choose everything until the last 7 observations
human <- human[1:last, ]
# remove 7 variables (regions, nor countries)
human <- filter(human, complete.cases(human))
# add countries as rownames
rownames(human) <- human$country
dim(human)


# remove the country variable
human <- select(human, -country)
human
dim(human) #155*8

write.csv(human, file = "/Users/Maria/R/IODS-project/data/human.csv", row.names = TRUE)


#Now our dataset includes the following variables:

#gni = Gross National Income per Capita
#leb =  Life Expectancy at Birth 
#eye = Expected Years of Education
#mmr = Maternal Mortality Ratio 
#abr = Adolescent Birth Rate
#prp = Percent Representation in Parliament 
#edu.rat = the ratio of Female and Male populations with secondary education (secedu.f/secedu.m)
#lab.rat = the ratio of labour force participation of females and males (lfpr.f/lfpr.m)
