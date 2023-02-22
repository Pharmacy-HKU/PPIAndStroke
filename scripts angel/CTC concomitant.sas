/*Created on 29 Jun 2016
Concomitant use of other drugs

Updated on 23 Sep 2016: to obtain the adjusted odds ratio by considering the interaction and time trend
same as SCCS: consider clarithromycin and NSAIDS
Updated on 26 Sep 2016: Add sensitivity analysis for considering NSAIDS as a whole group
Updated on 31 Oct 2016: To add H2 blockers as the negative exposure tracer*/

libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname an "C:\Users\Angel YS Wong\Desktop\PPI\program\drug";
libname lc "C:\Users\Angel YS Wong\Desktop\PPI\program\lc";
libname m "C:\Users\Angel YS Wong\Desktop\PPI\program\CTC";

/*Identify clarithromycin and NSAIDS exposures in control patients*/

/*clarithromycin*/
proc sql;
create table an.clarith_ctrl as
select * from an.control_alldrug_all where drug_name like '%CLARITHRO%'
or drug_item_code like 'CLAR%';
quit; *2701;
proc freq data=an.clarith_ctrl;
table drug_name;run;
data an.clarith_ctrl;
set an.clarith_ctrl;
if substr(drug_name,1,9)='CLARINASE' then delete;run; *2509;
data an.clarith_ctrl;
set an.clarith_ctrl;
rxst=input(prescription_start_date, yymmdd10.);
rxen=input(Prescription_End_Date, yymmdd10.);
dur=rxen-rxst+1;
format rxst rxen yymmdd10.;
run;
/*check any prescription duration <0*/
data a;
set an.clarith_ctrl;
if ~missing(dur) and dur<0;
run; *0;
/*adding rxst and rxen to missing ones from Quantity__Named_Patient_/cl_ndd/cl_dosage
otherwise, impute the median days*/
data clarith_miss;
set an.clarith_ctrl;
if missing(dur);run; *68;
proc freq data=clarith_miss;
table Dosage;run;
data an.clarith_ctrl;
set an.clarith_ctrl;
if substr(Dosage,1,2)="1 " then cl_dosage=1;
if substr(Dosage,1,2)="2 " then cl_dosage=2;
run;
proc freq data=clarith_miss;
table Drug_Frequency;run;
data an.clarith_ctrl;
set an.clarith_ctrl;
if substr(Drug_Frequency,1,5)="TWICE" then cl_ndd=2; run;
data an.clarith_ctrl;
set an.clarith_ctrl;
if missing(Prescription_Start_Date) then 
rxst=input(Dispensing_Date__yyyy_mm_dd_, yymmdd10.);
format rxst yymmdd10.;
run;
data an.clarith_ctrl;
set an.clarith_ctrl;
if missing(Prescription_Start_Date) then dur=Quantity__Named_Patient_/cl_ndd/cl_dosage;
run;
data an.clarith_ctrl;
set an.clarith_ctrl;
if missing(Prescription_Start_Date) then rxen=rxst+dur-1; format rxen yymmdd10.;
run;
data no_miss;
set an.clarith_ctrl;
if ~missing(dur);run;
proc univariate data=no_miss;
var dur;run; *median 7 days;
data an.clarith_ctrl;
set an.clarith_ctrl;
if missing(dur) then f_dur=7;
else f_dur=dur;run;
data an.clarith_ctrl;
set an.clarith_ctrl;
if missing(dur) then rxen=rxst+f_dur-1; format rxen yymmdd10.;
run;
data a;
set an.clarith_ctrl;
if missing(rxen);run; *0, after overlapping 1775;

data an.clarith_ctrl_o7;
set an.clarith_ctrl;
run; 
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
%consec7d(max=20, input=an.clarith_ctrl_o7, patid=reference_key, rxst=rxst, rxen=rxen);
/*NSAIDS*/
proc sql;
create table an.NSAIDS_ctrl as
select * from an.control_alldrug_all where Therapeutic_Classification__BNF_ like '10.1.1%' 
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
quit; *15899;
proc freq data=an.NSAIDS_ctrl;
table drug_name;run;
data an.NSAIDS_ctrl;
set an.NSAIDS_ctrl;
if substr(drug_name,1,11)='GLUCOSAMINE' then delete;
run; *15747;
data an.NSAIDS_ctrl;
set an.NSAIDS_ctrl;
rxst=input(prescription_start_date, yymmdd10.);
rxen=input(Prescription_End_Date, yymmdd10.);
dur=rxen-rxst+1;
format rxst rxen yymmdd10.;
run;
/*adding rxst and rxen to missing ones from Quantity__Named_Patient_/ns_ndd/ns_dosage
otherwise, impute the median days*/
proc freq data=an.NSAIDS_ctrl;
table route;run;
data nsaids_miss;
set an.NSAIDS_ctrl;
if missing(dur);run; *1542;
proc freq data=nsaids_miss;
table Dosage;run;
data an.NSAIDS_ctrl;
set an.NSAIDS_ctrl;
if substr(Dosage,1,5)="0.5 N" then ns_dosage=0.5;
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
data an.NSAIDS_ctrl;
set an.NSAIDS_ctrl;
if substr(Drug_Frequency,1,2)="AT" then ns_ndd=1;
if substr(Drug_Frequency,1,2)="IN" then ns_ndd=1;
if substr(Drug_Frequency,1,3)="DAI" then ns_ndd=1;
if substr(Drug_Frequency,1,10)="EVERY SIX" then ns_ndd=4;
if substr(Drug_Frequency,1,10)="EVERY TWEL" then ns_ndd=2;
if substr(Drug_Frequency,1,4)="FOUR" then ns_ndd=4;
if substr(Drug_Frequency,1,4)="ONCE" then ns_ndd=1;
if substr(Drug_Frequency,1,3)="SIX" then ns_ndd=6;
if substr(Drug_Frequency,1,3)="THR" then ns_ndd=3;
if substr(Drug_Frequency,1,5)="TWICE" then ns_ndd=2; run;
data an.NSAIDS_ctrl;
set an.NSAIDS_ctrl;
if missing(Prescription_Start_Date) then 
rxst=input(Dispensing_Date__yyyy_mm_dd_, yymmdd10.);
format rxst yymmdd10.;
run;
data an.NSAIDS_ctrl;
set an.NSAIDS_ctrl;
if missing(Prescription_Start_Date) then dur=Quantity__Named_Patient_/ns_ndd/ns_dosage;
run;
data an.NSAIDS_ctrl;
set an.NSAIDS_ctrl;
if missing(Prescription_Start_Date) then rxen=rxst+dur-1; format rxen yymmdd10.;
run;
/*missing dosage or ambigorous dosage for further imputation*/
data b;
set an.NSAIDS_ctrl;
if missing(rxen) or
(substr(dosage,1,5)='5 AMP' or
substr(dosage,1,6)='1 BOTT' or
substr(dosage,1,6)='75 AMP' or
substr(dosage,1,6)='1 TUBE');
run; *336;
proc freq data=b;
table drug_name*route;
run;

