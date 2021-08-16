# This file contains the helper functions for exoplanet project

# calculates standardized max of a vector
max_stand <- function(x){
  (max(x) - mean(x))/sd(x)
}

# calculates the amount of times the values of a vector 
# change signs from i to i - 1
change_sign <- function(x){
  c <- 0
  for (i in 2:length(x)) {
    if(sign(x[i]) !=  sign(x[i - 1])){
      c <- c + 1
    }
  }
  c
}