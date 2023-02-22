/**************************************
*************************************
Created on 17 Jan 2018

Stroke includes haemorrhagic stroke and ischaemic stroke in the primary analysis

risk windows:
day 1-14
days 15-30
days 31-60
and remove exposed time longer than the risk windows

*Updated on 19 Jan 2018
Run the program in LSHTM

Purpose: replicate the stroke SAS editor apart from extending the pre-risk period to 60 days
after discussion with Heather on 16 Jan 2018 (UK time)
to clean the datasets for investigation the association between proton pump inhibitors and stroke
*************************************
**************************************/
libname st "C:\Users\Angel YS Wong\Desktop\PPIs & stroke";
libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname an "C:\Users\Angel YS Wong\Desktop\PPI\program\drug";
libname lc "C:\Users\Angel YS Wong\Desktop\PPI\program\lc";

*in LSHTM;
libname st "I:\PPIs & stroke";
*identify the censoring reason;
data ppi_stroke_coh1_adult;
set st.ppi_stroke_coh1_adult;
if st_en=y2 then censor_reason=0;
if ~missing(IP_RC) and st_en=IP_RC then censor_reason=1;
if ~missing(dod) and st_en=dod then censor_reason=2;
run;
proc sort data=ppi_stroke_coh1_adult nodupkey out=ppi_stroke_coh1_adult_censor;
by reference_key;run;
/***********************************
***********************************
reshape the datasets**********
***********************************/
data ppi_stroke_coh1_adult;
set st.ppi_stroke_coh1_adult;
keep reference_key ppirxst ppirxen st_st st_en eventd;
run;


*add risk period;
proc sort data=ppi_stroke_coh1_adult;
by reference_key ppirxst ppirxen;
run;
/*risk 1-14*/
data ppi_stroke_coh1_adult;
set ppi_stroke_coh1_adult;
pst=ppirxst;
pen=ppirxst+14-1;
r=2;
format pst pen yymmdd10.;
run;
/*pre risk -60-1 periods*/
data prerisk;
set ppi_stroke_coh1_adult;
pst=ppirxst-60;
pen=ppirxst-1;
senpst=pst;
senpen=pen;
r=1;
format pst pen yymmdd10.;
run;
/*risk 15-30*/
data postrisk1;
set ppi_stroke_coh1_adult;
pst=ppirxst+14;
pen=ppirxst+30-1;
r=3;
format pst pen yymmdd10.;
run;
/*risk 31-60*/
data postrisk2;
set ppi_stroke_coh1_adult;
pst=ppirxst+30;
pen=ppirxst+60-1;
senpst=pst;
senpen=pen;
r=4;
format pst pen yymmdd10.;
run;
/*risk 61+ if exposed period last until days 61+*/
data postrisk3;
set ppi_stroke_coh1_adult;
if ppirxen-ppirxst+1>60;
run;
data postrisk3;
set postrisk3;
pst=ppirxst+60;
pen=ppirxen;
senpst=pst;
senpen=pen;
r=5;
format pst pen yymmdd10.;
run;
data riskset;
set ppi_stroke_coh1_adult prerisk postrisk1 postrisk2 postrisk3;
run;
proc sort data=riskset;
by reference_key pst r;run;
* identify the first prescription and add the non-risk period before the index date;
data nonrisk_st_st;
set riskset;
by reference_key;
if first.reference_key;
pst=st_st;
pen=senpst-1;
r=0;
format pst pen yymmdd10.;
run;
data nonrisk_st_st;
set nonrisk_st_st;
if ppirxst<st_st then delete;
run; *sometimes rxst<st_st, then no nonrisk period:  obs;
data nonrisk_st_en;
set riskset; 
by reference_key;
if last.reference_key;
pst=senpen+1;
pen=st_en;
r=0;
run;
proc sort data=riskset;
by reference_key descending pst descending pen;
run;
data nonrisk_middle;
set riskset;
by reference_key;
Prxst=lag(pst);
Prxen=lag(pen);
format Prxst Prxen yymmdd10.;
if first.reference_key then do;
Prxst=.;
Prxen=.;
end;
run;
data nonrisk_middle;
set nonrisk_middle;
if ~missing(Prxst);
senpst=pen+1;
senpen=Prxst-1;
format senpst senpen yymmdd10.;
r=0;
run;
data nonrisk_middle;
set nonrisk_middle;
pst=senpst;
pen=senpen;
run;
data allperiod;
set nonrisk_middle nonrisk_st_st nonrisk_st_en riskset;
drop Prxst Prxen senpst senpen;
run; *107186;
proc sort data=allperiod;
by reference_key pst pen;
run; 
data allperiod;
set allperiod;
if pst>pen or pst>st_en or pen<st_st then delete;
run; *63006;
data allperiod;
set allperiod;
if pen>st_en then pen=st_en;run;
data allperiod;
set allperiod;
if pst<st_st then pst=st_st;
run;

