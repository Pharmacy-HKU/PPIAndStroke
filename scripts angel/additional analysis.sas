/*Created on 29 Dec 2016

Purpose: Additional analysis 
(Considering all PPIs scripts, not limiting to short-term exposure to PPIs)
*Same as primary analysis
Chop risk periods:
-pre-risk period (14 days before the prescription)
-day 1-14
-days 15-30
-days 31-60

*Remove periods which still exposed to PPIs after days 61+ (after overlapping Rx gap <=30 days) from baseline 

*/

libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname pp "C:\Users\Angel YS Wong\Desktop\PPI\program\additional analysis";
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname an "C:\Users\Angel YS Wong\Desktop\PPI\program\drug";
libname lc "C:\Users\Angel YS Wong\Desktop\PPI\program\lc";


/*remove those who had IP PPIs before first OP PPIs and remove patients on non-oral*/
data pbppi0314;
set p.ppi_pb_0312 p.ppi_pb_1314;
run; *8592463;
data pbppi0314_rm;
set pbppi0314;
if Type_of_Patient__Drug_='I' or
Type_of_Patient__Drug_='D' or route not in ('ORAL' , 'PO')
or missing(route);run; *6251182;
proc sql;
create table ppi_ip_0314 as
select * from pbppi0314_rm where reference_key in (select reference_key from p.opppi_mi_oralclean_2);
quit; *775530;
data ppi_ip_0314;
set ppi_ip_0314;
rxst=input(prescription_start_date, yymmdd10.);
format rxst yymmdd10.;
run; *no missing data for rxst/rxen in this dataset;

proc sql;
create table opppi_mi_oralclean_2 as
select *, min(ppirxst) as min_op format yymmdd10. from p.opppi_mi_oralclean_2 group by reference_key;
quit;
proc sql;
create table ip_op as
select * from opppi_mi_oralclean_2 A left join (select rxst as ip_rxst from ppi_ip_0314 B)
on A.reference_key=B.reference_key;
quit; *9351668;
data ip_op2;
set ip_op;
if ~missing(ip_rxst) and ip_rxst<=min_op;
run; *1822567,  HC;

proc sql;
create table pp.opppi_mi_oralclean_3 as
select * from p.opppi_mi_oralclean_2 where reference_key not in (select reference_key from ip_op2);
quit; *67408;

/*key LC data into the dataset*/
proc sql;
create table pp.opppi_mi_oralclean_3 as
select * from pp.opppi_mi_oralclean_3 A left join (select min_lc from lc.pat_lc B)
on A.reference_key=B.reference_key;
quit;*67408;

/*key right censored IP PPIs/other routes into the dataset*/
proc sql;
create table pp.opppi_mi_oralclean_3 as
select * from pp.opppi_mi_oralclean_3 A left join (select IP_RC from an.ppi_ip_0314_RC B)
on A.reference_key=B.reference_key;
quit; *67408;
data pp.opppi_mi_oralclean_3;
set pp.opppi_mi_oralclean_3;
lc12=min_lc+365;
y1=input("2003/01/01", yymmdd10.);
y2=input("2014/12/31", yymmdd10.);
st_st=max(dob, y1, lc12);
st_en=min(dod, y2, IP_RC);
format lc12 y1 y2 st_st st_en IP_RC yymmdd10.;
run; *67408;
data remove;
set pp.opppi_mi_oralclean_3;
if st_st>st_en or ppirxen<st_st;
run; *520 entry;
data pp.opppi_mi_oralclean_3;
set pp.opppi_mi_oralclean_3;
if ppirxst>st_en then delete;
run; *27331;
proc sql;
create table pp.opppi_mi_oralclean_3 as
select * from pp.opppi_mi_oralclean_3 where reference_key not in (select reference_key from remove);
quit; *26830;

proc sort data=pp.opppi_mi_oralclean_3 nodupkey out=hc;
by reference_key;
run; *7265;

proc freq data=pp.opppi_mi_oralclean_3;;
table drug_name;
run;
data pp.opppi_mi_oralclean_3_o;
set pp.opppi_mi_oralclean_3;
run; *after overlap: 8751;
/**************************************
*************************************
*************************************
*************************************
overlapping
*************************************
*************************************
*************************************
***************************************/