/*check any prescription duration <0*/
data a;
set an.NSAIDS_ctrl;
if ~missing(dur) and dur<0;
run; *0;

data nsaids_missing_v2;
set an.nsaids_ctrl;
if missing(dur);run; *290;
proc freq data=nsaids_missing_v2;
table drug_name*route;
run;

/*impute duration by drug name and route*/
data celecoxib;
set an.nsaids_ctrl;
if substr(drug_name,1,9)='CELECOXIB' or substr(drug_name,1,8)='CELEBREX';
run; *160;
data celecoxib;
set celecoxib;
if ~missing(dur) and route in ('ORAL','PO');run; *156, Missing data only have oral for this drug;
proc univariate data=celecoxib;
var dur;run; *median 28 days;

data diclo_diethy;
set an.nsaids_ctrl;
if substr(drug_name,1,26)='DICLOFENAC DIETHYLAMMONIUM' and ~missing(dur) and route in ('LA', 'TOPICAL');
run; *166, Missing data only have topical for this drug;
proc univariate data=diclo_diethy;
var dur;run; *median 56 days;

data diclo_na_po;
set an.nsaids_ctrl;
if substr(drug_name,1,17)='DICLOFENAC SODIUM' or substr(drug_name,1,8)='VOLTAREN';
data diclo_na_po;
set diclo_na_po;
if ~missing(dur) and route in ('ORAL','PO');run; *5884;
proc univariate data=diclo_na_po;
var dur;run; *median 14 days;

data diclo_na_inj;
set an.nsaids_ctrl;
if substr(drug_name,1,17)='DICLOFENAC SODIUM' or substr(drug_name,1,8)='VOLTAREN';
run; *6100;
data diclo_na_inj;
set diclo_na_inj;
if ~missing(dur) and route in ('INJ','INJECTION');run; *33;
proc univariate data=diclo_na_inj;
var dur;run; *median 2 days;

data diclo_na_eye;
set an.nsaids_ctrl;
if substr(drug_name,1,17)='DICLOFENAC SODIUM' or substr(drug_name,1,8)='VOLTAREN';
run;*6100;
data diclo_na_eye;
set diclo_na_eye;
if ~missing(dur) and route in ('EYE');run; *23;
proc univariate data=diclo_na_eye;
var dur;run; *median 15 days;

data flurb;
set an.nsaids_ctrl;
if substr(drug_name,1,12)='FLURBIPROFEN' and ~missing(dur) and route in ('EYE');run; *2;
proc univariate data=flurb;
var dur;run; *median: 1.5, use 2 days;

data ibuprofen;
set an.nsaids_ctrl;
if substr(drug_name,1,9)='IBUPROFEN' and ~missing(dur) and route in ('ORAL','PO');run; *2925;
proc univariate data=ibuprofen;
var dur;run; *median 7 days;

data indomethacin;
set an.nsaids_ctrl;
if substr(drug_name,1,12)='INDOMETHACIN' and ~missing(dur) and route in ('RECTAL');run; *32;
proc univariate data=indomethacin;
var dur;run; *median 3 days;

data naproxen;
set an.nsaids_ctrl;
if substr(drug_name,1,8)='NAPROXEN' and ~missing(dur) and route in ('ORAL','PO');run; *3240;
proc univariate data=naproxen;
var dur;run; *median 7 days;

data olfen;
set an.nsaids_ctrl;
if substr(drug_name,1,5)='OLFEN' or substr(drug_name,1,17)='DICLOFENAC SODIUM';
run; *6080;
data olfen;
set olfen;
if ~missing(dur) and route in ('LA');run; *0;
data olfen;
set an.nsaids_ctrl;
if substr(drug_name,1,5)='OLFEN' or substr(drug_name,1,17)='DICLOFENAC SODIUM';
run; *6080;
data olfen;
set olfen;
if ~missing(dur);run; *6043;
proc univariate data=olfen;
var dur;run; *median 14 days;

data piroxican_top;
set an.nsaids_ctrl;
if substr(drug_name,1,9)='PIROXICAM' and ~missing(dur) and route in ('LA', 'TOPICAL');run; *22;
proc univariate data=piroxican_top;
var dur;run; *median 71 days;

data piroxican_oral;
set an.nsaids_ctrl;
if substr(drug_name,1,9)='PIROXICAM' and ~missing(dur) and route in ('PO', 'ORAL');run; *389;
proc univariate data=piroxican_oral;
var dur;run; *median 21 days;

data proglumetacin;
set an.nsaids_ctrl;
if substr(drug_name,1,13)='PROGLUMETACIN' and ~missing(dur) and route in ('LA', 'TOPICAL');run; *3';
proc univariate data=proglumetacin;
var dur;run; *median 43 days;

