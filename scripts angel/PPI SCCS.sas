/**************************************
*************************************
Created on 16 Feb 2016
Updated on 29 Jun 2016
Purpose: perform SCCS on short term use of PPIs  (<=56 days) recommended by BNF (4-8 weeks)

Use different methods to estimate the duration of prescriptions
overlapping 30 days assuming same regimen for PPIs

Multiple exposures to estimate the effect of concomitant use of other drugs:
NSAIDS, clarithromycin, IP PPIs


Updated on 11 July: 
1. discussed with Celine that we re-calculated the duration after setting up the observation period
as we chose short term use of PPIs because SCCS requires intermittent short exposures.
2. Use the whole PPIs (IP/OP/AE) to check whose prescription start date> deathdate and remove these patients
3. remove patients who had inpatient PPIs or PPIs other than oral routes on or before first outpatient PPIs
4. Multiple exposures only consider clarithromycin and NSAIDS

*************************************
**************************************/
libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname an "C:\Users\Angel YS Wong\Desktop\PPI\program\drug";
libname lc "C:\Users\Angel YS Wong\Desktop\PPI\program\lc";

/* identify MI for all dx*/
proc sql;
create table dx.ppi_allmi as
select * from dx.dx_all9315jj where All_Diagnosis_Code__ICD9_ like '410%';
quit; *62635;
/* only find those MI patients in OP PPI prescriptions*/
proc sql;
create table opppi_mi as
select * from p.ppi_pb_0314op where reference_key in (select reference_key from dx.ppi_allmi);
quit; *325960;
proc sort data=opppi_mi nodupkey out=hc;
by reference_key;
run; *37157;

proc sort data=p.ppi_pb_0314op nodupkey out=ppi_op_hc;
by reference_key;
run;
/*find the total number of PPIs prescriptions*/
proc freq data=p.ppi_pb_0314op;
table drug_name;
run; *;
data ppi_clean_rxno;
set p.ppi_pb_0314op;
if substr(drug_name,1,7)='ASPIRIN'
or substr(drug_name,1,9)='BENZHEXOL' 
or substr(drug_name,1,9)='MEFENAMIC' then delete;
run; *2341849;
/*estimate how many Rx in short-term exposure (<=56 days)*/
data ppi_clean_rxno;
set ppi_clean_rxno;
rxst=input(Prescription_Start_Date, yymmdd10.);
rxen=input(Prescription_End_Date, yymmdd10.);
disp=input(Dispensing_Date__yyyy_mm_dd_, yymmdd10.);
year=year(disp);
format rxst rxen disp yymmdd10.;
run;
proc freq data=ppi_clean_rxno;
table year/ out=p.ppi_op_trend;
run;
title "The prescription trend of proton pump inhibitors between 2003 and 2014 in Hong Kong public healthcare sector";
axis1 label=(a=90 'Number of proton pump inhibitor prescriptions');
symbol1 color=black interpol=join value=x;
proc gplot data=p.ppi_op_trend;
plot COUNT*year/vaxis=axis1;
run;quit;

