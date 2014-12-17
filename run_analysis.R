# Packages needed:
# install.packages("plyr")
# 



# Check if data exists and if not, download data

if (!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile = "getdata_projectfiles_UCI HAR Dataset.zip")
  unzip("getdata_projectfiles_UCI HAR Dataset.zip")
}

########

# Load data

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")


# Merge each test and train data to own dataframe

x_data <- rbind(x_train, x_test)
subject_data <- rbind(subject_train, subject_test)
y_data <- rbind(y_train, y_test)


# Add labels and change activity numbers to labels (Steps 3 & 4)

colnames(x_data) <- features[,2]

library(plyr)
y_data <- join(y_data,activity_labels)
y_data <- as.data.frame(y_data[,2])
colnames(y_data) <- "activity"

colnames(subject_data) <- "subject"

# Get measurements, which are either mean or standart deviation (Step 2)

x_data <- x_data[,grep("mean\\(\\)|std\\(\\)", colnames(x_data))]


# Final merge of separated data (Step 1)

merge_Data <- cbind(subject_data,y_data,x_data)

##########

# Create the tidyData (Step 5)

tidyData <- aggregate(merge_Data[,-c(1,2)], 
  by = list(
  activity = merge_Data$activity,
  subject = merge_Data$subject), 
  mean)

# Write the tidyData
write.table(tidyData, "tidyData.txt",row.names=F)


