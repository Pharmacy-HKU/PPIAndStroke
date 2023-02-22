libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname an "C:\Users\Angel YS Wong\Desktop\PPI\program\drug";
libname pp "C:\Users\Angel YS Wong\Desktop\PPI\program\additional analysis";


libname an "F:\HK PhD project\PPI\program\drug";
libname dx "F:\HK PhD project\PPI\program\dx";

PROC EXPORT DATA= an.alldrug9314
            OUTFILE= "H:\Desktop\PPI\alldrug9314.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;

PROC EXPORT DATA= dx.dx_all9315jj
            OUTFILE= "H:\Desktop\PPI\dx_all9315jj.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;


*check patients on nitrates/CCB/beta blockers;
proc sql;
create table p.ppimi_nitrate as
select * from an.alldrug9314 where 
Therapeutic_Classification__BNF_ like '2.6.1'
or drug_name like 'ANGISED %' or drug_name like 'DEPONIT %' or drug_name like 'NITRO POHL %' or drug_name like 'NITROCINE %' or drug_name like 'NITRODERM %' or drug_name like 'NITRO MACK RETARD %' 
or drug_name like 'APO-ISDN %' or drug_name like 'APOISDN %' or drug_name like 'APO ISDN %' or drug_name like 'ISOKET %' or drug_name like 'ISORDE %' or drug_name like 'SORBIDIN %' 
or drug_name like 'APO-ISMN %' or drug_name like 'APOISMN %' or drug_name like 'APO ISMN %' or drug_name like 'COXINE %' or drug_name like 'DURIDE %' or drug_name like 'ELANTAN %' or drug_name like 'IMDEX %' or drug_name like 'IMDUR %' or drug_name like 'MOHERO %' or drug_name like 'MONOCINQUE RETARD %' or drug_name like 'MONOSORDIL %' or drug_name like 'SORBIMON %'
or drug_name like '%TRINITRATE%'
or drug_name like '%DINITRATE%'
or drug_name like '%MONONITRATE%'
or drug_name like '%NITRO MACK%';
quit;
proc freq data=p.ppimi_nitrate;
table drug_name;
run;
proc sql;
delete from p.ppimi_nitrate where drug_name like '%ACERTIL%';
quit; *1 deleted; 

