/*Created on 31 Oct 2016

Purpose: to add covariates of H2 blockers as negative exposure tracer in SCCS

cut OP PPIs risk periods:
prerisk 14 days
1-14
15-30
31-60

also cut age group 1 year for each interval

*if risk periods for each prescriptions overlap, favor pre-risk period

multiple exposure:
during treatment, mark 1, otherwise mark 0*/

libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname an "C:\Users\Angel YS Wong\Desktop\PPI\program\drug";
libname lc "C:\Users\Angel YS Wong\Desktop\PPI\program\lc";
libname ne "C:\Users\Angel YS Wong\Desktop\PPI\program\negative exposure";

/*identify H2 blockers*/
proc sql;
create table an.h2_script_inppi as
select * from an.alldrug9314 where 
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
quit; *2236798;
proc freq data=an.h2_script_inppi;
table drug_name;
run;
data h2_script_inppi;
set an.h2_script_inppi;
run;
proc sql;
delete from h2_script_inppi 
where drug_name like 'FAD SANTEN' or 
drug_name like 'FAD SANTEN OPHTHALMIC SOLUTION' or
drug_name like 'STUDY MED(RABEPRAZOLE VS FAMOTIDINE' or
drug_name like 'APH STUDY MED (FAMOTIDINE 40MG VS R';
quit;
data an.h2_script_inppi;
set h2_script_inppi;
rxst=input(Prescription_Start_Date, yymmdd10.);
rxen=input(Prescription_End_Date, yymmdd10.);
dur=rxen-rxst+1;
format rxst rxen yymmdd10.;
run; *2236789;
/*find prescription duration*/
data an.h2_script_inppi;
set an.h2_script_inppi;
dis_d=input(Dispensing_Date__yyyy_mm_dd_, yymmdd10.);
format dis_d yymmdd10.;
if missing(Prescription_Start_Date) then rxst=dis_d;
run;
data a;
set an.h2_script_inppi;
if ~missing(dur) and dur<0;
run; *0;
data missingdur;
set an.h2_script_inppi;
if missing(rxen);run; *86133;
proc freq data=missingdur;
table Dosage;run;
data h2_script_inppi;
set an.h2_script_inppi;
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
run;
proc freq data=missingdur;
table Drug_Frequency;run;
data h2_script_inppi;
set h2_script_inppi;
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
data h2_script_inppi;
set h2_script_inppi;
if substr(Drug_Frequency,1,31)="IN THE MORNING AND [1] AT NIGHT" then h2_ndd=2;
if substr(Drug_Frequency,1,28)="TWICE DAILY AND [1] AT NIGHT" then h2_ndd=3; 
run;
data h2_script_inppi;
set h2_script_inppi;
if missing(rxen) then do;
dur=Quantity__Named_Patient_/h2_ndd/h2_dosage;
rxen=rxst+dur-1; format rxen yymmdd10.;
end;
run;
data no_miss_dur;
set h2_script_inppi;
if ~missing(rxen);
run;
proc univariate data=no_miss_dur;
var dur;run; *median: 14d;
data h2_script_inppi;
set h2_script_inppi;
if missing(dur) then f_dur=14;
else f_dur=dur;run;
data h2_script_inppi;
set h2_script_inppi;
if missing(dur) then rxen=rxst+f_dur-1; format rxen yymmdd10.;
run;
data a;
set h2_script_inppi;
if missing(rxen);run; *0; 
proc sql;
create table an.h2_ppimi as
select * from h2_script_inppi where reference_key in (select reference_key from p.ppi_mi_coh1_adult);
quit; *43456;

/************************************************************************
***************************************************************************
******************************************************************************
reset the observation period by considering only outpatient scripts for other medications
******************************************************************************
******************************************************************************
*******************************************************************************/
*patients who had inpatient clarithromycin and H2;
data ip_script;
set an.h2_script_inppi;
if Type_of_Patient__Drug_='I' or Type_of_Patient__Drug_='D';
run;
data ip_script;
set ip_script;
yr_rxst=year(rxst);
run;
data ip_script;
set ip_script;
if yr_rxst<2000 then delete;
run; *1191210;

