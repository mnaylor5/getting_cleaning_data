library(dplyr)

#You should create one R script called run_analysis.R that does the following:
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of 
##  each variable for each activity and each subject.

setwd('C:/Users/Mitch/Desktop/JHU/Getting and Cleaning Data/Programming Assignment/UCI HAR Dataset')

# read in the stuff
x_train <- read.table('train/X_train.txt')
x_test <- read.table('test/X_test.txt')
y_train <- read.table('train/Y_train.txt')
y_test <- read.table('test/Y_test.txt')
subject_train <- read.table('train/subject_train.txt')
subject_test <- read.table('test/subject_test.txt')
features <- read.table('features.txt')
labels <- read.table('activity_labels.txt')

combined_x <- rbind(x_train, x_test)
combined_y <- rbind(y_train, y_test)
combined_subject <- rbind(subject_train, subject_test)
colnames(combined_x) <- features[,2]
colnames(combined_y) <- 'activity_index'
colnames(combined_subject) <- 'subject_id'

# find the columns of interest
mean_std <- grep("*mean\\(|*std\\(" , features[,2])

# combine X, Y, and Subject columns
total_data <- cbind(combined_y,combined_subject,combined_x[,mean_std])

# clean up after yourself
rm(x_train, y_train, x_test, y_test, subject_test, subject_train, 
   combined_subject, combined_x, combined_y, features, mean_std)

# label the label labels
colnames(labels) <- c('index','activity_label')
 
# apply labels to y values
total_data %>%
  left_join(labels, by = c('activity_index' = 'index')) %>%
  select(-c(activity_index)) -> total_data

# tidy dataset with means of each metric grouped by activity and subject
total_data %>%
  group_by(activity_label, subject_id) %>%
  summarise_each(funs(mean)) -> tidy_df

rm(labels, total_data)