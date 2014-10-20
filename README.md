How the Script Works
=========================
The file run_analysis.R is the script for the course project for Getting and Cleaning Data.

When to run the script, make some adjustments on the directory to make sure the data set would be read propoerly in your computer.

The first part is to read the training data set and the test data set. Then merge the two data sets to get one data set for next steps.

The second part is to xxtracts only the measurements on the mean and standard deviation for each measurement. 
The strategy is to create a logcial varaible indicating whether or not the names of the original variables contain "mean" or "std" but not "meanFreq".
Apply the logical variable as the condition to get a subset.

The third part is to change the numeric activity variable into descriptive names.

The fourth part is to rename the variable names in a more detailed descriptive way.

The fifth part is to compute the average of each variable for each activity and each subject.
The strategy is to create a double-level loop to get subsets for each activity and each subject.
Apply colMeans() to compute the means of each variable for each subset created in the loop.

The sixth part is to save the completed data set (names included) and the tidy data set (numbers alone) as txt files.

The output would be the tidy data set submitted in part 1 of the course project.