data short_ppi;
set ppi_clean_rxno;
if 0<=dur<=56;run; *890389;
proc freq data=ppi_clean_rxno;
table drug_name;
run;
proc freq data=ppi_clean_rxno;
table drug_item_code;where missing(drug_name);
run;
proc sort data=ppi_clean_rxno nodupkey;
by reference_key;run; *405137;
data opppi_mi;
set opppi_mi;
disd=input(Dispensing_Date__yyyy_mm_dd_,yymmdd10.);
ppirxst=input(prescription_start_date, yymmdd10.);
ppirxen=input(Prescription_End_Date, yymmdd10.);
dob=input(Date_of_Birth__yyyy_mm_dd_, yymmdd10.);
dod=input(Date_of_Registered_Death, yymmdd10.);
format disd ppirxst ppirxen dob dod yymmdd10.;
run;
/*remove patients who had PPI prescription during 2000-2002*/
proc sql;
create table opppi_mi_oralclean as
select * from opppi_mi where reference_key not in (select reference_key from p.ppi_pb_0002);
quit; *280247;
proc sort data=opppi_mi_oralclean nodupkey out=hc;
by reference_key;
run; *33848;
proc freq data=opppi_mi_oralclean;
table drug_name;
run; *all are PPIs;
/*please use the whole datasets to remove patients with ppirxen<ppirxst/ppirxst>dod
need to update on 11 July 2016*/
data rm;
set opppi_mi_oralclean;
if ppirxen<ppirxst;
run; *4;
data rm2;
set opppi_mi_oralclean;
if ~missing(dod) and dob>dod;
run; *0;
data rm3;
set p.ppi_pb_0312 p.ppi_pb_1314;
ppirxst=input(prescription_start_date, yymmdd10.);
dod=input(Date_of_Registered_Death, yymmdd10.);
if ~missing(dod) and ppirxst>dod;
run; *1137;
data rm_all;
set rm rm2 rm3;run; *1141;
proc sql;
create table p.opppi_mi_oralclean as
select * from opppi_mi_oralclean where reference_key not in (select reference_key from rm_all);
quit; *279337;
proc freq data=p.opppi_mi_oralclean;
table action_status;run;
data p.opppi_mi_oralclean;
set p.opppi_mi_oralclean;
if action_status='Suspended' then delete;run; *279335;

proc sort data=p.opppi_mi_oralclean nodupkey out=hc;
by reference_key;
run; *33764;

********************************
*check dose and calculate duration using dispensing information etc
not yet updated*********
**********************;
proc freq data=p.opppi_mi_oralclean;
table Dosage;run;
data p.opppi_mi_oralclean;
set p.opppi_mi_oralclean;
if substr(Dosage,1,3)="0.5" then ppi_dosage=0.5;
if substr(Dosage,1,2)="1 " then ppi_dosage=1;
if substr(Dosage,1,7)="1.5 TAB" then ppi_dosage=1.5;
if substr(Dosage,1,2)="14" then ppi_dosage=14;
if substr(Dosage,1,2)="16" then ppi_dosage=16;
if substr(Dosage,1,2)="18" then ppi_dosage=18;
if substr(Dosage,1,2)="2 " then ppi_dosage=2;
if substr(Dosage,1,2)="4 " then ppi_dosage=4;
if substr(Dosage,1,2)="8 " then ppi_dosage=8;
run;
data a;
set p.opppi_mi_oralclean;
if missing(ppi_dosage);run; *0;
proc freq data=p.opppi_mi_oralclean;
table Drug_Strength;run;
data p.opppi_mi_oralclean;
set p.opppi_mi_oralclean;
if substr(Drug_Strength,1,2)="10" then ppi_str=10;
if substr(Drug_Strength,1,2)="15" then ppi_str=15;
if substr(Drug_Strength,1,2)="20" then ppi_str=20;
if substr(Drug_Strength,1,2)="30" then ppi_str=30;
if substr(Drug_Strength,1,2)="40" then ppi_str=40;
if substr(Drug_Strength,1,2)="60" then ppi_str=60;run;
data a;
set p.opppi_mi_oralclean;
if missing(ppi_str) and ~missing(Drug_Strength);run; *0;
proc freq data=p.opppi_mi_oralclean;table Drug_Frequency;run;
data p.opppi_mi_oralclean;
set p.opppi_mi_oralclean;
if substr(Drug_Frequency,1,2)="AT" then ppi_ndd=1;
if substr(Drug_Frequency,1,2)="AF" then ppi_ndd=1;
if substr(Drug_Frequency,1,2)="BE" then ppi_ndd=1;
if substr(Drug_Frequency,1,3)="DAI" then ppi_ndd=1;
if substr(Drug_Frequency,1,8)="EVERY 12" then ppi_ndd=2;
if substr(Drug_Frequency,1,8)="EVERY 24" then ppi_ndd=1;
if substr(Drug_Frequency,1,10)="EVERY TWEL" then ppi_ndd=2;
if substr(Drug_Frequency,1,4)="FOUR" then ppi_ndd=4;
if substr(Drug_Frequency,1,2)="IN" then ppi_ndd=1;
if substr(Drug_Frequency,1,4)="ONCE" then ppi_ndd=1;
if substr(Drug_Frequency,1,3)="THR" then ppi_ndd=3;
if substr(Drug_Frequency,1,5)="TWICE" then ppi_ndd=2; run;
data a;
set p.opppi_mi_oralclean;
if missing(ppi_ndd) and ~missing(Drug_Frequency);run; *2, only as directed, cant determined;
data p.opppi_mi_oralclean;
set p.opppi_mi_oralclean;
ppi_mgperday=ppi_str*ppi_ndd*ppi_dosage;
cal_dur=Quantity__Named_Patient_/ppi_ndd/ppi_dosage;
dur=ppirxen-ppirxst+1;
run;
proc freq data=p.opppi_mi_oralclean;
table Dispensing_Duration_Unit;
run;
data p.opppi_mi_oralclean;
set p.opppi_mi_oralclean;
if Dispensing_Duration_Unit='Week(s' then dis_dur=Dispensing_Duration*7;
else dis_dur=Dispensing_Duration;run;
data a;
set p.opppi_mi_oralclean;
if missing(dis_dur) or dis_dur=0;run; *45;