proc sql;
create table p.ppimi_betablocker as
select * from an.alldrug9314 where
Therapeutic_Classification__BNF_ like '2.4'
or drug_name like 'ALONET %' or drug_name like 'ALONET %' or drug_name like 'APO-ATENOL %' or drug_name like 'APOATENOL %' or drug_name like 'APO ATENOL %'  or drug_name like 'ARTENOL %' or drug_name like 'ATENOL %' or drug_name like 'ATEOL %' or drug_name like 'BETEN %' or drug_name like 'DEMITENS %' or drug_name like 'HYPERNOL %' or drug_name like 'INTERNOLOL %' or drug_name like 'MARTENOL %' or drug_name like 'NORMATEN %' or drug_name like 'NORTELOL %' or drug_name like 'NOTEN %' or drug_name like 'SANTOL %' or drug_name like 'SEDAMIN %' or drug_name like 'SITENOL %' or drug_name like 'TELOL %' or drug_name like 'TEN-BLOKA %' or drug_name like 'TENBLOKA %' or drug_name like 'TEN BLOKA %'   or drug_name like 'TENOCARD %' or drug_name like 'TENOREN %' or drug_name like 'TENORMIN %' or drug_name like 'TENPRESS %' or drug_name like 'TENSIG %' or drug_name like 'TERNOLOL %' or drug_name like 'TOLMIN %' or drug_name like 'TOTAMOL %' or drug_name like 'TREDOL %' or drug_name like 'UROSIN %' or drug_name like 'VASCOTEN %'
or drug_name like 'TENCHLOR %' or drug_name like 'TENORET %' or drug_name like 'TENORETIC %'
or drug_name like 'NIF-TEN %' or drug_name like 'NIF TEN %' or drug_name like 'NIFTEN %'
or drug_name like 'CONCOR %'
or drug_name like 'LODOZ %'
or drug_name like 'CARDILO %' or drug_name like 'DILATREND %' or drug_name like 'SYNTREND %' or drug_name like 'TALLITON %'
or drug_name like 'SELECTOL %' 
or drug_name like 'BREVIBLOC %'
or drug_name like 'TRANDATE %'
or drug_name like 'BETALOC %' or drug_name like 'CARTALOC %' or drug_name like 'CP-METOLOL %' or drug_name like 'CPMETOLOL %' or drug_name like 'CP METOLOL %'  or drug_name like 'DENEX %' or drug_name like 'METLOL %' or drug_name like 'MINAX %'
or drug_name like 'LOGIMAX %'
or drug_name like 'APO-NADOL %' or drug_name like 'APONADOL %' or drug_name like 'APO NADOL %'
or drug_name like 'NEBILET %'
or drug_name like 'CORBETON %'
or drug_name like 'VISKEN %'
or drug_name like 'BECARDIN %' or drug_name like 'BETAPRESS %' or drug_name like 'DERALIN %' or drug_name like 'INDERAL %' or drug_name like 'INPANOL %' or drug_name like 'PRALOL %' or drug_name like 'PROLOL %' or drug_name like 'PROPA %' or drug_name like 'QUALIPANOL %' or drug_name like 'SYNOLOL %' or drug_name like 'UNI-PANOLOL %' or drug_name like 'UNIPANOLOL %' or drug_name like 'UNI PANOLOL %'
or drug_name like 'APO-SOTALOL %' or drug_name like 'APOSOTALOL %' or drug_name like 'APO SOTALOL %'
or drug_name like '%ACEBUTOLOL%' or drug_name like '%ATENOLOL%'
or drug_name like '%BISOPROLOL%' or drug_name like '%CARVEDILOL%'
or drug_name like '%CELIPROLOL%' or drug_name like '%ESMOLOL%'
or drug_name like '%LABETALOL%' or drug_name like '%METOPROLOL%'
or drug_name like '%NADOLOL%' or drug_name like '%NEBIVOLOL%'
or drug_name like '%OXPRENOLOL%' or drug_name like '%PINDOLOL%'
or drug_name like '%PROPRANOLOL%' or drug_name like '%SOTALOL%';
quit;
proc freq data=p.ppimi_betablocker;
table drug_name;
run;

