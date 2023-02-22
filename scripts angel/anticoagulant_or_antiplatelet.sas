/*Created on 15 May 2017
updated on 11 Oct 2017
Purpose: to adjust anticoagulants/antiplatelet
in the primary analysis and sensitivity analysis*/

libname st "C:\Users\Angel YS Wong\Desktop\PPIs & stroke";

/*identify patients on antiplatelet or anticoagulants*/
proc sql;
create table st.antiplatalet as
select * from an.alldrug9314 where
Therapeutic_Classification__BNF_ like '2.9%'
or drug_name like 'REOPRO %'
or drug_name like 'ACEPRIN %' or drug_name like 'ACETYLSALICYLIC ACID %' or drug_name like 'ASCOT %' or drug_name like 'ASP %' or drug_name like 'ASPI-COR %' or drug_name like 'ASPICOR %' or drug_name like 'ASPI COR %' or drug_name like ' ASPILETS %' or drug_name like 'ASTRIX %' or drug_name like 'BOKEY EMC %' or drug_name like 'DISPRIN %' or drug_name like 'ECOPIRIN %' or drug_name like 'FUSEN %' or drug_name like 'PROPIRIN %' or drug_name like 'QUALITEA %' or drug_name like 'REPISPRIN %'
or drug_name like 'CARDIPRIN %' 
or drug_name like 'AGGRENOX %' 
or drug_name like 'COPLAVIX %'
or drug_name like 'ANTIPLATT %' or drug_name like 'CLAVIX %' or drug_name like 'CLOFLOW %' or drug_name like 'CLOGIN %' or drug_name like 'CLOPIDEX %' or drug_name like 'CLOPIDOREX %' or drug_name like 'CLOPIMED %' or drug_name like 'CLOPIRIGHT %' or drug_name like 'CLOPISTAD %' or drug_name like 'CLOPIVAS %' or drug_name like 'CLOPIVID %' or drug_name like 'CLOPRA %' or drug_name like 'CLOPREZ %' or drug_name like 'COPALEX %' or drug_name like 'COPIDREL %' or drug_name like 'DCLOT %' or drug_name like 'FRELET %' or drug_name like 'GRIDOKLINE %' or drug_name like 'LOPIREL %' or drug_name like 'NORPLAT %' or drug_name like 'PLAGERINE %' or drug_name like 'PLAVIX %' or drug_name like 'PROGREL %'   
or drug_name like 'DIPAMOL %' or drug_name like 'LIDAMOLE %' or drug_name like 'PERSANTIN %' or drug_name like 'PROCARDIN %' or drug_name like 'PYMOTIN %'
or drug_name like 'INTEGRILIN %'
or drug_name like 'EFFIENT %'
or drug_name like 'BRILINTA %' 
or drug_name like 'APLAKET %' or drug_name like 'TICLID %' or drug_name like 'TICLOPIDINA TROMBOPAT %' or drug_name like 'TICLOPIDINE %' or drug_name like 'TICLOPINE %' or drug_name like 'TIPIDIN %'
or drug_name like 'AGGRASTAT %'
or drug_name like '%ABCIXIMAB%'
or drug_name like '%ASPIRIN%'
or drug_name like '%CLOPIDOGREL%'
or drug_name like '%DIPYRIDAMOLE%'
or drug_name like '%EPTIFIBATIDE%'
or drug_name like '%PRASUGREL%'
or drug_name like '%TICAGRELOR%'
or drug_name like '%TICLOPIDINE%'
or drug_name like '%TIROFIBAN%';quit;
proc freq data=st.antiplatalet;
table Therapeutic_Classification__BNF_;run;
proc freq data=st.antiplatalet;
table drug_name;run;

*remove trial medicine (could be placebo);
proc sql;
delete from st.antiplatalet 
where drug_name like '%CHARISMA STUDY%'
or drug_name like '%PLACEBO%'
or drug_name like '%PLACEABO%'
or drug_name like '%PICASSO STUDY%';
quit; *185 deleted;