data an.nsaids_ctrl;
set an.nsaids_ctrl;
if substr(drug_name,1,8)='CELEBREX' and missing(dur) and route in ('ORAL','PO') then f_dur=28;
if substr(drug_name,1,26)='DICLOFENAC DIETHYLAMMONIUM' and missing(dur) and route in ('LA', 'TOPICAL') then f_dur=56;
if substr(drug_name,1,17)='DICLOFENAC SODIUM' and missing(dur) and route in ('ORAL','PO') then f_dur=14;
if substr(drug_name,1,17)='DICLOFENAC SODIUM' and missing(dur) and route in ('INJ','INJECTION') then f_dur=2;
if substr(drug_name,1,17)='DICLOFENAC SODIUM' and missing(dur) and route in ('EYE') then f_dur=15;
if substr(drug_name,1,12)='FLURBIPROFEN' and missing(dur) and route in ('EYE')then f_dur=2;
if substr(drug_name,1,9)='IBUPROFEN' and missing(dur) and route in ('ORAL','PO') then f_dur=7;
if substr(drug_name,1,12)='INDOMETHACIN' and missing(dur) and route in ('RECTAL') then f_dur=3;
if substr(drug_name,1,8)='NAPROXEN' and missing(dur) and route in ('ORAL','PO') then f_dur=7;
if substr(drug_name,1,5)='OLFEN' and missing(dur) and route in ('LA') then f_dur=14;
if substr(drug_name,1,9)='PIROXICAM' and missing(dur) and route in ('LA', 'TOPICAL') then f_dur=71;
if substr(drug_name,1,9)='PIROXICAM' and missing(dur) and route in ('PO', 'ORAL') then f_dur=21;
if substr(drug_name,1,13)='PROGLUMETACIN' and missing(dur) and route in ('LA', 'TOPICAL') then f_dur=43;
run;
data an.nsaids_ctrl;
set an.nsaids_ctrl;
if missing(dur) then rxen=rxst+f_dur-1; format rxen yymmdd10.;
run;
data a;
set an.nsaids_ctrl;
if missing(rxen);run; *0;
data an.nsaids_ctrol_o30;
set an.nsaids_ctrl;run; *after overlapping 8509;
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
%consec30d(max=120, input=an.nsaids_ctrol_o30, patid=reference_key, rxst=rxst, rxen=rxen);

*clarithromycin;
data clarith_all;
set an.clarith_ppimi an.clarith_ctrl_o7;
run; *1970;
proc sql;
create table ctc_clarith_1 as
select * from m.ctc_rw1 A left join (select rxst as cl_rxst, rxen as cl_rxen from clarith_all B)
on A.reference_key=B.reference_key;
quit; *141103;
data ctc_clarith_1;
set ctc_clarith_1;
if cc_pst<=cl_rxst<=cc_pen or cc_pst<=cl_rxen<=cc_pen or cl_rxst<=cc_pst<=cl_rxen or cl_rxst<=cc_pen<=cl_rxen then clar=1;
else clar=0;run;
proc sort data=ctc_clarith_1;
by reference_key rw cc_pst mi decending clar;
run;
proc sort data=ctc_clarith_1 nodupkey;
by reference_key rw cc_pst mi;
run;*135930;

/*NSAIDS*/
data nsaids_all;
set an.nsaids_ppimi an.nsaids_ctrol_o30;
run; *14651;
proc sql;
create table ctc_ns_1 as
select * from ctc_clarith_1 A left join (select rxst as ns_rxst, rxen as ns_rxen from nsaids_all B)
on A.reference_key=B.reference_key;
quit; *545741;
data ctc_ns_1;
set ctc_ns_1;
if cc_pst<=ns_rxst<=cc_pen or cc_pst<=ns_rxen<=cc_pen or ns_rxst<=cc_pst<=ns_rxen or ns_rxst<=cc_pen<=ns_rxen then ns=1;
else ns=0;run;
proc sort data=ctc_ns_1;
by reference_key rw cc_pst mi decending ns;
run;
proc sort data=ctc_ns_1 nodupkey;
by reference_key rw cc_pst mi;
run;*135930 ok;

data m.ctc_adj_rw1;
set ctc_ns_1;
run;

*Perfom conditional logistic regression
using those three drugs as covariates, adding interaction terms;
PROC LOGISTIC data = m.ctc_adj_rw1;
model rw  (EVENT='1')= exp clar ns exp*mi clar*mi ns*mi/ expb;
strata reference_key;
run; 
*Analysis of Maximum Likelihood Estimates 
Parameter DF Estimate Standard
Error Wald
Chi-Square Pr > ChiSq Exp(Est) 
exp 1 0.9742 0.1546 39.7091 <.0001 2.649 
clar 1 0.5679 0.6050 0.8811 0.3479 1.764 
ns 1 -0.0996 0.2018 0.2438 0.6215 0.905 
exp*mi 1 1.9493 0.2063 89.2430 <.0001 7.024 
clar*mi 1 1.9187 0.7845 5.9812 0.0145 6.812 
ns*mi 1 -0.2717 0.3242 0.7020 0.4021 0.762 
;

/*********************************************
*********************************************
Risk window 2********************************
*********************************************
*********************************************/

proc sql;
create table ctc_clarith_2 as
select * from m.ctc_rw2 A left join (select rxst as cl_rxst, rxen as cl_rxen from clarith_all B)
on A.reference_key=B.reference_key;
quit; *148488;
data ctc_clarith_2;
set ctc_clarith_2;
if cc_pst<=cl_rxst<=cc_pen or cc_pst<=cl_rxen<=cc_pen or cl_rxst<=cc_pst<=cl_rxen or cl_rxst<=cc_pen<=cl_rxen then clar=1;
else clar=0;run;
proc sort data=ctc_clarith_2;
by reference_key rw cc_pst mi decending clar;
run;
proc sort data=ctc_clarith_2 nodupkey;
by reference_key rw cc_pst mi;
run;*142992, ok;

/*NSAIDS*/
proc sql;
create table ctc_ns_2 as
select * from ctc_clarith_2 A left join (select rxst as ns_rxst, rxen as ns_rxen from nsaids_all B)
on A.reference_key=B.reference_key;
quit; *651732;
data ctc_ns_2;
set ctc_ns_2;
if cc_pst<=ns_rxst<=cc_pen or cc_pst<=ns_rxen<=cc_pen or ns_rxst<=cc_pst<=ns_rxen or ns_rxst<=cc_pen<=ns_rxen then ns=1;
else ns=0;run;
proc sort data=ctc_ns_2;
by reference_key rw cc_pst mi decending ns;
run;
proc sort data=ctc_ns_2 nodupkey;
by reference_key rw cc_pst mi;
run;*142992;

