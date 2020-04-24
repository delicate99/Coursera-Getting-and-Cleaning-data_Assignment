# download file and setting directory

library(dplyr)

url<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile="./dataset.zip", method="curl")
unzip("dataset.zip")
  
setwd("UCI HAR Dataset")

getwd()

# read data

X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/y_test.txt")
Subject_test <- read.table("./test/subject_test.txt")

X_train <- read.table("./train/X_train.txt")
Y_train <- read.table("./train/y_train.txt")
Subject_train <- read.table("./train/subject_train.txt")

Features <- read.table("./features.txt")
Activity_labels <- read.table("./activity_labels.txt")

# Merges and training & the test sets to create one dataset.

X_data <- rbind(X_train, X_test)
Y_data <- rbind (Y_train, Y_test)
Subject_data <- rbind(Subject_train, Subject_test)

# Extract only the measurements on the mean and SD for each measurement.

Features_stat <- Features[grep("mean|std", Features[,2]),]
X_stat <- X_data[,Features_stat[,1]]

# Uses descriptive activity names to name the activities in the data set
# and appropriately labels the data set with descriptive variable names

colnames(Y_data) <- "Activity"
colnames(Subject_data) <- "Subject"

colnames(X_stat) <- Features_stat[,2]

# Merge all cleaned data.

Final_data <- cbind(Subject_data, Y_data, X_stat)

# Turn Subject and Activity column into factor

Final_data$Activity <- factor(Final_data$Activity, levels=Activity_labels[,1],
                        labels=Activity_labels[,2])
Final_data$Subject <- as.factor(Final_data$Subject)

# Creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.

Group <- group_by(Final_data, Activity,Subject)
Tidy_data <- summarize_all(Group, list(mean=mean))

write.table(x=Tidy_data, file="./Tidydata.txt", sep="@", row.names=FALSE,
            col.names = TRUE)


