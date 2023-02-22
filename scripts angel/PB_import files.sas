/* Created 6 Jan 2016
Purpose: Import all Dx, LC, IP and all drug data into SAS*/
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname lc "C:\Users\Angel YS Wong\Desktop\PPI\program\lc";
libname an "C:\Users\Angel YS Wong\Desktop\PPI\program\drug";

/*************************************************************************************
**************************************************************************************
***********************************************************************************
**************************************************************************************
Import alldx data
***********************************************************************************
**************************************************************************************
***********************************************************************************
***************************************************************************************/

%macro import;
   %do i=1 %to 196;
   PROC IMPORT OUT= ppi_dx_&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\Dx\data\master\ppi_dx_&i..xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%import;
data dx.ppi_dx9314;
set ppi_dx_:;run;
*NOTE: There were 44451 observations read from the data set WORK.PPI_DX_1.
NOTE: There were 75525 observations read from the data set WORK.PPI_DX_10.
NOTE: There were 250 observations read from the data set WORK.PPI_DX_100.
NOTE: There were 10780 observations read from the data set WORK.PPI_DX_101.
NOTE: There were 56670 observations read from the data set WORK.PPI_DX_102.
NOTE: There were 91408 observations read from the data set WORK.PPI_DX_103.
NOTE: There were 84335 observations read from the data set WORK.PPI_DX_104.
NOTE: There were 52810 observations read from the data set WORK.PPI_DX_105.
NOTE: There were 81388 observations read from the data set WORK.PPI_DX_106.
NOTE: There were 51089 observations read from the data set WORK.PPI_DX_107.
NOTE: There were 207 observations read from the data set WORK.PPI_DX_108.
NOTE: There were 10653 observations read from the data set WORK.PPI_DX_109.
NOTE: There were 58232 observations read from the data set WORK.PPI_DX_11.
NOTE: There were 52399 observations read from the data set WORK.PPI_DX_110.
NOTE: There were 47445 observations read from the data set WORK.PPI_DX_111.
NOTE: There were 200 observations read from the data set WORK.PPI_DX_112.
NOTE: There were 15155 observations read from the data set WORK.PPI_DX_113.
NOTE: There were 58383 observations read from the data set WORK.PPI_DX_114.
NOTE: There were 51632 observations read from the data set WORK.PPI_DX_115.
NOTE: There were 84864 observations read from the data set WORK.PPI_DX_116.
NOTE: There were 80918 observations read from the data set WORK.PPI_DX_117.
NOTE: There were 41 observations read from the data set WORK.PPI_DX_118.
NOTE: There were 10579 observations read from the data set WORK.PPI_DX_119.
NOTE: There were 45515 observations read from the data set WORK.PPI_DX_12.
NOTE: There were 65015 observations read from the data set WORK.PPI_DX_120.
NOTE: There were 95003 observations read from the data set WORK.PPI_DX_121.
NOTE: There were 85774 observations read from the data set WORK.PPI_DX_122.
NOTE: There were 56 observations read from the data set WORK.PPI_DX_123.
NOTE: There were 489 observations read from the data set WORK.PPI_DX_124.
NOTE: There were 53836 observations read from the data set WORK.PPI_DX_125.
NOTE: There were 88669 observations read from the data set WORK.PPI_DX_126.
NOTE: There were 80908 observations read from the data set WORK.PPI_DX_127.
NOTE: There were 46882 observations read from the data set WORK.PPI_DX_128.
NOTE: There were 69196 observations read from the data set WORK.PPI_DX_129.
NOTE: There were 60636 observations read from the data set WORK.PPI_DX_13.
NOTE: There were 59753 observations read from the data set WORK.PPI_DX_130.
NOTE: There were 67846 observations read from the data set WORK.PPI_DX_131.
NOTE: There were 73759 observations read from the data set WORK.PPI_DX_132.
NOTE: There were 67017 observations read from the data set WORK.PPI_DX_133.
NOTE: There were 39361 observations read from the data set WORK.PPI_DX_134.
NOTE: There were 30088 observations read from the data set WORK.PPI_DX_135.
NOTE: There were 4072 observations read from the data set WORK.PPI_DX_136.
NOTE: There were 219 observations read from the data set WORK.PPI_DX_137.
NOTE: There were 100 observations read from the data set WORK.PPI_DX_138.
NOTE: There were 36856 observations read from the data set WORK.PPI_DX_139.
NOTE: There were 51073 observations read from the data set WORK.PPI_DX_14.
NOTE: There were 26854 observations read from the data set WORK.PPI_DX_140.
NOTE: There were 11102 observations read from the data set WORK.PPI_DX_141.
NOTE: There were 18639 observations read from the data set WORK.PPI_DX_142.
NOTE: There were 39122 observations read from the data set WORK.PPI_DX_143.
NOTE: There were 24957 observations read from the data set WORK.PPI_DX_144.
NOTE: There were 43971 observations read from the data set WORK.PPI_DX_145.
NOTE: There were 54032 observations read from the data set WORK.PPI_DX_146.
NOTE: There were 69706 observations read from the data set WORK.PPI_DX_147.
NOTE: There were 81357 observations read from the data set WORK.PPI_DX_148.
NOTE: There were 46454 observations read from the data set WORK.PPI_DX_149.
NOTE: There were 62605 observations read from the data set WORK.PPI_DX_15.
NOTE: There were 28373 observations read from the data set WORK.PPI_DX_150.
NOTE: There were 60779 observations read from the data set WORK.PPI_DX_151.
NOTE: There were 39129 observations read from the data set WORK.PPI_DX_152.
NOTE: There were 39171 observations read from the data set WORK.PPI_DX_153.
NOTE: There were 45134 observations read from the data set WORK.PPI_DX_154.
NOTE: There were 49881 observations read from the data set WORK.PPI_DX_155.
NOTE: There were 65226 observations read from the data set WORK.PPI_DX_156.
NOTE: There were 8069 observations read from the data set WORK.PPI_DX_157.
NOTE: There were 57614 observations read from the data set WORK.PPI_DX_158.
NOTE: There were 45237 observations read from the data set WORK.PPI_DX_159.
NOTE: There were 39611 observations read from the data set WORK.PPI_DX_16.
NOTE: There were 81138 observations read from the data set WORK.PPI_DX_160.
NOTE: There were 74344 observations read from the data set WORK.PPI_DX_161.
NOTE: There were 64237 observations read from the data set WORK.PPI_DX_162.
NOTE: There were 46437 observations read from the data set WORK.PPI_DX_163.
NOTE: There were 38054 observations read from the data set WORK.PPI_DX_164.
NOTE: There were 84757 observations read from the data set WORK.PPI_DX_165.
NOTE: There were 73622 observations read from the data set WORK.PPI_DX_166.
NOTE: There were 32876 observations read from the data set WORK.PPI_DX_167.
NOTE: There were 23455 observations read from the data set WORK.PPI_DX_168.
NOTE: There were 36819 observations read from the data set WORK.PPI_DX_169.
NOTE: There were 45947 observations read from the data set WORK.PPI_DX_17.
NOTE: There were 26817 observations read from the data set WORK.PPI_DX_170.
NOTE: There were 28411 observations read from the data set WORK.PPI_DX_171.
NOTE: There were 40552 observations read from the data set WORK.PPI_DX_172.
NOTE: There were 52743 observations read from the data set WORK.PPI_DX_173.
NOTE: There were 41040 observations read from the data set WORK.PPI_DX_174.
NOTE: There were 32194 observations read from the data set WORK.PPI_DX_175.
NOTE: There were 56691 observations read from the data set WORK.PPI_DX_176.
NOTE: There were 43996 observations read from the data set WORK.PPI_DX_177.
NOTE: There were 51741 observations read from the data set WORK.PPI_DX_178.
NOTE: There were 47860 observations read from the data set WORK.PPI_DX_179.
NOTE: There were 96643 observations read from the data set WORK.PPI_DX_18.
NOTE: There were 32722 observations read from the data set WORK.PPI_DX_180.
NOTE: There were 26086 observations read from the data set WORK.PPI_DX_181.
NOTE: There were 69379 observations read from the data set WORK.PPI_DX_182.
NOTE: There were 55065 observations read from the data set WORK.PPI_DX_183.
NOTE: There were 52644 observations read from the data set WORK.PPI_DX_184.
NOTE: There were 48980 observations read from the data set WORK.PPI_DX_185.
NOTE: There were 43116 observations read from the data set WORK.PPI_DX_186.
NOTE: There were 35824 observations read from the data set WORK.PPI_DX_187.
NOTE: There were 67149 observations read from the data set WORK.PPI_DX_188.
NOTE: There were 60104 observations read from the data set WORK.PPI_DX_189.
NOTE: There were 63537 observations read from the data set WORK.PPI_DX_19.
NOTE: There were 28908 observations read from the data set WORK.PPI_DX_190.
NOTE: There were 35731 observations read from the data set WORK.PPI_DX_191.
NOTE: There were 4 observations read from the data set WORK.PPI_DX_192.
NOTE: There were 3 observations read from the data set WORK.PPI_DX_193.
NOTE: There were 24 observations read from the data set WORK.PPI_DX_194.
NOTE: There were 48 observations read from the data set WORK.PPI_DX_195.
NOTE: There were 2 observations read from the data set WORK.PPI_DX_196.
NOTE: There were 89018 observations read from the data set WORK.PPI_DX_2.
NOTE: There were 51785 observations read from the data set WORK.PPI_DX_20.
NOTE: There were 64807 observations read from the data set WORK.PPI_DX_21.
NOTE: There were 54661 observations read from the data set WORK.PPI_DX_22.
NOTE: There were 61503 observations read from the data set WORK.PPI_DX_23.
NOTE: There were 58139 observations read from the data set WORK.PPI_DX_24.
NOTE: There were 50716 observations read from the data set WORK.PPI_DX_25.
NOTE: There were 59712 observations read from the data set WORK.PPI_DX_26.
NOTE: There were 52381 observations read from the data set WORK.PPI_DX_27.
NOTE: There were 33752 observations read from the data set WORK.PPI_DX_28.
NOTE: There were 62493 observations read from the data set WORK.PPI_DX_29.
NOTE: There were 73421 observations read from the data set WORK.PPI_DX_3.
NOTE: There were 33692 observations read from the data set WORK.PPI_DX_30.
NOTE: There were 44069 observations read from the data set WORK.PPI_DX_31.
NOTE: There were 60855 observations read from the data set WORK.PPI_DX_32.
NOTE: There were 50126 observations read from the data set WORK.PPI_DX_33.
NOTE: There were 46896 observations read from the data set WORK.PPI_DX_34.
NOTE: There were 22960 observations read from the data set WORK.PPI_DX_35.
NOTE: There were 69465 observations read from the data set WORK.PPI_DX_36.
NOTE: There were 28650 observations read from the data set WORK.PPI_DX_37.
NOTE: There were 59873 observations read from the data set WORK.PPI_DX_38.
NOTE: There were 61183 observations read from the data set WORK.PPI_DX_39.
NOTE: There were 30451 observations read from the data set WORK.PPI_DX_4.
NOTE: There were 45420 observations read from the data set WORK.PPI_DX_40.
NOTE: There were 55582 observations read from the data set WORK.PPI_DX_41.
NOTE: There were 33960 observations read from the data set WORK.PPI_DX_42.
NOTE: There were 33417 observations read from the data set WORK.PPI_DX_43.
NOTE: There were 43190 observations read from the data set WORK.PPI_DX_44.
NOTE: There were 51883 observations read from the data set WORK.PPI_DX_45.
NOTE: There were 49614 observations read from the data set WORK.PPI_DX_46.
NOTE: There were 55552 observations read from the data set WORK.PPI_DX_47.
NOTE: There were 42042 observations read from the data set WORK.PPI_DX_48.
NOTE: There were 52884 observations read from the data set WORK.PPI_DX_49.
NOTE: There were 85794 observations read from the data set WORK.PPI_DX_5.
NOTE: There were 41642 observations read from the data set WORK.PPI_DX_50.
NOTE: There were 49618 observations read from the data set WORK.PPI_DX_51.
NOTE: There were 46169 observations read from the data set WORK.PPI_DX_52.
NOTE: There were 61056 observations read from the data set WORK.PPI_DX_53.
NOTE: There were 20287 observations read from the data set WORK.PPI_DX_54.
NOTE: There were 44886 observations read from the data set WORK.PPI_DX_55.
NOTE: There were 54182 observations read from the data set WORK.PPI_DX_56.
NOTE: There were 92020 observations read from the data set WORK.PPI_DX_57.
NOTE: There were 94148 observations read from the data set WORK.PPI_DX_58.
NOTE: There were 58542 observations read from the data set WORK.PPI_DX_59.
NOTE: There were 68026 observations read from the data set WORK.PPI_DX_6.
NOTE: There were 25780 observations read from the data set WORK.PPI_DX_60.
NOTE: There were 36471 observations read from the data set WORK.PPI_DX_61.
NOTE: There were 422 observations read from the data set WORK.PPI_DX_62.
NOTE: There were 38199 observations read from the data set WORK.PPI_DX_63.
NOTE: There were 23520 observations read from the data set WORK.PPI_DX_64.
NOTE: There were 34064 observations read from the data set WORK.PPI_DX_65.
NOTE: There were 47608 observations read from the data set WORK.PPI_DX_66.
NOTE: There were 84336 observations read from the data set WORK.PPI_DX_67.
NOTE: There were 47328 observations read from the data set WORK.PPI_DX_68.
NOTE: There were 80070 observations read from the data set WORK.PPI_DX_69.
NOTE: There were 29764 observations read from the data set WORK.PPI_DX_7.
NOTE: There were 42040 observations read from the data set WORK.PPI_DX_70.
NOTE: There were 40368 observations read from the data set WORK.PPI_DX_71.
NOTE: There were 54850 observations read from the data set WORK.PPI_DX_72.
NOTE: There were 349 observations read from the data set WORK.PPI_DX_73.
NOTE: There were 36627 observations read from the data set WORK.PPI_DX_74.
NOTE: There were 298 observations read from the data set WORK.PPI_DX_75.
NOTE: There were 33090 observations read from the data set WORK.PPI_DX_76.
NOTE: There were 54776 observations read from the data set WORK.PPI_DX_77.
NOTE: There were 52858 observations read from the data set WORK.PPI_DX_78.
NOTE: There were 43293 observations read from the data set WORK.PPI_DX_79.
NOTE: There were 82833 observations read from the data set WORK.PPI_DX_8.
NOTE: There were 80363 observations read from the data set WORK.PPI_DX_80.
NOTE: There were 45701 observations read from the data set WORK.PPI_DX_81.
NOTE: There were 74498 observations read from the data set WORK.PPI_DX_82.
NOTE: There were 45394 observations read from the data set WORK.PPI_DX_83.
NOTE: There were 43320 observations read from the data set WORK.PPI_DX_84.
NOTE: There were 30084 observations read from the data set WORK.PPI_DX_85.
NOTE: There were 26412 observations read from the data set WORK.PPI_DX_86.
NOTE: There were 44208 observations read from the data set WORK.PPI_DX_87.
NOTE: There were 41703 observations read from the data set WORK.PPI_DX_88.
NOTE: There were 30176 observations read from the data set WORK.PPI_DX_89.
NOTE: There were 85508 observations read from the data set WORK.PPI_DX_9.
NOTE: There were 24462 observations read from the data set WORK.PPI_DX_90.
NOTE: There were 43804 observations read from the data set WORK.PPI_DX_91.
NOTE: There were 41924 observations read from the data set WORK.PPI_DX_92.
NOTE: There were 28905 observations read from the data set WORK.PPI_DX_93.
NOTE: There were 24521 observations read from the data set WORK.PPI_DX_94.
NOTE: There were 218 observations read from the data set WORK.PPI_DX_95.
NOTE: There were 11683 observations read from the data set WORK.PPI_DX_96.
NOTE: There were 39177 observations read from the data set WORK.PPI_DX_97.
NOTE: There were 38321 observations read from the data set WORK.PPI_DX_98.
NOTE: There were 73729 observations read from the data set WORK.PPI_DX_99.
NOTE: The data set DX.PPI_DX9314 has 9001837 observations and 7 variables.;

/* updated on 4th Feb 2016
Identify MI and stroke patients in all Dx for retreiving data for LC and In-patient admission date*/
*MI;

/* Import dx.ppi_dx9314 SAS file please refer to SAS editor PB_import files*/

proc sql;
create table dx.ppi_mi_1plus2 as
select * from dx.ppi_dx9314 where All_Diagnosis_Code__ICD9_ like '410%';
quit; *40339;

proc sql;
create table dx.ppi_allstroke_1plus2 as
select * from dx.ppi_dx9314 where All_Diagnosis_Code__ICD9_ like '433.01'
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
quit; *89514;

data dx.ppi_mistroke_refkey_1plus2;
set dx.ppi_mi_1plus2 dx.ppi_allstroke_1plus2;
keep reference_key;run; *129853;

proc sort data=dx.ppi_mistroke_refkey_1plus2 nodupkey;
by reference_key;run; *54379;

data dx.ppi_mistroke_refkey_1plus2;
set dx.ppi_mistroke_refkey_1plus2;
n=_n_;run;
data dx.ppi_mistroke_refkey_1plus2;
set dx.ppi_mistroke_refkey_1plus2;
if 1<=n<=10000 then file=1;
if 10001<=n<=20000 then file=2;
if 20001<=n<=30000 then file=3;
if 30001<=n<=40000 then file=4;
if 40001<=n<=54379 then file=5;
run;

%macro export;
%do i=1 %to 5;
data hc&i.;
set dx.ppi_mistroke_refkey_1plus2;
if file=&i. then output hc&i.;
keep reference_key;
run;
%end;
%mend;
%export;
%macro export;
%do i=1 %to 5;
PROC EXPORT DATA= hc&i.
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\mistroke1plus2_coh_&i..txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=No;
RUN;
%end;
%mend;
%export;

*created on 31 Jul 2015
1. Import all dx data into sas
2. identify MI;

%macro import;
   %do i=1 %to 49;
   PROC IMPORT OUT= ppi_pb_dx&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\Dx\PB_ppi_alldx\master\pbppi_dx_&i..xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%import;
data dx.ppi_pb_dx9314;
set ppi_pb_dx:;run;
*NOTE: There were 30100 observations read from the data set DX.PPI_PB_DX1.
NOTE: There were 60483 observations read from the data set DX.PPI_PB_DX10.
NOTE: There were 22244 observations read from the data set DX.PPI_PB_DX11.
NOTE: There were 41951 observations read from the data set DX.PPI_PB_DX12.
NOTE: There were 28269 observations read from the data set DX.PPI_PB_DX13.
NOTE: There were 35013 observations read from the data set DX.PPI_PB_DX14.
NOTE: There were 41408 observations read from the data set DX.PPI_PB_DX15.
NOTE: There were 22101 observations read from the data set DX.PPI_PB_DX16.
NOTE: There were 28264 observations read from the data set DX.PPI_PB_DX17.
NOTE: There were 36438 observations read from the data set DX.PPI_PB_DX18.
NOTE: There were 58976 observations read from the data set DX.PPI_PB_DX19.
NOTE: There were 165 observations read from the data set DX.PPI_PB_DX2.
NOTE: There were 58654 observations read from the data set DX.PPI_PB_DX20.
NOTE: There were 64727 observations read from the data set DX.PPI_PB_DX21.
NOTE: There were 64615 observations read from the data set DX.PPI_PB_DX22.
NOTE: There were 45658 observations read from the data set DX.PPI_PB_DX23.
NOTE: There were 21822 observations read from the data set DX.PPI_PB_DX24.
NOTE: There were 35304 observations read from the data set DX.PPI_PB_DX25.
NOTE: There were 40106 observations read from the data set DX.PPI_PB_DX26.
NOTE: There were 716 observations read from the data set DX.PPI_PB_DX27.
NOTE: There were 24987 observations read from the data set DX.PPI_PB_DX28.
NOTE: There were 28786 observations read from the data set DX.PPI_PB_DX29.
NOTE: There were 9234 observations read from the data set DX.PPI_PB_DX3.
NOTE: There were 37733 observations read from the data set DX.PPI_PB_DX30.
NOTE: There were 70096 observations read from the data set DX.PPI_PB_DX31.
NOTE: There were 61600 observations read from the data set DX.PPI_PB_DX32.
NOTE: There were 45760 observations read from the data set DX.PPI_PB_DX33.
NOTE: There were 35511 observations read from the data set DX.PPI_PB_DX34.
NOTE: There were 120 observations read from the data set DX.PPI_PB_DX35.
NOTE: There were 7198 observations read from the data set DX.PPI_PB_DX36.
NOTE: There were 31768 observations read from the data set DX.PPI_PB_DX37.
NOTE: There were 82484 observations read from the data set DX.PPI_PB_DX38.
NOTE: There were 188 observations read from the data set DX.PPI_PB_DX39.
NOTE: There were 48940 observations read from the data set DX.PPI_PB_DX4.
NOTE: There were 20405 observations read from the data set DX.PPI_PB_DX40.
NOTE: There were 43169 observations read from the data set DX.PPI_PB_DX41.
NOTE: There were 94098 observations read from the data set DX.PPI_PB_DX42.
NOTE: There were 30610 observations read from the data set DX.PPI_PB_DX43.
NOTE: There were 60535 observations read from the data set DX.PPI_PB_DX44.
NOTE: There were 46365 observations read from the data set DX.PPI_PB_DX45.
NOTE: There were 144 observations read from the data set DX.PPI_PB_DX46.
NOTE: There were 7410 observations read from the data set DX.PPI_PB_DX47.
NOTE: There were 33316 observations read from the data set DX.PPI_PB_DX48.
NOTE: There were 85668 observations read from the data set DX.PPI_PB_DX49.
NOTE: There were 72055 observations read from the data set DX.PPI_PB_DX5.
NOTE: There were 69433 observations read from the data set DX.PPI_PB_DX6.
NOTE: There were 50578 observations read from the data set DX.PPI_PB_DX7.
NOTE: There were 28646 observations read from the data set DX.PPI_PB_DX8.
NOTE: There were 28042 observations read from the data set DX.PPI_PB_DX9.
NOTE: The data set DX.PPI_PB_DX9314 has 1891893 observations and 7 variables.;

*Updated on 30 Dec 2015
Identify MI and stroke patients in all Dx for retreiving data for LC and In-patient admission date*/
*MI;
proc sql;
create table dx.ppi_mi_3 as
select * from dx.ppi_pb_dx9314 where All_Diagnosis_Code__ICD9_ like '410%';
quit; *4810;

proc sql;
create table dx.ppi_allstroke_3 as
select * from dx.ppi_pb_dx9314 where All_Diagnosis_Code__ICD9_ like '433.01'
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
quit; *18395;

data dx.ppi_mistroke_refkey_3;
set dx.ppi_mi_3 dx.ppi_allstroke_3;
keep reference_key;run; *23205;

proc sort data=dx.ppi_mistroke_refkey_3 nodupkey;
by reference_key;run; *10125;

PROC EXPORT DATA= dx.ppi_mistroke_refkey_3
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\pb_mistroke_coh.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=No;
RUN;

/*check missing reference_key in converted files, already updated the files without any missing reference_key*/
data a;
set dx.ppi_dx9314;
if missing(reference_key);run; 
data a;
set dx.ppi_pb_dx9314;
if missing(reference_key);run; 
%macro check_missingrefkey;
%do i=1 %to 196;
data a_&i.;
set ppi_dx_&i.;
if missing(reference_key);
run;
%end;
%mend;
%check_missingrefkey;
%macro check_missingrefkey;
%do i=1 %to 49;
data a_&i.;
set ppi_pb_dx&i.;
if missing(reference_key);
run;
%end;
%mend;
%check_missingrefkey;
data a;
set dx.ppi_dx9314;
if missing(reference_key);run; *0;
data a;
set dx.ppi_pb_dx9314;
if missing(reference_key);run; *0;

*updated on 2 Feb 2015 after adding back missing reference_key in all dx files
NOTE: There were 30100 observations read from the data set WORK.PPI_PB_DX1.
NOTE: There were 60483 observations read from the data set WORK.PPI_PB_DX10.
NOTE: There were 22244 observations read from the data set WORK.PPI_PB_DX11.
NOTE: There were 41951 observations read from the data set WORK.PPI_PB_DX12.
NOTE: There were 28269 observations read from the data set WORK.PPI_PB_DX13.
NOTE: There were 35013 observations read from the data set WORK.PPI_PB_DX14.
NOTE: There were 41408 observations read from the data set WORK.PPI_PB_DX15.
NOTE: There were 22101 observations read from the data set WORK.PPI_PB_DX16.
NOTE: There were 28264 observations read from the data set WORK.PPI_PB_DX17.
NOTE: There were 36438 observations read from the data set WORK.PPI_PB_DX18.
NOTE: There were 58976 observations read from the data set WORK.PPI_PB_DX19.
NOTE: There were 165 observations read from the data set WORK.PPI_PB_DX2.
NOTE: There were 58654 observations read from the data set WORK.PPI_PB_DX20.
NOTE: There were 64727 observations read from the data set WORK.PPI_PB_DX21.
NOTE: There were 64615 observations read from the data set WORK.PPI_PB_DX22.
NOTE: There were 45658 observations read from the data set WORK.PPI_PB_DX23.
NOTE: There were 21822 observations read from the data set WORK.PPI_PB_DX24.
NOTE: There were 35304 observations read from the data set WORK.PPI_PB_DX25.
NOTE: There were 40106 observations read from the data set WORK.PPI_PB_DX26.
NOTE: There were 716 observations read from the data set WORK.PPI_PB_DX27.
NOTE: There were 24987 observations read from the data set WORK.PPI_PB_DX28.
NOTE: There were 28786 observations read from the data set WORK.PPI_PB_DX29.
NOTE: There were 9234 observations read from the data set WORK.PPI_PB_DX3.
NOTE: There were 37733 observations read from the data set WORK.PPI_PB_DX30.
NOTE: There were 70096 observations read from the data set WORK.PPI_PB_DX31.
NOTE: There were 61600 observations read from the data set WORK.PPI_PB_DX32.
NOTE: There were 45760 observations read from the data set WORK.PPI_PB_DX33.
NOTE: There were 35511 observations read from the data set WORK.PPI_PB_DX34.
NOTE: There were 120 observations read from the data set WORK.PPI_PB_DX35.
NOTE: There were 7198 observations read from the data set WORK.PPI_PB_DX36.
NOTE: There were 31768 observations read from the data set WORK.PPI_PB_DX37.
NOTE: There were 82484 observations read from the data set WORK.PPI_PB_DX38.
NOTE: There were 188 observations read from the data set WORK.PPI_PB_DX39.
NOTE: There were 48940 observations read from the data set WORK.PPI_PB_DX4.
NOTE: There were 20405 observations read from the data set WORK.PPI_PB_DX40.
NOTE: There were 43169 observations read from the data set WORK.PPI_PB_DX41.
NOTE: There were 94098 observations read from the data set WORK.PPI_PB_DX42.
NOTE: There were 30610 observations read from the data set WORK.PPI_PB_DX43.
NOTE: There were 60535 observations read from the data set WORK.PPI_PB_DX44.
NOTE: There were 46365 observations read from the data set WORK.PPI_PB_DX45.
NOTE: There were 144 observations read from the data set WORK.PPI_PB_DX46.
NOTE: There were 7410 observations read from the data set WORK.PPI_PB_DX47.
NOTE: There were 33316 observations read from the data set WORK.PPI_PB_DX48.
NOTE: There were 85668 observations read from the data set WORK.PPI_PB_DX49.
NOTE: There were 72055 observations read from the data set WORK.PPI_PB_DX5.
NOTE: There were 69433 observations read from the data set WORK.PPI_PB_DX6.
NOTE: There were 50578 observations read from the data set WORK.PPI_PB_DX7.
NOTE: There were 28646 observations read from the data set WORK.PPI_PB_DX8.
NOTE: There were 28042 observations read from the data set WORK.PPI_PB_DX9.
NOTE: The data set DX.PPI_PB_DX9314 has 1891893 observations and 7 variables.;