data m.ctc_adj_rw2;
set ctc_ns_2;
run;
*Perfom conditional logistic regression
using those three drugs as covariates, adding interaction terms;
PROC LOGISTIC data = m.ctc_adj_rw2;
model rw  (EVENT='2')= exp clar ns exp*mi clar*mi ns*mi/ expb;
strata reference_key;
run; 
*Analysis of Maximum Likelihood Estimates 
Parameter DF Estimate Standard
Error Wald
Chi-Square Pr > ChiSq Exp(Est) 
exp 1 0.7518 0.1691 19.7594 <.0001 2.121 
clar 1 1.0430 0.5199 4.0249 0.0448 2.838 
ns 1 0.0835 0.1841 0.2058 0.6501 1.087 
exp*mi 1 1.5093 0.2311 42.6534 <.0001 4.523 
clar*mi 1 -1.2037 0.7152 2.8327 0.0924 0.300 
ns*mi 1 -0.2720 0.3051 0.7947 0.3727 0.762  ;

/*********************************************
*********************************************
Risk window 3********************************
*********************************************
*********************************************/

proc sql;
create table ctc_clarith_3 as
select * from m.ctc_rw3 A left join (select rxst as cl_rxst, rxen as cl_rxen from clarith_all B)
on A.reference_key=B.reference_key;
quit; *;
data ctc_clarith_3;
set ctc_clarith_3;
if cc_pst<=cl_rxst<=cc_pen or cc_pst<=cl_rxen<=cc_pen or cl_rxst<=cc_pst<=cl_rxen or cl_rxst<=cc_pen<=cl_rxen then clar=1;
else clar=0;run;
proc sort data=ctc_clarith_3;
by reference_key rw cc_pst mi decending clar;
run;
proc sort data=ctc_clarith_3 nodupkey;
by reference_key rw cc_pst mi;
run;*187956, ok;

/*NSAIDS*/
proc sql;
create table ctc_ns_3 as
select * from ctc_clarith_3 A left join (select rxst as ns_rxst, rxen as ns_rxen from nsaids_all B)
on A.reference_key=B.reference_key;
quit; *;
data ctc_ns_3;
set ctc_ns_3;
if cc_pst<=ns_rxst<=cc_pen or cc_pst<=ns_rxen<=cc_pen or ns_rxst<=cc_pst<=ns_rxen or ns_rxst<=cc_pen<=ns_rxen then ns=1;
else ns=0;run;
proc sort data=ctc_ns_3;
by reference_key rw cc_pst mi decending ns;
run;
proc sort data=ctc_ns_3 nodupkey;
by reference_key rw cc_pst mi;
run;*187956;

data m.ctc_adj_rw3;
set ctc_ns_3;
run;
*Perfom conditional logistic regression
using those three drugs as covariates, adding interaction terms;
PROC LOGISTIC data = m.ctc_adj_rw3;
model rw  (EVENT='3')= exp clar ns exp*mi clar*mi ns*mi/ expb;
strata reference_key;
run; 
*Analysis of Maximum Likelihood Estimates 
Parameter DF Estimate Standard
Error Wald 
Chi-Square Pr > ChiSq Exp(Est) 
exp 1 0.3571 0.2033 3.0839 0.0791 1.429 
clar 1 1.1923 0.3678 10.5063 0.0012 3.295 
ns 1 -0.0271 0.1434 0.0358 0.8499 0.973 
exp*mi 1 1.2070 0.2729 19.5553 <.0001 3.343 
clar*mi 1 -0.9603 0.5674 2.8643 0.0906 0.383 
ns*mi 1 -0.1334 0.2399 0.3090 0.5783 0.875 ;


/****************************************************
***************************************************
Sensitivity analysis that considering NSAIDS as a whole group
****************************************************
****************************************************/
data an.nsaids_ctrl;
set an.nsaids_ctrl;
ns_nid=_n_;run;
proc sql;
create table an.ns_ctrl_high as
select * from an.nsaids_ctrl where drug_name like '%CATAFLAM%'
or drug_name like '%VOLTAREN%'
or drug_name like '%DICLOFENAC%'
or drug_name like '%ROFECOXIB%'
or drug_name like '%VIOXX%';quit; *6983;
proc sql;
create table an.ns_ctrl_low as
select * from an.nsaids_ctrl where ns_nid not in (select ns_nid from an.ns_ctrl_high);
quit; *8764;
data an.ns_ctrl_high;set an.ns_ctrl_high;drop ns_nid;run;
data an.ns_ctrl_low;set an.ns_ctrl_low;drop ns_nid;run;
proc freq data=an.ns_ctrl_low;
table drug_name;run;
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
%consec30d(max=60, input=an.ns_ctrl_high, patid=reference_key, rxst=rxst, rxen=rxen);
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
%consec30d(max=60, input=an.ns_ctrl_low, patid=reference_key, rxst=rxst, rxen=rxen);

*clarithromycin;
data clarith_all;
set an.clarith_ppimi an.clarith_ctrl_o7;
run; *2596;
proc sql;
create table ctc_clarith_1 as
select * from m.ctc_rw1 A left join (select rxst as cl_rxst, rxen as cl_rxen from clarith_all B)
on A.reference_key=B.reference_key;
quit; *154881;
data ctc_clarith_1;
set ctc_clarith_1;
if cc_pst<=cl_rxst<=cc_pen or cc_pst<=cl_rxen<=cc_pen or cl_rxst<=cc_pst<=cl_rxen or cl_rxst<=cc_pen<=cl_rxen then clar=1;
else clar=0;run;
proc sort data=ctc_clarith_1;
by reference_key rw cc_pst mi decending clar;
run;
proc sort data=ctc_clarith_1 nodupkey;
by reference_key rw cc_pst mi;
run;*139732;

/*NSAIDS high risk*/
data nsaids_high_all;
set an.nsaids_high an.ns_ctrl_high;
run; *5697;
proc sql;
create table ctc_nsh_1 as
select * from ctc_clarith_1 A left join (select rxst as nsh_rxst, rxen as nsh_rxen from nsaids_high_all B)
on A.reference_key=B.reference_key;
quit; *276144;
data ctc_nsh_1;
set ctc_nsh_1;
if cc_pst<=nsh_rxst<=cc_pen or cc_pst<=nsh_rxen<=cc_pen or nsh_rxst<=cc_pst<=nsh_rxen or nsh_rxst<=cc_pen<=nsh_rxen then nsh=1;
else nsh=0;run;
proc sort data=ctc_nsh_1;
by reference_key rw cc_pst mi decending nsh;
run;
proc sort data=ctc_nsh_1 nodupkey;
by reference_key rw cc_pst mi;
run;*139732 ok;

