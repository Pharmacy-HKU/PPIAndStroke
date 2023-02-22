/*Created on 16 Jun 2016 

Updated on 9 Oct 2017
changed the stratumid for CTC analysis
See: https://github.com/OHDSI/CaseCrossover/commit/0fbf8b34c1c7edf09a35fc197927a3255f45075b#diff-4d252d3e951940f44518f83ef8ff313fL35

Purpose: To perform case-crossover study and case-time-control study (crude estimate)

****
Risk windows:
rw1=1-14 day before index date (control periods after risk window 3 (14 days each)
rw2=15-30 day before index date (control periods after risk window 3 (16 days each)
rw3=31-60 day before index date (control periods after risk window 3 (30 days each)
****

*/
libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname an "C:\Users\Angel YS Wong\Desktop\PPI\program\drug";
libname lc "C:\Users\Angel YS Wong\Desktop\PPI\program\lc";
libname m "C:\Users\Angel YS Wong\Desktop\PPI\program\CTC";

*cut case period;
proc sort data=p.ppi_mi_coh1_adult out=p.ppi_case;
by reference_key;
run; *1639;
data p.ppi_case;
set p.ppi_case;
case_st=eventd-14+1;
case_en=eventd;
rw=1;
format case_st case_en yymmdd10.;
run;
data p.ppi_case2;
set p.ppi_case;
case_st=eventd-30+1;
case_en=eventd-14;
rw=2;
format case_st case_en yymmdd10.;
run;
data p.ppi_case3;
set p.ppi_case;
case_st=eventd-60+1;
case_en=eventd-30;
rw=3;
format case_st case_en yymmdd10.;
run;
*cut as many as control periods that currently available within valid ob period
According to "SHOULD WE USE A CASE-CROSSOVER DESIGN M.Maclure 2000 suggested >100 controls reduced CI further by 40%;
/*controls for risk window 1*/
proc sort data=p.ppi_mi_coh1_adult out=ppi_control;
by reference_key;
run; *1639;
data ppi_control;
set ppi_control;
contrl=eventd-60+14;
format contrl yymmdd10.;run;
%macro ctrl;
%do i=1 %to 100;
data ppi_control_&i.;
set ppi_control;
ctrl_st=contrl-14*&i.-14+1;
ctrl_en=contrl-14*&i.;
rw=0;
format ctrl_st ctrl_en yymmdd10.;%end;
run;
%mend;
%ctrl;
data p.ppi_control1;
set ppi_control_:;run; *163900;
proc sort data=p.ppi_control1;
by reference_key ctrl_st;run;
data p.ppi_allrw1;
set p.ppi_control1 p.ppi_case;
if ~missing(ctrl_st) then cc_pst=ctrl_st;
if ~missing(ctrl_en) then cc_pen=ctrl_en;
if ~missing(case_st) then cc_pst=case_st;
if ~missing(case_en) then cc_pen=case_en;
format cc_pst cc_pen yymmdd10.;run; *165539;
/*controls for risk window 2*/
proc sort data=p.ppi_mi_coh1_adult out=ppi_control;
by reference_key;
run; *1639;
data ppi_control;
set ppi_control;
contrl=eventd-60+16;
format contrl yymmdd10.;run;
%macro ctrl;
%do i=1 %to 100;
data ppi_control_&i.;
set ppi_control;
ctrl_st=contrl-16*&i.-16+1;
ctrl_en=contrl-16*&i.;
rw=0;
format ctrl_st ctrl_en yymmdd10.;%end;%end;
run;
%mend;
%ctrl;
data p.ppi_control2;
set ppi_control_:;run; *163900;
proc sort data=p.ppi_control2;
by reference_key decending ctrl_st;run;
data p.ppi_allrw2;
set p.ppi_control2 p.ppi_case2;
if ~missing(ctrl_st) then cc_pst=ctrl_st;
if ~missing(ctrl_en) then cc_pen=ctrl_en;
if ~missing(case_st) then cc_pst=case_st;
if ~missing(case_en) then cc_pen=case_en;
format cc_pst cc_pen yymmdd10.;run; *165539;

