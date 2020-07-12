pacman::p_load("caret","partykit","ROCR","lift","rpart","e1071", "ROCR", "MASS", "randomForest")

#Load data
demographic<-read.csv(file.choose(), na.strings=c(""," ","NA"), header=TRUE)
diet<-read.csv(file.choose(), na.strings=c(""," ","NA"), header=TRUE)
questionnaires<-read.csv(file.choose(), na.strings=c(""," ","NA"), header=TRUE)
disease<-read.csv(file.choose(), na.strings=c(""," ","NA"), header=TRUE)

#set as.factor
demographic$SEQN<-as.factor(demographic$SEQN)
demographic$RIDSTATR<-as.factor(demographic$RIDSTATR)
demographic$RIAGENDR<-as.factor(demographic$RIAGENDR)
demographic$RIDRETH3<-as.factor(demographic$RIDRETH3)
demographic$RIDEXMON<-as.factor(demographic$RIDEXMON)
demographic$DMQMILIZ<-as.factor(demographic$DMQMILIZ)
demographic$DMDBORN4<-as.factor(demographic$DMDBORN4)
demographic$DMDCITZN<-as.factor(demographic$DMDCITZN)
demographic$DMDEDUC<-as.factor(demographic$DMDEDUC)
demographic$DMDMARTL<-as.factor(demographic$DMDMARTL)
demographic$RIDEXPRG<-as.factor(demographic$RIDEXPRG)
demographic$SIALANG<-as.factor(demographic$SIALANG)
demographic$SIAINTRP<-as.factor(demographic$SIAINTRP)
demographic$FIALANG<-as.factor(demographic$FIALANG)
demographic$FIAINTRP<-as.factor(demographic$FIAINTRP)
demographic$MIALANG<-as.factor(demographic$MIALANG)
demographic$MIAINTRP<-as.factor(demographic$MIAINTRP)
demographic$AIALANGA<-as.factor(demographic$AIALANGA)
demographic$DMDHHSIZ<-as.factor(demographic$DMDHHSIZ)
demographic$DMDFMSIZ<-as.factor(demographic$DMDFMSIZ)
demographic$DMDHHSZA<-as.factor(demographic$DMDHHSZA)
demographic$DMDHHSZB<-as.factor(demographic$DMDHHSZB)
demographic$DMDHHSZE<-as.factor(demographic$DMDHHSZE)

