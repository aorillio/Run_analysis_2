unzip(zipfile = "getdata_projectfiles_UCI HAR Dataset.zip", exdir = "./data")

list.files("~/Desktop/Coursera Work/Getting_Cleaning_Data/Week 4 project/data/UCI HAR Dataset")

pathdata = file.path("~/Desktop/Coursera Work/Getting_Cleaning_Data/Week 4 project/data/UCI HAR Dataset")

# list files in Dataset folder
# list.files("UCI HAR Dataset")
# [1] "activity_labels.txt" "features_info.txt"   "features.txt"       
# [4] "README.txt"          "test"                "train"              
# [7] "Week 4 run_analysis"

#Reading training tables
xtrain = read.table(file.path(pathdata, "train", "X_train.txt"), header = FALSE)
ytrain = read.table(file.path(pathdata, "train", "Y_train.txt"), header = FALSE)
subtrain = read.table(file.path(pathdata, "train", "subject_train.txt"), header = FALSE)

#Reading testing tables
xtest = read.table(file.path(pathdata, "test", "X_test.txt"), header = FALSE)
ytest = read.table(file.path(pathdata, "test", "Y_test.txt"), header = FALSE)
subtest = read.table(file.path(pathdata, "test", "subject_test.txt"), header = FALSE)

#Read features data
features = read.table(file.path(pathdata, "features.txt"),header = FALSE)
#Read activity labels data
activityLabels = read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

#create column values to the Train data
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subtrain) = "subjectId"

#create column values to the Test data
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subtest) = "subjectId"

#create activity labels value
colnames(activityLabels) <- c('activityId', 'activityType')

#merge the train and test data
mrg_train = cbind(ytrain, subtrain, xtrain)
mrg_test = cbind(ytest, subtest, xtest)

#created main data table merging both tables
AllDataTogether = rbind(mrg_train, mrg_test)

#read all values available in merged master dataset
colNames = colnames(AllDataTogether)

#obtain subset of all values available
mean_std = (grepl("activityId", colNames) | grepl("subjectId", colNames)
                 | grepl("mean..", colNames) | grepl("std..", colNames))

mean_std_subset <- AllDataTogether[, mean_std == TRUE]

subsetwithactivitynames = merge(mean_std_subset, activityLabels, by = 'activityId', all.x = TRUE)

#New Tidy Data Set

TidyData <- aggregate(. ~subjectId + activityId, subsetwithactivitynames, mean)
TidyData <- TidyData[order(TidyData$subjectId, TidyData$activityId),]

write.table(TidyData, "TidyData.txt", row.names = FALSE)

#End

