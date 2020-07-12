pacman::p_load("caret","ROCR","lift","glmnet","MASS","e1071","partykit","rpart","randomForest","xgboost", "dplyr", "plyr","matrixStats") #Check, and if needed install the necessary packages

#Load data
new.data<-read.csv(file.choose(), na.strings=c(""," ","NA"), header=TRUE)
disease<-read.csv(file.choose(), na.strings=c(""," ","NA"), header=TRUE)

#Change to as.factor
new.data$SLD010H<-as.factor(new.data$SLD010H)
new.data$IND235<-as.factor(new.data$IND235)
new.data$HUQ061<-as.factor(new.data$HUQ061)
new.data$WHQ070<-as.factor(new.data$WHQ070)
new.data$HOD050<-as.factor(new.data$HOD050)
new.data$PFQ061A<-as.factor(new.data$PFQ061A)
new.data$HUQ030<-as.factor(new.data$HUQ030)
new.data$HUD080<-as.factor(new.data$HUD080)
new.data$PFQ061T<-as.factor(new.data$PFQ061T)
new.data$PFQ061S<-as.factor(new.data$PFQ061S)
new.data$PFQ061E<-as.factor(new.data$PFQ061E)
new.data$PFQ061D<-as.factor(new.data$PFQ061D)
new.data$RIDRETH3<-as.factor(new.data$RIDRETH3)
new.data$PFQ061G<-as.factor(new.data$PFQ061G)
new.data$OCQ380<-as.factor(new.data$OCQ380)
new.data$INQ030<-as.factor(new.data$INQ030)
new.data$CDQ008<-as.factor(new.data$CDQ008)
new.data$PFQ061Q<-as.factor(new.data$PFQ061Q)
new.data$HUQ010<-as.factor(new.data$HUQ010)
new.data$DPQ100<-as.factor(new.data$DPQ100)
new.data$DMDHHSZE<-as.factor(new.data$DMDHHSZE)
new.data$CSQ202<-as.factor(new.data$CSQ202)


disease$Essential..primary..hypertension<-as.factor(disease$Essential..primary..hypertension)
disease$Pure.hypercholesterolemia<-as.factor(disease$Pure.hypercholesterolemia)
disease$Type.2.diabetes.mellitus<-as.factor(disease$Type.2.diabetes.mellitus)


str(new.data)
#Set seed
set.seed(190592)

####################
### Hypertension ###
####################

###
### Prepare data
###
hypertension.short <- cbind(new.data,disease[,c(2,ncol(disease))])
hypertension.short <- hypertension.short[,c(2:(ncol(hypertension.short)-1))]
inTrain <- createDataPartition(y = hypertension.short$Essential..primary..hypertension,
                               p = 0.8, list = FALSE)
training <- hypertension.short[ inTrain,]
testing <- hypertension.short[ -inTrain,]

###
### Logistic regression
###
model_logistic<-glm(Essential..primary..hypertension~ ., data=training, family="binomial"(link="logit"))

model_logistic_stepwiseAIC<-stepAIC(model_logistic,direction = c("both"),trace = 1) #AIC stepwise

summary(model_logistic_stepwiseAIC) 

par(mfrow=c(1,4))
plot(model_logistic_stepwiseAIC) #Error plots: similar nature to lm plots
par(mfrow=c(1,1))

###Finding predicitons: probabilities and classification
logistic_probabilities<-predict(model_logistic_stepwiseAIC,newdata=testing,type="response") #Predict probabilities
logistic_classification<-rep("1",2035)
logistic_classification[logistic_probabilities<0.1]="0" #Predict classification using 0.1 threshold
logistic_classification<-as.factor(logistic_classification)

###Confusion matrix  
confusionMatrix(logistic_classification,testing$Essential..primary..hypertension,positive = "1") #Display confusion matrix

####ROC Curve
logistic_ROC_prediction <- prediction(logistic_probabilities, testing$Essential..primary..hypertension)
logistic_ROC <- performance(logistic_ROC_prediction,"tpr","fpr") #Create ROC curve data
plot(logistic_ROC) #Plot ROC curve