questionnaires$SEQN<-as.factor(questionnaires$SEQN)
questionnaires$ALQ101<-as.factor(questionnaires$ALQ101)
questionnaires$ALQ110<-as.factor(questionnaires$ALQ110)
questionnaires$ALQ151<-as.factor(questionnaires$ALQ151)
questionnaires$HSD010<-as.factor(questionnaires$HSD010)
questionnaires$HSQ500<-as.factor(questionnaires$HSQ500)
questionnaires$HSQ510<-as.factor(questionnaires$HSQ510)
questionnaires$HSQ520<-as.factor(questionnaires$HSQ520)
questionnaires$HSQ571<-as.factor(questionnaires$HSQ571)
questionnaires$HSQ590<-as.factor(questionnaires$HSQ590)
questionnaires$CSQ010<-as.factor(questionnaires$CSQ010)
questionnaires$CSQ020<-as.factor(questionnaires$CSQ020)
questionnaires$CSQ030<-as.factor(questionnaires$CSQ030)
questionnaires$CSQ040<-as.factor(questionnaires$CSQ040)
questionnaires$CSQ060<-as.factor(questionnaires$CSQ060)
questionnaires$CSQ070<-as.factor(questionnaires$CSQ070)
questionnaires$CSQ080<-as.factor(questionnaires$CSQ080)
questionnaires$CSQ090A<-as.factor(questionnaires$CSQ090A)
questionnaires$CSQ090B<-as.factor(questionnaires$CSQ090B)
questionnaires$CSQ090C<-as.factor(questionnaires$CSQ090C)
questionnaires$CSQ090D<-as.factor(questionnaires$CSQ090D)
questionnaires$CSQ100<-as.factor(questionnaires$CSQ100)
questionnaires$CSQ110<-as.factor(questionnaires$CSQ110)
questionnaires$CSQ120A<-as.factor(questionnaires$CSQ120A)
questionnaires$CSQ120B<-as.factor(questionnaires$CSQ120B)
questionnaires$CSQ120C<-as.factor(questionnaires$CSQ120C)
questionnaires$CSQ120D<-as.factor(questionnaires$CSQ120D)
questionnaires$CSQ120E<-as.factor(questionnaires$CSQ120E)
questionnaires$CSQ120F<-as.factor(questionnaires$CSQ120F)
questionnaires$CSQ120G<-as.factor(questionnaires$CSQ120G)
questionnaires$CSQ120H<-as.factor(questionnaires$CSQ120H)
questionnaires$CSQ140<-as.factor(questionnaires$CSQ140)
questionnaires$CSQ200<-as.factor(questionnaires$CSQ200)
questionnaires$CSQ202<-as.factor(questionnaires$CSQ202)
questionnaires$CSQ204<-as.factor(questionnaires$CSQ204)
questionnaires$CSQ210<-as.factor(questionnaires$CSQ210)
questionnaires$CSQ220<-as.factor(questionnaires$CSQ220)
questionnaires$CSQ240<-as.factor(questionnaires$CSQ240)
questionnaires$CSQ250<-as.factor(questionnaires$CSQ250)
questionnaires$CSQ260<-as.factor(questionnaires$CSQ260)
questionnaires$AUQ136<-as.factor(questionnaires$AUQ136)
questionnaires$AUQ138<-as.factor(questionnaires$AUQ138)
questionnaires$CDQ001<-as.factor(questionnaires$CDQ001)
questionnaires$CDQ002<-as.factor(questionnaires$CDQ002)
questionnaires$CDQ003<-as.factor(questionnaires$CDQ003)
questionnaires$CDQ004<-as.factor(questionnaires$CDQ004)
questionnaires$CDQ005<-as.factor(questionnaires$CDQ005)
questionnaires$CDQ006<-as.factor(questionnaires$CDQ006)
questionnaires$CDQ009A<-as.factor(questionnaires$CDQ009A)
questionnaires$CDQ009B<-as.factor(questionnaires$CDQ009B)
questionnaires$CDQ009C<-as.factor(questionnaires$CDQ009C)
questionnaires$CDQ009D<-as.factor(questionnaires$CDQ009D)
questionnaires$CDQ009E<-as.factor(questionnaires$CDQ009E)
questionnaires$CDQ009F<-as.factor(questionnaires$CDQ009F)
questionnaires$CDQ009G<-as.factor(questionnaires$CDQ009G)
questionnaires$CDQ009H<-as.factor(questionnaires$CDQ009H)
questionnaires$CDQ008<-as.factor(questionnaires$CDQ008)
questionnaires$CDQ010<-as.factor(questionnaires$CDQ010)
questionnaires$DBQ700<-as.factor(questionnaires$DBQ700)
questionnaires$DBQ197<-as.factor(questionnaires$DBQ197)
questionnaires$DBQ223A<-as.factor(questionnaires$DBQ223A)
questionnaires$DBQ223B<-as.factor(questionnaires$DBQ223B)
questionnaires$DBQ223C<-as.factor(questionnaires$DBQ223C)
questionnaires$DBQ223D<-as.factor(questionnaires$DBQ223D)
questionnaires$DBQ223E<-as.factor(questionnaires$DBQ223E)
questionnaires$DBQ223U<-as.factor(questionnaires$DBQ223U)
questionnaires$DBQ229<-as.factor(questionnaires$DBQ229)
questionnaires$DBQ235A<-as.factor(questionnaires$DBQ235A)
questionnaires$DBQ235B<-as.factor(questionnaires$DBQ235B)
questionnaires$DBQ235C<-as.factor(questionnaires$DBQ235C)
questionnaires$DBQ301<-as.factor(questionnaires$DBQ301)
questionnaires$DBQ330<-as.factor(questionnaires$DBQ330)
questionnaires$DBQ360<-as.factor(questionnaires$DBQ360)
questionnaires$DBQ370<-as.factor(questionnaires$DBQ370)
questionnaires$DBD381<-as.factor(questionnaires$DBD381)
questionnaires$DBQ390<-as.factor(questionnaires$DBQ390)
questionnaires$DBQ400<-as.factor(questionnaires$DBQ400)
questionnaires$DBD411<-as.factor(questionnaires$DBD411)
questionnaires$DBQ421<-as.factor(questionnaires$DBQ421)
questionnaires$DBQ424<-as.factor(questionnaires$DBQ424)
questionnaires$DBD895<-as.factor(questionnaires$DBD895)
questionnaires$DBD900<-as.factor(questionnaires$DBD900)
questionnaires$DBD905<-as.factor(questionnaires$DBD905)
questionnaires$DBD910<-as.factor(questionnaires$DBD910)
questionnaires$DED031<-as.factor(questionnaires$DED031)
questionnaires$DEQ034A<-as.factor(questionnaires$DEQ034A)
questionnaires$DEQ034C<-as.factor(questionnaires$DEQ034C)
questionnaires$DEQ034D<-as.factor(questionnaires$DEQ034D)
questionnaires$DEQ038G<-as.factor(questionnaires$DEQ038G)
questionnaires$DEQ038Q<-as.factor(questionnaires$DEQ038Q)
questionnaires$DLQ010<-as.factor(questionnaires$DLQ010)
questionnaires$DLQ020<-as.factor(questionnaires$DLQ020)
questionnaires$DLQ040<-as.factor(questionnaires$DLQ040)
questionnaires$DLQ050<-as.factor(questionnaires$DLQ050)
questionnaires$DLQ060<-as.factor(questionnaires$DLQ060)
questionnaires$DLQ080<-as.factor(questionnaires$DLQ080)
questionnaires$DPQ010<-as.factor(questionnaires$DPQ010)
questionnaires$DPQ020<-as.factor(questionnaires$DPQ020)
questionnaires$DPQ030<-as.factor(questionnaires$DPQ030)
questionnaires$DPQ040<-as.factor(questionnaires$DPQ040)
questionnaires$DPQ050<-as.factor(questionnaires$DPQ050)
questionnaires$DPQ060<-as.factor(questionnaires$DPQ060)
questionnaires$DPQ070<-as.factor(questionnaires$DPQ070)
questionnaires$DPQ080<-as.factor(questionnaires$DPQ080)
questionnaires$DPQ090<-as.factor(questionnaires$DPQ090)
questionnaires$DPQ100<-as.factor(questionnaires$DPQ100)
questionnaires$DUQ200<-as.factor(questionnaires$DUQ200)
questionnaires$DUQ211<-as.factor(questionnaires$DUQ211)
questionnaires$DUQ217<-as.factor(questionnaires$DUQ217)
questionnaires$DUQ219<-as.factor(questionnaires$DUQ219)
questionnaires$DUQ220U<-as.factor(questionnaires$DUQ220U)
questionnaires$FSD032A<-as.factor(questionnaires$FSD032A)
questionnaires$FSD032B<-as.factor(questionnaires$FSD032B)
questionnaires$FSD032C<-as.factor(questionnaires$FSD032C)
questionnaires$FSD041<-as.factor(questionnaires$FSD041)
questionnaires$FSD052<-as.factor(questionnaires$FSD052)
questionnaires$FSD061<-as.factor(questionnaires$FSD061)
questionnaires$FSD071<-as.factor(questionnaires$FSD071)
questionnaires$FSD081<-as.factor(questionnaires$FSD081)
questionnaires$FSD092<-as.factor(questionnaires$FSD092)
questionnaires$FSD102<-as.factor(questionnaires$FSD102)
questionnaires$FSD032D<-as.factor(questionnaires$FSD032D)
questionnaires$FSD032E<-as.factor(questionnaires$FSD032E)
questionnaires$FSD032F<-as.factor(questionnaires$FSD032F)
questionnaires$FSD111<-as.factor(questionnaires$FSD111)
questionnaires$FSD122<-as.factor(questionnaires$FSD122)
questionnaires$FSD132<-as.factor(questionnaires$FSD132)
questionnaires$FSD141<-as.factor(questionnaires$FSD141)
questionnaires$FSD146<-as.factor(questionnaires$FSD146)
questionnaires$HOD050<-as.factor(questionnaires$HOD050)
questionnaires$HOQ065<-as.factor(questionnaires$HOQ065)
questionnaires$HUQ010<-as.factor(questionnaires$HUQ010)
questionnaires$HUQ020<-as.factor(questionnaires$HUQ020)
questionnaires$HUQ030<-as.factor(questionnaires$HUQ030)
questionnaires$HUQ061<-as.factor(questionnaires$HUQ061)
questionnaires$HUQ071<-as.factor(questionnaires$HUQ071)
questionnaires$HUD080<-as.factor(questionnaires$HUD080)
questionnaires$IMQ011<-as.factor(questionnaires$IMQ011)
questionnaires$IMQ020<-as.factor(questionnaires$IMQ020)
questionnaires$IMQ040<-as.factor(questionnaires$IMQ040)
questionnaires$IMQ070<-as.factor(questionnaires$IMQ070)
questionnaires$IMQ080<-as.factor(questionnaires$IMQ080)
questionnaires$IMQ045<-as.factor(questionnaires$IMQ045)
questionnaires$INQ020<-as.factor(questionnaires$INQ020)
questionnaires$INQ012<-as.factor(questionnaires$INQ012)
questionnaires$INQ030<-as.factor(questionnaires$INQ030)
questionnaires$INQ060<-as.factor(questionnaires$INQ060)
questionnaires$INQ080<-as.factor(questionnaires$INQ080)
questionnaires$INQ090<-as.factor(questionnaires$INQ090)
questionnaires$INQ132<-as.factor(questionnaires$INQ132)
questionnaires$INQ140<-as.factor(questionnaires$INQ140)
questionnaires$INQ150<-as.factor(questionnaires$INQ150)
questionnaires$IND235<-as.factor(questionnaires$IND235)
questionnaires$INDFMMPC<-as.factor(questionnaires$INDFMMPC)
questionnaires$INQ244<-as.factor(questionnaires$INQ244)
questionnaires$IND247<-as.factor(questionnaires$IND247)
questionnaires$OCD150<-as.factor(questionnaires$OCD150)
questionnaires$OCQ210<-as.factor(questionnaires$OCQ210)
questionnaires$OCQ260<-as.factor(questionnaires$OCQ260)
questionnaires$OCQ380<-as.factor(questionnaires$OCQ380)
questionnaires$OCD390G<-as.factor(questionnaires$OCD390G)
questionnaires$OHQ030<-as.factor(questionnaires$OHQ030)
questionnaires$OHQ033<-as.factor(questionnaires$OHQ033)
questionnaires$OHQ770<-as.factor(questionnaires$OHQ770)
questionnaires$OHQ780A<-as.factor(questionnaires$OHQ780A)
questionnaires$OHQ780B<-as.factor(questionnaires$OHQ780B)
questionnaires$OHQ780C<-as.factor(questionnaires$OHQ780C)
questionnaires$OHQ780D<-as.factor(questionnaires$OHQ780D)
questionnaires$OHQ780E<-as.factor(questionnaires$OHQ780E)
questionnaires$OHQ780F<-as.factor(questionnaires$OHQ780F)
questionnaires$OHQ780G<-as.factor(questionnaires$OHQ780G)
questionnaires$OHQ780H<-as.factor(questionnaires$OHQ780H)
questionnaires$OHQ780I<-as.factor(questionnaires$OHQ780I)
questionnaires$OHQ780J<-as.factor(questionnaires$OHQ780J)
questionnaires$OHQ780K<-as.factor(questionnaires$OHQ780K)
questionnaires$OHQ620<-as.factor(questionnaires$OHQ620)
questionnaires$OHQ640<-as.factor(questionnaires$OHQ640)
questionnaires$OHQ680<-as.factor(questionnaires$OHQ680)
questionnaires$OHQ835<-as.factor(questionnaires$OHQ835)
questionnaires$OHQ845<-as.factor(questionnaires$OHQ845)
questionnaires$OHQ848G<-as.factor(questionnaires$OHQ848G)
questionnaires$OHQ848Q<-as.factor(questionnaires$OHQ848Q)
questionnaires$OHQ849<-as.factor(questionnaires$OHQ849)
questionnaires$OHQ850<-as.factor(questionnaires$OHQ850)
questionnaires$OHQ855<-as.factor(questionnaires$OHQ855)
questionnaires$OHQ860<-as.factor(questionnaires$OHQ860)
questionnaires$OHQ865<-as.factor(questionnaires$OHQ865)
questionnaires$OSQ010A<-as.factor(questionnaires$OSQ010A)
questionnaires$OSQ010B<-as.factor(questionnaires$OSQ010B)
questionnaires$OSQ010C<-as.factor(questionnaires$OSQ010C)
questionnaires$OSQ020A<-as.factor(questionnaires$OSQ020A)
questionnaires$OSQ020B<-as.factor(questionnaires$OSQ020B)
questionnaires$OSQ020C<-as.factor(questionnaires$OSQ020C)
questionnaires$OSQ040AA<-as.factor(questionnaires$OSQ040AA)
questionnaires$OSD050AA<-as.factor(questionnaires$OSD050AA)
questionnaires$OSQ040AB<-as.factor(questionnaires$OSQ040AB)
questionnaires$OSD050AB<-as.factor(questionnaires$OSD050AB)
questionnaires$OSQ040AC<-as.factor(questionnaires$OSQ040AC)
questionnaires$OSD050AC<-as.factor(questionnaires$OSD050AC)
questionnaires$OSQ040BA<-as.factor(questionnaires$OSQ040BA)
questionnaires$OSD050BA<-as.factor(questionnaires$OSD050BA)
questionnaires$OSQ040BB<-as.factor(questionnaires$OSQ040BB)
questionnaires$OSD050BB<-as.factor(questionnaires$OSD050BB)
questionnaires$OSQ040BC<-as.factor(questionnaires$OSQ040BC)
questionnaires$OSD050BC<-as.factor(questionnaires$OSD050BC)
questionnaires$OSQ040BD<-as.factor(questionnaires$OSQ040BD)
questionnaires$OSD050BD<-as.factor(questionnaires$OSD050BD)
questionnaires$OSQ040BE<-as.factor(questionnaires$OSQ040BE)
questionnaires$OSQ040BF<-as.factor(questionnaires$OSQ040BF)
questionnaires$OSD030BG<-as.factor(questionnaires$OSD030BG)
questionnaires$OSQ040BG<-as.factor(questionnaires$OSQ040BG)
questionnaires$OSD030BH<-as.factor(questionnaires$OSD030BH)
questionnaires$OSQ040BH<-as.factor(questionnaires$OSQ040BH)
questionnaires$OSD030BI<-as.factor(questionnaires$OSD030BI)
questionnaires$OSQ040BI<-as.factor(questionnaires$OSQ040BI)
questionnaires$OSD030BJ<-as.factor(questionnaires$OSD030BJ)
questionnaires$OSQ040BJ<-as.factor(questionnaires$OSQ040BJ)
questionnaires$OSQ040CA<-as.factor(questionnaires$OSQ040CA)
questionnaires$OSD050CA<-as.factor(questionnaires$OSD050CA)
questionnaires$OSQ040CB<-as.factor(questionnaires$OSQ040CB)
questionnaires$OSD050CB<-as.factor(questionnaires$OSD050CB)
questionnaires$OSD030CC<-as.factor(questionnaires$OSD030CC)
questionnaires$OSQ040CC<-as.factor(questionnaires$OSQ040CC)
questionnaires$OSQ080<-as.factor(questionnaires$OSQ080)
questionnaires$OSQ090A<-as.factor(questionnaires$OSQ090A)
questionnaires$OSQ100A<-as.factor(questionnaires$OSQ100A)
questionnaires$OSQ120A<-as.factor(questionnaires$OSQ120A)
questionnaires$OSQ090B<-as.factor(questionnaires$OSQ090B)
questionnaires$OSQ100B<-as.factor(questionnaires$OSQ100B)
questionnaires$OSQ120B<-as.factor(questionnaires$OSQ120B)
questionnaires$OSQ090C<-as.factor(questionnaires$OSQ090C)
questionnaires$OSQ100C<-as.factor(questionnaires$OSQ100C)
questionnaires$OSQ120C<-as.factor(questionnaires$OSQ120C)
questionnaires$OSQ090D<-as.factor(questionnaires$OSQ090D)
questionnaires$OSQ100D<-as.factor(questionnaires$OSQ100D)
questionnaires$OSQ120D<-as.factor(questionnaires$OSQ120D)
questionnaires$OSQ090E<-as.factor(questionnaires$OSQ090E)
questionnaires$OSD110E<-as.factor(questionnaires$OSD110E)
questionnaires$OSQ120E<-as.factor(questionnaires$OSQ120E)
questionnaires$OSQ090F<-as.factor(questionnaires$OSQ090F)
questionnaires$OSQ120F<-as.factor(questionnaires$OSQ120F)
questionnaires$OSQ090G<-as.factor(questionnaires$OSQ090G)
questionnaires$OSQ100G<-as.factor(questionnaires$OSQ100G)
questionnaires$OSQ120G<-as.factor(questionnaires$OSQ120G)
questionnaires$OSQ090H<-as.factor(questionnaires$OSQ090H)
questionnaires$OSQ120H<-as.factor(questionnaires$OSQ120H)
questionnaires$OSQ060<-as.factor(questionnaires$OSQ060)
questionnaires$OSQ072<-as.factor(questionnaires$OSQ072)
questionnaires$OSQ130<-as.factor(questionnaires$OSQ130)
questionnaires$OSQ140U<-as.factor(questionnaires$OSQ140U)
questionnaires$OSQ150<-as.factor(questionnaires$OSQ150)
questionnaires$OSQ160A<-as.factor(questionnaires$OSQ160A)
questionnaires$OSQ160B<-as.factor(questionnaires$OSQ160B)
questionnaires$OSQ170<-as.factor(questionnaires$OSQ170)
questionnaires$OSQ190<-as.factor(questionnaires$OSQ190)
questionnaires$OSQ200<-as.factor(questionnaires$OSQ200)
questionnaires$OSQ220<-as.factor(questionnaires$OSQ220)
questionnaires$PFQ020<-as.factor(questionnaires$PFQ020)
questionnaires$PFQ030<-as.factor(questionnaires$PFQ030)
questionnaires$PFQ033<-as.factor(questionnaires$PFQ033)
questionnaires$PFQ041<-as.factor(questionnaires$PFQ041)
questionnaires$PFQ049<-as.factor(questionnaires$PFQ049)
questionnaires$PFQ051<-as.factor(questionnaires$PFQ051)
questionnaires$PFQ054<-as.factor(questionnaires$PFQ054)
questionnaires$PFQ057<-as.factor(questionnaires$PFQ057)
questionnaires$PFQ059<-as.factor(questionnaires$PFQ059)
questionnaires$PFQ061A<-as.factor(questionnaires$PFQ061A)
questionnaires$PFQ061B<-as.factor(questionnaires$PFQ061B)
questionnaires$PFQ061C<-as.factor(questionnaires$PFQ061C)
questionnaires$PFQ061D<-as.factor(questionnaires$PFQ061D)
questionnaires$PFQ061E<-as.factor(questionnaires$PFQ061E)
questionnaires$PFQ061F<-as.factor(questionnaires$PFQ061F)
questionnaires$PFQ061G<-as.factor(questionnaires$PFQ061G)
questionnaires$PFQ061H<-as.factor(questionnaires$PFQ061H)
questionnaires$PFQ061I<-as.factor(questionnaires$PFQ061I)
questionnaires$PFQ061J<-as.factor(questionnaires$PFQ061J)
questionnaires$PFQ061K<-as.factor(questionnaires$PFQ061K)
questionnaires$PFQ061L<-as.factor(questionnaires$PFQ061L)
questionnaires$PFQ061M<-as.factor(questionnaires$PFQ061M)
questionnaires$PFQ061N<-as.factor(questionnaires$PFQ061N)
questionnaires$PFQ061O<-as.factor(questionnaires$PFQ061O)
questionnaires$PFQ061P<-as.factor(questionnaires$PFQ061P)
questionnaires$PFQ061Q<-as.factor(questionnaires$PFQ061Q)
questionnaires$PFQ061R<-as.factor(questionnaires$PFQ061R)
questionnaires$PFQ061S<-as.factor(questionnaires$PFQ061S)
questionnaires$PFQ061T<-as.factor(questionnaires$PFQ061T)
questionnaires$PAQ605<-as.factor(questionnaires$PAQ605)
questionnaires$PAQ610<-as.factor(questionnaires$PAQ610)
questionnaires$PAQ620<-as.factor(questionnaires$PAQ620)
questionnaires$PAQ625<-as.factor(questionnaires$PAQ625)
questionnaires$PAQ635<-as.factor(questionnaires$PAQ635)
questionnaires$PAQ640<-as.factor(questionnaires$PAQ640)
questionnaires$PAQ650<-as.factor(questionnaires$PAQ650)
questionnaires$PAQ655<-as.factor(questionnaires$PAQ655)
questionnaires$PAQ665<-as.factor(questionnaires$PAQ665)
questionnaires$PAQ670<-as.factor(questionnaires$PAQ670)
questionnaires$PAQ706<-as.factor(questionnaires$PAQ706)
questionnaires$PAQ710<-as.factor(questionnaires$PAQ710)
questionnaires$PAQ715<-as.factor(questionnaires$PAQ715)
questionnaires$PAQ722<-as.factor(questionnaires$PAQ722)
questionnaires$PAQ724A<-as.factor(questionnaires$PAQ724A)
questionnaires$PAQ724B<-as.factor(questionnaires$PAQ724B)
questionnaires$PAQ724C<-as.factor(questionnaires$PAQ724C)
questionnaires$PAQ724D<-as.factor(questionnaires$PAQ724D)
questionnaires$PAQ724E<-as.factor(questionnaires$PAQ724E)
questionnaires$PAQ724F<-as.factor(questionnaires$PAQ724F)
questionnaires$PAQ724G<-as.factor(questionnaires$PAQ724G)
questionnaires$PAQ724H<-as.factor(questionnaires$PAQ724H)
questionnaires$PAQ724I<-as.factor(questionnaires$PAQ724I)
questionnaires$PAQ724J<-as.factor(questionnaires$PAQ724J)
questionnaires$PAQ724K<-as.factor(questionnaires$PAQ724K)
questionnaires$PAQ724L<-as.factor(questionnaires$PAQ724L)
questionnaires$PAQ724M<-as.factor(questionnaires$PAQ724M)
questionnaires$PAQ724N<-as.factor(questionnaires$PAQ724N)
questionnaires$PAQ724O<-as.factor(questionnaires$PAQ724O)
questionnaires$PAQ724P<-as.factor(questionnaires$PAQ724P)
questionnaires$PAQ724Q<-as.factor(questionnaires$PAQ724Q)
questionnaires$PAQ724R<-as.factor(questionnaires$PAQ724R)
questionnaires$PAQ724S<-as.factor(questionnaires$PAQ724S)
questionnaires$PAQ724T<-as.factor(questionnaires$PAQ724T)
questionnaires$PAQ724U<-as.factor(questionnaires$PAQ724U)
questionnaires$PAQ724V<-as.factor(questionnaires$PAQ724V)
questionnaires$PAQ724W<-as.factor(questionnaires$PAQ724W)
questionnaires$PAQ724X<-as.factor(questionnaires$PAQ724X)
questionnaires$PAQ724Y<-as.factor(questionnaires$PAQ724Y)
questionnaires$PAQ724Z<-as.factor(questionnaires$PAQ724Z)
questionnaires$PAQ724AA<-as.factor(questionnaires$PAQ724AA)
questionnaires$PAQ724AB<-as.factor(questionnaires$PAQ724AB)
questionnaires$PAQ724AC<-as.factor(questionnaires$PAQ724AC)
questionnaires$PAQ724AD<-as.factor(questionnaires$PAQ724AD)
questionnaires$PAQ724AE<-as.factor(questionnaires$PAQ724AE)
questionnaires$PAQ724AF<-as.factor(questionnaires$PAQ724AF)
questionnaires$PAQ724CM<-as.factor(questionnaires$PAQ724CM)
questionnaires$PAQ731<-as.factor(questionnaires$PAQ731)
questionnaires$PAQ677<-as.factor(questionnaires$PAQ677)
questionnaires$PAQ678<-as.factor(questionnaires$PAQ678)
questionnaires$PAQ740<-as.factor(questionnaires$PAQ740)
questionnaires$PAQ742<-as.factor(questionnaires$PAQ742)
questionnaires$PAQ744<-as.factor(questionnaires$PAQ744)
questionnaires$PAQ746<-as.factor(questionnaires$PAQ746)
questionnaires$PAQ748<-as.factor(questionnaires$PAQ748)
questionnaires$PAQ755<-as.factor(questionnaires$PAQ755)
questionnaires$PAQ759A<-as.factor(questionnaires$PAQ759A)
questionnaires$PAQ759B<-as.factor(questionnaires$PAQ759B)
questionnaires$PAQ759C<-as.factor(questionnaires$PAQ759C)
questionnaires$PAQ759D<-as.factor(questionnaires$PAQ759D)
questionnaires$PAQ759E<-as.factor(questionnaires$PAQ759E)
questionnaires$PAQ759F<-as.factor(questionnaires$PAQ759F)
questionnaires$PAQ759G<-as.factor(questionnaires$PAQ759G)
questionnaires$PAQ759H<-as.factor(questionnaires$PAQ759H)
questionnaires$PAQ759I<-as.factor(questionnaires$PAQ759I)
questionnaires$PAQ759J<-as.factor(questionnaires$PAQ759J)
questionnaires$PAQ759K<-as.factor(questionnaires$PAQ759K)
questionnaires$PAQ759L<-as.factor(questionnaires$PAQ759L)
questionnaires$PAQ759M<-as.factor(questionnaires$PAQ759M)
questionnaires$PAQ759N<-as.factor(questionnaires$PAQ759N)
questionnaires$PAQ759O<-as.factor(questionnaires$PAQ759O)
questionnaires$PAQ759P<-as.factor(questionnaires$PAQ759P)
questionnaires$PAQ759Q<-as.factor(questionnaires$PAQ759Q)
questionnaires$PAQ759R<-as.factor(questionnaires$PAQ759R)
questionnaires$PAQ759S<-as.factor(questionnaires$PAQ759S)
questionnaires$PAQ759T<-as.factor(questionnaires$PAQ759T)
questionnaires$PAQ759U<-as.factor(questionnaires$PAQ759U)
questionnaires$PAQ759V<-as.factor(questionnaires$PAQ759V)
questionnaires$PAQ762<-as.factor(questionnaires$PAQ762)
questionnaires$PAQ764<-as.factor(questionnaires$PAQ764)
questionnaires$PAQ766<-as.factor(questionnaires$PAQ766)
questionnaires$PAQ679<-as.factor(questionnaires$PAQ679)
questionnaires$PAQ750<-as.factor(questionnaires$PAQ750)
questionnaires$PAQ770<-as.factor(questionnaires$PAQ770)
questionnaires$PAQ772A<-as.factor(questionnaires$PAQ772A)
questionnaires$PAQ772B<-as.factor(questionnaires$PAQ772B)
questionnaires$PAQ772C<-as.factor(questionnaires$PAQ772C)
questionnaires$PUQ100<-as.factor(questionnaires$PUQ100)
questionnaires$PUQ110<-as.factor(questionnaires$PUQ110)
questionnaires$RHQ020<-as.factor(questionnaires$RHQ020)
questionnaires$RHQ031<-as.factor(questionnaires$RHQ031)
questionnaires$RHD043<-as.factor(questionnaires$RHD043)
questionnaires$RHQ070<-as.factor(questionnaires$RHQ070)
questionnaires$RHQ074<-as.factor(questionnaires$RHQ074)
questionnaires$RHQ076<-as.factor(questionnaires$RHQ076)
questionnaires$RHQ078<-as.factor(questionnaires$RHQ078)
questionnaires$RHQ131<-as.factor(questionnaires$RHQ131)
questionnaires$RHD143<-as.factor(questionnaires$RHD143)
questionnaires$RHQ160<-as.factor(questionnaires$RHQ160)
questionnaires$RHQ162<-as.factor(questionnaires$RHQ162)
questionnaires$RHQ172<-as.factor(questionnaires$RHQ172)
questionnaires$RHQ305<-as.factor(questionnaires$RHQ305)
questionnaires$RHQ420<-as.factor(questionnaires$RHQ420)
questionnaires$SLD010H<-as.factor(questionnaires$SLD010H)
questionnaires$SMQ020<-as.factor(questionnaires$SMQ020)
questionnaires$SMQ040<-as.factor(questionnaires$SMQ040)
questionnaires$SMQ050U<-as.factor(questionnaires$SMQ050U)
questionnaires$SMQ078<-as.factor(questionnaires$SMQ078)
questionnaires$SMD630<-as.factor(questionnaires$SMD630)
questionnaires$SMQ670<-as.factor(questionnaires$SMQ670)
questionnaires$SMQ856<-as.factor(questionnaires$SMQ856)
questionnaires$SMQ858<-as.factor(questionnaires$SMQ858)
questionnaires$SMQ860<-as.factor(questionnaires$SMQ860)
questionnaires$SMQ862<-as.factor(questionnaires$SMQ862)
questionnaires$SMQ866<-as.factor(questionnaires$SMQ866)
questionnaires$SMQ868<-as.factor(questionnaires$SMQ868)
questionnaires$SMQ870<-as.factor(questionnaires$SMQ870)
questionnaires$SMQ872<-as.factor(questionnaires$SMQ872)
questionnaires$SMQ874<-as.factor(questionnaires$SMQ874)
questionnaires$SMQ876<-as.factor(questionnaires$SMQ876)
questionnaires$SMQ878<-as.factor(questionnaires$SMQ878)
questionnaires$SMQ880<-as.factor(questionnaires$SMQ880)
questionnaires$SMQ681<-as.factor(questionnaires$SMQ681)
questionnaires$SMQ690A<-as.factor(questionnaires$SMQ690A)
questionnaires$SMQ710<-as.factor(questionnaires$SMQ710)
questionnaires$SMQ725<-as.factor(questionnaires$SMQ725)
questionnaires$SMQ690B<-as.factor(questionnaires$SMQ690B)
questionnaires$SMQ740<-as.factor(questionnaires$SMQ740)
questionnaires$SMQ690C<-as.factor(questionnaires$SMQ690C)
questionnaires$SMQ770<-as.factor(questionnaires$SMQ770)
questionnaires$SMQ690G<-as.factor(questionnaires$SMQ690G)
questionnaires$SMQ845<-as.factor(questionnaires$SMQ845)
questionnaires$SMQ690H<-as.factor(questionnaires$SMQ690H)
questionnaires$SMQ849<-as.factor(questionnaires$SMQ849)
questionnaires$SMQ851<-as.factor(questionnaires$SMQ851)
questionnaires$SMQ690D<-as.factor(questionnaires$SMQ690D)
questionnaires$SMQ800<-as.factor(questionnaires$SMQ800)
questionnaires$SMQ690E<-as.factor(questionnaires$SMQ690E)
questionnaires$SMQ817<-as.factor(questionnaires$SMQ817)
questionnaires$SMQ690I<-as.factor(questionnaires$SMQ690I)
questionnaires$SMQ857<-as.factor(questionnaires$SMQ857)
questionnaires$SMQ863<-as.factor(questionnaires$SMQ863)
questionnaires$SMQ690F<-as.factor(questionnaires$SMQ690F)
questionnaires$SMQ830<-as.factor(questionnaires$SMQ830)
questionnaires$SMQ840<-as.factor(questionnaires$SMQ840)
questionnaires$SMDANY<-as.factor(questionnaires$SMDANY)
questionnaires$WHQ030<-as.factor(questionnaires$WHQ030)
questionnaires$WHQ040<-as.factor(questionnaires$WHQ040)
questionnaires$WHQ060<-as.factor(questionnaires$WHQ060)
questionnaires$WHQ070<-as.factor(questionnaires$WHQ070)
questionnaires$WHD080A<-as.factor(questionnaires$WHD080A)
questionnaires$WHD080B<-as.factor(questionnaires$WHD080B)
questionnaires$WHD080C<-as.factor(questionnaires$WHD080C)
questionnaires$WHD080D<-as.factor(questionnaires$WHD080D)
questionnaires$WHD080E<-as.factor(questionnaires$WHD080E)
questionnaires$WHD080F<-as.factor(questionnaires$WHD080F)
questionnaires$WHD080G<-as.factor(questionnaires$WHD080G)
questionnaires$WHD080H<-as.factor(questionnaires$WHD080H)
questionnaires$WHD080I<-as.factor(questionnaires$WHD080I)
questionnaires$WHD080J<-as.factor(questionnaires$WHD080J)
questionnaires$WHD080K<-as.factor(questionnaires$WHD080K)
questionnaires$WHD080M<-as.factor(questionnaires$WHD080M)
questionnaires$WHD080N<-as.factor(questionnaires$WHD080N)
questionnaires$WHD080O<-as.factor(questionnaires$WHD080O)
questionnaires$WHD080P<-as.factor(questionnaires$WHD080P)
questionnaires$WHD080Q<-as.factor(questionnaires$WHD080Q)
questionnaires$WHD080R<-as.factor(questionnaires$WHD080R)
questionnaires$WHD080S<-as.factor(questionnaires$WHD080S)
questionnaires$WHD080T<-as.factor(questionnaires$WHD080T)
questionnaires$WHD080U<-as.factor(questionnaires$WHD080U)
questionnaires$WHD080L<-as.factor(questionnaires$WHD080L)
questionnaires$WHQ030M<-as.factor(questionnaires$WHQ030M)
questionnaires$WHQ500<-as.factor(questionnaires$WHQ500)
questionnaires$WHQ520<-as.factor(questionnaires$WHQ520)

