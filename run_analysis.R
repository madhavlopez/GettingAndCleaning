#Download file and unzip
if(!file.exists("UCIHAR.zip")) {
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              "UCIHAR.zip", method = "curl")
        unzip("UCIHAR.zip")
}

#Read in everthing
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
stest <- read.table("UCI HAR Dataset/test/subject_test.txt")
strain <- read.table("UCI HAR Dataset/train/subject_train.txt")
ftext <- read.table("UCI HAR Dataset/features.txt")
alabs <- read.table("UCI HAR Dataset/activity_labels.txt")

#Set column names
names(xtest) <- ftext[ , 2]
names(xtrain) <- ftext[ , 2]
names(ytest) <- "activity"
names(ytrain) <- "activity"
names(stest) <- "subject"
names(strain) <- "subject"

#Merge train and test sets
test <- cbind(stest, ytest, xtest)
train <- cbind(strain, ytrain, xtrain)
tt <- rbind(test, train)

#Extract means and standard deviations
mcol <- grep("mean", names(tt), value = TRUE)
scol <- grep("std", names(tt), value = TRUE)
ecol <- c("subject", "activity")
ecol <- append(ecol, mcol)
ecol <- append(ecol, scol)
mscol <- tt[ , ecol]

#Change activity ID to name
mscol$activity <- factor(mscol$activity, labels = alabs[ , 2])

#Give descriptive column names
names(mscol) <- gsub("^t", "Time", names(mscol))
names(mscol) <- gsub("^f", "Frequency", names(mscol))
names(mscol) <- gsub("Acc", "Acceleration", names(mscol))
names(mscol) <- gsub("Gyro", "Gyroscope", names(mscol))
names(mscol) <- gsub("Mag", "Magnitude", names(mscol))

#Make the independent tidy data set
td <- aggregate(.~subject+activity, data = mscol, mean)
write.table(td, "tidydata.txt", row.names = FALSE)