/*Created on 10 March 2016
Purpose: To extend the study period to 2013-2014*/
%macro import;
   %do i=1 %to 65;
   PROC IMPORT OUT= ppi1314_dx&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\Dx\master\ppi1314_dx_&i..xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%import;
data dx.ppi1314_dx9314;
set ppi1314_dx:;run;
*NOTE: There were 25123 observations read from the data set WORK.PPI1314_DX1.
NOTE: There were 43293 observations read from the data set WORK.PPI1314_DX10.
NOTE: There were 58562 observations read from the data set WORK.PPI1314_DX11.
NOTE: There were 67654 observations read from the data set WORK.PPI1314_DX12.
NOTE: There were 65425 observations read from the data set WORK.PPI1314_DX13.
NOTE: There were 69703 observations read from the data set WORK.PPI1314_DX14.
NOTE: There were 21383 observations read from the data set WORK.PPI1314_DX15.
NOTE: There were 37212 observations read from the data set WORK.PPI1314_DX16.
NOTE: There were 40473 observations read from the data set WORK.PPI1314_DX17.
NOTE: There were 54660 observations read from the data set WORK.PPI1314_DX18.
NOTE: There were 62587 observations read from the data set WORK.PPI1314_DX19.
NOTE: There were 45307 observations read from the data set WORK.PPI1314_DX2.
NOTE: There were 61487 observations read from the data set WORK.PPI1314_DX20.
NOTE: There were 66518 observations read from the data set WORK.PPI1314_DX21.
NOTE: There were 3881 observations read from the data set WORK.PPI1314_DX22.
NOTE: There were 26543 observations read from the data set WORK.PPI1314_DX23.
NOTE: There were 36189 observations read from the data set WORK.PPI1314_DX24.
NOTE: There were 50275 observations read from the data set WORK.PPI1314_DX25.
NOTE: There were 54916 observations read from the data set WORK.PPI1314_DX26.
NOTE: There were 55223 observations read from the data set WORK.PPI1314_DX27.
NOTE: There were 59742 observations read from the data set WORK.PPI1314_DX28.
NOTE: There were 260 observations read from the data set WORK.PPI1314_DX29.
NOTE: There were 53622 observations read from the data set WORK.PPI1314_DX3.
NOTE: There were 23269 observations read from the data set WORK.PPI1314_DX30.
NOTE: There were 30206 observations read from the data set WORK.PPI1314_DX31.
NOTE: There were 42821 observations read from the data set WORK.PPI1314_DX32.
NOTE: There were 49355 observations read from the data set WORK.PPI1314_DX33.
NOTE: There were 52811 observations read from the data set WORK.PPI1314_DX34.
NOTE: There were 55178 observations read from the data set WORK.PPI1314_DX35.
NOTE: There were 179 observations read from the data set WORK.PPI1314_DX36.
NOTE: There were 6588 observations read from the data set WORK.PPI1314_DX37.
NOTE: There were 21851 observations read from the data set WORK.PPI1314_DX38.
NOTE: There were 76279 observations read from the data set WORK.PPI1314_DX39.
NOTE: There were 73309 observations read from the data set WORK.PPI1314_DX4.
NOTE: There were 51170 observations read from the data set WORK.PPI1314_DX40.
NOTE: There were 57092 observations read from the data set WORK.PPI1314_DX41.
NOTE: There were 138 observations read from the data set WORK.PPI1314_DX42.
NOTE: There were 6622 observations read from the data set WORK.PPI1314_DX43.
NOTE: There were 22548 observations read from the data set WORK.PPI1314_DX44.
NOTE: There were 77902 observations read from the data set WORK.PPI1314_DX45.
NOTE: There were 52742 observations read from the data set WORK.PPI1314_DX46.
NOTE: There were 58818 observations read from the data set WORK.PPI1314_DX47.
NOTE: There were 101 observations read from the data set WORK.PPI1314_DX48.
NOTE: There were 9509 observations read from the data set WORK.PPI1314_DX49.
NOTE: There were 74526 observations read from the data set WORK.PPI1314_DX5.
NOTE: There were 23234 observations read from the data set WORK.PPI1314_DX50.
NOTE: There were 74705 observations read from the data set WORK.PPI1314_DX51.
NOTE: There were 51926 observations read from the data set WORK.PPI1314_DX52.
NOTE: There were 56627 observations read from the data set WORK.PPI1314_DX53.
NOTE: There were 52 observations read from the data set WORK.PPI1314_DX54.
NOTE: There were 2320 observations read from the data set WORK.PPI1314_DX55.
NOTE: There were 23552 observations read from the data set WORK.PPI1314_DX56.
NOTE: There were 70915 observations read from the data set WORK.PPI1314_DX57.
NOTE: There were 51032 observations read from the data set WORK.PPI1314_DX58.
NOTE: There were 56219 observations read from the data set WORK.PPI1314_DX59.
NOTE: There were 73370 observations read from the data set WORK.PPI1314_DX6.
NOTE: There were 14 observations read from the data set WORK.PPI1314_DX60.
NOTE: There were 124 observations read from the data set WORK.PPI1314_DX61.
NOTE: There were 3473 observations read from the data set WORK.PPI1314_DX62.
NOTE: There were 53978 observations read from the data set WORK.PPI1314_DX63.
NOTE: There were 52525 observations read from the data set WORK.PPI1314_DX64.
NOTE: There were 59361 observations read from the data set WORK.PPI1314_DX65.
NOTE: There were 77088 observations read from the data set WORK.PPI1314_DX7.
NOTE: There were 20896 observations read from the data set WORK.PPI1314_DX8.
NOTE: There were 35870 observations read from the data set WORK.PPI1314_DX9.
NOTE: The data set DX.PPI1314_DX9314 has 2690333 observations and 7 variables.;

data a;
set dx.ppi1314_dx9314;
if missing(reference_key);run; *0;
*Identify MI and stroke patients in all Dx for retreiving data for LC and In-patient admission date*/
*MI;
proc sql;
create table dx.ppi_mi_4 as
select * from dx.ppi1314_dx9314 where All_Diagnosis_Code__ICD9_ like '410%';
quit; *15067;

proc sql;
create table dx.ppi_allstroke_4 as
select * from dx.ppi1314_dx9314 where All_Diagnosis_Code__ICD9_ like '433.01'
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
quit; *27403;

data dx.ppi_mistroke_refkey_4;
set dx.ppi_mi_4 dx.ppi_allstroke_4;
keep reference_key;run; *42470;

proc sort data=dx.ppi_mistroke_refkey_4 nodupkey;
by reference_key;run; *19395;

data dx.ppi_mistroke_refkey_4;
set dx.ppi_mistroke_refkey_4;
n=_n_;run;
data dx.ppi_mistroke_refkey_4;
set dx.ppi_mistroke_refkey_4;
if 1<=n<=10000 then file=1;
if 10001<=n<=20000 then file=2;
run;

%macro export;
%do i=1 %to 2;
data hc&i.;
set dx.ppi_mistroke_refkey_4;
if file=&i. then output hc&i.;
keep reference_key;
run;
%end;
%mend;
%export;
%macro export;
%do i=1 %to 2;
PROC EXPORT DATA= hc&i.
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\mistroke4_coh_&i..txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=No;
RUN;
%end;
%mend;
%export;


/*Created on 22 April 2016
Purpose: To obtain more Dx data for all cohort (2015Jan-2015Jun)*/
%macro import;
   %do i=1 %to 40;
   PROC IMPORT OUT= ppi15_dx&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\Dx\master\ppi15_dx_&i..xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%import;
data dx.ppi15jj_dx;
set ppi15_dx:;run;
*NOTE: There were 15702 observations read from the data set WORK.PPI15_DX1.
NOTE: There were 11722 observations read from the data set WORK.PPI15_DX10.
NOTE: There were 10813 observations read from the data set WORK.PPI15_DX11.
NOTE: There were 10369 observations read from the data set WORK.PPI15_DX12.
NOTE: There were 9785 observations read from the data set WORK.PPI15_DX13.
NOTE: There were 11537 observations read from the data set WORK.PPI15_DX14.
NOTE: There were 10056 observations read from the data set WORK.PPI15_DX15.
NOTE: There were 15385 observations read from the data set WORK.PPI15_DX16.
NOTE: There were 16545 observations read from the data set WORK.PPI15_DX17.
NOTE: There were 16415 observations read from the data set WORK.PPI15_DX18.
NOTE: There were 13144 observations read from the data set WORK.PPI15_DX19.
NOTE: There were 14444 observations read from the data set WORK.PPI15_DX2.
NOTE: There were 12511 observations read from the data set WORK.PPI15_DX20.
NOTE: There were 9138 observations read from the data set WORK.PPI15_DX21.
NOTE: There were 4 observations read from the data set WORK.PPI15_DX22.
NOTE: There were 10610 observations read from the data set WORK.PPI15_DX23.
NOTE: There were 9073 observations read from the data set WORK.PPI15_DX24.
NOTE: There were 8464 observations read from the data set WORK.PPI15_DX25.
NOTE: There were 8047 observations read from the data set WORK.PPI15_DX26.
NOTE: There were 7827 observations read from the data set WORK.PPI15_DX27.
NOTE: There were 6806 observations read from the data set WORK.PPI15_DX28.
NOTE: There were 7327 observations read from the data set WORK.PPI15_DX29.
NOTE: There were 13112 observations read from the data set WORK.PPI15_DX3.
NOTE: There were 12184 observations read from the data set WORK.PPI15_DX30.
NOTE: There were 27083 observations read from the data set WORK.PPI15_DX31.
NOTE: There were 24692 observations read from the data set WORK.PPI15_DX32.
NOTE: There were 24051 observations read from the data set WORK.PPI15_DX33.
NOTE: There were 20522 observations read from the data set WORK.PPI15_DX34.
NOTE: There were 20718 observations read from the data set WORK.PPI15_DX35.
NOTE: There were 19143 observations read from the data set WORK.PPI15_DX36.
NOTE: There were 20013 observations read from the data set WORK.PPI15_DX37.
NOTE: There were 19065 observations read from the data set WORK.PPI15_DX38.
NOTE: There were 18635 observations read from the data set WORK.PPI15_DX39.
NOTE: There were 14675 observations read from the data set WORK.PPI15_DX4.
NOTE: There were 18076 observations read from the data set WORK.PPI15_DX40.
NOTE: There were 13249 observations read from the data set WORK.PPI15_DX5.
NOTE: There were 12867 observations read from the data set WORK.PPI15_DX6.
NOTE: There were 11430 observations read from the data set WORK.PPI15_DX7.
NOTE: There were 12108 observations read from the data set WORK.PPI15_DX8.
NOTE: There were 11471 observations read from the data set WORK.PPI15_DX9.
NOTE: The data set DX.PPI15JJ_DX has 548818 observations and 7 variables.;

data a;
set dx.ppi15jj_dx;
if missing(reference_key);run; *0;
*Identify MI and stroke patients in all Dx for retreiving data for LC and In-patient admission date*/
*MI;
proc sql;
create table dx.ppi_mi_5 as
select * from dx.ppi15jj_dx where All_Diagnosis_Code__ICD9_ like '410%';
quit; *2419;

proc sql;
create table dx.ppi_allstroke_5 as
select * from dx.ppi15jj_dx where All_Diagnosis_Code__ICD9_ like '433.01'
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
quit; *3466;

data dx.ppi_mistroke_refkey_5;
set dx.ppi_mi_5 dx.ppi_allstroke_5;
keep reference_key;run; *5885;

proc sort data=dx.ppi_mistroke_refkey_5 nodupkey;
by reference_key;run; *4008;
data dx.ppi_mistroke_refkey_5;
set dx.ppi_mistroke_refkey_5;
keep reference_key;run;

PROC EXPORT DATA= dx.ppi_mistroke_refkey_5
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\mistroke5.txt"
            DBMS=TAB REPLACE;
     PUTNAMES=No;
RUN;

/*******Combine total alldx data
for pp.hc, refkey file=coh_1-16
for pp.ppi_rest2, refkey file=new_coh1-5
for pp.ppi_rest3, refkey file=new_coh_6
for hc, refkey file=PB_coh_1-8
for another hc, refkey file=ppiPB1314_1-10*****/
data dx.dx_all9315jj;
set dx.ppi_dx9314 dx.ppi_pb_dx9314 dx.ppi1314_dx9314 dx.ppi15jj_dx;
run; *14132881;
/************************************************************************************
**************************************************************************************
***********************************************************************************
**************************************************************************************
Import IP data
***********************************************************************************
**************************************************************************************
***********************************************************************************
**************************************************************************************
Updated on 16 Feb 2016
Further updated on 30 May 2016*/
%macro import;
   %do i=1 %to 89;
   PROC IMPORT OUT= ppi_ip_&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\IP\master\mis1p2_ip_&i..xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%import;
%macro import;
   %do i=42 %to 53;
   PROC IMPORT OUT= ppi_ip_pb&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\IP\master\ppi_ip_&i..xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%import;
%macro import;
   %do i=1 %to 29;
   PROC IMPORT OUT= ppi_ip_pb4p5&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\IP\master\mis4p5_ip_&i..xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%import;

data dx.ppi_mistrokeip;
set ppi_ip_:;run; *0;

*NOTE: There were 58451 observations read from the data set WORK.PPI_IP_1.
NOTE: There were 49489 observations read from the data set WORK.PPI_IP_10.
NOTE: There were 52057 observations read from the data set WORK.PPI_IP_11.
NOTE: There were 49115 observations read from the data set WORK.PPI_IP_12.
NOTE: There were 43195 observations read from the data set WORK.PPI_IP_13.
NOTE: There were 43907 observations read from the data set WORK.PPI_IP_14.
NOTE: There were 36068 observations read from the data set WORK.PPI_IP_15.
NOTE: There were 30432 observations read from the data set WORK.PPI_IP_16.
NOTE: There were 25485 observations read from the data set WORK.PPI_IP_17.
NOTE: There were 24578 observations read from the data set WORK.PPI_IP_18.
NOTE: There were 21032 observations read from the data set WORK.PPI_IP_19.
NOTE: There were 47965 observations read from the data set WORK.PPI_IP_2.
NOTE: There were 50939 observations read from the data set WORK.PPI_IP_20.
NOTE: There were 38795 observations read from the data set WORK.PPI_IP_21.
NOTE: There were 47783 observations read from the data set WORK.PPI_IP_22.
NOTE: There were 58384 observations read from the data set WORK.PPI_IP_23.
NOTE: There were 71865 observations read from the data set WORK.PPI_IP_24.
NOTE: There were 87009 observations read from the data set WORK.PPI_IP_25.
NOTE: There were 56556 observations read from the data set WORK.PPI_IP_26.
NOTE: There were 80280 observations read from the data set WORK.PPI_IP_27.
NOTE: There were 98628 observations read from the data set WORK.PPI_IP_28.
NOTE: There were 49815 observations read from the data set WORK.PPI_IP_29.
NOTE: There were 58484 observations read from the data set WORK.PPI_IP_3.
NOTE: There were 43125 observations read from the data set WORK.PPI_IP_30.
NOTE: There were 45783 observations read from the data set WORK.PPI_IP_31.
NOTE: There were 38021 observations read from the data set WORK.PPI_IP_32.
NOTE: There were 33094 observations read from the data set WORK.PPI_IP_33.
NOTE: There were 29165 observations read from the data set WORK.PPI_IP_34.
NOTE: There were 24973 observations read from the data set WORK.PPI_IP_35.
NOTE: There were 23466 observations read from the data set WORK.PPI_IP_36.
NOTE: There were 31625 observations read from the data set WORK.PPI_IP_37.
NOTE: There were 32267 observations read from the data set WORK.PPI_IP_38.
NOTE: There were 44372 observations read from the data set WORK.PPI_IP_39.
NOTE: There were 72282 observations read from the data set WORK.PPI_IP_4.
NOTE: There were 51736 observations read from the data set WORK.PPI_IP_40.
NOTE: There were 63504 observations read from the data set WORK.PPI_IP_41.
NOTE: There were 74897 observations read from the data set WORK.PPI_IP_42.
NOTE: There were 50749 observations read from the data set WORK.PPI_IP_43.
NOTE: There were 78253 observations read from the data set WORK.PPI_IP_44.
NOTE: There were 91591 observations read from the data set WORK.PPI_IP_45.
NOTE: There were 44435 observations read from the data set WORK.PPI_IP_46.
NOTE: There were 41022 observations read from the data set WORK.PPI_IP_47.
NOTE: There were 43444 observations read from the data set WORK.PPI_IP_48.
NOTE: There were 37649 observations read from the data set WORK.PPI_IP_49.
NOTE: There were 88386 observations read from the data set WORK.PPI_IP_5.
NOTE: There were 28933 observations read from the data set WORK.PPI_IP_50.
NOTE: There were 26078 observations read from the data set WORK.PPI_IP_51.
NOTE: There were 23876 observations read from the data set WORK.PPI_IP_52.
NOTE: There were 20033 observations read from the data set WORK.PPI_IP_53.
NOTE: There were 1 observations read from the data set WORK.PPI_IP_54.
NOTE: There were 8795 observations read from the data set WORK.PPI_IP_55.
NOTE: There were 30986 observations read from the data set WORK.PPI_IP_56.
NOTE: There were 36198 observations read from the data set WORK.PPI_IP_57.
NOTE: There were 50113 observations read from the data set WORK.PPI_IP_58.
NOTE: There were 60606 observations read from the data set WORK.PPI_IP_59.
NOTE: There were 46111 observations read from the data set WORK.PPI_IP_6.
NOTE: There were 21637 observations read from the data set WORK.PPI_IP_60.
NOTE: There were 24304 observations read from the data set WORK.PPI_IP_61.
NOTE: There were 67749 observations read from the data set WORK.PPI_IP_62.
NOTE: There were 88139 observations read from the data set WORK.PPI_IP_63.
NOTE: There were 43103 observations read from the data set WORK.PPI_IP_64.
NOTE: There were 40963 observations read from the data set WORK.PPI_IP_65.
NOTE: There were 43977 observations read from the data set WORK.PPI_IP_66.
NOTE: There were 37092 observations read from the data set WORK.PPI_IP_67.
NOTE: There were 30453 observations read from the data set WORK.PPI_IP_68.
NOTE: There were 27050 observations read from the data set WORK.PPI_IP_69.
NOTE: There were 50543 observations read from the data set WORK.PPI_IP_7.
NOTE: There were 24385 observations read from the data set WORK.PPI_IP_70.
NOTE: There were 19661 observations read from the data set WORK.PPI_IP_71.
NOTE: There were 30 observations read from the data set WORK.PPI_IP_72.
NOTE: There were 34 observations read from the data set WORK.PPI_IP_73.
NOTE: There were 12760 observations read from the data set WORK.PPI_IP_74.
NOTE: There were 33230 observations read from the data set WORK.PPI_IP_75.
NOTE: There were 53982 observations read from the data set WORK.PPI_IP_76.
NOTE: There were 73586 observations read from the data set WORK.PPI_IP_77.
NOTE: There were 54582 observations read from the data set WORK.PPI_IP_78.
NOTE: There were 83472 observations read from the data set WORK.PPI_IP_79.
NOTE: There were 59540 observations read from the data set WORK.PPI_IP_8.
NOTE: There were 54524 observations read from the data set WORK.PPI_IP_80.
NOTE: There were 56437 observations read from the data set WORK.PPI_IP_81.
NOTE: There were 57905 observations read from the data set WORK.PPI_IP_82.
NOTE: There were 59162 observations read from the data set WORK.PPI_IP_83.
NOTE: There were 64146 observations read from the data set WORK.PPI_IP_84.
NOTE: There were 55545 observations read from the data set WORK.PPI_IP_85.
NOTE: There were 41466 observations read from the data set WORK.PPI_IP_86.
NOTE: There were 35240 observations read from the data set WORK.PPI_IP_87.
NOTE: There were 32897 observations read from the data set WORK.PPI_IP_88.
NOTE: There were 28040 observations read from the data set WORK.PPI_IP_89.
NOTE: There were 84889 observations read from the data set WORK.PPI_IP_9.
NOTE: There were 24670 observations read from the data set WORK.PPI_IP_PB42.
NOTE: There were 35167 observations read from the data set WORK.PPI_IP_PB43.
NOTE: There were 36085 observations read from the data set WORK.PPI_IP_PB44.
NOTE: There were 42812 observations read from the data set WORK.PPI_IP_PB45.
NOTE: There were 50412 observations read from the data set WORK.PPI_IP_PB46.
NOTE: There were 63799 observations read from the data set WORK.PPI_IP_PB47.
NOTE: There were 55280 observations read from the data set WORK.PPI_IP_PB48.
NOTE: There were 71933 observations read from the data set WORK.PPI_IP_PB49.
NOTE: There were 24186 observations read from the data set WORK.PPI_IP_PB4P51.
NOTE: There were 67386 observations read from the data set WORK.PPI_IP_PB4P510.
NOTE: There were 56030 observations read from the data set WORK.PPI_IP_PB4P511.
NOTE: There were 10385 observations read from the data set WORK.PPI_IP_PB4P513.
NOTE: There were 29866 observations read from the data set WORK.PPI_IP_PB4P514.
NOTE: There were 49956 observations read from the data set WORK.PPI_IP_PB4P515.
NOTE: There were 27897 observations read from the data set WORK.PPI_IP_PB4P516.
NOTE: There were 43957 observations read from the data set WORK.PPI_IP_PB4P517.
NOTE: There were 46825 observations read from the data set WORK.PPI_IP_PB4P518.
NOTE: There were 52010 observations read from the data set WORK.PPI_IP_PB4P519.
NOTE: There were 31226 observations read from the data set WORK.PPI_IP_PB4P52.
NOTE: There were 56958 observations read from the data set WORK.PPI_IP_PB4P520.
NOTE: There were 46071 observations read from the data set WORK.PPI_IP_PB4P521.
NOTE: There were 8530 observations read from the data set WORK.PPI_IP_PB4P522.
NOTE: There were 19516 observations read from the data set WORK.PPI_IP_PB4P523.
NOTE: There were 32966 observations read from the data set WORK.PPI_IP_PB4P524.
NOTE: There were 59057 observations read from the data set WORK.PPI_IP_PB4P525.
NOTE: There were 31128 observations read from the data set WORK.PPI_IP_PB4P526.
NOTE: There were 34372 observations read from the data set WORK.PPI_IP_PB4P527.
NOTE: There were 42881 observations read from the data set WORK.PPI_IP_PB4P528.
NOTE: There were 60150 observations read from the data set WORK.PPI_IP_PB4P529.
NOTE: There were 43532 observations read from the data set WORK.PPI_IP_PB4P53.
NOTE: There were 39427 observations read from the data set WORK.PPI_IP_PB4P54.
NOTE: There were 93793 observations read from the data set WORK.PPI_IP_PB4P55.
NOTE: There were 45815 observations read from the data set WORK.PPI_IP_PB4P56.
NOTE: There were 62883 observations read from the data set WORK.PPI_IP_PB4P57.
NOTE: There were 56703 observations read from the data set WORK.PPI_IP_PB4P58.
NOTE: There were 63127 observations read from the data set WORK.PPI_IP_PB4P59.
NOTE: There were 62600 observations read from the data set WORK.PPI_IP_PB50.
NOTE: There were 62493 observations read from the data set WORK.PPI_IP_PB51.
NOTE: There were 45371 observations read from the data set WORK.PPI_IP_PB52.
NOTE: There were 36405 observations read from the data set WORK.PPI_IP_PB53.
NOTE: The data set DX.PPI_MISTROKEIP has 5880064 observations and 7 variables.;

data a;
set DX.PPI_MISTROKEIP;
if missing(reference_key);
run;

/*Import LC data
Further updated on 30 May 2016*/
%macro import;
   %do i=1 %to 844;
   PROC IMPORT OUT= ppi_lc_&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\LC\master\ppi_pb_LC_&i..xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%import;
data lc.ppi_lc;
set ppi_lc_:;run;

