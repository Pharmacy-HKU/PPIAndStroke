/**************************************
*************************************
Created on 6 March 2018
Purpose: to clean the datasets for investigation the association between proton pump inhibitors and stroke

Stroke includes haemorrhagic stroke and ischaemic stroke in the primary analysis

risk windows:
day 1-14
days 15-30
days 31-60
and remove exposed time longer than the risk windows

As the inpatient PPIs censored lots of patients in the primary analysis
try to use another approach to manage the inpatient PPIs in the SCCS analysis
and describe the prescribing pattern of inpatient PPIs
*************************************
**************************************/
libname st "C:\Users\Angel YS Wong\Desktop\PPIs & stroke";
libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname an "C:\Users\Angel YS Wong\Desktop\PPI\program\drug";
libname lc "C:\Users\Angel YS Wong\Desktop\PPI\program\lc";

*In harddisk;
libname st "\\tsclient\E\PPIs & stroke";
libname p "\\tsclient\E\HK PhD project\PPI\program\PB_PPI";
libname dx "\\tsclient\E\HK PhD project\PPI\program\dx";

libname st "I:\PPIs & stroke";
libname p "I:\HK PhD project\PPI\program\PB_PPI";
libname dx "I:\HK PhD project\PPI\program\dx";
libname lc "I:\HK PhD project\PPI\program\lc";

/* only find those stroke patients in OP PPI prescriptions*/
proc sql;
create table opppi_stroke as
select * from p.ppi_pb_0314op where reference_key in (select reference_key from dx.ppi_allstroke);
quit; *468260;

proc sort data=p.ppi_pb_0314op nodupkey out=ppi_op_hc;
by reference_key;
run;
data opppi_stroke;
set opppi_stroke;
if substr(drug_name,1,7)='ASPIRIN'
or substr(drug_name,1,9)='BENZHEXOL' 
or substr(drug_name,1,9)='MEFENAMIC'
or action_status='Suspended' then delete;
run; *468251;

proc sort data=opppi_stroke nodupkey out=hc;
by reference_key;
run; *57133;
data opppi_stroke;
set opppi_stroke;
disd=input(Dispensing_Date__yyyy_mm_dd_,yymmdd10.);
ppirxst=input(prescription_start_date, yymmdd10.);
ppirxen=input(Prescription_End_Date, yymmdd10.);
dob=input(Date_of_Birth__yyyy_mm_dd_, yymmdd10.);
dod=input(Date_of_Registered_Death, yymmdd10.);
format disd ppirxst ppirxen dob dod yymmdd10.;
run;
/*remove patients who had PPI prescription during 2000-2002*/
proc sql;
create table opppi_stroke_oralclean as
select * from opppi_stroke where reference_key not in (select reference_key from p.ppi_pb_0002);
quit; *396992;
proc sort data=opppi_stroke_oralclean nodupkey out=hc;
by reference_key;
run; *51422;
proc freq data=opppi_stroke_oralclean;
table drug_name;
run; *all are PPIs;
/*please use the whole datasets to remove patients with ppirxen<ppirxst/ppirxst>dod
need to update on 11 July 2016*/
data rm;
set p.ppi_pb_0312 p.ppi_pb_1314;
ppirxst=input(Prescription_Start_Date, yymmdd10.);
ppirxen=input(Prescription_End_Date, yymmdd10.);
if ppirxen<ppirxst;
run; *182;
data rm2;
set opppi_stroke_oralclean;
if ~missing(dod) and dob>dod;
run; *0;
data rm3;
set p.ppi_pb_0312 p.ppi_pb_1314;
ppirxst=input(prescription_start_date, yymmdd10.);
dod=input(Date_of_Registered_Death, yymmdd10.);
if ~missing(dod) and ppirxst>dod;
run; *1137;
data rm_all;
set rm rm2 rm3;run; *1319;
proc sort data=rm_all nodupkey out=a;
by reference_key;run; *1161;
proc sql;
create table st.opppi_stroke_oralclean as
select * from opppi_stroke_oralclean where reference_key not in (select reference_key from rm_all);
quit; *395953;

proc sort data=st.opppi_stroke_oralclean nodupkey out=hc;
by reference_key;
run; *51307;

