/*Created from SCCS_multi_periods on 4 July 2016

Updated on 11 July, 2016
further updated on 14 July, 2016
further updated on 20 July, 2016: by separating NSAIDS for two groups
further updated on 21 July, 2016: after re-calculating NSAIDS duration
further updated on 14 July, 2016: to use outpatient of NSAIDS and clarith only
further updated on 15 July, 2016: change the program for combine risk windows

cut OP PPIs risk periods:
prerisk 14 days
1-14
15-30
31-60

also cut age group 1 year for each interval

*if risk periods for each prescriptions overlap, favor pre-risk period

multiple exposure:
during treatment, mark 1, otherwise mark 0

*checking how many patients on antiplatelet/anticoagulants while on PPIs with MI during current use (day 1-60)*/

libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname an "C:\Users\Angel YS Wong\Desktop\PPI\program\drug";
libname lc "C:\Users\Angel YS Wong\Desktop\PPI\program\lc";

/*************************************
*************************************
*************************************
*************************************
*************************************
multiple exposures
1. clarithromycin
2. NSAIDS
*************************************
*************************************
*************************************
**************************************/

/* clarithromycin */
proc sql;
create table an.clarith as
select * from an.alldrug9314 where drug_name like '%CLARITHRO%'
or drug_item_code like 'CLAR%';
quit; *74037;
proc freq data=an.clarith;
table drug_name;run;
data an.clarith;
set an.clarith;
if substr(drug_name,1,9)='AUGMENTIN'
or substr(drug_name,1,9)='CLARINASE' then delete;run; *71240;
data an.clarith;
set an.clarith;
rxst=input(prescription_start_date, yymmdd10.);
rxen=input(Prescription_End_Date, yymmdd10.);
dur=rxen-rxst+1;
format rxst rxen yymmdd10.;
run;

/*check any prescription duration <0*/
data a;
set an.clarith;
if ~missing(dur) and dur<0;
run; *0;
/*adding rxst and rxen to missing ones from Quantity__Named_Patient_/cl_ndd/cl_dosage
otherwise, impute the median days*/
proc sql;
create table an.clarith_ppimi as
select * from an.clarith where reference_key in (select reference_key from p.ppi_mi_coh1_adult);
quit; *1226;
data clarith_miss;
set an.clarith_ppimi;
if missing(prescription_start_date) or missing(Prescription_End_Date);run;
proc freq data=clarith_miss;
table Dosage;run;
data an.clarith_ppimi;
set an.clarith_ppimi;
if substr(Dosage,1,2)="1 " then cl_dosage=1;
if substr(Dosage,1,2)="2 " then cl_dosage=2;
run;
proc freq data=clarith_miss;
table Drug_Frequency;run;
data an.clarith_ppimi;
set an.clarith_ppimi;
if substr(Drug_Frequency,1,2)="AT" then cl_ndd=1;
if substr(Drug_Frequency,1,3)="DAI" then cl_ndd=1;
if substr(Drug_Frequency,1,10)="EVERY TWEL" then cl_ndd=2;
if substr(Drug_Frequency,1,4)="FOUR" then cl_ndd=4;
if substr(Drug_Frequency,1,4)="ONCE" then cl_ndd=1;
if substr(Drug_Frequency,1,3)="THR" then cl_ndd=3;
if substr(Drug_Frequency,1,5)="TWICE" then cl_ndd=2; run;
data an.clarith_ppimi;
set an.clarith_ppimi;
if missing(Prescription_Start_Date) then 
rxst=input(Dispensing_Date__yyyy_mm_dd_, yymmdd10.);
format rxst yymmdd10.;
run;
data an.clarith_ppimi;
set an.clarith_ppimi;
if missing(Prescription_Start_Date) then dur=Quantity__Named_Patient_/cl_ndd/cl_dosage;
run;
data an.clarith_ppimi;
set an.clarith_ppimi;
if missing(Prescription_Start_Date) then rxen=rxst+dur-1; format rxen yymmdd10.;
run;
data no_miss;
set an.clarith_ppimi;
if ~missing(dur);run;
proc univariate data=no_miss;
var dur;run; *median 7 days, cause most of the IP prescriptions are in v short duration;
data an.clarith_ppimi;
set an.clarith_ppimi;
if missing(dur) then f_dur=7;
else f_dur=dur;run;
data an.clarith_ppimi;
set an.clarith_ppimi;
if missing(dur) then rxen=rxst+f_dur-1; format rxen yymmdd10.;
run;
data a;
set an.clarith_ppimi;
if missing(rxen);run; *0, after overlapping 821;
/*for saving record*/
data an.clarith_ppimi2;
set an.clarith_ppimi;
run; *1226;

