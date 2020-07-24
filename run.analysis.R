#loading packages
library(dplyr)
library(base)
library(utils)
library(data.table)

#downloading the data
download.data <- function () {
  zip.url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  filename <- 'dataset.zip'
  download.file(zip.url, filename, method = 'curl')
  unzip(filename)
}

#reading data
features <- read.table("UCI HAR Dataset/features.txt")
actlab <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE)
subtrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE)
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE)
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE)
subtest <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE)
ytest <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE)
xtest <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE)

#creating dataset
sub <- rbind(subtrain, subtest)
act <- rbind(ytrain, ytest)
feat <- rbind(xtrain, xtest)
colnames(feat) <- t(featNames[2])
colnames(act) <- "Activity"
colnames(sub) <- "Subject"
finaldataset <- cbind(feat,act,sub)

#extracting measurement
meanstdcolumns <- grep(".*Mean.*|.*Std.*", names(finaldataset), ignore.case = TRUE)
reqcolumns <- c(meanstdcolumns, 562, 563)
dim(finaldataset)
extracteddata <- finaldataset[,reqcolumns]
dim(extracteddata)

#naming the activities
extracteddata$Activity <- as.character(extracteddata$Activity)
for (i in 1:6){
extracteddata$Activity[extracteddata$Activity==i] <- as.character(actlab[i, 2])
}
extracteddata$Activity <- as.factor(extracteddata$Activity)
names(extracteddata)

#replacing names
names(extracteddata) <- gsub("Acc", "Accelerometer", names(extracteddata))
names(extracteddata) <- gsub("Gyro", "Gyroscope", names(extracteddata))
names(extracteddata) <- gsub("BodyBody", "Body", names(extracteddata))
names(extracteddata) <- gsub("Mag", "Magnitude", names(extracteddata))
names(extracteddata) <- gsub("^t", "Time", names(extracteddata))
names(extracteddata) <- gsub("^f", "Frequency", names(extracteddata))
names(extracteddata) <- gsub("tBody", "TimeBody", names(extracteddata))
names(extracteddata) <- gsub("-mean()", "Mean", names(extracteddata), ignore.case=TRUE)
names(extracteddata) <- gsub("-std()", "STD", names(extracteddata), ignore.case=TRUE)
names(extracteddata) <- gsub("-freq()", "Frequency", names(extracteddata), ignore.case=TRUE)
names(extracteddata) <- gsub("angle", "Angle", names(extracteddata))
names(extracteddata) <- gsub("gravity", "Gravity", names(extracteddata))
names(extracteddata)

#creating dataset
extracteddata$Subject <- as.factor(extracteddata$Subject)
extracteddata <- data.table(extracteddata)
tidydata <- aggregate(. ~Subject + Activity, extracteddata, mean)
tidydata <- tidydata[order(tidydata$Subject,tidydata$Activity),]
write.table(tidydata,file = "Tidy.txt",row.names = FALSE)