/*identified IP PPIs and non-oral PPIs*/
data pbppi0314;
set p.ppi_pb_0312 p.ppi_pb_1314;
run; *8592463;
data inppi_nonoral;
set pbppi0314;
if Type_of_Patient__Drug_='I' or
Type_of_Patient__Drug_='D' or route not in ('ORAL' , 'PO')
or missing(route);run; *6251182;
data inppi_nonoral;
set inppi_nonoral;
rxst=input(prescription_start_date, yymmdd10.);
rxen=input(prescription_end_date, yymmdd10.);
format rxst rxen yymmdd10.;
run;
data a;
set inppi_nonoral;
if missing(rxst) or missing(rxen);run; *0;
proc sql;
create table st.inppi_nonoral as
select * from inppi_nonoral where reference_key in (Select reference_key from st.opppi_stroke_oralclean);
quit; *1064229;

/*key LC data into the dataset*/
proc sql;
create table st.opppi_stroke_oralclean as
select * from st.opppi_stroke_oralclean A left join (select min_lc from lc.pat_lc B)
on A.reference_key=B.reference_key;
quit;*395953, zero missing;

data st.opppi_stroke_oralclean;
set st.opppi_stroke_oralclean;
lc12=min_lc+365;
y1=input("2003/01/01", yymmdd10.);
y2=input("2014/12/31", yymmdd10.);
st_st=max(dob, y1, lc12);
st_en=min(dod, y2);
format lc12 y1 y2 st_st st_en yymmdd10.;
run; *395953;

data remove;
set st.opppi_stroke_oralclean;
if st_st>st_en or ppirxen<st_st;
run; *2777 entry;
data st.opppi_stroke_oralclean;
set st.opppi_stroke_oralclean;
if ppirxst>st_en then delete;
run; *395944;
proc sql;
create table st.opppi_stroke_oralclean as
select * from st.opppi_stroke_oralclean where reference_key not in (select reference_key from remove);
quit; *386899;

proc sort data=st.opppi_stroke_oralclean nodupkey out=hc;
by reference_key;
run; *50127;
/*handle overlapping*/
data st.oralclean_coh1;
set st.opppi_stroke_oralclean;
run; *after overlap 30dapart: 74586 ;
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
%consec30d(max=80, input=st.oralclean_coh1, patid=reference_key, rxst=ppirxst, rxen=ppirxen);


data remove;
set st.oralclean_coh1;
if st_st>st_en or ppirxen<st_st;
run; *0 entry;
data st.oralclean_coh1;
set st.oralclean_coh1;
if ppirxst>st_en then delete;
run; *74586;
proc sql;
create table st.oralclean_coh1 as
select * from st.oralclean_coh1 where reference_key not in (select reference_key from remove);
quit; *;

data st.oralclean_coh1;
set st.oralclean_coh1;
if ppirxst<st_st and ppirxen>=st_st then ppirxst=st_st;
if ppirxen>st_en and ppirxst<=st_en then ppirxen=st_en;
run; *74586 entry;
proc sort data=st.oralclean_coh1 nodupkey out=hc;
by reference_key;run; *50127;


/******************************************
*******************************************
*******************************************
identify stroke using admission date, 
use only A&E and inpatient D1 data**********
*******************************************
*******************************************
*******************************************/
data dx.ppi_allstroke;
set dx.ppi_allstroke;
refd=input(reference_date, yymmdd10.);
format refd yymmdd10.;
run;
proc freq data=dx.ppi_allstroke;
table All_Diagnosis_Code__ICD9_;run;

proc sql;
create table st.ppi_allstroke_min as
select min(refd) as min_refd, * from dx.ppi_allstroke group by reference_key;
quit;
data st.ppi_allstroke_min;
set st.ppi_allstroke_min;
format min_refd yymmdd10.;
run;

/*updated on 13 Sep 2017, after cross-check with Joe
as there may be some inpatient data missing from dx.ppi_mistroke but not in all diagnosis, so can't left join
then wrongly identify the first recorded date in inpatient data
example: reference_key=2661790*/

