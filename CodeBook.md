# DATA DICTIONARY

## UCI_mean_std.csv

### Description

Dataset with the mean and standard deviation from the measures and their activity and subject. Contains data from both the train and test measures.

### Variables

-   mean: mean of the 561-feature vector from the measure. NUMERIC
-   sd: standard deviation of the 561-feature vector from the measures. NUMERIC
-   activity: measure activity. NUMERIC
-   subject: measure subject. NUMERIC

## UCI_mean_std_groupby.csv

### Description

Dataset resulting from a group by the activity and subject in UCI_mean_std.csv. The metric used in the summarise was the mean from the data.

### Variables

-   mean: mean of the mean column from UCI_mean_std.csv. NUMERIC
-   sd: mean of the sd column from UCI_mean_std.csv. NUMERIC
-   activity: measure activity. NUMERIC
-   subject: measure subject. NUMERIC
