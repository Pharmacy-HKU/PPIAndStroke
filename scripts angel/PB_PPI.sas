/*Created on 30 Dec 2015
Purpose: To import PPI prescription identified in patient based souce of CDARS
*/
libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";

%macro import;
   %do i=1 %to 96;
   PROC IMPORT OUT= ppi_pb_&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\PB_Rx\master\ppi_pb_&i..xlsx" 
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
   %do i=1 %to 96;
data ppi_pb_&i.;
set ppi_pb_&i.;
drop Therapeutic_Classification__BNF_;
run;
%end;
%mend;
%drop;
data p.ppi_pb_0312;
length Route $50. Drug_Strength $50. Dosage $50. Dosage_Unit $50. Drug_Frequency $50. Action_Status $50.;
set ppi_pb_:;run;
/*NOTE: There were 38412 observations read from the data set P.PPI_PB_1.
NOTE: There were 60552 observations read from the data set P.PPI_PB_10.
NOTE: There were 63234 observations read from the data set P.PPI_PB_11.
NOTE: There were 67690 observations read from the data set P.PPI_PB_12.
NOTE: There were 65903 observations read from the data set P.PPI_PB_13.
NOTE: There were 75133 observations read from the data set P.PPI_PB_14.
NOTE: There were 73370 observations read from the data set P.PPI_PB_15.
NOTE: There were 71202 observations read from the data set P.PPI_PB_16.
NOTE: There were 64754 observations read from the data set P.PPI_PB_17.
NOTE: There were 63869 observations read from the data set P.PPI_PB_18.
NOTE: There were 63868 observations read from the data set P.PPI_PB_19.
NOTE: There were 38459 observations read from the data set P.PPI_PB_2.
NOTE: There were 65960 observations read from the data set P.PPI_PB_20.
NOTE: There were 68523 observations read from the data set P.PPI_PB_21.
NOTE: There were 68687 observations read from the data set P.PPI_PB_22.
NOTE: There were 67630 observations read from the data set P.PPI_PB_23.
NOTE: There were 75274 observations read from the data set P.PPI_PB_24.
NOTE: There were 42500 observations read from the data set P.PPI_PB_25.
NOTE: There were 37213 observations read from the data set P.PPI_PB_26.
NOTE: There were 44305 observations read from the data set P.PPI_PB_27.
NOTE: There were 38767 observations read from the data set P.PPI_PB_28.
NOTE: There were 41138 observations read from the data set P.PPI_PB_29.
NOTE: There were 33959 observations read from the data set P.PPI_PB_3.
NOTE: There were 39622 observations read from the data set P.PPI_PB_30.
NOTE: There were 41012 observations read from the data set P.PPI_PB_31.
NOTE: There were 44008 observations read from the data set P.PPI_PB_32.
NOTE: There were 40550 observations read from the data set P.PPI_PB_33.
NOTE: There were 43196 observations read from the data set P.PPI_PB_34.
NOTE: There were 45411 observations read from the data set P.PPI_PB_35.
NOTE: There were 46160 observations read from the data set P.PPI_PB_36.
NOTE: There were 50013 observations read from the data set P.PPI_PB_37.
NOTE: There were 47419 observations read from the data set P.PPI_PB_38.
NOTE: There were 48991 observations read from the data set P.PPI_PB_39.
NOTE: There were 40085 observations read from the data set P.PPI_PB_4.
NOTE: There were 48894 observations read from the data set P.PPI_PB_40.
NOTE: There were 48766 observations read from the data set P.PPI_PB_41.
NOTE: There were 47127 observations read from the data set P.PPI_PB_42.
NOTE: There were 49041 observations read from the data set P.PPI_PB_43.
NOTE: There were 49172 observations read from the data set P.PPI_PB_44.
NOTE: There were 49852 observations read from the data set P.PPI_PB_45.
NOTE: There were 49985 observations read from the data set P.PPI_PB_46.
NOTE: There were 49742 observations read from the data set P.PPI_PB_47.
NOTE: There were 57455 observations read from the data set P.PPI_PB_48.
NOTE: There were 55132 observations read from the data set P.PPI_PB_49.
NOTE: There were 46240 observations read from the data set P.PPI_PB_5.
NOTE: There were 54245 observations read from the data set P.PPI_PB_50.
NOTE: There were 58907 observations read from the data set P.PPI_PB_51.
NOTE: There were 57033 observations read from the data set P.PPI_PB_52.
NOTE: There were 53681 observations read from the data set P.PPI_PB_53.
NOTE: There were 56531 observations read from the data set P.PPI_PB_54.
NOTE: There were 57278 observations read from the data set P.PPI_PB_55.
NOTE: There were 56392 observations read from the data set P.PPI_PB_56.
NOTE: There were 58113 observations read from the data set P.PPI_PB_57.
NOTE: There were 57321 observations read from the data set P.PPI_PB_58.
NOTE: There were 58936 observations read from the data set P.PPI_PB_59.
NOTE: There were 51751 observations read from the data set P.PPI_PB_6.
NOTE: There were 64856 observations read from the data set P.PPI_PB_60.
NOTE: There were 62988 observations read from the data set P.PPI_PB_61.
NOTE: There were 56541 observations read from the data set P.PPI_PB_62.
NOTE: There were 69673 observations read from the data set P.PPI_PB_63.
NOTE: There were 63280 observations read from the data set P.PPI_PB_64.
NOTE: There were 63836 observations read from the data set P.PPI_PB_65.
NOTE: There were 62943 observations read from the data set P.PPI_PB_66.
NOTE: There were 62376 observations read from the data set P.PPI_PB_67.
NOTE: There were 63605 observations read from the data set P.PPI_PB_68.
NOTE: There were 64499 observations read from the data set P.PPI_PB_69.
NOTE: There were 54684 observations read from the data set P.PPI_PB_7.
NOTE: There were 62047 observations read from the data set P.PPI_PB_70.
NOTE: There were 65677 observations read from the data set P.PPI_PB_71.
NOTE: There were 69729 observations read from the data set P.PPI_PB_72.
NOTE: There were 71532 observations read from the data set P.PPI_PB_73.
NOTE: There were 63073 observations read from the data set P.PPI_PB_74.
NOTE: There were 75192 observations read from the data set P.PPI_PB_75.
NOTE: There were 69848 observations read from the data set P.PPI_PB_76.
NOTE: There were 70142 observations read from the data set P.PPI_PB_77.
NOTE: There were 70403 observations read from the data set P.PPI_PB_78.
NOTE: There were 69446 observations read from the data set P.PPI_PB_79.
NOTE: There were 58925 observations read from the data set P.PPI_PB_8.
NOTE: There were 75006 observations read from the data set P.PPI_PB_80.
NOTE: There were 73163 observations read from the data set P.PPI_PB_81.
NOTE: There were 73920 observations read from the data set P.PPI_PB_82.
NOTE: There were 76843 observations read from the data set P.PPI_PB_83.
NOTE: There were 80779 observations read from the data set P.PPI_PB_84.
NOTE: There were 80443 observations read from the data set P.PPI_PB_85.
NOTE: There were 84822 observations read from the data set P.PPI_PB_86.
NOTE: There were 90399 observations read from the data set P.PPI_PB_87.
NOTE: There were 80697 observations read from the data set P.PPI_PB_88.
NOTE: There were 88356 observations read from the data set P.PPI_PB_89.
NOTE: There were 57953 observations read from the data set P.PPI_PB_9.
NOTE: There were 85249 observations read from the data set P.PPI_PB_90.
NOTE: There were 85349 observations read from the data set P.PPI_PB_91.
NOTE: There were 92292 observations read from the data set P.PPI_PB_92.
NOTE: There were 85573 observations read from the data set P.PPI_PB_93.
NOTE: There were 86921 observations read from the data set P.PPI_PB_94.
NOTE: There were 92666 observations read from the data set P.PPI_PB_95.
NOTE: There were 93520 observations read from the data set P.PPI_PB_96.
NOTE: The data set P.PPI_PB_0312 has 5907709 observations and 27 variables.*/