diet$SEQN<-as.factor(diet$SEQN)
diet$DRABF<-as.factor(diet$DRABF)
diet$DBQ095Z<-as.factor(diet$DBQ095Z)
diet$DR1STY<-as.factor(diet$DR1STY)
diet$DR1SKY<-as.factor(diet$DR1SKY)
diet$DR1.300<-as.factor(diet$DR1.300)
diet$DR1TWS<-as.factor(diet$DR1TWS)
diet$DRD340<-as.factor(diet$DRD340)
diet$DRD360<-as.factor(diet$DRD360)
diet$DRD370V<-as.factor(diet$DRD370V)

disease$Essential..primary..hypertension<-as.factor(disease$Essential..primary..hypertension)
disease$Pure.hypercholesterolemia<-as.factor(disease$Pure.hypercholesterolemia)
disease$Type.2.diabetes.mellitus<-as.factor(disease$Type.2.diabetes.mellitus)

str(disease)

#set seed
set.seed(77300) 


############################
### Predict hypertension ###
############################

###combine data for prediction###
hypertension <- cbind(demographic,diet[,c(2:ncol(diet))],questionnaires[,c(2:ncol(questionnaires))],disease[,c(2,ncol(disease))])
hypertension <- hypertension[,c(2:(ncol(hypertension)-1))]
inTrain <- createDataPartition(y = hypertension$Essential..primary..hypertension,
                               p = 0.8, list = FALSE)
