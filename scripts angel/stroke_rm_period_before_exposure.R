#Primary analysis: set risk periods as follows: 1-14, 15-30, 31-60;
test2<-read.table(file="I:/PPIs & stroke/R dataset/sccs_ppistroke_rm_period_bef_exp.txt",
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



#Primary analysis: set risk periods as follows: 1-14, 15-30, 31-60;
test2<-read.table(file="I:/PPIs & stroke/R dataset/sccs_ppistroke_notrmip.txt",
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

#Primary analysis: day 1-14, 15-30, 31-60 with inpatient PPIs as a covarate
test2<-read.table(file="I:/PPIs & stroke/R dataset/sccs_ppistroke_ipppi_cov_firevt.txt",
                  header=F, sep="")
xindiv<-test2[,1]
xgender<-test2[,2]
xpresent<-test2[,7]
xgroup<-test2[,9]
xadrug<-test2[,4]
xlower<-test2[,10]
xupper<-test2[,11]
xexposed_ipppi<-test2[,12]
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
egroup_ipppi<-as.factor(xexposed_ipppi+1)
event<-(xlower<=xaevent)*(xaevent<=xupper)
ggroup<-as.factor(xgender+1)


# Fit standard case series models

modall<-clogit(event~egroup+agroup+strata(xindiv)+egroup_ipppi+offset(logint))
summary(modall)


modall2<-clogit(event~egroup+agroup+strata(xindiv)+egroup_ipppi*egroup+offset(logint))
summary(modall2)


#Primary analysis: set risk periods as follows: 1-14, 15-30, 31-60;
test2<-read.table(file="I:/PPIs & stroke/R dataset/sccs_ppistroke_neveripppi.txt",
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