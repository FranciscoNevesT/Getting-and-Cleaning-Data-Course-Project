# Getting-and-Cleaning-Data-Course-Project

## Overview

This repository contains a script for cleaning and transforming data from the Human Activity Recognition Using Smartphones dataset.

## Script Usage

The scrip run_analysis.R cleans the data and follow this steps:

1.  Download and unzip the data from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

2.  Reads and formats the training and test datasets.

3.  Groups the resulting dataset by activity and subject, and calculates the mean of each column.

4.  Saves the processed dataset to a file named UCI_mean_std_groupby.txt.

5.  Creates a Code book that describes the variables in the processed dataset.
