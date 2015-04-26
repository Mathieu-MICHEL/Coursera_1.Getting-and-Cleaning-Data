######################################################################################################
#######################################   run_analysis.r   ###########################################
#
# purpose : extract and prepare a tidy data set from the Samsung data.
#
# hypothesis : 
#   1. the variables I am interested in are all the variables coming
#      from a mean or std calculation, including meanFreq() or ***Mean variables
#   2. the data set I want contain solely aggregated values by both subject and activity
#   More details to be found in the ReadMe.
#
# input : the entire 'getdata_projectfiles_UCI HAR Dataset' folder has to be in your working directory.
#
# output : a text file TydyData.txt written in your working directory.
#
######################################################################################################



  ## 0. Getting the data 


# data from the 'test' stream
Test_set <- read.table('./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt')
Test_label <- read.table('./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt')
Test_subject <- read.table('./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt')

# data from the 'train' stream
Train_set <- read.table('./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt')
Train_label <- read.table('./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt')
Train_subject <- read.table('./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt')



  ## 1.'Merges the training and the test sets to create one data set.'


# Merging 'test' and 'train' datasets
dataset <- rbind(Test_set,Train_set)
label <- rbind(Test_label,Train_label)
subject <- rbind(Test_subject,Train_subject)

# Verifying the coherence of the merging step
length(Test_set) == length(Train_set) 
length(dataset) == length(Train_set)
dim(dataset)[1]==dim(Test_set)[1]+dim(Train_set)[1]

  

  ## 2. 'Extracts only the measurements on the mean and standard deviation for each measurement.' 


# Getting the variable names
header <- read.table('./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt')

# Checking which variables we want
col_mean <- grep("mean",header[[2]])
col_Mean <- grep("Mean",header[[2]])
col_std <- grep("std",header[[2]])
col_wanted <- sort(c(col_mean, col_Mean, col_std))

# Defining the new subset
dataset_2 <- dataset[, col_wanted]

#Checking compliance of the process
length(col_wanted) == length(dataset_2)
dim(dataset_2)[1]==dim(dataset)[1]



  ## 3. 'Uses descriptive activity names to name the activities in the data set.'


# Activities are identified in the 'label' data set (originally 'y_test.txt'/'y_train.txt')  
# and there descriptive names are given in 'activity_labels.txt'
activity_label <- read.table('./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt')
activity <- merge(label,activity_label)



  ## 4. 'Appropriately labels the data set with descriptive variable names.'


# Giving the variable names into the dataset
names(dataset_2) <- header[[2]][col_wanted]



  ## 5. 'From the data set in step 4, creates a second, independent tidy data set 
  ## with the average of each variable for each activity and each subject.'


# Properly renaming the activity and subject labels
names(subject) <- 'subject'
names(activity) <- c('y','activity')

# Joining the subject and activity information to the dataset
dataset_3 <- cbind(activity[2], subject, dataset_2)
dim(dataset_3)

# Aggregating the rows (calculating the mean) to get a 88 variables dataset of 30*6=180 rows 
# corresponding to each activity and each subject
dataset_4 <- aggregate(dataset_3,by=list(dataset_3$activity,dataset_3$subject),
                       FUN=mean,na.rm=TRUE)

# Dropping the Group variables generated by the aggregate function
TidyData <- dataset_4[c(-2,-3)]

# Renaming the dataset to match the nature of the observations in it 
names(TidyData)[1] <- "activity" 
names(TidyData)[3:88] <- paste(names(TidyData)[3:88],"Average By Subject&Activity")

# Writing the final dataset into a text file
write.table(TidyData,file="./TidyData.txt",row.name=FALSE)