proc sql;
create table st.anticoag as
select * from an.alldrug9314 where 
Therapeutic_Classification__BNF_ like '2.8.2%' 
or drug_name like 'ELIQUIS %'
or drug_name like 'PRADAXA %'
or drug_name like 'CLEXANE %'
or drug_name like 'ARIXTRA %'
or drug_name like 'FRAXIPARINE %'
or drug_name like 'XARELTO %'
or drug_name like 'INNOHEP %'
or drug_name like 'ORFARIN %'
or drug_name like '%ACENOCOUMAROL%' or drug_name like '%APIXABAN%'
or drug_name like '%ARGATROBAN%' or drug_name like '%BIVALIRUDIN%'
or drug_name like '%DABIGATRAN%' or drug_name like '%DALTEPARIN%'
or drug_name like '%DANAPAROID%' or drug_name like '%ENOXAPARIN%'
or drug_name like '%EPOPROSTENOL%' or drug_name like '%FONDAPARINUX%' 
or drug_name like '%HEPARIN%' or drug_name like '%NADROPARIN%' 
or drug_name like '%PROTAMINE%' or drug_name like '%RIVAROXABAN%' 
or drug_name like '%TINZAPARIN%' or drug_name like '%WARFARIN%';quit;
proc freq data=st.anticoag;
table Therapeutic_Classification__BNF_;run;
proc freq data=st.anticoag;
table drug_name;run;
*remove trial medicine (could be placebo) or irrelevant drugs;
proc sql;
delete from st.anticoag 
where drug_name like '%PARACETAMOL%'
or drug_name like '%INSULIN ASPART + ASPART PROTAMINE%'
or drug_name like '%PLACEBO%'
or drug_name like '%PLACEABO%';
quit; *57 deleted;
data anticoag_and_antiplate;
set st.anticoag st.antiplatalet;
rxst=input(Prescription_Start_Date, yymmdd10.);
rxen=input(Prescription_End_Date, yymmdd10.);
disd=input(Dispensing_Date__yyyy_mm_dd_, yymmdd10.);
if missing(Prescription_Start_Date) then rxst=disd;
dur=rxen-rxst+1;
format rxst rxen disd yymmdd10.;
run;
data anticoag_and_antiplate;
set anticoag_and_antiplate;
if route='LA' or route='TOPICAL' then delete;
run; *5553642;
data missing_dur;
set anticoag_and_antiplate;
if missing(rxen);run;

