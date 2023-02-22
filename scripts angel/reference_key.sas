/*Created on 6 May 2016
Purpose: check reference key for all files in CDARS data retrieval*/

libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname rk "C:\Users\Angel YS Wong\Desktop\PPI\program\rk";
*From OP PPI to all dx from 2003-2014

for pp.hc, refkey file=coh_1-16
for pp.ppi_rest2, refkey file=new_coh1-5
for pp.ppi_rest3, refkey file=new_coh_6
for hc, refkey file=PB_coh_1-8
for another hc, refkey file=ppiPB1314_1-10;

* Total OP PPI from 2003-2014;
data p.ppi_pb_0314op;
set p.ppi_pb_0312op p.ppi_pb_1314op;
run;
proc sort data=p.ppi_pb_0314op nodupkey out=ppiop_hc;
by reference_key;
run;*405140;
%macro import_rk;
%do i=1 %to 16;
PROC IMPORT OUT= rk.coh&i. 
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\coh_&i..txt" 
            DBMS=TAB REPLACE;
     GETNAMES=NO;
RUN;
%end;
%mend;
%import_rk;
%macro import_rk;
%do i=1 %to 6;
PROC IMPORT OUT= rk.new_coh&i. 
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\new_coh_&i..txt" 
            DBMS=TAB REPLACE;
     GETNAMES=NO;
RUN;
%end;
%mend;
%import_rk;
%macro import_rk;
%do i=1 %to 8;
PROC IMPORT OUT= rk.pb_coh&i. 
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\PB_coh_&i..txt" 
            DBMS=TAB REPLACE;
     GETNAMES=NO;
RUN;
%end;
%mend;
%import_rk;
%macro import_rk;
%do i=1 %to 10;
PROC IMPORT OUT= rk.ppi1314_coh&i. 
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\ppiPB1314_&i..txt" 
            DBMS=TAB REPLACE;
     GETNAMES=NO;
RUN;
%end;
%mend;
%import_rk;
data ppiop_txt;
set rk.coh: rk.new_coh: rk.pb_coh: rk.ppi1314_:;run;

*NOTE: There were 10000 observations read from the data set RK.COH1.
NOTE: There were 10000 observations read from the data set RK.COH10.
NOTE: There were 10000 observations read from the data set RK.COH11.
NOTE: There were 10000 observations read from the data set RK.COH12.
NOTE: There were 10000 observations read from the data set RK.COH13.
NOTE: There were 10000 observations read from the data set RK.COH14.
NOTE: There were 10000 observations read from the data set RK.COH15.
NOTE: There were 16545 observations read from the data set RK.COH16.
NOTE: There were 10000 observations read from the data set RK.COH2.
NOTE: There were 10000 observations read from the data set RK.COH3.
NOTE: There were 10000 observations read from the data set RK.COH4.
NOTE: There were 10000 observations read from the data set RK.COH5.
NOTE: There were 10000 observations read from the data set RK.COH6.
NOTE: There were 10000 observations read from the data set RK.COH7.
NOTE: There were 10000 observations read from the data set RK.COH8.
NOTE: There were 10000 observations read from the data set RK.COH9.
NOTE: There were 10000 observations read from the data set RK.NEW_COH1.
NOTE: There were 10000 observations read from the data set RK.NEW_COH2.
NOTE: There were 10000 observations read from the data set RK.NEW_COH3.
NOTE: There were 10000 observations read from the data set RK.NEW_COH4.
NOTE: There were 9912 observations read from the data set RK.NEW_COH5.
NOTE: There were 1 observations read from the data set RK.NEW_COH6.
NOTE: There were 10000 observations read from the data set RK.PB_COH1.
NOTE: There were 10000 observations read from the data set RK.PB_COH2.
NOTE: There were 10000 observations read from the data set RK.PB_COH3.
NOTE: There were 10000 observations read from the data set RK.PB_COH4.
NOTE: There were 10000 observations read from the data set RK.PB_COH5.
NOTE: There were 10000 observations read from the data set RK.PB_COH6.
NOTE: There were 10000 observations read from the data set RK.PB_COH7.
NOTE: There were 17620 observations read from the data set RK.PB_COH8.
NOTE: There were 10000 observations read from the data set RK.PPI1314_COH1.
NOTE: There were 11845 observations read from the data set RK.PPI1314_COH10.
NOTE: There were 10000 observations read from the data set RK.PPI1314_COH2.
NOTE: There were 10000 observations read from the data set RK.PPI1314_COH3.
NOTE: There were 10000 observations read from the data set RK.PPI1314_COH4.
NOTE: There were 10000 observations read from the data set RK.PPI1314_COH5.
NOTE: There were 10000 observations read from the data set RK.PPI1314_COH6.
NOTE: There were 10000 observations read from the data set RK.PPI1314_COH7.
NOTE: There were 10000 observations read from the data set RK.PPI1314_COH8.
NOTE: There were 10000 observations read from the data set RK.PPI1314_COH9.
NOTE: The data set WORK.PPIOP_TXT has 405923 observations and 1 variables.;