proc sql;
create table p.ppimi_ccb as
select * from an.alldrug9314 where 
Therapeutic_Classification__BNF_ like '2.6.2'
or drug_name like 'A-PHINE %' or drug_name like 'A PHINE %' or drug_name like 'APHINE %' 
or drug_name like 'ACTAPIN %' or drug_name like 'ALOPINE %' or drug_name like 'AMCOPINE %' 
or drug_name like 'AMDOCAL %' or drug_name like 'AMDOL %' or drug_name like 'AMEDIN %' 
or drug_name like 'AMLO-DENK %' or drug_name like 'AMLO DENK %' or drug_name like 'AMLODENK %' 
or drug_name like 'AMLOBIN %' or drug_name like 'AMLOD %' or drug_name like 'AMLODIGAMMA %' 
or drug_name like 'AMLODIPIN  STADA %' or drug_name like 'AMLODIPINA FARMOZ %' 
or drug_name like 'AMLOGARD %' or drug_name like 'AMLONG %' or drug_name like 'AMLONIP %' 
or drug_name like 'AMLOPIN %' or drug_name like 'AMLOPRES %' or drug_name like 'AMLORIGHT %' 
or drug_name like 'AMLORINE %' or drug_name like 'AMLOTEN %' or drug_name like 'AMLOTENS %' 
or drug_name like 'AMLOVAS %' or drug_name like 'AMLOZEN %' or drug_name like 'AMNDILINE %' 
or drug_name like 'AMODEP %' or drug_name like 'AMOSARC %' or drug_name like 'AMPIN %' 
or drug_name like 'AMTAS %' or drug_name like 'AMVAS %' or drug_name like 'CARDIPIN %' 
or drug_name like 'CP-LOVAC %' or drug_name like 'CP LOVAC %' or drug_name like 'CPLOVAC %' 
or drug_name like 'DEROX %' or drug_name like 'EMLIP %' or drug_name like 'HOVASC %' 
or drug_name like 'HYPRESS %' or drug_name like 'INTERVASK %' or drug_name like 'LODIPINE %' 
or drug_name like 'LOFRAL %' or drug_name like 'LOMAKLINE %' or drug_name like 'LOPICARD %' 
or drug_name like 'NORVASC %' or drug_name like 'OMSANZOL %' or drug_name like 'STADOVAS %' 
or drug_name like 'STAMLO %' or drug_name like 'TOPDIP %' or drug_name like 'UNASC %' 
or drug_name like 'ZYNOR %'
or drug_name like 'CADUET %' or drug_name like 'CODUWON %'
or drug_name like 'AZOREN %'
or drug_name like 'ACERYCAL %'
or drug_name like 'TWYNSTA %'
or drug_name like 'EXFORGE %'
or drug_name like 'ALTIAZEM %' or drug_name like 'APO-DILTIAZ %' or drug_name like 'APO DILTIAZ %' or drug_name like 'APODILTIAZ %' or drug_name like 'CARTIL %' or drug_name like 'DILEM %' or drug_name like 'DILZEM %' or drug_name like 'HERBESSER %' or drug_name like 'MESSER %' or drug_name like 'WONTIZEM RETARD %'
or drug_name like 'CERATEN %' or drug_name like 'FEDISYN %' or drug_name like 'FELO %' or drug_name like 'FELODIN RETARD %' or drug_name like 'FELOGARD %' or drug_name like 'FELOSTAD /FELPIN %' or drug_name like 'FELUTAM %' or drug_name like 'HIDIPINE %' or drug_name like 'PLENDIL %' or drug_name like 'STAPIN %'
or drug_name like 'LOGIMAX %'
or drug_name like 'LACIPIL %' or drug_name like 'LASYN %'
or drug_name like 'ZANIDIP %'
or drug_name like 'ZANIPRESS %'
or drug_name like 'ADALAT %' or drug_name like 'ALAT %' or drug_name like 'APO-NIFED %' 
or drug_name like 'APO NIFED %' or drug_name like 'APONIFED %' or drug_name like 'CARDITAS RETARD %' 
or drug_name like 'CORDIPIN RETARD %' or drug_name like 'FENAMON %' or drug_name like 'NIFECARD %' 
or drug_name like 'NIFEDI-DENK %' or drug_name like 'NIFEDI DENK %' or drug_name like 'NIFEDIDENK %' 
or drug_name like 'NIFEDIPIN %' or drug_name like 'NIFELAT RETARD %' or drug_name like 'VASDALAT RETARD %'
or drug_name like 'NIF-TEN %' or drug_name like 'NIF TEN %' or drug_name like 'NIFTEN %'
or drug_name like 'NIMOTOP %'
or drug_name like 'AKILEN %' or drug_name like 'ANPEC %' or drug_name like 'APO-VERAP %' 
or drug_name like 'APO VERAP %' or drug_name like 'APOVERAP %' or drug_name like 'CINTSU SRFC %' 
or drug_name like 'ISOPTIN %' or drug_name like 'VASOMIL %'
or drug_name like 'TARKA %'
or drug_name like '%AMLODIPINE%'
or drug_name like '%DILTIAZEM%' 
or drug_name like '%FELODIPINE%' 
or drug_name like '%ISRADIPINE%' 
or drug_name like '%LACIDIPINE%' 
or drug_name like '%LERCANIDIPINE%' 
or drug_name like '%NICARDIPINE%' 
or drug_name like '%NIFEDIPINE%' 
or drug_name like '%NIMODIPINE%' 
or drug_name like '%VERAPAMIL%';
quit;
proc freq data=p.ppimi_ccb;
table drug_name;
run;
proc sql;
delete from p.ppimi_ccb where drug_name like '%STUDY%';
quit; *2 deleted; 
proc sql;
create table p.ppimi_otherantiangina as
select * from an.alldrug9314 where 
Therapeutic_Classification__BNF_ like '2.6.3'
or drug_name like '%IVABRADINE%'
or drug_name like '%NICORANDIL%'
or drug_name like '%RANOLAZINE%';
quit;
proc freq data=p.ppimi_otherantiangina;
table drug_name;
run;
proc sql;
delete from p.ppimi_otherantiangina where drug_name like '%PLACEBO%';
quit; *24 deleted; 

