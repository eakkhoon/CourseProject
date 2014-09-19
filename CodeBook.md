**features** : data frame with a list of feature labels.  This list is used to label the variables of the data set.
 
**classes** : column classes vector used in loading feature vectors from testing and training data using read.table(). "NULL" value is used to mark 
unused variables for this project. Variables with feature labels' substring matching "mean()" or "std()" are marked as "numeric".  This vector will 
serve as a filter during the loading of the feature variables using read.table() to speed up the file loading. 

**train.set** : data frame containing the subject variable, activity variable & feature vectors from the training data using read.table(). **features**' 
is used to label feature variables and **classes** is used to filter the unused variables.  

**test.set** : data frame containing the subject variable, activity variable & feature vectors from the test data using read.table(). **features**' 
is used to label feature variables and **classes** is used to filter the unused variables.                 

**merged.set** : row wise merge of the **train.set** and **test.set**.  Since **train.set** & **test.set** has no intersection we simply perform a rbind().

**tidy.set** : data frame containing the required result for the project generated from **merged.set** by 
+ applying ddply() to **merged.set** using ColMeans().  
+ relabelling the transformed feature variables by prefixing the original feature label with "Average."
+ replace activity code in "Activity" variable with descriptive activity names from activity_labels.txt  

**tidy.set** is written out to "tidy.txt"