*IP;
data allstroke_min_ip;
set st.ppi_allstroke_min;
if Patient_Type__IP_OP_A_E_="I";run; *124440;
* key adm, discharge date to stroke_min_ip;
proc sql;
create table allstroke_min_ip_adm as
select * from allstroke_min_ip A left join (select admd, dischd, Dx_Px_code, Dx_Px_Rank, Comment from dx.ppi_mistrokeip B)
on A.reference_key=B.reference_key and A.All_Diagnosis_Code__ICD9_=B.Dx_Px_code;
quit;
data allstroke_min_ip_adm2;
set allstroke_min_ip_adm;
if admd<refd<=dischd or admd=refd=dischd;run;
*Find min date for admission date;
proc sql;
create table allstroke_min_ip_adm2 as
select *, min(admd) as tempd from allstroke_min_ip_adm2 group by reference_key;quit;
data allstroke_min_ip_adm2;
set allstroke_min_ip_adm2;
format tempd yymmdd10.;run;
data allstroke_min_ip_adm2;
set allstroke_min_ip_adm2;
if ~missing(admd) and admd=tempd;run; *need to keep which entry has D1;
*OP and AE, and those inpatients without linkage;
data allstroke_min_ip_adm;
set allstroke_min_ip_adm;
if missing(admd);
run;
data allstroke_min_ao_only;
set st.ppi_allstroke_min;
if Patient_Type__IP_OP_A_E_="A" or Patient_Type__IP_OP_A_E_="O";run; *14338;
data allstroke_min_ao;
set allstroke_min_ao_only allstroke_min_ip_adm;
run;
data allstroke_min_ao;
set allstroke_min_ao;
if min_refd=refd;run; *9726;
data allstroke_min_ao;
set allstroke_min_ao;
tempd=min_refd;format tempd yymmdd10.;run;
data allstroke_min_ao;
set allstroke_min_ao;
if Patient_Type__IP_OP_A_E_="A" then pattype=2;
if Patient_Type__IP_OP_A_E_="I" then pattype=1;
if Patient_Type__IP_OP_A_E_="O" then pattype=0;
proc sort data=allstroke_min_ao;
by reference_key decending pattype;run; 
proc sort data=allstroke_min_ao nodupkey;
by reference_key;run; *9518;
*combine A with IP;
data allstroke_min_all;
set allstroke_min_ao allstroke_min_ip_adm2;run; *71755;
proc sql;
create table st.allstroke_date as
select *, min(tempd) as eventd from allstroke_min_all group by reference_key;
quit; *71755;
data st.allstroke_date;
set st.allstroke_date;
if eventd=tempd;
format eventd yymmdd10.;run;
data st.allstroke_date;
set st.allstroke_date;
if Patient_Type__IP_OP_A_E_="A" then pat_type=1;
if Patient_Type__IP_OP_A_E_="I" then pat_type=0;run;
proc sort data=st.allstroke_date;
by reference_key decending pat_type Dx_Px_Rank;run;
proc sort data=st.allstroke_date nodupkey;
by reference_key;run; *57233;

*only keep IP with D1;
data st.allstroke_date;
set st.allstroke_date;
if Patient_Type__IP_OP_A_E_="O" then delete;run; *56639;
data st.allstroke_date;
set st.allstroke_date;
if Patient_Type__IP_OP_A_E_="I" and Dx_Px_Rank~="D1" then delete;run; *49308;

/******************************************
*******************************************
*******************************************
***identify stroke patients;
*******************************************
*******************************************
*******************************************/
proc sql;
create table st.ppi_stroke_coh1 as
select * from st.oralclean_coh1 A left join (select reference_key, eventd, All_Diagnosis_Code__ICD9_, Diagnosis_Comment from st.allstroke_date B)
on A.reference_key=B.reference_key where ~missing(eventd);
quit; *64100;
data st.ppi_stroke_coh1;
set st.ppi_stroke_coh1;
if st_st<=eventd<=st_en;
run; *47768;
proc sort data=st.ppi_stroke_coh1 nodupkey out=ppi_stroke_hc;
by reference_key;run; *32102;
data ppi_stroke_hc;
set ppi_stroke_hc;
age=(st_st-dob)/365.25;run;
proc univariate data=ppi_stroke_hc;
var age;
run; *mean age: Median ;
data child;
set ppi_stroke_hc;
if age<18;run; *5;
proc sql;
create table st.ppi_stroke_coh1_adult as
select * from st.ppi_stroke_coh1 where reference_key not in (select reference_key from child);
quit; *47740;
proc sort data=st.ppi_stroke_coh1_adult nodupkey out=ppi_hc;
by reference_key;run; *32081;
data a;
set st.ppi_stroke_coh1_adult;
if ~missing(dod) and eventd>dod;
run; *0 entry;

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
/*pre risk -14-1 periods*/
data prerisk;
set ppi_stroke_coh1_adult;
pst=ppirxst-14;
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
run; *483709;
proc sort data=allperiod;
by reference_key pst pen;
run; 
data allperiod;
set allperiod;
if pst>pen or pst>st_en or pen<st_st then delete;
run; *286028;
data allperiod;
set allperiod;
if pen>st_en then pen=st_en;run;
data allperiod;
set allperiod;
if pst<st_st then pst=st_st;
run;