####AUC (area under curve)
auc.tmp <- performance(logistic_ROC_prediction,"auc") #Create AUC data
logistic_auc_testing <- as.numeric(auc.tmp@y.values) #Calculate AUC
logistic_auc_testing #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(logistic_probabilities, testing$Essential..primary..hypertension, cumulative = TRUE, n.buckets = 10) # Plot Lift chart

###
### CTREE
###

ctree_tree<-ctree(Essential..primary..hypertension~.,data=training) #Run ctree on training data
plot(ctree_tree, gp = gpar(fontsize = 8)) #Plotting the tree (adjust fontsize if needed)

ctree_probabilities<-predict(ctree_tree,newdata=testing,type="prob") #Predict probabilities
ctree_classification<-rep("1",2035)
ctree_classification[ctree_probabilities[,2]<0.1]="0" #Predict classification using 0.1 threshold
ctree_classification<-as.factor(ctree_classification)

###Confusion matrix  
confusionMatrix(ctree_classification,testing$Essential..primary..hypertension,positive = "1")

####ROC Curve
ctree_probabilities_testing <-predict(ctree_tree,newdata=testing,type = "prob") #Predict probabilities
ctree_pred_testing <- prediction(ctree_probabilities_testing[,2], testing$Essential..primary..hypertension) #Calculate errors
ctree_ROC_testing <- performance(ctree_pred_testing,"tpr","fpr") #Create ROC curve data
plot(ctree_ROC_testing) #Plot ROC curve

####AUC (area under curve)
auc.tmp <- performance(ctree_pred_testing,"auc") #Create AUC data
ctree_auc_testing <- as.numeric(auc.tmp@y.values) #Calculate AUC
ctree_auc_testing #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(ctree_probabilities[,2],  testing$Essential..primary..hypertension, cumulative = TRUE, n.buckets = 10) # Plot Lift chart

#
# Random Forest
#

model_forest <- randomForest(Essential..primary..hypertension~ ., data=training, 
                             importance=TRUE,
                             cutoff = c(0.9, 0.1),type="classification", ntree = 500, mtry = 20, nodesize = 20, maxnodes = 30)
# No good answers on how to determine hyperparameters of ntree, mtry, etc. 

print(model_forest)   
plot(model_forest)
importance(model_forest)
varImpPlot(model_forest)

###Finding predicitons: probabilities and classification
forest_probabilities<-predict(model_forest,newdata=testing,type="prob") #Predict probabilities -- an array with 2 columns: for not retained (class 0) and for retained (class 1)
forest_classification<-rep("1",2035)
forest_classification[forest_probabilities[,2]<0.1]="0" #Predict classification using 0.5 threshold. 
forest_classification<-as.factor(forest_classification)

confusionMatrix(forest_classification,testing$Essential..primary..hypertension, positive="1") #Display confusion matrix.

#There is also a "shortcut" forest_prediction<-predict(model_forest,newdata=testing, type="response") 
#But it by default uses threshold of 50%: 

####ROC Curve
forest_ROC_prediction <- prediction(forest_probabilities[,2], testing$Essential..primary..hypertension~ .) #Calculate errors
forest_ROC <- performance(forest_ROC_prediction,"tpr","fpr") #Create ROC curve data
plot(forest_ROC) #Plot ROC curve

####AUC (area under curve)
AUC.tmp <- performance(forest_ROC_prediction,"auc") #Create AUC data
forest_AUC <- as.numeric(AUC.tmp@y.values) #Calculate AUC
forest_AUC #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(forest_probabilities[,2],  testing$Essential..primary..hypertension~ ., cumulative = TRUE, n.buckets = 10) # Plot Lift chart

### An alternative way is to plot a Lift curve not by buckets, but on all data points
Lift_forest <- performance(forest_ROC_prediction,"lift","rpp")
plot(Lift_forest)


###
### With Support Vector Machines (SVM)
###

pacman::p_load("caret","ROCR","lift","glmnet","MASS","e1071") 

model_svm <- svm(Essential..primary..hypertension ~., data=training, probability=TRUE)
summary(model_svm)