/*Updated on 16 Feb 2016*/
%macro import;
   %do i=97 %to 114;
   PROC IMPORT OUT= ppi_pb_&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\PB_Rx\master\ppi_pb_&i..xlsx" 
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
   %do i=97 %to 114;
data ppi_pb_&i.;
set ppi_pb_&i.;
drop Dispensing_Duration;
run;
%end;
%mend;
%drop;
data p.ppi_pb_0002;
set ppi_pb_:;run;
*NOTE: There were 26392 observations read from the data set WORK.PPI_PB_100.
NOTE: There were 27324 observations read from the data set WORK.PPI_PB_101.
NOTE: There were 30646 observations read from the data set WORK.PPI_PB_102.
NOTE: There were 30782 observations read from the data set WORK.PPI_PB_103.
NOTE: There were 33587 observations read from the data set WORK.PPI_PB_104.
NOTE: There were 34175 observations read from the data set WORK.PPI_PB_105.
NOTE: There were 34430 observations read from the data set WORK.PPI_PB_106.
NOTE: There were 32693 observations read from the data set WORK.PPI_PB_107.
NOTE: There were 32556 observations read from the data set WORK.PPI_PB_108.
NOTE: There were 32962 observations read from the data set WORK.PPI_PB_109.
NOTE: There were 32035 observations read from the data set WORK.PPI_PB_110.
NOTE: There were 33339 observations read from the data set WORK.PPI_PB_111.
NOTE: There were 36458 observations read from the data set WORK.PPI_PB_112.
NOTE: There were 36557 observations read from the data set WORK.PPI_PB_113.
NOTE: There were 38253 observations read from the data set WORK.PPI_PB_114.
NOTE: There were 23338 observations read from the data set WORK.PPI_PB_97.
NOTE: There were 25363 observations read from the data set WORK.PPI_PB_98.
NOTE: There were 24004 observations read from the data set WORK.PPI_PB_99.
NOTE: The data set P.PPI_PB_0002 has 564894 observations and 25 variables.;