training <- hypertension[ inTrain,]
testing <- hypertension[ -inTrain,]

###
### RPART ###
###

CART_cp = rpart.control(cp = 0.00000000001) #set cp to a small number to "grow" a large tree

rpart_tree<-rpart(Essential..primary..hypertension~.,data=training, method="class", control=CART_cp) #"Grow" a tree on training data
printcp(rpart_tree) # Understand the relationship between the cross-validated error, size of the tree and cp
plotcp(rpart_tree) # As a rule of thumb pick up the largest cp which does not give a substantial drop in error

prunned_rpart_tree<-prune(rpart_tree, cp=0.00415) #Prun the tree. Play with cp to see how the resultant tree changes
plot(as.party(prunned_rpart_tree), type = "extended",gp = gpar(fontsize = 7)) #Plotting the tree (adjust fontsize if needed)
  
rpart_prediction_class<-predict(prunned_rpart_tree,newdata=testing, type="class") #Predict classification (for confusion matrix)
confusionMatrix(rpart_prediction_class,testing$Essential..primary..hypertension,positive = "1") #Display confusion matrix

rpart_probabilities_testing <-predict(prunned_rpart_tree,newdata=testing,type = "prob") #Predict probabilities
rpart_pred_testing <- prediction(rpart_probabilities_testing[,2], testing$Essential..primary..hypertension) #Calculate errors
rpart_ROC_testing <- performance(rpart_pred_testing,"tpr","fpr") #Create ROC curve data
plot(rpart_ROC_testing) #Plot ROC curve

