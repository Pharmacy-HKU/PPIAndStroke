/*Created on 3 Oct 2017

Purpose: doing the case-crossover analysis to validate the findings of SCCS
to investigate the association between PPIs and stroke

case period: control period = 1:1
case patient: control patient = 1:1

Updated on 13 Jan 2018: update the strataid
*/

libname st "C:\Users\Angel YS Wong\Desktop\PPIs & stroke";
libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname an "C:\Users\Angel YS Wong\Desktop\PPI\program\drug";
libname lc "C:\Users\Angel YS Wong\Desktop\PPI\program\lc";
libname cc "C:\Users\Angel YS Wong\Desktop\PPIs & stroke\CCO";


*cut case period;
proc sort data=st.ppi_stroke_coh1_adult out=cc.stroke_case;
by reference_key;
run; *10958;
data cc.stroke_case;
set cc.stroke_case;
case_st=eventd-60+1;
case_en=eventd;
rw=1;
format case_st case_en yymmdd10.;
run;

*cut as many as control periods that currently available within valid ob period
According to "SHOULD WE USE A CASE-CROSSOVER DESIGN M.Maclure 2000 suggested >100 controls reduced CI further by 40%;
proc sort data=st.ppi_stroke_coh1_adult out=stroke_control;
by reference_key;
run; *10958;
%macro ctrl;
%do i=1 %to 1;
data stroke_control_&i.;
set stroke_control;
ctrl_st=eventd-60*&i.-60+1;
ctrl_en=eventd-60*&i.;
rw=0;
format ctrl_st ctrl_en yymmdd10.;%end;
run;
%mend;
%ctrl;
data cc.stroke_ctrl;
set stroke_control_:;run; *10958;
proc sort data=cc.stroke_ctrl;
by reference_key ctrl_st;run;
data cc.stroke_allrw;
set cc.stroke_ctrl cc.stroke_case;
if ~missing(ctrl_st) then cc_pst=ctrl_st;
if ~missing(ctrl_en) then cc_pen=ctrl_en;
if ~missing(case_st) then cc_pst=case_st;
if ~missing(case_en) then cc_pen=case_en;
format cc_pst cc_pen yymmdd10.;run; *21916;

*remove rw that are outside study period;
data cc.stroke_allrw;
set cc.stroke_allrw;
if cc_pst>st_en or cc_pen<st_st then delete;run; *21775;
data a;
set cc.stroke_allrw;
if cc_pen>st_en;run; *0;
data cc.stroke_allrw;
set cc.stroke_allrw;
if cc_pst<st_st then cc_pst=st_st;run; 

*set Exp variable;
data cc.stroke_allrw;
set cc.stroke_allrw;
if cc_pst<=ppirxst<=cc_pen or cc_pst<=ppirxen<=cc_pen or ppirxst<=cc_pst<=ppirxen or ppirxst<=cc_pen<=ppirxen then exp=1;
else exp=0;run; *21775;
data cc.stroke_allrw;
set cc.stroke_allrw;
if rw=1 then s=1;
else s=2;
time=cc_pen-cc_pst+1;run;

*check how many people included;
data a;
set cc.stroke_allrw;
if exp=1 and rw=1;run; *792;
data aa;
set cc.stroke_allrw;
if exp=1 and rw=0;run; *695, after remove duplicate is  ppl;
data b;
set a aa;run;
proc sort data=b nodupkey;
by reference_key;run;

proc sort data=cc.stroke_allrw;
by reference_key decending exp;
run;
proc sort data=cc.stroke_allrw nodupkey;
by reference_key cc_pst;run;

*remove those never exposed before the event;
proc sql;
create table stroke_allrw as
select * from cc.stroke_allrw where reference_key in (select reference_key from b);
quit; *1805;

*check who is not discordant pairs in those periods;
proc sql;
create table not_discordant as
select * from a where reference_key in (select reference_key from aa);
quit; *582;