*NOTE: There were 189 observations read from the data set WORK.PPI_LC_1.
NOTE: There were 14811 observations read from the data set WORK.PPI_LC_10.
NOTE: There were 11 observations read from the data set WORK.PPI_LC_100.
NOTE: There were 35 observations read from the data set WORK.PPI_LC_101.
NOTE: There were 19075 observations read from the data set WORK.PPI_LC_102.
NOTE: There were 72186 observations read from the data set WORK.PPI_LC_103.
NOTE: There were 69 observations read from the data set WORK.PPI_LC_104.
NOTE: There were 251 observations read from the data set WORK.PPI_LC_105.
NOTE: There were 9537 observations read from the data set WORK.PPI_LC_106.
NOTE: There were 1 observations read from the data set WORK.PPI_LC_107.
NOTE: There were 85604 observations read from the data set WORK.PPI_LC_108.
NOTE: There were 883 observations read from the data set WORK.PPI_LC_109.
NOTE: There were 78813 observations read from the data set WORK.PPI_LC_11.
NOTE: There were 240 observations read from the data set WORK.PPI_LC_110.
NOTE: There were 9937 observations read from the data set WORK.PPI_LC_111.
NOTE: There were 2 observations read from the data set WORK.PPI_LC_112.
NOTE: There were 86260 observations read from the data set WORK.PPI_LC_113.
NOTE: There were 888 observations read from the data set WORK.PPI_LC_114.
NOTE: There were 188 observations read from the data set WORK.PPI_LC_115.
NOTE: There were 11573 observations read from the data set WORK.PPI_LC_116.
NOTE: There were 50579 observations read from the data set WORK.PPI_LC_117.
NOTE: There were 145 observations read from the data set WORK.PPI_LC_118.
NOTE: There were 208 observations read from the data set WORK.PPI_LC_119.
NOTE: There were 1107 observations read from the data set WORK.PPI_LC_12.
NOTE: There were 10647 observations read from the data set WORK.PPI_LC_120.
NOTE: There were 56114 observations read from the data set WORK.PPI_LC_121.
NOTE: There were 405 observations read from the data set WORK.PPI_LC_122.
NOTE: There were 201 observations read from the data set WORK.PPI_LC_123.
NOTE: There were 11117 observations read from the data set WORK.PPI_LC_124.
NOTE: There were 62770 observations read from the data set WORK.PPI_LC_125.
NOTE: There were 714 observations read from the data set WORK.PPI_LC_126.
NOTE: There were 208 observations read from the data set WORK.PPI_LC_127.
NOTE: There were 12016 observations read from the data set WORK.PPI_LC_128.
NOTE: There were 69908 observations read from the data set WORK.PPI_LC_129.
NOTE: There were 424 observations read from the data set WORK.PPI_LC_13.
NOTE: There were 912 observations read from the data set WORK.PPI_LC_130.
NOTE: There were 235 observations read from the data set WORK.PPI_LC_131.
NOTE: There were 6701 observations read from the data set WORK.PPI_LC_132.
NOTE: There were 57128 observations read from the data set WORK.PPI_LC_133.
NOTE: There were 741 observations read from the data set WORK.PPI_LC_134.
NOTE: There were 187 observations read from the data set WORK.PPI_LC_135.
NOTE: There were 8824 observations read from the data set WORK.PPI_LC_136.
NOTE: There were 77987 observations read from the data set WORK.PPI_LC_137.
NOTE: There were 863 observations read from the data set WORK.PPI_LC_138.
NOTE: There were 262 observations read from the data set WORK.PPI_LC_139.
NOTE: There were 8752 observations read from the data set WORK.PPI_LC_14.
NOTE: There were 15740 observations read from the data set WORK.PPI_LC_140.
NOTE: There were 73757 observations read from the data set WORK.PPI_LC_141.
NOTE: There were 704 observations read from the data set WORK.PPI_LC_142.
NOTE: There were 368 observations read from the data set WORK.PPI_LC_143.
NOTE: There were 8254 observations read from the data set WORK.PPI_LC_144.
NOTE: There were 52062 observations read from the data set WORK.PPI_LC_145.
NOTE: There were 652 observations read from the data set WORK.PPI_LC_146.
NOTE: There were 219 observations read from the data set WORK.PPI_LC_147.
NOTE: There were 6147 observations read from the data set WORK.PPI_LC_148.
NOTE: There were 46900 observations read from the data set WORK.PPI_LC_149.
NOTE: There were 53087 observations read from the data set WORK.PPI_LC_15.
NOTE: There were 734 observations read from the data set WORK.PPI_LC_150.
NOTE: There were 148 observations read from the data set WORK.PPI_LC_151.
NOTE: There were 8202 observations read from the data set WORK.PPI_LC_152.
NOTE: There were 76792 observations read from the data set WORK.PPI_LC_153.
NOTE: There were 1014 observations read from the data set WORK.PPI_LC_154.
NOTE: There were 219 observations read from the data set WORK.PPI_LC_155.
NOTE: There were 9308 observations read from the data set WORK.PPI_LC_156.
NOTE: There were 59259 observations read from the data set WORK.PPI_LC_157.
NOTE: There were 838 observations read from the data set WORK.PPI_LC_158.
NOTE: There were 204 observations read from the data set WORK.PPI_LC_159.
NOTE: There were 710 observations read from the data set WORK.PPI_LC_16.
NOTE: There were 6773 observations read from the data set WORK.PPI_LC_160.
NOTE: There were 47496 observations read from the data set WORK.PPI_LC_161.
NOTE: There were 559 observations read from the data set WORK.PPI_LC_162.
NOTE: There were 118 observations read from the data set WORK.PPI_LC_163.
NOTE: There were 10128 observations read from the data set WORK.PPI_LC_164.
NOTE: There were 1 observations read from the data set WORK.PPI_LC_165.
NOTE: There were 71469 observations read from the data set WORK.PPI_LC_166.
NOTE: There were 896 observations read from the data set WORK.PPI_LC_167.
NOTE: There were 263 observations read from the data set WORK.PPI_LC_168.
NOTE: There were 9422 observations read from the data set WORK.PPI_LC_169.
NOTE: There were 225 observations read from the data set WORK.PPI_LC_17.
NOTE: There were 72306 observations read from the data set WORK.PPI_LC_170.
NOTE: There were 806 observations read from the data set WORK.PPI_LC_171.
NOTE: There were 250 observations read from the data set WORK.PPI_LC_172.
NOTE: There were 7286 observations read from the data set WORK.PPI_LC_173.
NOTE: There were 52931 observations read from the data set WORK.PPI_LC_174.
NOTE: There were 543 observations read from the data set WORK.PPI_LC_175.
NOTE: There were 200 observations read from the data set WORK.PPI_LC_176.
NOTE: There were 5427 observations read from the data set WORK.PPI_LC_177.
NOTE: There were 1 observations read from the data set WORK.PPI_LC_178.
NOTE: There were 44539 observations read from the data set WORK.PPI_LC_179.
NOTE: There were 8781 observations read from the data set WORK.PPI_LC_18.
NOTE: There were 528 observations read from the data set WORK.PPI_LC_180.
NOTE: There were 129 observations read from the data set WORK.PPI_LC_181.
NOTE: There were 6073 observations read from the data set WORK.PPI_LC_182.
NOTE: There were 1 observations read from the data set WORK.PPI_LC_183.
NOTE: There were 50361 observations read from the data set WORK.PPI_LC_184.
NOTE: There were 491 observations read from the data set WORK.PPI_LC_185.
NOTE: There were 154 observations read from the data set WORK.PPI_LC_186.
NOTE: There were 6182 observations read from the data set WORK.PPI_LC_187.
NOTE: There were 49888 observations read from the data set WORK.PPI_LC_188.
NOTE: There were 513 observations read from the data set WORK.PPI_LC_189.
NOTE: There were 57854 observations read from the data set WORK.PPI_LC_19.
NOTE: There were 165 observations read from the data set WORK.PPI_LC_190.
NOTE: There were 5900 observations read from the data set WORK.PPI_LC_191.
NOTE: There were 48765 observations read from the data set WORK.PPI_LC_192.
NOTE: There were 537 observations read from the data set WORK.PPI_LC_193.
NOTE: There were 161 observations read from the data set WORK.PPI_LC_194.
NOTE: There were 6156 observations read from the data set WORK.PPI_LC_195.
NOTE: There were 1 observations read from the data set WORK.PPI_LC_196.
NOTE: There were 48833 observations read from the data set WORK.PPI_LC_197.
NOTE: There were 539 observations read from the data set WORK.PPI_LC_198.
NOTE: There were 142 observations read from the data set WORK.PPI_LC_199.
NOTE: There were 19786 observations read from the data set WORK.PPI_LC_2.
NOTE: There were 694 observations read from the data set WORK.PPI_LC_20.
NOTE: There were 6558 observations read from the data set WORK.PPI_LC_200.
NOTE: There were 3 observations read from the data set WORK.PPI_LC_201.
NOTE: There were 49335 observations read from the data set WORK.PPI_LC_202.
NOTE: There were 577 observations read from the data set WORK.PPI_LC_203.
NOTE: There were 172 observations read from the data set WORK.PPI_LC_204.
NOTE: There were 6868 observations read from the data set WORK.PPI_LC_205.
NOTE: There were 4 observations read from the data set WORK.PPI_LC_206.
NOTE: There were 48705 observations read from the data set WORK.PPI_LC_207.
NOTE: There were 503 observations read from the data set WORK.PPI_LC_208.
NOTE: There were 172 observations read from the data set WORK.PPI_LC_209.
NOTE: There were 251 observations read from the data set WORK.PPI_LC_21.
NOTE: There were 6770 observations read from the data set WORK.PPI_LC_210.
NOTE: There were 13 observations read from the data set WORK.PPI_LC_211.
NOTE: There were 47587 observations read from the data set WORK.PPI_LC_212.
NOTE: There were 523 observations read from the data set WORK.PPI_LC_213.
NOTE: There were 129 observations read from the data set WORK.PPI_LC_214.
NOTE: There were 7292 observations read from the data set WORK.PPI_LC_215.
NOTE: There were 18 observations read from the data set WORK.PPI_LC_216.
NOTE: There were 46519 observations read from the data set WORK.PPI_LC_217.
NOTE: There were 582 observations read from the data set WORK.PPI_LC_218.
NOTE: There were 124 observations read from the data set WORK.PPI_LC_219.
NOTE: There were 10469 observations read from the data set WORK.PPI_LC_22.
NOTE: There were 7014 observations read from the data set WORK.PPI_LC_220.
NOTE: There were 12 observations read from the data set WORK.PPI_LC_221.
NOTE: There were 47571 observations read from the data set WORK.PPI_LC_222.
NOTE: There were 618 observations read from the data set WORK.PPI_LC_223.
NOTE: There were 141 observations read from the data set WORK.PPI_LC_224.
NOTE: There were 7174 observations read from the data set WORK.PPI_LC_225.
NOTE: There were 12 observations read from the data set WORK.PPI_LC_226.
NOTE: There were 46863 observations read from the data set WORK.PPI_LC_227.
NOTE: There were 586 observations read from the data set WORK.PPI_LC_228.
NOTE: There were 140 observations read from the data set WORK.PPI_LC_229.
NOTE: There were 79086 observations read from the data set WORK.PPI_LC_23.
NOTE: There were 7221 observations read from the data set WORK.PPI_LC_230.
NOTE: There were 1783 observations read from the data set WORK.PPI_LC_231.
NOTE: There were 48083 observations read from the data set WORK.PPI_LC_232.
NOTE: There were 637 observations read from the data set WORK.PPI_LC_233.
NOTE: There were 156 observations read from the data set WORK.PPI_LC_234.
NOTE: There were 7092 observations read from the data set WORK.PPI_LC_235.
NOTE: There were 562 observations read from the data set WORK.PPI_LC_236.
NOTE: There were 45845 observations read from the data set WORK.PPI_LC_237.
NOTE: There were 714 observations read from the data set WORK.PPI_LC_238.
NOTE: There were 119 observations read from the data set WORK.PPI_LC_239.
NOTE: There were 912 observations read from the data set WORK.PPI_LC_24.
NOTE: There were 6809 observations read from the data set WORK.PPI_LC_240.
NOTE: There were 889 observations read from the data set WORK.PPI_LC_241.
NOTE: There were 45179 observations read from the data set WORK.PPI_LC_242.
NOTE: There were 642 observations read from the data set WORK.PPI_LC_243.
NOTE: There were 127 observations read from the data set WORK.PPI_LC_244.
NOTE: There were 7023 observations read from the data set WORK.PPI_LC_245.
NOTE: There were 457 observations read from the data set WORK.PPI_LC_246.
NOTE: There were 43018 observations read from the data set WORK.PPI_LC_247.
NOTE: There were 632 observations read from the data set WORK.PPI_LC_248.
NOTE: There were 131 observations read from the data set WORK.PPI_LC_249.
NOTE: There were 326 observations read from the data set WORK.PPI_LC_25.
NOTE: There were 6521 observations read from the data set WORK.PPI_LC_250.
NOTE: There were 885 observations read from the data set WORK.PPI_LC_251.
NOTE: There were 42115 observations read from the data set WORK.PPI_LC_252.
NOTE: There were 616 observations read from the data set WORK.PPI_LC_253.
NOTE: There were 118 observations read from the data set WORK.PPI_LC_254.
NOTE: There were 6931 observations read from the data set WORK.PPI_LC_255.
NOTE: There were 374 observations read from the data set WORK.PPI_LC_256.
NOTE: There were 40793 observations read from the data set WORK.PPI_LC_257.
NOTE: There were 629 observations read from the data set WORK.PPI_LC_258.
NOTE: There were 117 observations read from the data set WORK.PPI_LC_259.
NOTE: There were 10714 observations read from the data set WORK.PPI_LC_26.
NOTE: There were 5924 observations read from the data set WORK.PPI_LC_260.
NOTE: There were 730 observations read from the data set WORK.PPI_LC_261.
NOTE: There were 38303 observations read from the data set WORK.PPI_LC_262.
NOTE: There were 535 observations read from the data set WORK.PPI_LC_263.
NOTE: There were 119 observations read from the data set WORK.PPI_LC_264.
NOTE: There were 7742 observations read from the data set WORK.PPI_LC_265.
NOTE: There were 51083 observations read from the data set WORK.PPI_LC_266.
NOTE: There were 589 observations read from the data set WORK.PPI_LC_267.
NOTE: There were 190 observations read from the data set WORK.PPI_LC_268.
NOTE: There were 6972 observations read from the data set WORK.PPI_LC_269.
NOTE: There were 85833 observations read from the data set WORK.PPI_LC_27.
NOTE: There were 50871 observations read from the data set WORK.PPI_LC_270.
NOTE: There were 527 observations read from the data set WORK.PPI_LC_271.
NOTE: There were 144 observations read from the data set WORK.PPI_LC_272.
NOTE: There were 7044 observations read from the data set WORK.PPI_LC_273.
NOTE: There were 49180 observations read from the data set WORK.PPI_LC_274.
NOTE: There were 534 observations read from the data set WORK.PPI_LC_275.
NOTE: There were 171 observations read from the data set WORK.PPI_LC_276.
NOTE: There were 7148 observations read from the data set WORK.PPI_LC_277.
NOTE: There were 49831 observations read from the data set WORK.PPI_LC_278.
NOTE: There were 542 observations read from the data set WORK.PPI_LC_279.
NOTE: There were 817 observations read from the data set WORK.PPI_LC_28.
NOTE: There were 143 observations read from the data set WORK.PPI_LC_280.
NOTE: There were 7662 observations read from the data set WORK.PPI_LC_281.
NOTE: There were 48464 observations read from the data set WORK.PPI_LC_282.
NOTE: There were 593 observations read from the data set WORK.PPI_LC_283.
NOTE: There were 145 observations read from the data set WORK.PPI_LC_284.
NOTE: There were 7220 observations read from the data set WORK.PPI_LC_285.
NOTE: There were 31 observations read from the data set WORK.PPI_LC_286.
NOTE: There were 47791 observations read from the data set WORK.PPI_LC_287.
NOTE: There were 530 observations read from the data set WORK.PPI_LC_288.
NOTE: There were 128 observations read from the data set WORK.PPI_LC_289.
NOTE: There were 354 observations read from the data set WORK.PPI_LC_29.
NOTE: There were 7820 observations read from the data set WORK.PPI_LC_290.
NOTE: There were 81 observations read from the data set WORK.PPI_LC_291.
NOTE: There were 46760 observations read from the data set WORK.PPI_LC_292.
NOTE: There were 647 observations read from the data set WORK.PPI_LC_293.
NOTE: There were 118 observations read from the data set WORK.PPI_LC_294.
NOTE: There were 7505 observations read from the data set WORK.PPI_LC_295.
NOTE: There were 13 observations read from the data set WORK.PPI_LC_296.
NOTE: There were 46362 observations read from the data set WORK.PPI_LC_297.
NOTE: There were 610 observations read from the data set WORK.PPI_LC_298.
NOTE: There were 134 observations read from the data set WORK.PPI_LC_299.
NOTE: There were 41816 observations read from the data set WORK.PPI_LC_3.
NOTE: There were 10985 observations read from the data set WORK.PPI_LC_30.
NOTE: There were 7467 observations read from the data set WORK.PPI_LC_300.
NOTE: There were 7 observations read from the data set WORK.PPI_LC_301.
NOTE: There were 45856 observations read from the data set WORK.PPI_LC_302.
NOTE: There were 556 observations read from the data set WORK.PPI_LC_303.
NOTE: There were 106 observations read from the data set WORK.PPI_LC_304.
NOTE: There were 7568 observations read from the data set WORK.PPI_LC_305.
NOTE: There were 1699 observations read from the data set WORK.PPI_LC_306.
NOTE: There were 45433 observations read from the data set WORK.PPI_LC_307.
NOTE: There were 590 observations read from the data set WORK.PPI_LC_308.
NOTE: There were 145 observations read from the data set WORK.PPI_LC_309.
NOTE: There were 86456 observations read from the data set WORK.PPI_LC_31.
NOTE: There were 7445 observations read from the data set WORK.PPI_LC_310.
NOTE: There were 555 observations read from the data set WORK.PPI_LC_311.
NOTE: There were 41601 observations read from the data set WORK.PPI_LC_312.
NOTE: There were 593 observations read from the data set WORK.PPI_LC_313.
NOTE: There were 126 observations read from the data set WORK.PPI_LC_314.
NOTE: There were 7438 observations read from the data set WORK.PPI_LC_315.
NOTE: There were 898 observations read from the data set WORK.PPI_LC_316.
NOTE: There were 42155 observations read from the data set WORK.PPI_LC_317.
NOTE: There were 619 observations read from the data set WORK.PPI_LC_318.
NOTE: There were 127 observations read from the data set WORK.PPI_LC_319.
NOTE: There were 866 observations read from the data set WORK.PPI_LC_32.
NOTE: There were 7124 observations read from the data set WORK.PPI_LC_320.
NOTE: There were 455 observations read from the data set WORK.PPI_LC_321.
NOTE: There were 39899 observations read from the data set WORK.PPI_LC_322.
NOTE: There were 548 observations read from the data set WORK.PPI_LC_323.
NOTE: There were 115 observations read from the data set WORK.PPI_LC_324.
NOTE: There were 6478 observations read from the data set WORK.PPI_LC_325.
NOTE: There were 824 observations read from the data set WORK.PPI_LC_326.
NOTE: There were 38280 observations read from the data set WORK.PPI_LC_327.
NOTE: There were 540 observations read from the data set WORK.PPI_LC_328.
NOTE: There were 133 observations read from the data set WORK.PPI_LC_329.
NOTE: There were 267 observations read from the data set WORK.PPI_LC_33.
NOTE: There were 7074 observations read from the data set WORK.PPI_LC_330.
NOTE: There were 367 observations read from the data set WORK.PPI_LC_331.
NOTE: There were 37394 observations read from the data set WORK.PPI_LC_332.
NOTE: There were 538 observations read from the data set WORK.PPI_LC_333.
NOTE: There were 82 observations read from the data set WORK.PPI_LC_334.
NOTE: There were 5835 observations read from the data set WORK.PPI_LC_335.
NOTE: There were 682 observations read from the data set WORK.PPI_LC_336.
NOTE: There were 35373 observations read from the data set WORK.PPI_LC_337.
NOTE: There were 462 observations read from the data set WORK.PPI_LC_338.
NOTE: There were 99 observations read from the data set WORK.PPI_LC_339.
NOTE: There were 11892 observations read from the data set WORK.PPI_LC_34.
NOTE: There were 4831 observations read from the data set WORK.PPI_LC_340.
NOTE: There were 44211 observations read from the data set WORK.PPI_LC_341.
NOTE: There were 574 observations read from the data set WORK.PPI_LC_342.
NOTE: There were 141 observations read from the data set WORK.PPI_LC_343.
NOTE: There were 4582 observations read from the data set WORK.PPI_LC_344.
NOTE: There were 1 observations read from the data set WORK.PPI_LC_345.
NOTE: There were 46627 observations read from the data set WORK.PPI_LC_346.
NOTE: There were 531 observations read from the data set WORK.PPI_LC_347.
NOTE: There were 102 observations read from the data set WORK.PPI_LC_348.
NOTE: There were 5403 observations read from the data set WORK.PPI_LC_349.
NOTE: There were 14 observations read from the data set WORK.PPI_LC_35.
NOTE: There were 2 observations read from the data set WORK.PPI_LC_350.
NOTE: There were 42258 observations read from the data set WORK.PPI_LC_351.
NOTE: There were 490 observations read from the data set WORK.PPI_LC_352.
NOTE: There were 126 observations read from the data set WORK.PPI_LC_353.
NOTE: There were 5511 observations read from the data set WORK.PPI_LC_354.
NOTE: There were 17 observations read from the data set WORK.PPI_LC_355.
NOTE: There were 43533 observations read from the data set WORK.PPI_LC_356.
NOTE: There were 491 observations read from the data set WORK.PPI_LC_357.
NOTE: There were 104 observations read from the data set WORK.PPI_LC_358.
NOTE: There were 6180 observations read from the data set WORK.PPI_LC_359.
NOTE: There were 85067 observations read from the data set WORK.PPI_LC_36.
NOTE: There were 65 observations read from the data set WORK.PPI_LC_360.
NOTE: There were 44680 observations read from the data set WORK.PPI_LC_361.
NOTE: There were 578 observations read from the data set WORK.PPI_LC_362.
NOTE: There were 111 observations read from the data set WORK.PPI_LC_363.
NOTE: There were 6004 observations read from the data set WORK.PPI_LC_364.
NOTE: There were 15 observations read from the data set WORK.PPI_LC_365.
NOTE: There were 44228 observations read from the data set WORK.PPI_LC_366.
NOTE: There were 561 observations read from the data set WORK.PPI_LC_367.
NOTE: There were 110 observations read from the data set WORK.PPI_LC_368.
NOTE: There were 6030 observations read from the data set WORK.PPI_LC_369.
NOTE: There were 916 observations read from the data set WORK.PPI_LC_37.
NOTE: There were 10 observations read from the data set WORK.PPI_LC_370.
NOTE: There were 43828 observations read from the data set WORK.PPI_LC_371.
NOTE: There were 590 observations read from the data set WORK.PPI_LC_372.
NOTE: There were 80 observations read from the data set WORK.PPI_LC_373.
NOTE: There were 6212 observations read from the data set WORK.PPI_LC_374.
NOTE: There were 1650 observations read from the data set WORK.PPI_LC_375.
NOTE: There were 44557 observations read from the data set WORK.PPI_LC_376.
NOTE: There were 637 observations read from the data set WORK.PPI_LC_377.
NOTE: There were 132 observations read from the data set WORK.PPI_LC_378.
NOTE: There were 6565 observations read from the data set WORK.PPI_LC_379.
NOTE: There were 265 observations read from the data set WORK.PPI_LC_38.
NOTE: There were 531 observations read from the data set WORK.PPI_LC_380.
NOTE: There were 43580 observations read from the data set WORK.PPI_LC_381.
NOTE: There were 612 observations read from the data set WORK.PPI_LC_382.
NOTE: There were 97 observations read from the data set WORK.PPI_LC_383.
NOTE: There were 6257 observations read from the data set WORK.PPI_LC_384.
NOTE: There were 861 observations read from the data set WORK.PPI_LC_385.
NOTE: There were 43626 observations read from the data set WORK.PPI_LC_386.
NOTE: There were 642 observations read from the data set WORK.PPI_LC_387.
NOTE: There were 135 observations read from the data set WORK.PPI_LC_388.
NOTE: There were 6468 observations read from the data set WORK.PPI_LC_389.
NOTE: There were 12115 observations read from the data set WORK.PPI_LC_39.
NOTE: There were 464 observations read from the data set WORK.PPI_LC_390.
NOTE: There were 42061 observations read from the data set WORK.PPI_LC_391.
NOTE: There were 626 observations read from the data set WORK.PPI_LC_392.
NOTE: There were 113 observations read from the data set WORK.PPI_LC_393.
NOTE: There were 6219 observations read from the data set WORK.PPI_LC_394.
NOTE: There were 876 observations read from the data set WORK.PPI_LC_395.
NOTE: There were 42372 observations read from the data set WORK.PPI_LC_396.
NOTE: There were 632 observations read from the data set WORK.PPI_LC_397.
NOTE: There were 114 observations read from the data set WORK.PPI_LC_398.
NOTE: There were 6841 observations read from the data set WORK.PPI_LC_399.
NOTE: There were 50 observations read from the data set WORK.PPI_LC_4.
NOTE: There were 76 observations read from the data set WORK.PPI_LC_40.
NOTE: There were 416 observations read from the data set WORK.PPI_LC_400.
NOTE: There were 41228 observations read from the data set WORK.PPI_LC_401.
NOTE: There were 574 observations read from the data set WORK.PPI_LC_402.
NOTE: There were 93 observations read from the data set WORK.PPI_LC_403.
NOTE: There were 5722 observations read from the data set WORK.PPI_LC_404.
NOTE: There were 777 observations read from the data set WORK.PPI_LC_405.
NOTE: There were 38659 observations read from the data set WORK.PPI_LC_406.
NOTE: There were 512 observations read from the data set WORK.PPI_LC_407.
NOTE: There were 96 observations read from the data set WORK.PPI_LC_408.
NOTE: There were 5133 observations read from the data set WORK.PPI_LC_409.
NOTE: There were 83537 observations read from the data set WORK.PPI_LC_41.
NOTE: There were 2 observations read from the data set WORK.PPI_LC_410.
NOTE: There were 46731 observations read from the data set WORK.PPI_LC_411.
NOTE: There were 618 observations read from the data set WORK.PPI_LC_412.
NOTE: There were 100 observations read from the data set WORK.PPI_LC_413.
NOTE: There were 5471 observations read from the data set WORK.PPI_LC_414.
NOTE: There were 3 observations read from the data set WORK.PPI_LC_415.
NOTE: There were 50031 observations read from the data set WORK.PPI_LC_416.
NOTE: There were 575 observations read from the data set WORK.PPI_LC_417.
NOTE: There were 89 observations read from the data set WORK.PPI_LC_418.
NOTE: There were 6127 observations read from the data set WORK.PPI_LC_419.
NOTE: There were 993 observations read from the data set WORK.PPI_LC_42.
NOTE: There were 49311 observations read from the data set WORK.PPI_LC_420.
NOTE: There were 597 observations read from the data set WORK.PPI_LC_421.
NOTE: There were 113 observations read from the data set WORK.PPI_LC_422.
NOTE: There were 6308 observations read from the data set WORK.PPI_LC_423.
NOTE: There were 19 observations read from the data set WORK.PPI_LC_424.
NOTE: There were 50668 observations read from the data set WORK.PPI_LC_425.
NOTE: There were 635 observations read from the data set WORK.PPI_LC_426.
NOTE: There were 96 observations read from the data set WORK.PPI_LC_427.
NOTE: There were 6855 observations read from the data set WORK.PPI_LC_428.
NOTE: There were 68 observations read from the data set WORK.PPI_LC_429.
NOTE: There were 275 observations read from the data set WORK.PPI_LC_43.
NOTE: There were 52117 observations read from the data set WORK.PPI_LC_430.
NOTE: There were 716 observations read from the data set WORK.PPI_LC_431.
NOTE: There were 109 observations read from the data set WORK.PPI_LC_432.
NOTE: There were 6825 observations read from the data set WORK.PPI_LC_433.
NOTE: There were 15 observations read from the data set WORK.PPI_LC_434.
NOTE: There were 54011 observations read from the data set WORK.PPI_LC_435.
NOTE: There were 727 observations read from the data set WORK.PPI_LC_436.
NOTE: There were 149 observations read from the data set WORK.PPI_LC_437.
NOTE: There were 7001 observations read from the data set WORK.PPI_LC_438.
NOTE: There were 12 observations read from the data set WORK.PPI_LC_439.
NOTE: There were 12754 observations read from the data set WORK.PPI_LC_44.
NOTE: There were 55266 observations read from the data set WORK.PPI_LC_440.
NOTE: There were 797 observations read from the data set WORK.PPI_LC_441.
NOTE: There were 137 observations read from the data set WORK.PPI_LC_442.
NOTE: There were 7264 observations read from the data set WORK.PPI_LC_443.
NOTE: There were 2110 observations read from the data set WORK.PPI_LC_444.
NOTE: There were 57365 observations read from the data set WORK.PPI_LC_445.
NOTE: There were 809 observations read from the data set WORK.PPI_LC_446.
NOTE: There were 143 observations read from the data set WORK.PPI_LC_447.
NOTE: There were 7678 observations read from the data set WORK.PPI_LC_448.
NOTE: There were 698 observations read from the data set WORK.PPI_LC_449.
NOTE: There were 1387 observations read from the data set WORK.PPI_LC_45.
NOTE: There were 56221 observations read from the data set WORK.PPI_LC_450.
NOTE: There were 832 observations read from the data set WORK.PPI_LC_451.
NOTE: There were 123 observations read from the data set WORK.PPI_LC_452.
NOTE: There were 7730 observations read from the data set WORK.PPI_LC_453.
NOTE: There were 1058 observations read from the data set WORK.PPI_LC_454.
NOTE: There were 58184 observations read from the data set WORK.PPI_LC_455.
NOTE: There were 900 observations read from the data set WORK.PPI_LC_456.
NOTE: There were 114 observations read from the data set WORK.PPI_LC_457.
NOTE: There were 8301 observations read from the data set WORK.PPI_LC_458.
NOTE: There were 527 observations read from the data set WORK.PPI_LC_459.
NOTE: There were 84021 observations read from the data set WORK.PPI_LC_46.
NOTE: There were 57664 observations read from the data set WORK.PPI_LC_460.
NOTE: There were 841 observations read from the data set WORK.PPI_LC_461.
NOTE: There were 134 observations read from the data set WORK.PPI_LC_462.
NOTE: There were 8379 observations read from the data set WORK.PPI_LC_463.
NOTE: There were 1108 observations read from the data set WORK.PPI_LC_464.
NOTE: There were 59915 observations read from the data set WORK.PPI_LC_465.
NOTE: There were 950 observations read from the data set WORK.PPI_LC_466.
NOTE: There were 144 observations read from the data set WORK.PPI_LC_467.
NOTE: There were 9452 observations read from the data set WORK.PPI_LC_468.
NOTE: There were 550 observations read from the data set WORK.PPI_LC_469.
NOTE: There were 1002 observations read from the data set WORK.PPI_LC_47.
NOTE: There were 59668 observations read from the data set WORK.PPI_LC_470.
NOTE: There were 914 observations read from the data set WORK.PPI_LC_471.
NOTE: There were 157 observations read from the data set WORK.PPI_LC_472.
NOTE: There were 7849 observations read from the data set WORK.PPI_LC_473.
NOTE: There were 1032 observations read from the data set WORK.PPI_LC_474.
NOTE: There were 56139 observations read from the data set WORK.PPI_LC_475.
NOTE: There were 896 observations read from the data set WORK.PPI_LC_476.
NOTE: There were 166 observations read from the data set WORK.PPI_LC_477.
NOTE: There were 15666 observations read from the data set WORK.PPI_LC_478.
NOTE: There were 90715 observations read from the data set WORK.PPI_LC_479.
NOTE: There were 267 observations read from the data set WORK.PPI_LC_48.
NOTE: There were 641 observations read from the data set WORK.PPI_LC_480.
NOTE: There were 412 observations read from the data set WORK.PPI_LC_481.
NOTE: There were 8480 observations read from the data set WORK.PPI_LC_482.
NOTE: There were 56827 observations read from the data set WORK.PPI_LC_483.
NOTE: There were 653 observations read from the data set WORK.PPI_LC_484.
NOTE: There were 220 observations read from the data set WORK.PPI_LC_485.
NOTE: There were 9276 observations read from the data set WORK.PPI_LC_486.
NOTE: There were 63961 observations read from the data set WORK.PPI_LC_487.
NOTE: There were 815 observations read from the data set WORK.PPI_LC_488.
NOTE: There were 249 observations read from the data set WORK.PPI_LC_489.
NOTE: There were 12665 observations read from the data set WORK.PPI_LC_49.
NOTE: There were 10002 observations read from the data set WORK.PPI_LC_490.
NOTE: There were 1 observations read from the data set WORK.PPI_LC_491.
NOTE: There were 73721 observations read from the data set WORK.PPI_LC_492.
NOTE: There were 995 observations read from the data set WORK.PPI_LC_493.
NOTE: There were 252 observations read from the data set WORK.PPI_LC_494.
NOTE: There were 9658 observations read from the data set WORK.PPI_LC_495.
NOTE: There were 75866 observations read from the data set WORK.PPI_LC_496.
NOTE: There were 1043 observations read from the data set WORK.PPI_LC_497.
NOTE: There were 299 observations read from the data set WORK.PPI_LC_498.
NOTE: There were 5609 observations read from the data set WORK.PPI_LC_499.
NOTE: There were 218 observations read from the data set WORK.PPI_LC_5.
NOTE: There were 1222 observations read from the data set WORK.PPI_LC_50.
NOTE: There were 44770 observations read from the data set WORK.PPI_LC_500.
NOTE: There were 530 observations read from the data set WORK.PPI_LC_501.
NOTE: There were 138 observations read from the data set WORK.PPI_LC_502.
NOTE: There were 6009 observations read from the data set WORK.PPI_LC_503.
NOTE: There were 50060 observations read from the data set WORK.PPI_LC_504.
NOTE: There were 560 observations read from the data set WORK.PPI_LC_505.
NOTE: There were 186 observations read from the data set WORK.PPI_LC_506.
NOTE: There were 6435 observations read from the data set WORK.PPI_LC_507.
NOTE: There were 49600 observations read from the data set WORK.PPI_LC_508.
NOTE: There were 592 observations read from the data set WORK.PPI_LC_509.
NOTE: There were 80370 observations read from the data set WORK.PPI_LC_51.
NOTE: There were 227 observations read from the data set WORK.PPI_LC_510.
NOTE: There were 6174 observations read from the data set WORK.PPI_LC_511.
NOTE: There were 50635 observations read from the data set WORK.PPI_LC_512.
NOTE: There were 526 observations read from the data set WORK.PPI_LC_513.
NOTE: There were 143 observations read from the data set WORK.PPI_LC_514.
NOTE: There were 6390 observations read from the data set WORK.PPI_LC_515.
NOTE: There were 1 observations read from the data set WORK.PPI_LC_516.
NOTE: There were 49566 observations read from the data set WORK.PPI_LC_517.
NOTE: There were 602 observations read from the data set WORK.PPI_LC_518.
NOTE: There were 139 observations read from the data set WORK.PPI_LC_519.
NOTE: There were 977 observations read from the data set WORK.PPI_LC_52.
NOTE: There were 6527 observations read from the data set WORK.PPI_LC_520.
NOTE: There were 1 observations read from the data set WORK.PPI_LC_521.
NOTE: There were 49380 observations read from the data set WORK.PPI_LC_522.
NOTE: There were 553 observations read from the data set WORK.PPI_LC_523.
NOTE: There were 158 observations read from the data set WORK.PPI_LC_524.
NOTE: There were 7064 observations read from the data set WORK.PPI_LC_525.
NOTE: There were 1 observations read from the data set WORK.PPI_LC_526.
NOTE: There were 47951 observations read from the data set WORK.PPI_LC_527.
NOTE: There were 590 observations read from the data set WORK.PPI_LC_528.
NOTE: There were 160 observations read from the data set WORK.PPI_LC_529.
NOTE: There were 219 observations read from the data set WORK.PPI_LC_53.
NOTE: There were 6872 observations read from the data set WORK.PPI_LC_530.
NOTE: There were 34 observations read from the data set WORK.PPI_LC_531.
NOTE: There were 48652 observations read from the data set WORK.PPI_LC_532.
NOTE: There were 627 observations read from the data set WORK.PPI_LC_533.
NOTE: There were 147 observations read from the data set WORK.PPI_LC_534.
NOTE: There were 7257 observations read from the data set WORK.PPI_LC_535.
NOTE: There were 97 observations read from the data set WORK.PPI_LC_536.
NOTE: There were 48101 observations read from the data set WORK.PPI_LC_537.
NOTE: There were 679 observations read from the data set WORK.PPI_LC_538.
NOTE: There were 126 observations read from the data set WORK.PPI_LC_539.
NOTE: There were 11937 observations read from the data set WORK.PPI_LC_54.
NOTE: There were 7305 observations read from the data set WORK.PPI_LC_540.
NOTE: There were 9 observations read from the data set WORK.PPI_LC_541.
NOTE: There were 46778 observations read from the data set WORK.PPI_LC_542.
NOTE: There were 630 observations read from the data set WORK.PPI_LC_543.
NOTE: There were 156 observations read from the data set WORK.PPI_LC_544.
NOTE: There were 7151 observations read from the data set WORK.PPI_LC_545.
NOTE: There were 5 observations read from the data set WORK.PPI_LC_546.
NOTE: There were 45891 observations read from the data set WORK.PPI_LC_547.
NOTE: There were 578 observations read from the data set WORK.PPI_LC_548.
NOTE: There were 136 observations read from the data set WORK.PPI_LC_549.
NOTE: There were 1149 observations read from the data set WORK.PPI_LC_55.
NOTE: There were 7157 observations read from the data set WORK.PPI_LC_550.
NOTE: There were 1782 observations read from the data set WORK.PPI_LC_551.
NOTE: There were 45295 observations read from the data set WORK.PPI_LC_552.
NOTE: There were 572 observations read from the data set WORK.PPI_LC_553.
NOTE: There were 165 observations read from the data set WORK.PPI_LC_554.
NOTE: There were 7216 observations read from the data set WORK.PPI_LC_555.
NOTE: There were 602 observations read from the data set WORK.PPI_LC_556.
NOTE: There were 42934 observations read from the data set WORK.PPI_LC_557.
NOTE: There were 619 observations read from the data set WORK.PPI_LC_558.
NOTE: There were 152 observations read from the data set WORK.PPI_LC_559.
NOTE: There were 75565 observations read from the data set WORK.PPI_LC_56.
NOTE: There were 7010 observations read from the data set WORK.PPI_LC_560.
NOTE: There were 898 observations read from the data set WORK.PPI_LC_561.
NOTE: There were 43130 observations read from the data set WORK.PPI_LC_562.
NOTE: There were 656 observations read from the data set WORK.PPI_LC_563.
NOTE: There were 149 observations read from the data set WORK.PPI_LC_564.
NOTE: There were 7177 observations read from the data set WORK.PPI_LC_565.
NOTE: There were 519 observations read from the data set WORK.PPI_LC_566.
NOTE: There were 40797 observations read from the data set WORK.PPI_LC_567.
NOTE: There were 591 observations read from the data set WORK.PPI_LC_568.
NOTE: There were 132 observations read from the data set WORK.PPI_LC_569.
NOTE: There were 985 observations read from the data set WORK.PPI_LC_57.
NOTE: There were 6578 observations read from the data set WORK.PPI_LC_570.
NOTE: There were 915 observations read from the data set WORK.PPI_LC_571.
NOTE: There were 39984 observations read from the data set WORK.PPI_LC_572.
NOTE: There were 562 observations read from the data set WORK.PPI_LC_573.
NOTE: There were 120 observations read from the data set WORK.PPI_LC_574.
NOTE: There were 7050 observations read from the data set WORK.PPI_LC_575.
NOTE: There were 393 observations read from the data set WORK.PPI_LC_576.
NOTE: There were 38856 observations read from the data set WORK.PPI_LC_577.
NOTE: There were 519 observations read from the data set WORK.PPI_LC_578.
NOTE: There were 116 observations read from the data set WORK.PPI_LC_579.
NOTE: There were 241 observations read from the data set WORK.PPI_LC_58.
NOTE: There were 5919 observations read from the data set WORK.PPI_LC_580.
NOTE: There were 761 observations read from the data set WORK.PPI_LC_581.
NOTE: There were 36902 observations read from the data set WORK.PPI_LC_582.
NOTE: There were 526 observations read from the data set WORK.PPI_LC_583.
NOTE: There were 119 observations read from the data set WORK.PPI_LC_584.
NOTE: There were 6685 observations read from the data set WORK.PPI_LC_585.
NOTE: There were 44363 observations read from the data set WORK.PPI_LC_586.
NOTE: There were 640 observations read from the data set WORK.PPI_LC_587.
NOTE: There were 167 observations read from the data set WORK.PPI_LC_588.
NOTE: There were 7405 observations read from the data set WORK.PPI_LC_589.
NOTE: There were 11703 observations read from the data set WORK.PPI_LC_59.
NOTE: There were 54391 observations read from the data set WORK.PPI_LC_590.
NOTE: There were 752 observations read from the data set WORK.PPI_LC_591.
NOTE: There were 801 observations read from the data set WORK.PPI_LC_592.
NOTE: There were 133 observations read from the data set WORK.PPI_LC_593.
NOTE: There were 22119 observations read from the data set WORK.PPI_LC_594.
NOTE: There were 49983 observations read from the data set WORK.PPI_LC_595.
NOTE: There were 59 observations read from the data set WORK.PPI_LC_596.
NOTE: There were 223 observations read from the data set WORK.PPI_LC_597.
NOTE: There were 5622 observations read from the data set WORK.PPI_LC_598.
NOTE: There were 51024 observations read from the data set WORK.PPI_LC_599.
NOTE: There were 11900 observations read from the data set WORK.PPI_LC_6.
NOTE: There were 963 observations read from the data set WORK.PPI_LC_60.
NOTE: There were 534 observations read from the data set WORK.PPI_LC_600.
NOTE: There were 145 observations read from the data set WORK.PPI_LC_601.
NOTE: There were 6350 observations read from the data set WORK.PPI_LC_602.
NOTE: There were 70550 observations read from the data set WORK.PPI_LC_603.
NOTE: There were 658 observations read from the data set WORK.PPI_LC_604.
NOTE: There were 206 observations read from the data set WORK.PPI_LC_605.
NOTE: There were 6510 observations read from the data set WORK.PPI_LC_606.
NOTE: There were 1 observations read from the data set WORK.PPI_LC_607.
NOTE: There were 77268 observations read from the data set WORK.PPI_LC_608.
NOTE: There were 694 observations read from the data set WORK.PPI_LC_609.
NOTE: There were 71171 observations read from the data set WORK.PPI_LC_61.
NOTE: There were 200 observations read from the data set WORK.PPI_LC_610.
NOTE: There were 7041 observations read from the data set WORK.PPI_LC_611.
NOTE: There were 2 observations read from the data set WORK.PPI_LC_612.
NOTE: There were 79024 observations read from the data set WORK.PPI_LC_613.
NOTE: There were 736 observations read from the data set WORK.PPI_LC_614.
NOTE: There were 177 observations read from the data set WORK.PPI_LC_615.
NOTE: There were 4853 observations read from the data set WORK.PPI_LC_616.
NOTE: There were 6352 observations read from the data set WORK.PPI_LC_617.
NOTE: There were 29 observations read from the data set WORK.PPI_LC_618.
NOTE: There were 8973 observations read from the data set WORK.PPI_LC_619.
NOTE: There were 990 observations read from the data set WORK.PPI_LC_62.
NOTE: There were 43482 observations read from the data set WORK.PPI_LC_620.
NOTE: There were 596 observations read from the data set WORK.PPI_LC_621.
NOTE: There were 138 observations read from the data set WORK.PPI_LC_622.
NOTE: There were 6768 observations read from the data set WORK.PPI_LC_623.
NOTE: There were 45486 observations read from the data set WORK.PPI_LC_624.
NOTE: There were 657 observations read from the data set WORK.PPI_LC_625.
NOTE: There were 157 observations read from the data set WORK.PPI_LC_626.
NOTE: There were 6885 observations read from the data set WORK.PPI_LC_627.
NOTE: There were 53933 observations read from the data set WORK.PPI_LC_628.
NOTE: There were 699 observations read from the data set WORK.PPI_LC_629.
NOTE: There were 224 observations read from the data set WORK.PPI_LC_63.
NOTE: There were 177 observations read from the data set WORK.PPI_LC_630.
NOTE: There were 6564 observations read from the data set WORK.PPI_LC_631.
NOTE: There were 27753 observations read from the data set WORK.PPI_LC_632.
NOTE: There were 122 observations read from the data set WORK.PPI_LC_633.
NOTE: There were 111 observations read from the data set WORK.PPI_LC_634.
NOTE: There were 7223 observations read from the data set WORK.PPI_LC_635.
NOTE: There were 34711 observations read from the data set WORK.PPI_LC_636.
NOTE: There were 348 observations read from the data set WORK.PPI_LC_637.
NOTE: There were 182 observations read from the data set WORK.PPI_LC_638.
NOTE: There were 6551 observations read from the data set WORK.PPI_LC_639.
NOTE: There were 5811 observations read from the data set WORK.PPI_LC_64.
NOTE: There were 41914 observations read from the data set WORK.PPI_LC_640.
NOTE: There were 498 observations read from the data set WORK.PPI_LC_641.
NOTE: There were 175 observations read from the data set WORK.PPI_LC_642.
NOTE: There were 7695 observations read from the data set WORK.PPI_LC_643.
NOTE: There were 28 observations read from the data set WORK.PPI_LC_644.
NOTE: There were 79552 observations read from the data set WORK.PPI_LC_645.
NOTE: There were 784 observations read from the data set WORK.PPI_LC_646.
NOTE: There were 180 observations read from the data set WORK.PPI_LC_647.
NOTE: There were 8341 observations read from the data set WORK.PPI_LC_648.
NOTE: There were 110 observations read from the data set WORK.PPI_LC_649.
NOTE: There were 11041 observations read from the data set WORK.PPI_LC_65.
NOTE: There were 82833 observations read from the data set WORK.PPI_LC_650.
NOTE: There were 862 observations read from the data set WORK.PPI_LC_651.
NOTE: There were 151 observations read from the data set WORK.PPI_LC_652.
NOTE: There were 3308 observations read from the data set WORK.PPI_LC_653.
NOTE: There were 2 observations read from the data set WORK.PPI_LC_654.
NOTE: There were 41927 observations read from the data set WORK.PPI_LC_655.
NOTE: There were 398 observations read from the data set WORK.PPI_LC_656.
NOTE: There were 82 observations read from the data set WORK.PPI_LC_657.
NOTE: There were 2442 observations read from the data set WORK.PPI_LC_658.
NOTE: There were 20113 observations read from the data set WORK.PPI_LC_659.
NOTE: There were 29 observations read from the data set WORK.PPI_LC_66.
NOTE: There were 355 observations read from the data set WORK.PPI_LC_660.
NOTE: There were 62 observations read from the data set WORK.PPI_LC_661.
NOTE: There were 2901 observations read from the data set WORK.PPI_LC_662.
NOTE: There were 33267 observations read from the data set WORK.PPI_LC_663.
NOTE: There were 376 observations read from the data set WORK.PPI_LC_664.
NOTE: There were 84 observations read from the data set WORK.PPI_LC_665.
NOTE: There were 3026 observations read from the data set WORK.PPI_LC_666.
NOTE: There were 39020 observations read from the data set WORK.PPI_LC_667.
NOTE: There were 384 observations read from the data set WORK.PPI_LC_668.
NOTE: There were 68 observations read from the data set WORK.PPI_LC_669.
NOTE: There were 8585 observations read from the data set WORK.PPI_LC_67.
NOTE: There were 9266 observations read from the data set WORK.PPI_LC_670.
NOTE: There were 2155 observations read from the data set WORK.PPI_LC_671.
NOTE: There were 87278 observations read from the data set WORK.PPI_LC_672.
NOTE: There were 974 observations read from the data set WORK.PPI_LC_673.
NOTE: There were 223 observations read from the data set WORK.PPI_LC_674.
NOTE: There were 3921 observations read from the data set WORK.PPI_LC_675.
NOTE: There were 14 observations read from the data set WORK.PPI_LC_676.
NOTE: There were 44141 observations read from the data set WORK.PPI_LC_677.
NOTE: There were 442 observations read from the data set WORK.PPI_LC_678.
NOTE: There were 92 observations read from the data set WORK.PPI_LC_679.
NOTE: There were 20400 observations read from the data set WORK.PPI_LC_68.
NOTE: There were 4062 observations read from the data set WORK.PPI_LC_680.
NOTE: There were 47 observations read from the data set WORK.PPI_LC_681.
NOTE: There were 47172 observations read from the data set WORK.PPI_LC_682.
NOTE: There were 549 observations read from the data set WORK.PPI_LC_683.
NOTE: There were 88 observations read from the data set WORK.PPI_LC_684.
NOTE: There were 4671 observations read from the data set WORK.PPI_LC_685.
NOTE: There were 1193 observations read from the data set WORK.PPI_LC_686.
NOTE: There were 50972 observations read from the data set WORK.PPI_LC_687.
NOTE: There were 633 observations read from the data set WORK.PPI_LC_688.
NOTE: There were 103 observations read from the data set WORK.PPI_LC_689.
NOTE: There were 60 observations read from the data set WORK.PPI_LC_69.
NOTE: There were 4878 observations read from the data set WORK.PPI_LC_690.
NOTE: There were 674 observations read from the data set WORK.PPI_LC_691.
NOTE: There were 43416 observations read from the data set WORK.PPI_LC_692.
NOTE: There were 507 observations read from the data set WORK.PPI_LC_693.
NOTE: There were 114 observations read from the data set WORK.PPI_LC_694.
NOTE: There were 5355 observations read from the data set WORK.PPI_LC_695.
NOTE: There were 1162 observations read from the data set WORK.PPI_LC_696.
NOTE: There were 46408 observations read from the data set WORK.PPI_LC_697.
NOTE: There were 625 observations read from the data set WORK.PPI_LC_698.
NOTE: There were 125 observations read from the data set WORK.PPI_LC_699.
NOTE: There were 51047 observations read from the data set WORK.PPI_LC_7.
NOTE: There were 22975 observations read from the data set WORK.PPI_LC_70.
NOTE: There were 5291 observations read from the data set WORK.PPI_LC_700.
NOTE: There were 633 observations read from the data set WORK.PPI_LC_701.
NOTE: There were 46154 observations read from the data set WORK.PPI_LC_702.
NOTE: There were 601 observations read from the data set WORK.PPI_LC_703.
NOTE: There were 135 observations read from the data set WORK.PPI_LC_704.
NOTE: There were 5317 observations read from the data set WORK.PPI_LC_705.
NOTE: There were 1267 observations read from the data set WORK.PPI_LC_706.
NOTE: There were 48412 observations read from the data set WORK.PPI_LC_707.
NOTE: There were 679 observations read from the data set WORK.PPI_LC_708.
NOTE: There were 129 observations read from the data set WORK.PPI_LC_709.
NOTE: There were 53208 observations read from the data set WORK.PPI_LC_71.
NOTE: There were 6278 observations read from the data set WORK.PPI_LC_710.
NOTE: There were 615 observations read from the data set WORK.PPI_LC_711.
NOTE: There were 50019 observations read from the data set WORK.PPI_LC_712.
NOTE: There were 642 observations read from the data set WORK.PPI_LC_713.
NOTE: There were 114 observations read from the data set WORK.PPI_LC_714.
NOTE: There were 7337 observations read from the data set WORK.PPI_LC_715.
NOTE: There were 1212 observations read from the data set WORK.PPI_LC_716.
NOTE: There were 52858 observations read from the data set WORK.PPI_LC_717.
NOTE: There were 738 observations read from the data set WORK.PPI_LC_718.
NOTE: There were 188 observations read from the data set WORK.PPI_LC_719.
NOTE: There were 98 observations read from the data set WORK.PPI_LC_72.
NOTE: There were 10273 observations read from the data set WORK.PPI_LC_720.
NOTE: There were 691 observations read from the data set WORK.PPI_LC_721.
NOTE: There were 60491 observations read from the data set WORK.PPI_LC_722.
NOTE: There were 872 observations read from the data set WORK.PPI_LC_723.
NOTE: There were 202 observations read from the data set WORK.PPI_LC_724.
NOTE: There were 11280 observations read from the data set WORK.PPI_LC_725.
NOTE: There were 1158 observations read from the data set WORK.PPI_LC_726.
NOTE: There were 65736 observations read from the data set WORK.PPI_LC_727.
NOTE: There were 953 observations read from the data set WORK.PPI_LC_728.
NOTE: There were 240 observations read from the data set WORK.PPI_LC_729.
NOTE: There were 185 observations read from the data set WORK.PPI_LC_73.
NOTE: There were 2599 observations read from the data set WORK.PPI_LC_730.
NOTE: There were 387 observations read from the data set WORK.PPI_LC_731.
NOTE: There were 25879 observations read from the data set WORK.PPI_LC_732.
NOTE: There were 318 observations read from the data set WORK.PPI_LC_733.
NOTE: There were 50 observations read from the data set WORK.PPI_LC_734.
NOTE: There were 2722 observations read from the data set WORK.PPI_LC_735.
NOTE: There were 628 observations read from the data set WORK.PPI_LC_736.
NOTE: There were 28907 observations read from the data set WORK.PPI_LC_737.
NOTE: There were 370 observations read from the data set WORK.PPI_LC_738.
NOTE: There were 64 observations read from the data set WORK.PPI_LC_739.
NOTE: There were 26689 observations read from the data set WORK.PPI_LC_74.
NOTE: There were 2818 observations read from the data set WORK.PPI_LC_740.
NOTE: There were 374 observations read from the data set WORK.PPI_LC_741.
NOTE: There were 28670 observations read from the data set WORK.PPI_LC_742.
NOTE: There were 388 observations read from the data set WORK.PPI_LC_743.
NOTE: There were 60 observations read from the data set WORK.PPI_LC_744.
NOTE: There were 3133 observations read from the data set WORK.PPI_LC_745.
NOTE: There were 788 observations read from the data set WORK.PPI_LC_746.
NOTE: There were 31302 observations read from the data set WORK.PPI_LC_747.
NOTE: There were 468 observations read from the data set WORK.PPI_LC_748.
NOTE: There were 73 observations read from the data set WORK.PPI_LC_749.
NOTE: There were 73949 observations read from the data set WORK.PPI_LC_75.
NOTE: There were 3801 observations read from the data set WORK.PPI_LC_750.
NOTE: There were 359 observations read from the data set WORK.PPI_LC_751.
NOTE: There were 33246 observations read from the data set WORK.PPI_LC_752.
NOTE: There were 426 observations read from the data set WORK.PPI_LC_753.
NOTE: There were 97 observations read from the data set WORK.PPI_LC_754.
NOTE: There were 4671 observations read from the data set WORK.PPI_LC_755.
NOTE: There were 735 observations read from the data set WORK.PPI_LC_756.
NOTE: There were 36265 observations read from the data set WORK.PPI_LC_757.
NOTE: There were 683 observations read from the data set WORK.PPI_LC_758.
NOTE: There were 68 observations read from the data set WORK.PPI_LC_759.
NOTE: There were 52 observations read from the data set WORK.PPI_LC_76.
NOTE: There were 7536 observations read from the data set WORK.PPI_LC_760.
NOTE: There were 460 observations read from the data set WORK.PPI_LC_761.
NOTE: There were 45158 observations read from the data set WORK.PPI_LC_762.
NOTE: There were 839 observations read from the data set WORK.PPI_LC_763.
NOTE: There were 111 observations read from the data set WORK.PPI_LC_764.
NOTE: There were 8321 observations read from the data set WORK.PPI_LC_765.
NOTE: There were 750 observations read from the data set WORK.PPI_LC_766.
NOTE: There were 53638 observations read from the data set WORK.PPI_LC_767.
NOTE: There were 942 observations read from the data set WORK.PPI_LC_768.
NOTE: There were 132 observations read from the data set WORK.PPI_LC_769.
NOTE: There were 310 observations read from the data set WORK.PPI_LC_77.
NOTE: There were 9189 observations read from the data set WORK.PPI_LC_770.
NOTE: There were 445 observations read from the data set WORK.PPI_LC_771.
NOTE: There were 55260 observations read from the data set WORK.PPI_LC_772.
NOTE: There were 929 observations read from the data set WORK.PPI_LC_773.
NOTE: There were 109 observations read from the data set WORK.PPI_LC_774.
NOTE: There were 7913 observations read from the data set WORK.PPI_LC_775.
NOTE: There were 778 observations read from the data set WORK.PPI_LC_776.
NOTE: There were 54591 observations read from the data set WORK.PPI_LC_777.
NOTE: There were 755 observations read from the data set WORK.PPI_LC_778.
NOTE: There were 101 observations read from the data set WORK.PPI_LC_779.
NOTE: There were 12905 observations read from the data set WORK.PPI_LC_78.
NOTE: There were 11973 observations read from the data set WORK.PPI_LC_780.
NOTE: There were 635 observations read from the data set WORK.PPI_LC_781.
NOTE: There were 63891 observations read from the data set WORK.PPI_LC_782.
NOTE: There were 949 observations read from the data set WORK.PPI_LC_783.
NOTE: There were 190 observations read from the data set WORK.PPI_LC_784.
NOTE: There were 10085 observations read from the data set WORK.PPI_LC_785.
NOTE: There were 1093 observations read from the data set WORK.PPI_LC_786.
NOTE: There were 61469 observations read from the data set WORK.PPI_LC_787.
NOTE: There were 802 observations read from the data set WORK.PPI_LC_788.
NOTE: There were 188 observations read from the data set WORK.PPI_LC_789.
NOTE: There were 81583 observations read from the data set WORK.PPI_LC_79.
NOTE: There were 6744 observations read from the data set WORK.PPI_LC_790.
NOTE: There were 17838 observations read from the data set WORK.PPI_LC_791.
NOTE: There were 6 observations read from the data set WORK.PPI_LC_792.
NOTE: There were 95 observations read from the data set WORK.PPI_LC_793.
NOTE: There were 5972 observations read from the data set WORK.PPI_LC_794.
NOTE: There were 34971 observations read from the data set WORK.PPI_LC_795.
NOTE: There were 244 observations read from the data set WORK.PPI_LC_796.
NOTE: There were 134 observations read from the data set WORK.PPI_LC_797.
NOTE: There were 9899 observations read from the data set WORK.PPI_LC_798.
NOTE: There were 1 observations read from the data set WORK.PPI_LC_799.
NOTE: There were 409 observations read from the data set WORK.PPI_LC_8.
NOTE: There were 1069 observations read from the data set WORK.PPI_LC_80.
NOTE: There were 83829 observations read from the data set WORK.PPI_LC_800.
NOTE: There were 1004 observations read from the data set WORK.PPI_LC_801.
NOTE: There were 210 observations read from the data set WORK.PPI_LC_802.
NOTE: There were 10920 observations read from the data set WORK.PPI_LC_803.
NOTE: There were 1603 observations read from the data set WORK.PPI_LC_804.
NOTE: There were 89140 observations read from the data set WORK.PPI_LC_805.
NOTE: There were 1331 observations read from the data set WORK.PPI_LC_806.
NOTE: There were 217 observations read from the data set WORK.PPI_LC_807.
NOTE: There were 2858 observations read from the data set WORK.PPI_LC_808.
NOTE: There were 30845 observations read from the data set WORK.PPI_LC_809.
NOTE: There were 260 observations read from the data set WORK.PPI_LC_81.
NOTE: There were 313 observations read from the data set WORK.PPI_LC_810.
NOTE: There were 60 observations read from the data set WORK.PPI_LC_811.
NOTE: There were 3088 observations read from the data set WORK.PPI_LC_812.
NOTE: There were 2 observations read from the data set WORK.PPI_LC_813.
NOTE: There were 32156 observations read from the data set WORK.PPI_LC_814.
NOTE: There were 348 observations read from the data set WORK.PPI_LC_815.
NOTE: There were 49 observations read from the data set WORK.PPI_LC_816.
NOTE: There were 3530 observations read from the data set WORK.PPI_LC_817.
NOTE: There were 9 observations read from the data set WORK.PPI_LC_818.
NOTE: There were 34722 observations read from the data set WORK.PPI_LC_819.
NOTE: There were 11972 observations read from the data set WORK.PPI_LC_82.
NOTE: There were 355 observations read from the data set WORK.PPI_LC_820.
NOTE: There were 64 observations read from the data set WORK.PPI_LC_821.
NOTE: There were 4037 observations read from the data set WORK.PPI_LC_822.
NOTE: There were 40 observations read from the data set WORK.PPI_LC_823.
NOTE: There were 36563 observations read from the data set WORK.PPI_LC_824.
NOTE: There were 477 observations read from the data set WORK.PPI_LC_825.
NOTE: There were 60 observations read from the data set WORK.PPI_LC_826.
NOTE: There were 4165 observations read from the data set WORK.PPI_LC_827.
NOTE: There were 942 observations read from the data set WORK.PPI_LC_828.
NOTE: There were 38609 observations read from the data set WORK.PPI_LC_829.
NOTE: There were 81728 observations read from the data set WORK.PPI_LC_83.
NOTE: There were 515 observations read from the data set WORK.PPI_LC_830.
NOTE: There were 72 observations read from the data set WORK.PPI_LC_831.
NOTE: There were 4607 observations read from the data set WORK.PPI_LC_832.
NOTE: There were 799 observations read from the data set WORK.PPI_LC_833.
NOTE: There were 40837 observations read from the data set WORK.PPI_LC_834.
NOTE: There were 621 observations read from the data set WORK.PPI_LC_835.
NOTE: There were 82 observations read from the data set WORK.PPI_LC_836.
NOTE: There were 6659 observations read from the data set WORK.PPI_LC_837.
NOTE: There were 841 observations read from the data set WORK.PPI_LC_838.
NOTE: There were 49547 observations read from the data set WORK.PPI_LC_839.
NOTE: There were 956 observations read from the data set WORK.PPI_LC_84.
NOTE: There were 790 observations read from the data set WORK.PPI_LC_840.
NOTE: There were 123 observations read from the data set WORK.PPI_LC_841.
NOTE: There were 9309 observations read from the data set WORK.PPI_LC_842.
NOTE: There were 894 observations read from the data set WORK.PPI_LC_843.
NOTE: There were 55679 observations read from the data set WORK.PPI_LC_844.
NOTE: There were 267 observations read from the data set WORK.PPI_LC_85.
NOTE: There were 4563 observations read from the data set WORK.PPI_LC_86.
NOTE: There were 18909 observations read from the data set WORK.PPI_LC_87.
NOTE: There were 89 observations read from the data set WORK.PPI_LC_88.
NOTE: There were 31 observations read from the data set WORK.PPI_LC_89.
NOTE: There were 300 observations read from the data set WORK.PPI_LC_9.
NOTE: There were 14303 observations read from the data set WORK.PPI_LC_90.
NOTE: There were 67722 observations read from the data set WORK.PPI_LC_91.
NOTE: There were 823 observations read from the data set WORK.PPI_LC_92.
NOTE: There were 236 observations read from the data set WORK.PPI_LC_93.
NOTE: There were 11057 observations read from the data set WORK.PPI_LC_94.
NOTE: There were 62780 observations read from the data set WORK.PPI_LC_95.
NOTE: There were 1192 observations read from the data set WORK.PPI_LC_96.
NOTE: There were 233 observations read from the data set WORK.PPI_LC_97.
NOTE: There were 17547 observations read from the data set WORK.PPI_LC_98.
NOTE: There were 31009 observations read from the data set WORK.PPI_LC_99.
NOTE: The data set LC.PPI_LC has 11109462 observations and 6 variables.;
data ppi_mistrokeip;
set dx.ppi_mistrokeip;
keep reference_key Admission_Date__yyyy_mm_dd_;run;
data lc.ppi_alllc;
set lc.ppi_lc ppi_mistrokeip;run; 
*NOTE: There were 11109462 observations read from the data set LC.PPI_LC.
NOTE: There were 5880064 observations read from the data set WORK.PPI_MISTROKEIP.
NOTE: The data set LC.PPI_ALLLC has 16989526 observations and 7 variables.;
data a;
set lc.ppi_alllc;
if missing(reference_key);run; *0;
/*adding LC date*/
data lc.ppi_alllc;
set lc.ppi_alllc;
if ~missing(Attendance_Date__yyyy_mm_dd_) then lc_date=input(Attendance_Date__yyyy_mm_dd_, yymmdd10.);
if ~missing(Admission_Date__yyyy_mm_dd_) then lc_date=input(Admission_Date__yyyy_mm_dd_, yymmdd10.);
if ~missing(Appointment_Date__yyyy_mm_dd_) then lc_date=input(Appointment_Date__yyyy_mm_dd_, yymmdd10.);
if ~missing(OT_Date__yyyy_mm_dd_) then lc_date=input(OT_Date__yyyy_mm_dd_, yymmdd10.);
if ~missing(PSY_Form__Service_Date__yyyy_mm_) then lc_date=input(PSY_Form__Service_Date__yyyy_mm_, yymmdd10.);
if ~missing(Injection_Date__yyyy_mm_dd_) then lc_date=input(Injection_Date__yyyy_mm_dd_, yymmdd10.);
format lc_date yymmdd10.;
run;
proc sql;
create table lc.ppi_alllc as
select *, min(lc_date) as min_lc from lc.ppi_alllc group by reference_key;
quit;
data lc.ppi_alllc;
set lc.ppi_alllc;
format min_lc yymmdd10.;
run;
proc sort data=lc.ppi_alllc nodupkey out=lc.pat_lc;
by reference_key;
run; *85803;
proc sql;
create table misslc as
select * from mistroke_txt where VAR1 not in (select reference_key from lc.pat_lc);
quit; *0 missing lc date;
data lc.pat_lc;
set lc.pat_lc;
keep reference_key min_lc;run;

