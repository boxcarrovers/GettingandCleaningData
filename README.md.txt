Read.Me for The Getting and Cleaning Data Class Project
Jim Maloney

This was a challenging project.

The first key step was to understand how the different files worked together and what they actually did. I did several google searches and read in the files and looked at their sizes and dimensions to get a better understanding of what
was going on.

The two most important files - holding the observational data - were the X_test.txt and X_train.txt files.  These each had 561 columns, which matched the features descriptions in the features file (which had 561 rows) and was clearly a description of what the data referenced.

The subject_test and subject_train files had the same number of rows as their respective X_files.  Because the range of the subject file entries was from 1-30 this clearly tied to the 30 participants in the study (the subjects).  And the Y_test/Y_train files matched the rows of their corresponding X_ files; these indicated which kind of exercise/activity was being conducted for the measurement.

The actual files of true measurements (the acc_, gyr_, and total_ etc) were not needed for the analysis as they were used in the compiling of the aggregated measurements in the X_files.

With this understood, it then made sense to join the test & train files together to form larger datasets, after they were read in.
	I did the data first, through an rbind.
	Then I added the information about which subject/exercise combination was part of the observation, through a cbind of the two different files.
Then I had to assign variable names to the dataset, which I did through some names commands using the feature data file.

After that, the next step was to drop the columns that did not have an avg or std measurement. 
There was probably a more elegant way to do this, but I was able to parse the data frame for only those who had an average calculation and those that had an std calculation, and then merge them back together.

I may have left in some freq avg calculated fields that weren't strictly averages, but i figured better to have too much data than too little.

The last step was to create a new tidy data file summary by subject and exercise.  For this I used the group_by command, and then wrote the table out to a file.  Again, there may be a few extra elements here, but this is a tidy data set since each row is an observation - that of a given subject doing a given exercise, and each column is a list of averages around those observations.

