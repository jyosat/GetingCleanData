## Download Data

library("reshape2")

dir.create("data")
setwd("c:/Rproj")

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "./data/UCI_HAR_data.zip")
unzip("./data/UCI_HAR_data.zip",exdir = "./data")

## Step 1: Merges the training and the test sets to create one data set

#Reading Training data set
X_train <- read.table("C:/Rproj/data/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("C:/Rproj/data/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("C:/Rproj/data/UCI HAR Dataset/train/subject_train.txt")
features <- read.table("C:/Rproj/data/UCI HAR Dataset/features.txt")

names(subject_train) <- "SubjectID"
names(Y_train) <- "Activity"
names(X_train) <- features$V2
# combining Training data set
combined_Tr <- cbind(subject_train,Y_train,X_train)

#Reading Test data set
X_test <- read.table("C:/Rproj/data/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("C:/Rproj/data/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("C:/Rproj/data/UCI HAR Dataset/test/subject_test.txt")
names(subject_test) <- "SubjectID"
names(Y_test) <- "Activity"
names(X_test) <- features$V2
combined_Ts <- cbind(subject_test,Y_test,X_test)

# combined into one single data set
combined <- rbind(combined_Tr,combined_Ts)

# determine which columns contain "mean()" or "std()"

meanstdcols <- grepl("mean\\(\\)", names(combined)) | grepl("std\\(\\)", names(combined))

# ensure that we also keep the subjectID and activity columns

meanstdcols[1:2] <- TRUE

#retain only mean and std

combined <- combined[, meanstdcols]

#Apply Activity Labels

combined$Activity <- factor(combined$Activity, labels = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))

# Melt into longformat data

com_melt <- melt(combined,id = c("SubjectID","Activity"))
tidy <- dcast(com_melt, SubjectID+Activity ~ variable, mean)

#write tidy dataset

write.csv(tidy, "C:/Rproj/data/tidy.csv", row.names=FALSE)