/*Import all drug SAS data 
Updated on 30 May 2016*/
%macro import;
   %do i=1 %to 1193;
   PROC IMPORT OUT= ppi_ad_&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\alldrug\master\mistroke_alldrug_&i..xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%import;
%macro chg;
%do i=1 %to 1193;
data ppi_ad_&i.;
set ppi_ad_&i.;
disp_dur=Dispensing_Duration*1;
run;
%end;
%mend;
%chg;
%macro drop;
%do i=1 %to 1193;
data ppi_ad_&i.;
set ppi_ad_&i.;
drop Dispensing_Duration;
run;
%end;
%mend;
%drop;
data an.alldrug9314;
set ppi_a:;run; *checked with no of entries in JAVA program and retreived excel files:64387977
changed the name of ppi_ad_1000 to ppi_aad_1000;

data a;
set an.alldrug9314;
if missing(reference_key);
run; *0;

PROC EXPORT DATA= an.alldrug9314
            OUTFILE= "W:\Angel\MPhil\cross_check\PPIs_MI\SCCS_original\SAS raw files\alldrug9314.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;

*WARNING: Multiple lengths were specified for the variable Dosage by input data set(s). This may
         cause truncation of data.
WARNING: Multiple lengths were specified for the variable Drug_Frequency by input data set(s).
         This may cause truncation of data.
