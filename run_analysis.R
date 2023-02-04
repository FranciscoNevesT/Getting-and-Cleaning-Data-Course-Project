library(data.table)
library(dplyr, warn.conflicts = FALSE)
library(utils)

download_dataset <- function(url, file_path) {
  download.file(url, file_path)
  unzip(file_path)
  file.remove(file_path)
}

names <- readLines("UCI HAR Dataset/features.txt")
names <- sapply(names, function(x) {strsplit(x, split = " ")[[1]][2]})

read_data <- function(file_path, seq1_path, seq2_path) {
  x <- readLines(file_path)
  x <- strsplit(x, split = " ")
  y <- sapply(x, function(a) { as.numeric(a) })
  y <- as.data.frame(sapply(y, function(a) { a[!is.na(a)] }))

  dataset <- transpose(y)
  colnames(dataset) <- names
  dataset$activity <- as.numeric(readLines(seq1_path))
  dataset$subject <- as.numeric(readLines(seq2_path))
  dataset
}

get_mean_sd <- function(dataset) {
  mean_sd_cols <- grep("mean\\(\\)|std\\(\\)", names(dataset))
  mean_sd_cols <- names[mean_sd_cols]
  
  dataset[, c(mean_sd_cols, "activity", "subject")]
}

if (!dir.exists("UCI HAR Dataset")){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  
  download_dataset(url, "file.zip")
}



test_set <- read_data("UCI HAR Dataset/test/X_test.txt",
                      "UCI HAR Dataset/test/y_test.txt",
                      "UCI HAR Dataset/test/subject_test.txt")

train_set <- read_data("UCI HAR Dataset/train/X_train.txt",
                       "UCI HAR Dataset/train/y_train.txt",
                       "UCI HAR Dataset/train/subject_train.txt")

dataset <- rbind(train_set, test_set)
dataset <- get_mean_sd(dataset)


groupby_dataset <- dataset %>% group_by(activity,subject) %>% summarise(across(everything(), list(mean)))

write.table(dataset, "UCI_mean_std_groupby.txt", row.names = FALSE)


#Writing in the codebook


str_codebook <- "# Code Book \n## Variables: "

column_types <- sapply(groupby_dataset, class)
for (i in 1:ncol(groupby_dataset) ){
  
  name <- colnames(groupby_dataset[i])
  type_i <- column_types[[i]]
  values_unique <- unique(groupby_dataset[i])[[1]]

  str_codebook <- paste(str_codebook, "\n\n### ", name)
  str_codebook <- paste(str_codebook, "\n - Type: " , type_i)
  str_codebook <- paste(str_codebook, "\n - Size: ", length(groupby_dataset[i][[1]]))
  str_codebook <- paste(str_codebook, "\n - Unique values: ", length(values_unique), " : ")
  
  for (j in 1:3){
    str_codebook <- paste(str_codebook,values_unique[j])
  }
  
  str_codebook <- paste(str_codebook, "...")
  
}

str_codebook <- paste(str_codebook, "\n\n## activity:")

for (i in readLines("UCI HAR Dataset/activity_labels.txt")){
  str_codebook <- paste(str_codebook, "\n - ", i)
}

writeLines(str_codebook,"CodeBook.md")

