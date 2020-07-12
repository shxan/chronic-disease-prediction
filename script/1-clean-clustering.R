#load relevent files
disease <- read.csv(file.choose(), header=TRUE)

#Make factor
disease$SEQN<-as.factor(disease$SEQN)
disease$Essential..primary..hypertension<-as.factor(disease$Essential..primary..hypertension)
disease$Pure.hypercholesterolemia<-as.factor(disease$Pure.hypercholesterolemia)
disease$Type.2.diabetes.mellitus<-as.factor(disease$Type.2.diabetes.mellitus)
disease$Asthma<-as.factor(disease$Asthma)
disease$Major.depressive.disorder..single.episode..unspecified<-as.factor(disease$Major.depressive.disorder..single.episode..unspecified)
disease$Gastro.esophageal.reflux.disease<-as.factor(disease$Gastro.esophageal.reflux.disease)
disease$Anxiety.disorder..unspecified<-as.factor(disease$Anxiety.disorder..unspecified)
disease$Hypothyroidism..unspecified<-as.factor(disease$Hypothyroidism..unspecified)
disease$Dorsalgia..unspecified<-as.factor(disease$Dorsalgia..unspecified)
disease$Insomnia<-as.factor(disease$Insomnia)
disease$Allergic.rhinitis..unspecified<-as.factor(disease$Allergic.rhinitis..unspecified)
disease$Attention.deficit.hyperactivity.disorders<-as.factor(disease$Attention.deficit.hyperactivity.disorders)
disease$Functional.dyspepsia<-as.factor(disease$Functional.dyspepsia)
disease$Allergy..unspecified<-as.factor(disease$Allergy..unspecified)
disease$Neuralgia.and.neuritis..unspecified<-as.factor(disease$Neuralgia.and.neuritis..unspecified)
disease$Edema..unspecified<-as.factor(disease$Edema..unspecified)
disease$Prevent.heart.attack.myocardial.infarction<-as.factor(disease$Prevent.heart.attack.myocardial.infarction)
disease$Heart.failure..unspecified<-as.factor(disease$Heart.failure..unspecified)
disease$Prevent.blood.clots<-as.factor(disease$Prevent.blood.clots)
disease$Sleep.disorder..unspecified<-as.factor(disease$Sleep.disorder..unspecified)
disease$Long.term..current..use.of.hormonal.contraceptives<-as.factor(disease$Long.term..current..use.of.hormonal.contraceptives)
disease$Enlarged.prostate<-as.factor(disease$Enlarged.prostate)
disease$Hypokalemia<-as.factor(disease$Hypokalemia)
disease$Glaucoma<-as.factor(disease$Glaucoma)
disease$Cardiac.arrhythmia..unspecified<-as.factor(disease$Cardiac.arrhythmia..unspecified)
disease$Migraine<-as.factor(disease$Migraine)
disease$Chronic.obstructive.pulmonary.disease..unspecified<-as.factor(disease$Chronic.obstructive.pulmonary.disease..unspecified)
disease$Epilepsy.and.recurrent.seizures<-as.factor(disease$Epilepsy.and.recurrent.seizures)
disease$Myalgia<-as.factor(disease$Myalgia)
disease$Bipolar.disorder..unspecified<-as.factor(disease$Bipolar.disorder..unspecified)
disease$Muscle.spasm<-as.factor(disease$Muscle.spasm)
disease$Chronic.gout<-as.factor(disease$Chronic.gout)
disease$Otitis.media..unspecified<-as.factor(disease$Otitis.media..unspecified)
disease$Osteoarthritis..unspecified.site<-as.factor(disease$Osteoarthritis..unspecified.site)
disease$Unspecified.injury<-as.factor(disease$Unspecified.injury)
disease$Rheumatoid.arthritis..unspecified<-as.factor(disease$Rheumatoid.arthritis..unspecified)
disease$Osteoporosis.without.current.pathological.fracture<-as.factor(disease$Osteoporosis.without.current.pathological.fracture)
disease$Unspecified.atrial.fibrillation<-as.factor(disease$Unspecified.atrial.fibrillation)
disease$Elevated.blood.glucose.level<-as.factor(disease$Elevated.blood.glucose.level)
disease$Heart.disease..unspecified<-as.factor(disease$Heart.disease..unspecified)
disease$Pain.in.knee<-as.factor(disease$Pain.in.knee)
disease$Other.diseases<-as.factor(disease$Other.diseases)

