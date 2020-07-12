
if("pacman" %in% rownames(installed.packages()) == FALSE) {install.packages("pacman")} # Check if you have universal installer package, install if not

pacman::p_load("rjson","arulesViz") #Check, and if needed install the necessary packages


#load diseases data
#load relevent files
disease <- read.csv(file.choose(), header=TRUE)

#Make logical
disease$SEQN<-as.factor(disease$SEQN)
disease$HT<-as.logical(disease$HT)
disease$H.Choles<-as.logical(disease$H.Choles)
disease$T2D<-as.logical(disease$T2D)
disease$Asthma<-as.logical(disease$Asthma)
disease$Depress.<-as.logical(disease$Depress.)
disease$GI.reflux<-as.logical(disease$GI.reflux)
disease$Anxiety<-as.logical(disease$Anxiety)
disease$Hypothyroidism<-as.logical(disease$Hypothyroidism)
disease$Dorsalgia<-as.logical(disease$Dorsalgia)
disease$Insomnia<-as.logical(disease$Insomnia)
disease$A.Rhinitis<-as.logical(disease$A.Rhinitis)
disease$ADHD<-as.logical(disease$ADHD)
disease$Dyspepsia<-as.logical(disease$Dyspepsia)
disease$Allergy<-as.logical(disease$Allergy)
disease$Neuralgia<-as.logical(disease$Neuralgia)
disease$Edema<-as.logical(disease$Edema)
disease$MCI<-as.logical(disease$MCI)
disease$Heart.failure<-as.logical(disease$Heart.failure)
disease$P.bloodclots<-as.logical(disease$P.bloodclots)
disease$Sleep.disorder<-as.logical(disease$Sleep.disorder)
disease$Contraceptives<-as.logical(disease$Contraceptives)
disease$Enlarged.prostate<-as.logical(disease$Enlarged.prostate)
disease$Hypokalemia<-as.logical(disease$Hypokalemia)
disease$Glaucoma<-as.logical(disease$Glaucoma)
disease$C.arrhythmia<-as.logical(disease$C.arrhythmia)
disease$Migraine<-as.logical(disease$Migraine)
disease$C.pul<-as.logical(disease$C.pul)
disease$Epilepsy<-as.logical(disease$Epilepsy)
disease$Myalgia<-as.logical(disease$Myalgia)
disease$Bipolar<-as.logical(disease$Bipolar)
disease$Spasm<-as.logical(disease$Spasm)
disease$C.gout<-as.logical(disease$C.gout)
disease$Otitis.media<-as.logical(disease$Otitis.media)
disease$Osteoarthritis<-as.logical(disease$Osteoarthritis)
disease$Unspecified<-as.logical(disease$Unspecified)
disease$RA<-as.logical(disease$RA)
disease$Osteoporosis<-as.logical(disease$Osteoporosis)
disease$Un.a.fibrillation<-as.logical(disease$Un.a.fibrillation)
disease$Elevated.BG<-as.logical(disease$Elevated.BG)
disease$Heart.disease<-as.logical(disease$Heart.disease)
disease$Knee.pain<-as.logical(disease$Knee.pain)
disease$Others<-as.logical(disease$Others)


#Take out ID
disease.ex.ID <- disease[,c(2:43)]

## coerce
trans <- as(disease.ex.ID, "transactions") 
inspect(trans[1:2,])


rules <- apriori(trans, parameter = list(supp = 0.01, conf = 0.3, target = "rules")) # set support and confidence level

inspect(head(rules,5, by = "lift")) #lets see which rules were identified

quality(rules) #table with quality measures for the identified rules

#install.packages("arulesViz")
#library(arulesViz)

#plot(rules[1:40,], method = "graph") #plot top 20 rules(ordered by lift)
plot(rules[1:20,], method = "graph")
# Direction of arrow tell us which one is more frequent

#append the quality table by the conviction measure
quality(rules) <- cbind(quality(rules),
                        conviction = interestMeasure(rules, measure = "conviction", transactions = disease.ex.ID))

inspect(head(rules,100, by = "conviction")) 

plot(rules[1:20,], method = "graph") #re plot top 20 rules  (now ordered by conviction)