/*controls for risk window 3*/
proc sort data=p.ppi_mi_coh1_adult out=ppi_control;
by reference_key;
run; *1639;
data ppi_control;
set ppi_control;
contrl=eventd-60+30;
format contrl yymmdd10.;run;
%macro ctrl;
%do i=1 %to 100;
data ppi_control_&i.;
set ppi_control;
ctrl_st=contrl-30*&i.-30+1;
ctrl_en=contrl-30*&i.;
rw=0;
format ctrl_st ctrl_en yymmdd10.;%end;%end;
run;
%mend;
%ctrl;
data p.ppi_control3;
set ppi_control_:;run; *163900;
proc sort data=p.ppi_control3;
by reference_key decending ctrl_st;run;
data p.ppi_allrw3;
set p.ppi_control3 p.ppi_case3;
if ~missing(ctrl_st) then cc_pst=ctrl_st;
if ~missing(ctrl_en) then cc_pen=ctrl_en;
if ~missing(case_st) then cc_pst=case_st;
if ~missing(case_en) then cc_pen=case_en;
format cc_pst cc_pen yymmdd10.;run; *165539;

* change study end date as event date;
%macro chg;
%do i=1 %to 3; 
data p.ppi_allrw&i.;
set p.ppi_allrw&i.;
if st_en>eventd then st_en=eventd;
run;
%end;
%mend;
%chg;
* remove rw then outside study period;
%macro rw;
%do i=1 %to 3; 
data p.ppi_allrw&i.;
set p.ppi_allrw&i.;
if cc_pst>st_en or cc_pen<st_st then delete;
run; *, ;
data a;
set p.ppi_allrw&i.;
if cc_pen>st_en;run; *0, 0;
data p.ppi_allrw&i.;
set p.ppi_allrw&i.;
if cc_pst<st_st then cc_pst=st_st;run; 
%end;
%mend;
%rw;
proc sort data=p.ppi_allrw1;
by reference_key decending cc_pst;run;
proc sort data=p.ppi_allrw2;
by reference_key decending cc_pst;run;
proc sort data=p.ppi_allrw3;
by reference_key decending cc_pst;run;
*set Exp variable;
%macro rw;
%do i=1 %to 3; 
data p.ppi_allrw&i.;
set p.ppi_allrw&i.;
if cc_pst<=ppirxst<=cc_pen or cc_pst<=ppirxen<=cc_pen or ppirxst<=cc_pst<=ppirxen or ppirxst<=cc_pen<=ppirxen then exp=1;
else exp=0;run; *, ;
%end;
%mend;
%rw;
* check how many people included;
data rw1_cap;
set p.ppi_allrw1;
if exp=1 and rw=1;run; *127;
data rw1_cop;
set p.ppi_allrw1;
if exp=1 and rw=0;run; *1153 , after remove duplicate is ppl;
data rw1_dup;
set rw1_cap rw1_cop;run;
proc sort data=rw1_dup nodupkey;
by reference_key;run; *512;

data rw2_cap;
set p.ppi_allrw2;
if exp=1 and rw=2;run; *83;
data rw2_cop;
set p.ppi_allrw2;
if exp=1 and rw=0;run; *1168;
data rw2_dup;
set rw2_cap rw2_cop;run;
proc sort data=rw2_dup nodupkey;
by reference_key;run; *512;

data rw3_cap;
set p.ppi_allrw3;
if exp=1 and rw=3;run; *74;
data rw3_cop;
set p.ppi_allrw3;
if exp=1 and rw=0;run; *1171;
data rw3_dup;
set rw3_cap rw3_cop;run;
proc sort data=rw3_dup nodupkey;
by reference_key;run; *680;

proc sort data=p.ppi_allrw1;
by reference_key decending exp;
run;
proc sort data=p.ppi_allrw1 nodupkey;
by reference_key cc_pst;run;
proc sort data=p.ppi_allrw2;
by reference_key decending exp;
run;
proc sort data=p.ppi_allrw2 nodupkey;
by reference_key cc_pst;run;
proc sort data=p.ppi_allrw3;
by reference_key decending exp;
run;
proc sort data=p.ppi_allrw3 nodupkey;
by reference_key cc_pst;run;
* remove those did not expose before event;
proc sql;
create table p.ppi_allrw1 as
select * from p.ppi_allrw1 where reference_key in (select reference_key from rw1_dup);
quit; *48327;
proc sql;
create table p.ppi_allrw2 as
select * from p.ppi_allrw2 where reference_key in (select reference_key from rw2_dup);
quit; *47970;
proc sql;
create table p.ppi_allrw3 as
select * from p.ppi_allrw3 where reference_key in (select reference_key from rw3_dup);
quit; *57578;
*check who is not discordant pairs in those periods;
proc sql;
create table not_disc1 as
select * from rw1_cap where reference_key in (select reference_key from rw1_cop);
quit; *28;
proc sql;
create table not_disc2 as
select * from rw2_cap where reference_key in (select reference_key from rw2_cop);
quit; *26;
proc sql;
create table not_disc3 as
select * from rw3_cap where reference_key in (select reference_key from rw3_cop);
quit; *34;