/*Updated on 25 Feb 2016*/
%macro import;
   %do i=115 %to 159;
   PROC IMPORT OUT= ppi_pb_&i.
            DATAFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\PB_Rx\master\ppi_pb_&i..xlsx" 
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
data p.ppi_pb_1314;
length Dosage $50. Dosage_Unit $50. Drug_Frequency $50. Dispensing_Duration_Unit $50.;
set ppi_pb_:;run;
*NOTE: There were 48169 observations read from the data set WORK.PPI_PB_115.
NOTE: There were 54609 observations read from the data set WORK.PPI_PB_116.
NOTE: There were 87604 observations read from the data set WORK.PPI_PB_117.
NOTE: There were 51552 observations read from the data set WORK.PPI_PB_118.
NOTE: There were 49210 observations read from the data set WORK.PPI_PB_119.
NOTE: There were 99440 observations read from the data set WORK.PPI_PB_120.
NOTE: There were 49533 observations read from the data set WORK.PPI_PB_121.
NOTE: There were 53882 observations read from the data set WORK.PPI_PB_122.
NOTE: There were 97838 observations read from the data set WORK.PPI_PB_123.
NOTE: There were 49318 observations read from the data set WORK.PPI_PB_124.
NOTE: There were 55149 observations read from the data set WORK.PPI_PB_125.
NOTE: There were 50645 observations read from the data set WORK.PPI_PB_126.
NOTE: There were 54229 observations read from the data set WORK.PPI_PB_127.
NOTE: There were 49864 observations read from the data set WORK.PPI_PB_128.
NOTE: There were 51749 observations read from the data set WORK.PPI_PB_129.
NOTE: There were 48548 observations read from the data set WORK.PPI_PB_130.
NOTE: There were 57384 observations read from the data set WORK.PPI_PB_131.
NOTE: There were 53551 observations read from the data set WORK.PPI_PB_132.
NOTE: There were 52238 observations read from the data set WORK.PPI_PB_133.
NOTE: There were 53791 observations read from the data set WORK.PPI_PB_134.
NOTE: There were 59472 observations read from the data set WORK.PPI_PB_135.
NOTE: There were 59372 observations read from the data set WORK.PPI_PB_136.
NOTE: There were 63639 observations read from the data set WORK.PPI_PB_137.
NOTE: There were 54483 observations read from the data set WORK.PPI_PB_138.
NOTE: There were 54651 observations read from the data set WORK.PPI_PB_139.
NOTE: There were 59207 observations read from the data set WORK.PPI_PB_140.
NOTE: There were 63043 observations read from the data set WORK.PPI_PB_141.
NOTE: There were 61000 observations read from the data set WORK.PPI_PB_142.
NOTE: There were 57278 observations read from the data set WORK.PPI_PB_143.
NOTE: There were 56431 observations read from the data set WORK.PPI_PB_144.
NOTE: There were 64873 observations read from the data set WORK.PPI_PB_145.
NOTE: There were 55510 observations read from the data set WORK.PPI_PB_146.
NOTE: There were 61986 observations read from the data set WORK.PPI_PB_147.
NOTE: There were 57888 observations read from the data set WORK.PPI_PB_148.
NOTE: There were 64840 observations read from the data set WORK.PPI_PB_149.
NOTE: There were 59850 observations read from the data set WORK.PPI_PB_150.
NOTE: There were 59928 observations read from the data set WORK.PPI_PB_151.
NOTE: There were 58730 observations read from the data set WORK.PPI_PB_152.
NOTE: There were 63648 observations read from the data set WORK.PPI_PB_153.
NOTE: There were 56980 observations read from the data set WORK.PPI_PB_154.
NOTE: There were 67569 observations read from the data set WORK.PPI_PB_155.
NOTE: There were 60316 observations read from the data set WORK.PPI_PB_156.
NOTE: There were 60350 observations read from the data set WORK.PPI_PB_157.
NOTE: There were 65753 observations read from the data set WORK.PPI_PB_158.
NOTE: There were 69654 observations read from the data set WORK.PPI_PB_159.
NOTE: The data set P.PPI_PB_1314 has 2684754 observations and 26 variables.;