svm_probabilities<-attr(predict(model_svm,newdata=testing, probability=TRUE), "prob")

svm_classification<-rep("1",2035)
svm_classification[svm_probabilities[,2]<0.1]="0" 
svm_classification<-as.factor(svm_classification)
confusionMatrix(svm_classification,testing$Essential..primary..hypertension,positive = "1")



###
### With Deep Learning (using TensorFlow controlled via Keras)
###

# The initial installation is a bit tricky, use the code below for the first time; after that, pacman

#install.packages("tensorflow")
#library(tensorflow)
#install_tensorflow()
#tf$constant("Hellow Tensorflow") ## a simple way to check if it installed correctly

#install.packages("keras")
#library(keras)
#install_keras()

pacman::p_load("tensorflow", "keras")

# Preprocessing data for inputting into Keras
# Tensors are matrices... hence the input data has to be in a form of a matrix

x_train <- data.matrix(training[,1:44]) #matrix of features ("X variables") for training; remove the "Essential..primary..hypertension" column number 25
y_train <- training$Essential..primary..hypertension #target vector ("Y variable") for training 

x_test <- data.matrix(testing[,1:44]) #matrix of features ("X variables") for testing; remove the "Essential..primary..hypertension" column number 25
y_test <- testing$Essential..primary..hypertension #target vector ("Y variable") for testing 

x_train <- array_reshape(x_train, c(nrow(x_train), 44)) #Keras interprets data using row-major semantics (as opposed to R's default column-major semantics). Hence need to "reshape" the matrices 
x_test <- array_reshape(x_test, c(nrow(x_test), 44))

# final data preparation steps: scaling for X and converting to categorical for Y

x_train <- scale(x_train)
x_test <- scale(x_test)

y_train <- to_categorical(y_train, 2)
y_test <- to_categorical(y_test, 2)

#
# Defining the neural network model architecture: layers, units, activations. 
#

# common kinds of layers: https://keras.io/layers/about-keras-layers/

# dense -- connect to each neuron
# dropout -- connect to each neuron with some probability 
# convolution -- foundation of computer vision/perception 
# recurrent -- foundation of time-dependent modeling (text, time-series, etc.) Wekaer than LSTM
# LSTM -- long short-term memory 
# flatten/embedding/ -- utility layers: particular kinds of data preparation 

# common kinds of activations: https://keras.io/activations/
# relu -- piece-wise linear 
# sigmoid, tanh -- S-shaped 
# softmax -- normalization to probabilities using exp/sum(exp) transform [like in logistic regression]

model <- keras_model_sequential() 

model %>% 
  layer_dense(units = 256, activation = 'relu') %>% 
  layer_dropout(rate = 0.4) %>% 
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 2, activation = 'softmax')

#
# Compiling the model 
#

# common loss functions: https://keras.io/losses/
# mean_absolute_percentage_error, mean_absolute_error -- for continuous quantities
# binary_crossentropy, categorical_crossentropy, sparse_categorical_crossentropy -- for events (binary, multinomial)

# common optimizers: https://keras.io/optimizers/
# adam -- commonly used
# SGD -- "stochastic gradient descent"

# common metrics: https://keras.io/metrics/ 
# accuracy, mae, mape 

model %>% compile(
  loss = 'binary_crossentropy',
  optimizer = 'adam',
  metrics = c('accuracy')
)

# Training / "fitting" the model

history <- model %>% fit(
  x_train, y_train, # on what data to train
  epochs = 30, # how many repetitions to have
  batch_size = 256, # how many datapoints are fed to the network at a time 
  validation_split = 0.2  # percentage of training data to keep for cross-validation 
)

summary(model)

plot(history)

# model %>% evaluate(x_test, y_test) # apply the model to testing data

TF_NN_probabilities <- model %>% predict(x_test)  # predict probabilities

TF_NN_classification<-rep("1",2035)
TF_NN_classification[TF_NN_probabilities[,2]<0.1]="0" 
TF_NN_classification<-as.factor(TF_NN_classification)

confusionMatrix(TF_NN_classification,testing$Essential..primary..hypertension, positive = "1")






###################
### Predict T2D ###
###################

