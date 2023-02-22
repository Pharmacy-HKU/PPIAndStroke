#Primary analysis: set risk periods as follows: -365-0, 1-14, 15-30, 31-60;
test2<-read.table(file="I:/PPIs & stroke/R dataset/sccs_ppistroke_allrx_prerisk1y.txt",
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
epresent<-as.factor(xpresent+1)
event<-(xlower<=xaevent)*(xaevent<=xupper)
ggroup<-as.factor(xgender+1)


# Fit standard case series models

modall<-clogit(event~egroup+agroup+strata(xindiv)+offset(logint))
summary(modall)
modall$loglik[2]

#          exp(coef) exp(-coef) lower .95 upper .95
#egroup2   1.664e+00  6.008e-01    1.5757     1.758
#egroup3   1.326e+00  7.542e-01    1.0369     1.696
#egroup4   1.029e+00  9.716e-01    0.7861     1.348
#egroup5   1.022e+00  9.784e-01    0.8314     1.257

#add interaction term with censoring reason
modall_censor<-clogit(event~egroup+agroup+egroup*epresent+strata(xindiv)+offset(logint))
summary(modall_censor)
modall_censor$loglik[2]

#                   (coef) exp(-coef) lower .95 upper .95
#egroup2           2.006e+00  4.986e-01   1.84682    2.1784
#egroup3           1.908e-01  5.242e+00   0.06147    0.5921
#egroup4           2.255e-01  4.434e+00   0.08455    0.6015
#egroup5           4.301e-01  2.325e+00   0.25420    0.7276
#egroup2:epresent2 7.682e-01  1.302e+00   0.68797    0.8577
#egroup3:epresent2 1.057e+01  9.464e-02   3.30329   33.8026
#egroup4:epresent2 5.490e+00  1.822e-01   1.94973   15.4563
#egroup5:epresent2 3.313e+00  3.018e-01   1.85810    5.9075
#egroup2:epresent3 5.789e-01  1.728e+00   0.46840    0.7154
#egroup3:epresent3 4.942e+00  2.023e-01   1.17468   20.7951
#egroup4:epresent3 1.066e+01  9.385e-02   3.48300   32.6003
#egroup5:epresent3 2.256e+00  4.433e-01   0.99331    5.1232

#Primary analysis: pre-risk 1 year, day 1-14, 15-30, 31-60 with adjustment of anticoagulants etc
test2<-read.table(file="I:/PPIs & stroke/R dataset/sccs_ppistroke_main_anticoag_prerisk1y.txt",
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

#         exp(coef) exp(-coef) lower .95 upper .95
#egroup2    1.705e+00  5.864e-01    1.6139    1.8021
#egroup3    1.394e+00  7.174e-01    1.0898    1.7832
#egroup4    1.080e+00  9.260e-01    0.8246    1.4144
#egroup5    1.069e+00  9.356e-01    0.8691    1.3145
#egroup_aa2 5.401e-01  1.852e+00    0.5039    0.5788

#After putting interaction

modall_int<-clogit(event~egroup+agroup+strata(xindiv)+egroup_aa+egroup*egroup_aa+offset(logint))
summary(modall_int)

#exp(coef) exp(-coef) lower .95 upper .95
#egroup2            2.295e+00  4.358e-01    2.1345    2.4667
#egroup3            1.537e+00  6.504e-01    1.0277    2.2999
#egroup4            1.575e+00  6.348e-01    1.0761    2.3061
#egroup5            1.470e+00  6.801e-01    1.0925    1.9789
#egroup_aa2         6.530e-01  1.531e+00    0.6054    0.7044
#egroup2:egroup_aa2 5.181e-01  1.930e+00    0.4638    0.5787
#egroup3:egroup_aa2 8.039e-01  1.244e+00    0.4832    1.3373
#egroup4:egroup_aa2 4.882e-01  2.048e+00    0.2847    0.8372
#egroup5:egroup_aa2 5.423e-01  1.844e+00    0.3585    0.8204

#sensitivity analysis 1: set pre-risk 1 year, during Rx, post 1-30 days, post 31-60 days
test2<-read.table(file="I:/PPIs & stroke/R dataset/sen1_primary_risk_final_prerisk1y.txt",
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

#          exp(coef) exp(-coef)  lower .95  upper .95
#egroup2   1.639e+00  6.103e-01  1.551e+00  1.731e+00
#egroup3   8.735e-01  1.145e+00  7.929e-01  9.624e-01
#egroup4   1.324e+00  7.551e-01  1.039e+00  1.688e+00
#egroup5   1.268e+00  7.889e-01  9.835e-01  1.634e+00

#sensitivity analysis 2: set pre-risk 1 year, during Rx, post 1-30 days, post 31-60 days with adjustment of anticoagulants etc
test2<-read.table(file="I:/PPIs & stroke/R dataset/sen2_primary_risk_final_prerisk1y.txt",
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
#egroup2    1.679e+00  5.956e-01    1.5888    1.7741
#egroup3    9.493e-01  1.053e+00    0.8610    1.0466
#egroup4    1.340e+00  7.465e-01    1.0509    1.7073
#egroup5    1.286e+00  7.776e-01    0.9976    1.6578
#egroup_aa2 5.542e-01  1.804e+00    0.5179    0.5931

# after adding the interaction term:

modall_int<-clogit(event~egroup+agroup+strata(xindiv)+egroup_aa+egroup*egroup_aa+offset(logint))
summary(modall_int)

#                   exp(coef) exp(-coef) lower .95 upper .95
#egroup2            2.195e+00  4.555e-01    2.0428    2.3596
#egroup3            1.502e+00  6.657e-01    1.2685    1.7788
#egroup4            1.503e+00  6.654e-01    1.0974    2.0584
#egroup5            1.308e+00  7.646e-01    0.9260    1.8473
#egroup_aa2         6.764e-01  1.478e+00    0.6274    0.7293
#egroup2:egroup_aa2 5.470e-01  1.828e+00    0.4898    0.6109
#egroup3:egroup_aa2 4.903e-01  2.040e+00    0.4001    0.6007
#egroup4:egroup_aa2 7.812e-01  1.280e+00    0.4763    1.2815
#egroup5:egroup_aa2 9.800e-01  1.020e+00    0.5884    1.6320