WARNING: Multiple lengths were specified for the variable Dispensing_Duration_Unit by input data
         set(s). This may cause truncation of data.
NOTE: There were 79092 observations read from the data set WORK.PPI_AAD_1000.
NOTE: There were 96712 observations read from the data set WORK.PPI_AD_1.
NOTE: There were 70438 observations read from the data set WORK.PPI_AD_10.
NOTE: There were 66154 observations read from the data set WORK.PPI_AD_100.
NOTE: There were 84615 observations read from the data set WORK.PPI_AD_1001.
NOTE: There were 87231 observations read from the data set WORK.PPI_AD_1002.
NOTE: There were 91106 observations read from the data set WORK.PPI_AD_1003.
NOTE: There were 49627 observations read from the data set WORK.PPI_AD_1004.
NOTE: There were 52314 observations read from the data set WORK.PPI_AD_1005.
NOTE: There were 44429 observations read from the data set WORK.PPI_AD_1006.
NOTE: There were 44061 observations read from the data set WORK.PPI_AD_1007.
NOTE: There were 50436 observations read from the data set WORK.PPI_AD_1008.
NOTE: There were 54324 observations read from the data set WORK.PPI_AD_1009.
NOTE: There were 66810 observations read from the data set WORK.PPI_AD_101.
NOTE: There were 50106 observations read from the data set WORK.PPI_AD_1010.
NOTE: There were 45355 observations read from the data set WORK.PPI_AD_1011.
NOTE: There were 44223 observations read from the data set WORK.PPI_AD_1012.
NOTE: There were 51255 observations read from the data set WORK.PPI_AD_1013.
NOTE: There were 43327 observations read from the data set WORK.PPI_AD_1014.
NOTE: There were 47058 observations read from the data set WORK.PPI_AD_1015.
NOTE: There were 44677 observations read from the data set WORK.PPI_AD_1016.
NOTE: There were 45599 observations read from the data set WORK.PPI_AD_1017.
NOTE: There were 45827 observations read from the data set WORK.PPI_AD_1018.
NOTE: There were 49942 observations read from the data set WORK.PPI_AD_1019.
NOTE: There were 58703 observations read from the data set WORK.PPI_AD_102.
NOTE: There were 44943 observations read from the data set WORK.PPI_AD_1020.
NOTE: There were 45848 observations read from the data set WORK.PPI_AD_1021.
NOTE: There were 40975 observations read from the data set WORK.PPI_AD_1022.
NOTE: There were 47643 observations read from the data set WORK.PPI_AD_1023.
NOTE: There were 40348 observations read from the data set WORK.PPI_AD_1024.
NOTE: There were 36602 observations read from the data set WORK.PPI_AD_1025.
NOTE: There were 38394 observations read from the data set WORK.PPI_AD_1026.
NOTE: There were 65815 observations read from the data set WORK.PPI_AD_1027.
NOTE: There were 68135 observations read from the data set WORK.PPI_AD_1028.
NOTE: There were 66151 observations read from the data set WORK.PPI_AD_1029.
NOTE: There were 72027 observations read from the data set WORK.PPI_AD_103.
NOTE: There were 72418 observations read from the data set WORK.PPI_AD_1030.
NOTE: There were 73580 observations read from the data set WORK.PPI_AD_1031.
NOTE: There were 80931 observations read from the data set WORK.PPI_AD_1032.
NOTE: There were 88206 observations read from the data set WORK.PPI_AD_1033.
NOTE: There were 91223 observations read from the data set WORK.PPI_AD_1034.
NOTE: There were 90002 observations read from the data set WORK.PPI_AD_1035.
NOTE: There were 96468 observations read from the data set WORK.PPI_AD_1036.
NOTE: There were 52352 observations read from the data set WORK.PPI_AD_1037.
NOTE: There were 57004 observations read from the data set WORK.PPI_AD_1038.
NOTE: There were 57250 observations read from the data set WORK.PPI_AD_1039.
NOTE: There were 64449 observations read from the data set WORK.PPI_AD_104.
NOTE: There were 82618 observations read from the data set WORK.PPI_AD_1040.
NOTE: There were 65804 observations read from the data set WORK.PPI_AD_1041.
NOTE: There were 66825 observations read from the data set WORK.PPI_AD_1042.
NOTE: There were 38612 observations read from the data set WORK.PPI_AD_1043.
NOTE: There were 40289 observations read from the data set WORK.PPI_AD_1044.
NOTE: There were 36572 observations read from the data set WORK.PPI_AD_1045.
NOTE: There were 41074 observations read from the data set WORK.PPI_AD_1046.
NOTE: There were 52023 observations read from the data set WORK.PPI_AD_1047.
NOTE: There were 64496 observations read from the data set WORK.PPI_AD_1048.
NOTE: There were 67337 observations read from the data set WORK.PPI_AD_1049.
NOTE: There were 60138 observations read from the data set WORK.PPI_AD_105.
NOTE: There were 69012 observations read from the data set WORK.PPI_AD_1050.
NOTE: There were 36033 observations read from the data set WORK.PPI_AD_1051.
NOTE: There were 37432 observations read from the data set WORK.PPI_AD_1052.
NOTE: There were 37625 observations read from the data set WORK.PPI_AD_1053.
NOTE: There were 37432 observations read from the data set WORK.PPI_AD_1054.
NOTE: There were 41288 observations read from the data set WORK.PPI_AD_1055.
NOTE: There were 39702 observations read from the data set WORK.PPI_AD_1056.
NOTE: There were 41806 observations read from the data set WORK.PPI_AD_1057.
NOTE: There were 44127 observations read from the data set WORK.PPI_AD_1058.
NOTE: There were 47857 observations read from the data set WORK.PPI_AD_1059.
NOTE: There were 60798 observations read from the data set WORK.PPI_AD_106.
NOTE: There were 45982 observations read from the data set WORK.PPI_AD_1060.
NOTE: There were 48204 observations read from the data set WORK.PPI_AD_1061.
NOTE: There were 49632 observations read from the data set WORK.PPI_AD_1062.
NOTE: There were 51755 observations read from the data set WORK.PPI_AD_1063.
NOTE: There were 50319 observations read from the data set WORK.PPI_AD_1064.
NOTE: There were 54521 observations read from the data set WORK.PPI_AD_1065.
NOTE: There were 55502 observations read from the data set WORK.PPI_AD_1066.
NOTE: There were 58595 observations read from the data set WORK.PPI_AD_1067.
NOTE: There were 59227 observations read from the data set WORK.PPI_AD_1068.
NOTE: There were 61930 observations read from the data set WORK.PPI_AD_1069.
NOTE: There were 56704 observations read from the data set WORK.PPI_AD_107.
NOTE: There were 63579 observations read from the data set WORK.PPI_AD_1070.
NOTE: There were 69346 observations read from the data set WORK.PPI_AD_1071.
NOTE: There were 67688 observations read from the data set WORK.PPI_AD_1072.
NOTE: There were 69508 observations read from the data set WORK.PPI_AD_1073.
NOTE: There were 74658 observations read from the data set WORK.PPI_AD_1074.
NOTE: There were 79969 observations read from the data set WORK.PPI_AD_1075.
NOTE: There were 83062 observations read from the data set WORK.PPI_AD_1076.
NOTE: There were 84512 observations read from the data set WORK.PPI_AD_1077.
NOTE: There were 90319 observations read from the data set WORK.PPI_AD_1078.
NOTE: There were 42200 observations read from the data set WORK.PPI_AD_1079.
NOTE: There were 64784 observations read from the data set WORK.PPI_AD_108.
NOTE: There were 40555 observations read from the data set WORK.PPI_AD_1080.
NOTE: There were 38278 observations read from the data set WORK.PPI_AD_1081.
NOTE: There were 40048 observations read from the data set WORK.PPI_AD_1082.
NOTE: There were 39615 observations read from the data set WORK.PPI_AD_1083.
NOTE: There were 40004 observations read from the data set WORK.PPI_AD_1084.
NOTE: There were 43311 observations read from the data set WORK.PPI_AD_1085.
NOTE: There were 35769 observations read from the data set WORK.PPI_AD_1086.
NOTE: There were 38069 observations read from the data set WORK.PPI_AD_1087.
NOTE: There were 36658 observations read from the data set WORK.PPI_AD_1088.
NOTE: There were 38544 observations read from the data set WORK.PPI_AD_1089.
NOTE: There were 60050 observations read from the data set WORK.PPI_AD_109.
NOTE: There were 35648 observations read from the data set WORK.PPI_AD_1090.
NOTE: There were 36834 observations read from the data set WORK.PPI_AD_1091.
NOTE: There were 35236 observations read from the data set WORK.PPI_AD_1092.
NOTE: There were 32791 observations read from the data set WORK.PPI_AD_1093.
NOTE: There were 36081 observations read from the data set WORK.PPI_AD_1094.
NOTE: There were 16320 observations read from the data set WORK.PPI_AD_1095.
NOTE: There were 19651 observations read from the data set WORK.PPI_AD_1096.
NOTE: There were 18400 observations read from the data set WORK.PPI_AD_1097.
NOTE: There were 20413 observations read from the data set WORK.PPI_AD_1098.
NOTE: There were 11597 observations read from the data set WORK.PPI_AD_1099.
NOTE: There were 71759 observations read from the data set WORK.PPI_AD_11.
NOTE: There were 62020 observations read from the data set WORK.PPI_AD_110.
NOTE: There were 38958 observations read from the data set WORK.PPI_AD_1100.
NOTE: There were 40521 observations read from the data set WORK.PPI_AD_1101.
NOTE: There were 42348 observations read from the data set WORK.PPI_AD_1102.
NOTE: There were 43738 observations read from the data set WORK.PPI_AD_1103.
NOTE: There were 47333 observations read from the data set WORK.PPI_AD_1104.
NOTE: There were 48755 observations read from the data set WORK.PPI_AD_1105.
NOTE: There were 53172 observations read from the data set WORK.PPI_AD_1106.
NOTE: There were 54853 observations read from the data set WORK.PPI_AD_1107.
NOTE: There were 55558 observations read from the data set WORK.PPI_AD_1108.
NOTE: There were 59482 observations read from the data set WORK.PPI_AD_1109.
NOTE: There were 63994 observations read from the data set WORK.PPI_AD_111.
NOTE: There were 62027 observations read from the data set WORK.PPI_AD_1110.
NOTE: There were 63031 observations read from the data set WORK.PPI_AD_1111.
NOTE: There were 68942 observations read from the data set WORK.PPI_AD_1112.
NOTE: There were 57094 observations read from the data set WORK.PPI_AD_1113.
NOTE: There were 70403 observations read from the data set WORK.PPI_AD_1114.
NOTE: There were 77423 observations read from the data set WORK.PPI_AD_1115.
NOTE: There were 84885 observations read from the data set WORK.PPI_AD_1116.
NOTE: There were 91657 observations read from the data set WORK.PPI_AD_1117.
NOTE: There were 98611 observations read from the data set WORK.PPI_AD_1118.
NOTE: There were 67826 observations read from the data set WORK.PPI_AD_1119.
NOTE: There were 66225 observations read from the data set WORK.PPI_AD_112.
NOTE: There were 75905 observations read from the data set WORK.PPI_AD_1120.
NOTE: There were 73809 observations read from the data set WORK.PPI_AD_1121.
NOTE: There were 70417 observations read from the data set WORK.PPI_AD_1122.
NOTE: There were 66950 observations read from the data set WORK.PPI_AD_1123.
NOTE: There were 72504 observations read from the data set WORK.PPI_AD_1124.
NOTE: There were 67509 observations read from the data set WORK.PPI_AD_1125.
NOTE: There were 37072 observations read from the data set WORK.PPI_AD_1126.
NOTE: There were 72069 observations read from the data set WORK.PPI_AD_1127.
NOTE: There were 78728 observations read from the data set WORK.PPI_AD_1128.
NOTE: There were 75515 observations read from the data set WORK.PPI_AD_1129.
NOTE: There were 63266 observations read from the data set WORK.PPI_AD_113.
NOTE: There were 78791 observations read from the data set WORK.PPI_AD_1130.
NOTE: There were 78555 observations read from the data set WORK.PPI_AD_1131.
NOTE: There were 82932 observations read from the data set WORK.PPI_AD_1132.
NOTE: There were 79694 observations read from the data set WORK.PPI_AD_1133.
NOTE: There were 83998 observations read from the data set WORK.PPI_AD_1134.
NOTE: There were 78791 observations read from the data set WORK.PPI_AD_1135.
NOTE: There were 83988 observations read from the data set WORK.PPI_AD_1136.
NOTE: There were 74253 observations read from the data set WORK.PPI_AD_1137.
NOTE: There were 76087 observations read from the data set WORK.PPI_AD_1138.
NOTE: There were 90063 observations read from the data set WORK.PPI_AD_1139.
NOTE: There were 66124 observations read from the data set WORK.PPI_AD_114.
NOTE: There were 85448 observations read from the data set WORK.PPI_AD_1140.
NOTE: There were 83146 observations read from the data set WORK.PPI_AD_1141.
NOTE: There were 87440 observations read from the data set WORK.PPI_AD_1142.
NOTE: There were 86499 observations read from the data set WORK.PPI_AD_1143.
NOTE: There were 90324 observations read from the data set WORK.PPI_AD_1144.
NOTE: There were 89078 observations read from the data set WORK.PPI_AD_1145.
NOTE: There were 92541 observations read from the data set WORK.PPI_AD_1146.
NOTE: There were 88308 observations read from the data set WORK.PPI_AD_1147.
NOTE: There were 90496 observations read from the data set WORK.PPI_AD_1148.
NOTE: There were 92747 observations read from the data set WORK.PPI_AD_1149.
NOTE: There were 73319 observations read from the data set WORK.PPI_AD_115.
NOTE: There were 93905 observations read from the data set WORK.PPI_AD_1150.
NOTE: There were 47085 observations read from the data set WORK.PPI_AD_1151.
NOTE: There were 51715 observations read from the data set WORK.PPI_AD_1152.
NOTE: There were 55585 observations read from the data set WORK.PPI_AD_1153.
NOTE: There were 47737 observations read from the data set WORK.PPI_AD_1154.
NOTE: There were 47827 observations read from the data set WORK.PPI_AD_1155.
NOTE: There were 48368 observations read from the data set WORK.PPI_AD_1156.
NOTE: There were 46238 observations read from the data set WORK.PPI_AD_1157.
NOTE: There were 48869 observations read from the data set WORK.PPI_AD_1158.
NOTE: There were 49352 observations read from the data set WORK.PPI_AD_1159.
NOTE: There were 64744 observations read from the data set WORK.PPI_AD_116.
NOTE: There were 47218 observations read from the data set WORK.PPI_AD_1160.
NOTE: There were 48759 observations read from the data set WORK.PPI_AD_1161.
NOTE: There were 49583 observations read from the data set WORK.PPI_AD_1162.
NOTE: There were 48485 observations read from the data set WORK.PPI_AD_1163.
NOTE: There were 42022 observations read from the data set WORK.PPI_AD_1164.
NOTE: There were 49089 observations read from the data set WORK.PPI_AD_1165.
NOTE: There were 43934 observations read from the data set WORK.PPI_AD_1166.
NOTE: There were 45587 observations read from the data set WORK.PPI_AD_1167.
NOTE: There were 46290 observations read from the data set WORK.PPI_AD_1168.
NOTE: There were 45253 observations read from the data set WORK.PPI_AD_1169.
NOTE: There were 67793 observations read from the data set WORK.PPI_AD_117.
NOTE: There were 47651 observations read from the data set WORK.PPI_AD_1170.
NOTE: There were 47110 observations read from the data set WORK.PPI_AD_1171.
NOTE: There were 44202 observations read from the data set WORK.PPI_AD_1172.
NOTE: There were 46156 observations read from the data set WORK.PPI_AD_1173.
NOTE: There were 47902 observations read from the data set WORK.PPI_AD_1174.
NOTE: There were 46700 observations read from the data set WORK.PPI_AD_1175.
NOTE: There were 49435 observations read from the data set WORK.PPI_AD_1176.
NOTE: There were 52506 observations read from the data set WORK.PPI_AD_1177.
NOTE: There were 46247 observations read from the data set WORK.PPI_AD_1178.
NOTE: There were 52734 observations read from the data set WORK.PPI_AD_1179.
NOTE: There were 62122 observations read from the data set WORK.PPI_AD_118.
NOTE: There were 49690 observations read from the data set WORK.PPI_AD_1180.
NOTE: There were 46852 observations read from the data set WORK.PPI_AD_1181.
NOTE: There were 51332 observations read from the data set WORK.PPI_AD_1182.
NOTE: There were 47630 observations read from the data set WORK.PPI_AD_1183.
NOTE: There were 48889 observations read from the data set WORK.PPI_AD_1184.
NOTE: There were 46925 observations read from the data set WORK.PPI_AD_1185.
NOTE: There were 45375 observations read from the data set WORK.PPI_AD_1186.
NOTE: There were 38465 observations read from the data set WORK.PPI_AD_1187.
NOTE: There were 43267 observations read from the data set WORK.PPI_AD_1188.
NOTE: There were 43155 observations read from the data set WORK.PPI_AD_1189.
NOTE: There were 58681 observations read from the data set WORK.PPI_AD_119.
NOTE: There were 41602 observations read from the data set WORK.PPI_AD_1190.
NOTE: There were 38815 observations read from the data set WORK.PPI_AD_1191.
NOTE: There were 23413 observations read from the data set WORK.PPI_AD_1192.
NOTE: There were 25042 observations read from the data set WORK.PPI_AD_1193.
NOTE: There were 86902 observations read from the data set WORK.PPI_AD_12.
NOTE: There were 63995 observations read from the data set WORK.PPI_AD_120.
NOTE: There were 56949 observations read from the data set WORK.PPI_AD_121.
NOTE: There were 54891 observations read from the data set WORK.PPI_AD_122.
NOTE: There were 57157 observations read from the data set WORK.PPI_AD_123.
NOTE: There were 56353 observations read from the data set WORK.PPI_AD_124.
NOTE: There were 62590 observations read from the data set WORK.PPI_AD_125.
NOTE: There were 47404 observations read from the data set WORK.PPI_AD_126.
NOTE: There were 52427 observations read from the data set WORK.PPI_AD_127.
NOTE: There were 52488 observations read from the data set WORK.PPI_AD_128.
NOTE: There were 50388 observations read from the data set WORK.PPI_AD_129.
NOTE: There were 78099 observations read from the data set WORK.PPI_AD_13.
NOTE: There were 47031 observations read from the data set WORK.PPI_AD_130.
NOTE: There were 49028 observations read from the data set WORK.PPI_AD_131.
NOTE: There were 49370 observations read from the data set WORK.PPI_AD_132.
NOTE: There were 47505 observations read from the data set WORK.PPI_AD_133.
NOTE: There were 49297 observations read from the data set WORK.PPI_AD_134.
NOTE: There were 48018 observations read from the data set WORK.PPI_AD_135.
NOTE: There were 51172 observations read from the data set WORK.PPI_AD_136.
NOTE: There were 52220 observations read from the data set WORK.PPI_AD_137.
NOTE: There were 42549 observations read from the data set WORK.PPI_AD_138.
NOTE: There were 45228 observations read from the data set WORK.PPI_AD_139.
NOTE: There were 72561 observations read from the data set WORK.PPI_AD_14.
NOTE: There were 43524 observations read from the data set WORK.PPI_AD_140.
NOTE: There were 43582 observations read from the data set WORK.PPI_AD_141.
NOTE: There were 42578 observations read from the data set WORK.PPI_AD_142.
NOTE: There were 45522 observations read from the data set WORK.PPI_AD_143.
NOTE: There were 41196 observations read from the data set WORK.PPI_AD_144.
NOTE: There were 42923 observations read from the data set WORK.PPI_AD_145.
NOTE: There were 42030 observations read from the data set WORK.PPI_AD_146.
NOTE: There were 40985 observations read from the data set WORK.PPI_AD_147.
NOTE: There were 44862 observations read from the data set WORK.PPI_AD_148.
NOTE: There were 28162 observations read from the data set WORK.PPI_AD_149.
NOTE: There were 82424 observations read from the data set WORK.PPI_AD_15.
NOTE: There were 88982 observations read from the data set WORK.PPI_AD_150.
NOTE: There were 88971 observations read from the data set WORK.PPI_AD_151.
NOTE: There were 92553 observations read from the data set WORK.PPI_AD_152.
NOTE: There were 92483 observations read from the data set WORK.PPI_AD_153.
NOTE: There were 44690 observations read from the data set WORK.PPI_AD_154.
NOTE: There were 24325 observations read from the data set WORK.PPI_AD_155.
NOTE: There were 75691 observations read from the data set WORK.PPI_AD_156.
NOTE: There were 74703 observations read from the data set WORK.PPI_AD_157.
NOTE: There were 79874 observations read from the data set WORK.PPI_AD_158.
NOTE: There were 82748 observations read from the data set WORK.PPI_AD_159.
NOTE: There were 90034 observations read from the data set WORK.PPI_AD_16.
NOTE: There were 84044 observations read from the data set WORK.PPI_AD_160.
NOTE: There were 86200 observations read from the data set WORK.PPI_AD_161.
NOTE: There were 89288 observations read from the data set WORK.PPI_AD_162.
NOTE: There were 92575 observations read from the data set WORK.PPI_AD_163.
NOTE: There were 64911 observations read from the data set WORK.PPI_AD_164.
NOTE: There were 65129 observations read from the data set WORK.PPI_AD_165.
NOTE: There were 66494 observations read from the data set WORK.PPI_AD_166.
NOTE: There were 70963 observations read from the data set WORK.PPI_AD_167.
NOTE: There were 73323 observations read from the data set WORK.PPI_AD_168.
NOTE: There were 73121 observations read from the data set WORK.PPI_AD_169.
NOTE: There were 91160 observations read from the data set WORK.PPI_AD_17.
NOTE: There were 76065 observations read from the data set WORK.PPI_AD_170.
NOTE: There were 69264 observations read from the data set WORK.PPI_AD_171.
NOTE: There were 62157 observations read from the data set WORK.PPI_AD_172.
NOTE: There were 73869 observations read from the data set WORK.PPI_AD_173.
NOTE: There were 79186 observations read from the data set WORK.PPI_AD_174.
NOTE: There were 82944 observations read from the data set WORK.PPI_AD_175.
NOTE: There were 81464 observations read from the data set WORK.PPI_AD_176.
NOTE: There were 92830 observations read from the data set WORK.PPI_AD_177.
NOTE: There were 91901 observations read from the data set WORK.PPI_AD_178.
NOTE: There were 95719 observations read from the data set WORK.PPI_AD_179.
NOTE: There were 91772 observations read from the data set WORK.PPI_AD_18.
NOTE: There were 95824 observations read from the data set WORK.PPI_AD_180.
NOTE: There were 55375 observations read from the data set WORK.PPI_AD_181.
NOTE: There were 46701 observations read from the data set WORK.PPI_AD_182.
NOTE: There were 58789 observations read from the data set WORK.PPI_AD_183.
NOTE: There were 54616 observations read from the data set WORK.PPI_AD_184.
NOTE: There were 53707 observations read from the data set WORK.PPI_AD_185.
NOTE: There were 54614 observations read from the data set WORK.PPI_AD_186.
NOTE: There were 48671 observations read from the data set WORK.PPI_AD_187.
NOTE: There were 53047 observations read from the data set WORK.PPI_AD_188.
NOTE: There were 51397 observations read from the data set WORK.PPI_AD_189.
NOTE: There were 55565 observations read from the data set WORK.PPI_AD_19.
NOTE: There were 50737 observations read from the data set WORK.PPI_AD_190.
NOTE: There were 53723 observations read from the data set WORK.PPI_AD_191.
NOTE: There were 54508 observations read from the data set WORK.PPI_AD_192.
NOTE: There were 50985 observations read from the data set WORK.PPI_AD_193.
NOTE: There were 55597 observations read from the data set WORK.PPI_AD_194.
NOTE: There were 52592 observations read from the data set WORK.PPI_AD_195.
NOTE: There were 52165 observations read from the data set WORK.PPI_AD_196.
NOTE: There were 58368 observations read from the data set WORK.PPI_AD_197.
NOTE: There were 51716 observations read from the data set WORK.PPI_AD_198.
NOTE: There were 55690 observations read from the data set WORK.PPI_AD_199.
NOTE: There were 98428 observations read from the data set WORK.PPI_AD_2.
NOTE: There were 49157 observations read from the data set WORK.PPI_AD_20.
NOTE: There were 58498 observations read from the data set WORK.PPI_AD_200.
NOTE: There were 54308 observations read from the data set WORK.PPI_AD_201.
NOTE: There were 56981 observations read from the data set WORK.PPI_AD_202.
NOTE: There were 55311 observations read from the data set WORK.PPI_AD_203.
NOTE: There were 54778 observations read from the data set WORK.PPI_AD_204.
NOTE: There were 57773 observations read from the data set WORK.PPI_AD_205.
NOTE: There were 56802 observations read from the data set WORK.PPI_AD_206.
NOTE: There were 64513 observations read from the data set WORK.PPI_AD_207.
NOTE: There were 55377 observations read from the data set WORK.PPI_AD_208.
NOTE: There were 64079 observations read from the data set WORK.PPI_AD_209.
NOTE: There were 48562 observations read from the data set WORK.PPI_AD_21.
NOTE: There were 56511 observations read from the data set WORK.PPI_AD_210.
NOTE: There were 61770 observations read from the data set WORK.PPI_AD_211.
NOTE: There were 58787 observations read from the data set WORK.PPI_AD_212.
NOTE: There were 59029 observations read from the data set WORK.PPI_AD_213.
NOTE: There were 63870 observations read from the data set WORK.PPI_AD_214.
NOTE: There were 58274 observations read from the data set WORK.PPI_AD_215.
NOTE: There were 61848 observations read from the data set WORK.PPI_AD_216.
NOTE: There were 63572 observations read from the data set WORK.PPI_AD_217.
NOTE: There were 61798 observations read from the data set WORK.PPI_AD_218.
NOTE: There were 68623 observations read from the data set WORK.PPI_AD_219.
NOTE: There were 50243 observations read from the data set WORK.PPI_AD_22.
NOTE: There were 61461 observations read from the data set WORK.PPI_AD_220.
NOTE: There were 63907 observations read from the data set WORK.PPI_AD_221.
NOTE: There were 65188 observations read from the data set WORK.PPI_AD_222.
NOTE: There were 63493 observations read from the data set WORK.PPI_AD_223.
NOTE: There were 59427 observations read from the data set WORK.PPI_AD_224.
NOTE: There were 62307 observations read from the data set WORK.PPI_AD_225.
NOTE: There were 60145 observations read from the data set WORK.PPI_AD_226.
NOTE: There were 61628 observations read from the data set WORK.PPI_AD_227.
NOTE: There were 61562 observations read from the data set WORK.PPI_AD_228.
NOTE: There were 61324 observations read from the data set WORK.PPI_AD_229.
NOTE: There were 52154 observations read from the data set WORK.PPI_AD_23.
NOTE: There were 70655 observations read from the data set WORK.PPI_AD_230.
NOTE: There were 68527 observations read from the data set WORK.PPI_AD_231.
NOTE: There were 65162 observations read from the data set WORK.PPI_AD_232.
NOTE: There were 67537 observations read from the data set WORK.PPI_AD_233.
NOTE: There were 68771 observations read from the data set WORK.PPI_AD_234.
NOTE: There were 61940 observations read from the data set WORK.PPI_AD_235.
NOTE: There were 64807 observations read from the data set WORK.PPI_AD_236.
NOTE: There were 64686 observations read from the data set WORK.PPI_AD_237.
NOTE: There were 65124 observations read from the data set WORK.PPI_AD_238.
NOTE: There were 66768 observations read from the data set WORK.PPI_AD_239.
NOTE: There were 53874 observations read from the data set WORK.PPI_AD_24.
NOTE: There were 62039 observations read from the data set WORK.PPI_AD_240.
NOTE: There were 63487 observations read from the data set WORK.PPI_AD_241.
NOTE: There were 73667 observations read from the data set WORK.PPI_AD_242.
NOTE: There were 68579 observations read from the data set WORK.PPI_AD_243.
NOTE: There were 59819 observations read from the data set WORK.PPI_AD_244.
NOTE: There were 75090 observations read from the data set WORK.PPI_AD_245.
NOTE: There were 66977 observations read from the data set WORK.PPI_AD_246.
NOTE: There were 66364 observations read from the data set WORK.PPI_AD_247.
NOTE: There were 63698 observations read from the data set WORK.PPI_AD_248.
NOTE: There were 64202 observations read from the data set WORK.PPI_AD_249.
NOTE: There were 53419 observations read from the data set WORK.PPI_AD_25.
NOTE: There were 67561 observations read from the data set WORK.PPI_AD_250.
NOTE: There were 67328 observations read from the data set WORK.PPI_AD_251.
NOTE: There were 62516 observations read from the data set WORK.PPI_AD_252.
NOTE: There were 63883 observations read from the data set WORK.PPI_AD_253.
NOTE: There were 68157 observations read from the data set WORK.PPI_AD_254.
NOTE: There were 72536 observations read from the data set WORK.PPI_AD_255.
NOTE: There were 62039 observations read from the data set WORK.PPI_AD_256.
NOTE: There were 72559 observations read from the data set WORK.PPI_AD_257.
NOTE: There were 67155 observations read from the data set WORK.PPI_AD_258.
NOTE: There were 65351 observations read from the data set WORK.PPI_AD_259.
NOTE: There were 52731 observations read from the data set WORK.PPI_AD_26.
NOTE: There were 65566 observations read from the data set WORK.PPI_AD_260.
NOTE: There were 61246 observations read from the data set WORK.PPI_AD_261.
NOTE: There were 64375 observations read from the data set WORK.PPI_AD_262.
NOTE: There were 63092 observations read from the data set WORK.PPI_AD_263.
NOTE: There were 63797 observations read from the data set WORK.PPI_AD_264.
NOTE: There were 64806 observations read from the data set WORK.PPI_AD_265.
NOTE: There were 69425 observations read from the data set WORK.PPI_AD_266.
NOTE: There were 66591 observations read from the data set WORK.PPI_AD_267.
NOTE: There were 70966 observations read from the data set WORK.PPI_AD_268.
NOTE: There were 74201 observations read from the data set WORK.PPI_AD_269.
NOTE: There were 55373 observations read from the data set WORK.PPI_AD_27.
NOTE: There were 68457 observations read from the data set WORK.PPI_AD_270.
NOTE: There were 69167 observations read from the data set WORK.PPI_AD_271.
NOTE: There were 67790 observations read from the data set WORK.PPI_AD_272.
NOTE: There were 65082 observations read from the data set WORK.PPI_AD_273.
NOTE: There were 65331 observations read from the data set WORK.PPI_AD_274.
NOTE: There were 59837 observations read from the data set WORK.PPI_AD_275.
NOTE: There were 59014 observations read from the data set WORK.PPI_AD_276.
NOTE: There were 61145 observations read from the data set WORK.PPI_AD_277.
NOTE: There were 58003 observations read from the data set WORK.PPI_AD_278.
NOTE: There were 62187 observations read from the data set WORK.PPI_AD_279.
NOTE: There were 59230 observations read from the data set WORK.PPI_AD_28.
NOTE: There were 51899 observations read from the data set WORK.PPI_AD_280.
NOTE: There were 58134 observations read from the data set WORK.PPI_AD_281.
NOTE: There were 57021 observations read from the data set WORK.PPI_AD_282.
NOTE: There were 55778 observations read from the data set WORK.PPI_AD_283.
NOTE: There were 51143 observations read from the data set WORK.PPI_AD_284.
NOTE: There were 53635 observations read from the data set WORK.PPI_AD_285.
NOTE: There were 52973 observations read from the data set WORK.PPI_AD_286.
NOTE: There were 48167 observations read from the data set WORK.PPI_AD_287.
NOTE: There were 50783 observations read from the data set WORK.PPI_AD_288.
NOTE: There were 47838 observations read from the data set WORK.PPI_AD_289.
NOTE: There were 60421 observations read from the data set WORK.PPI_AD_29.
NOTE: There were 48408 observations read from the data set WORK.PPI_AD_290.
NOTE: There were 51234 observations read from the data set WORK.PPI_AD_291.
NOTE: There were 45142 observations read from the data set WORK.PPI_AD_292.
NOTE: There were 46295 observations read from the data set WORK.PPI_AD_293.
NOTE: There were 44157 observations read from the data set WORK.PPI_AD_294.
NOTE: There were 46534 observations read from the data set WORK.PPI_AD_295.
NOTE: There were 42741 observations read from the data set WORK.PPI_AD_296.
NOTE: There were 46693 observations read from the data set WORK.PPI_AD_297.
NOTE: There were 41982 observations read from the data set WORK.PPI_AD_298.
NOTE: There were 41436 observations read from the data set WORK.PPI_AD_299.
NOTE: There were 74673 observations read from the data set WORK.PPI_AD_3.
NOTE: There were 52084 observations read from the data set WORK.PPI_AD_30.
NOTE: There were 41983 observations read from the data set WORK.PPI_AD_300.
NOTE: There were 41948 observations read from the data set WORK.PPI_AD_301.
NOTE: There were 81545 observations read from the data set WORK.PPI_AD_302.
NOTE: There were 83624 observations read from the data set WORK.PPI_AD_303.
NOTE: There were 86509 observations read from the data set WORK.PPI_AD_304.
NOTE: There were 92816 observations read from the data set WORK.PPI_AD_305.
NOTE: There were 18941 observations read from the data set WORK.PPI_AD_306.
NOTE: There were 58270 observations read from the data set WORK.PPI_AD_307.
NOTE: There were 58590 observations read from the data set WORK.PPI_AD_308.
NOTE: There were 63478 observations read from the data set WORK.PPI_AD_309.
NOTE: There were 64607 observations read from the data set WORK.PPI_AD_31.
NOTE: There were 68558 observations read from the data set WORK.PPI_AD_310.
NOTE: There were 31976 observations read from the data set WORK.PPI_AD_311.
NOTE: There were 32640 observations read from the data set WORK.PPI_AD_312.
NOTE: There were 34440 observations read from the data set WORK.PPI_AD_313.
NOTE: There were 37029 observations read from the data set WORK.PPI_AD_314.
NOTE: There were 31628 observations read from the data set WORK.PPI_AD_315.
NOTE: There were 35405 observations read from the data set WORK.PPI_AD_316.
NOTE: There were 26245 observations read from the data set WORK.PPI_AD_317.
NOTE: There were 28282 observations read from the data set WORK.PPI_AD_318.
NOTE: There were 30806 observations read from the data set WORK.PPI_AD_319.
NOTE: There were 61305 observations read from the data set WORK.PPI_AD_32.
NOTE: There were 35191 observations read from the data set WORK.PPI_AD_320.
NOTE: There were 36274 observations read from the data set WORK.PPI_AD_321.
NOTE: There were 35512 observations read from the data set WORK.PPI_AD_322.
NOTE: There were 38257 observations read from the data set WORK.PPI_AD_323.
NOTE: There were 36592 observations read from the data set WORK.PPI_AD_324.
NOTE: There were 43209 observations read from the data set WORK.PPI_AD_325.
NOTE: There were 41050 observations read from the data set WORK.PPI_AD_326.
NOTE: There were 42439 observations read from the data set WORK.PPI_AD_327.
NOTE: There were 47146 observations read from the data set WORK.PPI_AD_328.
NOTE: There were 45306 observations read from the data set WORK.PPI_AD_329.
NOTE: There were 58173 observations read from the data set WORK.PPI_AD_33.
NOTE: There were 45248 observations read from the data set WORK.PPI_AD_330.
NOTE: There were 47854 observations read from the data set WORK.PPI_AD_331.
NOTE: There were 48397 observations read from the data set WORK.PPI_AD_332.
NOTE: There were 47894 observations read from the data set WORK.PPI_AD_333.
NOTE: There were 47528 observations read from the data set WORK.PPI_AD_334.
NOTE: There were 47249 observations read from the data set WORK.PPI_AD_335.
NOTE: There were 49032 observations read from the data set WORK.PPI_AD_336.
NOTE: There were 49658 observations read from the data set WORK.PPI_AD_337.
NOTE: There were 51630 observations read from the data set WORK.PPI_AD_338.
NOTE: There were 43736 observations read from the data set WORK.PPI_AD_339.
NOTE: There were 58954 observations read from the data set WORK.PPI_AD_34.
NOTE: There were 55045 observations read from the data set WORK.PPI_AD_340.
NOTE: There were 51312 observations read from the data set WORK.PPI_AD_341.
NOTE: There were 50304 observations read from the data set WORK.PPI_AD_342.
NOTE: There were 52806 observations read from the data set WORK.PPI_AD_343.
NOTE: There were 50173 observations read from the data set WORK.PPI_AD_344.
NOTE: There were 50137 observations read from the data set WORK.PPI_AD_345.
NOTE: There were 49975 observations read from the data set WORK.PPI_AD_346.
NOTE: There were 48575 observations read from the data set WORK.PPI_AD_347.
NOTE: There were 49824 observations read from the data set WORK.PPI_AD_348.
NOTE: There were 49596 observations read from the data set WORK.PPI_AD_349.
NOTE: There were 55745 observations read from the data set WORK.PPI_AD_35.
NOTE: There were 51747 observations read from the data set WORK.PPI_AD_350.
NOTE: There were 49590 observations read from the data set WORK.PPI_AD_351.
NOTE: There were 58190 observations read from the data set WORK.PPI_AD_352.
NOTE: There were 49074 observations read from the data set WORK.PPI_AD_353.
NOTE: There were 53158 observations read from the data set WORK.PPI_AD_354.
NOTE: There were 54861 observations read from the data set WORK.PPI_AD_355.
NOTE: There were 52147 observations read from the data set WORK.PPI_AD_356.
NOTE: There were 54881 observations read from the data set WORK.PPI_AD_357.
NOTE: There were 55489 observations read from the data set WORK.PPI_AD_358.
NOTE: There were 53776 observations read from the data set WORK.PPI_AD_359.
NOTE: There were 57981 observations read from the data set WORK.PPI_AD_36.
NOTE: There were 54726 observations read from the data set WORK.PPI_AD_360.
NOTE: There were 54534 observations read from the data set WORK.PPI_AD_361.
NOTE: There were 61059 observations read from the data set WORK.PPI_AD_362.
NOTE: There were 51459 observations read from the data set WORK.PPI_AD_363.
NOTE: There were 60269 observations read from the data set WORK.PPI_AD_364.
NOTE: There were 55040 observations read from the data set WORK.PPI_AD_365.
NOTE: There were 58974 observations read from the data set WORK.PPI_AD_366.
NOTE: There were 54259 observations read from the data set WORK.PPI_AD_367.
NOTE: There were 58246 observations read from the data set WORK.PPI_AD_368.
NOTE: There were 58334 observations read from the data set WORK.PPI_AD_369.
NOTE: There were 54862 observations read from the data set WORK.PPI_AD_37.
NOTE: There were 51786 observations read from the data set WORK.PPI_AD_370.
NOTE: There were 55979 observations read from the data set WORK.PPI_AD_371.
NOTE: There were 58124 observations read from the data set WORK.PPI_AD_372.
NOTE: There were 56264 observations read from the data set WORK.PPI_AD_373.
NOTE: There were 64513 observations read from the data set WORK.PPI_AD_374.
NOTE: There were 57975 observations read from the data set WORK.PPI_AD_375.
NOTE: There were 60323 observations read from the data set WORK.PPI_AD_376.
NOTE: There were 60552 observations read from the data set WORK.PPI_AD_377.
NOTE: There were 56990 observations read from the data set WORK.PPI_AD_378.
NOTE: There were 56634 observations read from the data set WORK.PPI_AD_379.
NOTE: There were 51530 observations read from the data set WORK.PPI_AD_38.
NOTE: There were 61410 observations read from the data set WORK.PPI_AD_380.
NOTE: There were 60266 observations read from the data set WORK.PPI_AD_381.
NOTE: There were 57858 observations read from the data set WORK.PPI_AD_382.
NOTE: There were 58920 observations read from the data set WORK.PPI_AD_383.
NOTE: There were 56699 observations read from the data set WORK.PPI_AD_384.
NOTE: There were 64447 observations read from the data set WORK.PPI_AD_385.
NOTE: There were 61411 observations read from the data set WORK.PPI_AD_386.
NOTE: There were 62842 observations read from the data set WORK.PPI_AD_387.
NOTE: There were 68468 observations read from the data set WORK.PPI_AD_388.
NOTE: There were 62517 observations read from the data set WORK.PPI_AD_389.
NOTE: There were 55660 observations read from the data set WORK.PPI_AD_39.
NOTE: There were 57664 observations read from the data set WORK.PPI_AD_390.
NOTE: There were 62540 observations read from the data set WORK.PPI_AD_391.
NOTE: There were 63642 observations read from the data set WORK.PPI_AD_392.
NOTE: There were 58897 observations read from the data set WORK.PPI_AD_393.
NOTE: There were 58393 observations read from the data set WORK.PPI_AD_394.
NOTE: There were 60325 observations read from the data set WORK.PPI_AD_395.
NOTE: There were 62694 observations read from the data set WORK.PPI_AD_396.
NOTE: There were 66114 observations read from the data set WORK.PPI_AD_397.
NOTE: There were 66161 observations read from the data set WORK.PPI_AD_398.
NOTE: There were 57543 observations read from the data set WORK.PPI_AD_399.
NOTE: There were 76490 observations read from the data set WORK.PPI_AD_4.
NOTE: There were 57319 observations read from the data set WORK.PPI_AD_40.
NOTE: There were 70076 observations read from the data set WORK.PPI_AD_400.
NOTE: There were 60415 observations read from the data set WORK.PPI_AD_401.
NOTE: There were 62054 observations read from the data set WORK.PPI_AD_402.
NOTE: There were 60167 observations read from the data set WORK.PPI_AD_403.
NOTE: There were 59102 observations read from the data set WORK.PPI_AD_404.
NOTE: There were 62314 observations read from the data set WORK.PPI_AD_405.
NOTE: There were 63003 observations read from the data set WORK.PPI_AD_406.
NOTE: There were 58272 observations read from the data set WORK.PPI_AD_407.
NOTE: There were 63152 observations read from the data set WORK.PPI_AD_408.
NOTE: There were 65480 observations read from the data set WORK.PPI_AD_409.
NOTE: There were 55432 observations read from the data set WORK.PPI_AD_41.
NOTE: There were 65853 observations read from the data set WORK.PPI_AD_410.
NOTE: There were 58056 observations read from the data set WORK.PPI_AD_411.
NOTE: There were 67289 observations read from the data set WORK.PPI_AD_412.
NOTE: There were 59566 observations read from the data set WORK.PPI_AD_413.
NOTE: There were 61107 observations read from the data set WORK.PPI_AD_414.
NOTE: There were 62345 observations read from the data set WORK.PPI_AD_415.
NOTE: There were 60752 observations read from the data set WORK.PPI_AD_416.
NOTE: There were 63094 observations read from the data set WORK.PPI_AD_417.
NOTE: There were 60146 observations read from the data set WORK.PPI_AD_418.
NOTE: There were 59485 observations read from the data set WORK.PPI_AD_419.
NOTE: There were 52837 observations read from the data set WORK.PPI_AD_42.
NOTE: There were 63326 observations read from the data set WORK.PPI_AD_420.
NOTE: There were 65306 observations read from the data set WORK.PPI_AD_421.
NOTE: There were 64893 observations read from the data set WORK.PPI_AD_422.
NOTE: There were 67155 observations read from the data set WORK.PPI_AD_423.
NOTE: There were 71980 observations read from the data set WORK.PPI_AD_424.
NOTE: There were 59852 observations read from the data set WORK.PPI_AD_425.
NOTE: There were 67881 observations read from the data set WORK.PPI_AD_426.
NOTE: There were 61897 observations read from the data set WORK.PPI_AD_427.
NOTE: There were 59490 observations read from the data set WORK.PPI_AD_428.
NOTE: There were 65213 observations read from the data set WORK.PPI_AD_429.
NOTE: There were 62176 observations read from the data set WORK.PPI_AD_43.
NOTE: There were 59197 observations read from the data set WORK.PPI_AD_430.
NOTE: There were 58754 observations read from the data set WORK.PPI_AD_431.
NOTE: There were 57665 observations read from the data set WORK.PPI_AD_432.
NOTE: There were 52850 observations read from the data set WORK.PPI_AD_433.
NOTE: There were 49919 observations read from the data set WORK.PPI_AD_434.
NOTE: There were 54575 observations read from the data set WORK.PPI_AD_435.
NOTE: There were 58505 observations read from the data set WORK.PPI_AD_436.
NOTE: There were 50499 observations read from the data set WORK.PPI_AD_437.
NOTE: There were 50177 observations read from the data set WORK.PPI_AD_438.
NOTE: There were 45828 observations read from the data set WORK.PPI_AD_439.
NOTE: There were 52215 observations read from the data set WORK.PPI_AD_44.
NOTE: There were 49264 observations read from the data set WORK.PPI_AD_440.
NOTE: There were 50577 observations read from the data set WORK.PPI_AD_441.
NOTE: There were 22799 observations read from the data set WORK.PPI_AD_442.
NOTE: There were 24532 observations read from the data set WORK.PPI_AD_443.
NOTE: There were 21897 observations read from the data set WORK.PPI_AD_444.
NOTE: There were 28010 observations read from the data set WORK.PPI_AD_445.
NOTE: There were 24030 observations read from the data set WORK.PPI_AD_446.
NOTE: There were 22752 observations read from the data set WORK.PPI_AD_447.
NOTE: There were 23268 observations read from the data set WORK.PPI_AD_448.
NOTE: There were 25900 observations read from the data set WORK.PPI_AD_449.
NOTE: There were 55759 observations read from the data set WORK.PPI_AD_45.
NOTE: There were 25905 observations read from the data set WORK.PPI_AD_450.
NOTE: There were 26698 observations read from the data set WORK.PPI_AD_451.
NOTE: There were 24508 observations read from the data set WORK.PPI_AD_452.
NOTE: There were 24365 observations read from the data set WORK.PPI_AD_453.
NOTE: There were 47152 observations read from the data set WORK.PPI_AD_454.
NOTE: There were 45629 observations read from the data set WORK.PPI_AD_455.
NOTE: There were 41814 observations read from the data set WORK.PPI_AD_456.
NOTE: There were 21929 observations read from the data set WORK.PPI_AD_457.
NOTE: There were 20267 observations read from the data set WORK.PPI_AD_458.
NOTE: There were 22112 observations read from the data set WORK.PPI_AD_459.
NOTE: There were 58132 observations read from the data set WORK.PPI_AD_46.
NOTE: There were 39806 observations read from the data set WORK.PPI_AD_460.
NOTE: There were 40822 observations read from the data set WORK.PPI_AD_461.
NOTE: There were 39790 observations read from the data set WORK.PPI_AD_462.
NOTE: There were 39173 observations read from the data set WORK.PPI_AD_463.
NOTE: There were 43082 observations read from the data set WORK.PPI_AD_464.
NOTE: There were 22397 observations read from the data set WORK.PPI_AD_465.
NOTE: There were 70703 observations read from the data set WORK.PPI_AD_466.
NOTE: There were 72425 observations read from the data set WORK.PPI_AD_467.
NOTE: There were 77992 observations read from the data set WORK.PPI_AD_468.
NOTE: There were 0 observations read from the data set WORK.PPI_AD_469.
NOTE: There were 56945 observations read from the data set WORK.PPI_AD_47.
NOTE: There were 41192 observations read from the data set WORK.PPI_AD_470.
NOTE: There were 40868 observations read from the data set WORK.PPI_AD_471.
NOTE: There were 49159 observations read from the data set WORK.PPI_AD_472.
NOTE: There were 44169 observations read from the data set WORK.PPI_AD_473.
NOTE: There were 24410 observations read from the data set WORK.PPI_AD_474.
NOTE: There were 22315 observations read from the data set WORK.PPI_AD_475.
NOTE: There were 31977 observations read from the data set WORK.PPI_AD_476.
NOTE: There were 12769 observations read from the data set WORK.PPI_AD_477.
NOTE: There were 44422 observations read from the data set WORK.PPI_AD_478.
NOTE: There were 46939 observations read from the data set WORK.PPI_AD_479.
NOTE: There were 59624 observations read from the data set WORK.PPI_AD_48.
NOTE: There were 47888 observations read from the data set WORK.PPI_AD_480.
NOTE: There were 45087 observations read from the data set WORK.PPI_AD_481.
NOTE: There were 48106 observations read from the data set WORK.PPI_AD_482.
NOTE: There were 49724 observations read from the data set WORK.PPI_AD_483.
NOTE: There were 53318 observations read from the data set WORK.PPI_AD_484.
NOTE: There were 54576 observations read from the data set WORK.PPI_AD_485.
NOTE: There were 37729 observations read from the data set WORK.PPI_AD_486.
NOTE: There were 39836 observations read from the data set WORK.PPI_AD_487.
NOTE: There were 39939 observations read from the data set WORK.PPI_AD_488.
NOTE: There were 42669 observations read from the data set WORK.PPI_AD_489.
NOTE: There were 57011 observations read from the data set WORK.PPI_AD_49.
NOTE: There were 41896 observations read from the data set WORK.PPI_AD_490.
NOTE: There were 44629 observations read from the data set WORK.PPI_AD_491.
NOTE: There were 47500 observations read from the data set WORK.PPI_AD_492.
NOTE: There were 42830 observations read from the data set WORK.PPI_AD_493.
NOTE: There were 40374 observations read from the data set WORK.PPI_AD_494.
NOTE: There were 45850 observations read from the data set WORK.PPI_AD_495.
NOTE: There were 52084 observations read from the data set WORK.PPI_AD_496.
NOTE: There were 55753 observations read from the data set WORK.PPI_AD_497.
NOTE: There were 59189 observations read from the data set WORK.PPI_AD_498.
NOTE: There were 65985 observations read from the data set WORK.PPI_AD_499.
NOTE: There were 77717 observations read from the data set WORK.PPI_AD_5.
NOTE: There were 53045 observations read from the data set WORK.PPI_AD_50.
NOTE: There were 66933 observations read from the data set WORK.PPI_AD_500.
NOTE: There were 70098 observations read from the data set WORK.PPI_AD_501.
NOTE: There were 71200 observations read from the data set WORK.PPI_AD_502.
NOTE: There were 76881 observations read from the data set WORK.PPI_AD_503.
NOTE: There were 72417 observations read from the data set WORK.PPI_AD_504.
NOTE: There were 83404 observations read from the data set WORK.PPI_AD_505.
NOTE: There were 80966 observations read from the data set WORK.PPI_AD_506.
NOTE: There were 77860 observations read from the data set WORK.PPI_AD_507.
NOTE: There were 76094 observations read from the data set WORK.PPI_AD_508.
NOTE: There were 80972 observations read from the data set WORK.PPI_AD_509.
NOTE: There were 55881 observations read from the data set WORK.PPI_AD_51.
NOTE: There were 74689 observations read from the data set WORK.PPI_AD_510.
NOTE: There were 84083 observations read from the data set WORK.PPI_AD_511.
NOTE: There were 85530 observations read from the data set WORK.PPI_AD_512.
NOTE: There were 85568 observations read from the data set WORK.PPI_AD_513.
NOTE: There were 84430 observations read from the data set WORK.PPI_AD_514.
NOTE: There were 87158 observations read from the data set WORK.PPI_AD_515.
NOTE: There were 46470 observations read from the data set WORK.PPI_AD_516.
NOTE: There were 41341 observations read from the data set WORK.PPI_AD_517.
NOTE: There were 48471 observations read from the data set WORK.PPI_AD_518.
NOTE: There were 43903 observations read from the data set WORK.PPI_AD_519.
NOTE: There were 56389 observations read from the data set WORK.PPI_AD_52.
NOTE: There were 47016 observations read from the data set WORK.PPI_AD_520.
NOTE: There were 44664 observations read from the data set WORK.PPI_AD_521.
NOTE: There were 46943 observations read from the data set WORK.PPI_AD_522.
NOTE: There were 49129 observations read from the data set WORK.PPI_AD_523.
NOTE: There were 43399 observations read from the data set WORK.PPI_AD_524.
NOTE: There were 46388 observations read from the data set WORK.PPI_AD_525.
NOTE: There were 48753 observations read from the data set WORK.PPI_AD_526.
NOTE: There were 49515 observations read from the data set WORK.PPI_AD_527.
NOTE: There were 55305 observations read from the data set WORK.PPI_AD_528.
NOTE: There were 51539 observations read from the data set WORK.PPI_AD_529.
NOTE: There were 63836 observations read from the data set WORK.PPI_AD_53.
NOTE: There were 51977 observations read from the data set WORK.PPI_AD_530.
NOTE: There were 54367 observations read from the data set WORK.PPI_AD_531.
NOTE: There were 53169 observations read from the data set WORK.PPI_AD_532.
NOTE: There were 50078 observations read from the data set WORK.PPI_AD_533.
NOTE: There were 51956 observations read from the data set WORK.PPI_AD_534.
NOTE: There were 50475 observations read from the data set WORK.PPI_AD_535.
NOTE: There were 51489 observations read from the data set WORK.PPI_AD_536.
NOTE: There were 51312 observations read from the data set WORK.PPI_AD_537.
NOTE: There were 51825 observations read from the data set WORK.PPI_AD_538.
NOTE: There were 58110 observations read from the data set WORK.PPI_AD_539.
NOTE: There were 54676 observations read from the data set WORK.PPI_AD_54.
NOTE: There were 57469 observations read from the data set WORK.PPI_AD_540.
NOTE: There were 54822 observations read from the data set WORK.PPI_AD_541.
NOTE: There were 59660 observations read from the data set WORK.PPI_AD_542.
NOTE: There were 55919 observations read from the data set WORK.PPI_AD_543.
NOTE: There were 50938 observations read from the data set WORK.PPI_AD_544.
NOTE: There were 55745 observations read from the data set WORK.PPI_AD_545.
NOTE: There were 54434 observations read from the data set WORK.PPI_AD_546.
NOTE: There were 53138 observations read from the data set WORK.PPI_AD_547.
NOTE: There were 26203 observations read from the data set WORK.PPI_AD_548.
NOTE: There were 28312 observations read from the data set WORK.PPI_AD_549.
NOTE: There were 64357 observations read from the data set WORK.PPI_AD_55.
NOTE: There were 27441 observations read from the data set WORK.PPI_AD_550.
NOTE: There were 28041 observations read from the data set WORK.PPI_AD_551.
NOTE: There were 26982 observations read from the data set WORK.PPI_AD_552.
NOTE: There were 29094 observations read from the data set WORK.PPI_AD_553.
NOTE: There were 29490 observations read from the data set WORK.PPI_AD_554.
NOTE: There were 32522 observations read from the data set WORK.PPI_AD_555.
NOTE: There were 61783 observations read from the data set WORK.PPI_AD_556.
NOTE: There were 30193 observations read from the data set WORK.PPI_AD_557.
NOTE: There were 25196 observations read from the data set WORK.PPI_AD_558.
NOTE: There were 33647 observations read from the data set WORK.PPI_AD_559.
NOTE: There were 56470 observations read from the data set WORK.PPI_AD_56.
NOTE: There were 34162 observations read from the data set WORK.PPI_AD_560.
NOTE: There were 26771 observations read from the data set WORK.PPI_AD_561.
NOTE: There were 32665 observations read from the data set WORK.PPI_AD_562.
NOTE: There were 30565 observations read from the data set WORK.PPI_AD_563.
NOTE: There were 30284 observations read from the data set WORK.PPI_AD_564.
NOTE: There were 29424 observations read from the data set WORK.PPI_AD_565.
NOTE: There were 27948 observations read from the data set WORK.PPI_AD_566.
NOTE: There were 57944 observations read from the data set WORK.PPI_AD_567.
NOTE: There were 61396 observations read from the data set WORK.PPI_AD_568.
NOTE: There were 59392 observations read from the data set WORK.PPI_AD_569.
NOTE: There were 64551 observations read from the data set WORK.PPI_AD_57.
NOTE: There were 56270 observations read from the data set WORK.PPI_AD_570.
NOTE: There were 60786 observations read from the data set WORK.PPI_AD_571.
NOTE: There were 64174 observations read from the data set WORK.PPI_AD_572.
NOTE: There were 65811 observations read from the data set WORK.PPI_AD_573.
NOTE: There were 56971 observations read from the data set WORK.PPI_AD_574.
NOTE: There were 65369 observations read from the data set WORK.PPI_AD_575.
NOTE: There were 58952 observations read from the data set WORK.PPI_AD_576.
NOTE: There were 57666 observations read from the data set WORK.PPI_AD_577.
NOTE: There were 58379 observations read from the data set WORK.PPI_AD_578.
NOTE: There were 57243 observations read from the data set WORK.PPI_AD_579.
NOTE: There were 58303 observations read from the data set WORK.PPI_AD_58.
NOTE: There were 60505 observations read from the data set WORK.PPI_AD_580.
NOTE: There were 58494 observations read from the data set WORK.PPI_AD_581.
NOTE: There were 61095 observations read from the data set WORK.PPI_AD_582.
NOTE: There were 63535 observations read from the data set WORK.PPI_AD_583.
NOTE: There were 65787 observations read from the data set WORK.PPI_AD_584.
NOTE: There were 64406 observations read from the data set WORK.PPI_AD_585.
NOTE: There were 35683 observations read from the data set WORK.PPI_AD_586.
NOTE: There were 35112 observations read from the data set WORK.PPI_AD_587.
NOTE: There were 38640 observations read from the data set WORK.PPI_AD_588.
NOTE: There were 31097 observations read from the data set WORK.PPI_AD_589.
NOTE: There were 60958 observations read from the data set WORK.PPI_AD_59.
NOTE: There were 32191 observations read from the data set WORK.PPI_AD_590.
NOTE: There were 37189 observations read from the data set WORK.PPI_AD_591.
NOTE: There were 64193 observations read from the data set WORK.PPI_AD_592.
NOTE: There were 62749 observations read from the data set WORK.PPI_AD_593.
NOTE: There were 34804 observations read from the data set WORK.PPI_AD_594.
NOTE: There were 33136 observations read from the data set WORK.PPI_AD_595.
NOTE: There were 34343 observations read from the data set WORK.PPI_AD_596.
NOTE: There were 30098 observations read from the data set WORK.PPI_AD_597.
NOTE: There were 29208 observations read from the data set WORK.PPI_AD_598.
NOTE: There were 27417 observations read from the data set WORK.PPI_AD_599.
NOTE: There were 82455 observations read from the data set WORK.PPI_AD_6.
NOTE: There were 54851 observations read from the data set WORK.PPI_AD_60.
NOTE: There were 29296 observations read from the data set WORK.PPI_AD_600.
NOTE: There were 28826 observations read from the data set WORK.PPI_AD_601.
NOTE: There were 29003 observations read from the data set WORK.PPI_AD_602.
NOTE: There were 27934 observations read from the data set WORK.PPI_AD_603.
NOTE: There were 28128 observations read from the data set WORK.PPI_AD_604.
NOTE: There were 31884 observations read from the data set WORK.PPI_AD_605.
NOTE: There were 28899 observations read from the data set WORK.PPI_AD_606.
NOTE: There were 24897 observations read from the data set WORK.PPI_AD_607.
NOTE: There were 24039 observations read from the data set WORK.PPI_AD_608.
NOTE: There were 53046 observations read from the data set WORK.PPI_AD_609.
NOTE: There were 58457 observations read from the data set WORK.PPI_AD_61.
NOTE: There were 53135 observations read from the data set WORK.PPI_AD_610.
NOTE: There were 51910 observations read from the data set WORK.PPI_AD_611.
NOTE: There were 23047 observations read from the data set WORK.PPI_AD_612.
NOTE: There were 24781 observations read from the data set WORK.PPI_AD_613.
NOTE: There were 23594 observations read from the data set WORK.PPI_AD_614.
NOTE: There were 26713 observations read from the data set WORK.PPI_AD_615.
NOTE: There were 49769 observations read from the data set WORK.PPI_AD_616.
NOTE: There were 46928 observations read from the data set WORK.PPI_AD_617.
NOTE: There were 47872 observations read from the data set WORK.PPI_AD_618.
NOTE: There were 46269 observations read from the data set WORK.PPI_AD_619.
NOTE: There were 60128 observations read from the data set WORK.PPI_AD_62.
NOTE: There were 49640 observations read from the data set WORK.PPI_AD_620.
NOTE: There were 24617 observations read from the data set WORK.PPI_AD_621.
NOTE: There were 25891 observations read from the data set WORK.PPI_AD_622.
NOTE: There were 45433 observations read from the data set WORK.PPI_AD_623.
NOTE: There were 42171 observations read from the data set WORK.PPI_AD_624.
NOTE: There were 38507 observations read from the data set WORK.PPI_AD_625.
NOTE: There were 40377 observations read from the data set WORK.PPI_AD_626.
NOTE: There were 38243 observations read from the data set WORK.PPI_AD_627.
NOTE: There were 40837 observations read from the data set WORK.PPI_AD_628.
NOTE: There were 46829 observations read from the data set WORK.PPI_AD_629.
NOTE: There were 60580 observations read from the data set WORK.PPI_AD_63.
NOTE: There were 68448 observations read from the data set WORK.PPI_AD_630.
NOTE: There were 85558 observations read from the data set WORK.PPI_AD_631.
NOTE: There were 46646 observations read from the data set WORK.PPI_AD_632.
NOTE: There were 53399 observations read from the data set WORK.PPI_AD_633.
NOTE: There were 58118 observations read from the data set WORK.PPI_AD_634.
NOTE: There were 43905 observations read from the data set WORK.PPI_AD_635.
NOTE: There were 58044 observations read from the data set WORK.PPI_AD_636.
NOTE: There were 69325 observations read from the data set WORK.PPI_AD_637.
NOTE: There were 80378 observations read from the data set WORK.PPI_AD_638.
NOTE: There were 91682 observations read from the data set WORK.PPI_AD_639.
NOTE: There were 66601 observations read from the data set WORK.PPI_AD_64.
NOTE: There were 64888 observations read from the data set WORK.PPI_AD_640.
NOTE: There were 70055 observations read from the data set WORK.PPI_AD_641.
NOTE: There were 77881 observations read from the data set WORK.PPI_AD_642.
NOTE: There were 73001 observations read from the data set WORK.PPI_AD_643.
NOTE: There were 84935 observations read from the data set WORK.PPI_AD_644.
NOTE: There were 82629 observations read from the data set WORK.PPI_AD_645.
NOTE: There were 79140 observations read from the data set WORK.PPI_AD_646.
NOTE: There were 77041 observations read from the data set WORK.PPI_AD_647.
NOTE: There were 84686 observations read from the data set WORK.PPI_AD_648.
NOTE: There were 43835 observations read from the data set WORK.PPI_AD_649.
NOTE: There were 65612 observations read from the data set WORK.PPI_AD_65.
NOTE: There were 43059 observations read from the data set WORK.PPI_AD_650.
NOTE: There were 50909 observations read from the data set WORK.PPI_AD_651.
NOTE: There were 42838 observations read from the data set WORK.PPI_AD_652.
NOTE: There were 46207 observations read from the data set WORK.PPI_AD_653.
NOTE: There were 46331 observations read from the data set WORK.PPI_AD_654.
NOTE: There were 45399 observations read from the data set WORK.PPI_AD_655.
NOTE: There were 47836 observations read from the data set WORK.PPI_AD_656.
NOTE: There were 46506 observations read from the data set WORK.PPI_AD_657.
NOTE: There were 46806 observations read from the data set WORK.PPI_AD_658.
NOTE: There were 48132 observations read from the data set WORK.PPI_AD_659.
NOTE: There were 60760 observations read from the data set WORK.PPI_AD_66.
NOTE: There were 46300 observations read from the data set WORK.PPI_AD_660.
NOTE: There were 54428 observations read from the data set WORK.PPI_AD_661.
NOTE: There were 45294 observations read from the data set WORK.PPI_AD_662.
NOTE: There were 53863 observations read from the data set WORK.PPI_AD_663.
NOTE: There were 47755 observations read from the data set WORK.PPI_AD_664.
NOTE: There were 51850 observations read from the data set WORK.PPI_AD_665.
NOTE: There were 51102 observations read from the data set WORK.PPI_AD_666.
NOTE: There were 53494 observations read from the data set WORK.PPI_AD_667.
NOTE: There were 48685 observations read from the data set WORK.PPI_AD_668.
NOTE: There were 54249 observations read from the data set WORK.PPI_AD_669.
NOTE: There were 66855 observations read from the data set WORK.PPI_AD_67.
NOTE: There were 56790 observations read from the data set WORK.PPI_AD_670.
NOTE: There were 57526 observations read from the data set WORK.PPI_AD_671.
NOTE: There were 63489 observations read from the data set WORK.PPI_AD_672.
NOTE: There were 61917 observations read from the data set WORK.PPI_AD_673.
NOTE: There were 60019 observations read from the data set WORK.PPI_AD_674.
NOTE: There were 62249 observations read from the data set WORK.PPI_AD_675.
NOTE: There were 61625 observations read from the data set WORK.PPI_AD_676.
NOTE: There were 58601 observations read from the data set WORK.PPI_AD_677.
NOTE: There were 53775 observations read from the data set WORK.PPI_AD_678.
NOTE: There were 62104 observations read from the data set WORK.PPI_AD_679.
NOTE: There were 62955 observations read from the data set WORK.PPI_AD_68.
NOTE: There were 59719 observations read from the data set WORK.PPI_AD_680.
NOTE: There were 59905 observations read from the data set WORK.PPI_AD_681.
NOTE: There were 60953 observations read from the data set WORK.PPI_AD_682.
NOTE: There were 60607 observations read from the data set WORK.PPI_AD_683.
NOTE: There were 70483 observations read from the data set WORK.PPI_AD_684.
NOTE: There were 66651 observations read from the data set WORK.PPI_AD_685.
NOTE: There were 64445 observations read from the data set WORK.PPI_AD_686.
NOTE: There were 70472 observations read from the data set WORK.PPI_AD_687.
NOTE: There were 67207 observations read from the data set WORK.PPI_AD_688.
NOTE: There were 62380 observations read from the data set WORK.PPI_AD_689.
NOTE: There were 60983 observations read from the data set WORK.PPI_AD_69.
NOTE: There were 66474 observations read from the data set WORK.PPI_AD_690.
NOTE: There were 68134 observations read from the data set WORK.PPI_AD_691.
NOTE: There were 67679 observations read from the data set WORK.PPI_AD_692.
NOTE: There were 70435 observations read from the data set WORK.PPI_AD_693.
NOTE: There were 67121 observations read from the data set WORK.PPI_AD_694.
NOTE: There were 68884 observations read from the data set WORK.PPI_AD_695.
NOTE: There were 75781 observations read from the data set WORK.PPI_AD_696.
NOTE: There were 35769 observations read from the data set WORK.PPI_AD_697.
NOTE: There were 36722 observations read from the data set WORK.PPI_AD_698.
NOTE: There were 35515 observations read from the data set WORK.PPI_AD_699.
NOTE: There were 77625 observations read from the data set WORK.PPI_AD_7.
NOTE: There were 58733 observations read from the data set WORK.PPI_AD_70.
NOTE: There were 30215 observations read from the data set WORK.PPI_AD_700.
NOTE: There were 40378 observations read from the data set WORK.PPI_AD_701.
NOTE: There were 43142 observations read from the data set WORK.PPI_AD_702.
NOTE: There were 34372 observations read from the data set WORK.PPI_AD_703.
NOTE: There were 39882 observations read from the data set WORK.PPI_AD_704.
NOTE: There were 37103 observations read from the data set WORK.PPI_AD_705.
NOTE: There were 37902 observations read from the data set WORK.PPI_AD_706.
NOTE: There were 37531 observations read from the data set WORK.PPI_AD_707.
NOTE: There were 35217 observations read from the data set WORK.PPI_AD_708.
NOTE: There were 34397 observations read from the data set WORK.PPI_AD_709.
NOTE: There were 63632 observations read from the data set WORK.PPI_AD_71.
NOTE: There were 36617 observations read from the data set WORK.PPI_AD_710.
NOTE: There were 34292 observations read from the data set WORK.PPI_AD_711.
NOTE: There were 39086 observations read from the data set WORK.PPI_AD_712.
NOTE: There were 37167 observations read from the data set WORK.PPI_AD_713.
NOTE: There were 36221 observations read from the data set WORK.PPI_AD_714.
NOTE: There were 35975 observations read from the data set WORK.PPI_AD_715.
NOTE: There were 35765 observations read from the data set WORK.PPI_AD_716.
NOTE: There were 38290 observations read from the data set WORK.PPI_AD_717.
NOTE: There were 37004 observations read from the data set WORK.PPI_AD_718.
NOTE: There were 38433 observations read from the data set WORK.PPI_AD_719.
NOTE: There were 59503 observations read from the data set WORK.PPI_AD_72.
NOTE: There were 41267 observations read from the data set WORK.PPI_AD_720.
NOTE: There were 39851 observations read from the data set WORK.PPI_AD_721.
NOTE: There were 44984 observations read from the data set WORK.PPI_AD_722.
NOTE: There were 37959 observations read from the data set WORK.PPI_AD_723.
NOTE: There were 36826 observations read from the data set WORK.PPI_AD_724.
NOTE: There were 43823 observations read from the data set WORK.PPI_AD_725.
NOTE: There were 45266 observations read from the data set WORK.PPI_AD_726.
NOTE: There were 40210 observations read from the data set WORK.PPI_AD_727.
NOTE: There were 36066 observations read from the data set WORK.PPI_AD_728.
NOTE: There were 34634 observations read from the data set WORK.PPI_AD_729.
NOTE: There were 62916 observations read from the data set WORK.PPI_AD_73.
NOTE: There were 44193 observations read from the data set WORK.PPI_AD_730.
NOTE: There were 39665 observations read from the data set WORK.PPI_AD_731.
NOTE: There were 41421 observations read from the data set WORK.PPI_AD_732.
NOTE: There were 39543 observations read from the data set WORK.PPI_AD_733.
NOTE: There were 39917 observations read from the data set WORK.PPI_AD_734.
NOTE: There were 41560 observations read from the data set WORK.PPI_AD_735.
NOTE: There were 44638 observations read from the data set WORK.PPI_AD_736.
NOTE: There were 40251 observations read from the data set WORK.PPI_AD_737.
NOTE: There were 40967 observations read from the data set WORK.PPI_AD_738.
NOTE: There were 39110 observations read from the data set WORK.PPI_AD_739.
NOTE: There were 60051 observations read from the data set WORK.PPI_AD_74.
NOTE: There were 43559 observations read from the data set WORK.PPI_AD_740.
NOTE: There were 42593 observations read from the data set WORK.PPI_AD_741.
NOTE: There were 42773 observations read from the data set WORK.PPI_AD_742.
NOTE: There were 44016 observations read from the data set WORK.PPI_AD_743.
NOTE: There were 46237 observations read from the data set WORK.PPI_AD_744.
NOTE: There were 43416 observations read from the data set WORK.PPI_AD_745.
NOTE: There were 46627 observations read from the data set WORK.PPI_AD_746.
NOTE: There were 51821 observations read from the data set WORK.PPI_AD_747.
NOTE: There were 47182 observations read from the data set WORK.PPI_AD_748.
NOTE: There were 49466 observations read from the data set WORK.PPI_AD_749.
NOTE: There were 59536 observations read from the data set WORK.PPI_AD_75.
NOTE: There were 50763 observations read from the data set WORK.PPI_AD_750.
NOTE: There were 42319 observations read from the data set WORK.PPI_AD_751.
NOTE: There were 46800 observations read from the data set WORK.PPI_AD_752.
NOTE: There were 44243 observations read from the data set WORK.PPI_AD_753.
NOTE: There were 49790 observations read from the data set WORK.PPI_AD_754.
NOTE: There were 46315 observations read from the data set WORK.PPI_AD_755.
NOTE: There were 43608 observations read from the data set WORK.PPI_AD_756.
NOTE: There were 40291 observations read from the data set WORK.PPI_AD_757.
NOTE: There were 49381 observations read from the data set WORK.PPI_AD_758.
NOTE: There were 44637 observations read from the data set WORK.PPI_AD_759.
NOTE: There were 67070 observations read from the data set WORK.PPI_AD_76.
NOTE: There were 48075 observations read from the data set WORK.PPI_AD_760.
NOTE: There were 42335 observations read from the data set WORK.PPI_AD_761.
NOTE: There were 43860 observations read from the data set WORK.PPI_AD_762.
NOTE: There were 39726 observations read from the data set WORK.PPI_AD_763.
NOTE: There were 44775 observations read from the data set WORK.PPI_AD_764.
NOTE: There were 40997 observations read from the data set WORK.PPI_AD_765.
NOTE: There were 40101 observations read from the data set WORK.PPI_AD_766.
NOTE: There were 38044 observations read from the data set WORK.PPI_AD_767.
NOTE: There were 39151 observations read from the data set WORK.PPI_AD_768.
NOTE: There were 38690 observations read from the data set WORK.PPI_AD_769.
NOTE: There were 65052 observations read from the data set WORK.PPI_AD_77.
NOTE: There were 44218 observations read from the data set WORK.PPI_AD_770.
NOTE: There were 34232 observations read from the data set WORK.PPI_AD_771.
NOTE: There were 33296 observations read from the data set WORK.PPI_AD_772.
NOTE: There were 36784 observations read from the data set WORK.PPI_AD_773.
NOTE: There were 33853 observations read from the data set WORK.PPI_AD_774.
NOTE: There were 30922 observations read from the data set WORK.PPI_AD_775.
NOTE: There were 35310 observations read from the data set WORK.PPI_AD_776.
NOTE: There were 31371 observations read from the data set WORK.PPI_AD_777.
NOTE: There were 35309 observations read from the data set WORK.PPI_AD_778.
NOTE: There were 30124 observations read from the data set WORK.PPI_AD_779.
NOTE: There were 62949 observations read from the data set WORK.PPI_AD_78.
NOTE: There were 32369 observations read from the data set WORK.PPI_AD_780.
NOTE: There were 31939 observations read from the data set WORK.PPI_AD_781.
NOTE: There were 34559 observations read from the data set WORK.PPI_AD_782.
NOTE: There were 32345 observations read from the data set WORK.PPI_AD_783.
NOTE: There were 33925 observations read from the data set WORK.PPI_AD_784.
NOTE: There were 30365 observations read from the data set WORK.PPI_AD_785.
NOTE: There were 31855 observations read from the data set WORK.PPI_AD_786.
NOTE: There were 28256 observations read from the data set WORK.PPI_AD_787.
NOTE: There were 34506 observations read from the data set WORK.PPI_AD_788.
NOTE: There were 30136 observations read from the data set WORK.PPI_AD_789.
NOTE: There were 65326 observations read from the data set WORK.PPI_AD_79.
NOTE: There were 28881 observations read from the data set WORK.PPI_AD_790.
NOTE: There were 30377 observations read from the data set WORK.PPI_AD_791.
NOTE: There were 33465 observations read from the data set WORK.PPI_AD_792.
NOTE: There were 34321 observations read from the data set WORK.PPI_AD_793.
NOTE: There were 36066 observations read from the data set WORK.PPI_AD_794.
NOTE: There were 29310 observations read from the data set WORK.PPI_AD_795.
NOTE: There were 29994 observations read from the data set WORK.PPI_AD_796.
NOTE: There were 31960 observations read from the data set WORK.PPI_AD_797.
NOTE: There were 32738 observations read from the data set WORK.PPI_AD_798.
NOTE: There were 31677 observations read from the data set WORK.PPI_AD_799.
NOTE: There were 84280 observations read from the data set WORK.PPI_AD_8.
NOTE: There were 65058 observations read from the data set WORK.PPI_AD_80.
NOTE: There were 28813 observations read from the data set WORK.PPI_AD_800.
NOTE: There were 28429 observations read from the data set WORK.PPI_AD_801.
NOTE: There were 31404 observations read from the data set WORK.PPI_AD_802.
NOTE: There were 26909 observations read from the data set WORK.PPI_AD_803.
NOTE: There were 28317 observations read from the data set WORK.PPI_AD_804.
NOTE: There were 27758 observations read from the data set WORK.PPI_AD_805.
NOTE: There were 30945 observations read from the data set WORK.PPI_AD_806.
NOTE: There were 27819 observations read from the data set WORK.PPI_AD_807.
NOTE: There were 27209 observations read from the data set WORK.PPI_AD_808.
NOTE: There were 26625 observations read from the data set WORK.PPI_AD_809.
NOTE: There were 61563 observations read from the data set WORK.PPI_AD_81.
NOTE: There were 29340 observations read from the data set WORK.PPI_AD_810.
NOTE: There were 24091 observations read from the data set WORK.PPI_AD_811.
NOTE: There were 28884 observations read from the data set WORK.PPI_AD_812.
NOTE: There were 26299 observations read from the data set WORK.PPI_AD_813.
NOTE: There were 26130 observations read from the data set WORK.PPI_AD_814.
NOTE: There were 29402 observations read from the data set WORK.PPI_AD_815.
NOTE: There were 28945 observations read from the data set WORK.PPI_AD_816.
NOTE: There were 38842 observations read from the data set WORK.PPI_AD_817.
NOTE: There were 49517 observations read from the data set WORK.PPI_AD_818.
NOTE: There were 84004 observations read from the data set WORK.PPI_AD_819.
NOTE: There were 61964 observations read from the data set WORK.PPI_AD_82.
NOTE: There were 91313 observations read from the data set WORK.PPI_AD_820.
NOTE: There were 47031 observations read from the data set WORK.PPI_AD_821.
NOTE: There were 49719 observations read from the data set WORK.PPI_AD_822.
NOTE: There were 50628 observations read from the data set WORK.PPI_AD_823.
NOTE: There were 50565 observations read from the data set WORK.PPI_AD_824.
NOTE: There were 51340 observations read from the data set WORK.PPI_AD_825.
NOTE: There were 39367 observations read from the data set WORK.PPI_AD_826.
NOTE: There were 45778 observations read from the data set WORK.PPI_AD_827.
NOTE: There were 52676 observations read from the data set WORK.PPI_AD_828.
NOTE: There were 60132 observations read from the data set WORK.PPI_AD_829.
NOTE: There were 62945 observations read from the data set WORK.PPI_AD_83.
NOTE: There were 13894 observations read from the data set WORK.PPI_AD_830.
NOTE: There were 63296 observations read from the data set WORK.PPI_AD_831.
NOTE: There were 72357 observations read from the data set WORK.PPI_AD_832.
NOTE: There were 74385 observations read from the data set WORK.PPI_AD_833.
NOTE: There were 76304 observations read from the data set WORK.PPI_AD_834.
NOTE: There were 81718 observations read from the data set WORK.PPI_AD_835.
NOTE: There were 76795 observations read from the data set WORK.PPI_AD_836.
NOTE: There were 80027 observations read from the data set WORK.PPI_AD_837.
NOTE: There were 79931 observations read from the data set WORK.PPI_AD_838.
NOTE: There were 80830 observations read from the data set WORK.PPI_AD_839.
NOTE: There were 61569 observations read from the data set WORK.PPI_AD_84.
NOTE: There were 52389 observations read from the data set WORK.PPI_AD_840.
NOTE: There were 54464 observations read from the data set WORK.PPI_AD_841.
NOTE: There were 56645 observations read from the data set WORK.PPI_AD_842.
NOTE: There were 56979 observations read from the data set WORK.PPI_AD_843.
NOTE: There were 52308 observations read from the data set WORK.PPI_AD_844.
NOTE: There were 56743 observations read from the data set WORK.PPI_AD_845.
NOTE: There were 56950 observations read from the data set WORK.PPI_AD_846.
NOTE: There were 56614 observations read from the data set WORK.PPI_AD_847.
NOTE: There were 60122 observations read from the data set WORK.PPI_AD_848.
NOTE: There were 60653 observations read from the data set WORK.PPI_AD_849.
NOTE: There were 64958 observations read from the data set WORK.PPI_AD_85.
NOTE: There were 58124 observations read from the data set WORK.PPI_AD_850.
NOTE: There were 61058 observations read from the data set WORK.PPI_AD_851.
NOTE: There were 62842 observations read from the data set WORK.PPI_AD_852.
NOTE: There were 64099 observations read from the data set WORK.PPI_AD_853.
NOTE: There were 60724 observations read from the data set WORK.PPI_AD_854.
NOTE: There were 66037 observations read from the data set WORK.PPI_AD_855.
NOTE: There were 62566 observations read from the data set WORK.PPI_AD_856.
NOTE: There were 64378 observations read from the data set WORK.PPI_AD_857.
NOTE: There were 64422 observations read from the data set WORK.PPI_AD_858.
NOTE: There were 72631 observations read from the data set WORK.PPI_AD_859.
NOTE: There were 63844 observations read from the data set WORK.PPI_AD_86.
NOTE: There were 68256 observations read from the data set WORK.PPI_AD_860.
NOTE: There were 70692 observations read from the data set WORK.PPI_AD_861.
NOTE: There were 71582 observations read from the data set WORK.PPI_AD_862.
NOTE: There were 78679 observations read from the data set WORK.PPI_AD_863.
NOTE: There were 72036 observations read from the data set WORK.PPI_AD_864.
NOTE: There were 82067 observations read from the data set WORK.PPI_AD_865.
NOTE: There were 78395 observations read from the data set WORK.PPI_AD_866.
NOTE: There were 80235 observations read from the data set WORK.PPI_AD_867.
NOTE: There were 84290 observations read from the data set WORK.PPI_AD_868.
NOTE: There were 86010 observations read from the data set WORK.PPI_AD_869.
NOTE: There were 63408 observations read from the data set WORK.PPI_AD_87.
NOTE: There were 44396 observations read from the data set WORK.PPI_AD_870.
NOTE: There were 39709 observations read from the data set WORK.PPI_AD_871.
NOTE: There were 46134 observations read from the data set WORK.PPI_AD_872.
NOTE: There were 41310 observations read from the data set WORK.PPI_AD_873.
NOTE: There were 41821 observations read from the data set WORK.PPI_AD_874.
NOTE: There were 42858 observations read from the data set WORK.PPI_AD_875.
NOTE: There were 42379 observations read from the data set WORK.PPI_AD_876.
NOTE: There were 47146 observations read from the data set WORK.PPI_AD_877.
NOTE: There were 43640 observations read from the data set WORK.PPI_AD_878.
NOTE: There were 44523 observations read from the data set WORK.PPI_AD_879.
NOTE: There were 70229 observations read from the data set WORK.PPI_AD_88.
NOTE: There were 44163 observations read from the data set WORK.PPI_AD_880.
NOTE: There were 47568 observations read from the data set WORK.PPI_AD_881.
NOTE: There were 47392 observations read from the data set WORK.PPI_AD_882.
NOTE: There were 51372 observations read from the data set WORK.PPI_AD_883.
NOTE: There were 56674 observations read from the data set WORK.PPI_AD_884.
NOTE: There were 49508 observations read from the data set WORK.PPI_AD_885.
NOTE: There were 54456 observations read from the data set WORK.PPI_AD_886.
NOTE: There were 49484 observations read from the data set WORK.PPI_AD_887.
NOTE: There were 52379 observations read from the data set WORK.PPI_AD_888.
NOTE: There were 57535 observations read from the data set WORK.PPI_AD_889.
NOTE: There were 65485 observations read from the data set WORK.PPI_AD_89.
NOTE: There were 54927 observations read from the data set WORK.PPI_AD_890.
NOTE: There were 61218 observations read from the data set WORK.PPI_AD_891.
NOTE: There were 71825 observations read from the data set WORK.PPI_AD_892.
NOTE: There were 80887 observations read from the data set WORK.PPI_AD_893.
NOTE: There were 45941 observations read from the data set WORK.PPI_AD_894.
NOTE: There were 53671 observations read from the data set WORK.PPI_AD_895.
NOTE: There were 41355 observations read from the data set WORK.PPI_AD_896.
NOTE: There were 41113 observations read from the data set WORK.PPI_AD_897.
NOTE: There were 49819 observations read from the data set WORK.PPI_AD_898.
NOTE: There were 48524 observations read from the data set WORK.PPI_AD_899.
NOTE: There were 72465 observations read from the data set WORK.PPI_AD_9.
NOTE: There were 58250 observations read from the data set WORK.PPI_AD_90.
NOTE: There were 45990 observations read from the data set WORK.PPI_AD_900.
NOTE: There were 53422 observations read from the data set WORK.PPI_AD_901.
NOTE: There were 50582 observations read from the data set WORK.PPI_AD_902.
NOTE: There were 52769 observations read from the data set WORK.PPI_AD_903.
NOTE: There were 49549 observations read from the data set WORK.PPI_AD_904.
NOTE: There were 50693 observations read from the data set WORK.PPI_AD_905.
NOTE: There were 50975 observations read from the data set WORK.PPI_AD_906.
NOTE: There were 58686 observations read from the data set WORK.PPI_AD_907.
NOTE: There were 54162 observations read from the data set WORK.PPI_AD_908.
NOTE: There were 57835 observations read from the data set WORK.PPI_AD_909.
NOTE: There were 73799 observations read from the data set WORK.PPI_AD_91.
NOTE: There were 53660 observations read from the data set WORK.PPI_AD_910.
NOTE: There were 55002 observations read from the data set WORK.PPI_AD_911.
NOTE: There were 51499 observations read from the data set WORK.PPI_AD_912.
NOTE: There were 60025 observations read from the data set WORK.PPI_AD_913.
NOTE: There were 55070 observations read from the data set WORK.PPI_AD_914.
NOTE: There were 54695 observations read from the data set WORK.PPI_AD_915.
NOTE: There were 55643 observations read from the data set WORK.PPI_AD_916.
NOTE: There were 62686 observations read from the data set WORK.PPI_AD_917.
NOTE: There were 61145 observations read from the data set WORK.PPI_AD_918.
NOTE: There were 67522 observations read from the data set WORK.PPI_AD_919.
NOTE: There were 67224 observations read from the data set WORK.PPI_AD_92.
NOTE: There were 56996 observations read from the data set WORK.PPI_AD_920.
NOTE: There were 57712 observations read from the data set WORK.PPI_AD_921.
NOTE: There were 61934 observations read from the data set WORK.PPI_AD_922.
NOTE: There were 65050 observations read from the data set WORK.PPI_AD_923.
NOTE: There were 61181 observations read from the data set WORK.PPI_AD_924.
NOTE: There were 57924 observations read from the data set WORK.PPI_AD_925.
NOTE: There were 57687 observations read from the data set WORK.PPI_AD_926.
NOTE: There were 63616 observations read from the data set WORK.PPI_AD_927.
NOTE: There were 52424 observations read from the data set WORK.PPI_AD_928.
NOTE: There were 60695 observations read from the data set WORK.PPI_AD_929.
NOTE: There were 66493 observations read from the data set WORK.PPI_AD_93.
NOTE: There were 55392 observations read from the data set WORK.PPI_AD_930.
NOTE: There were 63321 observations read from the data set WORK.PPI_AD_931.
NOTE: There were 56116 observations read from the data set WORK.PPI_AD_932.
NOTE: There were 58426 observations read from the data set WORK.PPI_AD_933.
NOTE: There were 54472 observations read from the data set WORK.PPI_AD_934.
NOTE: There were 57230 observations read from the data set WORK.PPI_AD_935.
NOTE: There were 50708 observations read from the data set WORK.PPI_AD_936.
NOTE: There were 57880 observations read from the data set WORK.PPI_AD_937.
NOTE: There were 48413 observations read from the data set WORK.PPI_AD_938.
NOTE: There were 46046 observations read from the data set WORK.PPI_AD_939.
NOTE: There were 64370 observations read from the data set WORK.PPI_AD_94.
NOTE: There were 48820 observations read from the data set WORK.PPI_AD_940.
NOTE: There were 38248 observations read from the data set WORK.PPI_AD_941.
NOTE: There were 25803 observations read from the data set WORK.PPI_AD_942.
NOTE: There were 18731 observations read from the data set WORK.PPI_AD_943.
NOTE: There were 24830 observations read from the data set WORK.PPI_AD_944.
NOTE: There were 12678 observations read from the data set WORK.PPI_AD_945.
NOTE: There were 13781 observations read from the data set WORK.PPI_AD_946.
NOTE: There were 15113 observations read from the data set WORK.PPI_AD_947.
NOTE: There were 15640 observations read from the data set WORK.PPI_AD_948.
NOTE: There were 16821 observations read from the data set WORK.PPI_AD_949.
NOTE: There were 65610 observations read from the data set WORK.PPI_AD_95.
NOTE: There were 13643 observations read from the data set WORK.PPI_AD_950.
NOTE: There were 16014 observations read from the data set WORK.PPI_AD_951.
NOTE: There were 19581 observations read from the data set WORK.PPI_AD_952.
NOTE: There were 23167 observations read from the data set WORK.PPI_AD_953.
NOTE: There were 26443 observations read from the data set WORK.PPI_AD_954.
NOTE: There were 30891 observations read from the data set WORK.PPI_AD_955.
NOTE: There were 32667 observations read from the data set WORK.PPI_AD_956.
NOTE: There were 34053 observations read from the data set WORK.PPI_AD_957.
NOTE: There were 34583 observations read from the data set WORK.PPI_AD_958.
NOTE: There were 35572 observations read from the data set WORK.PPI_AD_959.
NOTE: There were 65976 observations read from the data set WORK.PPI_AD_96.
NOTE: There were 37592 observations read from the data set WORK.PPI_AD_960.
NOTE: There were 36988 observations read from the data set WORK.PPI_AD_961.
NOTE: There were 37269 observations read from the data set WORK.PPI_AD_962.
NOTE: There were 38496 observations read from the data set WORK.PPI_AD_963.
NOTE: There were 39573 observations read from the data set WORK.PPI_AD_964.
NOTE: There were 42505 observations read from the data set WORK.PPI_AD_965.
NOTE: There were 42018 observations read from the data set WORK.PPI_AD_966.
NOTE: There were 44027 observations read from the data set WORK.PPI_AD_967.
NOTE: There were 47111 observations read from the data set WORK.PPI_AD_968.
NOTE: There were 46856 observations read from the data set WORK.PPI_AD_969.
NOTE: There were 65916 observations read from the data set WORK.PPI_AD_97.
NOTE: There were 48158 observations read from the data set WORK.PPI_AD_970.
NOTE: There were 48786 observations read from the data set WORK.PPI_AD_971.
NOTE: There were 50364 observations read from the data set WORK.PPI_AD_972.
NOTE: There were 55317 observations read from the data set WORK.PPI_AD_973.
NOTE: There were 54006 observations read from the data set WORK.PPI_AD_974.
NOTE: There were 56478 observations read from the data set WORK.PPI_AD_975.
NOTE: There were 59326 observations read from the data set WORK.PPI_AD_976.
NOTE: There were 59046 observations read from the data set WORK.PPI_AD_977.
NOTE: There were 64988 observations read from the data set WORK.PPI_AD_978.
NOTE: There were 66356 observations read from the data set WORK.PPI_AD_979.
NOTE: There were 61841 observations read from the data set WORK.PPI_AD_98.
NOTE: There were 70710 observations read from the data set WORK.PPI_AD_980.
NOTE: There were 72252 observations read from the data set WORK.PPI_AD_981.
NOTE: There were 70166 observations read from the data set WORK.PPI_AD_982.
NOTE: There were 78188 observations read from the data set WORK.PPI_AD_983.
NOTE: There were 81665 observations read from the data set WORK.PPI_AD_984.
NOTE: There were 59433 observations read from the data set WORK.PPI_AD_985.
NOTE: There were 62750 observations read from the data set WORK.PPI_AD_986.
NOTE: There were 66811 observations read from the data set WORK.PPI_AD_987.
NOTE: There were 70222 observations read from the data set WORK.PPI_AD_988.
NOTE: There were 74807 observations read from the data set WORK.PPI_AD_989.
NOTE: There were 64399 observations read from the data set WORK.PPI_AD_99.
NOTE: There were 46941 observations read from the data set WORK.PPI_AD_990.
NOTE: There were 56845 observations read from the data set WORK.PPI_AD_991.
NOTE: There were 71698 observations read from the data set WORK.PPI_AD_992.
NOTE: There were 65858 observations read from the data set WORK.PPI_AD_993.
NOTE: There were 75773 observations read from the data set WORK.PPI_AD_994.
NOTE: There were 75037 observations read from the data set WORK.PPI_AD_995.
NOTE: There were 79362 observations read from the data set WORK.PPI_AD_996.
NOTE: There were 75666 observations read from the data set WORK.PPI_AD_997.
NOTE: There were 80664 observations read from the data set WORK.PPI_AD_998.
NOTE: There were 81975 observations read from the data set WORK.PPI_AD_999.
NOTE: The data set AN.ALLDRUG9314 has 64387977 observations and 21 variables.;

