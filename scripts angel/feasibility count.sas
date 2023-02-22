/*Created on 7 July 2015*/
/*Project: Investigate association between PPI and MI
purpose: to identify the no of patients on PPI but no clarith before for SCCS*/
libname cl "C:\Users\Angel YS Wong\Desktop\sas\Complete\PRO_PB_CL";
libname pp "C:\Users\Angel YS Wong\Desktop\PPI\program\OP_PPI";

*import PPI patients;
filename indata pipe 'dir C:\"Users\Angel YS Wong\Desktop\PPI\extracted\data" /b ';
/* put all the .xlsx file names in dataset file_list */
data file_list;
length fname $90 in_name out_name $32;
infile indata truncover;
input fname $ 90.;
in_name=translate(scan(fname,1,'.'),'_','-');
out_name=cats('_',in_name); 
if upcase(scan(fname,-1,'.'))='XLSX';                                                                                                         
run;
data _null_;
  set file_list end=last;
  call symputx(cats('dsn',_n_),in_name);
  call symputx(cats('outdsn',_n_),out_name);
  if last then call symputx('n',_n_);
run;
%macro test;
   %do i=1 %to &n;
   PROC IMPORT OUT= work.&&outdsn&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\extracted\data\&&dsn&i...xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Data$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%test
data pp.allppi0312;
  set _:;
run; *;

data pp.ppi0306;
set _3115793_ppi_op_2003_conv _3115782_ppi_op_2004_conv _3115781_ppi_op_2005_conv _3115777_ppi_op_2006_conv;
dod=Date_of_Registered_Death;
format dod yymmdd10.;
drop Date_of_Registered_Death;run;
*NOTE: There were 54621 observations read from the data set WORK._3115793_PPI_OP_2003_CONV.
NOTE: There were 81638 observations read from the data set WORK._3115782_PPI_OP_2004_CONV.
NOTE: There were 94541 observations read from the data set WORK._3115781_PPI_OP_2005_CONV.
NOTE: There were 93946 observations read from the data set WORK._3115777_PPI_OP_2006_CONV.
NOTE: The data set PP.PPI0306 has 324746 observations and 25 variables.;
data pp.ppi0712;
set _3115776_ppi_op_2007_conv _3114957_ppi_op_2008_conv _3114956_ppi_op_2009_conv 
_3113423_ppi_op_2010_conv _3113420_ppi_op_2011_conv _3112657_ppi_op_2012_conv;
dod=input(Date_of_Registered_Death, yymmdd10.);
format dod yymmdd10.;
drop Date_of_Registered_Death;run;
*NOTE: There were 110999 observations read from the data set WORK._3115776_PPI_OP_2007_CONV.
NOTE: There were 138193 observations read from the data set WORK._3114957_PPI_OP_2008_CONV.
NOTE: There were 164675 observations read from the data set WORK._3114956_PPI_OP_2009_CONV.
NOTE: There were 186017 observations read from the data set WORK._3113423_PPI_OP_2010_CONV.
NOTE: There were 213789 observations read from the data set WORK._3113420_PPI_OP_2011_CONV.
NOTE: There were 261261 observations read from the data set WORK._3112657_PPI_OP_2012_CONV.
NOTE: The data set PP.PPI0712 has 1074934 observations and 25 variables.;
data pp.ppi0312;
set pp.ppi0306 pp.ppi0712;
drop Date_of_Registered_Death;run; *1399680;

proc sort data=pp.ppi0312 nodupkey out=ppi_hc;
by reference_key;run; *278958;

data pp.ppi0312;
set pp.ppi0312;
reference_key_=reference_key*1;
drop reference_key;run;
data pp.ppi0312(rename=(reference_key_=reference_key));
retain reference_key_;
set pp.ppi0312;run;

*remove patients ever took clarith on or before ppi;
proc sql;
create table rm1 as
select * from pp.ppi0312 where reference_key not in (select reference_key from cl.cl0002);
quit; *1294865;

proc sort data=rm1 nodupkey out=ppi_hc;
by reference_key;run; *265245;

proc sql;
create table rm2 as
select * from rm1 A left join (select reference_key, clpsd from cl.cl0312_2 B)
on A.reference_key=B.reference_key;quit;

data rm2;
set rm2;
if ~missing(clpsd) and clpsd<=Prescription_Start_Date;run; *613256;
proc sql;
create table pp.ppi0312_clean as
select * from rm1 where reference_key not in (select reference_key from rm2);
quit; *929778;
proc sort data=pp.ppi0312_clean nodupkey out=ppi_hc;
by reference_key;run; *166577;