/*NSAIDS low risk*/
data nsaids_low_all;
set an.nsaids_low an.ns_ctrl_low;
run; *8421;
proc sql;
create table ctc_nsl_1 as
select * from ctc_nsh_1 A left join (select rxst as nsl_rxst, rxen as nsl_rxen from nsaids_low_all B)
on A.reference_key=B.reference_key;
quit; *332401;
data ctc_nsl_1;
set ctc_nsl_1;
if cc_pst<=nsl_rxst<=cc_pen or cc_pst<=nsl_rxen<=cc_pen or nsl_rxst<=cc_pst<=nsl_rxen or nsl_rxst<=cc_pen<=nsl_rxen then nsl=1;
else nsl=0;run;
proc sort data=ctc_nsl_1;
by reference_key rw cc_pst mi decending nsl;
run;
proc sort data=ctc_nsl_1 nodupkey;
by reference_key rw cc_pst mi;
run;*139732 ok;

data m.ctc_adj_rw1_sen;
set ctc_nsl_1;
run;
*Perfom conditional logistic regression
using those three drugs as covariates, adding interaction terms;
PROC LOGISTIC data = m.ctc_adj_rw1_sen;
model rw  (EVENT='1')= exp clar nsh nsl exp*mi exp*clar exp*nsh exp*nsl clar*mi nsh*mi nsl*mi/ expb;
strata reference_key;
run; 
*
;

/*********************************************
*********************************************
Risk window 2********************************
*********************************************
*********************************************/

proc sql;
create table ctc_clarith_2 as
select * from m.ctc_rw2 A left join (select rxst as cl_rxst, rxen as cl_rxen from clarith_all B)
on A.reference_key=B.reference_key;
quit; *163613;
data ctc_clarith_2;
set ctc_clarith_2;
if cc_pst<=cl_rxst<=cc_pen or cc_pst<=cl_rxen<=cc_pen or cl_rxst<=cc_pst<=cl_rxen or cl_rxst<=cc_pen<=cl_rxen then clar=1;
else clar=0;run;
proc sort data=ctc_clarith_2;
by reference_key rw cc_pst mi decending clar;
run;
proc sort data=ctc_clarith_2 nodupkey;
by reference_key rw cc_pst mi;
run;*147761, ok;

/*NSAIDS high risk*/
proc sql;
create table ctc_nsh_2 as
select * from ctc_clarith_2 A left join (select rxst as nsh_rxst, rxen as nsh_rxen from nsaids_high_all B)
on A.reference_key=B.reference_key;
quit; *289540;
data ctc_nsh_2;
set ctc_nsh_2;
if cc_pst<=nsh_rxst<=cc_pen or cc_pst<=nsh_rxen<=cc_pen or nsh_rxst<=cc_pst<=nsh_rxen or nsh_rxst<=cc_pen<=nsh_rxen then nsh=1;
else nsh=0;run;
proc sort data=ctc_nsh_2;
by reference_key rw cc_pst mi decending nsh;
run;
proc sort data=ctc_nsh_2 nodupkey;
by reference_key rw cc_pst mi;
run;*147761 ok;

/*NSAIDS low risk*/
proc sql;
create table ctc_nsl_2 as
select * from ctc_nsh_2 A left join (select rxst as nsl_rxst, rxen as nsl_rxen from nsaids_low_all B)
on A.reference_key=B.reference_key;
quit; *352043;
data ctc_nsl_2;
set ctc_nsl_2;
if cc_pst<=nsl_rxst<=cc_pen or cc_pst<=nsl_rxen<=cc_pen or nsl_rxst<=cc_pst<=nsl_rxen or nsl_rxst<=cc_pen<=nsl_rxen then nsl=1;
else nsl=0;run;
proc sort data=ctc_nsl_2;
by reference_key rw cc_pst mi decending nsl;
run;
proc sort data=ctc_nsl_2 nodupkey;
by reference_key rw cc_pst mi;
run;*147761 ok;

data m.ctc_adj_rw2_sen;
set ctc_nsl_2;
run;

*Perfom conditional logistic regression
using those three drugs as covariates, adding interaction terms;
PROC LOGISTIC data = m.ctc_adj_rw2_sen;
model rw  (EVENT='2')= exp clar nsh nsl exp*mi exp*clar exp*nsh exp*nsl clar*mi nsh*mi nsl*mi/ expb;
strata reference_key;
run; 
*;

/*********************************************
*********************************************
Risk window 3********************************
*********************************************
*********************************************/

proc sql;
create table ctc_clarith_3 as
select * from m.ctc_rw3 A left join (select rxst as cl_rxst, rxen as cl_rxen from clarith_all B)
on A.reference_key=B.reference_key;
quit; *229140;
data ctc_clarith_3;
set ctc_clarith_3;
if cc_pst<=cl_rxst<=cc_pen or cc_pst<=cl_rxen<=cc_pen or cl_rxst<=cc_pst<=cl_rxen or cl_rxst<=cc_pen<=cl_rxen then clar=1;
else clar=0;run;
proc sort data=ctc_clarith_3;
by reference_key rw cc_pst mi decending clar;
run;
proc sort data=ctc_clarith_3 nodupkey;
by reference_key rw cc_pst mi;
run;*204516, ok;

/*NSAIDS high risk*/
proc sql;
create table ctc_nsh_3 as
select * from ctc_clarith_3 A left join (select rxst as nsh_rxst, rxen as nsh_rxen from nsaids_high_all B)
on A.reference_key=B.reference_key;
quit; *402083;
data ctc_nsh_3;
set ctc_nsh_3;
if cc_pst<=nsh_rxst<=cc_pen or cc_pst<=nsh_rxen<=cc_pen or nsh_rxst<=cc_pst<=nsh_rxen or nsh_rxst<=cc_pen<=nsh_rxen then nsh=1;
else nsh=0;run;
proc sort data=ctc_nsh_3;
by reference_key rw cc_pst mi decending nsh;
run;
proc sort data=ctc_nsh_3 nodupkey;
by reference_key rw cc_pst mi;
run;*204516 ok;