/*remove those who had PPI during 2000-2002*/
proc sql;
create table p.opppi_mi_oralclean_2 as
select * from p.opppi_mi_oralclean where reference_key not in (select reference_key from p.ppi_pb_0002);
quit; *279335,  HC same as p.opppi_mi_oralclean;

/*remove those who had IP PPIs before first OP PPIs and remove patients on non-oral*/
proc freq data=opppi_mi;
table route;run;
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
create table p.opppi_mi_oralclean_3 as
select * from p.opppi_mi_oralclean_2 where reference_key not in (select reference_key from ip_op2);
quit; *67408;

proc sql;
create table ppi_ip_0314_RC as
select * from ppi_ip_0314 where reference_key not in (select reference_key from ip_op2);
quit; *109095;
proc sql;
create table an.ppi_ip_0314_RC as
select *, min(rxst) as IP_RC format yymmdd10. from ppi_ip_0314_RC group by reference_key;
quit;
proc sort data=an.ppi_ip_0314_RC nodupkey;
by reference_key;
run; *5256;

/*key LC data into the dataset*/
proc sql;
create table p.opppi_mi_oralclean_3 as
select * from p.opppi_mi_oralclean_3 A left join (select min_lc from lc.pat_lc B)
on A.reference_key=B.reference_key;
quit;*67408;

/*key right censored IP PPIs/other routes into the dataset*/
proc sql;
create table p.opppi_mi_oralclean_3 as
select * from p.opppi_mi_oralclean_3 A left join (select IP_RC from an.ppi_ip_0314_RC B)
on A.reference_key=B.reference_key;
quit; *67408;
data p.opppi_mi_oralclean_3;
set p.opppi_mi_oralclean_3;
lc12=min_lc+365;
y1=input("2003/01/01", yymmdd10.);
y2=input("2014/12/31", yymmdd10.);
st_st=max(dob, y1, lc12);
st_en=min(dod, y2, IP_RC);
format lc12 y1 y2 st_st st_en IP_RC yymmdd10.;
run; *67408;
data remove;
set p.opppi_mi_oralclean_3;
if st_st>st_en or ppirxen<st_st;
run; *520 entry;
data p.opppi_mi_oralclean_3;
set p.opppi_mi_oralclean_3;
if ppirxst>st_en then delete;
run; *27331;
proc sql;
create table p.opppi_mi_oralclean_3 as
select * from p.opppi_mi_oralclean_3 where reference_key not in (select reference_key from remove);
quit; *26830;

data p.opppi_mi_oralclean_3;
set p.opppi_mi_oralclean_3;
if ppirxst<st_st and ppirxen>=st_st then ppirxst=st_st;
if ppirxen>st_en and ppirxst<=st_en then ppirxen=st_en;
run; *26830 entries;