proc sql;
create table p.ppi_allrw1_v2 as
select * from p.ppi_allrw1 where reference_key not in (select reference_key from not_disc1);
quit; *45600;
proc sql;
create table p.ppi_allrw2_v2 as
select * from p.ppi_allrw2 where reference_key not in (select reference_key from not_disc2);
quit; *45448;
proc sql;
create table p.ppi_allrw3_v2 as
select * from p.ppi_allrw3 where reference_key not in (select reference_key from not_disc3);
quit; *54927;

proc sort data=p.ppi_allrw1_v2 nodupkey out=a;
by reference_key;
run;
proc sort data=p.ppi_allrw2_v2 nodupkey out=a;
by reference_key;
run;
proc sort data=p.ppi_allrw3_v2 nodupkey out=a;
by reference_key;
run;
*calculate median age and sex;
data ppi_allrw;
set p.ppi_allrw1_v2 p.ppi_allrw2_v2 p.ppi_allrw3_v2;
run;
proc sort data=ppi_allrw nodupkey;
by reference_key;run; *727;
data ppi_allrw;
set ppi_allrw;
age=(eventd-dob)/365.25;run;
proc univariate data=ppi_allrw;
var age;run;
proc freq data=ppi_allrw;
table sex;run;

*Perfom conditional logistic regression;
PROC LOGISTIC data = p.ppi_allrw1_v2;
model rw  (EVENT='1')= exp;
strata reference_key;
run; 
*Odds Ratio Estimates 
Effect Point Estimate 95% Wald
Confidence Limits 
exp 11.124 8.808 14.048;

PROC LOGISTIC data = p.ppi_allrw2_v2;
model rw  (EVENT='2')= exp;
strata reference_key;
run; 
*Odds Ratio Estimates 
Effect Point Estimate 95% Wald
Confidence Limits 
exp 5.302 3.976 7.070;

PROC LOGISTIC data = p.ppi_allrw3_v2;
model rw  (EVENT='3')= exp;
strata reference_key;
run; 
*Odds Ratio Estimates 
Effect Point Estimate 95% Wald
Confidence Limits 
exp 2.670 1.920 3.713;
/******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
***************************CTC analysis***************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************/

*cut case period in controls;
proc sql;
create table ppi_control as
select * from m.ppi_shdur_o where reference_key in (select reference_key_ctrl from m.match_all);
quit; *3387;
proc sql;
create table ppi_control2 as
select * from ppi_control A left join (select eventd from m.match_all B)
on A.reference_key=B.reference_key_ctrl;
quit; *3387;

