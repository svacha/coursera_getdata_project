## run_analysis.r 

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


merged_test <- x_test
colnames(merged_test) <- clean_features(features)
merged_test <- cbind(y_test, subject_test, merged_test)
names(merged_test)[1:2] <- c('activitynumber', 'subject')
activitylabel <- activity_labels$V2[merged_x$activitynumber]
merged_test <- cbind(activitylabel, merged_test)


