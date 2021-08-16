# This is the model building part of the exoplanets project. 

# load cleaned data
load("exo_mod.Rdata")
load("exo_mod_test.Rdata")


### Logistic Regression Model with Training
set.seed(273)

# specifies cross validation methods and tuning paramters
logit_ctrl <- trainControl(method = "repeatedcv",
                     number = 10, # k in k-fold cross validation
                     repeats = 3,
                     summaryFunction = twoClassSummary,
                     classProbs = TRUE)

# creates a logistic regression model with cross validation
logit_mod <- train(label ~ .,
                   data = exo_mod,
                   method = "glm",
                   family = "binomial",
                   metric = "ROC",
                   trControl = logit_ctrl)


### Random Forest Model with SMOTE Sampling
set.seed(273)

# specifies cross validation methods and tuning paramters
pgrid <- expand.grid(mtry = 2)

rf_ctrl <- trainControl(method = "repeatedcv",
                     number = 10, # k in k-fold cross validation
                     repeats = 3,
                     sampling = "smote",
                     summaryFunction = twoClassSummary,
                     classProbs = TRUE)

# creates a random forest model with smote sampling and cross validation
smote_fit_rf <- train(label ~ .,
                      data = exo_mod,
                      method = "rf",
                      ntree = 1000,
                      verbose = FALSE,
                      metric = "ROC",
                      importance = TRUE,
                      tuneGrid = pgrid,
                      trControl = rf_ctrl)


### Stochastic Gradient Boosting with SMOTE Sampling
set.seed(273)

# specifies cross validation methods and tuning paramters
gbm_ctrl <- trainControl(method = "repeatedcv",
                     number = 10, # k in k-fold cross validation
                     repeats = 3,
                     sampling = "smote",
                     summaryFunction = twoClassSummary,
                     classProbs = TRUE)

pgrid <- expand.grid(n.trees = 500, 
                     interaction.depth = 3,
                     shrinkage = 0.1, 
                     n.minobsinnode = 50)

# creates GBM with smote sampling and cross validation
smote_fit_gbm <- train(label ~ .,
                       data = exo_mod,
                       method = "gbm",
                       verbose = FALSE,
                       metric = "ROC",
                       tuneGrid = pgrid,
                       trControl = gbm_ctrl)

# saves models
save(logit_mod, file = "logit_mod.Rdata")
save(smote_fit_rf , file = "smote_fit_rf.Rdata")
save(smote_fit_gbm , file = "smote_fit_gbm.Rdata")