auc.tmp <- performance(rpart_pred_testing,"auc") #Create AUC data
rpart_auc_testing <- as.numeric(auc.tmp@y.values) #Calculate AUC
rpart_auc_testing #Display AUC value

plotLift(rpart_prediction_class,  testing$Essential..primary..hypertension, cumulative = TRUE, n.buckets = 10) # Plot Lift chart

###
###Random Forest - Hypertension ###
###

model_forest <- randomForest(Essential..primary..hypertension~ ., data=training, 
                             importance=TRUE,proximity=TRUE,
                             cutoff = c(0.9, 0.1),type="classification") 
#cutoffs determined at default 90/10, to be more conservative

print(model_forest)   
plot(model_forest)
importance(model_forest)
varImpPlot(model_forest)

###Finding predicitons: probabilities and classification
forest_probabilities<-predict(model_forest,newdata=testing,type="prob") #Predict probabilities -- an array with 2 columns: for not retained (class 0) and for retained (class 1)
forest_classification<-rep("1",500)
forest_classification[forest_probabilities[,2]<0.1]="0" 
forest_classification<-as.factor(forest_classification)

confusionMatrix(forest_classification,testing$Essential..primary..hypertension, positive="1") 

####ROC Curve
forest_ROC_prediction <- prediction(forest_probabilities[,2], testing$Essential..primary..hypertension) #Calculate errors
forest_ROC <- performance(forest_ROC_prediction,"tpr","fpr") #Create ROC curve data
plot(forest_ROC) #Plot ROC curve

