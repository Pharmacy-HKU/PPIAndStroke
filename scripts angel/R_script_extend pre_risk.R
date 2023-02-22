#Primary analysis: set risk periods as follows: -60-0, 1-14, 15-30, 31-60;
test2<-read.table(file="I:/PPIs & stroke/R dataset/sccs_ppistroke_allrx_prerisk60.txt",
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
#egroup2   2.036e+00  4.911e-01    1.8595     2.230
#egroup3   1.094e+00  9.140e-01    0.8575     1.396
#egroup4   8.827e-01  1.133e+00    0.6792     1.147
#egroup5   8.512e-01  1.175e+00    0.6941     1.044

#add interaction term with censoring reason
modall_censor<-clogit(event~egroup+agroup+egroup*epresent+strata(xindiv)+offset(logint))
summary(modall_censor)
modall_censor$loglik[2]

#                   exp(coef) exp(-coef)  lower .95  upper .95
#egroup2           2.473e+00  4.043e-01  2.145e+00  2.851e+00
#egroup3           1.503e-01  6.655e+00  4.842e-02  4.663e-01
#egroup4           2.673e-01  3.741e+00  1.199e-01  5.957e-01
#egroup5           3.665e-01  2.729e+00  2.205e-01  6.092e-01
#egroup2:epresent2 7.553e-01  1.324e+00  6.261e-01  9.113e-01
#egroup3:epresent2 1.120e+01  8.927e-02  3.504e+00  3.581e+01
#egroup4:epresent2 3.893e+00  2.569e-01  1.639e+00  9.245e+00
#egroup5:epresent2 3.226e+00  3.099e-01  1.841e+00  5.655e+00
#egroup2:epresent3 6.431e-01  1.555e+00  4.485e-01  9.223e-01
#egroup3:epresent3 5.813e+00  1.720e-01  1.383e+00  2.444e+01
#egroup4:epresent3 8.316e+00  1.202e-01  3.174e+00  2.179e+01
#egroup5:epresent3 2.450e+00  4.081e-01  1.092e+00  5.497e+00

#Primary analysis: day 1-14, 15-30, 31-60 with adjustment of anticoagulants etc
test2<-read.table(file="I:/PPIs & stroke/R dataset/sccs_ppistroke_main_anticoag_prerisk60.txt",
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

#           exp(coef) exp(-coef) lower .95 upper .95
#egroup2    2.061e+00  4.851e-01    1.8814    2.2585
#egroup3    1.137e+00  8.792e-01    0.8912    1.4515
#egroup4    9.154e-01  1.092e+00    0.7042    1.1900
#egroup5    8.802e-01  1.136e+00    0.7175    1.0797
#egroup_aa2 5.540e-01  1.805e+00    0.5169    0.5938

#After putting interaction

modall_int<-clogit(event~egroup+agroup+strata(xindiv)+egroup_aa+egroup*egroup_aa+offset(logint))
summary(modall_int)

#                    exp(coef) exp(-coef) lower .95 upper .95
#egroup2            3.431e+00  2.914e-01 3.060e+00 3.847e+00
#egroup3            1.170e+00  8.546e-01 7.805e-01 1.754e+00
#egroup4            1.244e+00  8.039e-01 8.536e-01 1.813e+00
#egroup5            1.132e+00  8.833e-01 8.399e-01 1.526e+00
#egroup_aa2         5.945e-01  1.682e+00 5.535e-01 6.385e-01
#egroup2:egroup_aa2 4.098e-01  2.440e+00 3.418e-01 4.914e-01
#egroup3:egroup_aa2 9.502e-01  1.052e+00 5.716e-01 1.580e+00
#egroup4:egroup_aa2 5.816e-01  1.719e+00 3.434e-01 9.848e-01
#egroup5:egroup_aa2 6.427e-01  1.556e+00 4.262e-01 9.690e-01


#sensitivity analysis 1: set pre-risk 60 days, during Rx, post 1-30 days, post 31-60 days
test2<-read.table(file="I:/PPIs & stroke/R dataset/sen1_primary_risk_final_prerisk60.txt",
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

#           exp(coef) exp(-coef)  lower .95  upper .95
#egroup2   1.965e+00  5.089e-01  1.794e+00  2.152e+00
#egroup3   7.097e-01  1.409e+00  6.454e-01  7.804e-01
#egroup4   1.094e+00  9.142e-01  8.644e-01  1.384e+00
#egroup5   1.040e+00  9.615e-01  8.087e-01  1.337e+00

#sensitivity analysis 2: set pre-risk 60 days, during Rx, post 1-30 days, post 31-60 days with adjustment of anticoagulants etc
test2<-read.table(file="I:/PPIs & stroke/R dataset/sen2_primary_risk_final_prerisk60.txt",
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
#egroup2    2.028e+00  4.930e-01    1.8514    2.2219
#egroup3    7.671e-01  1.304e+00    0.6971    0.8441
#egroup4    1.097e+00  9.113e-01    0.8670    1.3889
#egroup5    1.047e+00  9.547e-01    0.8144    1.3472
#egroup_aa2 5.663e-01  1.766e+00    0.5292    0.6061

# after adding the interaction term:

modall_int<-clogit(event~egroup+agroup+strata(xindiv)+egroup_aa+egroup*egroup_aa+offset(logint))
summary(modall_int)

#                exp(coef) exp(-coef) lower .95 upper .95
#egroup2            2.838e+00  3.524e-01    2.5179    3.1988
#egroup3            1.104e+00  9.056e-01    0.9329    1.3072
#egroup4            1.136e+00  8.805e-01    0.8326    1.5490
#egroup5            1.007e+00  9.935e-01    0.7129    1.4212
#egroup_aa2         6.155e-01  1.625e+00    0.5735    0.6605
#egroup2:egroup_aa2 4.978e-01  2.009e+00    0.4138    0.5989
#egroup3:egroup_aa2 5.919e-01  1.689e+00    0.4839    0.7240
#egroup4:egroup_aa2 9.484e-01  1.054e+00    0.5886    1.5281
#egroup5:egroup_aa2 1.115e+00  8.967e-01    0.6733    1.8472