%macro consec30d(max=, input=, patid=, rxst=, rxen=);
%do i=1 %to &max;
proc sort data=&input;
by &patid decending &rxst decending &rxen;
run;
data &input;
set &input;
by &patid;
Prxst=lag(&rxst);
Prxen=lag(&rxen);
format Prxst Prxen yymmdd10.;
if first.&patid then do;
Prxst=.;
Prxen=.;
end;
run;
data &input;
set &input;
if ~missing(Prxst)and 0<=Prxst-&rxen<=30 then do &rxen=Prxen;
end;
drop Prxst Prxen;
run;
proc sort data=&input;
by &patid &rxst &rxen;
run;
data &input;
set &input;
by &patid;
Prxst=lag(&rxst);
Prxen=lag(&rxen);
format Prxst Prxen yymmdd10.;
if first.&patid then do;
Prxst=.;
Prxen=.;
end;
run;
data &input;
set &input;
if &rxst<=Prxen<=&rxen and Prxst<=&rxst then do &rxst=Prxst;
end;
if Prxen>=&rxen and Prxst<=&rxst then do &rxst=Prxst;
end;
if Prxen>=&rxen and Prxst<=&rxst then do &rxen=Prxen;
end;
drop Prxst Prxen;
run;
proc sort data=&input;
by &patid descending &rxst descending &rxen;
run;
data &input;
set &input;
by &patid;
Prxst=lag(&rxst);
Prxen=lag(&rxen);
format Prxst Prxen yymmdd10.;
if first.&patid then do;
Prxst=.;
Prxen=.;
end;
run;
data &input;
set &input;
if &rxst<=Prxst<=&rxen and Prxen=>&rxen then do &rxen=Prxen;
end;
drop Prxst Prxen;
run;
proc sort data=&input nodupkey out=&input;
by &patid &rxst &rxen;
run;
%end;
%mend consec30d(max=, input=, patid=, rxst=, rxen=);
%consec30d(max=80, input=pp.opppi_mi_oralclean_3_o, patid=reference_key, rxst=ppirxst, rxen=ppirxen);

/*check whether the prescription within observation period*/
data remove;
set pp.opppi_mi_oralclean_3_o;
if st_st>st_en or ppirxen<st_st;
run; *0 entry;
data pp.opppi_mi_oralclean_3_o;
set pp.opppi_mi_oralclean_3_o;
if ppirxst>st_en then delete;
run; *8751;
data pp.oralclean_coh1;
set pp.opppi_mi_oralclean_3_o;
if ppirxst<st_st and ppirxen>=st_st then ppirxst=st_st;
if ppirxen>st_en and ppirxst<=st_en then ppirxen=st_en;
run; *8751 entry;
proc sort data=pp.oralclean_coh1 nodupkey out=hc;
by reference_key;run; *7265;


/*******************************************
*******************************************
***identify MI patients;
*******************************************
*******************************************
*******************************************/
proc sql;
create table pp.ppi_mi_coh1 as
select * from pp.oralclean_coh1 A left join (select reference_key, eventd, All_Diagnosis_Code__ICD9_, Diagnosis_Comment from p.allmi_date B)
on A.reference_key=B.reference_key where ~missing(eventd);
quit; *6504;
data pp.ppi_mi_coh1;
set pp.ppi_mi_coh1;
if st_st<=eventd<=st_en;
run; *3599;
proc sort data=pp.ppi_mi_coh1 nodupkey out=ppi_mi_hc;
by reference_key;run; *3014;
data ppi_mi_hc;
set ppi_mi_hc;
age=(st_st-dob)/365.25;run;
proc univariate data=ppi_mi_hc;
var age;
run; *mean age: Median ;
data child;
set ppi_mi_hc;
if age<18;run; *0;
proc sql;
create table pp.ppi_mi_coh1_adult as
select * from pp.ppi_mi_coh1 where reference_key not in (select reference_key from child);
quit; *3598;
data a;
set pp.ppi_mi_coh1_adult;
if ~missing(dod) and eventd>dod;
run; *0 entry;

/***********************************
***********************************
reshape the datasets**********
***********************************/
data ppi_mi_coh1_adult;
set pp.ppi_mi_coh1_adult;
keep reference_key ppirxst ppirxen st_st st_en eventd;
run;


*add risk period;
proc sort data=ppi_mi_coh1_adult;
by reference_key ppirxst ppirxen;
run;
/*risk 1-14*/
data ppi_mi_coh1_adult;
set ppi_mi_coh1_adult;
pst=ppirxst;
pen=ppirxst+14-1;
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
/*risk 15-30*/
data postrisk1;
set ppi_mi_coh1_adult;
pst=ppirxst+14;
pen=ppirxst+30-1;
r=3;
format pst pen yymmdd10.;
run;
/*risk 31-60*/
data postrisk2;
set ppi_mi_coh1_adult;
pst=ppirxst+30;
pen=ppirxst+60-1;
senpst=pst;
senpen=pen;
r=4;
format pst pen yymmdd10.;
run;
/*risk 61+ if exposed period last until days 61+*/
data postrisk3;
set ppi_mi_coh1_adult;
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
set ppi_mi_coh1_adult prerisk postrisk1 postrisk2 postrisk3;
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
run; *35381;
proc sort data=allperiod;
by reference_key pst pen;
run; 
data allperiod;
set allperiod;
if pst>pen or pst>st_en or pen<st_st then delete;
run; *20638;
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
set pp.ppi_mi_coh1_adult;
keep reference_key dob st_en;
run;
data a;
set a;
age=year(st_en)-year(dob);
run;
proc sort data=a;
by decending age;run; *109 is the largest so cut 110 below;