proc freq data=p.ppi_pb_0312;
table Type_of_Patient__Drug_;run;
data p.ppi_pb_0312op;
set p.ppi_pb_0312;
if Type_of_Patient__Drug_="O";
run; *1586671;
proc sort data=p.ppi_pb_0312op nodupkey out=hc;
by reference_key;run; *303295;
data pp.ppi_allrefkey;
set pp.ppi_rest3 pp.ppi_rest2 pp.hc; 
run; *216458;

*for pp.ppi_rest3, refkey file=new_coh_6
for pp.ppi_rest2, refkey file=new_coh1-5
for pp.hc, refkey file=coh_1-16;
data pp.ppi_allrefkey;
set pp.ppi_allrefkey;
if reference_key_~=. then reference_key=reference_key_;run;
data a;set pp.ppi_allrefkey;if missing(reference_key);run; *0;

*try to retrieve all other data for the rest cohorts identified from Patient based;
proc sql;
create table p.ppi_pb_refkey as
select * from p.ppi_pb_0312op where reference_key not in (Select reference_key from pp.ppi_allrefkey);
quit;
proc sort data=p.ppi_pb_refkey nodupkey;
by reference_key;run; *87620;
data p.ppi_pb_refkey;set p.ppi_pb_refkey;n=_n_;run;
data p.ppi_pb_refkey;
set p.ppi_pb_refkey;
if 1<=n<=10000 then file=1;
if 10001<=n<=20000 then file=2;
if 20001<=n<=30000 then file=3;
if 30001<=n<=40000 then file=4;
if 40001<=n<=50000 then file=5;
if 50001<=n<=60000 then file=6;
if 60001<=n<=70000 then file=7;
if 70001<=n<=87620 then file=8;
run;
%macro export;
%do i=1 %to 8;
data hc&i.;
set p.ppi_pb_refkey;
if file=&i. then output hc&i.;
keep reference_key;
run;
%end;
%mend;
%export;
%macro export;
%do i=1 %to 8;
PROC EXPORT DATA= WORK.hc&i.
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\PB_coh_&i..txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=No;
RUN;
%end;
%mend;
%export;

/*Update data: For PB_PPI from 2013-2014 */
proc freq data=p.ppi_pb_1314;
table Type_of_Patient__Drug_;run;
data p.ppi_pb_1314op;
set p.ppi_pb_1314;
if Type_of_Patient__Drug_="O";
run; *755183;
proc sort data=p.ppi_pb_1314op nodupkey out=p.ppi_1314_refkey;
by reference_key;run; *190020, i used this adding 303295 for BHF grant without removing duplicates
so calculated as 493315;
proc sql;
create table p.ppi1314_rest as
select * from p.ppi_1314_refkey where reference_key not in (select reference_key from p.ppi_pb_0312op);
quit; *101845;
data p.ppi1314_rest;set p.ppi1314_rest;n=_n_;keep reference_key n;run;
data p.ppi1314_rest;
set p.ppi1314_rest;
if 1<=n<=10000 then file=1;
if 10001<=n<=20000 then file=2;
if 20001<=n<=30000 then file=3;
if 30001<=n<=40000 then file=4;
if 40001<=n<=50000 then file=5;
if 50001<=n<=60000 then file=6;
if 60001<=n<=70000 then file=7;
if 70001<=n<=80000 then file=8;
if 80001<=n<=90000 then file=9;
if 90001<=n<=101845 then file=10;
run;
%macro export;
%do i=1 %to 10;
data hc&i.;
set p.ppi1314_rest;
if file=&i. then output hc&i.;
keep reference_key;
run;
%end;
%mend;
%export;
%macro export;
%do i=1 %to 10;
PROC EXPORT DATA= WORK.hc&i.
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\ppiPB1314_&i..txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=No;
RUN;
%end;
%mend;
%export;

data p.ppi_pb_0314op;
set p.ppi_pb_0312op p.ppi_pb_1314op;
run;

/* for case-time-control to take the LC datas*/
proc sql;
create table lc_rest as
select * from p.ppi_pb_0314op where reference_key not in (select VAR1 from rk.mistroke_txt);
quit; *1629889;
proc sort data=lc_rest nodupkey;
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