data antiangina;
set p.ppimi_otherantiangina p.ppimi_ccb p.ppimi_betablocker p.ppimi_nitrate;
run;
data antiangina;
set antiangina;
anti_rxst=input(Prescription_Start_Date, yymmdd10.);
anti_rxen=input(Prescription_End_Date, yymmdd10.);
format anti_rxst anti_rxen yymmdd10.;
run;

/*antiangina medications just started with PPIs*/
proc sql;
create table primary_risk_final as
select * from p.primary_risk_final A left join (select anti_rxst, anti_rxen from antiangina B)
on A.reference_key=B.reference_key;
quit;
data primary_risk_final;
set primary_risk_final;
if anti_rxst=pst and r=2 then anti_angina=1;
else anti_angina=0;
run;
data a;
set primary_risk_final;
if anti_angina=1;
drop event;run;
proc sort data=a nodupkey;
by reference_key;
run; *606;
data a;
set a;
if pst<=eventd<=pen then event=1;
else event=0;run;
proc freq data=a;
table event;run; 
*24, for those risk period is 14 days post-exposure
and has event during these 14 days and having anti-angina initiated with PPIs;

*exclude 606 patients;
proc sql;
create table excl as
select * from poisson2 where indiv not in (select reference_key from a);
quit;
PROC EXPORT DATA= excl
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\SAS export for R\manuscript\excl_primary_risk_final.txt" 
            DBMS=DLM REPLACE;
     PUTNAMES=NO;
RUN;
proc sort data=excl nodupkey out=a;
by indiv;run;
/*check the baseline characteristerics of short-term use and regardless of prescription duration*/
proc sort data=p.ppi_mi_coh1_adult;
by reference_key ppirxst;
run;
proc sort data=p.ppi_mi_coh1_adult nodupkey out=hc;
by reference_key;
run; *1506;

data dx_all9315jj;
set dx.dx_all9315jj;
rd=input(reference_date, yymmdd10.);
format rd yymmdd10.;
run;