/*NSAIDS*/
proc sql;
create table an.NSAIDS as
select * from an.alldrug9314 where Therapeutic_Classification__BNF_ like '10.1.1%' 
or drug_name like 'EMFLEX %'
or drug_name like 'CELCIB %' or drug_name like 'CELCOX %' or drug_name like 'CELEBREX %' or drug_name like 'COBIX %' or drug_name like 'FAVOCOX %' or drug_name like 'HICOXX %'
or drug_name like 'KETESSE %'
or drug_name like 'AFLAMIN %' or drug_name like 'APO-DICLO %' or drug_name like 'APODICLO %' or drug_name like 'APO DICLO %' or drug_name like 'ARTHAREN %' or drug_name like 'BRUDIC %' or drug_name like 'BRUDIC %' or drug_name like 'CLOFENEX %' or drug_name like 'DEFNIL %' or drug_name like 'DICLOGESIC %' or drug_name like 'DICLOCAIN %' or drug_name like 'DICLOFEN %' or drug_name like 'DIFENA %' or drug_name like 'DIVON %' or drug_name like 'DYNAPAR %' or drug_name like 'EUNAC %' or drug_name like 'FENAC %' or drug_name like 'FIP TONDONAC %' or drug_name like 'FLEFARMIN EMULGEL %' or drug_name like 'FORMIN %' or drug_name like 'HOULUONING %' or drug_name like 'ITAMI MEDICATED %' or drug_name like 'KOJAR-DICLOFEN %' or drug_name like 'KOJARDICLOFEN %' or drug_name like 'KOJAR DICLOFEN %'  or drug_name like 'NEO-CLOFEN %' or drug_name like 'NEOCLOFEN %' or drug_name like 'NEO CLOFEN %' or drug_name like 'OLFEN %' or drug_name like 'PANAMOR %' or drug_name like 'PARAFORTAN %' or drug_name like 'SAWTO %' or drug_name like 'SCANTAREN %' or drug_name like 'SHOREN %' or drug_name like 'TAPAIN %' or drug_name like 'TONDONAC %' or drug_name like 'UMERAN %' or drug_name like 'VICLOFENAC %' or drug_name like 'VIDACLOFEN %' or drug_name like 'VIGOLIN %' or drug_name like 'VOLTA %' or drug_name like 'VOLTAREN %' or drug_name like 'VOTALIN %' or drug_name like 'WEIDAREN %' or drug_name like 'XOEASE %' or drug_name like 'XTRA %' or drug_name like 'YUGOKIN %' or drug_name like 'ZOLASE %' or drug_name like 'ZUCON %'  
or drug_name like 'CATAFLAM %' or drug_name like 'DIFLAM %' or drug_name like 'LESFLAM %' or drug_name like 'VOLNA-K F.C. %' or drug_name like 'VOLNA K FC %' or drug_name like 'VOLNA-K FC %' or drug_name like 'VOLTAREN DOLO %' or drug_name like 'VOLTFAST %'
or drug_name like 'ETOLAC %' or drug_name like 'ETONOX %' or drug_name like 'LACCHIS %'
or drug_name like 'ARCOXIA %'
or drug_name like 'STREPFEN %'
or drug_name like 'ADVIL %' or drug_name like 'AMBUFEN %' or drug_name like 'ARFEN %' or drug_name like 'BIFEN %' or drug_name like 'BRUFEN %' or drug_name like 'BRUMED %' or drug_name like 'BRUPRON %' or drug_name like 'BUPOGESIC %' or drug_name like 'CUFENIN %' or drug_name like 'DOLO-SPEDIFEN %' or drug_name like 'DOLOSPEDIFEN %' or drug_name like 'DOLO SPEDIFEN %' or drug_name like 'EXTRAPAN %' or drug_name like 'FENBID FORTE %' or drug_name like 'FLAMEX %' or drug_name like 'IBUFAC %' or drug_name like 'IBUFEN %' or drug_name like 'IBULAN %' or drug_name like 'IBULEVE %' or drug_name like 'IBUPEN %' or drug_name like 'IBUSPAN %' or drug_name like 'ILOFEN %' or drug_name like 'IPOGESIC %' or drug_name like 'IPUFEN %' or drug_name like 'KELANG F.C. %' or drug_name like 'KELANG FC %' or drug_name like 'L-FUPROFEN %' or drug_name like 'L FUPROFEN %' or drug_name like 'LFUPROFEN %' or drug_name like 'NEUTROPAIN %' or drug_name like 'NUROFEN %' or drug_name like 'P-FEN %' or drug_name like 'PFEN %' or drug_name like 'P FEN %' or drug_name like 'PANAFLEX %' or drug_name like 'PARKINS %' or drug_name like 'PEROFEN %' or drug_name like 'PHORPAIN %' or drug_name like 'POTOFEN %' or drug_name like 'PROFEN %' or drug_name like 'RAFEN %' or drug_name like 'RUPAN %' or drug_name like 'SCHUFEN %' or drug_name like 'SHANAFEN %' or drug_name like 'SPEDIFEN %' or drug_name like 'SYNPROFEN %' or drug_name like 'TRIFENE %' or drug_name like 'TUOAN %' or drug_name like 'VICKROFEN %' or drug_name like 'ZOFEN %'
or drug_name like 'ARTHREXIN %' or drug_name like 'INDECIN %' or drug_name like 'INDERSHIN %' or drug_name like 'INDOCID %' or drug_name like 'INDOCOLLYRE %' or drug_name like 'INDOMETHACIN %' or drug_name like 'INDOXEN %' or drug_name like 'INDYLON %' or drug_name like 'METHACIN %' or drug_name like 'SUPER STRONG AMMELTZ %' or drug_name like 'RHEUMAXIN %'
or drug_name like 'ACXTRA %' or drug_name like 'ARKET %' or drug_name like 'CETOCLEAN %' or drug_name like 'DERUMA %' or drug_name like 'FASTUM %' or drug_name like 'HARUFEN %' or drug_name like 'HEALTHSPAN %' or drug_name like 'KEBANON %' or drug_name like 'KEFENRIN %' or drug_name like 'KEFENTECH %' or drug_name like 'KENON-S %' or drug_name like 'KENONS %' or drug_name like 'KENON %' or drug_name like 'KENOPAN %' or drug_name like 'KEPAX %' or drug_name like 'KETESSE %' or drug_name like 'KETOFEN %' or drug_name like 'KETOKURA %' or drug_name like 'KETOPAS %' or drug_name like 'KETOPLUS %' or drug_name like 'KETO-TDDS %' or drug_name like 'KETOTDDS %' or drug_name like 'KETO TDDS %'  or drug_name like 'KETOBAND %' or drug_name like 'KETOCLEAN CATAPLASMA  %' or drug_name like 'KETOCLIN %' or drug_name like 'MOHRUS %' or drug_name like 'OSTEKUR %' or drug_name like 'RUBOLIN %' or drug_name like 'SU TON YAN %' or drug_name like 'THRITITON %' or drug_name like 'VOLTA %' or drug_name like 'WAH TAT %'
or drug_name like 'ANALMIN %' or drug_name like 'BEAFEMIC %' or drug_name like 'DOLOGIN %' or drug_name like 'EUROTAN-F %' or drug_name like 'EUROTANF %' or drug_name like 'EUROTAN F %' or drug_name like 'FENAGESIC %' or drug_name like 'FENAPON %' or drug_name like 'FENSTAN %' or drug_name like 'FILMEFEN %' or drug_name like 'GANDIN %' or drug_name like 'GYNOGESIC %' or drug_name like 'HOSTAN %' or drug_name like 'MACROMEFA %' or drug_name like 'MEDICAP %' or drug_name like 'MEFA %' or drug_name like 'MEFAMIC %' or drug_name like 'MEFANIC %' or drug_name like 'MEFEC %' or drug_name like 'MEFEMIC %' or drug_name like 'MEFEN %' or drug_name like 'MEFENA %' or drug_name like 'MEFENAMA %' or drug_name like 'MEFENCID %' or drug_name like 'MEFENE %' or drug_name like 'MEFENSTAN %' or drug_name like 'MEFIC %' or drug_name like 'METSYN %' or drug_name like 'NAMIC %' or drug_name like 'NAPAN %' or drug_name like 'PAINNOX %' or drug_name like 'PONGESIC %' or drug_name like 'PONSGESIC %' or drug_name like 'PONSIS %' or drug_name like 'PONSPAIN %' or drug_name like 'PONSTAL %' or drug_name like 'PONSTAN %' or drug_name like 'PONSTEL %' or drug_name like 'PONTACID %' or drug_name like 'POTARLON %' or drug_name like 'SEFMIC %' or drug_name like 'SHANAMEF %' or drug_name like 'TOEEFON %' or drug_name like 'U-PONOL %' or drug_name like 'UPONOL %' or drug_name like 'U PONOL %' or drug_name like 'UNI-FENAMIC %'  or drug_name like 'UNIFENAMIC %' or drug_name like 'UNI FENAMIC %'
or drug_name like 'ARROX %' or drug_name like 'ARTHCAM %' or drug_name like 'BIOCAM %' or drug_name like 'EXAMEL %' or drug_name like 'MECON %' or drug_name like 'MEDICON %' or drug_name like 'MELANIC %' or drug_name like 'MELCAM %' or drug_name like 'MELFLAM %' or drug_name like 'MELOCAM %' or drug_name like 'MELOX %' or drug_name like 'MELOXIN %' or drug_name like 'MICOXAM %' or drug_name like 'MOBIC %' or drug_name like 'MOCAM %' or drug_name like 'MOVEN %' or drug_name like 'MOXIC %' or drug_name like 'MOXICAM %' or drug_name like 'NEWROCAM %' or drug_name like 'NEWSICAM %' or drug_name like 'NULOX %' or drug_name like 'PARTIAL %' or drug_name like 'PETCAM %' or drug_name like 'RHEUMOCAM %' or drug_name like 'SYNLOXICAM %'
or drug_name like 'ALEVE %' or drug_name like 'APO-NAPRO-NA %' or drug_name like 'APONAPRONA %' or drug_name like 'APO NAPRO NA %' or drug_name like 'INZA %' or drug_name like 'NAPROREX %' or drug_name like 'NAPXEN %' or drug_name like 'SAFROSYN S %' or drug_name like 'SINTON %' or drug_name like 'SNOFIN %' or drug_name like 'SODEN %' or drug_name like 'SOREN %' or drug_name like 'UPROGESIC %'
or drug_name like 'AMMIDENE %' or drug_name like 'CP-PIROX %' or drug_name like 'CPPIROX %' or drug_name like 'CP PIROX %' or drug_name like 'ECKERD TORICAM %' or drug_name like 'ENTON %' or drug_name like 'FEDCOVIT %' or drug_name like 'FEDPIROCAP %' or drug_name like 'FELDENE %' or drug_name like 'FELGESIC %' or drug_name like 'FELTICAM %' or drug_name like 'FINES %' or drug_name like 'FIP TORICAM %' or drug_name like 'FLAMIC %' or drug_name like 'FOCUS %' or drug_name like 'FRATERSI %' or drug_name like 'GOODGEN %' or drug_name like 'HUDSON TORICAM %' or drug_name like 'KENETON %' or drug_name like 'MOBILIS %' or drug_name like 'OSCO TORICAM %' or drug_name like 'PFIDENE %' or drug_name like 'PHARMOR TORICAM %' or drug_name like 'PIROCAM %' or drug_name like 'PIROXIM %' or drug_name like 'PIRUX %' or drug_name like 'PIRXICAM %' or drug_name like 'POCIL %' or drug_name like 'POZZIE %' or drug_name like 'PROPONOL %' or drug_name like 'RHUMAGEL %' or drug_name like 'ROBLES %' or drug_name like 'ROSIDEN %' or drug_name like 'ROSIDEN %' or drug_name like 'SEFDENE %' or drug_name like 'SEMINCON %' or drug_name like 'SOTILEN %' or drug_name like 'SYNOXICAM %' or drug_name like 'TORICAM %' or drug_name like 'XIACT %'
or drug_name like 'AFLOXAN %'
or drug_name like 'ACLIN %' or drug_name like 'APO-SULIN %' or drug_name like 'APOSULIN %' or drug_name like 'APO SULIN %'
or drug_name like 'TENOX %' or drug_name like 'TENOXIL %' or drug_name like 'XOTILON %'
or drug_name like '%ACECLOFENAC%' or drug_name like '%ACEMETACIN%' or drug_name like '%CELECOXIB%'
or drug_name like '%DEXIBUPROFEN%' or drug_name like '%DEXKETOPROFEN%' or drug_name like '%DICLOFENAC%'
or drug_name like '%ETODOLAC%' or drug_name like '%ETORICOXIB%' or drug_name like '%FENOPROFEN%'
or drug_name like '%FLURBIPROFEN%' or drug_name like '%IBUPROFEN%' or drug_name like '%INDOMETHACIN%'
or drug_name like '%KETOPROFEN%' or drug_name like '%MEFENAMIC ACID%' or drug_name like '%MELOXICAM%'
or drug_name like '%NABUMETONE%' or drug_name like '%NAPROXEN%' or drug_name like '%PIROXICAM%'
or drug_name like '%PROGLUMETACIN%' or drug_name like '%ROFECOXIB%' or drug_name like '%SULINDAC%'
or drug_name like '%TENOXICAM%' or drug_name like '%TIAPROFENIC ACID%';
quit; *406865;
proc freq data=an.NSAIDS;
table drug_name;run;
data a;
set an.nsaids;
if substr(drug_name,1,11)='PARACETAMOL' or missing(drug_name);
run;
data an.nsaids;
set an.nsaids;
if substr(drug_name,1,11)='PARACETAMOL' then delete;
run; *406863 altho drug_item_code and BNF seems to be diclofenic but not for drug_name so delete;
data an.nsaids;
set an.nsaids;
rxst=input(prescription_start_date, yymmdd10.);
rxen=input(Prescription_End_Date, yymmdd10.);
dur=rxen-rxst+1;
format rxst rxen yymmdd10.;
run;
/*adding rxst and rxen to missing ones from Quantity__Named_Patient_/ns_ndd/ns_dosage
otherwise, impute the median days*/

