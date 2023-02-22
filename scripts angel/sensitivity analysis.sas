
libname st "C:\Users\Angel YS Wong\Desktop\PPIs & stroke";
libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname an "C:\Users\Angel YS Wong\Desktop\PPI\program\drug";
libname lc "C:\Users\Angel YS Wong\Desktop\PPI\program\lc";
/*********************************************************************************
*********************************************************************************
updated on 11 Oct 2017

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
/*pre risk -14-1 periods*/
data prerisk;
set ppi_mi_coh1_adult;
pst=ppirxst-14;
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
run; *50408;
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
run; *note: 133839, after: stop macro until entries in aa is 0;

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
%multi(max=4, input=all2);

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
run; *note:267678, after: stop macro until entries in aa is 0;

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
run; *133773;


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
run; *133773;

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
run; *133773;

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
run; *133773;

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
run;
data primary_risk4;
set primary_risk4;
if missing(r) then r=0;
drop op op_p1 op_p2 op_p3 pre_pst pre_pen postst_1 posten_1 postst_2 posten_2 postst_3 posten_3;run;
proc sort data=primary_risk4;
by reference_key pst pen r;run; *133773;


proc sql;
create table st.sen3_primary_risk_final as
select * from primary_risk4 A left join (select sex as gen from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *133773;
data st.sen3_primary_risk_final;
set st.sen3_primary_risk_final;
if gen='M' then sex=1;
if gen='F' then sex=0;
run;
data st.sen3_primary_risk_final;
set st.sen3_primary_risk_final;
drop gen ppirxst;
run;
proc sql;
create table st.sen3_primary_risk_final as
select * from st.sen3_primary_risk_final A left join (select dob, ppirxst, eventd from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *133773;


/*some of the risk periods chopped due to different pst and pen overlapped >>>need to be recombined
for example reference_key=1826865: the pre-risk period 17/2/2011-18/2/2011 and 19/2/2011-2/3/2011 are both pre-risk period
they were chopped due to the previous post-risk period, so need to combine it to be 17/2/2011-2/3/2011 for the whole pre-risk period

4 people have this problem
869674
1467772
1826865
2425738*/

data combinerisk;
set st.sen3_primary_risk_final;
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

data st.sen1_primary_risk_final;
set combinerisk3;
drop pst pen;
rename min_pst=pst max_pen=pen;
drop lag_indiv n lag_r m_dob d_dob m_pst d_pst;
run; *133599;

data st.sen1_primary_risk_final;
set st.sen1_primary_risk_final;
age=year(pst)-year(dob);
if pst<=eventd<=pen then event=1;
else event=0;
run;

data poisson_sen1;
set st.sen1_primary_risk_final;
indiv=reference_key;
gender=sex;
astart=datdif(dob, st_st, 'act/act');
adrug=datdif(dob, ppirxst, 'act/act');
aevent=datdif(dob, eventd, 'act/act');
aend=datdif(dob, st_en, 'act/act');
present=1;
exposed=r;
group=year(pst)-year(dob);
lower=datdif(dob, pst, 'act/act');
upper=datdif(dob, pen, 'act/act');
keep indiv astart aend adrug aevent gender present exposed group lower upper;run;

PROC EXPORT DATA= poisson_sen1
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPIs & stroke\R dataset\sen1_primary_risk_final.txt" 
            DBMS=DLM REPLACE;
     PUTNAMES=NO;
RUN;

proc sort data=st.sen1_primary_risk_final nodupkey out=sen1_hc;
by reference_key;run; *8974;

data poisson;
set st.sen1_primary_risk_final;
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
/*********************************************************************************
*********************************************************************************
Updated on 4 Aug 2017
updated on 11 Oct 2017
sensitivity analysis 3 for excluding patients with haemorrhagic stroke
(i.e. including ischaemic stroke only)
*********************************************************************************
*********************************************************************************/

*identify patients with haemorrhagic stroke in inpatient and A&E setting;
proc sql;
create table hae_stroke_ip as
select * from dx.ppi_mistrokeip where Dx_Px_code like '430%'
or Dx_Px_code like '431%'
or Dx_Px_code like '432%';
quit;

data allstroke_ae;
set dx.ppi_allstroke;
if Patient_Type__IP_OP_A_E_="A";
run; 
proc sql;
create table hae_stroke_ae as
select * from allstroke_ae where All_Diagnosis_Code__ICD9_ like '430%'
or All_Diagnosis_Code__ICD9_ like '431%'
or All_Diagnosis_Code__ICD9_ like '432%';
quit;
data hae_stroke_ipae;
set hae_stroke_ae hae_stroke_ip;
if ~missing(admd) then hae_eventd=admd;
if ~missing(refd) then hae_eventd=refd;
format hae_eventd yymmdd10.;
run; *26142;


*check which patients has haemorrhagic stroke on event date in the primary analysis;
proc sql;
create table rm_hae as
select * from st.ppi_stroke_coh1_adult A left join (select hae_eventd from hae_stroke_ipae B)
on A.reference_key=B.reference_key and A.eventd=B.hae_eventd;
quit;
data rm_hae;
set rm_hae;
if ~missing(hae_eventd);run; *2308;
proc sort data=rm_hae nodupkey;
by reference_key;run; *1484;
proc freq data=rm_hae;
table All_Diagnosis_Code__ICD9_;
run;

*remove patients who had haemorrhagic stroke on event date from the primary analysis;
proc sql;
create table st.sen3_primary_risk_final as
select * from st.primary_risk_final2 where reference_key not in (select reference_key from rm_hae);
quit; *108882;
proc sort data=st.sen3_primary_risk_final nodupkey out=sen4_hc;
by reference_key;run; *7100;

/*making R dataset*/
data poisson_sen3;
set st.sen3_primary_risk_final;
indiv=reference_key;
gender=sex;
astart=datdif(dob, st_st, 'act/act');
adrug=datdif(dob, ppirxst, 'act/act');
aevent=datdif(dob, eventd, 'act/act');
aend=datdif(dob, st_en, 'act/act');
present=1;
exposed=r;
group=age;
lower=datdif(dob, pst, 'act/act');
upper=datdif(dob, pen, 'act/act');
keep indiv gender adrug lower upper exposed astart aend aevent group present; 
run;

data poisson;
set st.sen3_primary_risk_final;
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

PROC EXPORT DATA= poisson_sen3
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPIs & stroke\R dataset\sen3_primary_risk_final.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=NO;
RUN;

/************************************************************************
***************************************************************************
******************************************************************************
Sensitivity analysis (did not update loading the program on 25 Sep 2017: 
reset the observation period by considering only outpatient scripts for
anticoagulants and antiplatelet
******************************************************************************
******************************************************************************
*******************************************************************************/
*patients who had inpatient Rx;
data ip_script;
set st.anticoag_and_antiplate;
if Type_of_Patient__Drug_='I' or Type_of_Patient__Drug_='D';
run;
data ip_script;
set ip_script;
yr_rxst=year(rxst);
run;
data ip_script;
set ip_script;
if yr_rxst<2000 then delete;run;
*remove patients who had inpatient script before first outpatient PPIs;
proc sql;
create table ppi_stroke_op as
select *, min(ppirxst) as min_op format yymmdd10. from st.ppi_stroke_coh1_adult group by reference_key;
quit;
proc sql;
create table ppi_stroke_op as
select * from ppi_stroke_op A left join (select rxst as ipod_rxst from ip_script B)
on A.reference_key=B.reference_key;
quit; *225841;
data rm;
set ppi_stroke_op;
if ~missing(ipod_rxst) and ipod_rxst<=min_op;
run; *96095,  HC;

proc sql;
create table ppi_stroke_coh1_adult_sen as
select * from st.ppi_stroke_coh1_adult where reference_key not in (select reference_key from rm);
quit; *4036;

*Censor the observation period if inpatient script after the first outpatient PPIs;
data ppi_ip_RC;
set ppi_stroke_op;
if ~missing(ipod_rxst) and ipod_rxst>min_op;
run; *128405,  HC;
proc sql;
create table ppi_ip_RC as
select *, min(ipod_rxst) as IPOD_RC format yymmdd10. from ppi_ip_RC group by reference_key;
quit;
proc sort data=ppi_ip_RC nodupkey;
by reference_key;
run; *5738;

/*key right censored IP PPIs/other routes into the dataset*/
proc sql;
create table ppi_stroke_coh1_adult_sen2 as
select * from ppi_stroke_coh1_adult_sen A left join (select IPOD_RC from ppi_ip_RC B)
on A.reference_key=B.reference_key;
quit; *4036;
data ppi_stroke_coh1_adult_sen2;
set ppi_stroke_coh1_adult_sen2;
st_st=max(dob, y1, lc12);
st_en=min(dod, y2, IP_RC, IPOD_RC);
format lc12 y1 y2 st_st st_en IP_RC yymmdd10.;
run; *4036;
data remove;
set ppi_stroke_coh1_adult_sen2;
if st_st>st_en or ppirxen<st_st;
run; *0 entry;
data ppi_stroke_coh1_adult_sen2;
set ppi_stroke_coh1_adult_sen2;
if ppirxst>st_en then delete;
run; *3769;

data ppi_stroke_coh1_adult_sen2;
set ppi_stroke_coh1_adult_sen2;
if ppirxst<st_st and ppirxen>=st_st then ppirxst=st_st;
if ppirxen>st_en and ppirxst<=st_en then ppirxen=st_en;
run; *3769 entries;

data ppi_stroke_coh1_adult_sen2;
set ppi_stroke_coh1_adult_sen2;
if st_st<=eventd<=st_en;
run; *3419;

*FOR SAVING RECORD ONLY;
data st.ppi_aa_sccs;
set ppi_stroke_coh1_adult_sen2;
run;*3419;
/***********************************
***********************************
original analysis
1.pre risk
2.day 1-14
3.day 15-30
4.day 31-60**********
***********************************/
*reshape the datasets;
data ppi_stroke_coh1_adult;
set st.ppi_aa_sccs;
keep reference_key ppirxst ppirxen st_st st_en eventd;
run;
*add non-risk period;
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
/*pre risk -14-1 periods*/
data prerisk;
set ppi_stroke_coh1_adult;
pst=ppirxst-14;
pen=ppirxst-1;
senpst=pst;
senpen=pen;
r=1;
format pst pen senpst senpen yymmdd10.;
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
format pst pen senpst senpen yymmdd10.;
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
run; *;
proc sort data=allperiod;
by reference_key pst pen;
run; 
data allperiod;
set allperiod;
if pst>pen or pst>st_en or pen<st_st then delete;
run; *;
data allperiod;
set allperiod;
if pen>st_en then pen=st_en;run;
data allperiod;
set allperiod;
if pst<st_st then pst=st_st;
run;

/*anticoagulants/antiplatelets*/
/*make sure the scripts are within their own obervation period before overlapping*/
proc sort data=st.ppi_aa_sccs nodupkey out=ppi_hc;
by reference_key;run; *2721;

proc sql;
create table anticoag_and_antiplate as
select * from st.anticoag_and_antiplate_o30 where reference_key in (select reference_key from st.ppi_aa_sccs);
quit; *2282;
data anticoag_and_antiplate;
set anticoag_and_antiplate;
rename rxst=aa_rxst rxen=aa_rxen;
aa_nid=_n_;
run;
proc sort data=anticoag_and_antiplate;
by reference_key aa_rxst;
run; *need to sort for formatdata in R to work well;

data anticoag_and_antiplate;
set anticoag_and_antiplate;
keep reference_key aa_rxst aa_rxen st_st st_en;
run; *2282;
*add non-risk period;
proc sort data=anticoag_and_antiplate;
by reference_key aa_rxst aa_rxen;
run;
data anticoag_and_antiplate;
set anticoag_and_antiplate;
senpst=aa_rxst;
senpen=aa_rxen;
pst=aa_rxst;
pen=aa_rxen;
r=0;
format senpst senpen yymmdd10.;
run;
* identify the first prescription and add the non-risk period before the index date;
data nonrisk_st_st;
set anticoag_and_antiplate;
by reference_key;
if first.reference_key;
pst=st_st;
pen=senpst-1;
r=0;
format pst pen yymmdd10.;
run;
data nonrisk_st_st;
set nonrisk_st_st;
if aa_rxst<st_st then delete;
run; *sometimes rxst<st_st, then no nonrisk period:  obs;
data nonrisk_st_en;
set anticoag_and_antiplate; 
by reference_key;
if last.reference_key;
pst=senpen+1;
pen=st_en;
r=0;
run;
data nonrisk_st_en;
set nonrisk_st_en;
if aa_rxst>st_en then delete;run; *sometimes upper_rw2>=st_en, then no nonrisk period: ;
data nonrisk_st_en;
set nonrisk_st_en;
if aa_rxen>st_en then pen=st_en;run;
proc sort data=anticoag_and_antiplate;
by reference_key descending pst descending pen;
run;
data nonrisk_middle;
set anticoag_and_antiplate;
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
data allperiod_aa;
set nonrisk_middle nonrisk_st_st nonrisk_st_en anticoag_and_antiplate;
drop Prxst Prxen senpst senpen;
run; *6307;
proc sort data=allperiod_aa;
by reference_key pst pen;
run; 
data allperiod_aa;
set allperiod_aa;
if pst>pen then delete;
run; *4810;
data allperiod_aa;
set allperiod_aa;
if pen>st_en then pen=st_en;run;
data allperiod_aa;
set allperiod_aa;
if pst<st_st then pst=st_st;run;

/*age chopping*/
*need to check the largest year of age when st_en;
data a;
set st.ppi_aa_sccs;
keep reference_key dob st_en;
run;
data a;
set a;
age=year(st_en)-year(dob);
run;
proc sort data=a;
by decending age;run; *108 is the largest so cut 109 below;

data age;
set st.ppi_aa_sccs;
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
set allperiod allperiod_aa age_trans;
run;
proc sort data=all;
by reference_key pst pen;
run;
data all2;
set all;
run; *note:47201, after: stop macro until entries in aa is 0;

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
%multi(max=32, input=all2);

data all3;
set all;
run; *, after:  stop macro until entries in aa is 0;
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
%multi(max=40, input=all3);

data all4;
set all2 all3;
run; *note:  stop macro until entries in aa is 0;

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
if ~missing(prxen) and pst-prxen~=1;run; *0, should be correct as it turaa to 0;

/*check pst and pen outside observation period*/
data all4;
set all4;
if pst>st_en or pen<st_st then delete;run; *;
data all4;
set all4;
if pst<st_st then pst=st_st;
if pen>st_en then pen=st_en;
run; *;
data all4;
set all4;
drop ppirxst ppirxen aa_rxst aa_rxen;
run; *45204;

/*key indicator for anticoag_and_antiplate*/
proc sql;
create table all4_aa as
select * from all4 A left join (select aa_rxst, aa_rxen from anticoag_and_antiplate B)
on A.reference_key=B.reference_key;
quit; *;
data all4_aa;
set all4_aa;
if pst<=aa_rxst<=pen or pst<=aa_rxen<=pen or aa_rxst<=pst<=aa_rxen or aa_rxst<=pen<=aa_rxen then aa=1;
else aa=0;
run;
proc sort data=all4_aa;
by reference_key pst pen decending aa;
run;
proc sort data=all4_aa nodupkey;
by reference_key pst pen;
run; *45204;
data st.all4_aa;
set all4_aa;
drop aa_rxst aa_rxen;run;

/*can key in drug indicator now*/
proc sql;
create table all4_aa_rw as
select * from st.all4_aa A left join (select pst as pre_pst, pen as pre_pen from prerisk B)
on A.reference_key=B.reference_key;
quit; *;
data all4_aa_rw;
set all4_aa_rw;
if pst<=pre_pst<=pen or pst<=pre_pen<=pen or pre_pst<=pst<=pre_pen or pre_pst<=pen<=pre_pen then op=1;
drop eventd;
run;
proc sort data=all4_aa_rw;
by reference_key pst pen decending op;
run;
proc sort data=all4_aa_rw nodupkey;
by reference_key pst pen;
run; *45204;


proc sql;
create table all4_aa_rw2 as
select * from all4_aa_rw A left join (select pst as postst_1, pen as posten_1 from ppi_stroke_coh1_adult B)
on A.reference_key=B.reference_key;
quit; *;
data all4_aa_rw2;
set all4_aa_rw2;
if pst<=postst_1<=pen or pst<=posten_1<=pen or postst_1<=pst<=posten_1 or postst_1<=pen<=posten_1 then op_p1=1;
run;
proc sort data=all4_aa_rw2;
by reference_key pst pen decending op_p1;
run;
proc sort data=all4_aa_rw2 nodupkey;
by reference_key pst pen;
run; *45204;

proc sql;
create table all4_aa_rw3 as
select * from all4_aa_rw2 A left join (select pst as postst_2, pen as posten_2 from postrisk1 B)
on A.reference_key=B.reference_key;
quit; *;
data all4_aa_rw3;
set all4_aa_rw3;
if pst<=postst_2<=pen or pst<=posten_2<=pen or postst_2<=pst<=posten_2 or postst_2<=pen<=posten_2 then op_p2=1;
run;
proc sort data=all4_aa_rw3;
by reference_key pst pen decending op_p2;
run;
proc sort data=all4_aa_rw3 nodupkey;
by reference_key pst pen;
run; *45204;

proc sql;
create table all4_aa_rw4 as
select * from all4_aa_rw3 A left join (select pst as postst_3, pen as posten_3 from postrisk2 B)
on A.reference_key=B.reference_key;
quit; *;
data all4_aa_rw4;
set all4_aa_rw4;
if pst<=postst_3<=pen or pst<=posten_3<=pen or postst_3<=pst<=posten_3 or postst_3<=pen<=posten_3 then op_p3=1;
run;
proc sort data=all4_aa_rw4;
by reference_key pst pen decending op_p3;
run;
proc sort data=all4_aa_rw4 nodupkey;
by reference_key pst pen;
run; *45204;

proc sql;
create table all4_aa_rw5 as
select * from all4_aa_rw4 A left join (select pst as postst_4, pen as posten_4 from postrisk3 B)
on A.reference_key=B.reference_key;
quit; *;
data all4_aa_rw5;
set all4_aa_rw5;
if pst<=postst_4<=pen or pst<=posten_4<=pen or postst_4<=pst<=posten_4 or postst_4<=pen<=posten_4 then op_p4=1;
run;
proc sort data=all4_aa_rw5;
by reference_key pst pen decending op_p4;
run;
proc sort data=all4_aa_rw5 nodupkey;
by reference_key pst pen;
run; *;

data all4_aa_rw5;
set all4_aa_rw5;
drop r;
run;
data all4_aa_rw5;
set all4_aa_rw5;
if op=1 then r=1;
if op_p1=1 then r=2;
if op_p2=1 then r=3;
if op_p3=1 then r=4;
run;
/*prefer pre-risk than post-risk*/
data all4_aa_rw5;
set all4_aa_rw5;
if op=1 and op_p1=1 then r=1;
if op=1 and op_p2=1 then r=1;
if op=1 and op_p3=1 then r=1;
run;

/*when two prescriptions overlap, prefer previous current risk window!
check all op_p1=1 and op_p2=1, op_p2 lower earlier than op_p1*/
data z;
set all4_aa_rw5;
if (op_p1=1 and op_p2=1) and (postst_2<postst_1);run; *0 just for checking;
data all4_aa_rw5;
set all4_aa_rw5;
if (op_p1=1 and op_p2=1) or (op_p1=1 and op_p3=1) then r=2;
run;
data all4_aa_rw5;
set all4_aa_rw5;
if (op_p2=1 and op_p3=1) then r=3;
run;

/*remove exposed periods after days 61+ from baseline*/
data all4_aa_rw5;
set all4_aa_rw5;
if ~missing(postst_4) and op_p4=1 then delete;run; *;
data all4_aa_rw5;
set all4_aa_rw5;
if missing(r) then r=0;
drop op op_p1 op_p2 op_p3 op_p4 pre_pst pre_pen postst_1 posten_1 postst_2 posten_2 postst_3 posten_3 postst_4 posten_4;run;
proc sort data=all4_aa_rw5;
by reference_key pst pen r;run; *;

proc sql;
create table st.all4_aa_rw as
select * from all4_aa_rw5 A left join (select sex as gen from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *42999;
data st.all4_aa_rw;
set st.all4_aa_rw;
if gen='M' then sex=1;
if gen='F' then sex=0;
run;
data st.all4_aa_rw;
set st.all4_aa_rw;
drop gen;
run;
proc sql;
create table st.all4_aa_rw as
select * from st.all4_aa_rw A left join (select dob, ppirxst, eventd from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *42999;

/*some of the risk periods chopped due to different pst and pen overlapped >>>need to be recombined
for example reference_key=1826865: the pre-risk period 17/2/2011-18/2/2011 and 19/2/2011-2/3/2011 are both pre-risk period
they were chopped due to the previous post-risk period, so need to combine it to be 17/2/2011-2/3/2011 for the whole pre-risk period
*/

data combinerisk;
set st.all4_aa_rw;
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
lag_aa=lag(aa);
lag_r=lag(r);
run;
data combinerisk2;
set combinerisk;
if reference_key~=lag_indiv or lag_aa~=aa or lag_r~=r or (m_dob=m_pst and d_dob=d_pst) then n+1;
run;
proc sql;
create table combinerisk3 as
  select *, min(pst) as min_pst format yymmdd10., max(pen) as max_pen format yymmdd10. from combinerisk2 group by n;
quit;
proc sort data=combinerisk3 nodupkey;
by n;
run;
data st.all4_aa_rw;
set combinerisk3;
drop pst pen;
rename min_pst=pst max_pen=pen;
drop lag_indiv lag_aa n lag_r m_dob d_dob m_pst d_pst;
run; *42922;

data st.all4_aa_rw;
set st.all4_aa_rw;
age=year(pst)-year(dob);
censor=1;
interval=pen-pst+1;
run;

/*make sure there is an event for each person within observation period
as some periods were removed from baseline*/
data st.all4_aa_rw;
set st.all4_aa_rw;
if pst<=eventd<=pen then evt=1;
else evt=0;
run;
proc sql;
create table primary_risk_final as
select *, max(evt) as max_evt from st.all4_aa_rw group by reference_key;
quit;
data rm;
set primary_risk_final;
if max_evt=0;
run; *3843;
proc sql;
create table st.all4_aa_rw2 as
select * from st.all4_aa_rw where reference_key not in (Select reference_key from rm);
quit; *39079;
proc sort data=st.all4_aa_rw2 nodupkey out=final_hc;
by reference_key;
run; *2455;
/*making R dataset*/
data poisson_sen;
set st.all4_aa_rw2;
indiv=reference_key;
gender=sex;
astart=datdif(dob, st_st, 'act/act');
adrug=datdif(dob, ppirxst, 'act/act');
aevent=datdif(dob, eventd, 'act/act');
aend=datdif(dob, st_en, 'act/act');
present=1;
exposed=r;
group=age;
lower=datdif(dob, pst, 'act/act');
upper=datdif(dob, pen, 'act/act');
anticoag_and_antiplate=aa;
keep indiv gender adrug lower upper exposed anticoag_and_antiplate astart aend aevent group present; 
run;
PROC EXPORT DATA= poisson_sen
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPIs & stroke\R dataset\sen1_primary_risk_final.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=NO;
RUN;

/*********************************************************************************
*********************************************************************************
Updated on 7 Aug 2017
Further updated on 6 Dec 2017
sensitivity analysis  for excluding patients whose patients death 90 days after stroke from the primary analysis
*********************************************************************************
*********************************************************************************/

*key death date to primar_risk_final2 dataset;
proc sort data=st.ppi_stroke_coh1_adult nodupkey out=ppi_hc;
by reference_key;
run;
proc sql;
create table rm_death90 as
select * from st.primary_risk_final2 A left join (Select dod from ppi_hc B)
on A.reference_key=B.reference_key;
quit;
data rm_death90;
set rm_death90;
if ~missing(dod) and 0<=dod-eventd+1<=90;
gap=dod-eventd+1;
run; *5315;
proc sort data=rm_death90 nodupkey;
by reference_key;run; *397;
proc sql;
create table st.sen5_primary_risk_final as
select * from st.primary_risk_final2 where reference_key not in (select reference_key from rm_death90);
quit; *124895;

/*making R dataset*/
data poisson_sen5;
set st.sen5_primary_risk_final;
indiv=reference_key;
gender=sex;
astart=datdif(dob, st_st, 'act/act');
adrug=datdif(dob, ppirxst, 'act/act');
aevent=datdif(dob, eventd, 'act/act');
aend=datdif(dob, st_en, 'act/act');
present=1;
exposed=r;
group=age;
lower=datdif(dob, pst, 'act/act');
upper=datdif(dob, pen, 'act/act');
keep indiv gender adrug lower upper exposed astart aend aevent group present; 
run;

proc freq datat=st.sen5_primary_risk_final;
table evt*r;
run;

PROC EXPORT DATA= poisson_sen5
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPIs & stroke\R dataset\sen5_primary_risk_final.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=NO;
RUN;
