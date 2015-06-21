## Load the needed libraries
library(plyr)
library(tidyr)

## To check the working directory and then set the directory to the appropriate work space
getwd()
setwd("\\\\prod-am.ameritrade.com/userhome/cro202/My Documents/JHU Data Science Spec//Getting and Cleaning Data/Course Project")

## checking to make sure all files are in current wd
list.files()

x1 <- read.table("UCI HAR Dataset/train/X_train.txt")
y1 <- read.table("UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
View(x1)

x2 <- read.table("UCI HAR Dataset/test/X_test.txt")
y2 <- read.table("UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
View(x2)

## To combine all x, y, and subject data
all_x <- rbind(x1, x2)
head(all_x)
View(all_x)

all_y <- rbind(y1, y2)
head(all_y)
View(all_y)

all_subject <- rbind(subjectTrain, subjectTest)
head(all_subject)
View(all_subject)

## To read in the features text containing measurements 
feat <- read.table("UCI HAR Dataset/features.txt")
View(feat)

## get columns with only mean and standard deviation 
meanAndStdDev <- grep("-(mean)\\(\\)", feat[, 2]) | grep("-(std)\\(\\)", feat[, 2])

## subsetting all x data
xSub <- all_x[, meanAndStdDev, 2]
View(xSub)

## update column names
names(xSub) <- feat[meanAndStdDev, 2]
head(xSub)
View(xSub)

## to read in the activities file
actLabels <- read.table("UCI HAR Dataset/activity_labels.txt")

## updates all_y with activity names
all_y[, 1] <- actLabels[all_y[, 1], 2]
View(all_y)

## adding column name for all_y
names(all_y) <- "activity"
View(all_y)

## adding column name for all_subject
names(all_subject) <- "subject"
View(all_subject)

## full bind of all data tables
df <- cbind(xSub, all_y, all_subject)
View(df)

## have to take means up to only 66, due to numeric error
ave <- ddply(df, .(subject, activity), function(x) colMeans(x [, 1:66]))
View(ave)


## write to a csv
write.table(ave, "jhu3averages.txt", row.names = FALSE )

## to check if it wrote properly
list.files()
check <- read.table(file = "jhu3averages.txt", header = T)
View(check)