###
### Prepare data
###
t2d.short <- cbind(new.data,disease[,c(4,ncol(disease))])
t2d.short <- t2d.short[,c(2:(ncol(t2d.short)-1))]
inTrain <- createDataPartition(y = t2d.short$Type.2.diabetes.mellitus,
                               p = 0.8, list = FALSE)
training <- t2d.short[ inTrain,]
testing <- t2d.short[ -inTrain,]

###
### Logistic regression
###
model_logistic<-glm(Type.2.diabetes.mellitus~ ., data=training, family="binomial"(link="logit"))

model_logistic_stepwiseAIC<-stepAIC(model_logistic,direction = c("both"),trace = 1) #AIC stepwise

 summary(model_logistic_stepwiseAIC) 

par(mfrow=c(1,4))
plot(model_logistic_stepwiseAIC) #Error plots: similar nature to lm plots
par(mfrow=c(1,1))

###Finding predicitons: probabilities and classification
logistic_probabilities<-predict(model_logistic_stepwiseAIC,newdata=testing,type="response") #Predict probabilities
logistic_classification<-rep("1",2035)
logistic_classification[logistic_probabilities<0.1]="0" #Predict classification using 0.1 threshold
logistic_classification<-as.factor(logistic_classification)

###Confusion matrix  
confusionMatrix(logistic_classification,testing$Type.2.diabetes.mellitus,positive = "1") #Display confusion matrix

####ROC Curve
logistic_ROC_prediction <- prediction(logistic_probabilities, testing$Type.2.diabetes.mellitus)
logistic_ROC <- performance(logistic_ROC_prediction,"tpr","fpr") #Create ROC curve data
plot(logistic_ROC) #Plot ROC curve

####AUC (area under curve)
auc.tmp <- performance(logistic_ROC_prediction,"auc") #Create AUC data
logistic_auc_testing <- as.numeric(auc.tmp@y.values) #Calculate AUC
logistic_auc_testing #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(logistic_probabilities, testing$Type.2.diabetes.mellitus, cumulative = TRUE, n.buckets = 10) # Plot Lift chart

###
### CTREE
###

# fix outliers in data
testing$PFQ061A <- revalue(testing$PFQ061A,c("9"="0"))
testing$PFQ061T <- revalue(testing$PFQ061T,c("7"="0"))
testing$OCQ380 <- revalue(testing$OCQ380,c("77"="0"))

ctree_tree<-ctree(Type.2.diabetes.mellitus~.,data=training) #Run ctree on training data
plot(ctree_tree, gp = gpar(fontsize = 8)) #Plotting the tree (adjust fontsize if needed)

ctree_probabilities<-predict(ctree_tree,newdata=testing,type="prob") #Predict probabilities
ctree_classification<-rep("1",2035)
ctree_classification[ctree_probabilities[,2]<0.1]="0" #Predict classification using 0.1 threshold
ctree_classification<-as.factor(ctree_classification)

###Confusion matrix  
confusionMatrix(ctree_classification,testing$Type.2.diabetes.mellitus,positive = "1")

####ROC Curve
ctree_probabilities_testing <-predict(ctree_tree,newdata=testing,type = "prob") #Predict probabilities
ctree_pred_testing <- prediction(ctree_probabilities_testing[,2], testing$Type.2.diabetes.mellitus) #Calculate errors
ctree_ROC_testing <- performance(ctree_pred_testing,"tpr","fpr") #Create ROC curve data
plot(ctree_ROC_testing) #Plot ROC curve

####AUC (area under curve)
auc.tmp <- performance(ctree_pred_testing,"auc") #Create AUC data
ctree_auc_testing <- as.numeric(auc.tmp@y.values) #Calculate AUC
ctree_auc_testing #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(ctree_probabilities[,2],  testing$Type.2.diabetes.mellitus, cumulative = TRUE, n.buckets = 10) # Plot Lift chart

#
# Random Forest
#

model_forest <- randomForest(Type.2.diabetes.mellitus~ ., data=training, 
                             importance=TRUE,
                             cutoff = c(0.9, 0.1),type="classification", ntree = 500, mtry = 20, nodesize = 20, maxnodes = 30)
