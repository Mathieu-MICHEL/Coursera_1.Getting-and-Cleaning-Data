# Getting-and-Cleaning-Data
A repo containing the files required for the Coursera course project on 'Getting and Cleaning Data'

This ReadMe has the purpose to explain the choices made to fulfill the requirements of the course Project 'Getting and Cleaning Data'. 

The current Repo contains:
1. the R code for the run_anlysis.R program
2. a code book describing the variables present in the final tidy data set
3. this ReadMe.

The general idea of the run_analysis.R program is:

- to get the so called Samsung Data (as the entire folder 'getdata_projectfiles_UCI HAR Dataset' registered in the working directory) ;

- to properly subset, join and rename them (this is discribed step by step in comments of the program)
  basically the labels are reattributed to the proper variables; the variables are then selected according to the
  "Extracts only the measurements on the mean and standard deviation for each measurement." requirement.
  Warning!!! A choice is made there to keep all variables that can be considered as a mean or a standard deviation 
  of any measurements (i.e. including meanFreq and **Name**Mean variables)

- to aggregate them into a new tidy data set. 
  Warning!!! The choice is made here to just let at the end the activity, subject and every previous variables  
  aggregated as average on both subject and activity. The final dataset is renamed according to the recalculated
  values it contains.  