/*NSAIDS low risk*/
proc sql;
create table ctc_nsl_3 as
select * from ctc_nsh_3 A left join (select rxst as nsl_rxst, rxen as nsl_rxen from nsaids_low_all B)
on A.reference_key=B.reference_key;
quit; *493825;
data ctc_nsl_3;
set ctc_nsl_3;
if cc_pst<=nsl_rxst<=cc_pen or cc_pst<=nsl_rxen<=cc_pen or nsl_rxst<=cc_pst<=nsl_rxen or nsl_rxst<=cc_pen<=nsl_rxen then nsl=1;
else nsl=0;run;
proc sort data=ctc_nsl_3;
by reference_key rw cc_pst mi decending nsl;
run;
proc sort data=ctc_nsl_3 nodupkey;
by reference_key rw cc_pst mi;
run;*204516 ok;

data m.ctc_adj_rw3_sen;
set ctc_nsl_3;
run;
*Perfom conditional logistic regression
using those three drugs as covariates, adding interaction terms;
PROC LOGISTIC data = m.ctc_adj_rw3_sen;
model rw  (EVENT='3')= exp clar nsh nsl exp*mi exp*clar exp*nsh exp*nsl clar*mi nsh*mi nsl*mi/ expb;
strata reference_key;
run; 

/*updated on 31 Oct 2016
Purpose: to use H2 blocker as the negative exposure tracer for case-time-control analysis*/

