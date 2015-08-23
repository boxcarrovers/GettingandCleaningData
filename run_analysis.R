## This is the script for final project for getting and cleaning data.
## 
# Downloading the files
pathproject <- file.path('./FinalProject')
list.files(pathproject)
# Now read in test and train key groupings
# 
# VarList is the single vector that names/describes the calculated variables in the data set (561 x 1)
VarList <- read.table('~/RClass/FinalProject/features.txt')
dim (VarList)
# traindata is the main file of calculated observations for a given subject for a given exercise in the control group (7352 x 561)
TrainData <- read.table('~/RClass/FinalProject/X_train.txt')
dim (TrainData)
# trainexercise is a single vector that indicates which of 6 exercise was being performed for a given observation by a given subject (7352 x 1)
TrainExercise <- read.table('~/RClass/FinalProject/y_train.txt')
dim (TrainExercise)
# trainsubject indicates which of the 30 subjects was being observed in teh traindata set (7352 x 1)
TrainSubject <- read.table('~/RClass/FinalProject/subject_train.txt')
dim (TrainSubject)
# now the same process is repeated for the test set of observations/ data
# testdata is the main file of calculated observations for a given subject for a given exercise in the test group (2947 x 561)
TestData <- read.table('~/RClass/FinalProject/X_test.txt')
dim (TestData)
# testexercise is a single vector that indicates which of 6 exercise was being performed for a given observation by a given subject (2947 x 1)
TestExercise <- read.table('~/RClass/FinalProject/y_test.txt')
dim (TestExercise)
# testsubject indicates which of the 30 subjects was being observed in the testdata set (2947 x 1)
TestSubject <- read.table('~/RClass/FinalProject/subject_test.txt')
dim (TestSubject)
## Now want to join these together appropriately
## the main data is stored in TrainData and TestData
## linked to these files, however, is the identity of the subject and a reference to which kind of exercise was being performed
##  thus traindata and testdata need to belinked together
##  trainsubject and testsubeject need to be lineked together
## and trainexercise and testexercise need to be linked together
## to make sure references stay in correct order, will always start with Train (Control) data set
MainData <- rbind(TrainData,TestData)
## MainData will be 7352+2947 rows = 10299 x 561
MainExercise <- rbind(TrainExercise,TestExercise)
## MainExercise will be 10299 x 1
MainSubject<- rbind(TrainSubject,TestSubject)
## MainSubject will be 10299 x 1
dim (MainData)
dim (MainExercise)
dim (MainSubject)

## so now we need to actually assign variable names to the elements in maindata.
## then we will cull out and subset only those ones that reference a mean or std dev calculation
## nagging question 1 - by not putting header = false, have i messed up the naming convention of MainData?
## do easy ones first
names(MainExercise) <- c("exercise")
names(MainSubject) <- c('subject')
## then need to apply VarList (2nd column) to MainData
names(MainData) <- VarList$V2

## now consolidate everything down to 1 master table, since MainSubject and MainExercise can be appended onto MainData (all having 10299 rows)
## this will be a molten table ... ultimately we will want to move some of the rows about exercises into columns so that the rows
## will be subject observations
## the ultimate tidy data set will have something that looks like this:
##  Subject #     WalkMean, WalkStdDev, WalkUpMean, WalkUpStdDev, WalkDownMean, WalkDownStdDev etc...
##   note there may be more than just a walkmean/walkstddev for the walk exercise... so may have more than 12 columns... but that's pretty close
## this will then have 10,299 rows and  6x columns, where x is the number of means and stddevs observed for each exercise

Step1 <- cbind(MainSubject,MainExercise)
str(Step1)
head (Step1)
MasterDataTable <- cbind(Step1,MainData)
str(MasterDataTable)
head(MasterDataTable)

## now want to extract only those variables taht have either mean or standard deviation in them
## there is probably more elegant way to do this, but this works....
jmsubset1 <- grep('mean()',VarList$V2)
jmsubset2 <- grep('std()',VarList$V2)
jmsubset <-c(jmsubset1,jmsubset2)
##need to add 2 to each column to account for 1st two columns in masterdatatable being reference
## and then sort them
jmsubset <- sort(jmsubset+2)
str(jmsubset)
head(jmsubset)
RefinedDataTable <- subset(MasterDataTable, select = c(jmsubset))
##need to add back the columns for subject and exercise
RefinedDataTable <- cbind(Step1,RefinedDataTable)
## now need to annotate the exercise types
RefinedDataTable$exercise <-factor(RefinedDataTable$exercise, levels = c(1,2,3,4,5,6), labels =c('Walk','WalkUp','WalkDown','Sit','Stand','Lay'))
#
#
# Now summarize by creating a tidy data set that has avg of each variable for each exericse and each subject
# first instally plyr package
library (plyr)
tidysummary <- group_by(RefinedDataTable,subject,exercise)
write.table (tidysummary, file = 'jimstidydataproject.txt', row.names = FALSE)