proc sql;
create table an.nsaids_ppimi as
select * from an.nsaids where reference_key in (select reference_key from p.ppi_mi_coh1_adult);
quit; *8657;
proc freq data=an.nsaids_ppimi;
table route;run;
data an.nsaids_ppimi;
set an.nsaids_ppimi;
if substr(drug_name,1,11)='GLUCOSAMINE' then delete;
run; *8562, its in the list of CDARS NSAIDS 10.1.1 category;
data nsaids_miss;
set an.nsaids_ppimi;
if missing(rxst) or missing(rxen);run; *917;
proc freq data=nsaids_miss;
table Dosage;run;
data an.nsaids_ppimi;
set an.nsaids_ppimi;
if substr(Dosage,1,5)="0.5 N" then ns_dosage=0.5;
if substr(Dosage,1,6)="0.5 TA" then ns_dosage=0.5;
if substr(Dosage,1,4)="0.75" then ns_dosage=0.75;
if substr(Dosage,1,3)="1 N" then ns_dosage=1;
if substr(Dosage,1,7)="1    NO" then ns_dosage=1;
if substr(Dosage,1,5)="1   (" then ns_dosage=1;
if substr(Dosage,1,7)="1    TA" then ns_dosage=1;
if substr(Dosage,1,5)="1 TAB" then ns_dosage=1;
if substr(Dosage,1,3)="1 (" then ns_dosage=1;
if substr(Dosage,1,9)="1 100M NO" then ns_dosage=1;
if substr(Dosage,1,3)="1 C" then ns_dosage=1;
if substr(Dosage,1,3)="1 S" then ns_dosage=1;
if substr(Dosage,1,5)="2   (" then ns_dosage=2;
if substr(Dosage,1,3)="2 C" then ns_dosage=2;
if substr(Dosage,1,3)="2 N" then ns_dosage=2;
if substr(Dosage,1,4)="2 TA" then ns_dosage=2;
run;
proc freq data=nsaids_miss;
table Drug_Frequency;run;
data an.nsaids_ppimi;
set an.nsaids_ppimi;
if substr(Drug_Frequency,1,2)="AT" then ns_ndd=1;
if substr(Drug_Frequency,1,12)="ON ALTERNATE" then ns_ndd=0.5;
if substr(Drug_Frequency,1,2)="IN" then ns_ndd=1;
if substr(Drug_Frequency,1,3)="DAI" then ns_ndd=1;
if substr(Drug_Frequency,1,11)="EVERY EIGHT" then ns_ndd=3;
if substr(Drug_Frequency,1,10)="EVERY FOUR" then ns_ndd=6;
if substr(Drug_Frequency,1,10)="EVERY SIX" then ns_ndd=4;
if substr(Drug_Frequency,1,10)="EVERY TWEL" then ns_ndd=2;
if substr(Drug_Frequency,1,10)="EVERY TWEN" then ns_ndd=1;
if substr(Drug_Frequency,1,4)="FOUR" then ns_ndd=4;
if substr(Drug_Frequency,1,4)="ONCE" then ns_ndd=1;
if substr(Drug_Frequency,1,3)="SIX" then ns_ndd=6;
if substr(Drug_Frequency,1,3)="THR" then ns_ndd=3;
if substr(Drug_Frequency,1,5)="TWICE" then ns_ndd=2; run;
data an.nsaids_ppimi;
set an.nsaids_ppimi;
if missing(Prescription_Start_Date) then 
rxst=input(Dispensing_Date__yyyy_mm_dd_, yymmdd10.);
format rxst yymmdd10.;
run;
data an.nsaids_ppimi;
set an.nsaids_ppimi;
if missing(Prescription_Start_Date) then dur=Quantity__Named_Patient_/ns_ndd/ns_dosage;
run;
data an.nsaids_ppimi;
set an.nsaids_ppimi;
if missing(Prescription_Start_Date) then rxen=rxst+dur-1; format rxen yymmdd10.;
run;
/*missing dosage or ambigorous dosage for further imputation*/
data b;
set an.nsaids_ppimi;
if missing(rxen) or
(substr(dosage,1,5)='5 AMP' or
substr(dosage,1,6)='75 AMP' or
substr(dosage,1,6)='1 TUBE');
run; *708;
proc freq data=b;
table drug_name*route;
run;

/*check any prescription duration <0*/
data a;
set an.nsaids_ppimi;
if ~missing(dur) and dur<0;
run;
data an.nsaids_ppimi;
set an.nsaids_ppimi;
if dur<0 then do;
dur=Quantity__Named_Patient_/ns_ndd/ns_dosage;
rxen=rxst+dur-1; format rxen yymmdd10.;end;
run;

/*impute duration by drug name and route*/
proc freq data=an.nsaids_ppimi;
table drug_name;run;
data celecoxib;
set an.nsaids_ppimi;
if substr(drug_name,1,9)='CELECOXIB' or substr(drug_name,1,8)='CELEBREX';
run; *56;
data celecoxib;
set celecoxib;
if ~missing(dur) and route in ('ORAL','PO');run; *50, Missing data only have oral for this drug;
proc univariate data=celecoxib;
var dur;run; *median 18 days;

data diclo_diethy;
set an.nsaids_ppimi;
if substr(drug_name,1,26)='DICLOFENAC DIETHYLAMMONIUM' and ~missing(dur) and route in ('LA', 'TOPICAL');
run; *91, Missing data only have topical for this drug;
proc univariate data=diclo_diethy;
var dur;run; *median 57 days;

data diclo_k;
set an.nsaids_ppimi;
if substr(drug_name,1,20)='DICLOFENAC POTASSIUM' or substr(drug_name,1,8)='CATAFLAM';
run; *230;
data diclo_k;
set diclo_k;
if ~missing(dur) and route in ('ORAL','PO');
run; *228;
proc univariate data=diclo_k;
var dur;run; *median 7 days;

data diclo_na_po;
set an.nsaids_ppimi;
if substr(drug_name,1,17)='DICLOFENAC SODIUM' or substr(drug_name,1,8)='VOLTAREN';
data diclo_na_po;
set diclo_na_po;
if ~missing(dur) and route in ('ORAL','PO');run; *3201;
proc univariate data=diclo_na_po;
var dur;run; *median 14 days;

data diclo_na_inj;
set an.nsaids_ppimi;
if substr(drug_name,1,17)='DICLOFENAC SODIUM' or substr(drug_name,1,8)='VOLTAREN';
data diclo_na_inj;
set diclo_na_inj;
if ~missing(dur) and route in ('INJ','INJECTION');run; *10;
proc univariate data=diclo_na_inj;
var dur;run; *median 2 days;

data diclo_na_eye;
set an.nsaids_ppimi;
if substr(drug_name,1,17)='DICLOFENAC SODIUM' or substr(drug_name,1,8)='VOLTAREN';
data diclo_na_eye;
set an.nsaids_ppimi;
if ~missing(dur) and route in ('EYE');run; *13;
proc univariate data=diclo_na_eye;
var dur;run; *median 1 days;

data etodolac;
set an.nsaids_ppimi;
if substr(drug_name,1,8)='ETODOLAC' and ~missing(dur) and route in ('ORAL','PO');run; *26;
proc univariate data=etodolac;
var dur;run; *median 84 days;

data ibuprofen;
set an.nsaids_ppimi;
if substr(drug_name,1,9)='IBUPROFEN' and ~missing(dur) and route in ('ORAL','PO');run; *1407;
proc univariate data=ibuprofen;
var dur;run; *median 7 days;

data indomethacin;
set an.nsaids_ppimi;
if substr(drug_name,1,12)='INDOMETHACIN' and ~missing(dur) and route in ('ORAL','PO');run; *671;
proc univariate data=indomethacin;
var dur;run; *median 7 days;

data naproxen;
set an.nsaids_ppimi;
if substr(drug_name,1,8)='NAPROXEN' and ~missing(dur) and route in ('ORAL','PO');run; *1987;
proc univariate data=naproxen;
var dur;run; *median 8 days;

data piroxican;
set an.nsaids_ppimi;
if substr(drug_name,1,9)='PIROXICAM' and ~missing(dur) and route in ('LA', 'TOPICAL');run; *11;
proc univariate data=piroxican;
var dur;run; *median 169 days;

data proglumetacin;
set an.nsaids_ppimi;
if substr(drug_name,1,13)='PROGLUMETACIN' and ~missing(dur) and route in ('LA', 'TOPICAL');run; *0';
data proglumetacin;
set an.nsaids_ppimi;
if substr(drug_name,1,13)='PROGLUMETACIN' and ~missing(dur);run; *2 ;
proc univariate data=proglumetacin;
var dur;run; *median 70 days;