data p.opppi_mi_oralclean_3;
set p.opppi_mi_oralclean_3;
new_dur=ppirxen-ppirxst+1;
run;

proc sort data=p.opppi_mi_oralclean_3 nodupkey out=hc;
by reference_key;
run; *7265;
/**************************************
*************************************
*************************************
*************************************
Cohort for patients who were prescribed PPI for up to 8 weeks
*************************************
*************************************
*************************************
***************************************/

*Cohort 1: only consider rxen-rxst+1 (duration) prescription start and end date;

*exclude patients whose PPIs prescription more than 8 weeks during ob period;
data p.ppi_lodur;
set p.opppi_mi_oralclean_3;
if new_dur>56;run; *16321;
proc sql;
create table p.ppi_shdur as
select * from p.opppi_mi_oralclean_3 where reference_key not in (select reference_key from p.ppi_lodur);
quit; *5382;

proc sort data=p.ppi_shdur nodupkey out=hc;
by reference_key;
run; *3580;
*Cohort 2: only consider dispensing_duration available in CDARS dataset
not yet updated;
data p.ppi8wks_disdur;
set opppi_mi_oralclean_4;
if 0<dis_dur<=56;run; *;

*Cohort 3: only consider calculated duration available in CDARS dataset
not yet updated;
data p.ppi8wks_caldur;
set opppi_mi_oralclean_4;
if 0<cal_dur<=56;run; *;

/*handle overlapping*/
data p.oralclean_coh1;
set p.ppi_shdur;
run; *after overlap 1d apart: , 30dapart: 3904 ;
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
%consec30d(max=80, input=p.oralclean_coh1, patid=reference_key, rxst=ppirxst, rxen=ppirxen);


data remove;
set p.oralclean_coh1;
if st_st>st_en or ppirxen<st_st;
run; *0 entry;
data p.oralclean_coh1;
set p.oralclean_coh1;
if ppirxst>st_en then delete;
run; *3904;
proc sql;
create table p.oralclean_coh1 as
select * from p.oralclean_coh1 where reference_key not in (select reference_key from remove);
quit; *3904;

data p.oralclean_coh1;
set p.oralclean_coh1;
if ppirxst<st_st and ppirxen>=st_st then ppirxst=st_st;
if ppirxen>st_en and ppirxst<=st_en then ppirxen=st_en;
run; *3904 entry;
proc sort data=p.oralclean_coh1 nodupkey out=hc;
by reference_key;run; *3580;


/******************************************
*******************************************
*******************************************
identify MI using admission date, 
use only A&E and inpatient D1 data**********
*******************************************
*******************************************
*******************************************/
data dx.ppi_allmi;
set dx.ppi_allmi;
refd=input(reference_date, yymmdd10.);
format refd yymmdd10.;
run;
proc freq data=dx.ppi_allmi;
table All_Diagnosis_Code__ICD9_;run;

proc sql;
create table p.ppi_allmi_min as
select min(refd) as min_refd, * from dx.ppi_allmi group by reference_key;
quit;
data p.ppi_allmi_min;
set p.ppi_allmi_min;
format min_refd yymmdd10.;
run;