*calculate the missing duration;
proc freq data=missing_dur;
table dosage;run;
data anticoag_and_antiplate;
set anticoag_and_antiplate;
if substr(dosage,1,5)='0.007' then dos=0.007;
if substr(dosage,1,3)='0.1' then dos=0.1;
if substr(dosage,1,3)='0,4' then dos=0.4;
if substr(dosage,1,2)='.5' then dos=0.5;
if substr(dosage,1,4)='0,.5' then dos=0.5;
if substr(dosage,1,6)='0.1 NO' then dos=0.1;
if substr(dosage,1,7)='0.15 NO' then dos=0.15;
if substr(dosage,1,7)='0.2 AMP' then dos=0.2;
if substr(dosage,1,6)='0.2 NO' then dos=0.2;
if substr(dosage,1,7)='0.25 NO' then dos=0.25;
if substr(dosage,1,8)='0.25 TAB' then dos=0.25;
if substr(dosage,1,3)='0.3' then dos=0.3;
if substr(dosage,1,7)='0.3  NO' then dos=0.3;
if substr(dosage,1,7)='0.35 NO' then dos=0.35;
if substr(dosage,1,10)='0.384 VIAL' then dos=0.384;
if substr(dosage,1,7)='0.4 AMP' then dos=0.4;
if substr(dosage,1,6)='0.4 NO' then dos=0.4;
if substr(dosage,1,8)='0.4 VIAL' then dos=0.4;
if substr(dosage,1,4)='0.45' then dos=0.45;
if substr(dosage,1,13)='0.5   (300MG)' then dos=0.5;
if substr(dosage,1,6)='0.5 NO' then dos=0.5;
if substr(dosage,1,7)='0.5 AMP' then dos=0.5;
if substr(dosage,1,7)='0.5 TAB' then dos=0.5;
if substr(dosage,1,8)='0.5 VIAL' then dos=0.5;
if substr(dosage,1,8)='0.54 TAB' then dos=0.54;
if substr(dosage,1,3)='0.6' then dos=0.6;
if substr(dosage,1,6)='0.7 NO' then dos=0.7;
if substr(dosage,1,8)='0.7 VIAL' then dos=0.7;
if substr(dosage,1,7)='0.7 AMP' then dos=0.7;
if substr(dosage,1,8)='0.75 TAB' then dos=0.75;
if substr(dosage,1,3)='0.8' then dos=0.8;
if substr(dosage,1,5)='1 TAB' then dos=1;
if substr(dosage,1,5)='1 AMP' then dos=1;
if substr(dosage,1,6)='1 VIAL' then dos=1;
if substr(dosage,1,8)='1    TAB' then dos=1;
if substr(dosage,1,11)='1   (100MG)' then dos=1;
if substr(dosage,1,10)='1   (75MG)' then dos=1;
if substr(dosage,1,10)='1   (80MG)' then dos=1;
if substr(dosage,1,5)='1 CAP' then dos=1;
if substr(dosage,1,4)='1 NO' then dos=1;
if substr(dosage,1,6)='1.4 NO' then dos=1.4;
if substr(dosage,1,3)='1.5' then dos=1.5;
if substr(dosage,1,4)='10.5' then dos=10.5;
if substr(dosage,1,6)='12 AMP' then dos=12;
if substr(dosage,1,6)='12 CAP' then dos=12;
if substr(dosage,1,7)='12 VIAL' then dos=12;
if substr(dosage,1,4)='12.5' then dos=12.5;
if substr(dosage,1,7)='13 VIAL' then dos=13;
if substr(dosage,1,2)='14' then dos=14;
if substr(dosage,1,6)='15 TAB' then dos=15;
if substr(dosage,1,6)='15 AMP' then dos=15;
if substr(dosage,1,7)='15.8 NO' then dos=15.8;
if substr(dosage,1,6)='16 AMP' then dos=16;
if substr(dosage,1,6)='19 AMP' then dos=19;
if substr(dosage,1,5)='2 TAB' then dos=2;
if substr(dosage,1,5)='2 AMP' then dos=2;
if substr(dosage,1,6)='2 VIAL' then dos=2;
if substr(dosage,1,8)='20   AMP' then dos=20;
if substr(dosage,1,6)='25 AMP' then dos=25;
if substr(dosage,1,6)='28 AMP' then dos=28;
if substr(dosage,1,7)='285 AMP' then dos=285;
if substr(dosage,1,8)='2    TAB' then dos=2;
if substr(dosage,1,9)='2   (1MG)' then dos=2;
if substr(dosage,1,10)='2   (80MG)' then dos=2;
if substr(dosage,1,4)='2 NO' then dos=2;
if substr(dosage,1,5)='2 CAP' then dos=2;
if substr(dosage,1,7)='2.5 TAB' then dos=2.5;
if substr(dosage,1,3)='285' then dos=285;
if substr(dosage,1,5)='3 TAB' then dos=3;
if substr(dosage,1,5)='3 AMP' then dos=3;
if substr(dosage,1,6)='3 VIAL' then dos=3;
if substr(dosage,1,8)='30.4 AMP' then dos=30.4;
if substr(dosage,1,7)='3.5 TAB' then dos=3.5;
if substr(dosage,1,2)='35' then dos=35;
if substr(dosage,1,2)='38' then dos=38;
if substr(dosage,1,5)='4 TAB' then dos=4;
if substr(dosage,1,5)='4 AMP' then dos=4;
if substr(dosage,1,6)='4 VIAL' then dos=4;
if substr(dosage,1,8)='4    TAB' then dos=4;
if substr(dosage,1,7)='4.5 TAB' then dos=4.5;
if substr(dosage,1,6)='4  TAB' then dos=4;
if substr(dosage,1,4)='4 NO' then dos=4;
if substr(dosage,1,2)='40' then dos=40;
if substr(dosage,1,2)='41' then dos=41;
if substr(dosage,1,2)='45' then dos=45;
if substr(dosage,1,3)='475' then dos=475;
if substr(dosage,1,4)='5 NO' then dos=5;
if substr(dosage,1,5)='5 AMP' then dos=5;
if substr(dosage,1,6)='5 VIAL' then dos=5;
if substr(dosage,1,6)='55 AMP' then dos=55;
if substr(dosage,1,6)='57 AMP' then dos=57;
if substr(dosage,1,5)='5 TAB' then dos=5;
if substr(dosage,1,7)='5.5 TAB' then dos=5.5;
if substr(dosage,1,5)='57 NO' then dos=57;
if substr(dosage,1,4)='6 NO' then dos=6;
if substr(dosage,1,5)='6 TAB' then dos=6;
if substr(dosage,1,5)='6 AMP' then dos=6;
if substr(dosage,1,6)='6 VIAL' then dos=6;
if substr(dosage,1,7)='6.25 NO' then dos=6.25;
if substr(dosage,1,5)='7 TAB' then dos=7;
if substr(dosage,1,5)='7 AMP' then dos=7;
if substr(dosage,1,6)='7 VIAL' then dos=7;
if substr(dosage,1,6)='78 AMP' then dos=78;
if substr(dosage,1,6)='76 AMP' then dos=76;
if substr(dosage,1,4)='7 NO' then dos=7;
if substr(dosage,1,5)='75 NO' then dos=75;
if substr(dosage,1,6)='75 TAB' then dos=75;
if substr(dosage,1,1)='8' then dos=8;
if substr(dosage,1,2)='85' then dos=85;
if substr(dosage,1,1)='9' then dos=9;
run;
proc freq data=missing_dur;
table drug_frequency;run;
data anticoag_and_antiplate;
set anticoag_and_antiplate;
if substr(drug_frequency,1,2)='AT' then freq=1;
if substr(drug_frequency,1,6)='BEFORE' then freq=1;
if substr(drug_frequency,1,5)='DAILY' then freq=1;
if substr(drug_frequency,1,5)='EIGHT' then freq=8;
if drug_frequency='EVERY EIGHT HOURS' then freq=3;
if substr(drug_frequency,1,10)='EVERY FOUR' then freq=6;
if substr(drug_frequency,1,13)='EVERY SEVENTY' then freq=0.33;
if substr(drug_frequency,1,7)='EVERY 3' then freq=0.33;
if substr(drug_frequency,1,9)='EVERY SIX' then freq=4;
if substr(drug_frequency,1,12)='EVERY TWELVE' then freq=2;
if substr(drug_frequency,1,12)='EVERY TWENTY' then freq=1;
if substr(drug_frequency,1,9)='EVERY TWO' then freq=12;
if drug_frequency='FIVE TIMES DAILY' then freq=5;
if drug_frequency='FIVE TIMES WEEKLY' then freq=5/7;
if substr(drug_frequency,1,16)='FOUR TIMES DAILY' then freq=4;
if drug_frequency='FOUR TIMES WEEKLY' then freq=4/7;
if drug_frequency='HOURLY' then freq=24;
if substr(drug_frequency,1,2)='IN' then freq=1;
if substr(drug_frequency,1,4)='ON A' then freq=1/2;
if substr(drug_frequency,1,4)='ON E' then freq=1/2;
if substr(drug_frequency,1,4)='ON O' then freq=1/2;
if substr(drug_frequency,1,4)='ON M' then freq=1/7;
if substr(drug_frequency,1,4)='ON T' then freq=1/7;
if substr(drug_frequency,1,4)='ON F' then freq=1/7;
if substr(drug_frequency,1,4)='ON S' then freq=1/7;
if substr(drug_frequency,1,4)='ON W' then freq=1/7;
if drug_frequency='ONCE' then freq=1;
if drug_frequency='ONCE WEEKLY' then freq=1/7;
if drug_frequency='SIX TIMES WEEKLY' then freq=6/7;
if drug_frequency='SIX TIMES DAILY' then freq=6;
if substr(drug_frequency,1,17)='THREE TIMES DAILY' then freq=3;
if drug_frequency='THREE TIMES WEEKLY' then freq=3/7;
if substr(drug_frequency,1,6)='THRICE' then freq=3/7;
if substr(drug_frequency,1,11)='TWICE DAILY' then freq=2;
if drug_frequency='TWICE WEEKLY' then freq=2/7;
if drug_frequency='WITH EVENING MEAL' then freq=1; 
run;
data anticoag_and_antiplate;
set anticoag_and_antiplate;
if missing(rxen) then dur=Quantity__Named_Patient_/freq/dos;
rx_dur=ceil(dur);
run; *round up the duration to nearest integer;
/* impute the median if still missing*/
proc univariate data=anticoag_and_antiplate;
var rx_dur; where ~missing(rx_dur);run; *median:14;
data anticoag_and_antiplate;
set anticoag_and_antiplate;
if missing(dur) then rx_dur=14;
run;
data st.anticoag_and_antiplate;
set anticoag_and_antiplate;
if missing(rxen) then rxen=rxst+dur-1;
run;


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
set st.ppi_stroke_coh1_adult;
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
proc sort data=st.ppi_stroke_coh1_adult nodupkey out=ppi_hc;
by reference_key;run; *8974;

