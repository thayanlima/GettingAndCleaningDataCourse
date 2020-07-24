1)Dataset downloaded was UCI HAR Dataset.

2)Assign data to the variables:
features <- features.txt : 561 rows, 2 columns
The features come from the acc and gyro
actlab <- activity_labels.txt : 6 rows, 2 columns
List of labels
subtest <- test/subject_test.txt : 2947 rows, 1 column
test data of 9/30 volunteer test subjects being observed
xtest <- test/X_test.txt : 2947 rows, 561 columns
recorded features test data
ytest <- test/y_test.txt : 2947 rows, 1 columns
test data of activities code labels
subtrain <- test/subject_train.txt : 7352 rows, 1 column
train data of volunteer subjects being observed
xtrain <- test/X_train.txt : 7352 rows, 561 columns
recorded features train data
ytrain <- test/y_train.txt : 7352 rows, 1 columns
train data of activities code labels

3)rbind and cbind to merge the data:
sub <- rbind(subtrain, subtest)
act <- rbind(ytrain, ytest)
feat <- rbind(xtrain, xtest)
finaldataset <- cbind(feat,act,sub)

4)gsub to replace the names to descriptive names:
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

5)creating a tidy dataset by the first dataset:
extracteddata$Subject <- as.factor(extracteddata$Subject)
extracteddata <- data.table(extracteddata)
tidydata <- aggregate(. ~Subject + Activity, extracteddata, mean)
tidydata <- tidydata[order(tidydata$Subject,tidydata$Activity),]
write.table(tidydata,file = "Tidy.txt",row.names = FALSE)