/* for case-time-control to take the LC data
Note: copied from PB_PPI SAS editor*/
proc sql;
create table lc_rest as
select * from p.ppi_pb_0314op where reference_key not in (select VAR1 from rk.mistroke_txt);
quit; *1629889;
proc sort data=lc_rest nodupkey out=rk.lc_rest;
by reference_key;run; *319459;
data lc_rest;
set lc_rest;
keep reference_key;run;
data lc_rest;set lc_rest;n=_n_;run;
data lc_rest;
set lc_rest;
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
if 150001<=n<=160000 then file=16;
if 160001<=n<=170000 then file=17;
if 170001<=n<=180000 then file=18;
if 180001<=n<=190000 then file=19;
if 190001<=n<=200000 then file=20;
if 200001<=n<=210000 then file=21;
if 210001<=n<=220000 then file=22;
if 220001<=n<=230000 then file=23;
if 230001<=n<=240000 then file=24;
if 240001<=n<=250000 then file=25;
if 250001<=n<=260000 then file=26;
if 260001<=n<=270000 then file=27;
if 270001<=n<=280000 then file=28;
if 280001<=n<=290000 then file=29;
if 290001<=n<=300000 then file=30;
if 300001<=n<=319459 then file=31;
run;
%macro export;
%do i=1 %to 31;
data hc&i.;
set lc_rest;
if file=&i. then output hc&i.;
keep reference_key;
run;
%end;
%mend;
%export;
%macro export;
%do i=1 %to 31;
PROC EXPORT DATA= WORK.hc&i.
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\ppi_lcrest_&i..txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=No;
RUN;
%end;
%mend;
%export;
/*import LC data for rest PPIs patients during 93-97*/
%macro import;
   %do i=845 %to 989;
   PROC IMPORT OUT= ppi_lc_&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\LC\master\ppi_pb_LC_&i..xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%import;
