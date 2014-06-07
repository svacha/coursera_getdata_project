## run_analysis.r 

## PART 0: LOAD THE DATA FROM THE FILES

## Folder where the data lives
data_folder <- "UCI\ HAR\ Dataset"

## Data files we need to load
files <- c(
activity_labels="activity_labels.txt",
features="features.txt",
x_test="test/X_test.txt",
y_test="test/y_test.txt",
subject_test="test/subject_test.txt",
x_train="train/X_train.txt",
y_train="train/y_train.txt",
subject_train="train/subject_train.txt"
)

for (i in 1:length(files)) {
    files[i] <- paste(data_folder,'/',files[i],sep="")
}


activity_labels <- read.table(files["activity_labels"])
features <- read.table(files["features"])
x_test <- read.table(files["x_test"])
y_test <- read.table(files["y_test"])
subject_test <- read.table(files["subject_test"])
x_train <- read.table(files["x_train"])
y_train <- read.table(files["y_train"])
subject_train <- read.table(files["subject_train"])


## Provided the raw features dataframe, return a vector of cleaned names 
## (make lowercase and remove nonletter chars)
clean_features <- function(x) {
    y <- x$V2
    y <- tolower(y)
    y <- gsub("\\W", "", y)
    y
}


## PART 1: MERGE SEPARATE DATAFRAMES INTO A SINGLE TIDY DATAFRAME

## Combine test and train data
x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)$V1

## Apply the feature names to the data
colnames(x) <- clean_features(features)

## Subset the data to keep only mean and std of the measurements
mean_and_std_data <- x[, grep("(mean|std)[xyz]?$", colnames(x))]

## Use the y data to get the labeled activities
activity <- activity_labels$V2[y$V1]

## Merged the selected feature data with the subject and labeled activity
tidy_data <- cbind(subject, activity, mean_and_std_data)

## Save the tidy data to a file
write.table(tidy_data, file="tidy_mean_and_std_data.txt")


## PART 2: CREATE A SECOND TIDY DATAFRAME OF THE AVERAGE OF EACH FEATURE BY SUBJECT AND ACTIVITY

library(reshape2)

## Melt data to make each feature column into a rows 
mtidy_data <- melt(tidy_data, id.vars = c('subject', 'activity'), variable.name = "feature", value.name = "measurement")

## Append 'avg' to the feature labels for clarity
mtidy_data$feature <- sub("(.*)", "\\1avg", mtidy_data$feature)

## Cast data back into wide table while applying the mean function
data_feature_averages <- dcast(mtidy_data, subject + activity ~ feature, mean, value.var = "measurement")

## Save the tidy data to a file
write.table(data_feature_averages, file="tidy_feature_averages.txt")

