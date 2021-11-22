# Maria Litova 18.11.2021
# Data wrangling exercise
# The data include two datasets which present student achievement
# in secondary education of two Portuguese schools



# read the first dataset (performance in Mathematics)
math <- read.csv("data/student-mat.csv", sep = ";", header = TRUE)
str(math)
dim(math)
colnames(math)

# read the second dataset (performance in Portuguese language)
por <- read.csv("data/student-por.csv", sep = ";", header = TRUE)
str(por)
dim(por)
colnames(por)



# joining the datasets
library(dplyr)
library(ggplot2)

# which columns vary in datasets
free_cols <- c("failures","paid","absences","G1","G2","G3")

# the rest of the columns are common identifiers used for joining the datasets
join_cols <- setdiff(colnames(por),free_cols)

# join two data by join_cols
math_por <- inner_join(math, por, by = join_cols, suffix = c('.math','.por'))

# explore the structure and dimensions of the joined data
str(math_por)
dim(math_por) # number of students is 370. Data includes 370 rows and 39 columns.
colnames(math_por)



# combine the 'duplicated' answers in the joined data

# print out the column names of 'math_por'
colnames(math_por)

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_cols))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_cols]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse at the new combined data
glimpse(alc)
dim(alc) # 370*33



# create a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# create a new logical column 'high_use' which is TRUE for students 
# for which 'alc_use' is greater than 2 (and FALSE otherwise)
alc <- mutate(alc, high_use = alc_use > 2)



# glimpse at the joined and modified data
glimpse(alc)
dim(alc) # 370*35

# save the joined and modified dataset
setwd("/Users/Maria/R/IODS-project")
write.csv(alc, file = "/Users/Maria/R/IODS-project/data/alc.csv", row.names = FALSE)
alc <- read.csv("/Users/Maria/R/IODS-project/data/alc.csv")
dim(alc) # 370*35
str(alc)
head(alc)