*remove those not discordant pairs;
proc sql;
create table cc.stroke_allrw2 as
select * from stroke_allrw where reference_key not in (select reference_key from not_discordant);
quit; *641;

*updated on 24 Nov 2017;
*remove patients who dont have any control period;
proc sql;
create table no_control_period as
select *, count(*) as count_entry from cc.stroke_allrw2 group by reference_key;
quit;
data no_control_period;
set no_control_period;
if count_entry=1;
run;
proc sql;
create table cc.stroke_allrw3 as
select * from cc.stroke_allrw2 where reference_key not in (select reference_key from no_control_period);
quit; *638;

*calculate median age and sex;
proc sort data=cc.stroke_allrw3 nodupkey out=stroke_hc;
by reference_key;run;
data stroke_hc;
set stroke_hc;
age=(eventd-dob)/365.25;run;
proc univariate data=stroke_hc;
var age;run;
proc freq data=stroke_hc;
table sex;run;

*Perfom conditional logistic regression;
proc phreg data=cc.stroke_allrw3;
     model s*rw(0)=exp/ risklimits ties=breslow;
     strata reference_key;
	ods output ContrastEstimate=result;
     run;
*Result:  (, );

proc phreg data=cc.stroke_allrw3;
     model time*rw(0)=exp/ risklimits ties=breslow;
     strata reference_key;
	ods output ContrastEstimate=result;
     run;
*Result:  (, );

PROC LOGISTIC data = cc.stroke_allrw3;
model rw  (EVENT='1')= exp;
strata reference_key;
run; 
*Result: (, );

proc sort data=cc.stroke_allrw3 nodupkey out=hc;
by reference_key;run; *319;

data stroke_allrw3;
set cc.stroke_allrw3;
keep reference_key rw cc_pst cc_pen exp time;
run;
*upload the dataset of cc.stroke_allrw2 before matching;
PROC EXPORT DATA= stroke_allrw3
            OUTFILE= "W:\Angel\PPIs and stroke\cross-check\Jesse\CCTC\Angel_dataset_cctc_beforematch.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;
/*find control patients from the case patients
set permissible lag time between the outcome event for the current case and the outcome event for a matched future-case control as 120 days*/
data ppi_stroke_coh1_adult;
set st.ppi_stroke_coh1_adult;
dob_year=year(dob);
if sex='F' then gender=0;
if sex='M' then gender=1;
st_en=eventd;
keep reference_key dob_year gender st_st st_en eventd ppirxst ppirxen; 
run;
proc sort data=ppi_stroke_coh1_adult nodupkey out=stroke_ctrl_in_case;
by reference_key;
run; *8974;
proc sort data=ppi_stroke_coh1_adult nodupkey out=stroke_case;
by reference_key;
run; *8974;
/*only match those in final analysis of case-crossover*/
proc sql;
create table stroke_case_final as
select * from stroke_case where reference_key in (select reference_key from cc.stroke_allrw3);
quit; *319;

proc sort data=stroke_ctrl_in_case; by reference_key;run;
proc sort data=stroke_case_final; by reference_key;run;
data stroke_ctrl_in_case;
set stroke_ctrl_in_case;
 call streaminit(123456789); *keep the sequence from the rand seed;
    rand = rand("Uniform"); output;run;