/*age chopping*/
*need to check the largest year of age when st_en;
data a;
set st.ppi_stroke_coh1_adult;
keep reference_key dob st_en;
run;
data a;
set a;
age=year(st_en)-year(dob);
run;
proc sort data=a;
by decending age;run; *108 is the largest so cut 109 below;

data age;
set st.ppi_stroke_coh1_adult;
keep reference_key dob st_st st_en;
run;
%macro age;
data age;
set age;
%do i=18 %to 109;
age&i._s = intnx('year',dob, &i., 'same');
format age&i._s yymmdd10.;
%end;
run;
%mend;
%age;

proc sort data=age;
by reference_key dob st_st st_en;
run;
proc transpose data=age out=age_trans;
   by reference_key dob st_st st_en;
run;
data age_trans(rename=(col1=pst));;
set age_trans;
keep reference_key dob COL1 st_st st_en;
run;
data age_trans;
set age_trans;
if st_en<pst or pst<=st_st then delete;
run;
data age_trans;
set age_trans;
pen=intnx('year',pst,1, 'same');format pen yymmdd10.;
drop dob;run;
proc sort data=age_trans;
by reference_key decending pst;run;
data age_trans;
set age_trans;
by reference_key;
nn_pen=lag(pst); *because sb may have 29th birthday in Feb, may not have 29 Feb for each year, so need to do this step;
n_pen=pen-1;
format nn_pen n_pen yymmdd10.;drop pen;run;
data age_trans;
set age_trans;
if ~missing(nn_pen) and nn_pen>n_pen then pen=nn_pen-1;
if (~missing(nn_pen) and n_pen>nn_pen) or (missing(nn_pen)) then pen=n_pen;
format pen yymmdd10.;
run;
data age_trans;
set age_trans;
if pen>st_en then pen=st_en;
drop nn_pen n_pen;
run; *no pen<pst;
proc sort data=age_trans;
by reference_key pst pen;run;
/*combine them all*/
data all;
set allperiod age_trans;
run;
proc sort data=all;
by reference_key pst pen;
run;
data all2;
set all;
run; *note:146437, after: stop macro until entries in aa is 0;

%macro multi(max=, input=);
%do i=1 %to &max;
proc sort data=&input;
by reference_key decending pst decending pen;run;
data &input;
set &input;
by reference_key;
Prxst=lag(pst);
Prxen=lag(pen);
format Prxst Prxen yymmdd10.;
if first.reference_key then do;
Prxst=.;
Prxen=.;
end;run;
data &input;
set &input;
if ~missing(Prxen) and pen>Prxst>pst and pen>Prxen>pst then do;
c=1;
pen=Prxst-1;end;
run;
data aa;
set &input;
if c=1;
run;
data &input;
set &input;
if pst>pen then delete;run;
data &input;
set &input;
drop c Prxst Prxen;
run;
%end;
%mend multi(max=, input=);
%multi(max=20, input=all2);

data all3;
set all;
run; *, after: 146437 stop macro until entries in aa is 0;
%macro multi(max=, input=);
%do i=1 %to &max;
proc sort data=&input;
by reference_key decending pst decending pen;run;
data &input;
set &input;
by reference_key;
Prxst=lag(pst);
Prxen=lag(pen);
format Prxst Prxen yymmdd10.;
if first.reference_key then do;
Prxst=.;
Prxen=.;
end;run;
data &input;
set &input;
if ~missing(Prxen) and pen>Prxst>pst and pen>Prxen>pst then do;
c=1;
pst=Prxen+1;end;
run;
data aa;
set &input;
if c=1;
run;
data &input;
set &input;
if pst>pen then delete;run;
data &input;
set &input;
drop c Prxst Prxen;
run;
%end;
%mend multi(max=, input=);
%multi(max=30, input=all3);

data all4;
set all2 all3;
run; *note: 292874, 146317 stop macro until entries in aa is 0;

%macro multi(max=, input=);
%do i=1 %to &max;
proc sort data=&input;
by reference_key decending pst decending pen;run;
data &input;
set &input;
by reference_key;
Prxst=lag(pst);
Prxen=lag(pen);
format Prxst Prxen yymmdd10.;
if first.reference_key then do;
Prxst=.;
Prxen=.;
end;run;
data &input;
set &input;
if ~missing(Prxen) and pen>=Prxst then do;
c=1;
pen=Prxst-1;end;
run;
data &input;
set &input;
if pst>pen then delete;run;
data aa;
set &input;
if c=1;
run;
data &input;
set &input;
drop c Prxst Prxen;
run;
%end;
%mend multi(max=, input=);
%multi(max=4, input=all4);
%macro multi(max=, input=);
%do i=1 %to &max;
proc sort data=&input;
by reference_key pst pen;run;
data &input;
set &input;
by reference_key;
Prxst=lag(pst);
Prxen=lag(pen);
format Prxst Prxen yymmdd10.;
if first.reference_key then do;
Prxst=.;
Prxen=.;
end;run;
data &input;
set &input;
if ~missing(Prxen) and pen>=Prxst>=pst and pen>=Prxen then do;
c=1;
pst=Prxen+1;end;
run;
data aa;
set &input;
if c=1;
run;
data &input;
set &input;
if pst>pen then delete;run;
data &input;
set &input;
drop c Prxst Prxen;
run;
%end;
%mend multi(max=, input=);
%multi(max=4, input=all4);

