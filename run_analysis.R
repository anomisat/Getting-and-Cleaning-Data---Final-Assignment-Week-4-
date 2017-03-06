setwd("C:/Projects/Training/R/Getting and Cleaning Data/Data/Final assignment/UCI HAR Dataset/all data")
library(data.table)

#READ ALL FILES

subj_train <- read.table("subject_train.txt")
subj_test <- read.table("subject_test.txt")
x_train <- read.table("X_train.txt")
y_train <- read.table("Y_train.txt")
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
features <- read.table("features.txt")

#GET THE COLUMNS NAMES FROM THE FEATURES DATA
colnames(x_train) <- features$V2
colnames(x_test) <- features$V2

#MERGE ALL DATA FILES FOR THE TEST AND TRAIN DATASETS
train_set <- cbind(y_train, subj_train, x_train)
test_set <- cbind(y_test, subj_test, x_test)

#COMBINE THE TRAIN AND TEST SETS
whole_set <- rbind(train_set, test_set)

#LABEL DATA WITH DESCRIPTIVE VARIABLE NAMES
names(whole_set)[1] <- "Activity_name"
names(whole_set)[2] <- "Subject"

#USE DESCRIPTIVE ACTIVITY NAMES TO LABEL ALL ACTIVITIES
whole_set$Activity_name[whole_set$Activity_name == 1] <- "Walking"
whole_set$Activity_name[whole_set$Activity_name == 2] <- "Walking_upstairs"
whole_set$Activity_name[whole_set$Activity_name == 3] <- "Walking_downstairs"
whole_set$Activity_name[whole_set$Activity_name == 4] <- "Sitting"
whole_set$Activity_name[whole_set$Activity_name == 5] <- "Standing"
whole_set$Activity_name[whole_set$Activity_name == 6] <- "Laying"

#EXTRACT ONLY VARIABLES WITH MEAN AND ST DEVIATION
names_reduced <- grep("mean|std",names(whole_set), value=TRUE)
reduced_set <- whole_set[,c("Activity_name","Subject",names_reduced)]

#FIND THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT
library(dplyr)
reduced_set <- group_by(reduced_set, Activity_name, Subject)
summarized_set <- summarise_each(reduced_set, funs(mean))
names(summarized_set) <- paste("Avg",names(summarized_set),sep = "_")
names(summarized_set)[1] <- "Activity_name"
names(summarized_set)[2] <- "Subject"

#EXPORT THE SUMMARIZED DATASET
write.table(summarized_set, "C:/Projects/Training/R/Getting and Cleaning Data/Data/Final assignment/Summarized_data.txt")
