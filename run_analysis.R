# Preparing the enviroment
library("data.table", lib.loc="C:/Program Files/R/R-3.1.1/library")
library("reshape2", lib.loc="C:/Program Files/R/R-3.1.1/library")

labels_dt <- read.table("activity_labels.txt")[,2]
features <- read.table("features.txt")[,2]

test_x <- read.table("test/X_test.txt")
test_y <- read.table("test/y_test.txt")
test_subject <- read.table("test/subject_test.txt")

# Appropriately labels the data set with descriptive variable names. 
names(test_x) <- features
names(test_subject) <- "subject"

train_x <- read.table("train/X_train.txt")
train_y <- read.table("train/y_train.txt")
train_subject <- read.table("train/subject_train.txt")

# Appropriately labels the data set with descriptive variable names. 
names(train_x) <- features
names(train_subject) <- "subject"

# Uses descriptive activity names to name the activities in the data set
test_y$activity_label <- labels_dt[test_y[,1]]
names(test_y)[1] <- "activity_id"
test_dt <- cbind(test_subject,test_y,test_x)

train_y$activity_label <- labels_dt[train_y[,1]]
names(train_y)[1] <- "activity_id"
train_dt <- cbind(train_subject,train_y,train_x)

# Merges the training and the test sets to create one data set.
merge_train_test <- rbind(train_dt,test_dt)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
features_mean_std <- grepl("mean|std", features)

# Including first three colluns of data
features_mean_std <- c(T,T,T,features_mean_std)
merge_mean_std <- merge_train_test[,features_mean_std]

vars_labels <- names(merge_mean_std[,-c(1,2,3)])
id_labels <- names(merge_mean_std[,c(1,2,3)])
melt_data <- melt(merge_mean_std, id = id_labels, measure.vars = vars_labels)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data <- dcast(melt_data, subject + activity_label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt", row.names = FALSE)

# Please upload the tidy data set created in step 5 of the instructions. 
# Please upload your data set as a txt file created with write.table() 
# using row.name=FALSE (do not cut and paste a dataset directly into the text box, 
# as this may cause errors saving your submission).
