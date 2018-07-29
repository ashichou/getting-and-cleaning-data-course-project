setwd("/Users/ashley.chou/Desktop/Coursera/Getting and Cleaning Data")

# Read training data 
subject_Train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_Train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_Train <- read.table("UCI HAR Dataset/train/y_train.txt")

# Read test data 
subject_Test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_Test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_Test <- read.table("UCI HAR Dataset/test/y_test.txt")

activities <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activities) <- c("activityId", "activityLabel")
features <- read.table("UCI HAR Dataset/features.txt")


str(features)
str(y_Test)
str(y_Train)
str(x_Test)
str(x_Train)
str(subject_Test)
str(subject_Train)


#1. Merge the training and the test data.
subjectData <- rbind(subject_Train, subject_Test)
featuresData <- rbind(x_Train, x_Test) 
activityData <- rbind(y_Train, y_Test)
names(activityData) <- c("activity")
names(subjectData) <- c("subject")
names(featuresData) <- features$V2

mergeData<-cbind(subjectData, activityData, featuresData)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

requiredFeatures  <- grepl("subject|activity|mean|std", colnames(mergeData))
fullData <- mergeData[, requiredFeatures]

# 3. Uses descriptive activity names to name the activities in the data set
fullData[, 2] <- activity_labels[fullData[,2], 2]


# 4. Appropriately labels the data set with descriptive activity names.
names(fullData)<-gsub("^t", "Time", names(fullData))
names(fullData)<-gsub("^f", "Frequency", names(fullData))
names(fullData)<-gsub("Acc", "Acceleration", names(fullData))
names(fullData)<-gsub("Mag", "Magnitude", names(fullData))
names(fullData)<-gsub("BodyBody", "Body", names(fullData))
names(fullData)<-gsub("mean", "Mean", names(fullData))
names(fullData)<-gsub("std", "StandardDeviation", names(fullData))
names(fullData)<-gsub("Gyro", "Gyroscope", names(fullData))

names(fullData)

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

library("reshape2")
melted <- melt(fullData, id=c("subject","activity"))
tidy <- dcast(melted, subject+activity ~ variable, mean)
write.table(tidy, file=file.path("tidy.txt"), row.names = FALSE, quote = FALSE)
