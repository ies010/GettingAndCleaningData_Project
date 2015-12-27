library(reshape2)

# Load activity labels + features
actLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
actLabels[,2] <- as.character(actLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract mean and std
wantedFeatures <- grep(".*mean.*|.*std.*", features[,2])
wantedFeatures.names <- features[wantedFeatures,2]
wantedFeatures.names = gsub('-mean', 'Mean', wantedFeatures.names)
wantedFeatures.names = gsub('-std', 'Std', wantedFeatures.names)
wantedFeatures.names <- gsub('[-()]', '', wantedFeatures.names)

# Load the data
train <- read.table("UCI HAR Dataset/train/X_train.txt")[wantedFeatures]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[wantedFeatures]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

test <- cbind(testSubjects, testActivities, test)

# merge all data - add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", wantedFeatures.names)

# turn into factors
allData$activity <- factor(allData$activity, levels = actLabels[,1], labels = actLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)