*identify H2 blockers;
proc sql;
create table an.h2_ctrl as
select * from an.control_alldrug_all where 
Therapeutic_Classification__BNF_ like '1.3.1%'
or Drug_Name like 'BELLASED %' or Drug_Name like 'BIGACON %' or Drug_Name like 'CEMENTIN %' or Drug_Name like 'CIMEDIN %' or Drug_Name like 'CIMEDINE %' 
or Drug_Name like 'CIMETA %' or Drug_Name like 'CIMETAB %' or Drug_Name like 'CIMETAX %' or Drug_Name like 'CIMULCER %' or Drug_Name like 'CITIDINE %' 
or Drug_Name like 'CIWEI %' or Drug_Name like 'CLINIMET %' or Drug_Name like 'COBOWEI %' or Drug_Name like 'DEFENSE %' or Drug_Name like 'GASTAB %' 
or Drug_Name like 'GASTROCIME %' or Drug_Name like 'GINOMIN %' or Drug_Name like 'HEALING-U %' or Drug_Name like 'HEALING U %' or Drug_Name like 'HEALINGU %' 
or Drug_Name like 'HOU WE MING %' or Drug_Name like 'LOTIDINE %' or Drug_Name like 'MAGICUL %' or Drug_Name like 'MARITIDINE %' or Drug_Name like 'MARTINDALE %' 
or Drug_Name like 'MEGADIN %' or Drug_Name like 'NEO-ULCERGEN %' or Drug_Name like 'NEOULCERGEN %' or Drug_Name like 'NEO ULCERGEN %'  or Drug_Name like 'NICE-NULCER %' 
or Drug_Name like 'NICENULCER %' or Drug_Name like 'NICE NULCER %'  or Drug_Name like 'NULCER %' or Drug_Name like 'NURODIN %' or Drug_Name like 'SHINTAMET %' 
or Drug_Name like 'SIMAGLEN %' or Drug_Name like 'STOGAMET %' or Drug_Name like 'STOMCAP %' or Drug_Name like 'SUPER STOMACH %' 
or Drug_Name like 'SYNCOMET %' or Drug_Name like 'SYNGAMET %' or Drug_Name like 'TAGAMET %' or Drug_Name like 'TALADINE %' or Drug_Name like 'TALAMIN FORTE %' 
or Drug_Name like 'TAMEDIN %' or Drug_Name like 'TIMODEX %' or Drug_Name like 'TOBETIDINE %' or Drug_Name like 'UCIDINE %' or Drug_Name like 'ULCERGEN %' 
or Drug_Name like 'ULCERIN %' or Drug_Name like 'ULCIME %' or Drug_Name like 'ULCIMET %' or Drug_Name like 'ULCOMET %' or Drug_Name like 'ULSIKUR %' 
or Drug_Name like 'ULTIPUS %' or Drug_Name like 'WETIDINE %' or Drug_Name like 'XEPAMET %'
or Drug_Name like 'AULZADIN %' or Drug_Name like 'AUSFAM %' or Drug_Name like 'BALHOA %' or Drug_Name like 'BEILANDE %' or Drug_Name like 'COSODINE %' 
or Drug_Name like 'DIGESTONE %' or Drug_Name like 'FACID %' or Drug_Name like 'FAD %' or Drug_Name like 'FADIN %' or Drug_Name like 'FAMAK %' or Drug_Name like 'FAMINE %' 
or Drug_Name like 'FAMO %' or Drug_Name like 'FAMOCED %' or Drug_Name like 'FAMOCEED %' or Drug_Name like 'FAMODINE %' or Drug_Name like 'FAMOL %' 
or Drug_Name like 'FAMOLTA %' or Drug_Name like 'FAMONOX %' or Drug_Name like 'FAMOSTER %' or Drug_Name like 'FAMOTAB %' 
or Drug_Name like 'FAMOTIDINA %' or Drug_Name like 'FAMOTIN %' or Drug_Name like 'FAMOXINE %' or Drug_Name like 'FAMTINE %' or Drug_Name like 'FARADIN %' or Drug_Name like 'GARADINE %' 
or Drug_Name like 'GASTRIK %' or Drug_Name like 'INTERFAM %' or Drug_Name like 'KEAMOTIN %' or Drug_Name like 'MARMODINE %' or Drug_Name like 'MK-208 %' or Drug_Name like 'MOTIDINE %' 
or Drug_Name like 'PECODINE %' or Drug_Name like 'PEDINE %' or Drug_Name like 'PEPDENAL %' or Drug_Name like 'PEPTICIN %' or Drug_Name like 'PEPZAN %' or Drug_Name like 'PERADINE %' 
or Drug_Name like 'PHYZIDINE %' or Drug_Name like 'STOM-A %' 
or Drug_Name like 'STOMA %' or Drug_Name like 'STOM A %' or Drug_Name like 'STOMAX %' or Drug_Name like 'TOBEFAM %' or Drug_Name like 'ULANCE %' or Drug_Name like 'ULARANCE  %'
or Drug_Name like 'ACIEND %' or Drug_Name like 'AMRATIDINE %' or Drug_Name like 'EMTAC %' or Drug_Name like 'EPADOREN %' or Drug_Name like 'EPIRANT %' or Drug_Name like 'EUROTAC %' 
or Drug_Name like 'FILMETAC %' or Drug_Name like 'GAITIDINE %' or Drug_Name like 'GLO-TAC %' or Drug_Name like 'GLOTAC %' or Drug_Name like 'GLO TAC %' or Drug_Name like 'HYZAN %' 
or Drug_Name like 'KANACID %' or Drug_Name like 'KIN PAK %' or Drug_Name like 'LUMERAN %' or Drug_Name like 'NEO-TAC %' or Drug_Name like 'NEOTAC %' or Drug_Name like 'NEO TAC %' 
or Drug_Name like 'NICE TIDINE %' or Drug_Name like 'NICE VICTOR %' 
or Drug_Name like 'PRIME %' or Drug_Name like 'PTINOLIN %' or Drug_Name like 'QUICRAN %' or Drug_Name like 'RANATEC %' or Drug_Name like 'RANIDINE %' or Drug_Name like 'RANIPLEX %' 
or Drug_Name like 'RANITAC %' or Drug_Name like 'RANITAL %' or Drug_Name like 'RANITID %' or Drug_Name like 'RANITIDINA %' or Drug_Name like 'RANOLTA %' or Drug_Name like 'RANTACID %' 
or Drug_Name like 'RANTIN %' or Drug_Name like 'RATIC %' or Drug_Name like 'RAWELO %' or Drug_Name like 'RENTSAN %' or Drug_Name like 'RESTOPON %' or Drug_Name like 'SIMETAC %' 
or Drug_Name like 'STOMACHAL %' or Drug_Name like 'STOMWELL %' 
or Drug_Name like 'SUPER PRO %' or Drug_Name like 'TUPAST %' or Drug_Name like 'ULCERNIL %' or Drug_Name like 'ULTAC %' or Drug_Name like 'ULTICER %' or Drug_Name like 'UNI-RANTAC %' 
or Drug_Name like 'UNIRANTAC %'  or Drug_Name like 'UNI RANTAC %' or Drug_Name like 'VESYCA %' or Drug_Name like 'WAH TAT %' or Drug_Name like 'WEICOTAC %' or Drug_Name like 'WEIDOS %' 
or Drug_Name like 'WONTAC %' or Drug_Name like 'XANAGAS %' or Drug_Name like 'ZANTAC %' or Drug_Name like 'ZANTICAINE %' or Drug_Name like 'ZARATON %' or Drug_Name like 'ZENDHIN %' or Drug_Name like 'ZYNOL %'
or Drug_Name like '%CIMETIDINE%' or Drug_Name like '%FAMOTIDINE%' or Drug_Name like '%NIZATIDINE%' or Drug_Name like '%RANITIDINE%';
quit; *51742;
proc freq data=an.h2_ctrl;
table drug_name;
run;
data an.h2_ctrl;
set an.h2_ctrl;
rxst=input(Prescription_Start_Date, yymmdd10.);
rxen=input(Prescription_End_Date, yymmdd10.);
dur=rxen-rxst+1;
format rxst rxen yymmdd10.;
run; *51742;
/*find prescription duration*/
data an.h2_ctrl;
set an.h2_ctrl;
dis_d=input(Dispensing_Date__yyyy_mm_dd_, yymmdd10.);
format dis_d yymmdd10.;
if missing(Prescription_Start_Date) then rxst=dis_d;
run;
data a;
set an.h2_ctrl;
if ~missing(dur) and dur<0;
run; *0;
data missingdur;
set an.h2_ctrl;
if missing(rxen);run; *1156;
proc freq data=missingdur;
table Dosage;run;
data an.h2_ctrl;
set an.h2_ctrl;
if substr(Dosage,1,6)="0.5 TA" then h2_dosage=0.5;
if substr(Dosage,1,3)="1 N" then h2_dosage=1;
if substr(Dosage,1,7)="1    NO" then h2_dosage=1;
if substr(Dosage,1,5)="1   (" then h2_dosage=1;
if substr(Dosage,1,7)="1    TA" then h2_dosage=1;
if substr(Dosage,1,5)="1 TAB" then h2_dosage=1;
if substr(Dosage,1,3)="1 (" then h2_dosage=1;
if substr(Dosage,1,9)="1 100M NO" then h2_dosage=1;
if substr(Dosage,1,3)="1 C" then h2_dosage=1;
if substr(Dosage,1,4)="2 TA" then h2_dosage=2;
if substr(Dosage,1,7)="2    TA" then h2_dosage=2;
if substr(Dosage,1,4)="5 TA" then h2_dosage=5;
run; *FOR DOSAGE IS 2ML, OTHER DRUG DURATION IS 4 DAYS CAN'T ESTIMATE, JUST USE THE MEDIAN TO ESTIMATE;
proc freq data=missingdur;
table Drug_Frequency;run;
data an.h2_ctrl;
set an.h2_ctrl;
if substr(Drug_Frequency,1,2)="AT" then h2_ndd=1;
if substr(Drug_Frequency,1,12)="ON ALTERNATE" then h2_ndd=0.5;
if substr(Drug_Frequency,1,2)="IN" then h2_ndd=1;
if substr(Drug_Frequency,1,3)="DAI" then h2_ndd=1;
if substr(Drug_Frequency,1,11)="EVERY EIGHT" then h2_ndd=3;
if substr(Drug_Frequency,1,10)="EVERY FOUR" then h2_ndd=6;
if substr(Drug_Frequency,1,10)="EVERY SIX" then h2_ndd=4;
if substr(Drug_Frequency,1,10)="EVERY TWEL" then h2_ndd=2;
if substr(Drug_Frequency,1,10)="EVERY TWEN" then h2_ndd=1;
if substr(Drug_Frequency,1,10)="EVERY THIR" then h2_ndd=0.67;
if substr(Drug_Frequency,1,9)="EVERY TWO" then h2_ndd=12;
if substr(Drug_Frequency,1,4)="FOUR" then h2_ndd=4;
if substr(Drug_Frequency,1,4)="ONCE" then h2_ndd=1;
if substr(Drug_Frequency,1,3)="SIX" then h2_ndd=6;
if substr(Drug_Frequency,1,3)="THR" then h2_ndd=3;
if substr(Drug_Frequency,1,5)="TWICE" then h2_ndd=2; run;
data an.h2_ctrl;
set an.h2_ctrl;
if missing(rxen) then do;
dur=Quantity__Named_Patient_/h2_ndd/h2_dosage;
rxen=rxst+dur-1; format rxen yymmdd10.;
end;
run;
data no_miss_dur;
set an.h2_ctrl;
if ~missing(rxen);
run;
proc univariate data=no_miss_dur;
var dur;run; *median: 28d;
data an.h2_ctrl;
set an.h2_ctrl;
if missing(dur) then f_dur=28;
else f_dur=dur;run;
data an.h2_ctrl;
set an.h2_ctrl;
if missing(dur) then rxen=rxst+f_dur-1; format rxen yymmdd10.;
run;
data a;
set an.h2_ctrl;
if missing(rxen);run; *0; 
data an.h2_ctrl_o;
set an.h2_ctrl;
run;*51742;
/*make sure the scripts within their observation period*/
proc sql;
create table h2_ctrl_o as
select * from an.h2_ctrl_o A left join (select stst_ctrl as st_st, sten_ctrl as st_en from m.match_all B)
on A.reference_key=B.reference_key_ctrl;
quit; *51742;
data h2_ctrl_o;
set h2_ctrl_o;
if rxst>st_en or rxen<st_st then delete;
if rxst<st_st then rxst=st_st;
if rxen>st_en then rxen=st_en;run; * 49373, after overlap:8791 ;
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
%consec30d(max=200, input=h2_ctrl_o, patid=reference_key, rxst=rxst, rxen=rxen);