# No good answers on how to determine hyperparameters of ntree, mtry, etc. 

print(model_forest)   
plot(model_forest)
importance(model_forest)
varImpPlot(model_forest)

###Finding predicitons: probabilities and classification
# Fixes issues
testing <- rbind(training[1, ] , testing)
testing <- testing[-1,]

forest_probabilities<-predict(model_forest,newdata=testing,type="prob") #Predict probabilities -- an array with 2 columns: for not retained (class 0) and for retained (class 1)
forest_classification<-rep("1",2035)
forest_classification[forest_probabilities[,2]<0.1]="0" #Predict classification using 0.5 threshold. 
forest_classification<-as.factor(forest_classification)

confusionMatrix(forest_classification,testing$Type.2.diabetes.mellitus, positive="1") #Display confusion matrix.

#There is also a "shortcut" forest_prediction<-predict(model_forest,newdata=testing, type="response") 
#But it by default uses threshold of 50%: 

####ROC Curve
forest_ROC_prediction <- prediction(forest_probabilities[,2], testing$Type.2.diabetes.mellitus) #Calculate errors
forest_ROC <- performance(forest_ROC_prediction,"tpr","fpr") #Create ROC curve data
plot(forest_ROC) #Plot ROC curve

####AUC (area under curve)
AUC.tmp <- performance(forest_ROC_prediction,"auc") #Create AUC data
forest_AUC <- as.numeric(AUC.tmp@y.values) #Calculate AUC
forest_AUC #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(forest_probabilities[,2],  testing$Type.2.diabetes.mellitus, cumulative = TRUE, n.buckets = 10) # Plot Lift chart

### An alternative way is to plot a Lift curve not by buckets, but on all data points
Lift_forest <- performance(forest_ROC_prediction,"lift","rpp")
plot(Lift_forest)


###
### With Support Vector Machines (SVM)
###

pacman::p_load("caret","ROCR","lift","glmnet","MASS","e1071") 

model_svm <- svm(Type.2.diabetes.mellitus ~., data=training, probability=TRUE)
summary(model_svm)

svm_probabilities<-attr(predict(model_svm,newdata=testing, probability=TRUE), "prob")

svm_classification<-rep("1",2035)
svm_classification[svm_probabilities[,2]<0.2]="0" 
svm_classification<-as.factor(svm_classification)
confusionMatrix(svm_classification,testing$Type.2.diabetes.mellitus,positive = "1")



###
### With Deep Learning (using TensorFlow controlled via Keras)
###

# The initial installation is a bit tricky, use the code below for the first time; after that, pacman

#install.packages("tensorflow")
#library(tensorflow)
#install_tensorflow()
#tf$constant("Hellow Tensorflow") ## a simple way to check if it installed correctly

#install.packages("keras")
#library(keras)
#install_keras()

pacman::p_load("tensorflow", "keras")

# Preprocessing data for inputting into Keras
# Tensors are matrices... hence the input data has to be in a form of a matrix

x_train <- data.matrix(training[,1:44]) #matrix of features ("X variables") for training; remove the "Type.2.diabetes.mellitus" column number 25
y_train <- training$Type.2.diabetes.mellitus #target vector ("Y variable") for training 

x_test <- data.matrix(testing[,1:44]) #matrix of features ("X variables") for testing; remove the "Type.2.diabetes.mellitus" column number 25
y_test <- testing$Type.2.diabetes.mellitus #target vector ("Y variable") for testing 

x_train <- array_reshape(x_train, c(nrow(x_train), 44)) #Keras interprets data using row-major semantics (as opposed to R's default column-major semantics). Hence need to "reshape" the matrices 
x_test <- array_reshape(x_test, c(nrow(x_test), 44))

# final data preparation steps: scaling for X and converting to categorical for Y

x_train <- scale(x_train)
x_test <- scale(x_test)

y_train <- to_categorical(y_train, 2)
y_test <- to_categorical(y_test, 2)

#
# Defining the neural network model architecture: layers, units, activations. 
#