data m.ppi_ctrl_case;
set ppi_control2;
case_st=eventd-14+1;
case_en=eventd;
rw=1;
format case_st case_en yymmdd10.;
run;
data m.ppi_ctrl_case2;
set ppi_control2;
case_st=eventd-30+1;
case_en=eventd-14;
rw=2;
format case_st case_en yymmdd10.;
run;
data m.ppi_ctrl_case3;
set ppi_control2;
case_st=eventd-60+1;
case_en=eventd-30;
rw=3;
format case_st case_en yymmdd10.;
run;
*cut as many as control periods that currently available within valid ob period
According to "SHOULD WE USE A CASE-CROSSOVER DESIGN M.Maclure 2000 suggested >100 controls reduced CI further by 40%;
/*controls for risk window 1*/
data ppi_ctrl_ctrl;
set ppi_control2;
contrl=eventd-60+14;
format contrl yymmdd10.;run;
%macro ctrl;
%do i=1 %to 100;
data ppi_ctrl_ctrl_&i.;
set ppi_ctrl_ctrl;
ctrl_st=contrl-14*&i.-14+1;
ctrl_en=contrl-14*&i.;
rw=0;
format ctrl_st ctrl_en yymmdd10.;%end;%end;
run;
%mend;
%ctrl;
data m.ppi_control1;
set ppi_ctrl_ctrl_:;run; *338700;
proc sort data=m.ppi_control1;
by reference_key ctrl_st;run;
data m.ppi_allrw1;
set m.ppi_control1 m.ppi_ctrl_case;
if ~missing(ctrl_st) then cc_pst=ctrl_st;
if ~missing(ctrl_en) then cc_pen=ctrl_en;
if ~missing(case_st) then cc_pst=case_st;
if ~missing(case_en) then cc_pen=case_en;
format cc_pst cc_pen yymmdd10.;run; *342087;
/*controls for risk window 2*/
data ppi_ctrl_ctrl2;
set ppi_control2;
contrl=eventd-60+16;
format contrl yymmdd10.;run;
%macro ctrl;
%do i=1 %to 100;
data ppi_ctrl_ctrl2_&i.;
set ppi_ctrl_ctrl2;
ctrl_st=contrl-16*&i.-16+1;
ctrl_en=contrl-16*&i.;
rw=0;
format ctrl_st ctrl_en yymmdd10.;%end;%end;
run;
%mend;
%ctrl;
data m.ppi_control2;
set ppi_ctrl_ctrl2_:;run; *338700;
proc sort data=m.ppi_control2;
by reference_key decending ctrl_st;run;
data m.ppi_allrw2;
set m.ppi_control2 m.ppi_ctrl_case2;
if ~missing(ctrl_st) then cc_pst=ctrl_st;
if ~missing(ctrl_en) then cc_pen=ctrl_en;
if ~missing(case_st) then cc_pst=case_st;
if ~missing(case_en) then cc_pen=case_en;
format cc_pst cc_pen yymmdd10.;run; *342087;
/*controls for risk window 3*/
data ppi_ctrl_ctrl3;
set ppi_control2;
contrl=eventd-60+30;
format contrl yymmdd10.;run;
%macro ctrl;
%do i=1 %to 100;
data ppi_ctrl_ctrl3_&i.;
set ppi_ctrl_ctrl3;
ctrl_st=contrl-30*&i.-30+1;
ctrl_en=contrl-30*&i.;
rw=0;
format ctrl_st ctrl_en yymmdd10.;%end;%end;
run;
%mend;
%ctrl;
data m.ppi_control3;
set ppi_ctrl_ctrl3_:;run; *338700;
proc sort data=m.ppi_control3;
by reference_key decending ctrl_st;run;
data m.ppi_allrw3;
set m.ppi_control3 m.ppi_ctrl_case3;
if ~missing(ctrl_st) then cc_pst=ctrl_st;
if ~missing(ctrl_en) then cc_pen=ctrl_en;
if ~missing(case_st) then cc_pst=case_st;
if ~missing(case_en) then cc_pen=case_en;
format cc_pst cc_pen yymmdd10.;run; *342087;
* change study end date as event date;
%macro chg;
%do i=1 %to 3; 
data m.ppi_allrw&i.;
set m.ppi_allrw&i.;
if st_en>eventd then st_en=eventd;
run;
%end;
%mend;
%chg;

* remove rw then outside study period;
%macro rw;
%do i=1 %to 3; 
data m.ppi_allrw&i.;
set m.ppi_allrw&i.;
if cc_pst>st_en or cc_pen<st_st then delete;
run; *, ;
data a;
set m.ppi_allrw&i.;
if cc_pen>st_en;run; *, ;
data m.ppi_allrw&i.;
set m.ppi_allrw&i.;
if cc_pst<st_st then cc_pst=st_st;run; 
%end;
%mend;
%rw;
proc sort data=m.ppi_allrw1;
by reference_key decending cc_pst;run;
proc sort data=m.ppi_allrw2;
by reference_key decending cc_pst;run;
proc sort data=m.ppi_allrw3;
by reference_key decending cc_pst;run;
*set Exp variable;
%macro rw;
%do i=1 %to 3; 
data m.ppi_allrw&i.;
set m.ppi_allrw&i.;
if cc_pst<=ppirxst<=cc_pen or cc_pst<=ppirxen<=cc_pen or ppirxst<=cc_pst<=ppirxen or ppirxst<=cc_pen<=ppirxen then exp=1;
else exp=0;run; *, ;
%end;
%mend;
%rw;
* check how many people included;
data rw1_cap;
set m.ppi_allrw1;
if exp=1 and rw=1;run; *85;
data rw1_cop;
set m.ppi_allrw1;
if exp=1 and rw=0;run; *3112 , after remove duplicate is ppl;
data rw1_dup;
set rw1_cap rw1_cop;run;
proc sort data=rw1_dup nodupkey;
by reference_key;run; *967;

