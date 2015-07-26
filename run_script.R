setwd("/Users/angelaxie/Google Drive/coursera/getting_and_cleaning_data/project/features_info.txt")


####read in data#####
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")
X_test <- read.table("test/X_test.txt")
subject_test <- read.table("test/subject_test.txt")
y_test <- read.table("test/y_test.txt")
X_train <- read.table("train/X_train.txt")
subject_train <- read.table("train/subject_train.txt")
y_train <- read.table("train/y_train.txt")

###combine test set data
#label X_test columns with feature names
colnames(X_test) <- features$V2
#label X_test rows with subject
X_test$subject <- subject_test$V1
#label X_test rows with acvitiy code
X_test$activity_code <- y_test$V1
#replace activity codes with activity label
colnames(activity_labels) <- c("activity_code","activity_label")
X_test_final <- merge(X_test,activity_labels,by="activity_code")

###combine training set data
#label X_train columns with feature names
colnames(X_train) <- features$V2
#label X_train rows with subject
X_train$subject <- subject_train$V1
#label X_train rows with acvitiy code
X_train$activity_code <- y_train$V1
#replace activity codes with activity label
X_train_final <- merge(X_train,activity_labels,by="activity_code")

###combine test set and training set into one dataframe
data <- rbind(X_train_final,X_test_final)

###select mean and std columns
library(dplyr)
data_mean <- select(data,contains("mean\\(."))
data_std <- select(data,contains("std\\(."))
data_selc <- cbind(data_mean,data_std)

###add back activity labels and subject
data_selc2 <- cbind(data_selc,data[,c("activity_label","subject")])

####
library(reshape2)
data_selc2_melt <- melt(data_selc2,id=c("subject","activity_label"),measure.var=colnames(data_selc2)[1:66])
data_selc2_recast <- dcast(data_selc2_melt,subject + activity_label ~ value,ave)


