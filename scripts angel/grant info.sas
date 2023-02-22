/* created on 14 Dec 2015
Purpose: for grant application to estimate the sample size and help write intro
Datasets refer to feasibility count in PPI file*/

libname pp "C:\Users\Angel YS Wong\Desktop\PPI\program\OP_PPI";
libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname tri "C:\Users\Angel YS Wong\Desktop\sas\Complete\PRO_TRI_identification";

proc sort data=p.ppi_pb_0312 nodupkey out=ppi_hc;
by reference_key;run; *505694 from 2003-2012;
data ppi0312;
set p.ppi_pb_0312;
disd=input(Dispensing_Date__yyyy_mm_dd_, yymmdd10.);
format disd yymmdd10.;
year=year(disd);
run;
proc sort data=ppi0312;
by reference_key year;run; 
proc freq data=ppi0312;
table year*Type_of_Patient__Drug_/out=ppi0312trend1;
run;
proc freq data=ppi0312;
table year/out=ppi0312trend2;
run;
data ppi0312trend2;
set ppi0312trend2;
Type_of_Patient__Drug_='total';run;
data ppi0312trend;
set ppi0312trend1 ppi0312trend2;
run;

/*plot a graph for PPI prescritpion trend in different settings*/
title "The trend of PPI prescription usage in public healthcare setting from 2003 to 2012";
axis1 order= (20000 to 1100000 by 50000) label=(a=90 'Volume of PPIs prescriptions');
symbol1 color=blue interpol=join value=plus;
symbol2 color=red interpol=join value=star;
symbol3 color=green interpol=join value=diamondfilled;
symbol4 color=black interpol=join value=X;
Legend1 label=('Sources of receiving PPIs')
 value=(height=1 'Receiving prescriptions after hospital discharge' 'Receiving prescriptions during hospitalisation' 'Receiving prescriptions in out-patient setting' 'Total prescriptions'); 
proc gplot data=ppi0312trend;
plot COUNT*year=Type_of_Patient__Drug_/vaxis=axis1 legend=legend1;
run;quit;


/* BHF grant
Updated on 13 May 2016*/
data ppi_pb_0314;
set p.ppi_pb_0312 p.ppi_pb_1314;
run;
*NOTE: There were 5907709 observations read from the data set P.PPI_PB_0312.
NOTE: There were 2684754 observations read from the data set P.PPI_PB_1314.
NOTE: The data set WORK.PPI_PB_0314 has 8592463 observations and 26 variables.
NOTE: DATA statement used (Total process time):;
data ppi_pb_0314;
set ppi_pb_0314;
disd=input(Dispensing_Date__yyyy_mm_dd_, yymmdd10.);
format disd yymmdd10.;
year=year(disd);
run;
proc sort data=ppi_pb_0314;
by reference_key year;run; 
proc freq data=ppi_pb_0314;
table year*Type_of_Patient__Drug_/out=ppi0314trend1;
run;
proc freq data=ppi_pb_0314;
table year/out=ppi0314trend2;
run;
data ppi0314trend2;
set ppi0314trend2;
Type_of_Patient__Drug_='total';run;
data ppi0314trend;
set ppi0314trend1 ppi0314trend2;
run;

proc sort data=ppi0314trend;
by decending COUNT;run;
proc sort data=ppi0314trend;
by year Type_of_Patient__Drug_;run;
/*plot a graph for PPI prescritpion trend in different settings*/
title "The trend of PPI prescription usage in public healthcare setting from 2003 to 2014";
axis1 order= (20000 to 1500000 by 50000) label=(a=90 'Volume of PPIs prescriptions');
symbol1 color=blue interpol=join value=plus;
symbol2 color=red interpol=join value=star;
symbol3 color=green interpol=join value=diamondfilled;
symbol4 color=black interpol=join value=X;
Legend1 label=('Sources of receiving PPIs')
 value=(height=1 'Receiving prescriptions after hospital discharge' 'Receiving prescriptions during hospitalisation' 'Receiving prescriptions in out-patient setting' 'Total prescriptions'); 
proc gplot data=ppi0314trend;
plot COUNT*year=Type_of_Patient__Drug_/vaxis=axis1 legend=legend1;
run;quit;





/*Plot number of incident users in out-patient setting
data ppi_op;
set p.ppi_pb_0312op;
disd=input(Dispensing_Date__yyyy_mm_dd_, yymmdd10.);
format disd yymmdd10.;
year=year(disd);
run;
proc sort data=ppi_op;
by reference_key year;run;
proc sort data=ppi_op nodupkey out=ppi_op_hc;
by reference_key;run;
proc freq data=ppi_op_hc;
table year/out=ppi_op_hctrend;
run;

SYMBOL1 V=plus C=blue I=r;
title "The number of incident PPIs users in out-patient setting from 2003 to 2012";
axis1 order= (20000 to 50000 by 10000) label=(a=90 'Number of incident users');
proc gplot data=ppi_op_hctrend;
plot COUNT*year/vaxis=axis1;
run;quit;
no of patients on out-patient PPIs prescriptions in 2012
data ppi_op12;
set ppi_op;
if year=2012;run;*288016;
proc sort data=ppi_op12 nodupkey;by reference_key;run; *105929;
*Total population in HK: 7154600
So, rate of PPI in HK: 105929/7154600*100=1.48%;

/*some patients on OP PPIs can't be identified in OP but PB in CDARS, estimate how many patients affected*/
proc sql;
create table checking as
select * from tri.hpclean_demolc7d where reference_key not in (select reference_key from pp.ppi0312);
quit; *3846;
proc sort data=checking nodupkey;
by reference_key;run; *3820;
proc sql;
create table checking2 as
select * from tri.hpclean_demolc7d where reference_key not in (select reference_key from p.ppi_pb_0312op);
quit; *59;
proc sort data=checking2 nodupkey;
by reference_key;run; *59;
proc sql;
create table checking3 as
select * from tri.Hp_mi_7d where reference_key not in (select reference_key from p.ppi_pb_0312op);
quit; *1;
proc sort data=checking3 nodupkey;
by reference_key;run; *1;
/* Therefore, total patients on out-patient PPIs =3820+278959=282779*/
*checking drug_item_codes in those missing patients;
proc freq data=checking2;
table ppi_code;run;

*The FREQ Procedure

Drug Item Code 
ppi_code Frequency Percent Cumulative
Frequency Cumulative
Percent 
NOT 01 5 8.47 5 8.47 
PANT01 1 1.69 6 10.17 
SAMP01 53 89.83 59 100.00;

PROC IMPORT OUT= pp.aus_druguse
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\HMRF\Australian\druguse20132014.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="dop20132014$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

PROC IMPORT OUT= pp.aus_PPI_code
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\HMRF\Australian\drugcode.xlsx"
            DBMS=EXCEL REPLACE;
     RANGE="code$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
data pp.aus_ppi_code;
set pp.aus_ppi_code;
if substr(ATC5_Code,1, 5)="A02BC";
run;

proc sql;
create table aus_ppi as
select * from pp.aus_druguse where ITEM_CODE in (select ITEM_CODE from pp.aus_PPI_code);
quit;

data aus_ppi2;
set aus_ppi;
if PATIENT_CAT='R1' or PATIENT_CAT='R0';
run;

proc univariate data=aus_ppi2;
var PRESCRIPTIONS;run;