data rw2_cap;
set m.ppi_allrw2;
if exp=1 and rw=2;run; *81;
data rw2_cop;
set m.ppi_allrw2;
if exp=1 and rw=0;run; *3113;
data rw2_dup;
set rw2_cap rw2_cop;run;
proc sort data=rw2_dup nodupkey;
by reference_key;run; *1050;

data rw3_cap;
set m.ppi_allrw3;
if exp=1 and rw=3;run; *93;
data rw3_cop;
set m.ppi_allrw3;
if exp=1 and rw=0;run; *3136;
data rw3_dup;
set rw3_cap rw3_cop;run;
proc sort data=rw3_dup nodupkey;
by reference_key;run; *1542;

proc sort data=m.ppi_allrw1;
by reference_key decending exp;
run;
proc sort data=m.ppi_allrw1 nodupkey;
by reference_key cc_pst;run;
proc sort data=m.ppi_allrw2;
by reference_key decending exp;
run;
proc sort data=m.ppi_allrw2 nodupkey;
by reference_key cc_pst;run;
proc sort data=m.ppi_allrw3;
by reference_key decending exp;
run;
proc sort data=m.ppi_allrw3 nodupkey;
by reference_key cc_pst;run;
* remove those did not expose before event;
proc sql;
create table m.ppi_allrw1 as
select * from m.ppi_allrw1 where reference_key in (select reference_key from rw1_dup);
quit; *93632;
proc sql;
create table m.ppi_allrw2 as
select * from m.ppi_allrw2 where reference_key in (select reference_key from rw2_dup);
quit; *101003;
proc sql;
create table m.ppi_allrw3 as
select * from m.ppi_allrw3 where reference_key in (select reference_key from rw3_dup);
quit; *137812;

*check who is not discordant pairs in those periods;
proc sql;
create table not_disc1 as
select * from rw1_cap where reference_key in (select reference_key from rw1_cop);
quit; *34;
proc sql;
create table not_disc2 as
select * from rw2_cap where reference_key in (select reference_key from rw2_cop);
quit; *36;
proc sql;
create table not_disc3 as
select * from rw3_cap where reference_key in (select reference_key from rw3_cop);
quit; *60;

proc sql;
create table m.ppi_allrw1_v2 as
select * from m.ppi_allrw1 where reference_key not in (select reference_key from not_disc1);
quit; *90431;
proc sql;
create table m.ppi_allrw2_v2 as
select * from m.ppi_allrw2 where reference_key not in (select reference_key from not_disc2);
quit; *97645;
proc sql;
create table m.ppi_allrw3_v2 as
select * from m.ppi_allrw3 where reference_key not in (select reference_key from not_disc3);
quit; *133122;

%macro rw;
%do i=1 %to 3; 
data p.ppi_allrw&i._v2;
set p.ppi_allrw&i._v2;
mi=1;
matchid=reference_key;
run;
%end;
%mend;
%rw;

proc sql;
create table m.ppi_allrw1_v2 as
select * from m.ppi_allrw1_v2 A left join (select reference_key as matchid from m.match_all B)
on A.reference_key=B.reference_key_ctrl;
quit;
proc sql;
create table m.ppi_allrw2_v2 as
select * from m.ppi_allrw2_v2 A left join (select reference_key as matchid from m.match_all B)
on A.reference_key=B.reference_key_ctrl;
quit;
proc sql;
create table m.ppi_allrw3_v2 as
select * from m.ppi_allrw3_v2 A left join (select reference_key as matchid from m.match_all B)
on A.reference_key=B.reference_key_ctrl;
quit;
%macro rw;
%do i=1 %to 3; 
data m.ppi_allrw&i._v2;
set m.ppi_allrw&i._v2;
mi=0;
run;
%end;
%mend;
%rw;

