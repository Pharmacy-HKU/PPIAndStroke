/**************************************
*************************************
Created
Purpose: to clean the datasets for investigation the association between proton pump inhibitors and stroke

Stroke includes haemorrhagic stroke and ischaemic stroke in the primary analysis

risk windows:
day 1-14
days 15-30
days 31-60
and remove exposed time longer than the risk windows

In this SAS editor, also identified anticoagulants and antiplatelets for further adjustment
*************************************
**************************************/
libname st "C:\Users\Angel YS Wong\Desktop\PPIs & stroke";
libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname an "C:\Users\Angel YS Wong\Desktop\PPI\program\drug";
libname lc "C:\Users\Angel YS Wong\Desktop\PPI\program\lc";

/*share drive*/
libname st "W:\Angel\MPhil\cross_check\PPIs_MI\SCCS_original\SAS raw files";
libname p "W:\Angel\MPhil\cross_check\PPIs_MI\SCCS_original\SAS raw files";
libname dx "W:\Angel\MPhil\cross_check\PPIs_MI\SCCS_original\SAS raw files";
libname an "W:\Angel\MPhil\cross_check\PPIs_MI\SCCS_original\SAS raw files";
libname lc "W:\Angel\MPhil\cross_check\PPIs_MI\SCCS_original\SAS raw files";

/*new share drive - fm*/
libname st "D:\OneDrive - connect.hku.hk\Projects\papers with others\Angel Wong\PPI and stroke\data\SAS raw files";
libname p "D:\OneDrive - connect.hku.hk\Projects\papers with others\Angel Wong\PPI and stroke\data\SAS raw files";
libname dx "D:\OneDrive - connect.hku.hk\Projects\papers with others\Angel Wong\PPI and stroke\data\SAS raw files";
libname an "D:\OneDrive - connect.hku.hk\Projects\papers with others\Angel Wong\PPI and stroke\data\SAS raw files";
libname lc "D:\OneDrive - connect.hku.hk\Projects\papers with others\Angel Wong\PPI and stroke\data\SAS raw files";



/*export text files for Joe to crosscheck*/
PROC EXPORT DATA= p.ppi_pb_0312
            OUTFILE= "D:\OneDrive - connect.hku.hk\Projects\papers with others\Angel Wong\PPI and stroke\data\ppi_pb_0312.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;
PROC EXPORT DATA= p.ppi_pb_1314
            OUTFILE= "D:\OneDrive - connect.hku.hk\Projects\papers with others\Angel Wong\PPI and stroke\data\ppi_pb_1314.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;
PROC EXPORT DATA= dx.dx_all9315jj
            OUTFILE= "D:\OneDrive - connect.hku.hk\Projects\papers with others\Angel Wong\PPI and stroke\data\dx_all9315jj.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;
PROC EXPORT DATA= p.ppi_pb_0002
            OUTFILE= "D:\OneDrive - connect.hku.hk\Projects\papers with others\Angel Wong\PPI and stroke\data\ppi_pb_0002.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;
PROC EXPORT DATA= lc.ppi_alllc
            OUTFILE= "D:\OneDrive - connect.hku.hk\Projects\papers with others\Angel Wong\PPI and stroke\data\ppi_alllc.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;
PROC EXPORT DATA= dx.ppi_mistrokeip
            OUTFILE= "D:\OneDrive - connect.hku.hk\Projects\papers with others\Angel Wong\PPI and stroke\data\ppi_mistrokeip.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;
PROC EXPORT DATA= an.alldrug9314
            OUTFILE= "D:\OneDrive - connect.hku.hk\Projects\papers with others\Angel Wong\PPI and stroke\data\alldrug9314.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;