/*just for checking*/
proc sort data=all4;
by reference_key pst pen;run;
data a;
set all4;
by reference_key;
Prxst=lag(pst);
Prxen=lag(pen);
format Prxst Prxen yymmdd10.;
if first.reference_key then do;
Prxst=.;
Prxen=.;end;
keep reference_key pst pen prxst prxen;
run; *;
data aa;
set a;
if ~missing(prxen) and pst-prxen~=1;run; *0, should be correct as it turns to 0;

/*check pst and pen outside observation period*/
data all4;
set all4;
if pst>st_en or pen<st_st then delete;run; *146615;
data all4;
set all4;
if pst<st_st then pst=st_st;
if pen>st_en then pen=st_en;
run; *146615;
data all4;
set all4;
drop ppirxst ppirxen ;
run;

/*can key in drug indicator now*/
data sen3_primary_risk;
set all4;
run;
proc sql;
create table primary_risk as
select * from sen3_primary_risk A left join (select pst as pre_pst, pen as pre_pen from prerisk B)
on A.reference_key=B.reference_key;
quit; *;
data primary_risk;
set primary_risk;
if pst<=pre_pst<=pen or pst<=pre_pen<=pen or pre_pst<=pst<=pre_pen or pre_pst<=pen<=pre_pen then op=1;
drop eventd;
run;
proc sort data=primary_risk;
by reference_key pst pen decending op;
run;
proc sort data=primary_risk nodupkey;
by reference_key pst pen;
run; *146317;


proc sql;
create table primary_risk2 as
select * from primary_risk A left join (select pst as postst_1, pen as posten_1 from ppi_stroke_coh1_adult B)
on A.reference_key=B.reference_key;
quit; *;
data primary_risk2;
set primary_risk2;
if pst<=postst_1<=pen or pst<=posten_1<=pen or postst_1<=pst<=posten_1 or postst_1<=pen<=posten_1 then op_p1=1;
run;
proc sort data=primary_risk2;
by reference_key pst pen decending op_p1;
run;
proc sort data=primary_risk2 nodupkey;
by reference_key pst pen;
run; *146317;

proc sql;
create table primary_risk3 as
select * from primary_risk2 A left join (select pst as postst_2, pen as posten_2 from postrisk1 B)
on A.reference_key=B.reference_key;
quit; *;
data primary_risk3;
set primary_risk3;
if pst<=postst_2<=pen or pst<=posten_2<=pen or postst_2<=pst<=posten_2 or postst_2<=pen<=posten_2 then op_p2=1;
run;
proc sort data=primary_risk3;
by reference_key pst pen decending op_p2;
run;
proc sort data=primary_risk3 nodupkey;
by reference_key pst pen;
run; *146317;

proc sql;
create table primary_risk4 as
select * from primary_risk3 A left join (select pst as postst_3, pen as posten_3 from postrisk2 B)
on A.reference_key=B.reference_key;
quit; *;
data primary_risk4;
set primary_risk4;
if pst<=postst_3<=pen or pst<=posten_3<=pen or postst_3<=pst<=posten_3 or postst_3<=pen<=posten_3 then op_p3=1;
run;
proc sort data=primary_risk4;
by reference_key pst pen decending op_p3;
run;
proc sort data=primary_risk4 nodupkey;
by reference_key pst pen;
run; *146317;

proc sql;
create table primary_risk5 as
select * from primary_risk4 A left join (select pst as postst_4, pen as posten_4 from postrisk3 B)
on A.reference_key=B.reference_key;
quit; *;
data primary_risk5;
set primary_risk5;
if pst<=postst_4<=pen or pst<=posten_4<=pen or postst_4<=pst<=posten_4 or postst_4<=pen<=posten_4 then op_p4=1;
run;
proc sort data=primary_risk5;
by reference_key pst pen decending op_p4;
run;
proc sort data=primary_risk5 nodupkey;
by reference_key pst pen;
run; *146317;

data primary_risk5;
set primary_risk5;
drop r;
run;
data primary_risk5;
set primary_risk5;
if op=1 then r=1;
if op_p1=1 then r=2;
if op_p2=1 then r=3;
if op_p3=1 then r=4;
run;
/*when two prescriptions overlap, prefer previous current risk window!
check all op_p1=1 and op_p2=1, op_p2 lower earlier than op_p1*/
data z;
set primary_risk5;
if (op_p1=1 and op_p2=1) and (postst_2<postst_1);run; *0 just for checking;
data primary_risk5;
set primary_risk5;
if (op_p2=1 and op_p3=1) then r=3;
run;
data primary_risk5;
set primary_risk5;
if (op_p1=1 and op_p2=1) or (op_p1=1 and op_p3=1) then r=2;
run;