/*COPD*/
proc sql;
create table copd as
select * from dx_all9315jj where All_Diagnosis_Code__ICD9_ like '490%'
or All_Diagnosis_Code__ICD9_ like '491%'
or All_Diagnosis_Code__ICD9_ like '492%'
or All_Diagnosis_Code__ICD9_ like '494%'
or All_Diagnosis_Code__ICD9_ like '496%';
quit; *244085;
proc sql;
create table copd as
select *, min(rd) as min_rd format yymmdd10. from copd group by reference_key;
quit;
/*obesity*/
proc sql;
create table obesity as
select * from dx_all9315jj where All_Diagnosis_Code__ICD9_ like '278.0%';
quit; *10954;
proc sql;
create table obesity as
select *, min(rd) as min_rd format yymmdd10. from obesity group by reference_key;
quit;
/*diabetes*/
proc sql;
create table dm as
select * from dx_all9315jj where All_Diagnosis_Code__ICD9_ like '249%'
or All_Diagnosis_Code__ICD9_ like '250%';
quit; *595370;
proc sql;
create table dm as
select *, min(rd) as min_rd format yymmdd10. from dm group by reference_key;
quit;
/*Hypertensive disease*/
proc sql;
create table hypertensive as
select * from dx_all9315jj where All_Diagnosis_Code__ICD9_ like '401%'
or All_Diagnosis_Code__ICD9_ like '402%'
or All_Diagnosis_Code__ICD9_ like '403%'
or All_Diagnosis_Code__ICD9_ like '404%'
or All_Diagnosis_Code__ICD9_ like '405%';
quit;
proc sql;
create table hypertensive as
select *, min(rd) as min_rd format yymmdd10. from hypertensive group by reference_key;
quit;
/*CHD*/
proc sql;
create table chd as
select * from dx_all9315jj where All_Diagnosis_Code__ICD9_ like '410%'
or All_Diagnosis_Code__ICD9_ like '411%'
or All_Diagnosis_Code__ICD9_ like '412%'
or All_Diagnosis_Code__ICD9_ like '413%'
or All_Diagnosis_Code__ICD9_ like '414%'
or All_Diagnosis_Code__ICD9_ like '429.71%'
or All_Diagnosis_Code__ICD9_ like '429.79%';
quit; *500195;
proc sql;
create table chd as
select *, min(rd) as min_rd format yymmdd10. from chd group by reference_key;
quit;
/*CHD excluding MI*/
proc sql;
create table chd_wo_mi as
select * from dx_all9315jj where All_Diagnosis_Code__ICD9_ like '411%'
or All_Diagnosis_Code__ICD9_ like '413%'
or All_Diagnosis_Code__ICD9_ like '414%'
or All_Diagnosis_Code__ICD9_ like '429.71%'
or All_Diagnosis_Code__ICD9_ like '429.79%';
quit; *500195;
proc sql;
create table chd_wo_mi as
select *, min(rd) as min_rd format yymmdd10. from chd_wo_mi group by reference_key;
quit;
/*Heart failure*/
proc sql;
create table hf as
select * from dx_all9315jj where All_Diagnosis_Code__ICD9_ like '402.01%'
or All_Diagnosis_Code__ICD9_ like '402.11%'
or All_Diagnosis_Code__ICD9_ like '402.91%'
or All_Diagnosis_Code__ICD9_ like '404.01%'
or All_Diagnosis_Code__ICD9_ like '404.03%'
or All_Diagnosis_Code__ICD9_ like '404.11%'
or All_Diagnosis_Code__ICD9_ like '404.13%'
or All_Diagnosis_Code__ICD9_ like '404.91%'
or All_Diagnosis_Code__ICD9_ like '404.93%'
or All_Diagnosis_Code__ICD9_ like '428%';
quit; *300673;
proc sql;
create table hf as
select *, min(rd) as min_rd format yymmdd10. from hf group by reference_key;
quit;

data a;
set hc;
if missing(ppirxst);run; *0;
*short-term Rxs;
proc sql;
create table mi_copd as
select * from hc A left join (select min_rd from copd B)
on A.reference_key=B.reference_key;
quit;
data mi_copd;
set mi_copd;
if ~missing(min_rd) and min_rd<ppirxst then copd=1;
else copd=0;
if ~missing(min_rd) and min_rd<st_st then copd_hx=1;
else copd_hx=0;
if ~missing(min_rd) and min_rd<ppirxst+60-1 then copd_end=1;
else copd_end=0;
drop min_rd;
run;
proc sort data=mi_copd;
by reference_key decending copd decending copd_hx decending copd_end;
run;
proc sort data=mi_copd nodupkey;
by reference_key;run;

proc sql;
create table mi_obesity as
select * from mi_copd A left join (select min_rd from obesity B)
on A.reference_key=B.reference_key;
quit;
data mi_obesity;
set mi_obesity;
if ~missing(min_rd) and min_rd<ppirxst then obesity=1;
else obesity=0;
if ~missing(min_rd) and min_rd<st_st then obesity_hx=1;
else obesity_hx=0;
if ~missing(min_rd) and min_rd<ppirxst+60-1 then obesity_end=1;
else obesity_end=0;
drop min_rd;
run;
proc sort data=mi_obesity;
by reference_key decending obesity decending obesity_hx decending obesity_end;
run;
proc sort data=mi_obesity nodupkey;
by reference_key;run;

proc sql;
create table mi_dm as
select * from mi_obesity A left join (select min_rd from dm B)
on A.reference_key=B.reference_key;
quit;
data mi_dm;
set mi_dm;
if ~missing(min_rd) and min_rd<ppirxst then dm=1;
else dm=0;
if ~missing(min_rd) and min_rd<st_st then dm_hx=1;
else dm_hx=0;
if ~missing(min_rd) and min_rd<ppirxst+60-1 then dm_end=1;
else dm_end=0;
drop min_rd;
run;
proc sort data=mi_dm;
by reference_key decending dm decending dm_hx decending dm_end;
run;
proc sort data=mi_dm nodupkey;
by reference_key;run;