data m.ctc_rw1;
set p.ppi_allrw1_v2 m.ppi_allrw1_v2;
run; *136031;
data m.ctc_rw2;
set p.ppi_allrw2_v2 m.ppi_allrw2_v2;
run; *143093;
data m.ctc_rw3;
set p.ppi_allrw3_v2 m.ppi_allrw3_v2;
run; *188049;

*remove the person that can't be matched;
proc sql;
create table case_left as
select * from m.ppi_case where reference_key not in (select reference_key from m.match_all);
quit;
proc sql;
create table m.ctc_rw1 as
select * from m.ctc_rw1 where reference_key not in (Select reference_key from case_left);
quit; *135930;
proc sql;
create table m.ctc_rw2 as
select * from m.ctc_rw2 where reference_key not in (Select reference_key from case_left);
quit; *142992;
proc sql;
create table m.ctc_rw3 as
select * from m.ctc_rw3 where reference_key not in (Select reference_key from case_left);
quit; *187956;

data all;
set m.ctc_rw1 m.ctc_rw2 m.ctc_rw3;
max=max(reference_key);
run;


*Create new stratumid;
proc sort data=m.ctc_rw1;
by decending reference_key;run;
data m.ctc_rw1;
set m.ctc_rw1;
if mi=1 then stratumid=reference_key;
if mi=0 then stratumid=matchid+10180099; *10180099 is the last reference_key(case) in m.ctc_rw1 to distinguish from case patients;
run;
*Perfom conditional logistic regression;
PROC LOGISTIC data = m.ctc_rw1;
model rw  (EVENT='1')= exp exp*mi / expb;
strata stratumid; 
run; 

*output to R for analysis instead of using SAS;
data ctc_rw1;
set m.ctc_rw1;
keep reference_key rw exp mi stratumid;
run;
PROC EXPORT DATA= ctc_rw1
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\SAS export for R\manuscript\CTC\ctc_rw1.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;

/*
Results in R:
> ctc_rw1_analysis<-clogit(rw~exp+ exp*mi +strata(stratumid))
Warning message:
In coxph(formula = Surv(rep(1, 135930L), rw) ~ exp + exp * mi +  :
  X matrix deemed to be singular; variable 2
> summary(ctc_rw1_analysis)
Call:
coxph(formula = Surv(rep(1, 135930L), rw) ~ exp + exp * mi + 
    strata(stratumid), method = "exact")

  n= 135930, number of events= 1416 

         coef exp(coef) se(coef)     z Pr(>|z|)    
exp    0.5758    1.7785   0.1464 3.932 8.42e-05 ***
mi         NA        NA   0.0000    NA       NA    
exp:mi 1.8378    6.2826   0.1888 9.735  < 2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

       exp(coef) exp(-coef) lower .95 upper .95
exp        1.779     0.5623     1.335     2.370
mi            NA         NA        NA        NA
exp:mi     6.283     0.1592     4.340     9.095

Rsquare= 0.002   (max possible= 0.094 )
Likelihood ratio test= 277.9  on 2 df,   p=0
Wald test            = 425.9  on 2 df,   p=0
Score (logrank) test = 629.5  on 2 df,   p=0*/

*no of case/control patients;
data case_rw1;
set m.ctc_rw1;
if mi=1;
run;
proc sort data=case_rw1 nodupkey;
by reference_key;
run;
data ctrl_rw1;
set m.ctc_rw1;
if mi=0;
run;
proc sort data=ctrl_rw1 nodupkey;
by reference_key;
run;

/*risk window 2*/
*Create new stratumid;
proc sort data=m.ctc_rw2;
by decending reference_key;run;
data m.ctc_rw2;
set m.ctc_rw2;
if mi=1 then stratumid=reference_key;
if mi=0 then stratumid=matchid+10180099; *10180099 is the last reference_key(case) in m.ctc_rw1 to distinguish from case patients;
run;
PROC LOGISTIC data = m.ctc_rw2;
model rw  (EVENT='2')= exp exp*mi / expb;
strata stratumid;
run; 
*output to R for analysis instead of using SAS;
data ctc_rw2;
set m.ctc_rw2;
if rw=2 then rw=1;
keep reference_key rw exp mi stratumid;
run;
PROC EXPORT DATA= ctc_rw2
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\SAS export for R\manuscript\CTC\ctc_rw2.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;