*remove patients who had inpatient script before first outpatient PPIs;
proc sql;
create table ppi_mi_op as
select *, min(ppirxst) as min_op format yymmdd10. from p.ppi_mi_coh1_adult group by reference_key;
quit;
proc sql;
create table ppi_mi_op as
select * from ppi_mi_op A left join (select rxst as ipod_rxst from ip_script B)
on A.reference_key=B.reference_key;
quit; *22048;
data rm;
set ppi_mi_op;
if ~missing(ipod_rxst) and ipod_rxst<=min_op;
run; *9685,  HC;

proc sql;
create table ppi_mi_coh1_adult_sen as
select * from p.ppi_mi_coh1_adult where reference_key not in (select reference_key from rm);
quit; *776;

*Censor the observation period if inpatient script after the first outpatient PPIs;
data ppi_ip_RC;
set ppi_mi_op;
if ~missing(ipod_rxst) and ipod_rxst>min_op;
run; *12047,  HC;
proc sql;
create table ppi_ip_RC as
select *, min(ipod_rxst) as IPOD_RC format yymmdd10. from ppi_ip_RC group by reference_key;
quit;
proc sort data=ppi_ip_RC nodupkey;
by reference_key;
run; *810;

/*key right censored IP PPIs/other routes into the dataset*/
proc sql;
create table ppi_mi_coh1_adult_sen2 as
select * from ppi_mi_coh1_adult_sen A left join (select IPOD_RC from ppi_ip_RC B)
on A.reference_key=B.reference_key;
quit; *776;
data ppi_mi_coh1_adult_sen2;
set ppi_mi_coh1_adult_sen2;
st_st=max(dob, y1, lc12);
st_en=min(dod, y2, IP_RC, IPOD_RC);
format lc12 y1 y2 st_st st_en IP_RC yymmdd10.;
run; *776;
data remove;
set ppi_mi_coh1_adult_sen2;
if st_st>st_en or ppirxen<st_st;
run; *0 entry;
data ppi_mi_coh1_adult_sen2;
set ppi_mi_coh1_adult_sen2;
if ppirxst>st_en then delete;
run; *756;

data ppi_mi_coh1_adult_sen2;
set ppi_mi_coh1_adult_sen2;
if ppirxst<st_st and ppirxen>=st_st then ppirxst=st_st;
if ppirxen>st_en and ppirxst<=st_en then ppirxen=st_en;
run; *756 entries;

data ppi_mi_coh1_adult_sen2;
set ppi_mi_coh1_adult_sen2;
if st_st<=eventd<=st_en;
run; *590;

/************************************************************************
***************************************************************************
******************************************************************************
*reshape the datasets
******************************************************************************
******************************************************************************
*******************************************************************************/
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
run; *5260;
proc sort data=allperiod;
by reference_key pst pen;
run; 
data allperiod;
set allperiod;
if pst>pen or pst>st_en or pen<st_st then delete;
run; *3218;
data allperiod;
set allperiod;
if pen>st_en then pen=st_en;run;
data allperiod;
set allperiod;
if pst<st_st then pst=st_st;
run;

