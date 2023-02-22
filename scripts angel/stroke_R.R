#Primary analysis: set risk periods as follows: 1-14, 15-30, 31-60;
test2<-read.table(file="D:/OneDrive - connect.hku.hk/Projects/papers with others/Angel Wong/PPI and stroke/sccs_ppistroke_allrx.txt",
                  header=F, sep="")
xindiv<-test2[,1]
xgender<-test2[,2]
xpresent<-test2[,7]
xgroup<-test2[,9]
xadrug<-test2[,4]
xlower<-test2[,10]
xupper<-test2[,11]
xexposed<-test2[,8]
xastart<-test2[,3]
xaend<-test2[,6]
xaevent<-test2[,5]
head(test2)

library(survival)


interv<-xupper-xlower+0.99
logint<-log(interv)
agroup<-relevel(as.factor(xgroup),ref=1)
egroup<-as.factor(xexposed+1)
event<-(xlower<=xaevent)*(xaevent<=xupper)
ggroup<-as.factor(xgender+1)


# Fit standard case series models

modall<-clogit(event~egroup+agroup+strata(xindiv)+offset(logint))
summary(modall)
modall$loglik[2]
#           exp(coef) exp(-coef) lower .95 upper .95
#egroup2   9.184e-01  1.089e+00    0.7144    1.1807
#egroup3   1.005e+00  9.954e-01    0.7874    1.2818
#egroup4   8.073e-01  1.239e+00    0.6211    1.0491
#egroup5   7.758e-01  1.289e+00    0.6326    0.9515

#Primary analysis: day 1-14, 15-30, 31-60 with adjustment of anticoagulants etc
test2<-read.table(file="C:/Users/Angel YS Wong/Desktop/PPIs & stroke/R dataset/sccs_ppistroke_main_anticoag.txt",
                  header=F, sep="")
xindiv<-test2[,1]
xgender<-test2[,2]
xpresent<-test2[,7]
xgroup<-test2[,9]
xadrug<-test2[,4]
xlower<-test2[,10]
xupper<-test2[,11]
xexposed_aa<-test2[,12]
xexposed<-test2[,8]
xastart<-test2[,3]
xaend<-test2[,6]
xaevent<-test2[,5]
head(test2)

library(survival)


interv<-xupper-xlower+0.99
logint<-log(interv)
agroup<-relevel(as.factor(xgroup),ref=1)
egroup<-as.factor(xexposed+1)
egroup_aa<-as.factor(xexposed_aa+1)
event<-(xlower<=xaevent)*(xaevent<=xupper)
ggroup<-as.factor(xgender+1)


# Fit standard case series models

modall<-clogit(event~egroup+agroup+strata(xindiv)+egroup_aa+offset(logint))
summary(modall)

#            exp(coef) exp(-coef) lower .95 upper .95
#egroup2    9.228e-01  1.084e+00    0.7176    1.1866
#egroup3    1.037e+00  9.646e-01    0.8124    1.3231
#egroup4    8.306e-01  1.204e+00    0.6389    1.0797
#egroup5    7.957e-01  1.257e+00    0.6486    0.9760
#egroup_aa2 5.672e-01  1.763e+00    0.5289    0.6082

#After putting interaction

modall_int<-clogit(event~egroup+agroup+strata(xindiv)+egroup_aa+egroup*egroup_aa+offset(logint))
summary(modall_int)

#                   exp(coef) exp(-coef)  lower .95  upper .95
#egroup2            1.195e+00  8.368e-01    0.8497    1.6808
#egroup3            1.012e+00  9.878e-01    0.6767    1.5145
#egroup4            1.074e+00  9.313e-01    0.7382    1.5617
#egroup5            9.757e-01  1.025e+00    0.7248    1.3134
#egroup_aa2         5.748e-01  1.740e+00    0.5357    0.6168
#egroup2:egroup_aa2 6.047e-01  1.654e+00    0.3647    1.0026
#egroup3:egroup_aa2 1.036e+00  9.649e-01    0.6246    1.7195
#egroup4:egroup_aa2 6.331e-01  1.580e+00    0.3745    1.0702
#egroup5:egroup_aa2 6.979e-01  1.433e+00    0.4634    1.0510


#sensitivity analysis 1: set pre-risk, during Rx, post 1-30 days, post 31-60 days
test2<-read.table(file="C:/Users/Angel YS Wong/Desktop/PPIs & stroke/R dataset/sen1_primary_risk_final.txt",
                  header=F, sep="")
xindiv<-test2[,1]
xgender<-test2[,2]
xpresent<-test2[,7]
xgroup<-test2[,9]
xadrug<-test2[,4]
xlower<-test2[,10]
xupper<-test2[,11]
xexposed<-test2[,8]
xastart<-test2[,3]
xaend<-test2[,6]
xaevent<-test2[,5]
head(test2)

library(survival)


interv<-xupper-xlower+0.99
logint<-log(interv)
agroup<-relevel(as.factor(xgroup),ref=1)
egroup<-as.factor(xexposed+1)
event<-(xlower<=xaevent)*(xaevent<=xupper)
ggroup<-as.factor(xgender+1)


# Fit standard case series models

modall<-clogit(event~egroup+agroup+strata(xindiv)+offset(logint))
summary(modall)

#           exp(coef) exp(-coef) lower .95 upper .95
#egroup2   8.834e-01  1.132e+00    0.6871    1.1358
#egroup3   6.529e-01  1.532e+00    0.5939    0.7177
#egroup4   9.865e-01  1.014e+00    0.7830    1.2430
#egroup5   9.213e-01  1.085e+00    0.7177    1.1827