/*prefer pre-risk than post-risk*/
*updated the below codes on 19 Jan 2018
: add if op=1 and op_p4=1 then r=1;
data primary_risk5;
set primary_risk5;
if op=1 and op_p1=1 then r=1;
if op=1 and op_p2=1 then r=1;
if op=1 and op_p3=1 then r=1;
if op=1 and op_p4=1 then r=1;
run;

/*remove exposed periods after days 61+ from baseline*/
*updated the below codes on 19 Jan 2018
: add missing(r) as pre-risk for 60 days are too long and may overlap with the previous 60+ period;
data primary_risk5;
set primary_risk5;
if ~missing(postst_4) and op_p4=1 and missing(r) then delete;run; *136743;
data primary_risk5;
set primary_risk5;
if missing(r) then r=0;
drop op op_p1 op_p2 op_p3 op_p4 pre_pst pre_pen postst_1 posten_1 postst_2 posten_2 postst_3 posten_3 postst_4 posten_4;run;
proc sort data=primary_risk5;
by reference_key pst pen r;run; *136743;

proc sort data=st.ppi_stroke_coh1_adult nodupkey out=ppi_hc;
by reference_key;
run;
proc sql;
create table st.primary_risk_final_prerisk60 as
select * from primary_risk5 A left join (select sex as gen from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *136743;
data st.primary_risk_final_prerisk60;
set st.primary_risk_final_prerisk60;
if gen='M' then sex=1;
if gen='F' then sex=0;
run;
data st.primary_risk_final_prerisk60;
set st.primary_risk_final_prerisk60;
drop gen eventd;
run;
proc sql;
create table st.primary_risk_final_prerisk60 as
select * from st.primary_risk_final_prerisk60 A left join (select dob, ppirxst, eventd from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *136743;


/*some of the risk periods chopped due to different pst and pen overlapped >>>need to be recombined
for example reference_key=1826865: the pre-risk period 17/2/2011-18/2/2011 and 19/2/2011-2/3/2011 are both pre-risk period
they were chopped due to the previous post-risk period, so need to combine it to be 17/2/2011-2/3/2011 for the whole pre-risk period
*/

data combinerisk;
set st.primary_risk_final_prerisk60;
run;
proc sort data=combinerisk;
by reference_key pst pen;
run;
data combinerisk;
set combinerisk;
m_dob=month(dob);
d_dob=day(dob);
m_pst=month(pst);
d_pst=day(pst);
yr_pst=year(pst);
run;
data combinerisk;
set combinerisk;
if m_dob=2 and d_dob=29 and (yr_pst~=2004 or yr_pst~=2008 or yr_pst~=2012) and d_pst=28 then d_pst=29;
run;
data combinerisk;
set combinerisk;
lag_indiv=lag(reference_key);
lag_r=lag(r);
run;
data combinerisk2;
set combinerisk;
if reference_key~=lag_indiv or lag_r~=r or (m_dob=m_pst and d_dob=d_pst) then n+1;
run;
proc sql;
create table combinerisk3 as
  select *, min(pst) as min_pst format yymmdd10., max(pen) as max_pen format yymmdd10. from combinerisk2 group by n;
quit;
proc sort data=combinerisk3 nodupkey;
by n;
run;
data st.primary_risk_final_prerisk60;
set combinerisk3;
drop pst pen;
rename min_pst=pst max_pen=pen;
drop lag_indiv n lag_r m_dob d_dob m_pst d_pst yr_pst;
run; *136079;

data st.primary_risk_final_prerisk60;
set st.primary_risk_final_prerisk60;
age=floor ((intck('month',dob,pst) - (day(pst) < day(dob))) / 12);
censor=1;
interval=pen-pst+1;
run;


/*make sure there is an event for each person within observation period
as some periods were removed from baseline*/
data st.primary_risk_final_prerisk60;
set st.primary_risk_final_prerisk60;
if pst<=eventd<=pen then evt=1;
else evt=0;
run;
proc sql;
create table primary_risk_final as
select *, max(evt) as max_evt from st.primary_risk_final_prerisk60 group by reference_key;
quit;
data rm;
set primary_risk_final;
if max_evt=0;
run; *6664;
proc sql;
create table st.primary_risk_final_prerisk602 as
select * from st.primary_risk_final_prerisk60 where reference_key not in (Select reference_key from rm);
quit; *129415;
proc sort data=st.primary_risk_final_prerisk602 nodupkey out=final_hc;
by reference_key;
run; *8487, two more were captured because the longer the pre-risk period so captured those were excluded due to 
long exposure (as pre-risk favour post-risk);

/*demographic details for the manuscript table*/
proc freq data=final_hc;
table sex;run;
data final_hc;
set final_hc;
age_cohort=(st_st-dob)/365.25;
age_evt=(eventd-dob)/365.25;
run;
proc univariate data=final_hc;
var age_cohort;run;
proc univariate data=final_hc;
var age_evt;run;

*key censored reason;
proc sql;
create table primary_risk_final_prerisk602 as
select * from st.primary_risk_final_prerisk602 A left join (Select censor_reason from ppi_stroke_coh1_adult_censor B)
on A.reference_key=B.reference_key;
quit;

/*making R dataset*/
data poisson_add;
set primary_risk_final_prerisk602;
indiv=reference_key;
gender=sex;
astart=datdif(dob, st_st, 'act/act');
adrug=datdif(dob, ppirxst, 'act/act');
aevent=datdif(dob, eventd, 'act/act');
aend=datdif(dob, st_en, 'act/act');
present=censor_reason;
exposed=r;
group=age;
lower=datdif(dob, pst, 'act/act');
upper=datdif(dob, pen, 'act/act');
keep indiv gender adrug lower upper exposed astart aend aevent group present; 
run;

PROC EXPORT DATA= poisson_add
            OUTFILE= "I:\PPIs & stroke\R dataset\sccs_ppistroke_allrx_prerisk60.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=NO;
RUN;

*  ;
data poisson;
set st.primary_risk_final2;
if pst<=eventd<=pen then event=1;
else event=0;
interval=pen-pst+1;
age=year(pst)-year(dob);
censor=1;
run;
proc freq data=poisson;
table r*event;
run;
proc sort data=poisson;
by r;run;
proc univariate data=poisson;
var interval;by r;
run;
proc univariate data=poisson;
var interval;
run;
* r=0, 8204
r=1, 62
r=2, 67
r=3, 57
r=4, 95 total: 8485

67+57+95=219 event during first 60 days;

*type of PPIs included in the identified patients;
data remove;
set st.opppi_stroke_oralclean_3;
if st_st>st_en or ppirxen<st_st;
run; *0 entry;
data type_ppi_all_coh;
set st.opppi_stroke_oralclean_3;
if ppirxst>st_en then delete;
run; *58749;

data type_ppi_all_coh;
set type_ppi_all_coh;
if ppirxst<st_st and ppirxen>=st_st then ppirxst=st_st;
if ppirxen>st_en and ppirxst<=st_en then ppirxen=st_en;
run; *58749 entry;
proc sort data=type_ppi_all_coh nodupkey out=hc;
by reference_key;run; *16431;

proc sql;
create table type_ppi_final as
select * from type_ppi_all_coh where reference_key in (select reference_key from st.ppi_stroke_coh1_adult);
quit; *30010;

proc freq data=type_ppi_final;
table drug_name;
run;

/*********************************************************************************
*********************************************************************************
updated on 22 Jan 2018

Sensitivity analysis 1

set pre-risk, during Rx, post 1-30 days, post 31-60 days
only consider PPIs

*********************************************************************************
*********************************************************************************/
/*************************************************************
**************************************************************
Cut risk periods*
**************************************************************
**************************************************************/
proc sort data=st.ppi_stroke_coh1_adult nodupkey out=ppi_hc;
by reference_key;run; *8974;
/*reshape the datasets*/
data ppi_mi_coh1_adult;
set st.ppi_stroke_coh1_adult;
keep reference_key ppirxst ppirxen st_st st_en eventd;
run;

*add non-risk period;
proc sort data=ppi_mi_coh1_adult;
by reference_key ppirxst ppirxen;
run;
/*during prescription*/
data ppi_mi_coh1_adult;
set ppi_mi_coh1_adult;
pst=ppirxst;
pen=ppirxen;
r=2;
format pst pen yymmdd10.;
run;
/*pre risk -60-1 periods*/
data prerisk;
set ppi_mi_coh1_adult;
pst=ppirxst-60;
pen=ppirxst-1;
senpst=pst;
senpen=pen;
r=1;
format pst pen yymmdd10.;
run;
/*first washout period 30 days after prescription end date*/
data postrisk1;
set ppi_mi_coh1_adult;
pst=ppirxen+1;
pen=ppirxen+30;
senpst=pst;
senpen=pen;
r=3;
format pst pen yymmdd10.;
run;
/*second washout periods 30 days after first washout period*/
data postrisk2;
set ppi_mi_coh1_adult;
pst=ppirxen+31;
pen=ppirxen+60;
senpst=pst;
senpen=pen;
r=4;
format pst pen yymmdd10.;
run;
data riskset;
set ppi_mi_coh1_adult prerisk postrisk1 postrisk2;
run;
proc sort data=riskset;
by reference_key pst r;run;
* identify the first prescription and add the non-risk period before the index date;
data nonrisk_st_st;
set riskset;
by reference_key;
if first.reference_key;
pst=st_st;
pen=senpst-1;
r=0;
format pst pen yymmdd10.;
run;
data nonrisk_st_st;
set nonrisk_st_st;
if ppirxst<st_st then delete;
run; *sometimes rxst<st_st, then no nonrisk period:  obs;
data nonrisk_st_en;
set riskset; 
by reference_key;
if last.reference_key;
pst=senpen+1;
pen=st_en;
r=0;
run;
proc sort data=riskset;
by reference_key descending pst descending pen;
run;
data nonrisk_middle;
set riskset;
by reference_key;
Prxst=lag(pst);
Prxen=lag(pen);
format Prxst Prxen yymmdd10.;
if first.reference_key then do;
Prxst=.;
Prxen=.;
end;
run;
data nonrisk_middle;
set nonrisk_middle;
if ~missing(Prxst);
senpst=pen+1;
senpen=Prxst-1;
format senpst senpen yymmdd10.;
r=0;
run;
data nonrisk_middle;
set nonrisk_middle;
pst=senpst;
pen=senpen;
run;
data allperiod;
set nonrisk_middle nonrisk_st_st nonrisk_st_en riskset;
drop Prxst Prxen senpst senpen;
run; *;
proc sort data=allperiod;
by reference_key pst pen;
run; 
data allperiod;
set allperiod;
if pst>pen or pst>st_en or pen<st_st then delete;
run; *50262;
data allperiod;
set allperiod;
if pen>st_en then pen=st_en;run;
data allperiod;
set allperiod;
if pst<st_st then pst=st_st;
run;

/*age chopping*/
*need to check the largest year of age when st_en;
data a;
set st.ppi_stroke_coh1_adult;;
keep reference_key dob st_en;
run;
data a;
set a;
age=year(st_en)-year(dob);
run;
proc sort data=a;
by decending age;run; *109 is the largest so cut 110 below;

data age;
set st.ppi_stroke_coh1_adult;
keep reference_key dob st_st st_en;
run;
%macro age;
data age;
set age;
%do i=18 %to 110;
age&i._s = intnx('year',dob, &i., 'same');
format age&i._s yymmdd10.;
%end;
run;
%mend;
%age;

proc sort data=age;
by reference_key dob st_st st_en;
run;
proc transpose data=age out=age_trans;
   by reference_key dob st_st st_en;
run;
data age_trans(rename=(col1=pst));;
set age_trans;
keep reference_key dob COL1 st_st st_en;
run;
data age_trans;
set age_trans;
if st_en<pst or pst<=st_st then delete;
run;
data age_trans;
set age_trans;
pen=intnx('year',pst,1, 'same');format pen yymmdd10.;
drop dob;run;
proc sort data=age_trans;
by reference_key decending pst;run;
data age_trans;
set age_trans;
by reference_key;
nn_pen=lag(pst); *because sb may have 29th birthday in Feb, may not have 29 Feb for each year, so need to do this step;
n_pen=pen-1;
format nn_pen n_pen yymmdd10.;drop pen;run;
data age_trans;
set age_trans;
if ~missing(nn_pen) and nn_pen>n_pen then pen=nn_pen-1;
if (~missing(nn_pen) and n_pen>nn_pen) or (missing(nn_pen)) then pen=n_pen;
format pen yymmdd10.;
run;
data age_trans;
set age_trans;
if pen>st_en then pen=st_en;
drop nn_pen n_pen;
run; *no pen<pst;
proc sort data=age_trans;
by reference_key pst pen;run;
/*combine them all*/
data all;
set allperiod age_trans;
run;
proc sort data=all;
by reference_key pst pen;
run;
data all2;
set all;
run; *note: 133693, after: stop macro until entries in aa is 0;

%macro multi(max=, input=);
%do i=1 %to &max;
proc sort data=&input;
by reference_key decending pst decending pen;run;
data &input;
set &input;
by reference_key;
Prxst=lag(pst);
Prxen=lag(pen);
format Prxst Prxen yymmdd10.;
if first.reference_key then do;
Prxst=.;
Prxen=.;
end;run;
data &input;
set &input;
if ~missing(Prxen) and pen>Prxst>pst and pen>Prxen>pst then do;
c=1;
pen=Prxst-1;end;
run;
data aa;
set &input;
if c=1;
run;
data &input;
set &input;
if pst>pen then delete;run;
data &input;
set &input;
drop c Prxst Prxen;
run;
%end;
%mend multi(max=, input=);
%multi(max=10, input=all2);

data all3;
set all;
run; *, after: stop macro until entries in aa is 0;
%macro multi(max=, input=);
%do i=1 %to &max;
proc sort data=&input;
by reference_key decending pst decending pen;run;
data &input;
set &input;
by reference_key;
Prxst=lag(pst);
Prxen=lag(pen);
format Prxst Prxen yymmdd10.;
if first.reference_key then do;
Prxst=.;
Prxen=.;
end;run;
data &input;
set &input;
if ~missing(Prxen) and pen>Prxst>pst and pen>Prxen>pst then do;
c=1;
pst=Prxen+1;end;
run;
data aa;
set &input;
if c=1;
run;
data &input;
set &input;
if pst>pen then delete;run;
data &input;
set &input;
drop c Prxst Prxen;
run;
%end;
%mend multi(max=, input=);
%multi(max=16, input=all3);

data all4;
set all2 all3;
run; *note:267386, after: stop macro until entries in aa is 0;

%macro multi(max=, input=);
%do i=1 %to &max;
proc sort data=&input;
by reference_key decending pst decending pen;run;
data &input;
set &input;
by reference_key;
Prxst=lag(pst);
Prxen=lag(pen);
format Prxst Prxen yymmdd10.;
if first.reference_key then do;
Prxst=.;
Prxen=.;
end;run;
data &input;
set &input;
if ~missing(Prxen) and pen>=Prxst then do;
c=1;
pen=Prxst-1;end;
run;
data &input;
set &input;
if pst>pen then delete;run;
data aa;
set &input;
if c=1;
run;
data &input;
set &input;
drop c Prxst Prxen;
run;
%end;
%mend multi(max=, input=);
%multi(max=4, input=all4);
%macro multi(max=, input=);
%do i=1 %to &max;
proc sort data=&input;
by reference_key pst pen;run;
data &input;
set &input;
by reference_key;
Prxst=lag(pst);
Prxen=lag(pen);
format Prxst Prxen yymmdd10.;
if first.reference_key then do;
Prxst=.;
Prxen=.;
end;run;
data &input;
set &input;
if ~missing(Prxen) and pen>=Prxst>=pst and pen>=Prxen then do;
c=1;
pst=Prxen+1;end;
run;
data aa;
set &input;
if c=1;
run;
data &input;
set &input;
if pst>pen then delete;run;
data &input;
set &input;
drop c Prxst Prxen;
run;
%end;
%mend multi(max=, input=);
%multi(max=4, input=all4);

/*just for checking*/
proc sort data=all4;
by reference_key pst pen;run;
data a;
set all4;
by reference_key;
Prxst=lag(pst);
Prxen=lag(pen);
format Prxst Prxen yymmdd10.;
if first.reference_key then do;
Prxst=.;
Prxen=.;end;
keep reference_key pst pen prxst prxen;
run; *;
data aa;
set a;
if ~missing(prxen) and pst-prxen~=1;run; *0, should be correct as it turns to 0;

/*check pst and pen outside observation period*/
data a;
set all4;
if pst>st_en or pen<st_st;run; *0;


/*can key in drug indicator now*/
data sen3_primary_risk;
set all4;
run;
proc sql;
create table primary_risk as
select * from sen3_primary_risk A left join (select pst as pre_pst, pen as pre_pen from prerisk B)
on A.reference_key=B.reference_key;
quit; *;
data primary_risk;
set primary_risk;
if pst<=pre_pst<=pen or pst<=pre_pen<=pen or pre_pst<=pst<=pre_pen or pre_pst<=pen<=pre_pen then op=1;
drop eventd;
run;
proc sort data=primary_risk;
by reference_key pst pen decending op;
run;
proc sort data=primary_risk nodupkey;
by reference_key pst pen;
run; *133641;


proc sql;
create table primary_risk2 as
select * from primary_risk A left join (select pst as postst_1, pen as posten_1 from ppi_mi_coh1_adult B)
on A.reference_key=B.reference_key;
quit; *;
data primary_risk2;
set primary_risk2;
if pst<=postst_1<=pen or pst<=posten_1<=pen or postst_1<=pst<=posten_1 or postst_1<=pen<=posten_1 then op_p1=1;
run;
proc sort data=primary_risk2;
by reference_key pst pen decending op_p1;
run;
proc sort data=primary_risk2 nodupkey;
by reference_key pst pen;
run; *133641;

proc sql;
create table primary_risk3 as
select * from primary_risk2 A left join (select pst as postst_2, pen as posten_2 from postrisk1 B)
on A.reference_key=B.reference_key;
quit; *;
data primary_risk3;
set primary_risk3;
if pst<=postst_2<=pen or pst<=posten_2<=pen or postst_2<=pst<=posten_2 or postst_2<=pen<=posten_2 then op_p2=1;
run;
proc sort data=primary_risk3;
by reference_key pst pen decending op_p2;
run;
proc sort data=primary_risk3 nodupkey;
by reference_key pst pen;
run; *133641;

proc sql;
create table primary_risk4 as
select * from primary_risk3 A left join (select pst as postst_3, pen as posten_3 from postrisk2 B)
on A.reference_key=B.reference_key;
quit; *;
data primary_risk4;
set primary_risk4;
if pst<=postst_3<=pen or pst<=posten_3<=pen or postst_3<=pst<=posten_3 or postst_3<=pen<=posten_3 then op_p3=1;
run;
proc sort data=primary_risk4;
by reference_key pst pen decending op_p3;
run;
proc sort data=primary_risk4 nodupkey;
by reference_key pst pen;
run; *133641;

data primary_risk4;
set primary_risk4;
drop r;
run;
data primary_risk4;
set primary_risk4;
if op=1 then r=1;
if op_p1=1 then r=2;
if op_p2=1 then r=3;
if op_p3=1 then r=4;
run;
/*when two prescriptions overlap, prefer previous current risk window!
check all op_p1=1 and op_p2=1, op_p2 lower earlier than op_p1*/
data z;
set primary_risk4;
if (op_p1=1 and op_p2=1) and (postst_2<postst_1);run; *0 just for checking;
data primary_risk4;
set primary_risk4;
if (op_p2=1 and op_p3=1) then r=3;
run;
data primary_risk4;
set primary_risk4;
if (op_p1=1 and op_p2=1) or (op_p1=1 and op_p3=1) then r=2;
run;

/*prefer pre-risk than post-risk*/
data primary_risk4;
set primary_risk4;
if op=1 and op_p1=1 then r=1;
if op=1 and op_p2=1 then r=1;
if op=1 and op_p3=1 then r=1;
if op=1 and op_p4=1 then r=1;
run;
data primary_risk4;
set primary_risk4;
if missing(r) then r=0;
drop op op_p1 op_p2 op_p3 pre_pst pre_pen postst_1 posten_1 postst_2 posten_2 postst_3 posten_3;run;
proc sort data=primary_risk4;
by reference_key pst pen r;run; *133641;


proc sql;
create table st.sen1_primary_final_prerisk60 as
select * from primary_risk4 A left join (select sex as gen from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *133641;
data st.sen1_primary_final_prerisk60;
set st.sen1_primary_final_prerisk60;
if gen='M' then sex=1;
if gen='F' then sex=0;
run;
data st.sen1_primary_final_prerisk60;
set st.sen1_primary_final_prerisk60;
drop gen ppirxst;
run;
proc sql;
create table st.sen1_primary_final_prerisk60 as
select * from st.sen1_primary_final_prerisk60 A left join (select dob, ppirxst, eventd from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *133641;


/*some of the risk periods chopped due to different pst and pen overlapped >>>need to be recombined
for example reference_key=1826865: the pre-risk period 17/2/2011-18/2/2011 and 19/2/2011-2/3/2011 are both pre-risk period
they were chopped due to the previous post-risk period, so need to combine it to be 17/2/2011-2/3/2011 for the whole pre-risk period

4 people have this problem
869674
1467772
1826865
2425738*/

data combinerisk;
set st.sen1_primary_final_prerisk60;
run;
proc sort data=combinerisk;
by reference_key pst pen;
run;
data combinerisk;
set combinerisk;
m_dob=month(dob);
d_dob=day(dob);
m_pst=month(pst);
d_pst=day(pst);
yr_pst=year(pst);
run;
data combinerisk;
set combinerisk;
if m_dob=2 and d_dob=29 and (yr_pst~=2004 or yr_pst~=2008 or yr_pst~=2012) and d_pst=28 then d_pst=29;
run;
data combinerisk;
set combinerisk;
lag_indiv=lag(reference_key);
lag_r=lag(r);
run;
data combinerisk2;
set combinerisk;
if reference_key~=lag_indiv or lag_r~=r or (m_dob=m_pst and d_dob=d_pst) then n+1;
run;
proc sql;
create table combinerisk3 as
  select *, min(pst) as min_pst format yymmdd10., max(pen) as max_pen format yymmdd10. from combinerisk2 group by n;
quit;
proc sort data=combinerisk3 nodupkey;
by n;
run;

data st.sen1_primary_final_prerisk60;
set combinerisk3;
drop pst pen;
rename min_pst=pst max_pen=pen;
drop lag_indiv n lag_r m_dob d_dob m_pst d_pst;
run; *132253;

data st.sen1_primary_final_prerisk60;
set st.sen1_primary_final_prerisk60;
age=year(pst)-year(dob);
if pst<=eventd<=pen then event=1;
else event=0;
run;

*key censored reason;
proc sql;
create table sen1_primary_final_prerisk60 as
select * from st.sen1_primary_final_prerisk60 A left join (Select censor_reason from ppi_stroke_coh1_adult_censor B)
on A.reference_key=B.reference_key;
quit;
data poisson_sen1;
set sen1_primary_final_prerisk60;
indiv=reference_key;
gender=sex;
astart=datdif(dob, st_st, 'act/act');
adrug=datdif(dob, ppirxst, 'act/act');
aevent=datdif(dob, eventd, 'act/act');
aend=datdif(dob, st_en, 'act/act');
present=censor_reason;
exposed=r;
group=year(pst)-year(dob);
lower=datdif(dob, pst, 'act/act');
upper=datdif(dob, pen, 'act/act');
keep indiv astart aend adrug aevent gender present exposed group lower upper;run;

PROC EXPORT DATA= poisson_sen1
            OUTFILE= "I:\PPIs & stroke\R dataset\sen1_primary_risk_final_prerisk60.txt" 
            DBMS=DLM REPLACE;
     PUTNAMES=NO;
RUN;

proc sort data=st.sen1_primary_final_prerisk60 nodupkey out=sen1_hc;
by reference_key;run; *8974;

data poisson;
set st.sen1_primary_final_prerisk60;
if pst<=eventd<=pen then event=1;
else event=0;
interval=pen-pst+1;
age=year(pst)-year(dob);
censor=1;
run;
proc freq data=poisson;
table r*event;
run;
proc sort data=poisson;
by r;run;
proc univariate data=poisson;
var interval;by r;
run;
proc univariate data=poisson;
var interval;
run;