proc sort data=ppi_mi_coh1_adult_sen2 nodupkey out=ppi_hc;
by reference_key;run; *540;
/*H2 blockers*/
/*make sure the scripts within their observation period*/
proc sql;
create table h2_ppimi as
select * from an.h2_ppimi A left join (select st_st, st_en from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *43456;
data h2_ppimi;
set h2_ppimi;
if rxst>st_en or rxen<st_st then delete;
if rxst<st_st then rxst=st_st;
if rxen>st_en then rxen=st_en;run; * 3271, after overlap: ;
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
%consec30d(max=80, input=h2_ppimi, patid=reference_key, rxst=rxst, rxen=rxen);

data h2;
set h2_ppimi;
rename rxst=h2_rxst rxen=h2_rxen;
h2_nid=_n_;
run; *1086;
proc sort data=h2;
by reference_key h2_rxst;
run; *need to sort for formatdata in R to work well;
data h2;
set h2;
keep reference_key h2_rxst h2_rxen st_st st_en;
run; *1086;
*add non-risk period;
proc sort data=h2;
by reference_key h2_rxst h2_rxen;
run;
data h2;
set h2;
senpst=h2_rxst;
senpen=h2_rxen;
pst=h2_rxst;
pen=h2_rxen;
r=0;
format senpst senpen yymmdd10.;
run;
* identify the first prescription and add the non-risk period before the index date;
data nonrisk_st_st;
set h2;
by reference_key;
if first.reference_key;
pst=st_st;
pen=senpst-1;
r=0;
format pst pen yymmdd10.;
run;
data nonrisk_st_st;
set nonrisk_st_st;
if h2_rxst<st_st then delete;
run; *sometimes rxst<st_st, then no nonrisk period:  obs;
data nonrisk_st_en;
set h2; 
by reference_key;
if last.reference_key;
pst=senpen+1;
pen=st_en;
r=0;
run;
data nonrisk_st_en;
set nonrisk_st_en;
if h2_rxst>st_en then delete;run; *sometimes upper_rw2>=st_en, then no nonrisk period: ;
data nonrisk_st_en;
set nonrisk_st_en;
if h2_rxen>st_en then pen=st_en;run;
proc sort data=h2;
by reference_key descending pst descending pen;
run;
data nonrisk_middle;
set h2;
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
data allperiod_h2;
set nonrisk_middle nonrisk_st_st nonrisk_st_en h2;
drop Prxst Prxen senpst senpen;
run; *2574;
proc sort data=allperiod_h2;
by reference_key pst pen;
run; 
data allperiod_h2;
set allperiod_h2;
if pst>pen then delete;
run; *2328;
data allperiod_h2;
set allperiod_h2;
if pen>st_en then pen=st_en;run;
data allperiod_h2;
set allperiod_h2;
if pst<st_st then pst=st_st;run;

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
set allperiod allperiod_h2 age_trans;
run; *9837;
proc sort data=all;
by reference_key pst pen;
run;
data all2;
set all;
run; *note:, after: stop macro until entries in aa is 0;

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
%multi(max=30, input=all3);

data all4;
set all2 all3;
run; *note:after:9352 stop macro until entries in aa is 0;

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
%multi(max=20, input=all4);
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
%multi(max=20, input=all4);

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
if pst>st_en or pen<st_st then delete;run; *9352;
data all4;
set all4;
if pst<st_st then pst=st_st;
if pen>st_en then pen=st_en;
run; *9352;
data all4;
set all4;
drop ppirxst ppirxen h2_rxst h2_rxen cl_rxst cl_rxen;
run;

/*H2 blockers*/
proc sql;
create table all4_h2 as
select * from all4 A left join (select h2_rxst, h2_rxen from h2 B)
on A.reference_key=B.reference_key;
quit; *;
data all4_h2;
set all4_h2;
if pst<=h2_rxst<=pen or pst<=h2_rxen<=pen or h2_rxst<=pst<=h2_rxen or h2_rxst<=pen<=h2_rxen then h2=1;
else h2=0;
run;
proc sort data=all4_h2;
by reference_key pst pen decending h2;
run;
proc sort data=all4_h2 nodupkey;
by reference_key pst pen;
run; *9352;
data ne.all4_h2;
set all4_h2;
drop h2_rxst h2_rxen;run;

/*can key in drug indicator now*/
proc sql;
create table all4_h2_rw as
select * from ne.all4_h2 A left join (select pst as pre_pst, pen as pre_pen from prerisk B)
on A.reference_key=B.reference_key;
quit; *;
data all4_h2_rw;
set all4_h2_rw;
if pst<=pre_pst<=pen or pst<=pre_pen<=pen or pre_pst<=pst<=pre_pen or pre_pst<=pen<=pre_pen then op=1;
drop eventd;
run;
proc sort data=all4_h2_rw;
by reference_key pst pen decending op;
run;
proc sort data=all4_h2_rw nodupkey;
by reference_key pst pen;
run; *9352;

proc sql;
create table all4_h2_rw2 as
select * from all4_h2_rw A left join (select pst as postst_1, pen as posten_1 from ppi_mi_coh1_adult B)
on A.reference_key=B.reference_key;
quit; *;
data all4_h2_rw2;
set all4_h2_rw2;
if pst<=postst_1<=pen or pst<=posten_1<=pen or postst_1<=pst<=posten_1 or postst_1<=pen<=posten_1 then op_p1=1;
run;
proc sort data=all4_h2_rw2;
by reference_key pst pen decending op_p1;
run;
proc sort data=all4_h2_rw2 nodupkey;
by reference_key pst pen;
run; *9352;

proc sql;
create table all4_h2_rw3 as
select * from all4_h2_rw2 A left join (select pst as postst_2, pen as posten_2 from postrisk1 B)
on A.reference_key=B.reference_key;
quit; *;
data all4_h2_rw3;
set all4_h2_rw3;
if pst<=postst_2<=pen or pst<=posten_2<=pen or postst_2<=pst<=posten_2 or postst_2<=pen<=posten_2 then op_p2=1;
run;
proc sort data=all4_h2_rw3;
by reference_key pst pen decending op_p2;
run;
proc sort data=all4_h2_rw3 nodupkey;
by reference_key pst pen;
run; *9352;

proc sql;
create table all4_h2_rw4 as
select * from all4_h2_rw3 A left join (select pst as postst_3, pen as posten_3 from postrisk2 B)
on A.reference_key=B.reference_key;
quit; *;
data all4_h2_rw4;
set all4_h2_rw4;
if pst<=postst_3<=pen or pst<=posten_3<=pen or postst_3<=pst<=posten_3 or postst_3<=pen<=posten_3 then op_p3=1;
run;
proc sort data=all4_h2_rw4;
by reference_key pst pen decending op_p3;
run;
proc sort data=all4_h2_rw4 nodupkey;
by reference_key pst pen;
run; *9352;

data all4_h2_rw4;
set all4_h2_rw4;
drop r;
run;
data all4_h2_rw4;
set all4_h2_rw4;
if op=1 then r=1;
if op_p1=1 then r=2;
if op_p2=1 then r=3;
if op_p3=1 then r=4;
run;
/*prefer pre-risk than post-risk*/
data all4_h2_rw4;
set all4_h2_rw4;
if op=1 and op_p1=1 then r=1;
if op=1 and op_p2=1 then r=1;
if op=1 and op_p3=1 then r=1;
run;
/*when two prescriptions overlap, prefer previous current risk window!
check all op_p1=1 and op_p2=1, op_p2 lower earlier than op_p1*/
data z;
set all4_h2_rw4;
if (op_p1=1 and op_p2=1) and (postst_2<postst_1);run; *0 just for checking;
data all4_h2_rw4;
set all4_h2_rw4;
if (op_p1=1 and op_p2=1) or (op_p1=1 and op_p3=1) then r=2;
run;
data all4_h2_rw4;
set all4_h2_rw4;
if (op_p2=1 and op_p3=1) then r=3;
run;

data all4_h2_rw4;
set all4_h2_rw4;
if missing(r) then r=0;
drop op op_p1 op_p2 op_p3 pre_pst pre_pen postst_1 posten_1 postst_2 posten_2 postst_3 posten_3;run;
proc sort data=all4_h2_rw4;
by reference_key pst pen r;run; *9352;


proc sql;
create table ne.all4_h2_rw4 as
select * from all4_h2_rw4 A left join (select sex as gen from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *9352;
data ne.all4_h2_rw4;
set ne.all4_h2_rw4;
if gen='M' then sex=1;
if gen='F' then sex=0;
run;
data ne.all4_h2_rw4;
set ne.all4_h2_rw4;
drop gen;
run;
proc sql;
create table ne.all4_h2_rw4 as
select * from ne.all4_h2_rw4 A left join (select dob, ppirxst, eventd from ppi_hc B)
on A.reference_key=B.reference_key;
quit; *9352;

/*some of the risk periods chopped due to different pst and pen overlapped >>>need to be recombined
for example reference_key=1826865: the pre-risk period 17/2/2011-18/2/2011 and 19/2/2011-2/3/2011 are both pre-risk period
they were chopped due to the previous post-risk period, so need to combine it to be 17/2/2011-2/3/2011 for the whole pre-risk period

4 people have this problem
869674
1467772
1826865
2425738*/

data combinerisk;
set ne.all4_h2_rw4;
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
lag_h2=lag(h2);
lag_r=lag(r);
run;
data combinerisk2;
set combinerisk;
if reference_key~=lag_indiv or lag_h2~=h2 or lag_r~=r or (m_dob=m_pst and d_dob=d_pst) then n+1;
run;
proc sql;
create table combinerisk3 as
  select *, min(pst) as min_pst format yymmdd10., max(pen) as max_pen format yymmdd10. from combinerisk2 group by n;
quit;
proc sort data=combinerisk3 nodupkey;
by n;
run;
data ne.all4_h2_rw4;
set combinerisk3;
drop pst pen;
rename min_pst=pst max_pen=pen;
drop lag_indiv lag_h2 n lag_r m_dob d_dob m_pst d_pst;
run; *9351;

data ne.all4_h2_rw4;
set ne.all4_h2_rw4;
age=year(pst)-year(dob);
censor=1;
interval=pen-pst+1;
run;

proc sort data=ne.all4_h2_rw4;
by reference_key pst pen;
run;

proc sql;
create table poisson as
select *, max(ppirxst) as max_adrug format yymmdd10. from ne.all4_h2_rw4 group by reference_key;
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
h2_block=h2;
keep indiv gender adrug lower upper exposed h2_block astart aend aevent group present; 
run;

PROC EXPORT DATA= poisson2
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\SAS export for R\manuscript\sccs_ppimi_negexp.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=NO;
RUN;

/*check how many patients on H2 within study period among included patients for PPIs VS MI*/
data h2_patient;
set ne.all4_h2_rw4;
if h2=1;
run;
proc sort data=h2_patient nodupkey;
by reference_key;run; *402;
/*total number of included patients*/
proc sort data=ne.all4_h2_rw4 nodupkey out=hc;
by reference_key;run; *540;

/*no of events in each risk window and baseline*/
data final;
set ne.all4_h2_rw4;
if pst<=eventd<=pen then event=1;
else event=0;run;
proc freq data=final;
table r*event;
run;
/*how many patients having event during H2*/
data h2_event;
set final;
if h2=1 and event=1;
run; *128;

proc univariate data=ne.all4_h2_rw4;
var interval; run; *;
proc univariate data=ne.all4_h2_rw4;
var interval; where r=0;run; *;
proc univariate data=ne.all4_h2_rw4;
var interval; where r=1;run; *;
proc univariate data=ne.all4_h2_rw4;
var interval; where r=2;run; *;
proc univariate data=ne.all4_h2_rw4;
var interval; where r=3;run; *;
proc univariate data=ne.all4_h2_rw4;
var interval; where r=4;run; *;
proc univariate data=ne.all4_h2_rw4;
var interval; where h2=1;run; *;