*IP;
data allmi_min_ip;
set p.ppi_allmi_min;
if Patient_Type__IP_OP_A_E_="I";run; *59437;
data dx.ppi_mistrokeip;
set dx.ppi_mistrokeip;
admd=input(Admission_Date__yyyy_mm_dd_, yymmdd10.);
dischd=input(Discharge_Date__yyyy_mm_dd_, yymmdd10.);
format admd dischd yymmdd10.;run; *580064;
* key adm, discharge date to mi_min_ip;
proc sql;
create table allmi_min_ip_adm as
select * from allmi_min_ip A left join (select admd, dischd, Dx_Px_code, Dx_Px_Rank, Comment from dx.ppi_mistrokeip B)
on A.reference_key=B.reference_key and A.All_Diagnosis_Code__ICD9_=B.Dx_Px_code;
quit;
data allmi_min_ip_adm;
set allmi_min_ip_adm;
if admd<refd<=dischd or admd=refd=dischd;run;
*Find min date for admission date;
proc sql;
create table allmi_min_ip_adm as
select *, min(admd) as tempd from allmi_min_ip_adm group by reference_key;quit;
data allmi_min_ip_adm;
set allmi_min_ip_adm;
format tempd yymmdd10.;run;
data allmi_min_ip_adm;
set allmi_min_ip_adm;
if ~missing(admd) and admd=tempd;run; *need to keep which entry has D1;
*OP and AE;
data allmi_min_ao;
set p.ppi_allmi_min;
if Patient_Type__IP_OP_A_E_="A" or Patient_Type__IP_OP_A_E_="O";run; *3198;
data allmi_min_ao;
set allmi_min_ao;
if min_refd=refd;run; *2416;
data allmi_min_ao;
set allmi_min_ao;
tempd=min_refd;format tempd yymmdd10.;run;
data allmi_min_ao;
set allmi_min_ao;
if Patient_Type__IP_OP_A_E_="A" then pattype=1;
if Patient_Type__IP_OP_A_E_="O" then pattype=0;
proc sort data=allmi_min_ao;
by reference_key decending pattype;run; 
proc sort data=allmi_min_ao nodupkey;
by reference_key;run; *2200;
*combine A with IP;
data allmi_min_all;
set allmi_min_ao allmi_min_ip_adm;run; *42070;
proc sql;
create table p.allmi_date as
select *, min(tempd) as eventd from allmi_min_all group by reference_key;
quit; *42070;
data p.allmi_date;
set p.allmi_date;
if eventd=tempd;
format eventd yymmdd10.;run;
data p.allmi_date;
set p.allmi_date;
if Patient_Type__IP_OP_A_E_="A" then pat_type=1;
if Patient_Type__IP_OP_A_E_="I" then pat_type=0;run;
proc sort data=p.allmi_date;
by reference_key decending pat_type Dx_Px_Rank;run;
proc sort data=p.allmi_date nodupkey;
by reference_key;run; *36114;
*only keep IP with D1;
data p.allmi_date;
set p.allmi_date;
if Patient_Type__IP_OP_A_E_="O" then delete;run; *35950;
data p.allmi_date;
set p.allmi_date;
if Patient_Type__IP_OP_A_E_="I" and Dx_Px_Rank~="D1" then delete;run; *27686;

/******************************************
*******************************************
*******************************************
***identify MI patients;
*******************************************
*******************************************
*******************************************/
proc sql;
create table p.ppi_mi_coh1 as
select * from p.oralclean_coh1 A left join (select reference_key, eventd, All_Diagnosis_Code__ICD9_, Diagnosis_Comment from p.allmi_date B)
on A.reference_key=B.reference_key where ~missing(eventd);
quit; *2806;
data p.ppi_mi_coh1;
set p.ppi_mi_coh1;
if st_st<=eventd<=st_en;
run; *1639;
proc sort data=p.ppi_mi_coh1 nodupkey out=ppi_mi_hc;
by reference_key;run; *1506;
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
create table p.ppi_mi_coh1_adult as
select * from p.ppi_mi_coh1 where reference_key not in (select reference_key from child);
quit; *1639;
proc sort data=p.ppi_mi_coh1_adult nodupkey out=a;
by reference_key;run; *1506;
data a;
set p.ppi_mi_coh1_adult;
if ~missing(dod) and eventd>dod;
run; *0 entry;

data p.ppi_mi_rformat;
set p.ppi_mi_coh1_adult;
if sex="M" then gend=1;
if sex="F" then gend=0;run;
data p.ppi_mi_rformat;
set p.ppi_mi_rformat;
drop sex;run;

data p.ppi_mi_rformat;
set p.ppi_mi_rformat;
indiv=reference_key;
sex=gend;
eventday=datdif(dob, eventd, 'act/act');
start=datdif(dob, st_st, 'act/act');
end=datdif(dob, st_en, 'act/act');
adrug=datdif(dob, ppirxst, 'act/act');
aedrug=datdif(dob, ppirxen, 'act/act');
keep indiv sex eventday start end adrug aedrug;run;