data ppi_lcrest_9397;
set ppi_lc_:;run;
data a;
set ppi_lcrest_9397;
if missing(reference_key) or (missing(OT_Date__yyyy_mm_dd_) and missing(PSY_Form__Service_Date__yyyy_mm_) and
missing(Attendance_Date__yyyy_mm_dd_) and missing(Admission_Date__yyyy_mm_dd_) and missing(Appointment_Date__yyyy_mm_dd_) and missing(Injection_Date__yyyy_mm_dd_));
run; *0;

/*identify the rest who doesnt have LC date in 1993-1997*/

proc sql;
create table rk.lc_rest_sec as
select * from rk.lc_rest where reference_key not in (select reference_key from ppi_lcrest_9397);
quit;
proc sort data=rk.lc_rest_sec nodupkey;
by reference_key;run;
data rk.lc_rest_sec;
set rk.lc_rest_sec;
keep reference_key;run;
data rk.lc_rest_sec;set rk.lc_rest_sec;n=_n_;run; *127645;
data rk.lc_rest_sec;
set rk.lc_rest_sec;
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
if 110001<=n<=127645 then file=12;
run;
%macro export;
%do i=1 %to 12;
data hc&i.;
set rk.lc_rest_sec;
if file=&i. then output hc&i.;
keep reference_key;
run;
%end;
%mend;
%export;
%macro export;
%do i=1 %to 12;
PROC EXPORT DATA= WORK.hc&i.
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\ppi_lcrest_sec_&i..txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=No;
RUN;
%end;
%mend;
%export;


