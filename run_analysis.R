## download and unzip file

furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(furl, destfile="run_data.zip")

unzip("run_data.zip")

##read txt files to tables


test <- read.table("X_test.txt")
testlab <- read.table("y_test.txt")
testsub <- read.table("subject_test.txt")

train <- read.table("X_train.txt")
trainlab <- read.table("y_train.txt")
trainsub <- read.table("subject_train.txt")

actlab <- read.table("activity_labels.txt")
feats <- read.table("features.txt")

##assign column names & activity names

colnames(test) <- feats[,2]
colnames(testlab) <- "activity"
colnames(testsub) <- "subject"

testlab[testlab$activity==1,1] <- "walking"
testlab[testlab$activity==2,1] <- "walking_upstairs"
testlab[testlab$activity==3,1] <- "walking_downstairs"
testlab[testlab$activity==4,1] <- "sitting"
testlab[testlab$activity==5,1] <- "standing"
testlab[testlab$activity==6,1] <- "laying"

colnames(train) <- feats[,2]
colnames(trainlab) <- "activity"
colnames(trainsub) <- "subject"

trainlab[trainlab$activity==1,1] <- "walking"
trainlab[trainlab$activity==2,1] <- "walking_upstairs"
trainlab[trainlab$activity==3,1] <- "walking_downstairs"
trainlab[trainlab$activity==4,1] <- "sitting"
trainlab[trainlab$activity==5,1] <- "standing"
trainlab[trainlab$activity==6,1] <- "laying"

colnames(actlab) <- c("activity", "type")

## bind datasets

test_all <- cbind(testlab, testsub, test)
train_all <- cbind(trainlab, trainsub, train)

all <- rbind(train_all, test_all)

## vector for subsetting

colnames <- colnames(all)

v_mean_std <- (grepl("activity", colnames)|grepl("subject", colnames)|grepl("mean()", colnames)|grepl("std()", colnames))

## subset & create tidy dataset

tidy_ds <- all[, v_mean_std == TRUE]

## group & average each variable for each activity

by_activity <- group_by(tidy_ds, activity)

mean_activity <- summarize_all(by_activity, funs(mean))

mean_activity <- select(mean_activity, -subject)


## write tidy dataset in .txt file 

write.table(tidy_ds, "tidy_ds.txt", row.name=FALSE)

write.table(mean_activity, "mean_activity.txt", row.name=FALSE)