/*in R:
> ctc_rw2_analysis<-clogit(rw~ exp + exp*mi + strata(stratumid))
Warning message:
In coxph(formula = Surv(rep(1, 142992L), rw) ~ exp + exp * mi +  :
  X matrix deemed to be singular; variable 2
> summary(ctc_rw2_analysis)
Call:
coxph(formula = Surv(rep(1, 142992L), rw) ~ exp + exp * mi + 
    strata(stratumid), method = "exact")

  n= 142992, number of events= 1499 

         coef exp(coef) se(coef)     z Pr(>|z|)    
exp    0.4137    1.5124   0.1549 2.671  0.00756 ** 
mi         NA        NA   0.0000    NA       NA    
exp:mi 1.2582    3.5190   0.2135 5.894 3.77e-09 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

       exp(coef) exp(-coef) lower .95 upper .95
exp        1.512     0.6612     1.116     2.049
mi            NA         NA        NA        NA
exp:mi     3.519     0.2842     2.316     5.347

Rsquare= 0.001   (max possible= 0.095 )
Likelihood ratio test= 95.91  on 2 df,   p=0
Wald test            = 136.7  on 2 df,   p=0
Score (logrank) test = 166.9  on 2 df,   p=0*/

*no of case/control patients;
data case_rw2;
set m.ctc_rw2;
if mi=1;
run;
proc sort data=case_rw2 nodupkey;
by reference_key;
run;

data ctrl_rw2;
set m.ctc_rw2;
if mi=0;
run;
proc sort data=ctrl_rw2 nodupkey;
by reference_key;
run;

/*risk window 3*/
proc sort data=m.ctc_rw3;
by decending reference_key;run;
data m.ctc_rw3;
set m.ctc_rw3;
if mi=1 then stratumid=reference_key;
if mi=0 then stratumid=matchid+10010875; *10010875 is the last reference_key(case) in m.ctc_rw1 to distinguish from case patients;
run;
PROC LOGISTIC data = m.ctc_rw3;
model rw  (EVENT='3')= exp exp*mi / expb;
strata stratumid;
run; 
*Odds Ratio Estimates 
Effect Point Estimate 95% Wald
Confidence Limits 
exp Exp(Est) se 
exp*mi Exp(Est) se ;

*output to R for analysis instead of using SAS;
data ctc_rw3;
set m.ctc_rw3;
if rw=3 then rw=1;
keep reference_key rw exp mi stratumid;
run;
PROC EXPORT DATA= ctc_rw3
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\SAS export for R\manuscript\CTC\ctc_rw3.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;

*no of case/control patients;
data case_rw3;
set m.ctc_rw3;
if mi=1;
run;
proc sort data=case_rw3 nodupkey;
by reference_key;
run;

data ctrl_rw3;
set m.ctc_rw3;
if mi=0;
run;
proc sort data=ctrl_rw3 nodupkey;
by reference_key;
run;

/*In R:
> ctc_rw3_analysis<-clogit(rw~ exp + exp*mi + strata(stratumid))
Warning message:
In coxph(formula = Surv(rep(1, 187956L), rw) ~ exp + exp * mi +  :
  X matrix deemed to be singular; variable 2
> summary(ctc_rw3_analysis)
Call:
coxph(formula = Surv(rep(1, 187956L), rw) ~ exp + exp * mi + 
    strata(stratumid), method = "exact")

  n= 187956, number of events= 2127 

           coef exp(coef) se(coef)      z Pr(>|z|)    
exp    -0.08074   0.92243  0.17763 -0.455    0.649    
mi           NA        NA  0.00000     NA       NA    
exp:mi  1.06509   2.90110  0.24474  4.352 1.35e-05 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

       exp(coef) exp(-coef) lower .95 upper .95
exp       0.9224     1.0841    0.6512     1.307
mi            NA         NA        NA        NA
exp:mi    2.9011     0.3447    1.7957     4.687

Rsquare= 0   (max possible= 0.101 )
Likelihood ratio test= 26.79  on 2 df,   p=1.523e-06
Wald test            = 34.39  on 2 df,   p=3.403e-08
Score (logrank) test = 37.02  on 2 df,   p=9.132e-09*/
