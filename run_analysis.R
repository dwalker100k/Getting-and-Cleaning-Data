## The following program will:
##  1.Merge the training and the test sets to create one data set.
##  2.Extract only the measurements on the mean and standard deviation for each measurement. 
##  3.Use descriptive activity names to name the activities in the data set
##  4.Appropriately label the data set with descriptive variable names. 
##  5.From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

##Step 0:  Download the data:

setwd("C:/Users/Darryl/Desktop/JHU Coursera Data Science")

if(!file.exists("./data")){dir.create("./data")} #creates a directory to store the data

fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileurl, destfile = "./data/GetCleanDataProject.zip")

unzip("./data/GetCleanDataProject.zip", exdir = "./data")



##---------------------------------------------------------------------------------------------##

## Step 1 Load the relevant data sets into R

X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt") #feature vector values

y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt") #activity lables for training data

subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt") #participant ID vector
    
Training_Data_Set <- cbind(subject_train, y_train, X_train) #combines all into one training set


X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")

y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")

subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

Test_Data_Set <- cbind(subject_test, y_test, X_test)

##Combine Training and Testing datasets into one complete set:

Full_Data_Set <- rbind(Training_Data_Set, Test_Data_Set)

##---------------------------------------Step 1 Complete------------------------------------------##

## 2.0  Extract only the mean and standard deviation from each measurement.

feature_names <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]

# The above line must be a character vector.  The first column is an index, the names are the second
#column, hence the subsetting [ ,2] to get the names.

MeanstdIndex <- grep("[Mm]ean|[Ss][Tt][Dd]", feature_names) #Captures the mean and std String positions

Means_std_dat <- Full_Data_Set[,c(1, 2, MeanstdIndex+2)]

colnames(Means_std_dat) <- c("Participant", "Activity", feature_names[MeanstdIndex])

##---------------------------------------Step 2 Complete------------------------------------------##

#Step 3:  Provide activity names

activity_names <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

Means_std_dat$Activity <- factor(Means_std_dat$Activity, levels = activity_names[,1], labels = activity_names[,2])

##---------------------------------------Step 3 Complete------------------------------------------##

# Step 4: Appropriately label the data set  

names(Means_std_dat) <- gsub("^t", "Time", names(Means_std_dat))
names(Means_std_dat) <- gsub("mean", "Mean", names(Means_std_dat))
names(Means_std_dat) <- gsub("^f", "Frequency", names(Means_std_dat))
names(Means_std_dat) <- gsub("\\()", "", names(Means_std_dat))

##---------------------------------------Step 4 Complete------------------------------------------##

#Step 5:  Create a tidy data set from step 4 with average for each participant and activity

library(dplyr)

tidyset <- Means_std_dat %>% group_by(Participant, Activity) %>%
  summarize_all(funs(mean))

write.table(tidyset, "./tidyset.txt", row.name = FALSE)