data rofecoxib;
set an.nsaids_ppimi;
if substr(drug_name,1,9)='ROFECOXIB' and ~missing(dur) and route in ('ORAL','PO');run; *14, Missing data only have oral for this drug;
proc univariate data=rofecoxib;
var dur;run; *median 28 days;

data sulindac;
set an.nsaids_ppimi;
if substr(drug_name,1,8)='SULINDAC' and ~missing(dur) and route in ('ORAL','PO');run; *90, Missing data only have oral for this drug;
proc univariate data=sulindac;
var dur;run; *median 28 days;

data an.nsaids_ppimi;
set an.nsaids_ppimi;
if substr(drug_name,1,9)='CELECOXIB' and missing(dur) and route in ('ORAL','PO') then f_dur=18;
if substr(drug_name,1,26)='DICLOFENAC DIETHYLAMMONIUM' and missing(dur) and route in ('LA', 'TOPICAL') then f_dur=57;
if substr(drug_name,1,20)='DICLOFENAC POTASSIUM' or missing(dur) and route in ('ORAL','PO') then f_dur=7;
if substr(drug_name,1,17)='DICLOFENAC SODIUM' and missing(dur) and route in ('ORAL','PO') then f_dur=14;
if substr(drug_name,1,17)='DICLOFENAC SODIUM' and missing(dur) and route in ('INJ','INJECTION') then f_dur=2;
if substr(drug_name,1,17)='DICLOFENAC SODIUM' and missing(dur) and route in ('EYE') then f_dur=1;
if substr(drug_name,1,8)='ETODOLAC' and missing(dur) and route in ('ORAL','PO') then f_dur=84;
if substr(drug_name,1,9)='IBUPROFEN' and missing(dur) and route in ('ORAL','PO') then f_dur=7;
if substr(drug_name,1,12)='INDOMETHACIN' and missing(dur) and route in ('ORAL','PO') then f_dur=7;
if substr(drug_name,1,8)='NAPROXEN' and missing(dur) and route in ('ORAL','PO') then f_dur=8;
if substr(drug_name,1,9)='PIROXICAM' and missing(dur) and route in ('LA', 'TOPICAL') then f_dur=169;
if substr(drug_name,1,13)='PROGLUMETACIN' and missing(dur) then f_dur=70;
if substr(drug_name,1,9)='ROFECOXIB' and missing(dur) and route in ('ORAL','PO') then f_dur=28;
if substr(drug_name,1,8)='SULINDAC' and missing(dur) and route in ('ORAL','PO') then f_dur=28;
run;
data an.nsaids_ppimi;
set an.nsaids_ppimi;
if missing(dur) then rxen=rxst+f_dur-1; format rxen yymmdd10.;
run;

data an.nsaids_ppimi;
set an.nsaids_ppimi;
ns_nid=_n_;run;
data a;
set an.nsaids_ppimi;
if missing(rxen);run; *0;
/*for saving records*/
data an.nsaids_o30;
set an.nsaids_ppimi;run; 

/*NSAIDS which are known to increase MI*/
proc sql;
create table an.nsaids_high as
select * from an.nsaids_ppimi where drug_name like '%CATAFLAM%'
or drug_name like '%VOLTAREN%'
or drug_name like '%DICLOFENAC%'
or drug_name like '%ROFECOXIB%'
or drug_name like '%VIOXX%';quit; *3703;

/*NSAIDS which are not known to increase MI*/
proc sql;
create table an.nsaids_low as
select * from an.nsaids_ppimi where ns_nid not in (select ns_nid from an.nsaids_high);
quit; *4859;
data an.nsaids_high;set an.nsaids_high;drop ns_nid;run;
data an.nsaids_low;set an.nsaids_low;drop ns_nid;run;
proc freq data=an.nsaids_low;
table drug_name;run;


/************************************************************************
***************************************************************************
******************************************************************************
reset the observation period by considering only outpatient scripts for other medications
******************************************************************************
******************************************************************************
*******************************************************************************/
*patients who had inpatient clarithromycin and nsaids;
data ip_script;
set an.clarith_ppimi2 an.nsaids_ppimi;
if Type_of_Patient__Drug_='I' or Type_of_Patient__Drug_='D';
run;
data ip_script;
set ip_script;
yr_rxst=year(rxst);
run;
data ip_script;
set ip_script;
if yr_rxst<2000 then delete;run;
*remove patients who had inpatient script before first outpatient PPIs;
proc sql;
create table ppi_mi_op as
select *, min(ppirxst) as min_op format yymmdd10. from p.ppi_mi_coh1_adult group by reference_key;
quit;
proc sql;
create table ppi_mi_op as
select * from ppi_mi_op A left join (select rxst as ipod_rxst from ip_script B)
on A.reference_key=B.reference_key;
quit; *3563;
data rm;
set ppi_mi_op;
if ~missing(ipod_rxst) and ipod_rxst<=min_op;
run; *1098,  HC;

proc sql;
create table ppi_mi_coh1_adult_sen as
select * from p.ppi_mi_coh1_adult where reference_key not in (select reference_key from rm);
quit; *1350;

*Censor the observation period if inpatient script after the first outpatient PPIs;
data ppi_ip_RC;
set ppi_mi_op;
if ~missing(ipod_rxst) and ipod_rxst>min_op;
run; *1359,  HC;
proc sql;
create table ppi_ip_RC as
select *, min(ipod_rxst) as IPOD_RC format yymmdd10. from ppi_ip_RC group by reference_key;
quit;
proc sort data=ppi_ip_RC nodupkey;
by reference_key;
run; *285;

/*key right censored IP PPIs/other routes into the dataset*/
proc sql;
create table ppi_mi_coh1_adult_sen2 as
select * from ppi_mi_coh1_adult_sen A left join (select IPOD_RC from ppi_ip_RC B)
on A.reference_key=B.reference_key;
quit; *1350;
data ppi_mi_coh1_adult_sen2;
set ppi_mi_coh1_adult_sen2;
st_st=max(dob, y1, lc12);
st_en=min(dod, y2, IP_RC, IPOD_RC);
format lc12 y1 y2 st_st st_en IP_RC yymmdd10.;
run; *1350;
data remove;
set ppi_mi_coh1_adult_sen2;
if st_st>st_en or ppirxen<st_st;
run; *0 entry;
data ppi_mi_coh1_adult_sen2;
set ppi_mi_coh1_adult_sen2;
if ppirxst>st_en then delete;
run; *1347;

data ppi_mi_coh1_adult_sen2;
set ppi_mi_coh1_adult_sen2;
if ppirxst<st_st and ppirxen>=st_st then ppirxst=st_st;
if ppirxen>st_en and ppirxst<=st_en then ppirxen=st_en;
run; *1347 entries;

data ppi_mi_coh1_adult_sen2;
set ppi_mi_coh1_adult_sen2;
if st_st<=eventd<=st_en;
run; *1287;

*FOR SAVING RECORD ONLY;
data an.ppi_clns_sccs;
set ppi_mi_coh1_adult_sen2;
run;*1287;
/***********************************
***********************************
reshape the datasets**********
***********************************/
data ppi_mi_coh1_adult;
set ppi_mi_coh1_adult_sen2;
keep reference_key ppirxst ppirxen st_st st_en eventd;
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
format pst pen senpst senpen yymmdd10.;
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
format pst pen senpst senpen yymmdd10.;
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
run; *11487;
proc sort data=allperiod;
by reference_key pst pen;
run; 
data allperiod;
set allperiod;
if pst>pen or pst>st_en or pen<st_st then delete;
run; *6789;
data allperiod;
set allperiod;
if pen>st_en then pen=st_en;run;
data allperiod;
set allperiod;
if pst<st_st then pst=st_st;
run;