####AUC (area under curve)
AUC.tmp <- performance(forest_ROC_prediction,"auc") #Create AUC data
forest_AUC <- as.numeric(AUC.tmp@y.values) #Calculate AUC
forest_AUC #Display AUC value: 90+% - excellent, 80-90% - very good, 70-80% - good, 60-70% - so so, below 60% - not much value

#### Lift chart
plotLift(forest_probabilities[,2],  testing$Essential..primary..hypertension, cumulative = TRUE, n.buckets = 10) # Plot Lift chart

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

#combine data for prediction
T2D <- cbind(demographic,diet[,c(2:ncol(diet))],questionnaires[,c(2:ncol(questionnaires))],disease[,c(4,ncol(disease))])
T2D <- T2D[,c(2:(ncol(T2D)-1))]
inTrain <- createDataPartition(y = T2D$Type.2.diabetes.mellitus,
                               p = 0.8, list = FALSE)
training <- T2D[ inTrain,]
testing <- T2D[ -inTrain,]

### RPART
CART_cp = rpart.control(cp = 0.00000000001) #set cp to a small number to "grow" a large tree

rpart_tree<-rpart(Type.2.diabetes.mellitus~.,data=training, method="class", control=CART_cp) #"Grow" a tree on training data

printcp(rpart_tree) # Understand the relationship between the cross-validated error, size of the tree and cp
plotcp(rpart_tree) # As a rule of thumb pick up the largest cp which does not give a substantial drop in error