*check demographics;
data a;
set pp.ppi0312_clean;
if missing(Date_of_Birth__yyyy_mm_dd_);run; *0;
data a;
set pp.ppi0312_clean;
if ~missing(dod) and Date_of_Birth__yyyy_mm_dd_>dod;run; *0;
data rm;
set pp.ppi0312_clean;
if ~missing(dod) and dod<Prescription_Start_Date;run;
proc sql;
create table pp.ppi0312_clean as
select * from pp.ppi0312_clean where reference_key not in (select reference_key from rm);
quit; *929726;
proc freq data=pp.ppi0312_clean;
table route;run; 
data pp.ppi0312_clean;
set pp.ppi0312_clean;
if route in ("ORAL" , "PO");run; *929623;

*calculate age;
proc sql;
create table pp.ppi0312_clean as
select *, min(Prescription_Start_Date) as min_ppipsd from pp.ppi0312_clean group by reference_key;
quit;
data pp.ppi0312_clean;
set pp.ppi0312_clean;
format min_ppipsd yymmdd10.;run;
data pp.ppi0312_clean;
set pp.ppi0312_clean;
age = floor ((intck('month',Date_of_Birth__yyyy_mm_dd_,min_ppipsd) - (day(min_ppipsd) < day(Date_of_Birth__yyyy_mm_dd_))) / 12);
run;
proc freq data=pp.ppi0312_clean;
table sex;run;
data pp.ppi0312_clean;
set pp.ppi0312_clean;
if sex="M" then gender=1;
if sex="F" then gender=0;run;
proc freq data=pp.ppi0312_clean;
table Action_status;run;
data pp.ppi0312_clean;
set pp.ppi0312_clean;
if Action_status="Suspended" then delete;run; *929603;
proc sort data=pp.ppi0312_clean nodupkey out=pp.hc;
by reference_key;run; *166545;

*create reference_key for CDARS data retrieval;
data pp.hc;
set pp.hc;
n=_n_;run;

data pp.hc;
set pp.hc;
if 1<=n<=10000 then file=1;
if 10001<=n<=20000 then file=2;
if 20001<=n<=30000 then file=3;
if 30001<=n<=40000 then file=4;
if 40001<=n<=50000 then file=5;
if 50001<=n<=60000 then file=6;
if 60001<=n<=70000 then file=7;
if 70001<=n<=80000 then file=8;
if 80001<=n<=90000 then file=9;
if 90001<=n<=100000 then file=10;
if 100001<=n<=110000 then file=11;
if 110001<=n<=120000 then file=12;
if 120001<=n<=130000 then file=13;
if 130001<=n<=140000 then file=14;
if 140001<=n<=150000 then file=15;
if 150001<=n<=166545 then file=16;run;

%macro export;
%do i=1 %to 16;
data hc&i.;
set pp.hc;
if file=&i. then output hc&i.;
keep reference_key;
run;
%end;
%mend;
%export;
%macro export;
%do i=1 %to 16;
PROC EXPORT DATA= WORK.hc&i.
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\coh_&i..txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=No;
RUN;
%end;
%mend;
%export;

/* Created on 8 October
Purpose: use the orginal cohort to remove those with available information
the new cohort obtained: ppi.hc and triple therapy in the previous study: tri.hpclean_demolc7d; (this dataset ensures take all LC and IP data for all patients)
Only 49912 patients left for second CDARS retrieval*/
proc sql;
create table ppi_rest as
select * from ppi_hc where reference_key not in (select reference_key from pp.hc);
quit; *ppi_hc:278958, 112413;

proc sql;
create table pp.ppi_rest2 as
select * from ppi_rest where reference_key not in (select reference_key from tri.hpclean_demolc7d);
quit; *49912;
data pp.ppi_rest2;
set pp.ppi_rest2;
n=_n_;run;

data pp.ppi_rest2;
set pp.ppi_rest2;
if 1<=n<=10000 then file=1;
if 10001<=n<=20000 then file=2;
if 20001<=n<=30000 then file=3;
if 30001<=n<=40000 then file=4;
if 40001<=n<=49912 then file=5;
run;
%macro export;
%do i=1 %to 5;
data hc&i.;
set pp.ppi_rest2;
if file=&i. then output hc&i.;
keep reference_key;
run;
%end;
%mend;
%export;
%macro export;
%do i=1 %to 5;
PROC EXPORT DATA= WORK.hc&i.
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\new_coh_&i..txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=No;
RUN;
%end;
%mend;
%export;