/*nsaids*/
/*make sure the scripts are within their own obervation period before overlapping*/
proc sort data=ppi_mi_coh1_adult_sen2 nodupkey out=ppi_hc;
by reference_key;run; *1191;
proc sql;
create table an.nsaids_o30 as
select * from an.nsaids_ppimi A left join (select st_st, st_en from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *8562;
data an.nsaids_o30;
set an.nsaids_o30;
if rxst>st_en or rxen<st_st then delete;
if rxst<st_st then rxst=st_st;
if rxen>st_en then rxen=st_en;run; *3048, after overlap: 1930;
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
%consec30d(max=80, input=an.nsaids_o30, patid=reference_key, rxst=rxst, rxen=rxen);
proc sql;
create table nsaids as
select * from an.nsaids_o30 where reference_key in (select reference_key from ppi_mi_coh1_adult_sen2);
quit; *1930;
data nsaids;
set nsaids;
rename rxst=ns_rxst rxen=ns_rxen;
ns_nid=_n_;
run;
proc sort data=nsaids;
by reference_key ns_rxst;
run; *need to sort for formatdata in R to work well;

data nsaids;
set nsaids;
keep reference_key ns_rxst ns_rxen st_st st_en;
run; *1930;
*add non-risk period;
proc sort data=nsaids;
by reference_key ns_rxst ns_rxen;
run;
data nsaids;
set nsaids;
senpst=ns_rxst;
senpen=ns_rxen;
pst=ns_rxst;
pen=ns_rxen;
r=0;
format senpst senpen yymmdd10.;
run;
* identify the first prescription and add the non-risk period before the index date;
data nonrisk_st_st;
set nsaids;
by reference_key;
if first.reference_key;
pst=st_st;
pen=senpst-1;
r=0;
format pst pen yymmdd10.;
run;
data nonrisk_st_st;
set nonrisk_st_st;
if ns_rxst<st_st then delete;
run; *sometimes rxst<st_st, then no nonrisk period:  obs;
data nonrisk_st_en;
set nsaids; 
by reference_key;
if last.reference_key;
pst=senpen+1;
pen=st_en;
r=0;
run;
data nonrisk_st_en;
set nonrisk_st_en;
if ns_rxst>st_en then delete;run; *sometimes upper_rw2>=st_en, then no nonrisk period: ;
data nonrisk_st_en;
set nonrisk_st_en;
if ns_rxen>st_en then pen=st_en;run;
proc sort data=nsaids;
by reference_key descending pst descending pen;
run;
data nonrisk_middle;
set nsaids;
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
data allperiod_ns;
set nonrisk_middle nonrisk_st_st nonrisk_st_en nsaids;
drop Prxst Prxen senpst senpen;
run; *;
proc sort data=allperiod_ns;
by reference_key pst pen;
run; 
data allperiod_ns;
set allperiod_ns;
if pst>pen then delete;
run; *4386;
data allperiod_ns;
set allperiod_ns;
if pen>st_en then pen=st_en;run;
data allperiod_ns;
set allperiod_ns;
if pst<st_st then pst=st_st;run;


/*clarith*/
/*make sure the scripts are within their own obervation period before overlapping*/
proc sort data=ppi_mi_coh1_adult_sen2 nodupkey out=ppi_hc;
by reference_key;run;
proc sql;
create table an.clarith_ppimi as
select * from an.clarith_ppimi2 A left join (select st_st, st_en from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *1226;
data an.clarith_ppimi;
set an.clarith_ppimi;
if rxst>st_en or rxen<st_st then delete;
if rxst<st_st then rxst=st_st;
if rxen>st_en then rxen=st_en;run; *532, after overlap: 509;
%macro consec7d(max=, input=, patid=, rxst=, rxen=);
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
if ~missing(Prxst)and 0<=Prxst-&rxen<=7 then do &rxen=Prxen;
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
%mend consec7d(max=, input=, patid=, rxst=, rxen=);
%consec7d(max=20, input=an.clarith_ppimi, patid=reference_key, rxst=rxst, rxen=rxen);

proc sql;
create table clarith as
select * from an.clarith_ppimi where reference_key in (select reference_key from ppi_mi_coh1_adult_sen2);
quit;
data clarith;
set clarith;
rename rxst=cl_rxst rxen=cl_rxen;
cl_nid=_n_;
run;
proc sort data=clarith;
by reference_key cl_rxst;
run; *need to sort for formatdata in R to work well;
data clarith;
set clarith;
keep reference_key cl_rxst cl_rxen st_st st_en;
run; *509;

*add non-risk period;
proc sort data=clarith;
by reference_key cl_rxst cl_rxen;
run;
data clarith;
set clarith;
senpst=cl_rxst;
senpen=cl_rxen;
pst=cl_rxst;
pen=cl_rxen;
r=0;
format senpst senpen yymmdd10.;
run;
* identify the first prescription and add the non-risk period before the index date;
data nonrisk_st_st;
set clarith;
by reference_key;
if first.reference_key;
pst=st_st;
pen=senpst-1;
r=0;
format pst pen yymmdd10.;
run;
data nonrisk_st_st;
set nonrisk_st_st;
if cl_rxst<st_st then delete;
run; *sometimes rxst<st_st, then no nonrisk period:  obs;
data nonrisk_st_en;
set clarith; 
by reference_key;
if last.reference_key;
pst=senpen+1;
pen=st_en;
r=0;
run;
data nonrisk_st_en;
set nonrisk_st_en;
if cl_rxen>st_en then delete;run; *sometimes upper_rw2>=st_en, then no nonrisk period: ;
data nonrisk_st_en;
set nonrisk_st_en;
if cl_rxen>st_en then pen=st_en;run;
proc sort data=clarith;
by reference_key descending pst descending pen;
run;
data nonrisk_middle;
set clarith;
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
data allperiod_cl;
set nonrisk_middle nonrisk_st_st nonrisk_st_en clarith;
drop Prxst Prxen senpst senpen;
run; *1496;
proc sort data=allperiod_cl;
by reference_key pst pen;
run; 
data allperiod_cl;
set allperiod_cl;
if pst>pen then delete;
run; *;
data allperiod_cl;
set allperiod_cl;
if pen>st_en then pen=st_en;run;
data allperiod_cl;
set allperiod_cl;
if pst<st_st then pst=st_st;run; *1468;

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
set ppi_mi_coh1_adult_sen2;
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
set allperiod allperiod_cl allperiod_ns age_trans;
run;
proc sort data=all;
by reference_key pst pen;
run;
data all2;
set all;
run; *note:22776, after: stop macro until entries in aa is 0;

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
run; *, after: 22776 stop macro until entries in aa is 0;
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
run; *note: 20153 stop macro until entries in aa is 0;

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
run; *28497;
data aa;
set a;
if ~missing(prxen) and pst-prxen~=1;run; *0, should be correct as it turns to 0;

/*check pst and pen outside observation period*/
data all4;
set all4;
if pst>st_en or pen<st_st then delete;run; *21053;
data all4;
set all4;
if pst<st_st then pst=st_st;
if pen>st_en then pen=st_en;
run; *21053;
data all4;
set all4;
drop ppirxst ppirxen ns_rxst ns_rxen cl_rxst cl_rxen;
run;

/*key clarith indicator 1/0 into the dataset*/
proc sql;
create table all4_cl as
select * from all4 A left join (select cl_rxst, cl_rxen from clarith B)
on A.reference_key=B.reference_key;
quit; *21800;
data all4_cl;
set all4_cl;
if pst<=cl_rxst<=pen or pst<=cl_rxen<=pen or cl_rxst<=pst<=cl_rxen or cl_rxst<=pen<=cl_rxen then cl=1;
else cl=0;
run;
proc sort data=all4_cl;
by reference_key pst pen decending cl;
run;
proc sort data=all4_cl nodupkey;
by reference_key pst pen;
run; *21053;

/*nsaids*/
data all4_cl;
set all4_cl;
drop cl_rxst cl_rxen;run;

proc sql;
create table all4_cl_ns as
select * from all4_cl A left join (select ns_rxst, ns_rxen from nsaids B)
on A.reference_key=B.reference_key;
quit; *;
data all4_cl_ns;
set all4_cl_ns;
if pst<=ns_rxst<=pen or pst<=ns_rxen<=pen or ns_rxst<=pst<=ns_rxen or ns_rxst<=pen<=ns_rxen then ns=1;
else ns=0;
run;
proc sort data=all4_cl_ns;
by reference_key pst pen decending ns;
run;
proc sort data=all4_cl_ns nodupkey;
by reference_key pst pen;
run; *21053;
data p.all4_cl_ns;
set all4_cl_ns;
drop ns_rxst ns_rxen;run;

/*can key in drug indicator now*/
proc sql;
create table all4_cl_ns_rw as
select * from p.all4_cl_ns A left join (select pst as pre_pst, pen as pre_pen from prerisk B)
on A.reference_key=B.reference_key;
quit; *;
data all4_cl_ns_rw;
set all4_cl_ns_rw;
if pst<=pre_pst<=pen or pst<=pre_pen<=pen or pre_pst<=pst<=pre_pen or pre_pst<=pen<=pre_pen then op=1;
drop eventd;
run;
proc sort data=all4_cl_ns_rw;
by reference_key pst pen decending op;
run;
proc sort data=all4_cl_ns_rw nodupkey;
by reference_key pst pen;
run; *21053;


proc sql;
create table all4_cl_ns_rw2 as
select * from all4_cl_ns_rw A left join (select pst as postst_1, pen as posten_1 from ppi_mi_coh1_adult B)
on A.reference_key=B.reference_key;
quit; *;
data all4_cl_ns_rw2;
set all4_cl_ns_rw2;
if pst<=postst_1<=pen or pst<=posten_1<=pen or postst_1<=pst<=posten_1 or postst_1<=pen<=posten_1 then op_p1=1;
run;
proc sort data=all4_cl_ns_rw2;
by reference_key pst pen decending op_p1;
run;
proc sort data=all4_cl_ns_rw2 nodupkey;
by reference_key pst pen;
run; *21053;

proc sql;
create table all4_cl_ns_rw3 as
select * from all4_cl_ns_rw2 A left join (select pst as postst_2, pen as posten_2 from postrisk1 B)
on A.reference_key=B.reference_key;
quit; *;
data all4_cl_ns_rw3;
set all4_cl_ns_rw3;
if pst<=postst_2<=pen or pst<=posten_2<=pen or postst_2<=pst<=posten_2 or postst_2<=pen<=posten_2 then op_p2=1;
run;
proc sort data=all4_cl_ns_rw3;
by reference_key pst pen decending op_p2;
run;
proc sort data=all4_cl_ns_rw3 nodupkey;
by reference_key pst pen;
run; *21053;

proc sql;
create table all4_cl_ns_rw4 as
select * from all4_cl_ns_rw3 A left join (select pst as postst_3, pen as posten_3 from postrisk2 B)
on A.reference_key=B.reference_key;
quit; *;
data all4_cl_ns_rw4;
set all4_cl_ns_rw4;
if pst<=postst_3<=pen or pst<=posten_3<=pen or postst_3<=pst<=posten_3 or postst_3<=pen<=posten_3 then op_p3=1;
run;
proc sort data=all4_cl_ns_rw4;
by reference_key pst pen decending op_p3;
run;
proc sort data=all4_cl_ns_rw4 nodupkey;
by reference_key pst pen;
run; *21053;

data all4_cl_ns_rw4;
set all4_cl_ns_rw4;
drop r;
run;
data all4_cl_ns_rw4;
set all4_cl_ns_rw4;
if op=1 then r=1;
if op_p1=1 then r=2;
if op_p2=1 then r=3;
if op_p3=1 then r=4;
run;
/*prefer pre-risk than post-risk*/
data all4_cl_ns_rw4;
set all4_cl_ns_rw4;
if op=1 and op_p1=1 then r=1;
if op=1 and op_p2=1 then r=1;
if op=1 and op_p3=1 then r=1;
run;
/*when two prescriptions overlap, prefer previous current risk window!
check all op_p1=1 and op_p2=1, op_p2 lower earlier than op_p1*/
data z;
set all4_cl_ns_rw4;
if (op_p1=1 and op_p2=1) and (postst_2<postst_1);run; *0 just for checking;
data all4_cl_ns_rw4;
set all4_cl_ns_rw4;
if (op_p1=1 and op_p2=1) or (op_p1=1 and op_p3=1) then r=2;
run;
data all4_cl_ns_rw4;
set all4_cl_ns_rw4;
if (op_p2=1 and op_p3=1) then r=3;
run;

data all4_cl_ns_rw4;
set all4_cl_ns_rw4;
if missing(r) then r=0;
drop op op_p1 op_p2 op_p3 pre_pst pre_pen postst_1 posten_1 postst_2 posten_2 postst_3 posten_3;run;
proc sort data=all4_cl_ns_rw4;
by reference_key pst pen r;run; *21053;


proc sql;
create table p.all4_cl_ns_rw as
select * from all4_cl_ns_rw4 A left join (select sex as gen from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *21053;
data p.all4_cl_ns_rw;
set p.all4_cl_ns_rw;
if gen='M' then sex=1;
if gen='F' then sex=0;
run;
data p.all4_cl_ns_rw;
set p.all4_cl_ns_rw;
drop gen;
run;
proc sql;
create table p.all4_cl_ns_rw as
select * from p.all4_cl_ns_rw A left join (select dob, ppirxst, eventd from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *21053;

/*some of the risk periods chopped due to different pst and pen overlapped >>>need to be recombined
for example reference_key=1826865: the pre-risk period 17/2/2011-18/2/2011 and 19/2/2011-2/3/2011 are both pre-risk period
they were chopped due to the previous post-risk period, so need to combine it to be 17/2/2011-2/3/2011 for the whole pre-risk period

4 people have this problem
869674
1467772
1826865
2425738*/

data combinerisk;
set p.all4_cl_ns_rw;
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
lag_ns=lag(ns);
lag_cl=lag(cl);
lag_r=lag(r);
run;
data combinerisk2;
set combinerisk;
if reference_key~=lag_indiv or lag_ns~=ns or lag_cl~=cl or lag_r~=r or (m_dob=m_pst and d_dob=d_pst) then n+1;
run;
proc sql;
create table combinerisk3 as
  select *, min(pst) as min_pst format yymmdd10., max(pen) as max_pen format yymmdd10. from combinerisk2 group by n;
quit;
proc sort data=combinerisk3 nodupkey;
by n;
run;
data p.all4_cl_ns_rw;
set combinerisk3;
drop pst pen;
rename min_pst=pst max_pen=pen;
drop lag_indiv lag_ns lag_cl n lag_r m_dob d_dob m_pst d_pst;
run; *21052;

data p.all4_cl_ns_rw;
set p.all4_cl_ns_rw;
age=year(pst)-year(dob);
censor=1;
interval=pen-pst+1;
run;
/*making R dataset*/
data poisson_sen;
set p.all4_cl_ns_rw;
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
nsaids=ns;
clarith=cl;
keep indiv gender adrug lower upper exposed nsaids clarith astart aend aevent group present; 
run;

PROC EXPORT DATA= poisson_sen
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\SAS export for R\manuscript\sccs_ppimi_multi_period_sen.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=NO;
RUN;

proc sort data=poisson_sen nodupkey out=hc;
by indiv;
run;
*no of events during clarith;
data final;
set poisson_sen;
if lower<=aevent<=upper then event=1;
else event=0;run;
proc freq data=final;
table exposed*event;
run;

data a;
set final;
if event=1 and clarith=1;
run; *13 HC;

*no of events during NSAIDS;
data a;
set final;
if event=1 and nsaids=1;
run; * HC;


/***************************************************************
****************************************************************
Updated on 20 Jul 2016
Purpose: separating NSAIDS into two groups: known or not known to increase MI
*****************************************************************
*****************************************************************/
/****************************************
NSAIDS known to increase MI*
****************************************/
proc sort data=ppi_mi_coh1_adult_sen2 nodupkey out=ppi_hc;
by reference_key;run; *1191;
proc sql;
create table nsaids_high as
select * from an.nsaids_high A left join (select st_st, st_en from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *3703;
data nsaids_high;
set nsaids_high;
if rxst>st_en or rxen<st_st then delete;
if rxst<st_st then rxst=st_st;
if rxen>st_en then rxen=st_en;run; 

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
%consec30d(max=60, input=nsaids_high, patid=reference_key, rxst=rxst, rxen=rxen);
proc sql;
create table nsaids_high as
select * from nsaids_high where reference_key in (select reference_key from ppi_mi_coh1_adult_sen2);
quit; *726;
data nsaids_high;
set nsaids_high;
rename rxst=nsh_rxst rxen=nsh_rxen;
ns_nid=_n_;
run;
proc sort data=nsaids_high;
by reference_key nsh_rxst;
run; *need to sort for formatdata in R to work well;
data nsaids_high;
set nsaids_high;
keep reference_key nsh_rxst nsh_rxen st_st st_en;
run; *726;

*add non-risk period;
proc sort data=nsaids_high;
by reference_key nsh_rxst nsh_rxen;
run;
data nsaids_high;
set nsaids_high;
senpst=nsh_rxst;
senpen=nsh_rxen;
pst=nsh_rxst;
pen=nsh_rxen;
r=0;
format senpst senpen yymmdd10.;
run;
* identify the first prescription and add the non-risk period before the index date;
data nonrisk_st_st;
set nsaids_high;
by reference_key;
if first.reference_key;
pst=st_st;
pen=senpst-1;
r=0;
format pst pen yymmdd10.;
run;
data nonrisk_st_st;
set nonrisk_st_st;
if nsh_rxst<st_st then delete;
run; *sometimes rxst<st_st, then no nonrisk period:  obs;
data nonrisk_st_en;
set nsaids_high; 
by reference_key;
if last.reference_key;
pst=senpen+1;
pen=st_en;
r=0;
run;
data nonrisk_st_en;
set nonrisk_st_en;
if nsh_rxst>st_en then delete;run; *sometimes upper_rw2>=st_en, then no nonrisk period: ;
data nonrisk_st_en;
set nonrisk_st_en;
if nsh_rxen>st_en then pen=st_en;run;
proc sort data=nsaids_high;
by reference_key descending pst descending pen;
run;
data nonrisk_middle;
set nsaids_high;
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
data allperiod_nsh;
set nonrisk_middle nonrisk_st_st nonrisk_st_en nsaids_high;
drop Prxst Prxen senpst senpen;
run; *1768;
proc sort data=allperiod_nsh;
by reference_key pst pen;
run; 
data allperiod_nsh;
set allperiod_nsh;
if pst>pen then delete;
run; *1716;
data allperiod_nsh;
set allperiod_nsh;
if pen>st_en then pen=st_en;run;
data allperiod_nsh;
set allperiod_nsh;
if pst<st_st then pst=st_st;run;

/****************************************
NSAIDS Not known to increase MI*
****************************************/
proc sort data=ppi_mi_coh1_adult_sen2 nodupkey out=ppi_hc;
by reference_key;run; *1191;
proc sql;
create table nsaids_low as
select * from an.nsaids_low A left join (select st_st, st_en from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *4859;
data nsaids_low;
set nsaids_low;
if rxst>st_en or rxen<st_st then delete;
if rxst<st_st then rxst=st_st;
if rxen>st_en then rxen=st_en;run; *1931, after overlap: 1365;

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
%consec30d(max=60, input=nsaids_low, patid=reference_key, rxst=rxst, rxen=rxen);
proc sql;
create table nsaids_low as
select * from nsaids_low where reference_key in (select reference_key from ppi_mi_coh1_adult_sen2);
quit; *1365;
data nsaids_low;
set nsaids_low;
rename rxst=nsl_rxst rxen=nsl_rxen;
ns_nid=_n_;
run;
proc sort data=nsaids_low;
by reference_key nsl_rxst;
run; *need to sort for formatdata in R to work well;
data nsaids_low;
set nsaids_low;
keep reference_key nsl_rxst nsl_rxen st_st st_en;
run; *1365;

*add non-risk period;
proc sort data=nsaids_low;
by reference_key nsl_rxst nsl_rxen;
run;
data nsaids_low;
set nsaids_low;
senpst=nsl_rxst;
senpen=nsl_rxen;
pst=nsl_rxst;
pen=nsl_rxen;
r=0;
format senpst senpen yymmdd10.;
run;
* identify the first prescription and add the non-risk period before the index date;
data nonrisk_st_st;
set nsaids_low;
by reference_key;
if first.reference_key;
pst=st_st;
pen=senpst-1;
r=0;
format pst pen yymmdd10.;
run;
data nonrisk_st_st;
set nonrisk_st_st;
if nsl_rxst<st_st then delete;
run; *sometimes rxst<st_st, then no nonrisk period:  obs;
data nonrisk_st_en;
set nsaids_low; 
by reference_key;
if last.reference_key;
pst=senpen+1;
pen=st_en;
r=0;
run;
data nonrisk_st_en;
set nonrisk_st_en;
if nsl_rxst>st_en then delete;run; *sometimes upper_rw2>=st_en, then no nonrisk period: ;
data nonrisk_st_en;
set nonrisk_st_en;
if nsl_rxen>st_en then pen=st_en;run;
proc sort data=nsaids_low;
by reference_key descending pst descending pen;
run;
data nonrisk_middle;
set nsaids_low;
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
data allperiod_nsl;
set nonrisk_middle nonrisk_st_st nonrisk_st_en nsaids_low;
drop Prxst Prxen senpst senpen;
run; *3217;
proc sort data=allperiod_nsl;
by reference_key pst pen;
run; 
data allperiod_nsl;
set allperiod_nsl;
if pst>pen then delete;
run; *3182;
data allperiod_nsl;
set allperiod_nsl;
if pen>st_en then pen=st_en;run;
data allperiod_nsl;
set allperiod_nsl;
if pst<st_st then pst=st_st;run;

/***************************************************************************
combine with other periods: for age_trans and allperiod allperiod_cl same as above
*****************************************************************************/
data all;
set allperiod allperiod_cl allperiod_nsl allperiod_nsh age_trans;
run; *23288;
proc sort data=all;
by reference_key pst pen;
run;
data all2;
set all;
run; *note: after: stop macro until entries in aa is 0;

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
%multi(max=30, input=all2);

data all3;
set all;
run; *, after: 23288 stop macro until entries in aa is 0;
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
run; *note:after:21351 stop macro until entries in aa is 0;

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
%multi(max=30, input=all4);
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
%multi(max=30, input=all4);

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
run; *21351;
data all4;
set all4;
drop ppirxst ppirxen nsl_rxst nsl_rxen nsh_rxst nsh_rxen cl_rxst cl_rxen;
run;

/*key clarith indicator 1/0 into the dataset*/
proc sql;
create table all4_cl as
select * from all4 A left join (select cl_rxst, cl_rxen from clarith B)
on A.reference_key=B.reference_key;
quit; *;
data all4_cl;
set all4_cl;
if pst<=cl_rxst<=pen or pst<=cl_rxen<=pen or cl_rxst<=pst<=cl_rxen or cl_rxst<=pen<=cl_rxen then cl=1;
else cl=0;
run;
proc sort data=all4_cl;
by reference_key pst pen decending cl;
run;
proc sort data=all4_cl nodupkey;
by reference_key pst pen;
run; *21351;

/*nsaids high risk*/
data all4_cl;
set all4_cl;
drop cl_rxst cl_rxen;run;

proc sql;
create table all4_cl_nsh as
select * from all4_cl A left join (select nsh_rxst, nsh_rxen from nsaids_high B)
on A.reference_key=B.reference_key;
quit; *;
data all4_cl_nsh;
set all4_cl_nsh;
if pst<=nsh_rxst<=pen or pst<=nsh_rxen<=pen or nsh_rxst<=pst<=nsh_rxen or nsh_rxst<=pen<=nsh_rxen then nsh=1;
else nsh=0;
run;
proc sort data=all4_cl_nsh;
by reference_key pst pen decending nsh;
run;
proc sort data=all4_cl_nsh nodupkey;
by reference_key pst pen;
run; *21351;

/*nsaids not known to have MI risk*/
data p.all4_cl_nsh;
set all4_cl_nsh;
drop nsh_rxst nsh_rxen;
run;

proc sql;
create table all4_cl_nshl as
select * from p.all4_cl_nsh A left join (select nsl_rxst, nsl_rxen from nsaids_low B)
on A.reference_key=B.reference_key;
quit; *;
data all4_cl_nshl;
set all4_cl_nshl;
if pst<=nsl_rxst<=pen or pst<=nsl_rxen<=pen or nsl_rxst<=pst<=nsl_rxen or nsl_rxst<=pen<=nsl_rxen then nsl=1;
else nsl=0;
run;
proc sort data=all4_cl_nshl;
by reference_key pst pen decending nsl;
run;
proc sort data=all4_cl_nshl nodupkey;
by reference_key pst pen;
run; *21351;
data p.all4_cl_nshl;
set all4_cl_nshl;
drop nsl_rxst nsl_rxen;
run;

/*can key in drug indicator now*/
proc sql;
create table all4_cl_ns_rw as
select * from p.all4_cl_nshl A left join (select pst as pre_pst, pen as pre_pen from prerisk B)
on A.reference_key=B.reference_key;
quit; *;
data all4_cl_ns_rw;
set all4_cl_ns_rw;
if pst<=pre_pst<=pen or pst<=pre_pen<=pen or pre_pst<=pst<=pre_pen or pre_pst<=pen<=pre_pen then op=1;
drop eventd;
run;
proc sort data=all4_cl_ns_rw;
by reference_key pst pen decending op;
run;
proc sort data=all4_cl_ns_rw nodupkey;
by reference_key pst pen;
run; *21351;


proc sql;
create table all4_cl_ns_rw2 as
select * from all4_cl_ns_rw A left join (select pst as postst_1, pen as posten_1 from ppi_mi_coh1_adult B)
on A.reference_key=B.reference_key;
quit; *;
data all4_cl_ns_rw2;
set all4_cl_ns_rw2;
if pst<=postst_1<=pen or pst<=posten_1<=pen or postst_1<=pst<=posten_1 or postst_1<=pen<=posten_1 then op_p1=1;
run;
proc sort data=all4_cl_ns_rw2;
by reference_key pst pen decending op_p1;
run;
proc sort data=all4_cl_ns_rw2 nodupkey;
by reference_key pst pen;
run; *21351;

proc sql;
create table all4_cl_ns_rw3 as
select * from all4_cl_ns_rw2 A left join (select pst as postst_2, pen as posten_2 from postrisk1 B)
on A.reference_key=B.reference_key;
quit; *;
data all4_cl_ns_rw3;
set all4_cl_ns_rw3;
if pst<=postst_2<=pen or pst<=posten_2<=pen or postst_2<=pst<=posten_2 or postst_2<=pen<=posten_2 then op_p2=1;
run;
proc sort data=all4_cl_ns_rw3;
by reference_key pst pen decending op_p2;
run;
proc sort data=all4_cl_ns_rw3 nodupkey;
by reference_key pst pen;
run; *21351;

proc sql;
create table all4_cl_ns_rw4 as
select * from all4_cl_ns_rw3 A left join (select pst as postst_3, pen as posten_3 from postrisk2 B)
on A.reference_key=B.reference_key;
quit; *;
data all4_cl_ns_rw4;
set all4_cl_ns_rw4;
if pst<=postst_3<=pen or pst<=posten_3<=pen or postst_3<=pst<=posten_3 or postst_3<=pen<=posten_3 then op_p3=1;
run;
proc sort data=all4_cl_ns_rw4;
by reference_key pst pen decending op_p3;
run;
proc sort data=all4_cl_ns_rw4 nodupkey;
by reference_key pst pen;
run; *21351;

data all4_cl_ns_rw4;
set all4_cl_ns_rw4;
drop r;
run;
data all4_cl_ns_rw4;
set all4_cl_ns_rw4;
if op=1 then r=1;
if op_p1=1 then r=2;
if op_p2=1 then r=3;
if op_p3=1 then r=4;
run;
/*prefer pre-risk than post-risk*/
data all4_cl_ns_rw4;
set all4_cl_ns_rw4;
if op=1 and op_p1=1 then r=1;
if op=1 and op_p2=1 then r=1;
if op=1 and op_p3=1 then r=1;
run;
/*when two prescriptions overlap, prefer previous current risk window!
check all op_p1=1 and op_p2=1, op_p2 lower earlier than op_p1*/
data z;
set all4_cl_ns_rw4;
if (op_p1=1 and op_p2=1) and (postst_2<postst_1);run; *0 just for checking;
data all4_cl_ns_rw4;
set all4_cl_ns_rw4;
if (op_p1=1 and op_p2=1) or (op_p1=1 and op_p3=1) then r=2;
run;
data all4_cl_ns_rw4;
set all4_cl_ns_rw4;
if (op_p2=1 and op_p3=1) then r=3;
run;

data all4_cl_ns_rw4;
set all4_cl_ns_rw4;
if missing(r) then r=0;
drop op op_p1 op_p2 op_p3 pre_pst pre_pen postst_1 posten_1 postst_2 posten_2 postst_3 posten_3;run;
proc sort data=all4_cl_ns_rw4;
by reference_key pst pen r;run; *21351;


proc sql;
create table p.all4_cl_nshl_rw as
select * from all4_cl_ns_rw4 A left join (select sex as gen from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *21351;
data p.all4_cl_nshl_rw;
set p.all4_cl_nshl_rw;
if gen='M' then sex=1;
if gen='F' then sex=0;
run;
data p.all4_cl_nshl_rw;
set p.all4_cl_nshl_rw;
drop gen;
run;
proc sql;
create table p.all4_cl_nshl_rw as
select * from p.all4_cl_nshl_rw A left join (select dob, ppirxst, eventd from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *21351;

/*some of the risk periods chopped due to different pst and pen overlapped >>>need to be recombined
for example reference_key=1826865: the pre-risk period 17/2/2011-18/2/2011 and 19/2/2011-2/3/2011 are both pre-risk period
they were chopped due to the previous post-risk period, so need to combine it to be 17/2/2011-2/3/2011 for the whole pre-risk period

4 people have this problem
869674
1467772
1826865
2425738*/

data combinerisk;
set p.all4_cl_nshl_rw;
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
lag_nsh=lag(nsh);
lag_nsl=lag(nsl);
lag_cl=lag(cl);
lag_r=lag(r);
run;
data combinerisk2;
set combinerisk;
if reference_key~=lag_indiv or lag_nsh~=nsh or lag_nsl~=nsl or lag_cl~=cl or lag_r~=r or (m_dob=m_pst and d_dob=d_pst) then n+1;
run;
proc sql;
create table combinerisk3 as
  select *, min(pst) as min_pst format yymmdd10., max(pen) as max_pen format yymmdd10. from combinerisk2 group by n;
quit;
proc sort data=combinerisk3 nodupkey;
by n;
run;
data p.all4_cl_nshl_rw;
set combinerisk3;
drop pst pen;
rename min_pst=pst max_pen=pen;
drop lag_indiv lag_nsh lag_nsl lag_cl n lag_r m_dob d_dob m_pst d_pst;
run; *21351;

data p.all4_cl_nshl_rw;
set p.all4_cl_nshl_rw;
age=year(pst)-year(dob);
censor=1;
interval=pen-pst+1;
run;

proc sort data=p.all4_cl_nshl_rw;
by reference_key pst pen;
run;

proc sql;
create table poisson as
select *, max(ppirxst) as max_adrug format yymmdd10. from p.all4_cl_nshl_rw group by reference_key;
quit;
/*making R dataset*/
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
nsaids_high=nsh;
nsaids_low=nsl;
clarith=cl;
keep indiv gender adrug lower upper exposed nsaids_high nsaids_low clarith astart aend aevent group present; 
run;

PROC EXPORT DATA= poisson2
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\SAS export for R\manuscript\sccs_ppimi_multi_period.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=NO;
RUN;

data final;
set p.all4_cl_nshl_rw;
age=year(pst)-year(dob);
sex_ = put(sex, 1.) ; 
drop sex; 
rename sex_=sex;
reference_key_ = put(reference_key, 20.) ; 
drop reference_key; 
rename reference_key_=reference_key;
run;
data final;
set final;
if pst<=eventd<=pen then event=1;
else event=0;
run;

proc freq data=final;
table r*event;
run;

*count how many included patients on clarithromycin during the observation period;
data clarith_num;
set final;
if cl=1;
run; *531;
proc sort data=clarith_num nodupkey;
by reference_key;
run; *478;
*count how many included patients on NSAIDS that are known to increase MI during the observation period;
data highns_num;
set final;
if nsh=1;
run; *1078;
proc sort data=highns_num nodupkey;
by reference_key;
run; *316;
*count how many included patients on NSAIDS that are not known to increase MI during the observation period;
data lowns_num;
set final;
if nsl=1;
run; *1642;
proc sort data=lowns_num nodupkey;
by reference_key;
run; *487;

*no of events on clarithromycin;
data clarith_event;
set final;
if event=1 and cl=1;
run; *13, nodupkey;
*no of events on NSAIDS that are known to increase MI;
data highns_event;
set final;
if event=1 and nsh=1;
run; *15, nodupkey;
*no of events on NSAIDS that are not known to increase MI;
data lowns_event;
set final;
if event=1 and nsl=1;
run; *11, nodupkey;

proc univariate data=p.all4_cl_nshl_rw;
var interval; run; *;
proc univariate data=p.all4_cl_nshl_rw;
var interval; where r=0;run; *;
proc univariate data=p.all4_cl_nshl_rw;
var interval; where r=1;run; *;
proc univariate data=p.all4_cl_nshl_rw;
var interval; where r=2;run; *;
proc univariate data=p.all4_cl_nshl_rw;
var interval; where r=3;run; *;
proc univariate data=p.all4_cl_nshl_rw;
var interval; where r=4;run; *;
proc univariate data=p.all4_cl_nshl_rw;
var interval; where cl=1;run; *;
proc univariate data=p.all4_cl_nshl_rw;
var interval; where nsh=1;run; *;
proc univariate data=p.all4_cl_nshl_rw;
var interval; where nsl=1;run; *;


/*Created on 7 April 2017
clopidogrel*/
proc sql;
create table an.clopidogrel as
select * from an.alldrug9314 where
drug_name like 'COPLAVIX %'
or drug_name like 'ANTIPLATT %' or drug_name like 'CLAVIX %' or drug_name like 'CLOFLOW %' or drug_name like 'CLOGIN %' or drug_name like 'CLOPIDEX %' or drug_name like 'CLOPIDOREX %' or drug_name like 'CLOPIMED %' or drug_name like 'CLOPIRIGHT %' or drug_name like 'CLOPISTAD %' or drug_name like 'CLOPIVAS %' or drug_name like 'CLOPIVID %' or drug_name like 'CLOPRA %' or drug_name like 'CLOPREZ %' or drug_name like 'COPALEX %' or drug_name like 'COPIDREL %' or drug_name like 'DCLOT %' or drug_name like 'FRELET %' or drug_name like 'GRIDOKLINE %' or drug_name like 'LOPIREL %' or drug_name like 'NORPLAT %' or drug_name like 'PLAGERINE %' or drug_name like 'PLAVIX %' or drug_name like 'PROGREL %'   
or drug_name like '%CLOPIDOGREL%';quit;
*538562;

proc freq data=an.clopidogrel;
table drug_name;
run;

proc sql;
delete from an.clopidogrel
where drug_name like '%STUDY%' or
drug_name like '%PLACEBO%';
quit; *150 deleted;
data an.clopidogrel;
set an.clopidogrel;
rxst=input(Prescription_Start_Date, yymmdd10.);
rxen=input(Prescription_End_Date, yymmdd10.);
format rxst rxen yymmdd10.;
run;
/*no of ppl who had MI during current use*/
data mi_current;
set p.primary_risk_final;
if (r=2 or r=3 or r=4) and event=1;
run;
proc sql;
create table mi_current_clop as
select * from mi_current A left join (select rxst as clo_rxst, rxen as clo_rxen from an.clopidogrel B)
on A.reference_key=B.reference_key;
quit;*1353;
data mi_current_clop;
set mi_current_clop;
if ~missing(clo_rxst) and clo_rxst<eventd;
run; *114;
proc sort data=mi_current_clop nodupkey out=a;
by reference_key;
run; *18;
proc sql;
create table exclude_clop_current as
select * from p.primary_risk_final where reference_key not in (select reference_key from mi_current_clop);
quit; *21357;
proc sql;
create table poisson as
select *, max(ppirxst) as max_adrug format yymmdd10. from exclude_clop_current group by reference_key;
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
PROC EXPORT DATA= poisson2
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\SAS export for R\manuscript\clop_current.txt" 
            DBMS=DLM REPLACE;
     PUTNAMES=NO;
RUN;
/*all ppl*/
proc sql;
create table mi_all_clop as
select * from p.primary_risk_final A left join (select rxst as clo_rxst, rxen as clo_rxen from an.clopidogrel B)
on A.reference_key=B.reference_key;
quit;*220921;
data mi_all_clop;
set mi_all_clop;
if ~missing(clo_rxst) and clo_rxst<eventd;
run; *15063;
proc sort data=mi_all_clop nodupkey out=aa;
by reference_key;
run; *124;
proc sql;
create table exclude_clop_all as
select * from p.primary_risk_final where reference_key not in (select reference_key from mi_all_clop);
quit; *19770;
proc sort data=exclude_clop_all nodupkey out=hc;
by reference_key;
run;*1382;

proc sql;
create table poisson as
select *, max(ppirxst) as max_adrug format yymmdd10. from exclude_clop_all group by reference_key;
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
PROC EXPORT DATA= poisson2
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\SAS export for R\manuscript\clop_all.txt" 
            DBMS=DLM REPLACE;
     PUTNAMES=NO;
RUN;