prunned_rpart_tree<-prune(rpart_tree, cp=0.011) #Prun the tree. Play with cp to see how the resultant tree changes
plot(as.party(prunned_rpart_tree), type = "extended",gp = gpar(fontsize = 7)) #Plotting the tree (adjust fontsize if needed)

rpart_prediction_class<-predict(prunned_rpart_tree,newdata=testing, type="class") #Predict classification (for confusion matrix)
confusionMatrix(rpart_prediction_class,testing$Type.2.diabetes.mellitus,positive = "1") #Display confusion matrix

rpart_probabilities_testing <-predict(prunned_rpart_tree,newdata=testing,type = "prob") #Predict probabilities
rpart_pred_testing <- prediction(rpart_probabilities_testing[,2], testing$Type.2.diabetes.mellitus) #Calculate errors
rpart_ROC_testing <- performance(rpart_pred_testing,"tpr","fpr") #Create ROC curve data
plot(rpart_ROC_testing) #Plot ROC curve

auc.tmp <- performance(rpart_pred_testing,"auc") #Create AUC data
rpart_auc_testing <- as.numeric(auc.tmp@y.values) #Calculate AUC
rpart_auc_testing #Display AUC value

plotLift(rpart_prediction_class,  testing$Type.2.diabetes.mellitus, cumulative = TRUE, n.buckets = 10) # Plot Lift chart