/*import LC data for rest PPIs patients during 1998-2002*/
%macro import;
   %do i=990 %to 1099;
   PROC IMPORT OUT= ppi_lc_&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\LC\master\ppi_pb_LC_&i..xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%import;
data ppi_lcrest_9802;
set ppi_lc_:;run; *939791;

data a;
set ppi_lcrest_9802;
if missing(reference_key) or (missing(OT_Date__yyyy_mm_dd_) and missing(PSY_Form__Service_Date__yyyy_mm_) and
missing(Attendance_Date__yyyy_mm_dd_) and missing(Admission_Date__yyyy_mm_dd_) and missing(Appointment_Date__yyyy_mm_dd_) and missing(Injection_Date__yyyy_mm_dd_));
run; *0;

/*identify the rest who doesnt have LC date in 1998-2002*/

proc sql;
create table rk.lc_rest_thir as
select * from rk.lc_rest_sec where reference_key not in (select reference_key from ppi_lcrest_9802);
quit;
proc sort data=rk.lc_rest_thir nodupkey;
by reference_key;run; *52961;
data rk.lc_rest_thir;
set rk.lc_rest_thir;
keep reference_key;run;
data rk.lc_rest_thir;set rk.lc_rest_thir;n=_n_;run; *52961;
data rk.lc_rest_thir;
set rk.lc_rest_thir;
if 1<=n<=10000 then file=1;
if 10001<=n<=20000 then file=2;
if 20001<=n<=30000 then file=3;
if 30001<=n<=40000 then file=4;
if 40001<=n<=52961 then file=5;
run;
%macro export;
%do i=1 %to 5;
data hc&i.;
set rk.lc_rest_thir;
if file=&i. then output hc&i.;
keep reference_key;
run;
%end;
%mend;
%export;
%macro export;
%do i=1 %to 5;
PROC EXPORT DATA= WORK.hc&i.
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\ppi_lcrest_thir_&i..txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=No;
RUN;
%end;
%mend;
%export;

/*import LC data for rest PPIs patients 
1. first LC rest 1-31 (9397)
2. sec LC rest 1-12 (9802)
3. third LC rest 1-5 (0314)*/
%macro import;
   %do i=845 %to 1366;
   PROC IMPORT OUT= ppi_lc_&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\LC\master\ppi_pb_LC_&i..xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%import;
data lc.ppi_lcrest_all;
set ppi_lc_:;run; *5618672;

data a;
set lc.ppi_lcrest_all;
if missing(reference_key) or (missing(OT_Date__yyyy_mm_dd_) and missing(PSY_Form__Service_Date__yyyy_mm_) and
missing(Attendance_Date__yyyy_mm_dd_) and missing(Admission_Date__yyyy_mm_dd_) and missing(Appointment_Date__yyyy_mm_dd_) and missing(Injection_Date__yyyy_mm_dd_));
run; *0;

/*take admission date for 412% patients which are not present in 410%*/
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
proc sort data=allmi412 nodupkey out=allmi412;
by reference_key;
run; *1873;
data allmi412;
set allmi412;
keep reference_key;run;
PROC EXPORT DATA= allmi412
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\allmi412.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=No;
RUN;

%macro import;
   %do i=1 %to 5;
   PROC IMPORT OUT= ppi_mi412_&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\IP\master\ppi_MI412_&i..xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%import;
data dx.mi412_ip_all;
set ppi_mi412_5 ppi_mi412_4 ppi_mi412_3 ppi_mi412_2 ppi_mi412_1;
run;
*NOTE: There were 6355 observations read from the data set WORK.PPI_MI412_1.
NOTE: There were 19345 observations read from the data set WORK.PPI_MI412_2.
NOTE: There were 32070 observations read from the data set WORK.PPI_MI412_3.
NOTE: There were 68860 observations read from the data set WORK.PPI_MI412_4.
NOTE: There were 19250 observations read from the data set WORK.PPI_MI412_5.
NOTE: The data set DX.MI412_IP_ALL has 145880 observations and 7 variables.;
data a;
set dx.mi412_ip_all;
if missing(reference_key);
run; *0;

/*import all drugs for control patients in CTC analysis*/
%macro import;
   %do i=1 %to 21;
   PROC IMPORT OUT= control_alldrug_&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\alldrug\master\control_alldrug_&i..xlsx"
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
%end;
%mend;
%import;
%macro drop;
%do i=1 %to 21;
data control_alldrug_&i.;
set control_alldrug_&i.;
drop Dispensing_Duration;
run;
%end;
%mend;
%drop;
data an.control_alldrug_all;
set control_alldrug_:;run; *1157204;

*NOTE: There were 94047 observations read from the data set WORK.CONTROL_ALLDRUG_1.
NOTE: There were 49638 observations read from the data set WORK.CONTROL_ALLDRUG_10.
NOTE: There were 55242 observations read from the data set WORK.CONTROL_ALLDRUG_11.
NOTE: There were 50953 observations read from the data set WORK.CONTROL_ALLDRUG_12.
NOTE: There were 50956 observations read from the data set WORK.CONTROL_ALLDRUG_13.
NOTE: There were 53886 observations read from the data set WORK.CONTROL_ALLDRUG_14.
NOTE: There were 50967 observations read from the data set WORK.CONTROL_ALLDRUG_15.
NOTE: There were 52140 observations read from the data set WORK.CONTROL_ALLDRUG_16.
NOTE: There were 51237 observations read from the data set WORK.CONTROL_ALLDRUG_17.
NOTE: There were 50869 observations read from the data set WORK.CONTROL_ALLDRUG_18.
NOTE: There were 52774 observations read from the data set WORK.CONTROL_ALLDRUG_19.
NOTE: There were 41403 observations read from the data set WORK.CONTROL_ALLDRUG_2.
NOTE: There were 56415 observations read from the data set WORK.CONTROL_ALLDRUG_20.
NOTE: There were 55239 observations read from the data set WORK.CONTROL_ALLDRUG_21.
NOTE: There were 60528 observations read from the data set WORK.CONTROL_ALLDRUG_3.
NOTE: There were 74591 observations read from the data set WORK.CONTROL_ALLDRUG_4.
NOTE: There were 77490 observations read from the data set WORK.CONTROL_ALLDRUG_5.
NOTE: There were 42725 observations read from the data set WORK.CONTROL_ALLDRUG_6.
NOTE: There were 44247 observations read from the data set WORK.CONTROL_ALLDRUG_7.
NOTE: There were 45808 observations read from the data set WORK.CONTROL_ALLDRUG_8.
NOTE: There were 46049 observations read from the data set WORK.CONTROL_ALLDRUG_9.
NOTE: The data set AN.CONTROL_ALLDRUG_ALL has 1157204 observations and 20 variables.;

PROC EXPORT DATA= an.control_alldrug_all
            OUTFILE= "W:\Angel\MPhil\cross_check\PPIs_MI\CTC\SAS raw files\control_alldrug9314.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;