#sensitivity analysis 2: set pre-risk, during Rx, post 1-30 days, post 31-60 days with adjustment of anticoagulants etc
test2<-read.table(file="C:/Users/Angel YS Wong/Desktop/PPIs & stroke/R dataset/sen2_primary_risk_final.txt",
                  header=F, sep="")
xindiv<-test2[,1]
xgender<-test2[,2]
xpresent<-test2[,7]
xgroup<-test2[,9]
xadrug<-test2[,4]
xlower<-test2[,10]
xupper<-test2[,11]
xexposed_aa<-test2[,12]
xexposed<-test2[,8]
xastart<-test2[,3]
xaend<-test2[,6]
xaevent<-test2[,5]
head(test2)

library(survival)


interv<-xupper-xlower+0.99
logint<-log(interv)
agroup<-relevel(as.factor(xgroup),ref=1)
egroup<-as.factor(xexposed+1)
egroup_aa<-as.factor(xexposed_aa+1)
event<-(xlower<=xaevent)*(xaevent<=xupper)
ggroup<-as.factor(xgender+1)


# Fit standard case series models

modall<-clogit(event~egroup+agroup+strata(xindiv)+egroup_aa+offset(logint))
summary(modall)

#            exp(coef) exp(-coef) lower .95 upper .95
#egroup2    9.085e-01  1.101e+00    0.7065    1.1683
#egroup3    7.000e-01  1.429e+00    0.6363    0.7700
#egroup4    9.792e-01  1.021e+00    0.7771    1.2340
#egroup5    9.188e-01  1.088e+00    0.7156    1.1796
#egroup_aa2 5.780e-01  1.730e+00    0.5399    0.6188

# after adding the interaction term:

modall_int<-clogit(event~egroup+agroup+strata(xindiv)+egroup_aa+egroup*egroup_aa+offset(logint))
summary(modall_int)

#                   exp(coef) exp(-coef) lower .95 upper .95
#egroup2            1.137e+00  8.796e-01    0.8086    1.5985
#egroup3            9.623e-01  1.039e+00    0.8122    1.1401
#egroup4            9.720e-01  1.029e+00    0.7173    1.3172
#egroup5            8.585e-01  1.165e+00    0.6109    1.20666
#egroup_aa2         5.962e-01  1.677e+00    0.5559    0.6393
#egroup2:egroup_aa2 6.429e-01  1.555e+00    0.3879    1.0656
#egroup3:egroup_aa2 6.424e-01  1.557e+00    0.5248    0.7862
#egroup4:egroup_aa2 1.033e+00  9.676e-01    0.6470    1.6510
#egroup5:egroup_aa2 1.180e+00  8.477e-01    0.7145    1.9476


#sensitivity analysis 3: remove patients with haemorrhagic stroke from primary analysis
test4<-read.table(file="C:/Users/Angel YS Wong/Desktop/PPIs & stroke/R dataset/sen3_primary_risk_final.txt",
                  header=F, sep="")
xindiv<-test4[,1]
xgender<-test4[,2]
xpresent<-test4[,7]
xgroup<-test4[,9]
xadrug<-test4[,4]
xlower<-test4[,10]
xupper<-test4[,11]
xexposed<-test4[,8]
xastart<-test4[,3]
xaend<-test4[,6]
xaevent<-test4[,5]
head(test4)

library(survival)


interv<-xupper-xlower+0.99
logint<-log(interv)
agroup<-relevel(as.factor(xgroup),ref=1)
egroup<-as.factor(xexposed+1)
event<-(xlower<=xaevent)*(xaevent<=xupper)
ggroup<-as.factor(xgender+1)


# Fit standard case series models

modall<-clogit(event~egroup+agroup+strata(xindiv)+offset(logint))
summary(modall)

#           exp(coef) exp(-coef) lower .95 upper .95
#egroup2   1.057e+00  9.461e-01    0.8184    1.3651
#egroup3   8.853e-01  1.130e+00    0.6672    1.1747
#egroup4   6.570e-01  1.522e+00    0.4787    0.9015
#egroup5   7.354e-01  1.360e+00    0.5854    0.9239

#sensitivity analysis 5: remove patients with stroke event died 90 days after from primary analysis
test4<-read.table(file="C:/Users/Angel YS Wong/Desktop/PPIs & stroke/R dataset/sen5_primary_risk_final.txt",
                  header=F, sep="")
xindiv<-test4[,1]
xgender<-test4[,2]
xpresent<-test4[,7]
xgroup<-test4[,9]
xadrug<-test4[,4]
xlower<-test4[,10]
xupper<-test4[,11]
xexposed<-test4[,8]
xastart<-test4[,3]
xaend<-test4[,6]
xaevent<-test4[,5]
head(test4)

library(survival)


interv<-xupper-xlower+0.99
logint<-log(interv)
agroup<-relevel(as.factor(xgroup),ref=1)
egroup<-as.factor(xexposed+1)
event<-(xlower<=xaevent)*(xaevent<=xupper)
ggroup<-as.factor(xgender+1)


# Fit standard case series models

modall<-clogit(event~egroup+agroup+strata(xindiv)+offset(logint))
summary(modall)

#          exp(coef) exp(-coef) lower .95 upper .95
#egroup2   9.741e-01  1.027e+00   0.75461   1.25753
#egroup3   8.143e-01  1.228e+00   0.61411   1.07987
#egroup4   6.636e-01  1.507e+00   0.49095   0.89699
#egroup5   6.571e-01  1.522e+00   0.52177   0.82765

#case-case-time-control method

ctc_estimate<-clogit(rw~factor(exp)+factor(exp)*factor(case)+strata(matchid))

summary(ctc_estimate)