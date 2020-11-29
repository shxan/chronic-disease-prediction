# Chronic disease prediction using self-reported questionnaires
Creating a simple self-reported health survey of 39 questions from the original CDC NHANES questionnaire of 1829 columns by 1) applying unsupervised machine learning to group and identify comorbid diseases, and 2) applying supervised machine learning to predict hypertension, type 2 diabetes and hypercholesterolemia from the questions. 

## Executive Summary
This 2-person project creates a condensed survey that has a high accuracy in predicting 3 common non-communicable diseases (hypertension, type 2 diabetes, hypercholesterolemia) that can be used by NGOs or governments to quickly screen a population for potential incidences and before sending these identified high risk individuals for definitive diagnostic tests. 

It aims to increase testing and hence diagnosis rates for these high prevalence diseases, without incuring much higher costs for healthcare providers and patients through unnecessary physical and lab examination. 

The input data used is the National Health and Nutrition Examination Survey (NHANES) 2013-2014 data set on Kaggle.

Data cleaning and preparation was first done to include only relevant self-reported data, combine variables, remove rare categories and treat missing data. 

Clustering and association techniques (K-means, association, PCA) were investigated to find the best method to identify co-morbidities among the 42 non-communicable diseases in the dataset. Of the 4 clusters from k-means, 2 with highest support and lift from association analysis were selected for further analysis in this project. These were the pure hypertension cluster and the hypercholesterolemia + T2D clusters (total of 3 main diseases). 

Demographics, diet-related and remaining self-reportable questionnaire were used as input in the next step to predict these diseases. Random Forest, RPART, Logit Stepwise AIC, CTree, SVM and TensorFlow model outputs were compared to identify the best model for predicting each of these 3 diseases. 

Final models were chosen based on a balance of accuracy and sensitivity. 

For Hypertension prediction, TensorFlow model gave 80.9% accuracy and 91.2% sensitivity with the shortened questionnaire. 
For Type 2 Diabetes, Logit Step-wise gave 83.7% accuracy and 81% sensitivity with the shortened questionnaire.
For Hypercholesterolemia, Logit Step-wise gave 81.9% accuracy and 95.5% sensitivity with the shortened questionnaire.

This project showed proof-of-concept that socio-demographics and behavioral data, which can be gathered through self-reported questionnaire, are good predictors of top non-communicable diseases. The value at stake is a combined total of >100 USD billion through earlier screening, self-identification and diagnosis to reduce diseas burden over lifetime of patient. 

## Data preparation and cleaning

Data cleaning and preparation was first done to include only relevant self-reported data, combine variables, remove rare categories and treat missing data. 

## Analysis Step 1 - Identifying co-morbidities

K-means, PCA, association analyses were done to identify co-morbidity.

### K-means

![k-means elbow](/graph/kmeans_elbow.png)

4 clusters are optimal for this analysis

![k-means cluster 1](/graph/kmeans_cluster_1.png)
![k-means cluster 2](/graph/kmeans_cluster_2.png)
![k-means cluster 3](/graph/kmeans_cluster_3.png)
![k-means cluster 4](/graph/kmeans_cluster_4.png)

### PCA

![PCA chart](/graph/PCA_Chart.png)

Not used due to too many resulting clusters and hard to interpret results

### Association 

Top 20 rules from association analysis

![association rules](/graph/AssocRules_Links.png)

Visualised by Conviction
![association rules by conviction](/graph/AssocRules_byConviction.png)

Visualised by Lift
![association rules by lift](/graph/AssocRules_byLift.png)

T2D (type 2 diabetes), H.Choles (Hypercholesterolemia) and HT (hypertension) associations have highest support, confidence and lift and is prioritized in this project to maximize prediction accuracy of the pilot due to large number of patient records available. Insufficient data for the rest of the diseases.

## Analysis Step 2 - Identifying key indicators / predictors

### Hypercholesterolemia - Random Forest

![hypercholesterolemia random forest importance](/graph/HChol_Short_RFImpt.png)
![hypercholesterolemia random forest lift](/graph/HChol_Short_RFLift.png)
![hypercholesterolemia random forest plot](/graph/HChol_Short_RFPlot.png)
![hypercholesterolemia random forest confusion matrix](/graph/HChol_Short_RFConf.png)
![hypercholesterolemia random forest ROC](/graph/HChol_Short_RFROC.png)

### Hypercholesterolemia - RPART

![hypercholesterolemia RPART tree](/graph/HChol_Short_RPartTree.png)
![hypercholesterolemia RPART confusion matrix](/graph/HChol_Short_RPartConf.png)
![hypercholesterolemia RPART ROC](/graph/HChol_Short_RPartROC.png)

### Hypercholesterolemia - CTree

![hypercholesterolemia CTree plot](/graph/HChol_Short_CtreePlot.png)
![hypercholesterolemia CTree lift](/graph/HChol_Short_CtreeLift.png)
![hypercholesterolemia CTree confusion matrix](/graph/HChol_Short_CTreeConf.png)
![hypercholesterolemia CTree ROC](/graph/HChol_Short_CTreeROC.png)

### Hypercholesterolemia - Logit Stepwise AIC

![hypercholesterolemia Logit plot](/graph/HChol_Short_LogitPlot.png)
![hypercholesterolemia Logit lift](/graph/HChol_Short_LogitLift.png)
![hypercholesterolemia Logit confusion matrix](/graph/HChol_Short_LogitConf.png)
![hypercholesterolemia Logit ROC](/graph/HChol_Short_LogitROC.png)

### Hypercholesterolemia - SVM

![hypercholesterolemia SVM confusion matrix](/graph/HChol_Short_SVMConf.png)

### Hypercholesterolemia - TensorFlow

![hypercholesterolemia TensorFlow plot](/graph/HChol_Short_TFPlot.png)
![hypercholesterolemia TensorFlow confusion matrix](/graph/HChol_Short_TFConf.png)