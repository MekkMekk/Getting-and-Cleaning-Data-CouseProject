
if (!require("data.table")) {
    install.packages("data.table")
}

if (!require("reshape2")) {
    install.packages("reshape2")
}

require("data.table")
require("reshape2")


# Load: activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Load: data column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)



# Load and process X_train & y_train data
YTrain = read.table("Y_train.txt")
XTrain = read.table("X_train.txt")
TrainSub = read.table("subject_train.txt")

names(XTrain) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
XTrain = XTrain[,extract_features]

# Load activity labels
YTrain[,2] = activity_labels[YTrain[,1]]
names(YTrain) = c("Activity_ID", "Activity_Label")
names(TrainSub) = "subject"

# Bind data
Trainall <- cbind(as.data.table(TrainSub), YTrain, XTrain)

#Write data out to Excel file for review
#library(openxlsx)
#write.xlsx(Trainall, file = "Trainall.xlsx", n=3)





# Load and process X_test & y_test data
YTest = read.table("Y_test.txt")
XTest = read.table("X_test.txt")
TestSub = read.table("subject_test.txt")

names(XTest) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
XTest = XTest[,extract_features]

# Load activity labels
YTest[,2] = activity_labels[YTest[,1]]
names(YTest) = c("Activity_ID", "Activity_Label")
names(TestSub) = "subject"

# Bind data
Testall <- cbind(as.data.table(TestSub), YTest, XTest)

#Write data out to Excel file for review
#library(openxlsx)
#write.xlsx(Testall, file = "Testall.xlsx", n=3)


# Merge test and train data
data = rbind(Testall, Trainall)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melted_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melted_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)