/* identify stroke for all dx*/
proc sql;
create table dx.ppi_allstroke as
select * from dx.dx_all9315jj where All_Diagnosis_Code__ICD9_ like '433.01'
or All_Diagnosis_Code__ICD9_ like '433.11'
or All_Diagnosis_Code__ICD9_ like '433.21'
or All_Diagnosis_Code__ICD9_ like '433.31'
or All_Diagnosis_Code__ICD9_ like '433.81'
or All_Diagnosis_Code__ICD9_ like '433.91'
or All_Diagnosis_Code__ICD9_ like '434%'
or All_Diagnosis_Code__ICD9_ like '436%'
or All_Diagnosis_Code__ICD9_ like '437.0%'
or All_Diagnosis_Code__ICD9_ like '437.1%'
or All_Diagnosis_Code__ICD9_ like '430%'
or All_Diagnosis_Code__ICD9_ like '431%'
or All_Diagnosis_Code__ICD9_ like '432%';
quit; *138778;
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
run; *468259;

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
quit; *395955;

proc sort data=st.opppi_stroke_oralclean nodupkey out=hc;
by reference_key;
run; *51307;

/*remove those who had IP PPIs before first OP PPIs and remove patients on non-oral*/
proc freq data=opppi_stroke;
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
select * from pbppi0314_rm where reference_key in (select reference_key from st.opppi_stroke_oralclean);
quit; *1064229;
data ppi_ip_0314;
set ppi_ip_0314;
rxst=input(prescription_start_date, yymmdd10.);
format rxst yymmdd10.;
run; *no missing data for rxst/rxen in this dataset;

proc sql;
create table opppi_stroke_oralclean as
select *, min(ppirxst) as min_op format yymmdd10. from st.opppi_stroke_oralclean group by reference_key;
quit;
proc sql;
create table ip_op as
select * from opppi_stroke_oralclean A left join (select rxst as ip_rxst from ppi_ip_0314 B)
on A.reference_key=B.reference_key;
quit; *12119252;
data ip_op2;
set ip_op;
if ~missing(ip_rxst) and ip_rxst<=min_op;
run; *2447911,  HC;

proc sql;
create table st.opppi_stroke_oralclean_3 as
select * from st.opppi_stroke_oralclean where reference_key not in (select reference_key from ip_op2);
quit; *127071;

proc sql;
create table ppi_ip_0314_RC as
select * from ppi_ip_0314 where reference_key not in (select reference_key from ip_op2);
quit; *178387;
proc sql;
create table st.ppi_ip_0314_RC as
select *, min(rxst) as IP_RC format yymmdd10. from ppi_ip_0314_RC group by reference_key;
quit;
proc sort data=st.ppi_ip_0314_RC nodupkey;
by reference_key;
run; *9852;

/*key LC data into the dataset*/
proc sql;
create table st.opppi_stroke_oralclean_3 as
select * from st.opppi_stroke_oralclean_3 A left join (select min_lc from lc.pat_lc B)
on A.reference_key=B.reference_key;
quit;*127071, zero missing;

/*key right censored IP PPIs/other routes into the dataset*/
proc sql;
create table st.opppi_stroke_oralclean_3 as
select * from st.opppi_stroke_oralclean_3 A left join (select IP_RC from st.ppi_ip_0314_RC B)
on A.reference_key=B.reference_key;
quit; *127071;
data st.opppi_stroke_oralclean_3;
set st.opppi_stroke_oralclean_3;
lc12=min_lc+365;
y1=input("2003/01/01", yymmdd10.);
y2=input("2014/12/31", yymmdd10.);
st_st=max(dob, y1);
st_en=min(dod, y2, IP_RC);
format lc12 y1 y2 st_st st_en IP_RC yymmdd10.;
run; *127071;

data remove;
set st.opppi_stroke_oralclean_3;
if st_st>st_en or ppirxen<st_st;
run; *939 entry(FM: only one records); 
data st.opppi_stroke_oralclean_3;
set st.opppi_stroke_oralclean_3;
if ppirxst>st_en then delete;
run; *59766;
proc sql;
create table st.opppi_stroke_oralclean_3 as
select * from st.opppi_stroke_oralclean_3 where reference_key not in (select reference_key from remove);
quit; *59765;