proc sql;
create table checking as
select * from ppiop_hc where reference_key not in (select VAR1 from ppiop_txt);
quit; *0, ok!;

*checking from alldx to mi & stroke cohort;

*alldx data;
data dx.dx_all9315jj;
set dx.ppi_dx9314 dx.ppi_pb_dx9314 dx.ppi1314_dx9314 dx.ppi15jj_dx;
run;
*NOTE: There were 9001837 observations read from the data set DX.PPI_DX9314.
NOTE: There were 1891893 observations read from the data set DX.PPI_PB_DX9314.
NOTE: There were 2690333 observations read from the data set DX.PPI1314_DX9314.
NOTE: There were 548818 observations read from the data set DX.PPI15JJ_DX.
NOTE: The data set DX.DX_ALL9315JJ has 14132881 observations and 7 variables.;

proc sql;
create table mistroke_all as
select * from dx.dx_all9315jj where All_Diagnosis_Code__ICD9_ like '410%'
or All_Diagnosis_Code__ICD9_ like '433.01'
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
quit; *201413;
proc sort data=mistroke_all nodupkey out=mistroke_hc;
by reference_key;
run; *85803;

%macro import_rk;
%do i=1 %to 5;
PROC IMPORT OUT= rk.mistroke1p2_&i. 
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\mistroke1plus2_coh_&i..txt" 
            DBMS=TAB REPLACE;
     GETNAMES=NO;
RUN;
%end;
%mend;
%import_rk;
PROC IMPORT OUT= rk.pbmistroke
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\pb_mistroke_coh.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=NO;
RUN;
%macro import_rk;
%do i=1 %to 2;
PROC IMPORT OUT= rk.mistroke4_&i. 
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\mistroke4_coh_&i..txt" 
            DBMS=TAB REPLACE;
     GETNAMES=NO;
RUN;
%end;
%mend;
%import_rk;
PROC IMPORT OUT= rk.mistroke5
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\mistroke5.txt"
            DBMS=TAB REPLACE;
     GETNAMES=NO;
RUN;

data rk.mistroke_txt;
set rk.mistroke: rk.pbmistroke;
run;
*NOTE: There were 10000 observations read from the data set RK.MISTROKE1P2_1.
NOTE: There were 10000 observations read from the data set RK.MISTROKE1P2_2.
NOTE: There were 10000 observations read from the data set RK.MISTROKE1P2_3.
NOTE: There were 10000 observations read from the data set RK.MISTROKE1P2_4.
NOTE: There were 14379 observations read from the data set RK.MISTROKE1P2_5.
NOTE: There were 10000 observations read from the data set RK.MISTROKE4_1.
NOTE: There were 9395 observations read from the data set RK.MISTROKE4_2.
NOTE: There were 4008 observations read from the data set RK.MISTROKE5.
NOTE: There were 10125 observations read from the data set RK.PBMISTROKE.
NOTE: The data set WORK.MISTROKE_TXT has 87907 observations and 1 variables.;


proc sql;
create table checking as
select * from mistroke_hc where reference_key not in (select VAR1 from rk.mistroke_txt);
quit; *0, ok!;


/*check refkey of LC rest thir*/
%macro import_rk;
%do i=1 %to 5;
PROC IMPORT OUT= rk.lcrest_thir_&i. 
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\ppi_lcrest_thir_&i..txt" 
            DBMS=TAB REPLACE;
     GETNAMES=NO;
RUN;
%end;
%mend;
%import_rk;
data all_thir;
set rk.lcrest_thir_:;run; *52961;
proc sql;
create table a as
select * from miss_lc where reference_key not in (Select VAR1 from all_thir);
quit; *0 but no LC records, remove them;

*Updated on 15 Aug;
proc sql;
create table allmi as
select * from dx.dx_all9315jj where All_Diagnosis_Code__ICD9_ like '410%' or All_Diagnosis_Code__ICD9_ like '412%'; ****and 412 too;
quit; *87889;
proc sql;
create table allmi410 as
select * from dx.dx_all9315jj where All_Diagnosis_Code__ICD9_ like '410%'; ****and 412 too;
quit; *62635;
proc sql;
create table allmi412 as
select * from allmi where reference_key not in (Select reference_key from allmi410);
quit; *3665;
proc sort data=allmi412 nodupkey out=rk.allmi412;
by reference_key;
run; *1873;
