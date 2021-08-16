# This file contains the data management for the exoplanet project


# load helper functions
source("helper.R")

# read in data
exo <- read.csv("exoTrain.csv")
exo_test <- read.csv("exoTest.csv")


### Training set

# initialize datasets
exo_diff <- exo_mod <- data.frame(label = exo$LABEL) 

# find differences in light from i to i - 1 time points 
for (i in 3:3198) {
  exo_diff <- cbind(exo_diff, exo[, i] - exo[, i - 1])
}

# change labels from 1 and 2 to no_exoplanet and exoplanet
exo_mod$label <- exo_mod$label - 1
exo_mod$label <- factor(exo_mod$label, labels = c("no_exoplanet", "exoplanet"))

# create variables for model building, these variables are summary statistics
# for the light data of each star (row)
exo_mod$means <- apply(abs(exo_diff[, -1]), 1, mean) # mean of differences
exo_mod$vars <- apply(abs(exo_diff[, -1]), 1, var) # var of differences
exo_mod$max_diff <- apply(abs(exo_diff[, -1]), 1, max) # max of differences
exo_mod$max_stand <- apply(abs(exo[, -1]), 1, max_stand) # standardized max light

# finds the amount of times the difference in light from point i to i - 1
#changes sign
exo_mod$abs_diff_chg_sign <- apply(abs(exo_diff[, -1]), 1, change_sign) 


### Testing Set

# initialize datasets
exo_diff_test <- exo_mod_test <- data.frame(label = exo_test$LABEL)

# find differences in light from i to i - 1 time points 
for (i in 3:3198) {
  exo_diff_test <- cbind(exo_diff_test, exo_test[, i] - exo_test[, i - 1])
}

# change labels from 1 and 2 to no_exoplanet and exoplanet
exo_mod_test$label <- exo_mod_test$label - 1
exo_mod_test$label <- factor(exo_mod_test$label, labels = c("no_exoplanet", "exoplanet"))

# create variables for model building, these variables are summary statistics
# for the light data of each star (row)
exo_mod_test$means <- apply(abs(exo_diff_test[, -1]), 1, mean) # mean of differences
exo_mod_test$vars <- apply(abs(exo_diff_test[, -1]), 1, var) # var of differences
exo_mod_test$max_diff <- apply(abs(exo_diff_test[, -1]), 1, max) # max of differences
exo_mod_test$max_stand <- apply(abs(exo_test[, -1]), 1, max_stand) # standardized max light

# finds the amount of times the difference in light from point i to i - 1
# changes sign
exo_mod_test$abs_diff_chg_sign <- apply(abs(exo_diff_test[, -1]), 1, change_sign) 

# saves data
save(exo_mod, file = "exo_mod.Rdata")
save(exo_mod_test, file = "exo_mod_test.Rdata")