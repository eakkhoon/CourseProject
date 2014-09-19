#  Requirement for this assignments 
#
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names. 
# 5.From the data set in step 4, creates a second, independent tidy data set with 
#   the average of each variable for each activity and each subject.

data.file <- "dataset.zip"

if (!file.exists(data.file)) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                  , data.file)
}

if (!file.exists("UCI HAR Dataset")) {
    unzip(data.file)
}

# Load feature labels to appropriately labels the feature vector with descriptive variable names. 
features <- read.table("UCI HAR Dataset/features.txt", 
                       colClasses=c("NULL","character"), 
                       col.names=c("","label"))

# Construct a column class vector to extracts only the measurements on the mean and standard deviation 
# for each measurement. As per features_info.txt such measurements are identified by the following substring 
# in the label
#   mean(): Mean value
#   std(): Standard deviation
# 
classes <- rep("NULL",nrow(features))

classes[c(grep("mean()", features$label, fixed=TRUE, value=FALSE),
           grep("std()", features$label, fixed=TRUE, value=FALSE))] <- "numeric" 

# load training data
train.set <- cbind(
                    # load training subject variable
                    read.table("UCI HAR Dataset/train/subject_train.txt", 
                                col.names="Subject",
                                colClasses="numeric"),
                    # load training activity variable
                    read.table("UCI HAR Dataset/train/y_train.txt", 
                                col.names="Activity",
                                colClasses="numeric"),
                    # load training feature vectors 
                    read.table("UCI HAR Dataset/train/X_train.txt",  
                                col.names=features$label,
                                colClasses=classes))

# load testing data
test.set <- cbind(
                    # load testing subject variable
                    read.table("UCI HAR Dataset/test/subject_test.txt", 
                                col.names="Subject",
                                colClasses="numeric"),
                    # load testing activity variable
                    read.table("UCI HAR Dataset/test/y_test.txt", 
                                col.names="Activity",
                                colClasses="numeric"),
                    # load testing feature vectors
                    read.table("UCI HAR Dataset/test/X_test.txt",  
                                col.names=features$label,
                                colClasses=classes))                    

# Merges the training and the test sets to create one data set.
merged.set <- rbind(train.set, test.set)

# creates a second, independent tidy data set with the average of each variable for 
# each activity and each subject.
require(plyr)
tidy.set <- ddply(merged.set, c("Subject","Activity"), colMeans)

# appropriately labels the data set with descriptive variable names.
colnames(tidy.set) <- c("Subject","Activity", paste("Average", colnames(tidy.set[3:68]), sep="."))

# Uses descriptive activity names to name the activities in the data set
tidy.set[tidy.set$Activity == 1, "Activity"] <- "WALKING"
tidy.set[tidy.set$Activity == 2, "Activity"] <- "WALKING_UPSTAIRS"
tidy.set[tidy.set$Activity == 3, "Activity"] <- "WALKING_DOWNSTAIRS"
tidy.set[tidy.set$Activity == 4, "Activity"] <- "SITTING"
tidy.set[tidy.set$Activity == 5, "Activity"] <- "STANDING"
tidy.set[tidy.set$Activity == 6, "Activity"] <- "LAYING"

# write out the tidy data set
write.table(tidy.set, file="tidy.txt", row.names=FALSE)