#Take out ID
disease.ex.ID <- disease[,c(2:43)]

###
### Normal clustering approach
###

#create elbow plot for clustering
wss <- 0

for (i in 1:20) {
  km.out <- kmeans(disease.ex.ID, centers=i, nstart=20, iter.max = 100)
  # Save total within sum of squares to wss variable
  wss[i] <- km.out$tot.withinss
}

# Plot total within sum of squares vs. number of clusters
par(mfrow = c(1, 1))
plot(1:20, wss, type = "b", 
     xlab = "Number of Clusters", 
     ylab = "Within groups sum of squares")

#Plot snake charts with 4 clusters
km.out<-kmeans(disease.ex.ID,centers=4,nstart=20,iter.max = 100)

ul<-max(km.out$centers) # upper and lower limits for plotting
ll<-min(km.out$centers)

plot(km.out$centers[1,], type = "o", col="red", ylim=(c(ll,ul)), xlab=NA, xaxt="n", ylab="centroid means")
axis(1,at=1:ncol(disease.ex.ID), las=2, labels=c(colnames(disease.ex.ID)))
lines(km.out$centers[2,], type = "o", col="green")
lines(km.out$centers[3,], type = "o", col="black")
lines(km.out$centers[4,], type = "o", col="blue")
legend("bottomright", legend=c("cluster 1", "cluster 2","cluster 3","Cluster 4"), col=c("red", "green", "black", "blue"), lty=1)

#print out data
table(km.out$cluster)
print(km.out) 

#write CSV
write.csv(km.out$centers, file="k-means_centers.csv")
write.csv(km.out$cluster, file="k-means_clusters.csv")

###
### PCA
###

#create new numeric dataset
disease.ex.ID.numeric <- read.csv(file.choose(), header=TRUE)
disease.ex.ID.numeric <- disease.ex.ID.numeric[,c(2:43)]


pr.out<-prcomp(disease.ex.ID.numeric,scale=FALSE, center=TRUE) # Perform "base-case" PCA - scaled not needed because it is factor (1,0) data
summary(pr.out) # Inspect model output
pr.out$rotation # Inspect PCA factor loadings
# to be more visually appealing, remove loadings that are small (here, less than 0.3)
pr.out.factor.loadings<-pr.out$rotation
pr.out.factor.loadings[abs(pr.out.factor.loadings)<0.2]<-NA
pr.out.factor.loadings

# Plot variance explained for each principal component

pr.var <- pr.out$sdev^2 #calculate variance explained
pve <- pr.var / sum(pr.var) #calculate % variance explained 
par(mfrow = c(1, 2))
plot(pve, xlab = "Principal Component",
     ylab = "Proportion of Variance Explained",
     ylim = c(0, 1), type = "b")

# Plot cumulative proportion of variance explained
plot(cumsum(pve), xlab = "Principal Component",
     ylab = "Cumulative Proportion of Variance Explained",
     ylim = c(0, 1), type = "b")

# Plot variance explained, "eigenvalues"
par(mfrow = c(1, 1))
plot(pr.var, xlab = "Principal Component",
     ylab = "Eigenvalue (variance explained)", type = "b")
abline(1,0)

# Biplot of the first two components
biplot(pr.out) 

#export CSV
write.csv(pr.out$rotation, "PCA full output.csv")
write.csv(pr.out.factor.loadings, "PCA output.csv")
write.csv(pr.var,"PCA PR Var.csv")
write.csv(pve, "PCA PVE.csv")