proc sql;
create table st.anticoag_and_antiplate_o30 as
select * from st.anticoag_and_antiplate A left join (select st_st, st_en from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *5553642;
data st.anticoag_and_antiplate_o30;
set st.anticoag_and_antiplate_o30;
if missing(st_st) then delete;run;
data st.anticoag_and_antiplate_o30;
set st.anticoag_and_antiplate_o30;
if rxst>st_en or rxen<st_st then delete;
if rxst<st_st then rxst=st_st;
if rxen>st_en then rxen=st_en;run; *304517, after overlap: 12390;
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
%consec30d(max=400, input=st.anticoag_and_antiplate_o30, patid=reference_key, rxst=rxst, rxen=rxen); 
data anticoag_and_antiplate;
set st.anticoag_and_antiplate_o30;
rename rxst=aa_rxst rxen=aa_rxen;
aa_nid=_n_;
run;

*generate the dataset on 6 Jan 2018 and export it to Heather;
data anticoag_and_antiplate_o30;
set st.anticoag_and_antiplate_o30;
keep reference_key rxst rxen;
run;
PROC EXPORT DATA= anticoag_and_antiplate_o30 
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPIs & stroke\to_Heather\antithrombotics_rx.txt" 
            DBMS=csv REPLACE;
     PUTNAMES=YES;
RUN;
proc sort data=anticoag_and_antiplate;
by reference_key aa_rxst;
run; *need to sort for formatdata in R to work well;

data anticoag_and_antiplate;
set anticoag_and_antiplate;
keep reference_key aa_rxst aa_rxen st_st st_en;
run; *;
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
run; *32760;
proc sort data=allperiod_aa;
by reference_key pst pen;
run; 
data allperiod_aa;
set allperiod_aa;
if pst>pen then delete;
run; *25112;
data allperiod_aa;
set allperiod_aa;
if pen>st_en then pen=st_en;run;
data allperiod_aa;
set allperiod_aa;
if pst<st_st then pst=st_st;run;

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
set allperiod allperiod_aa age_trans;
run;
proc sort data=all;
by reference_key pst pen;
run;
data all2;
set all;
run; *note:171854, after: stop macro until entries in aa is 0;

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
run; *note:343708  stop macro until entries in aa is 0;

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
run; *162678;

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
run; *162678;
data st.all4_aa_primary;
set all4_aa;
drop aa_rxst aa_rxen;run;

/*can key in drug indicator now*/
proc sql;
create table all4_aa_rw as
select * from st.all4_aa_primary A left join (select pst as pre_pst, pen as pre_pen from prerisk B)
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
run; *162678;


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
run; *162678;

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
run; *162678;

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
run; *162678;

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
create table st.all4_aa_rw_primary as
select * from all4_aa_rw5 A left join (select sex as gen from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *152763;
data st.all4_aa_rw_primary;
set st.all4_aa_rw_primary;
if gen='M' then sex=1;
if gen='F' then sex=0;
run;
data st.all4_aa_rw_primary;
set st.all4_aa_rw_primary;
drop gen;
run;
proc sql;
create table st.all4_aa_rw_primary as
select * from st.all4_aa_rw_primary A left join (select dob, ppirxst, eventd from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *152763;

/*some of the risk periods chopped due to different pst and pen overlapped >>>need to be recombined
for example reference_key=1826865: the pre-risk period 17/2/2011-18/2/2011 and 19/2/2011-2/3/2011 are both pre-risk period
they were chopped due to the previous post-risk period, so need to combine it to be 17/2/2011-2/3/2011 for the whole pre-risk period
*/

data combinerisk;
set st.all4_aa_rw_primary;
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
data st.all4_aa_rw_primary;
set combinerisk3;
drop pst pen;
rename min_pst=pst max_pen=pen;
drop lag_indiv lag_aa n lag_r m_dob d_dob m_pst d_pst;
run; *152743;

data st.all4_aa_rw_primary;
set st.all4_aa_rw_primary;
age=year(pst)-year(dob);
censor=1;
interval=pen-pst+1;
run;

/*make sure there is an event for each person within observation period
as some periods were removed from baseline*/
data st.all4_aa_rw_primary;
set st.all4_aa_rw_primary;
if pst<=eventd<=pen then evt=1;
else evt=0;
run;
proc sql;
create table primary_risk_final as
select *, max(evt) as max_evt from st.all4_aa_rw_primary group by reference_key;
quit;
data rm;
set primary_risk_final;
if max_evt=0;
run; *7227;
proc sql;
create table st.all4_aa_rw_primary2 as
select * from st.all4_aa_rw_primary where reference_key not in (Select reference_key from rm);
quit; *145516;
proc sort data=st.all4_aa_rw_primary2 nodupkey out=final_hc;
by reference_key;
run; *8485;
/*making R dataset*/
data poisson_aa;
set st.all4_aa_rw_primary2;
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
PROC EXPORT DATA= poisson_aa
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPIs & stroke\R dataset\sccs_ppistroke_main_anticoag.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=NO;
RUN;

data on_anticoagulants;
set poisson_aa;
if anticoag_and_antiplate=1;
run;
proc sort data=on_anticoagulants nodupkey;
by indiv;run;

data on_anticoagulants_duringrisk;
set poisson_aa;
if anticoag_and_antiplate=1 and (exposed=2 or exposed=3 or exposed=4);
run;
proc sort data=on_anticoagulants_duringrisk nodupkey;
by indiv;run;
/*********************************************************************************
*********************************************************************************
Sensitivity analysis 2:
for shortly, during, and two 30-day wash out periods after the Rx
with adjustment with anticoagulants/antiplatelets
*********************************************************************************
*********************************************************************************/
proc sort data=st.ppi_stroke_coh1_adult nodupkey out=ppi_hc;
by reference_key;run; *8974;
/*reshape the datasets*/
data ppi_stroke_coh1_adult;
set st.ppi_stroke_coh1_adult;
keep reference_key ppirxst ppirxen st_st st_en eventd;
run;

*add non-risk period;
proc sort data=ppi_stroke_coh1_adult;
by reference_key ppirxst ppirxen;
run;
/*during prescription*/
data ppi_stroke_coh1_adult;
set ppi_stroke_coh1_adult;
pst=ppirxst;
pen=ppirxen;
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
/*first washout period 30 days after prescription end date*/
data postrisk1;
set ppi_stroke_coh1_adult;
pst=ppirxen+1;
pen=ppirxen+30;
senpst=pst;
senpen=pen;
r=3;
format pst pen yymmdd10.;
run;
/*second washout periods 30 days after first washout period*/
data postrisk2;
set ppi_stroke_coh1_adult;
pst=ppirxen+31;
pen=ppirxen+60;
senpst=pst;
senpen=pen;
r=4;
format pst pen yymmdd10.;
run;
data riskset;
set ppi_stroke_coh1_adult prerisk postrisk1 postrisk2;
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

/*anticoagulants/antiplatelets*/
/*make sure the scripts are within their own obervation period before overlapping*/
data anticoag_and_antiplate;
set st.anticoag_and_antiplate_o30; *already included the original cohort;
rename rxst=aa_rxst rxen=aa_rxen;
aa_nid=_n_;
run;
proc sort data=anticoag_and_antiplate;
by reference_key aa_rxst;
run; *need to sort for formatdata in R to work well;

data anticoag_and_antiplate;
set anticoag_and_antiplate;
keep reference_key aa_rxst aa_rxen st_st st_en;
run; *12390;
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
run; *32760;
proc sort data=allperiod_aa;
by reference_key pst pen;
run; 
data allperiod_aa;
set allperiod_aa;
if pst>pen then delete;
run; *25112;
data allperiod_aa;
set allperiod_aa;
if pen>st_en then pen=st_en;run;
data allperiod_aa;
set allperiod_aa;
if pst<st_st then pst=st_st;run;

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
set allperiod allperiod_aa age_trans;
run;
proc sort data=all;
by reference_key pst pen;
run;
data all2;
set all;
run; *note:158951, after:158951 stop macro until entries in aa is 0;

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
%multi(max=8, input=all2);

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
%multi(max=32, input=all3);

data all4;
set all2 all3;
run; *note:317902, after: stop macro until entries in aa is 0;

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
drop ppirxst ppirxen aa_rxst aa_rxen;
run; *149818;

/*key indicator for anticoag_and_antiplate*/
data all4;
set all4;
drop ppirxst ppirxen aa_rxst aa_rxen;run;
proc sql;
create table all4_aa_sen as
select * from all4 A left join (select aa_rxst, aa_rxen from anticoag_and_antiplate B)
on A.reference_key=B.reference_key;
quit; *;
data all4_aa_sen;
set all4_aa_sen;
if pst<=aa_rxst<=pen or pst<=aa_rxen<=pen or aa_rxst<=pst<=aa_rxen or aa_rxst<=pen<=aa_rxen then aa=1;
else aa=0;
run;
proc sort data=all4_aa_sen;
by reference_key pst pen decending aa;
run;
proc sort data=all4_aa_sen nodupkey;
by reference_key pst pen;
run; *149818;
data st.all4_aa_sen;
set all4_aa_sen;
drop aa_rxst aa_rxen;run;

/*can key in drug indicator now*/
proc sql;
create table primary_risk as
select * from st.all4_aa_sen A left join (select pst as pre_pst, pen as pre_pen from prerisk B)
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
run; *149818;


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
run; *149818;

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
run; *149818;

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
run; *149818;

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
by reference_key pst pen r;run; *149818;


proc sql;
create table st.sen2_primary_risk_final as
select * from primary_risk4 A left join (select sex as gen from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *149818;
data st.sen2_primary_risk_final;
set st.sen2_primary_risk_final;
if gen='M' then sex=1;
if gen='F' then sex=0;
run;
data st.sen2_primary_risk_final;
set st.sen2_primary_risk_final;
drop gen ppirxst;
run;
proc sql;
create table st.sen2_primary_risk_final as
select * from st.sen2_primary_risk_final A left join (select dob, ppirxst, eventd from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *149818;


/*some of the risk periods chopped due to different pst and pen overlapped >>>need to be recombined
for example reference_key=1826865: the pre-risk period 17/2/2011-18/2/2011 and 19/2/2011-2/3/2011 are both pre-risk period
they were chopped due to the previous post-risk period, so need to combine it to be 17/2/2011-2/3/2011 for the whole pre-risk period
*/

data combinerisk;
set st.sen2_primary_risk_final;
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

data st.sen2_primary_risk_final;
set combinerisk3;
drop pst pen;
rename min_pst=pst max_pen=pen;
drop lag_indiv lag_aa n lag_r m_dob d_dob m_pst d_pst;
run; *149625;

proc sort data=st.sen2_primary_risk_final nodupkey out=sen2_hc;
by reference_key;run;
data poisson_sen2;
set st.sen2_primary_risk_final;
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
anticoag_and_antiplate=aa;
keep indiv astart aend adrug aevent gender present exposed anticoag_and_antiplate group lower upper;run;

PROC EXPORT DATA= poisson_sen2
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPIs & stroke\R dataset\sen2_primary_risk_final.txt" 
            DBMS=DLM REPLACE;
     PUTNAMES=NO;
RUN;