proc sort data=st.opppi_stroke_oralclean_3 nodupkey out=hc;
by reference_key;
run; *16431;
/*handle overlapping*/
data st.oralclean_coh1;
set st.opppi_stroke_oralclean_3;
run; *after overlap 1d apart: , 30dapart: 20082 ;
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
run; *;
proc sql;
create table st.oralclean_coh1 as
select * from st.oralclean_coh1 where reference_key not in (select reference_key from remove);
quit; *;

data st.oralclean_coh1;
set st.oralclean_coh1;
if ppirxst<st_st and ppirxen>=st_st then ppirxst=st_st;
if ppirxen>st_en and ppirxst<=st_en then ppirxen=st_en;
run; *20082 entry;
proc sort data=st.oralclean_coh1 nodupkey out=hc;
by reference_key;run; *16431;


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
* key adm, discharge date to arrh_min_ip;
data ppi_mistrokeip;
set dx.ppi_mistrokeip;
admd=input(Admission_Date__yyyy_mm_dd_, YYMMDD10.);
dischd=input(Discharge_Date__yyyy_mm_dd_, YYMMDD10.);
format admd dischd yymmdd10.;
run;

proc sql;
create table allstroke_min_ip_adm as
select * from allstroke_min_ip A left join (select admd, dischd, Dx_Px_code, Dx_Px_Rank, Comment from ppi_mistrokeip B)
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
quit; *17457;
data st.ppi_stroke_coh1;
set st.ppi_stroke_coh1;
if st_st<=eventd<=st_en;
run; *10965;
proc sort data=st.ppi_stroke_coh1 nodupkey out=ppi_stroke_hc;
by reference_key;run; *8979;
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
quit; *10958;
proc sort data=st.ppi_stroke_coh1_adult nodupkey out=ppi_hc;
by reference_key;run; *8974;
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
run; *107186;
proc sort data=allperiod;
by reference_key pst pen;
run; 
data allperiod;
set allperiod;
if pst>pen or pst>st_en or pen<st_st then delete;
run; *63311;
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
run; *note:146742, after: stop macro until entries in aa is 0;

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
run; *, after: 146742 stop macro until entries in aa is 0;
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
run; *note: 293484, 146615 stop macro until entries in aa is 0;

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
run; *146615;


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
run; *146615;

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
run; *146615;

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
run; *146615;

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
run; *146615;

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
if ~missing(postst_4) and op_p4=1 then delete;run; *137025;
data primary_risk5;
set primary_risk5;
if missing(r) then r=0;
drop op op_p1 op_p2 op_p3 op_p4 pre_pst pre_pen postst_1 posten_1 postst_2 posten_2 postst_3 posten_3 postst_4 posten_4;run;
proc sort data=primary_risk5;
by reference_key pst pen r;run; *137025;

proc sort data=st.ppi_stroke_coh1_adult nodupkey out=ppi_hc;
by reference_key;
run;
proc sql;
create table st.primary_risk_final as
select * from primary_risk5 A left join (select sex as gen from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *137025;
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
quit; *137025;


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
data st.primary_risk_final;
set combinerisk3;
drop pst pen;
rename min_pst=pst max_pen=pen;
drop lag_indiv n lag_r m_dob d_dob m_pst d_pst yr_pst;
run; *137005;

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
run; *6795;
proc sql;
create table st.primary_risk_final2 as
select * from st.primary_risk_final where reference_key not in (Select reference_key from rm);
quit; *130210;
proc sort data=st.primary_risk_final2 nodupkey out=final_hc;
by reference_key;
run; *8485;
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
            OUTFILE= "D:\OneDrive - connect.hku.hk\Projects\papers with others\Angel Wong\PPI and stroke\st.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=NO;
RUN;

*            exp(coef) exp(-coef) lower .95 upper .95
egroup2   9.184e-01  1.089e+00    0.7144    1.1807
egroup3   1.005e+00  9.954e-01    0.7874    1.2818
egroup4   8.073e-01  1.239e+00    0.6211    1.0491
egroup5   7.758e-01  1.289e+00    0.6326    0.9515    ;
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