PROC EXPORT DATA= p.ppi_mi_rformat
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\SAS export for R\ppi30_mi_coh1.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;

*                            exp(coef) exp(-coef) lower .95 upper .95
factor(mi1_reformat$adrug)1 1.395e+00  7.167e-01    0.8824     2.206
factor(mi1_reformat$adrug)2 3.857e+00  2.593e-01    2.8549     5.210
factor(mi1_reformat$adrug)3 2.406e+00  4.156e-01    1.8494     3.131;

proc sort data=p.ppi_mi_coh1_adult nodupkey out=ppi_hc;
by reference_key;run; *1506;

/*************************************************************
**************************************************************
Cut risk periods*
**************************************************************
**************************************************************/

/*reshape the datasets*/
data ppi_mi_coh1_adult;
set p.ppi_mi_coh1_adult;
keep reference_key ppirxst ppirxen st_st st_en eventd;
run;

proc freq data=p.ppi_mi_coh1_adult;
table drug_name;
run;
proc freq data=p.ppi_mi_coh1_adult;
table new_dur;
run;

*add non-risk period;
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
run; *14618;
proc sort data=allperiod;
by reference_key pst pen;
run; 
data allperiod;
set allperiod;
if pst>pen or pst>st_en or pen<st_st then delete;
run; *8612;
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
set p.ppi_mi_coh1_adult;
keep reference_key dob st_en;
run;
data a;
set a;
age=year(st_en)-year(dob);
run;
proc sort data=a;
by decending age;run; *109 is the largest so cut 110 below;

data age;
set p.ppi_mi_coh1_adult;
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
run; *note:, after:21602 stop macro until entries in aa is 0;

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
run; *, after:20084 stop macro until entries in aa is 0;
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
%multi(max=4, input=all3);

data all4;
set all2 all3;
run; *note:41666, after:21583 stop macro until entries in aa is 0;

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
run; *21583;
data aa;
set a;
if ~missing(prxen) and pst-prxen~=1;run; *0, should be correct as it turns to 0;

/*check pst and pen outside observation period*/
data a;
set all4;
if pst>st_en or pen<st_st;run; *0;


/*can key in drug indicator now*/
data p.primary_risk;
set all4;
drop ns_rxst ns_rxen;
run;
proc sql;
create table primary_risk as
select * from p.primary_risk A left join (select pst as pre_pst, pen as pre_pen from prerisk B)
on A.reference_key=B.reference_key;
quit; *24782;
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
run; *21583;


proc sql;
create table primary_risk2 as
select * from primary_risk A left join (select pst as postst_1, pen as posten_1 from ppi_mi_coh1_adult B)
on A.reference_key=B.reference_key;
quit; *24782;
data primary_risk2;
set primary_risk2;
if pst<=postst_1<=pen or pst<=posten_1<=pen or postst_1<=pst<=posten_1 or postst_1<=pen<=posten_1 then op_p1=1;
run;
proc sort data=primary_risk2;
by reference_key pst pen decending op_p1;
run;
proc sort data=primary_risk2 nodupkey;
by reference_key pst pen;
run; *21583;

proc sql;
create table primary_risk3 as
select * from primary_risk2 A left join (select pst as postst_2, pen as posten_2 from postrisk1 B)
on A.reference_key=B.reference_key;
quit; *24782;
data primary_risk3;
set primary_risk3;
if pst<=postst_2<=pen or pst<=posten_2<=pen or postst_2<=pst<=posten_2 or postst_2<=pen<=posten_2 then op_p2=1;
run;
proc sort data=primary_risk3;
by reference_key pst pen decending op_p2;
run;
proc sort data=primary_risk3 nodupkey;
by reference_key pst pen;
run; *21583;