proc sort data=stroke_ctrl_in_case; by rand;
run;
proc printto log="C:\Users\Angel YS Wong\Desktop\PPIs & stroke\match.log";
run;
%macro matches(dataf=,datal=,outdata=);
%if %sysfunc(exist(&outdata)) %then %do;
proc datasets;
delete &outdata;
Run;
%end;
/* Determine the number of observations in the case data set. */
data _null_;
dsid=open("&dataf",'i');
nobs=attrn(dsid,'nobs');
call symput('nobs',nobs);
Run;
data datalast;
set &datal;
Run;
%put nobs = &nobs;
%do n=1 %to &nobs;
/* Determine the number of observations in the control data
set. */
data _null_;
dsid=open("datalast",'i');
nobs=attrn(dsid,'nobs');
call symput('conobs',nobs);
Run;
%let mmatch=1;
data matches1;
choose=&n;
set &dataf point=choose;
output;
stop;
Run;
/* The match indicator variable is set to zero, the
variables in the control data set are renamed, and the
matching criteria is coded. */
data matches1;
set matches1;
i=1;
match=0;
do until(match=1);
/* Set the control data set and rename the variables*/
set datalast(rename=(reference_key=reference_key_ctrl
dob_year=dob_year_ctrl
gender=gender_ctrl
st_st=stst_ctrl
st_en=sten_ctrl)
) point=i;
/* If the control matches the case, set match=1 to allow
for this matched control to be appended to the match
data set and deleted from the control data set. */
if reference_key~=reference_key_ctrl and dob_year=dob_year_ctrl and gender=gender_ctrl and stst_ctrl<=st_en<=sten_ctrl and sten_ctrl-st_en>=120 then do;
match=1;
call symput("matchn",i);
output;
end;
/* If the control does not match the case and all controls
have been examined as potential matches, set match=1 to
exit the do loop. */
if match=0 and i=&conobs then do;
call symput("mmatch",match);
match=1;
end;
/* If the control does not match the case and all controls
have not been examined, set match=0 and go to the next
control. */
if match=0 then i=i+1;
end;
stop;
Run;
/* Append the matches to the matched data set and deleted
the matched control from the control data set. */
%if &mmatch=1 %then %do;
proc append base=&outdata data=matches1 force;
Run;
data datalast;
set datalast;
if _n_=&matchn then delete;
Run;
%end;
%end;
proc print data=&outdata;
title 'Matched Data Set';
Run;
%mend;
%matches(dataf=stroke_case_final,datal=stroke_ctrl_in_case,outdata=cc.match_cohort);
/*305 matches*/
PROC PRINTTO PRINT=PRINT LOG=LOG ;
RUN;
*check matches;
data a;
set cc.match_cohort;
if sten_ctrl-st_en<60;
run; *0;
data a;
set cc.match_cohort;
if stst_ctrl<=st_en<=sten_ctrl;
run; *305, all;

/*export match cohort*/
PROC EXPORT DATA= cc.match_cohort
            OUTFILE= "W:\Angel\PPIs and stroke\cross-check\final_datasets\match_cohort.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;

/*Chop case and control periods for control patients*/
proc sql;
create table ppi_stroke_control as
select * from ppi_stroke_coh1_adult where reference_key in (Select reference_key_ctrl from cc.match_cohort);
quit; *360;
proc sql;
create table ppi_stroke_control2 as
select * from ppi_stroke_control A left join (select st_en as st_en_match from cc.match_cohort B)
on A.reference_key=B.reference_key_ctrl;
quit; *360;
data ppi_stroke_control2_case;
set ppi_stroke_control2;
case_st=st_en_match-60+1;
case_en=st_en_match;
rw=1;
format case_st case_en yymmdd10.;
run;

*cut as many as control periods that currently available within valid ob period
According to "SHOULD WE USE A CASE-CROSSOVER DESIGN M.Maclure 2000 suggested >100 controls reduced CI further by 40%;
proc sort data=ppi_stroke_control2 out=ppi_stroke_control2_ctrl;
by reference_key;
run; *360;
%macro ctrl;
%do i=1 %to 1;
data ppi_stroke_control2_ctrl_&i.;
set ppi_stroke_control2_ctrl;
ctrl_st=st_en_match-60*&i.-60+1;
ctrl_en=st_en_match-60*&i.;
rw=0;
format ctrl_st ctrl_en yymmdd10.;%end;
run;
%mend;
%ctrl;
data stroke_ctrl;
set ppi_stroke_control2_ctrl_:;run; *;
proc sort data=stroke_ctrl;
by reference_key ctrl_st;run;
data stroke_allrw;
set stroke_ctrl ppi_stroke_control2_case;
if ~missing(ctrl_st) then cc_pst=ctrl_st;
if ~missing(ctrl_en) then cc_pen=ctrl_en;
if ~missing(case_st) then cc_pst=case_st;
if ~missing(case_en) then cc_pen=case_en;
format cc_pst cc_pen yymmdd10.;run; *;
proc sort data=stroke_allrw;
by reference_key decending cc_pst decending cc_pen;
run;