###
### Random Forest: T2D ###
###


model_forest <- randomForest(Type.2.diabetes.mellitus~ ., data=training, 
                             importance=TRUE,proximity=TRUE,
                             cutoff = c(0.9, 0.1),type="classification") 
#cutoffs determined at default 90/10, to be more conservative

print(model_forest)   
plot(model_forest)
importance(model_forest)
varImpPlot(model_forest)


###Finding predicitons: probabilities and classification
forest_probabilities<-predict(model_forest,newdata=testing,type="prob") #Predict probabilities -- an array with 2 columns: for not retained (class 0) and for retained (class 1)
forest_classification<-rep("1",500)
forest_classification[forest_probabilities[,2]<0.1]="0" 
forest_classification<-as.factor(forest_classification)

confusionMatrix(forest_classification,testing$Type.2.diabetes.mellitus, positive="1") 

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


####################################
### Predict Hypercholesterolemia ###
####################################

#combine data for prediction
hyperlipidemia <- cbind(demographic,diet[,c(2:ncol(diet))],questionnaires[,c(2:ncol(questionnaires))],disease[,c(3,ncol(disease))])
hyperlipidemia <- hyperlipidemia[,c(2:(ncol(hyperlipidemia)-1))]
inTrain <- createDataPartition(y = hyperlipidemia$Pure.hypercholesterolemia,
                               p = 0.8, list = FALSE)
training <- hyperlipidemia[ inTrain,]
testing <- hyperlipidemia[ -inTrain,]

#RPART
CART_cp = rpart.control(cp = 0.00000000001) #set cp to a small number to "grow" a large tree

rpart_tree<-rpart(Pure.hypercholesterolemia~.,data=training, method="class", control=CART_cp) #"Grow" a tree on training data

printcp(rpart_tree) # Understand the relationship between the cross-validated error, size of the tree and cp
plotcp(rpart_tree) # As a rule of thumb pick up the largest cp which does not give a substantial drop in error

prunned_rpart_tree<-prune(rpart_tree, cp=0.0066) #Prun the tree. Play with cp to see how the resultant tree changes
plot(as.party(prunned_rpart_tree), type = "extended",gp = gpar(fontsize = 7)) #Plotting the tree (adjust fontsize if needed)

rpart_prediction_class<-predict(prunned_rpart_tree,newdata=testing, type="class") #Predict classification (for confusion matrix)
confusionMatrix(rpart_prediction_class,testing$Pure.hypercholesterolemia,positive = "1") #Display confusion matrix

rpart_probabilities_testing <-predict(prunned_rpart_tree,newdata=testing,type = "prob") #Predict probabilities
rpart_pred_testing <- prediction(rpart_probabilities_testing[,2], testing$Pure.hypercholesterolemia) #Calculate errors
rpart_ROC_testing <- performance(rpart_pred_testing,"tpr","fpr") #Create ROC curve data
plot(rpart_ROC_testing) #Plot ROC curve

auc.tmp <- performance(rpart_pred_testing,"auc") #Create AUC data
rpart_auc_testing <- as.numeric(auc.tmp@y.values) #Calculate AUC
rpart_auc_testing #Display AUC value

plotLift(rpart_prediction_class,  testing$Pure.hypercholesterolemia, cumulative = TRUE, n.buckets = 10) # Plot Lift chart

###
###Random Forest - Hypercholesterolemia
###

model_forest <- randomForest(Pure.hypercholesterolemia~ ., data=training, 
                             importance=TRUE,proximity=TRUE,
                             cutoff = c(0.9, 0.1),type="classification") 
#cutoffs determined at default 90/10, to be more conservative

print(model_forest)   
plot(model_forest)
importance(model_forest)
varImpPlot(model_forest)

###Finding predicitons: probabilities and classification
forest_probabilities<-predict(model_forest,newdata=testing,type="prob") #Predict probabilities -- an array with 2 columns: for not retained (class 0) and for retained (class 1)
forest_classification<-rep("1",500)
forest_classification[forest_probabilities[,2]<0.1]="0" 

forest_classification<-as.factor(forest_classification)

confusionMatrix(forest_classification,testing$Pure.hypercholesterolemia, positive="1") 


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
