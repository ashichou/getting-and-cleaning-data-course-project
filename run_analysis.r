{\rtf1\ansi\ansicpg1252\cocoartf1561\cocoasubrtf400
{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red87\green96\blue106;}
{\*\expandedcolortbl;;\cssrgb\c41569\c45098\c49020;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 setwd("/Users/ashley.chou/Desktop/Coursera/Getting and Cleaning Data")\
\
	\
\pard\pardeftab720\partightenfactor0

\f1 \cf2 \expnd0\expndtw0\kerning0
# Read training data 
\f0 \cf0 \kerning1\expnd0\expndtw0 \
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0
\cf0 subject_Train <- read.table("UCI HAR Dataset/train/subject_train.txt")\
x_Train <- read.table("UCI HAR Dataset/train/X_train.txt")\
y_Train <- read.table("UCI HAR Dataset/train/y_train.txt")\
\
\pard\pardeftab720\partightenfactor0

\f1 \cf2 \expnd0\expndtw0\kerning0
# Read test data 
\f0 \cf0 \kerning1\expnd0\expndtw0 \
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0
\cf0 subject_Test <- read.table("UCI HAR Dataset/test/subject_test.txt")\
x_Test <- read.table("UCI HAR Dataset/test/X_test.txt")\
y_Test <- read.table("UCI HAR Dataset/test/y_test.txt")\
\
\
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")\
features <- read.table("UCI HAR Dataset/features.txt")\
str(features)\
\
str(y_Test)\
str(y_Train)\
str(x_Test)\
str(x_Train)\
str(subject_Test)\
str(subject_Train)\
\
\
\pard\pardeftab720\partightenfactor0

\f1 \cf2 \expnd0\expndtw0\kerning0
#1. Merge the training and the test data.
\f0 \cf0 \kerning1\expnd0\expndtw0 \
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0
\cf0 subjectData <- rbind(subject_Train, subject_Test)\
featuresData <- rbind(x_Train, x_Test) \
activityData <- rbind(y_Train, y_Test)\
names(activityData) <- c("activity")\
names(subjectData) <- c("subject")\
names(featuresData) <- features$V2\
\
mergeData<-cbind(subjectData, activityData, featuresData)\
\
\pard\pardeftab720\partightenfactor0

\f1 \cf2 \expnd0\expndtw0\kerning0
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
\f0 \cf0 \kerning1\expnd0\expndtw0 \
requiredFeatures <- features[grep('-(mean|std)\\\\(\\\\)', features[, 2 ]), 2]\
fullData <- mergeData[, c(1, 2, requiredFeatures)]\
\
dim(fullData)\
\

\f1 \cf2 \expnd0\expndtw0\kerning0
# 3. Uses descriptive activity names to name the activities in the data set
\f0 \cf0 \kerning1\expnd0\expndtw0 \
fullData[, 2] <- activity_labels[fullData[,2], 2]\

\f1 \cf2 \expnd0\expndtw0\kerning0
\
\
\
# 4. Appropriately labels the data set with descriptive activity names.
\f0 \cf0 \kerning1\expnd0\expndtw0 \
names(fullData)<-gsub("^t", "Time", names(fullData))\
names(fullData)<-gsub("^f", "Frequency", names(fullData))\
names(fullData)<-gsub("Acc", "Acceleration", names(fullData))\
names(fullData)<-gsub("Mag", "Magnitude", names(fullData))\
names(fullData)<-gsub("BodyBody", "Body", names(fullData))\
names(fullData)<-gsub("mean", "Mean", names(fullData))\
names(fullData)<-gsub("std", "Std", names(fullData))\
names(fullData)<-gsub("Gyro", "Gyroscope", names(fullData))\
\
\
names(fullData)
\f1 \cf2 \expnd0\expndtw0\kerning0
\
\
\
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. \
\

\f0 \cf0 \kerning1\expnd0\expndtw0 \
if (!require("reshape2")) \{\
  install.packages("reshape2")\
\}\
library("reshape2")\
melted <- melt(fullData, id=c("subject","activity"))\
tidy <- dcast(melted, subject+activity ~ variable, mean)\
write.table(tidy, file=file.path("tidy.txt"), row.names = FALSE, quote = FALSE)\
\
\
\
\
}