*create on 12 Oct 2015
Purpose: check Helen retrieved file PPI_OP_2003 whether its complete, if not then drop this file and reuse the new requested one
and also identify extra patients that havn't took their Dx record and name the refkey file as new_cohort_6;
PROC IMPORT OUT= helen_ppi_op_2003
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\extracted\data\3115793_PPI_OP_2003_conv.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Data$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
PROC IMPORT OUT= Angel_ppi_op_2003
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\extracted\data\3744498_PPI_OP_2003_conv.xlsx"
            DBMS=EXCEL REPLACE;
     RANGE="Data$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN; *54621;
proc sql;
create table pp.ppi_rest3 as
select * from Angel_ppi_op_2003 where reference_key_ not in (select reference_key from helen_ppi_op_2003);
quit;*1;
data ppi_rest3;
set pp.ppi_rest3;
reference_key=reference_key_*1;run;
proc sql;
create table a as
select * from ppi_rest3 where reference_key in (select reference_key from pp.ppi0312);
quit;

/* create the final dataset for ppi0312 not yet finalised 14 Dec 2015*/
data Angel_ppi_op_20032(rename=(reference_key_=reference_key
sex_=sex 
Date_of_Birth__yyyy_mm_dd__=Date_of_Birth__yyyy_mm_dd_
Exact_date_of_birth_=Exact_date_of_birth
Date_of_Registered_Death_=Date_of_Registered_Death
Exact_date_of_death_=Exact_date_of_death
Dispensing_Date__yyyy_mm_dd__=Dispensing_Date__yyyy_mm_dd_
Dispensing_Institution__Prescrib=Dispensing_Institution__Prescrib
Dispensing_Specialty__PHS__=Dispensing_Specialty__PHS_
Prescription_Start_Date_=Prescription_Start_Date
Prescription_End_Date_=Prescription_End_Date
Multiple_dosage_indicator_=Multiple_dosage_indicator
Drug_Item_Code_=Drug_Item_Code
Drug_Name_=Drug_Name
Route_=Route
Drug_Strength_=Drug_Strength
Dosage_=Dosage
Dosage_Unit_=Dosage_Unit
Drug_Frequency_=Drug_Frequency
Dispensing_Duration_=Dispensing_Duration__Day_
Dispensing_Duration_Unit_=Dispensing_Duration_Unit
Quantity__Named_Patient_=Dispensing_Quantity__Named_Patie
Base_Unit_=Base_Unit
Action_Status_=Action_Status));
retain reference_key_ sex_ Date_of_Birth__yyyy_mm_dd__ Exact_date_of_birth_ Date_of_Registered_Death_
Exact_date_of_death_ Dispensing_Date__yyyy_mm_dd__
Dispensing_Institution__Prescrib Dispensing_Specialty__PHS__ Prescription_Start_Date_
Prescription_End_Date_ Multiple_dosage_indicator_ Drug_Item_Code_ Drug_Name_ Route_
Drug_Strength_ Dosage_ Dosage_Unit_ Drug_Frequency_ Dispensing_Duration_ Dispensing_Duration_Unit_
Quantity__Named_Patient_ Base_Unit_ Action_Status_;
format Quantity__Named_Patient_ $4. Dispensing_Date__yyyy_mm_dd_ yymmdd10.;
set Angel_ppi_op_2003;run;

data ppi0306;
set Angel_ppi_op_20032 _3115782_ppi_op_2004_conv _3115781_ppi_op_2005_conv _3115777_ppi_op_2006_conv;
dod=Date_of_Registered_Death;
format dod yymmdd10.;
drop Date_of_Registered_Death;run; *don't know why adding one more patient to the original dataset but total entries are the same;
*NOTE: There were 54621 observations read from the data set WORK._3115793_PPI_OP_2003_CONV.
NOTE: There were 81638 observations read from the data set WORK._3115782_PPI_OP_2004_CONV.
NOTE: There were 94541 observations read from the data set WORK._3115781_PPI_OP_2005_CONV.
NOTE: There were 93946 observations read from the data set WORK._3115777_PPI_OP_2006_CONV.
NOTE: The data set PP.PPI0306 has 324746 observations and 25 variables.;
data pp.ppi0312final;
set ppi0306 pp.ppi0712;
run; *1399680;

proc sort data=pp.ppi0312final nodupkey out=ppi_hc;
by reference_key;run; *278958;

data pp.ppi0312;
set pp.ppi0312;
reference_key_=reference_key*1;
drop reference_key;run;
data pp.ppi0312(rename=(reference_key_=reference_key));
retain reference_key_;
set pp.ppi0312;run;