# common kinds of layers: https://keras.io/layers/about-keras-layers/

# dense -- connect to each neuron
# dropout -- connect to each neuron with some probability 
# convolution -- foundation of computer vision/perception 
# recurrent -- foundation of time-dependent modeling (text, time-series, etc.) Wekaer than LSTM
# LSTM -- long short-term memory 
# flatten/embedding/ -- utility layers: particular kinds of data preparation 

# common kinds of activations: https://keras.io/activations/
# relu -- piece-wise linear 
# sigmoid, tanh -- S-shaped 
# softmax -- normalization to probabilities using exp/sum(exp) transform [like in logistic regression]

model <- keras_model_sequential() 

model %>% 
  layer_dense(units = 256, activation = 'relu') %>% 
  layer_dropout(rate = 0.4) %>% 
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 2, activation = 'softmax')

#
# Compiling the model 
#

# common loss functions: https://keras.io/losses/
# mean_absolute_percentage_error, mean_absolute_error -- for continuous quantities
# binary_crossentropy, categorical_crossentropy, sparse_categorical_crossentropy -- for events (binary, multinomial)

# common optimizers: https://keras.io/optimizers/
# adam -- commonly used
# SGD -- "stochastic gradient descent"

# common metrics: https://keras.io/metrics/ 
# accuracy, mae, mape 

model %>% compile(
  loss = 'binary_crossentropy',
  optimizer = 'adam',
  metrics = c('accuracy')
)

# Training / "fitting" the model

history <- model %>% fit(
  x_train, y_train, # on what data to train
  epochs = 30, # how many repetitions to have
  batch_size = 256, # how many datapoints are fed to the network at a time 
  validation_split = 0.2  # percentage of training data to keep for cross-validation 
)

summary(model)

plot(history)

# model %>% evaluate(x_test, y_test) # apply the model to testing data

TF_NN_probabilities <- model %>% predict(x_test)  # predict probabilities

TF_NN_classification<-rep("1",2035)
TF_NN_classification[TF_NN_probabilities[,2]<0.1]="0" 
TF_NN_classification<-as.factor(TF_NN_classification)

confusionMatrix(TF_NN_classification,testing$Type.2.diabetes.mellitus, positive = "1")





####################################
### Predict Hypercholesterolemia ###
####################################

###
### Prepare data
###
hchol.short <- cbind(new.data,disease[,c(3,ncol(disease))])
hchol.short <- hchol.short[,c(2:(ncol(hchol.short)-1))]
inTrain <- createDataPartition(y = hchol.short$Pure.hypercholesterolemia,
                               p = 0.8, list = FALSE)
training <- hchol.short[ inTrain,]
testing <- hchol.short[ -inTrain,]

###
### Logistic regression
###
model_logistic<-glm(Pure.hypercholesterolemia~ ., data=training, family="binomial"(link="logit"))

model_logistic_stepwiseAIC<-stepAIC(model_logistic,direction = c("both"),trace = 1) #AIC stepwise

summary(model_logistic_stepwiseAIC) 

par(mfrow=c(1,4))
plot(model_logistic_stepwiseAIC) #Error plots: similar nature to lm plots
par(mfrow=c(1,1))

# fix outliers in data
testing$HUQ010 <- revalue(testing$HUQ010,c("7"="9"))

###Finding predicitons: probabilities and classification
logistic_probabilities<-predict(model_logistic_stepwiseAIC,newdata=testing,type="response") #Predict probabilities
logistic_classification<-rep("1",2034)
logistic_classification[logistic_probabilities<0.1]="0" #Predict classification using 0.1 threshold
logistic_classification<-as.factor(logistic_classification)

###Confusion matrix  
confusionMatrix(logistic_classification,testing$Pure.hypercholesterolemia,positive = "1") #Display confusion matrix

####ROC Curve
logistic_ROC_prediction <- prediction(logistic_probabilities, testing$Pure.hypercholesterolemia)
logistic_ROC <- performance(logistic_ROC_prediction,"tpr","fpr") #Create ROC curve data
plot(logistic_ROC) #Plot ROC curve

