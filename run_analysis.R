library(data.table)
library(dplyr)

read_file <- function(path){
  x <- readLines(path)
  x <- strsplit(x,split = " ")
  
  y <- sapply(x, function(a) {as.numeric(a)})
  y <- as.data.frame(sapply(y, function(a) { a[!is.na(a)]}))
  
  transpose(y)
  
}

read_seq <- function(path){
  x <- readLines(path)
  
  as.numeric(x)
  
}


read_data <- function(path_file,path_seq1,path_seq2){
  
  dataset <- read_file(path_file)
  dataset["activity"] <- read_seq(path_seq1)
  dataset["subject"] <- read_seq(path_seq2)
  
  dataset
  
}

get_mean_sd <- function(dataset){
  d <- transpose(dataset)
  
  d <- lapply(d, function(x) { c(mean(x),sd(x))})
  
  d <- transpose(as.data.frame(d))
  
  colnames(d) = c("mean","sd")
  
  d
}

compute_mean_sd <- function(dataset){
  size_dataset = length(colnames(dataset))
  
  x <- get_mean_sd(dataset[-c(size_dataset,size_dataset - 1)])
  x["activity"] <- dataset["activity"]
  x["subject"] <- dataset["subject"]
  
  x
}


test_set <- read_data("UCI HAR Dataset/test/X_test.txt",
                      "UCI HAR Dataset/test/y_test.txt",
                      "UCI HAR Dataset/test/subject_test.txt")

train_set <- read_data("UCI HAR Dataset/train/X_train.txt",
                       "UCI HAR Dataset/train/y_train.txt",
                       "UCI HAR Dataset/train/subject_train.txt")


dataset <- compute_mean_sd(rbind(train_set,test_set))

write.csv(dataset, "UCI_mean_std.csv")

groupby_dataset <- dataset %>% group_by(activity,subject) %>% summarise(mean = mean(mean),
                                                   sd = sd(sd))

write.csv(dataset, "UCI_mean_std_groupby.csv")