proc sql;
create table primary_risk4 as
select * from primary_risk3 A left join (select pst as postst_3, pen as posten_3 from postrisk2 B)
on A.reference_key=B.reference_key;
quit; *24782;
data primary_risk4;
set primary_risk4;
if pst<=postst_3<=pen or pst<=posten_3<=pen or postst_3<=pst<=posten_3 or postst_3<=pen<=posten_3 then op_p3=1;
run;
proc sort data=primary_risk4;
by reference_key pst pen decending op_p3;
run;
proc sort data=primary_risk4 nodupkey;
by reference_key pst pen;
run; *21583;

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
/*prefer pre-risk than post-risk*/
data primary_risk4;
set primary_risk4;
if op=1 and op_p1=1 then r=1;
if op=1 and op_p2=1 then r=1;
if op=1 and op_p3=1 then r=1;
run;
/*when two prescriptions overlap, prefer previous current risk window!
check all op_p1=1 and op_p2=1, op_p2 lower earlier than op_p1*/
data z;
set primary_risk4;
if (op_p1=1 and op_p2=1) and (postst_2<postst_1);run; *0 just for checking;
data primary_risk4;
set primary_risk4;
if (op_p1=1 and op_p2=1) or (op_p1=1 and op_p3=1) then r=2;
run;
data primary_risk4;
set primary_risk4;
if (op_p2=1 and op_p3=1) then r=3;
run;

data primary_risk4;
set primary_risk4;
if missing(r) then r=0;
drop op op_p1 op_p2 op_p3 pre_pst pre_pen postst_1 posten_1 postst_2 posten_2 postst_3 posten_3;run;
proc sort data=primary_risk4;
by reference_key pst pen r;run; *21583;


