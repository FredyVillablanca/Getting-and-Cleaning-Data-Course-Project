# Reading "Human Activity Recognition Using Smartphones Data Set"* 

# File url to download

file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Local zipped data file

UCI_HAR_datasetzip <- "./UCI_HAR_datasetzip.zip"

# Local directory for data

directory_file <- "./UCI HAR Dataset"

# Download and unzip conditions

if (file.exists(UCI_HAR_datasetzip) == FALSE) {
  download.file(file_url, destfile = UCI_HAR_datasetzip)
}
if (file.exists(directory_file) == FALSE) {
  unzip(UCI_HAR_datasetzip)
}

# 1. Merges the training and the test sets to create one data set.

# Read and merges subject data

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subject_data <- rbind(subject_train, subject_test)

# Read and merges activity data

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
y_data <- rbind(y_train, y_test)

# Read and merges experiments' obtained dataset set data

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
x_data <- rbind(x_train, X_test)

# Merges the training and the test sets to create one data set.

data_set <- cbind(subject_data,y_data,x_data)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# Read features

features <- read.table("./UCI HAR Dataset/features.txt")

# Extracts measurements

measurements <- features[grep('-(mean|std)\\(\\)', features[, 2 ]), 2]

# 3. Uses descriptive activity names to name the activities in the data set

# Read activities

activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Name the activities in the data set

data_set[, 2] <- activities[data_set[,2], 2]

# 4. Appropriately labels the data set with descriptive variable names. 

# Name the variables

names(data_set) <- c("subject", "activity", measurements)

# Tidy file

write.table(data_set, file=file.path("tidy.txt"), row.names = TRUE, quote = FALSE)
tidy <- read.table("tidy.txt")

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# reshape2 condition

if(!library(reshape2, logical.return = TRUE)) {
    install.packages('reshape2')
}
library(reshape2)

# Cluster 

consolidated <- melt(data_set, id = c('subject', 'activity'))

# Consolidated

average <- dcast(consolidated, subject + activity ~ variable, mean)

# Tidy2 file

write.table(average, file=file.path("tidy2.txt"), row.names = TRUE, quote = FALSE)
tidy2 <- read.table("tidy2.txt")

# *License: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012 This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited. Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.