####AUC (area under curve)
auc.tmp <- performance(logistic_ROC_prediction,"auc") #Create AUC data
logistic_auc_testing <- as.numeric(auc.tmp@y.values) #Calculate AUC
logistic_auc_testing #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(logistic_probabilities, testing$Pure.hypercholesterolemia, cumulative = TRUE, n.buckets = 10) # Plot Lift chart

###
### CTREE
###

ctree_tree<-ctree(Pure.hypercholesterolemia~.,data=training) #Run ctree on training data
plot(ctree_tree, gp = gpar(fontsize = 8)) #Plotting the tree (adjust fontsize if needed)

ctree_probabilities<-predict(ctree_tree,newdata=testing,type="prob") #Predict probabilities
ctree_classification<-rep("1",2034)
ctree_classification[ctree_probabilities[,2]<0.1]="0" #Predict classification using 0.1 threshold
ctree_classification<-as.factor(ctree_classification)

###Confusion matrix  
confusionMatrix(ctree_classification,testing$Pure.hypercholesterolemia,positive = "1")

####ROC Curve
ctree_probabilities_testing <-predict(ctree_tree,newdata=testing,type = "prob") #Predict probabilities
ctree_pred_testing <- prediction(ctree_probabilities_testing[,2], testing$Pure.hypercholesterolemia) #Calculate errors
ctree_ROC_testing <- performance(ctree_pred_testing,"tpr","fpr") #Create ROC curve data
plot(ctree_ROC_testing) #Plot ROC curve

####AUC (area under curve)
auc.tmp <- performance(ctree_pred_testing,"auc") #Create AUC data
ctree_auc_testing <- as.numeric(auc.tmp@y.values) #Calculate AUC
ctree_auc_testing #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(ctree_probabilities[,2],  testing$Pure.hypercholesterolemia, cumulative = TRUE, n.buckets = 10) # Plot Lift chart

#
# Random Forest
#

model_forest <- randomForest(Pure.hypercholesterolemia~ ., data=training, 
                             importance=TRUE,
                             cutoff = c(0.9, 0.1),type="classification", ntree = 500, mtry = 20, nodesize = 20, maxnodes = 30)
# No good answers on how to determine hyperparameters of ntree, mtry, etc. 

print(model_forest)   
plot(model_forest)
importance(model_forest)
varImpPlot(model_forest)

###Finding predicitons: probabilities and classification
forest_probabilities<-predict(model_forest,newdata=testing,type="prob") #Predict probabilities -- an array with 2 columns: for not retained (class 0) and for retained (class 1)
forest_classification<-rep("1",2034)
forest_classification[forest_probabilities[,2]<0.1]="0" #Predict classification using 0.5 threshold. 
forest_classification<-as.factor(forest_classification)

confusionMatrix(forest_classification,testing$Pure.hypercholesterolemia, positive="1") #Display confusion matrix.

#There is also a "shortcut" forest_prediction<-predict(model_forest,newdata=testing, type="response") 
#But it by default uses threshold of 50%: 

####ROC Curve
forest_ROC_prediction <- prediction(forest_probabilities[,2], testing$Pure.hypercholesterolemia) #Calculate errors
forest_ROC <- performance(forest_ROC_prediction,"tpr","fpr") #Create ROC curve data
plot(forest_ROC) #Plot ROC curve

####AUC (area under curve)
AUC.tmp <- performance(forest_ROC_prediction,"auc") #Create AUC data
forest_AUC <- as.numeric(AUC.tmp@y.values) #Calculate AUC
forest_AUC #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(forest_probabilities[,2],  testing$Pure.hypercholesterolemia, cumulative = TRUE, n.buckets = 10) # Plot Lift chart

### An alternative way is to plot a Lift curve not by buckets, but on all data points
Lift_forest <- performance(forest_ROC_prediction,"lift","rpp")
plot(Lift_forest)


###
### With Support Vector Machines (SVM)
###

pacman::p_load("caret","ROCR","lift","glmnet","MASS","e1071") 

model_svm <- svm(Pure.hypercholesterolemia ~., data=training, probability=TRUE)
summary(model_svm)