proc sql;
create table p.primary_risk_final as
select * from primary_risk4 A left join (select sex as gen from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *21583;
data p.primary_risk_final;
set p.primary_risk_final;
if gen='M' then sex=1;
if gen='F' then sex=0;
run;
data p.primary_risk_final;
set p.primary_risk_final;
drop gen;
run;
proc sql;
create table p.primary_risk_final as
select * from p.primary_risk_final A left join (select dob, ppirxst, eventd from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *21583;


/*some of the risk periods chopped due to different pst and pen overlapped >>>need to be recombined
for example reference_key=1826865: the pre-risk period 17/2/2011-18/2/2011 and 19/2/2011-2/3/2011 are both pre-risk period
they were chopped due to the previous post-risk period, so need to combine it to be 17/2/2011-2/3/2011 for the whole pre-risk period

4 people have this problem
869674
1467772
1826865
2425738*/

data combinerisk;
set p.primary_risk_final;
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
run;
data combinerisk;
set combinerisk;
lag_indiv=lag(reference_key);
lag_r=lag(r);
run;
data combinerisk2;
set combinerisk;
if reference_key~=lag_indiv or lag_r~=r or m_dob=m_pst or d_dob=d_pst then n+1;
run;
proc sql;
create table combinerisk3 as
  select *, min(pst) as min_pst format yymmdd10., max(pen) as max_pen format yymmdd10. from combinerisk2 group by n;
quit;
proc sort data=combinerisk3 nodupkey;
by n;
run;
data p.primary_risk_final;
set combinerisk3;
drop pst pen;
rename min_pst=pst max_pen=pen;
drop lag_indiv n lag_r m_dob d_dob m_pst d_pst;
run; *21579;

/*checked on 18 July 2016 in other editors
whether all pre-risk has 14 days, if not then not favor pre-risk.
Now only 5 people has pre-risk<14 because they start treatment near to the study start
same for multiple exposures program
so program is correct*/
data b;
set p.primary_risk_final;
int=pen-pst+1;
if r=1 and int<14;
run;

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
if ~missing(Prxst)and 0<=Prxst-&rxen<=1 then do &rxen=Prxen;
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
%consec30d(max=10, input=b, patid=reference_key, rxst=pst, rxen=pen);
data bb;
set b;
int2=pen-pst+1;
if int2<14;
run;
proc sql;
create table abc as
select * from p.primary_risk_final where reference_key in (select reference_key from bb);
quit;

data p.primary_risk_final;
set p.primary_risk_final;
if pst<=eventd<=pen then event=1;
else event=0;
interval=pen-pst+1;
age=year(pst)-year(dob);
censor=1;
run;
proc freq data=p.primary_risk_final;
table r*event;
run;
proc univariate data=p.primary_risk_final;
var interval; run; *;
proc univariate data=p.primary_risk_final;
var interval; where r=0;run; *;
proc univariate data=p.primary_risk_final;
var interval; where r=1;run; *;
proc univariate data=p.primary_risk_final;
var interval; where r=2;run; *;
proc univariate data=p.primary_risk_final;
var interval; where r=3;run; *;
proc univariate data=p.primary_risk_final;
var interval; where r=4;run; *;

proc sql;
create table poisson as
select *, max(ppirxst) as max_adrug format yymmdd10. from p.primary_risk_final group by reference_key;
quit;

data poisson2;
set poisson;
indiv=reference_key;
gender=sex;
astart=datdif(dob, st_st, 'act/act');
adrug=datdif(dob, max_adrug, 'act/act');
aevent=datdif(dob, eventd, 'act/act');
aend=datdif(dob, st_en, 'act/act');
present=censor;
exposed=r;
group=age;
lower=datdif(dob, pst, 'act/act');
upper=datdif(dob, pen, 'act/act');
keep indiv astart aend adrug aevent gender present exposed group lower upper;run;

proc sort data=poisson2;
by indiv lower upper;
run;
data poisson3;
set poisson2;
if lower<=aevent<=upper then event=1;
else event=0;run;
proc freq data=poisson3;
table exposed*event;
run;
PROC EXPORT DATA= poisson2
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\SAS export for R\manuscript\primary_risk_final.txt" 
            DBMS=DLM REPLACE;
     PUTNAMES=NO;
RUN;

data primary_risk_final;
set p.primary_risk_final;
int=1;
if r=0 then r=5;
run;
data primary_risk_final;
set primary_risk_final;
keep reference_key int interval r age event;
run;
OPTIONS nodate nonumber;

/* Define macro and output directories */
%LET macdir = C:\Users\Angel YS Wong\Desktop\sccs package\macro;
%INCLUDE "&macdir\poisreg.sas";
%poisreg(data=primary_risk_final,y=event,covar=int, class=r age,offset=interval,elim=reference_key
        ,prntyn=Y,title="clar_aw");

*just to check if its same as above, yes*/
data a;
set p.primary_risk_final;
if r=1 then Risk1=1;
if r=2 then Risk2=1;
if r=3 then Risk3=1;
if r=4 then Risk4=1;
run;
data a;
set a;
if missing(Risk1) then Risk1=0;
if missing(Risk2) then Risk2=0;
if missing(Risk3) then Risk3=0;
if missing(Risk4) then Risk4=0;
int=1;
run;

%poisreg(data=a,y=event,covar=int Risk1 Risk2 Risk3 Risk4, class=age,offset=interval,elim=reference_key
        ,prntyn=Y,title="clar_aw");

/*ratio of treatent duration*/

/*remove first day of treatment from the analysis*/
data a;
set p.primary_risk_final;
if r=2 and pst=eventd;
run;

data poisson2;
set poisson2;
if lower<=aevent<=upper then event=1;
else event=0;
run;
data a;
set poisson2;
if event=1 and aevent=lower and exposed=2;
run; *3;

/*calculate the mean age at cohort entry and event occurence
and proportion of sex*/
data age;
set p.primary_risk_final;
age_event=(eventd-dob)/365.25;
age_st_st=(st_st-dob)/365.25;
run;
proc sort data=age nodupkey;
by reference_key;
run; *1506;
proc univariate data=age;
var age_event;
run;
proc univariate data=age;
var age_st_st;
run;
proc freq data=age;
table sex;
run;

*check patterns of no of prescription for short-term PPIs;
proc sql;
create table no_rx_short_ppi as
select * from p.ppi_shdur where reference_key in (select reference_key from p.primary_risk_final);
quit;
proc sql;
create table no_rx_short_ppi_count as
select *, count(*) as count_Rx from no_rx_short_ppi group by reference_key ;
quit;
proc univariate data=no_rx_short_ppi_count;
var count_Rx;run; *1;