*remove rw that are outside study period;
data stroke_allrw;
set stroke_allrw;
if cc_pst>st_en_match or cc_pen<st_st then delete;run; *720;
data a;
set stroke_allrw;
if cc_pen>st_en_match;run; *0;
data stroke_allrw;
set stroke_allrw;
if cc_pst<st_st then cc_pst=st_st;run; 

*set exposure variable;
data stroke_allrw;
set stroke_allrw;
if cc_pst<=ppirxst<=cc_pen or cc_pst<=ppirxen<=cc_pen or ppirxst<=cc_pst<=ppirxen or ppirxst<=cc_pen<=ppirxen then exp=1;
else exp=0;run; *;
data stroke_allrw_ctrl;
set stroke_allrw;
if rw=1 then s=1;
else s=2;
time=cc_pen-cc_pst+1;
case=0;run;

proc sort data=stroke_allrw_ctrl;
by reference_key decending exp;
run;
proc sort data=stroke_allrw_ctrl nodupkey;
by reference_key cc_pst;run; *610;

/*set case variable as 1 for case patients from case-crossover dataset*/
data stroke_allrw2;
set cc.stroke_allrw2;
case=1;
run;

*remove cases without matches;
proc sql;
create table stroke_allrw2_match as
select * from stroke_allrw2 where reference_key in (select reference_key from cc.match_cohort);
quit; *610;

data cc.ctc;
set stroke_allrw2_match stroke_allrw_ctrl;
run; *1220;

*updated on 13 Jan 2018
assign another id for the control patients as it would overlap with their previous id when they are the case patient;
proc sort data=cc.ctc;
by decending reference_key;
run;
data cc.ctc;
set cc.ctc;
if case=0 then matchid=reference_key+9004099;
if case=1 then matchid=reference_key;
run;
data ctc;
set cc.ctc;
keep Reference_Key case rw exp matchid;
run;
PROC EXPORT DATA= ctc
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPIs & stroke\R dataset\ctc.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;
*num of case patients;
data case;
set cc.ctc;
if case=1;run;
proc sort data=case nodupkey;
by reference_key;run; *305;

*num of control patients;
data ctrl;
set cc.ctc;
if case=0;run;
proc sort data=ctrl nodupkey;
by reference_key;run; *305;
/*In R:

Call:
coxph(formula = Surv(rep(1, 1220L), rw) ~ factor(exp) + factor(exp) * 
    factor(case) + strata(matchid), method = "exact")

  n= 1220, number of events= 610 

                              coef exp(coef) se(coef)      z Pr(>|z|)
factor(exp)1               -0.4055    0.6667   0.9129 -0.444    0.657
factor(case)1                   NA        NA   0.0000     NA       NA
factor(exp)1:factor(case)1  0.9922    2.6972   0.9207  1.078    0.281

                           exp(coef) exp(-coef) lower .95 upper .95
factor(exp)1                  0.6667     1.5000    0.1114      3.99
factor(case)1                     NA         NA        NA        NA
factor(exp)1:factor(case)1    2.6972     0.3707    0.4439     16.39

Rsquare= 0.021   (max possible= 0.5 )
Likelihood ratio test= 25.37  on 2 df,   p=3.104e-06
Wald test            = 24.31  on 2 df,   p=5.252e-06
Score (logrank) test = 25.02  on 2 df,   p=3.696e-06;