proc sql;
create table mi_hypertensive as
select * from mi_dm A left join (select min_rd from hypertensive B)
on A.reference_key=B.reference_key;
quit;
data mi_hypertensive;
set mi_hypertensive;
if ~missing(min_rd) and min_rd<ppirxst then hypertensive=1;
else hypertensive=0;
if ~missing(min_rd) and min_rd<st_st then hypertensive_hx=1;
else hypertensive_hx=0;
if ~missing(min_rd) and min_rd<ppirxst+60-1 then hypertensive_end=1;
else hypertensive_end=0;
drop min_rd;
run;
proc sort data=mi_hypertensive;
by reference_key decending hypertensive decending hypertensive_hx decending hypertensive_end;
run;
proc sort data=mi_hypertensive nodupkey;
by reference_key;run;

proc sql;
create table mi_hf as
select * from mi_hypertensive A left join (select min_rd from hf B)
on A.reference_key=B.reference_key;
quit;
data mi_hf;
set mi_hf;
if ~missing(min_rd) and min_rd<ppirxst then hf=1;
else hf=0;
if ~missing(min_rd) and min_rd<st_st then hf_hx=1;
else hf_hx=0;
if ~missing(min_rd) and min_rd<ppirxst+60-1 then hf_end=1;
else hf_end=0;
drop min_rd;
run;
proc sort data=mi_hf;
by reference_key decending hf decending hf_hx decending hf_end;
run;
proc sort data=mi_hf nodupkey;
by reference_key;run;

proc sql;
create table mi_chd_womi as
select * from mi_hf A left join (select min_rd from chd_wo_mi B)
on A.reference_key=B.reference_key;
quit;
data mi_chd_womi;
set mi_chd_womi;
if ~missing(min_rd) and min_rd<ppirxst then chd_wo_mi=1;
else chd_wo_mi=0;
if ~missing(min_rd) and min_rd<st_st then chd_wo_mi_hx=1;
else chd_wo_mi_hx=0;
if ~missing(min_rd) and min_rd<ppirxst+60-1 then chd_wo_mi_end=1;
else chd_wo_mi_end=0;
drop min_rd;
run;
proc sort data=mi_chd_womi;
by reference_key decending chd_wo_mi decending chd_wo_mi_hx decending chd_wo_mi_end;
run;
proc sort data=mi_chd_womi nodupkey;
by reference_key;run;
proc freq data=mi_chd_womi;
table copd obesity dm hypertensive hf copd_hx obesity_hx dm_hx hypertensive_hx hf_hx
copd_end obesity_end dm_end hypertensive_end hf_end chd_wo_mi chd_wo_mi_hx chd_wo_mi_end;
run;


/*all Rxs*/
proc sort data=pp.ppi_mi_coh1_adult;
by reference_key ppirxst;
run;
proc sort data=pp.ppi_mi_coh1_adult nodupkey out=allppi_hc;
by reference_key;run; *3013;

data a;
set allppi_hc;
if missing(ppirxst);run; *0;
proc sql;
create table mi_copd as
select * from allppi_hc A left join (select min_rd from copd B)
on A.reference_key=B.reference_key;
quit;
data mi_copd;
set mi_copd;
if ~missing(min_rd) and min_rd<ppirxst then copd=1;
else copd=0;
if ~missing(min_rd) and min_rd<st_st then copd_hx=1;
else copd_hx=0;
if ~missing(min_rd) and min_rd<ppirxst+60-1 then copd_end=1;
else copd_end=0;
drop min_rd;
run;
proc sort data=mi_copd;
by reference_key decending copd decending copd_hx decending copd_end;
run;
proc sort data=mi_copd nodupkey;
by reference_key;run;