/*anticoagulants/antiplatelets*/
/*make sure the scripts are within their own obervation period before overlapping*/
proc sort data=st.ppi_stroke_coh1_adult nodupkey out=ppi_hc;
by reference_key;run; *32081;
proc sql;
create table st.inppi_nonoral_o30 as
select * from st.inppi_nonoral A left join (select st_st, st_en from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *1064229;
data st.inppi_nonoral_o30;
set st.inppi_nonoral_o30;
if missing(st_st) then delete;run;
data st.inppi_nonoral_o30;
set st.inppi_nonoral_o30;
if rxst>st_en or rxen<st_st then delete;
if rxst<st_st then rxst=st_st;
if rxen>st_en then rxen=st_en;run; *652680, after overlap: ;
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
%consec30d(max=100, input=st.inppi_nonoral_o30, patid=reference_key, rxst=rxst, rxen=rxen); 
data inppi_nonoral_o30;
set st.inppi_nonoral_o30;
rename rxst=ipppi_rxst rxen=ipppi_rxen;
ipppi_nid=_n_;
run;

data inppi_nonoral_o30;
set inppi_nonoral_o30;
keep reference_key ipppi_rxst ipppi_rxen st_st st_en;
run; *;
*add non-risk period;
proc sort data=inppi_nonoral_o30;
by reference_key ipppi_rxst ipppi_rxen;
run;
data inppi_nonoral_o30;
set inppi_nonoral_o30;
senpst=ipppi_rxst;
senpen=ipppi_rxen;
pst=ipppi_rxst;
pen=ipppi_rxen;
r=0;
format senpst senpen yymmdd10.;
run;
* identify the first prescription and add the non-risk period before the index date;
data nonrisk_st_st;
set inppi_nonoral_o30;
by reference_key;
if first.reference_key;
pst=st_st;
pen=senpst-1;
r=0;
format pst pen yymmdd10.;
run;
data nonrisk_st_st;
set nonrisk_st_st;
if ipppi_rxst<st_st then delete;
run; *sometimes rxst<st_st, then no nonrisk period:  obs;
data nonrisk_st_en;
set inppi_nonoral_o30; 
by reference_key;
if last.reference_key;
pst=senpen+1;
pen=st_en;
r=0;
run;
data nonrisk_st_en;
set nonrisk_st_en;
if ipppi_rxst>st_en then delete;run; *sometimes upper_rw2>=st_en, then no nonrisk period: ;
data nonrisk_st_en;
set nonrisk_st_en;
if ipppi_rxen>st_en then pen=st_en;run;
proc sort data=inppi_nonoral_o30;
by reference_key descending pst descending pen;
run;
data nonrisk_middle;
set inppi_nonoral_o30;
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
data allperiod_ipppi;
set nonrisk_middle nonrisk_st_st nonrisk_st_en inppi_nonoral_o30;
drop Prxst Prxen senpst senpen;
run; *181722;
proc sort data=allperiod_ipppi;
by reference_key pst pen;
run; 
data allperiod_ipppi;
set allperiod_ipppi;
if pst>pen then delete;
run; *171824;
data allperiod_ipppi;
set allperiod_ipppi;
if pen>st_en then pen=st_en;run;
data allperiod_ipppi;
set allperiod_ipppi;
if pst<st_st then pst=st_st;run;

/*age chopping

not yet run below codes: 06 March 2018*/
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
set allperiod allperiod_ipppi age_trans;
run; *601591 without ip added, 773415 now;
proc sort data=all;
by reference_key pst pen;
run;
data all2;
set all;
run; *note:601591, after: stop macro until entries in aa is 0;

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
%multi(max=30, input=all3);

data all4;
set all2 all3;
run; *note: ,  stop macro until entries in aa is 0;

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
if pst>st_en or pen<st_st then delete;run; *;
data all4;
set all4;
if pst<st_st then pst=st_st;
if pen>st_en then pen=st_en;
run; *;
data all4;
set all4;
drop ppirxst ppirxen;
run;

/*key indicator for ip ppi*/
data all4;
set all4;
drop ipppi_rxst ipppi_rxen;
run;
proc sql;
create table all4_ipppi as
select * from all4 A left join (select ipppi_rxst, ipppi_rxen from Inppi_nonoral_o30 B)
on A.reference_key=B.reference_key;
quit; *;
data all4_ipppi;
set all4_ipppi;
if pst<=ipppi_rxst<=pen or pst<=ipppi_rxen<=pen or ipppi_rxst<=pst<=ipppi_rxen or ipppi_rxst<=pen<=ipppi_rxen then ipppi=1;
else ipppi=0;
run;
proc sort data=all4_ipppi;
by reference_key pst pen decending ipppi;
run;
proc sort data=all4_ipppi nodupkey;
by reference_key pst pen;
run; *;
data st.all4_ipppi_primary;
set all4_ipppi;
drop ipppi_rxst ipppi_rxen;run;

/*can key in drug indicator now*/
data sen_primary_risk;
set st.all4_ipppi_primary;
run;
proc sql;
create table primary_risk as
select * from sen_primary_risk A left join (select pst as pre_pst, pen as pre_pen from prerisk B)
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
run; *600996, 737840;


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
run; *600996;

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
run; *600996;

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
run; *600996;

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
run; *600996;

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
if ~missing(postst_4) and op_p4=1 then delete;run; *523149;
data primary_risk5;
set primary_risk5;
if missing(r) then r=0;
drop op op_p1 op_p2 op_p3 op_p4 pre_pst pre_pen postst_1 posten_1 postst_2 posten_2 postst_3 posten_3 postst_4 posten_4;run;
proc sort data=primary_risk5;
by reference_key pst pen r;run; *523149;

proc sort data=st.ppi_stroke_coh1_adult nodupkey out=ppi_hc;
by reference_key;
run;
proc sql;
create table st.primary_risk_final as
select * from primary_risk5 A left join (select sex as gen from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *523149;
data st.primary_risk_final;
set st.primary_risk_final;
if gen='M' then sex=1;
if gen='F' then sex=0;
run;
data st.primary_risk_final;
set st.primary_risk_final;
drop gen eventd;
run;
proc sql;
create table st.primary_risk_final as
select * from st.primary_risk_final A left join (select dob, ppirxst, eventd from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *523149;


/*some of the risk periods chopped due to different pst and pen overlapped >>>need to be recombined
for example reference_key=1826865: the pre-risk period 17/2/2011-18/2/2011 and 19/2/2011-2/3/2011 are both pre-risk period
they were chopped due to the previous post-risk period, so need to combine it to be 17/2/2011-2/3/2011 for the whole pre-risk period
*/

data combinerisk;
set st.primary_risk_final;
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
lag_ipppi=lag(ipppi);
lag_r=lag(r);
run;
data combinerisk2;
set combinerisk;
if reference_key~=lag_indiv or lag_ipppi~=ipppi or lag_r~=r or (m_dob=m_pst and d_dob=d_pst) then n+1;
run;
proc sql;
create table combinerisk3 as
  select *, min(pst) as min_pst format yymmdd10., max(pen) as max_pen format yymmdd10. from combinerisk2 group by n;
quit;
proc sort data=combinerisk3 nodupkey;
by n;
run;
data st.primary_risk_final;
set combinerisk3;
drop pst pen;
rename min_pst=pst max_pen=pen;
drop lag_indiv n lag_ipppi lag_r m_dob d_dob m_pst d_pst yr_pst;
run; *523072;

data st.primary_risk_final;
set st.primary_risk_final;
age=floor ((intck('month',dob,pst) - (day(pst) < day(dob))) / 12);
censor=1;
interval=pen-pst+1;
run;


/*make sure there is an event for each person within observation period
as some periods were removed from baseline*/
data st.primary_risk_final;
set st.primary_risk_final;
if pst<=eventd<=pen then evt=1;
else evt=0;
run;
proc sql;
create table primary_risk_final as
select *, max(evt) as max_evt from st.primary_risk_final group by reference_key;
quit;
data rm;
set primary_risk_final;
if max_evt=0;
run; *58086;
proc sql;
create table st.primary_risk_final2 as
select * from st.primary_risk_final where reference_key not in (Select reference_key from rm);
quit; *464986;
proc sort data=st.primary_risk_final2 nodupkey out=final_hc;
by reference_key;
run; *28604;
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
/*making R dataset*/
data poisson_add;
set st.primary_risk_final2;
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
            OUTFILE= "I:\PPIs & stroke\R dataset\sccs_ppistroke_notrmip.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=NO;
RUN;

/*Result on 8 March 2018
without putting inpatient PPI as a covariate:
          exp(coef) exp(-coef) lower .95 upper .95
egroup2   1.018e+00  9.827e-01    0.9079    1.1406
egroup3   7.637e-01  1.309e+00    0.6697    0.8708
egroup4   8.041e-01  1.244e+00    0.7125    0.9074
egroup5   6.820e-01  1.466e+00    0.6183    0.7523
*/

data poisson_add;
set st.primary_risk_final2;
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
ip=ipppi;
keep indiv gender adrug lower upper exposed ip astart aend aevent group present; 
run;
PROC EXPORT DATA= poisson_add
            OUTFILE= "I:\PPIs & stroke\R dataset\sccs_ppistroke_ipppi_cov.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=NO;
RUN;

data ip_event;
set st.primary_risk_final2;
if ipppi=1 and lag(ipppi)=0 and pst=eventd;
run; *1295;
proc sql;
create table coh_ip_event as
select * from st.primary_risk_final2 where reference_key in (select reference_key from ip_event);
quit;
proc sql;
create table poisson_add_firevt as
select * from poisson_add where indiv not in (select reference_key from ip_event);
quit; *501171;
PROC EXPORT DATA= poisson_add_firevt
            OUTFILE= "I:\PPIs & stroke\R dataset\sccs_ppistroke_ipppi_cov_firevt.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=NO;
RUN;

/*Putting inpatient PPI as a covariate:

              exp(coef) exp(-coef) lower .95 upper .95
egroup2       5.568e-01  1.796e+00    0.4949    0.6266
egroup3       5.325e-01  1.878e+00    0.4663    0.6081
egroup4       6.405e-01  1.561e+00    0.5671    0.7233
egroup5       5.754e-01  1.738e+00    0.5213    0.6350
egroup_ipppi2 2.809e+00  3.560e-01    2.6768    2.9483

remove those with event on first day of inpatient
egroup_ipppi2 1.174e+00  8.515e-01    1.1009    1.2529

adjustment with interaction term with outpatient PPIs
                      exp(coef) exp(-coef) lower .95 upper .95
egroup2               2.073e+00  4.823e-01   1.81945    2.3628
egroup3               3.807e-01  2.627e+00   0.29990    0.4833
egroup4               3.152e-01  3.172e+00   0.25077    0.3963
egroup5               3.668e-01  2.726e+00   0.31444    0.4278
egroup_ipppi2         2.752e+00  3.634e-01   2.61145    2.9000
egroup2:egroup_ipppi2 8.004e-02  1.249e+01   0.06103    0.1050
egroup3:egroup_ipppi2 1.716e+00  5.826e-01   1.28554    2.2918
egroup4:egroup_ipppi2 3.414e+00  2.929e-01   2.59676    4.4876
egroup5:egroup_ipppi2 2.572e+00  3.888e-01   2.09552    3.1562
*/

*remove patients who had ever had inpatient PPIs
seems that the data is quite messy in terms of having inpatient and outpatient PPIs
they sometimes have overlapping Rx duration between these two types of PPIs settings;
proc sql;
create table rm_ever_ipppi as
select * from st.primary_risk_final2 where reference_key not in (Select reference_key from st.inppi_nonoral);
quit;
data poisson_add;
set rm_ever_ipppi;
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
            OUTFILE= "I:\PPIs & stroke\R dataset\sccs_ppistroke_neveripppi.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=NO;
RUN;

/*           exp(coef) exp(-coef) lower .95 upper .95
egroup2   1.245e+00  8.031e-01    0.8779    1.7659
egroup3   2.732e-01  3.660e+00    0.1301    0.5739
egroup4   6.590e-01  1.517e+00    0.4194    1.0355
egroup5   4.590e-01  2.179e+00    0.3069    0.6864*/

*how about only conduct the SCCS analyses among inpatient PPIs;
