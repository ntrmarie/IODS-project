# Maria Litova 11.11.2021
# Data wrangling exercise

# read the data
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep = "\t", header = TRUE)
str(lrn14)
dim(lrn14)
# comments: data includes 60 variables and 183 observations

# access the dplyr library
library(dplyr)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'sta' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

# create column 'attitude' by scaling the column "Attitude"
lrn14$attitude <- lrn14$Attitude/10

# choose a handful of columns to keep
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

# change the name of the second column
colnames(learning2014)[2] <- "age"

# change the name of "Points" to "points"
colnames(learning2014)[7] <- "points"

# select rows where points is greater than zero
learning2014 <- filter(learning2014, points > 0)

# see the stucture of the new dataset
str(learning2014)

# now the dataset includes 7 variables and 166 observations

setwd("/Users/Maria/R/IODS-project")
write.csv(learning2014, file = "/Users/Maria/R/IODS-project/data/learning2014.csv", row.names = FALSE)
learning2014 <- read.csv("/Users/Maria/R/IODS-project/data/learning2014.csv")
str(learning2014)
head(learning2014)


