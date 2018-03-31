#Given file is unzipped and copied in the working directory

library(reshape2) 

# Loading and reading data
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
wantedFeatures <- grep(".*mean.*|.*std.*", features[,2])
wantedFeatures.names <- features[wantedFeatures,2]
wantedFeatures.names = gsub('-mean', 'Mean', wantedFeatures.names)
wantedFeatures.names = gsub('-std', 'Std', wantedFeatures.names)
wantedFeatures.names <- gsub('[-()]', '', wantedFeatures.names)


# Load the datasets
# train dataset
train <- read.table("UCI HAR Dataset/train/X_train.txt")[wantedFeatures]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

#testdataset
test <- read.table("UCI HAR Dataset/test/X_test.txt")[wantedFeatures]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets and add labels
Data <- rbind(train, test)
colnames(Data) <- c("subject", "activity", wantedFeatures.names)

# turn activities & subjects into factors
Data$activity <- factor(Data$activity, levels = activityLabels[,1], labels = activityLabels[,2])
Data$subject <- as.factor(Data$subject)

Data.melted <- melt(Data, id = c("subject", "activity"))
Data.mean <- dcast(Data.melted, subject + activity ~ variable, mean)

# New tidy dataset created as "tidy.txt" 
write.table(Data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