data h2_overlap_ctc;
set an.h2_ppimi;
run; *43456;
proc sort data=m.match_all nodupkey out=case_hc;
by reference_key;
run;
proc sql;
create table h2_overlap_ctc as
select * from h2_overlap_ctc A left join (select st_st, st_en from case_hc B)
on A.reference_key=B.reference_key;
quit; *43456;
data h2_overlap_ctc;
set h2_overlap_ctc;
if missing(st_st) or missing(st_en) then delete;
if rxst>st_en or rxen<st_st then delete;
if rxst<st_st then rxst=st_st;
if rxen>st_en then rxen=st_en;run; *11720, after overlap: 1907;
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
%consec30d(max=110, input=h2_overlap_ctc, patid=reference_key, rxst=rxst, rxen=rxen);
*H2 Blocker;
data h2_all;
set h2_ctrl_o h2_overlap_ctc;*an.h2_ppimi from SCCS negative exposure;
run; *10698;
proc sort data=h2_ctrl_o;
by reference_key rxst rxen;
run;

proc sql;
create table ctc_h2_1 as
select * from m.ctc_rw1 A left join (select rxst as h2_rxst, rxen as h2_rxen from h2_all B)
on A.reference_key=B.reference_key;
quit; *;
data ctc_h2_1;
set ctc_h2_1;
if cc_pst<=h2_rxst<=cc_pen or cc_pst<=h2_rxen<=cc_pen or h2_rxst<=cc_pst<=h2_rxen or h2_rxst<=cc_pen<=h2_rxen then h2b=1;
else h2b=0;run;
proc sort data=ctc_h2_1;
by reference_key rw cc_pst mi decending h2b;
run;
proc sort data=ctc_h2_1 nodupkey out=m.ctc_h2_1;
by reference_key rw cc_pst mi;
run;*135930;

*Perfom conditional logistic regression
using H2 drugs as covariate, adding interaction terms;
PROC LOGISTIC data = m.ctc_h2_1;
model rw  (EVENT='1')= h2b exp exp*mi h2b*mi/ expb;
strata reference_key;
run; 
*Analysis of Maximum Likelihood Estimates 
Parameter DF Estimate Standard
Error Wald
Chi-Square Pr > ChiSq Exp(Est) 

;
/*********************************************
*********************************************
Risk window 2********************************
*********************************************
*********************************************/

proc sql;
create table ctc_h2_2 as
select * from m.ctc_rw2 A left join (select rxst as h2_rxst, rxen as h2_rxen from h2_all B)
on A.reference_key=B.reference_key;
quit; *;
data ctc_h2_2;
set ctc_h2_2;
if cc_pst<=h2_rxst<=cc_pen or cc_pst<=h2_rxen<=cc_pen or h2_rxst<=cc_pst<=h2_rxen or h2_rxst<=cc_pen<=h2_rxen then h2b=1;
else h2b=0;run;
proc sort data=ctc_h2_2;
by reference_key rw cc_pst mi decending h2b;
run;
proc sort data=ctc_h2_2 nodupkey out=m.ctc_h2_2;
by reference_key rw cc_pst mi;
run;*142992, ok;

*Perfom conditional logistic regression
using H2 drugs as covariate, adding interaction terms;
PROC LOGISTIC data = m.ctc_h2_2;
model rw  (EVENT='2')= h2b exp exp*mi h2b*mi/ expb;
strata reference_key;
run; 
*Analysis of Maximum Likelihood Estimates 
Parameter DF Estimate Standard
Error Wald


 ;

/*********************************************
*********************************************
Risk window 3********************************
*********************************************
*********************************************/

proc sql;
create table ctc_h2_3 as
select * from m.ctc_rw3 A left join (select rxst as h2_rxst, rxen as h2_rxen from h2_all B)
on A.reference_key=B.reference_key;
quit; *;
data ctc_h2_3;
set ctc_h2_3;
if cc_pst<=h2_rxst<=cc_pen or cc_pst<=h2_rxen<=cc_pen or h2_rxst<=cc_pst<=h2_rxen or h2_rxst<=cc_pen<=h2_rxen then h2b=1;
else h2b=0;run;
proc sort data=ctc_h2_3;
by reference_key rw cc_pst mi decending h2b;
run;
proc sort data=ctc_h2_3 nodupkey out=m.ctc_h2_3;
by reference_key rw cc_pst mi;
run;*187956, ok;

*Perfom conditional logistic regression
using H2 drugs as covariate, adding interaction terms;
PROC LOGISTIC data = m.ctc_h2_3;
model rw  (EVENT='3')= exp h2b exp*mi h2b*mi/ expb;
strata reference_key;
run; 
*Analysis of Maximum Likelihood Estimates 
Parameter DF Estimate Standard
Error Wald 
Chi-Square Pr > ChiSq Exp(Est) 
 


;