svm_probabilities<-attr(predict(model_svm,newdata=testing, probability=TRUE), "prob")

svm_classification<-rep("1",2034)
svm_classification[svm_probabilities[,2]<0.1]="0" 
svm_classification<-as.factor(svm_classification)
confusionMatrix(svm_classification,testing$Pure.hypercholesterolemia,positive = "1")



###
### With Deep Learning (using TensorFlow controlled via Keras)
###

# The initial installation is a bit tricky, use the code below for the first time; after that, pacman

#install.packages("tensorflow")
#library(tensorflow)
#install_tensorflow()
#tf$constant("Hellow Tensorflow") ## a simple way to check if it installed correctly

#install.packages("keras")
#library(keras)
#install_keras()

pacman::p_load("tensorflow", "keras")

# Preprocessing data for inputting into Keras
# Tensors are matrices... hence the input data has to be in a form of a matrix

x_train <- data.matrix(training[,1:44]) #matrix of features ("X variables") for training; remove the "Pure.hypercholesterolemia" column number 25
y_train <- training$Pure.hypercholesterolemia #target vector ("Y variable") for training 

x_test <- data.matrix(testing[,1:44]) #matrix of features ("X variables") for testing; remove the "Pure.hypercholesterolemia" column number 25
y_test <- testing$Pure.hypercholesterolemia #target vector ("Y variable") for testing 

x_train <- array_reshape(x_train, c(nrow(x_train), 44)) #Keras interprets data using row-major semantics (as opposed to R's default column-major semantics). Hence need to "reshape" the matrices 
x_test <- array_reshape(x_test, c(nrow(x_test), 44))

# final data preparation steps: scaling for X and converting to categorical for Y

x_train <- scale(x_train)
x_test <- scale(x_test)

y_train <- to_categorical(y_train, 2)
y_test <- to_categorical(y_test, 2)

#
# Defining the neural network model architecture: layers, units, activations. 
#

# common kinds of layers: https://keras.io/layers/about-keras-layers/

# dense -- connect to each neuron
# dropout -- connect to each neuron with some probability 
# convolution -- foundation of computer vision/perception 
# recurrent -- foundation of time-dependent modeling (text, time-series, etc.) Wekaer than LSTM
# LSTM -- long short-term memory 
# flatten/embedding/ -- utility layers: particular kinds of data preparation 

# common kinds of activations: https://keras.io/activations/
# relu -- piece-wise linear 
# sigmoid, tanh -- S-shaped 
# softmax -- normalization to probabilities using exp/sum(exp) transform [like in logistic regression]

model <- keras_model_sequential() 

model %>% 
  layer_dense(units = 256, activation = 'relu') %>% 
  layer_dropout(rate = 0.4) %>% 
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 2, activation = 'softmax')

#
# Compiling the model 
#

# common loss functions: https://keras.io/losses/
# mean_absolute_percentage_error, mean_absolute_error -- for continuous quantities
# binary_crossentropy, categorical_crossentropy, sparse_categorical_crossentropy -- for events (binary, multinomial)

# common optimizers: https://keras.io/optimizers/
# adam -- commonly used
# SGD -- "stochastic gradient descent"

# common metrics: https://keras.io/metrics/ 
# accuracy, mae, mape 

model %>% compile(
  loss = 'binary_crossentropy',
  optimizer = 'adam',
  metrics = c('accuracy')
)

# Training / "fitting" the model

history <- model %>% fit(
  x_train, y_train, # on what data to train
  epochs = 30, # how many repetitions to have
  batch_size = 256, # how many datapoints are fed to the network at a time 
  validation_split = 0.2  # percentage of training data to keep for cross-validation 
)

summary(model)

plot(history)

# model %>% evaluate(x_test, y_test) # apply the model to testing data

TF_NN_probabilities <- model %>% predict(x_test)  # predict probabilities

TF_NN_classification<-rep("1",2034)
TF_NN_classification[TF_NN_probabilities[,2]<0.1]="0" 
TF_NN_classification<-as.factor(TF_NN_classification)

confusionMatrix(TF_NN_classification,testing$Pure.hypercholesterolemia, positive = "1")