data age;
set pp.ppi_mi_coh1_adult;
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
run; *note:47713, after: stop macro until entries in aa is 0;

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
%multi(max=18, input=all2);

data all3;
set all;
run; *, after: 47713 stop macro until entries in aa is 0;
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
run; *note: 95426, 47666 stop macro until entries in aa is 0;

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
if pst>st_en or pen<st_st then delete;run; *47666;
data all4;
set all4;
if pst<st_st then pst=st_st;
if pen>st_en then pen=st_en;
run; *47666;
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
run; *47666;


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
run; *47666;

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
run; *47666;

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
run; *47666;

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
run; *47666;

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
data primary_risk5;
set primary_risk5;
if op=1 and op_p1=1 then r=1;
if op=1 and op_p2=1 then r=1;
if op=1 and op_p3=1 then r=1;
run;

/*remove exposed periods after days 61+ from baseline*/
data primary_risk5;
set primary_risk5;
if ~missing(postst_4) and op_p4=1 then delete;run; *44091;
data primary_risk5;
set primary_risk5;
if missing(r) then r=0;
drop op op_p1 op_p2 op_p3 op_p4 pre_pst pre_pen postst_1 posten_1 postst_2 posten_2 postst_3 posten_3 postst_4 posten_4;run;
proc sort data=primary_risk5;
by reference_key pst pen r;run; *44091;

proc sort data=pp.ppi_mi_coh1_adult nodupkey out=ppi_hc;
by reference_key;
run;
proc sql;
create table pp.primary_risk_final as
select * from primary_risk5 A left join (select sex as gen from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *44091;
data pp.primary_risk_final;
set pp.primary_risk_final;
if gen='M' then sex=1;
if gen='F' then sex=0;
run;
data pp.primary_risk_final;
set pp.primary_risk_final;
drop gen eventd;
run;
proc sql;
create table pp.primary_risk_final as
select * from pp.primary_risk_final A left join (select dob, ppirxst, eventd from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *44091;


/*some of the risk periods chopped due to different pst and pen overlapped >>>need to be recombined
for example reference_key=1826865: the pre-risk period 17/2/2011-18/2/2011 and 19/2/2011-2/3/2011 are both pre-risk period
they were chopped due to the previous post-risk period, so need to combine it to be 17/2/2011-2/3/2011 for the whole pre-risk period
*/

data combinerisk;
set pp.primary_risk_final;
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
data pp.primary_risk_final;
set combinerisk3;
drop pst pen;
rename min_pst=pst max_pen=pen;
drop lag_indiv n lag_r m_dob d_dob m_pst d_pst yr_pst;
run; *44086;

data pp.primary_risk_final;
set pp.primary_risk_final;
age=year(pst)-year(dob);
censor=1;
interval=pen-pst+1;
run;

/*make sure there is an event for each person within observation period
as some periods were removed from baseline*/
data pp.primary_risk_final;
set pp.primary_risk_final;
if pst<=eventd<=pen then evt=1;
else evt=0;
run;
proc sql;
create table primary_risk_final as
select *, max(evt) as max_evt from pp.primary_risk_final group by reference_key;
quit;
data rm;
set primary_risk_final;
if max_evt=0;
run; *2813;
proc sql;
create table pp.primary_risk_final2 as
select * from pp.primary_risk_final where reference_key not in (Select reference_key from rm);
quit; *41273;
proc sort data=pp.primary_risk_final2 nodupkey out=final_hc;
by reference_key;
run; *2802;
/*demographic details for the manuscript table*/
proc freq data=final_hc;
table sex;run;
data final_hc;
set final_hc;
age_cohort=(st_st-dob)/365.25;
run;
proc univariate data=final_hc;
var age_cohort;run;
/*making R dataset*/
data poisson_add;
set pp.primary_risk_final2;
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

PROC EXPORT DATA= poisson_add
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\SAS export for R\manuscript\sccs_ppimi_allrx.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=NO;
RUN;

data poisson;
set pp.primary_risk_final2;
if pst<=eventd<=pen then event=1;
else event=0;
interval=pen-pst+1;
age=year(pst)-year(dob);
censor=1;
run;
proc freq data=poisson;
table r*event;
run;

* r=0, 2631
r=1, 27
r=2, 56
r=3, 33
r=4, 55

56+33+55=144 event during first 60 days;

*check patterns of no of prescription for all PPIs;
proc sql;
create table no_rx_all_ppi as
select * from pp.opppi_mi_oralclean_3 where reference_key in (select reference_key from pp.primary_risk_final2);
quit;
proc sql;
create table no_rx_all_ppi_count as
select *, count(*) as count_Rx from no_rx_all_ppi group by reference_key ;
quit;
proc univariate data=no_rx_all_ppi_count;
var count_Rx;run; *6;
