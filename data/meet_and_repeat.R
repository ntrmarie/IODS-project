# Maria Litova 8.12.2021
# Data wrangling exercise

# read the data
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep = " ", header = TRUE)
str(BPRS)
names(BPRS)
summary(BPRS)

# data includes 11 columns and 40 rows  

#The BPRS data includes 40 male subjects that were randomly assigned to one of two treatment groups and each subject was rated on the brief psychiatric rating scale (BPRS) measured for the period from week 0 to week 8. 
#The BPRS assesses the level of 18 symptom constructs such as hostility, suspiciousness, hallucinations and grandiosity; each of these is rated from 1 (not present) to 7 (extremely severe). 
#The scale is used to evaluate patients suspected of having schizophrenia.

RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = "\t", header = TRUE)
str(RATS)
names(RATS)
summary(RATS)

# data includes 13 columns and 16 rows

# RATS is dataset from a nutrition study conducted in three groups of rats. 
# The groups were put on different diets, and each animal’s body weight (grams) was recorded repeatedly over a 9-week period.

# convert the categorical variables of both data sets to factors
library(dplyr)
library(tidyr)

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

# convert BPRS to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
# add the week variable
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# convert RATS to long form
RATSL <-  RATS %>% gather(key = WD, value = Weight, -ID, -Group)
# add the Time variable
RATSL <-  RATSL %>% mutate(Time = as.integer(substr(WD,3,4)))

# summarize and compare results
str(BPRSL)
str(RATSL)

# We see that the new data sets have the long form, so that 
# BPRS had 11 columns and 40 rows and now has 5 columns and 360 rows.
# RATS had 13 columns and 16 rows and now has 5 columns and 176 rows.
# In BPRS the main change has been made regarding to the variables related to weeks 0-8.
# Now BPRSL includes only one "week" variable with the week number instead of longitudinal data on weeks 0-8 and new variable "bprs" that includes the number of points of each measurement for psychiatric rating scale.
# In RATS the main change has been made regarding to the variables related to week days that have been put into the variable "WD" and variable "Time".
# In RATSL for every rat the group, the week day, the time and weight are presented.



# save the data
write.csv(BPRSL, file = "/Users/Maria/R/IODS-project/data/BPRSL.csv", row.names = FALSE)
write.csv(RATSL, file = "/Users/Maria/R/IODS-project/data/RATSL.csv", row.names = FALSE)
