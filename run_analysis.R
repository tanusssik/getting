library("tidyverse")
library("readr")
#reading test table
setwd("~/Downloads/UCI HAR Dataset/test")
x_test<-read.table("X_test.txt")
y_test<- read.table("Y_test.txt")
subject_test<-read.table("subject_test.txt")

#reading train table
setwd("~/Downloads/UCI HAR Dataset/train")
x_train<-read.table("X_train.txt")
y_train<- read.table("Y_train.txt")
subject_train<- read.table("subject_train.txt")

#reading feature vector
setwd("~/Downloads/UCI HAR Dataset")
features<-read.table("features.txt")

#reading activity Labels
activityLabels=read.table("activity_labels.txt")

#assignment column names
colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

# merging dataset

merge_test<-cbind(y_test, subject_test, x_test)
merge_train<-cbind(y_train, subject_train, x_train)
setAllinOne<-rbind(merge_test, merge_train)

#Extracts only the measurements on the mean and standard deviation for each measurement.
colNames <- colnames(setAllinOne)

deviation <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

setdeviation<- setAllinOne[ , deviation == TRUE]
#Uses descriptive activity names to name the activities in the data set
set_Desc_act_names <- merge(setdeviation, activityLabels,
                              by='activityId',
                              all.x=TRUE)
#From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable for each activity and each subject.

secTidySet <- aggregate(. ~subjectId + activityId, set_Desc_act_names, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)