proc sql;
create table mi_obesity as
select * from mi_copd A left join (select min_rd from obesity B)
on A.reference_key=B.reference_key;
quit;
data mi_obesity;
set mi_obesity;
if ~missing(min_rd) and min_rd<ppirxst then obesity=1;
else obesity=0;
if ~missing(min_rd) and min_rd<st_st then obesity_hx=1;
else obesity_hx=0;
if ~missing(min_rd) and min_rd<ppirxst+60-1 then obesity_end=1;
else obesity_end=0;
drop min_rd;
run;
proc sort data=mi_obesity;
by reference_key decending obesity decending obesity_hx decending obesity_end;
run;
proc sort data=mi_obesity nodupkey;
by reference_key;run;

proc sql;
create table mi_dm as
select * from mi_obesity A left join (select min_rd from dm B)
on A.reference_key=B.reference_key;
quit;
data mi_dm;
set mi_dm;
if ~missing(min_rd) and min_rd<ppirxst then dm=1;
else dm=0;
if ~missing(min_rd) and min_rd<st_st then dm_hx=1;
else dm_hx=0;
if ~missing(min_rd) and min_rd<ppirxst+60-1 then dm_end=1;
else dm_end=0;
drop min_rd;
run;
proc sort data=mi_dm;
by reference_key decending dm decending dm_hx decending dm_end;
run;
proc sort data=mi_dm nodupkey;
by reference_key;run;

proc sql;
create table mi_hypertensive as
select * from mi_dm A left join (select min_rd from hypertensive B)
on A.reference_key=B.reference_key;
quit;
data mi_hypertensive;
set mi_hypertensive;
if ~missing(min_rd) and min_rd<ppirxst then hypertensive=1;
else hypertensive=0;
if ~missing(min_rd) and min_rd<st_st then hypertensive_hx=1;
else hypertensive_hx=0;
if ~missing(min_rd) and min_rd<ppirxst+60-1 then hypertensive_end=1;
else hypertensive_end=0;
drop min_rd;
run;
proc sort data=mi_hypertensive;
by reference_key decending hypertensive decending hypertensive_hx decending hypertensive_end;
run;
proc sort data=mi_hypertensive nodupkey;
by reference_key;run;

proc sql;
create table mi_hf_allrx as
select * from mi_hypertensive A left join (select min_rd from hf B)
on A.reference_key=B.reference_key;
quit;
data mi_hf_allrx;
set mi_hf_allrx;
if ~missing(min_rd) and min_rd<ppirxst then hf=1;
else hf=0;
if ~missing(min_rd) and min_rd<st_st then hf_hx=1;
else hf_hx=0;
if ~missing(min_rd) and min_rd<ppirxst+60-1 then hf_end=1;
else hf_end=0;
drop min_rd;
run;
proc sort data=mi_hf_allrx;
by reference_key decending hf decending hf_hx decending hf_end;
run;
proc sort data=mi_hf_allrx nodupkey;
by reference_key;run;

proc sql;
create table mi_chd_womi_allrx as
select * from mi_hf_allrx A left join (select min_rd from chd_wo_mi B)
on A.reference_key=B.reference_key;
quit;
data mi_chd_womi_allrx;
set mi_chd_womi_allrx;
if ~missing(min_rd) and min_rd<ppirxst then chd_wo_mi=1;
else chd_wo_mi=0;
if ~missing(min_rd) and min_rd<st_st then chd_wo_mi_hx=1;
else chd_wo_mi_hx=0;
if ~missing(min_rd) and min_rd<ppirxst+60-1 then chd_wo_mi_end=1;
else chd_wo_mi_end=0;
drop min_rd;
run;
proc sort data=mi_chd_womi_allrx;
by reference_key decending chd_wo_mi decending chd_wo_mi_hx decending chd_wo_mi_end;
run;
proc sort data=mi_chd_womi_allrx nodupkey;
by reference_key;run;
proc freq data=mi_chd_womi_allrx;
table copd obesity dm hypertensive chd_wo_mi hf copd_hx obesity_hx dm_hx hypertensive_hx hf_hx
copd_end obesity_end dm_end hypertensive_end hf_end chd_wo_mi_hx chd_wo_mi_end;
run;
