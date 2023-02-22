/*Created on 12 July 2017

Purpose: to estimate the prior event rate ratio for responding the reviewers' comments

Use study period 2003-2014
and 2000-2002 as the screening period

only look at the outpatient prescriptions of PPIs but not inpatient Rx

set pre- and post- windows are 60 days

Note: (updated on 21 Jul 2017)
-remove patients who had ever had PPIs in H2RAs group
-remove patients who had non-oral outpatient PPIs at the first identified date (sensitivity analysis 1)
-remove patients who had ever had inpatient PPIs in prior periods for both PPI and H2RAs groups (sensitivity analysis 2)
-add subsequent MI event into the post period for both PPI and H2RAs groups (sensitivity analysis 3 and using dataset from sensitivity analysis 2)*/

libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname h "C:\Users\Angel YS Wong\Desktop\H2RA\program";
libname hs "C:\Users\Angel YS Wong\Desktop\H2RA\program\SCCS";

/*****************************************************************************
*****************************************************************************
PPIs dataset 
*****************************************************************************
*****************************************************************************/
*clean the PPI dataset;
data ppi_clean_rxno;
set p.ppi_pb_0314op;
if substr(drug_name,1,7)='ASPIRIN'
or substr(drug_name,1,9)='BENZHEXOL' 
or substr(drug_name,1,9)='MEFENAMIC' then delete;
run; *2341849;
data ppi_clean_rxno;
set ppi_clean_rxno;
rxst=input(Prescription_Start_Date, yymmdd10.);
rxen=input(Prescription_End_Date, yymmdd10.);
dob=input(Date_of_Birth__yyyy_mm_dd_, yymmdd10.);
dod=input(Date_of_Registered_Death, yymmdd10.);
format rxst rxen dob dod yymmdd10.;
if year(rxst)=1900 or year(rxst)=2015 then delete;
run; *2341797;
data rm;
set ppi_clean_rxno;
if rxen<rxst;
run; *132;
data rm2;
set ppi_clean_rxno;
if ~missing(dod) and dob>dod;
run; *0;
data rm3;
set p.ppi_pb_0312 p.ppi_pb_1314;
ppirxst=input(prescription_start_date, yymmdd10.);
dod=input(Date_of_Registered_Death, yymmdd10.);
if ~missing(dod) and ppirxst>dod;
run; *1137;
data rm_all;
set rm rm2 rm3;run; *1269;
proc sql;
create table ppi_clean_rxno_v2 as
select * from ppi_clean_rxno where reference_key not in (select reference_key from rm_all);
quit; *2337571;
proc freq data=ppi_clean_rxno_v2;
table action_status;run;
data ppi_clean_rxno_v2;
set ppi_clean_rxno_v2;
if action_status='Suspended' then delete;run; *2337543;

*remove patients who had any PPIs in 2000-2002;
proc sql;
create table ppi_0314_clean as
select * from ppi_clean_rxno_v2 where reference_key not in (select reference_key from p.ppi_pb_0002);
quit; *2006967;

*find the first Rx during 2003-2014;
proc sql;
create table ppi_0314_clean as
select *, min(rxst) as min_rxst format yymmdd10. from ppi_0314_clean group by reference_key;
quit;

*chop 60 days pre- and post-windows;
proc sort data=ppi_0314_clean nodupkey;
by reference_key;run; *375726;

*not include the first day of PPI prescription for the prior period;
data ppi_0314_clean_prior;
set ppi_0314_clean;
period=0;
pre_window=min_rxst-61+1;
format pre_window yymmdd10.;
run;
data ppi_0314_clean_post;
set ppi_0314_clean;
post_window=min_rxst+60-1;
format post_window yymmdd10.;
period=1;
run;
data ppi_0314_clean;
set ppi_0314_clean_prior ppi_0314_clean_post;run;

*Exclude patients aged<18 at the start of pre_window;
data rm_child;
set ppi_0314_clean;
age_pre=(pre_window-dob)/365.25;
run;
data rm_child;
set rm_child;
if ~missing(age_pre) and age_pre<18;run;
proc sql;
create table ppi_0314_clean_v2 as
select * from ppi_0314_clean where reference_key not in (select reference_key from rm_child);
quit; *745082;

/*find MI event during pre- and post- windows*/
*remove patients who had MI before pre-window;
proc sql;
create table ppi_hist_mi as
select * from dx.dx_all9315jj where All_Diagnosis_Code__ICD9_ like '410%'
or All_Diagnosis_Code__ICD9_ like '412%';
quit; *62635;
data ppi_hist_mi;
set ppi_hist_mi;
ref_date=input(reference_date, yymmdd10.);
format ref_date yymmdd10.;
run;
proc sql;
create table rm as
select * from ppi_0314_clean_v2 A left join (select ref_date from ppi_hist_mi B)
on A.reference_key=B.reference_key;
quit;
data rm;
set rm;
if ~missing(ref_date) and ref_date<pre_window;
run; *27358;

proc sql;
create table ppi_0314_clean_v3 as
select * from ppi_0314_clean_v2 where reference_key not in (select reference_key from rm);
quit; *716662;

*first MI as outcome;
*MI identification in SAS editor: PPI SCCS.sas;
proc sql;
create table ppi_0314_clean_mi as
select * from ppi_0314_clean_v3 A left join (select eventd from p.allmi_date B)
on A.reference_key=B.reference_key;
quit; *716662;

*mark study start and study end dates;
data ppi_0314_clean_mi;
set ppi_0314_clean_mi;
y2=input("2014/12/31", yymmdd10.);
if period=0 then do;
pst=pre_window;
pen=min(dod, y2, eventd, min_rxst-1);end; *note that no one has pen=dod/y2, same as H2RAs;
if period=1 then do;
pst=min_rxst;
pen=min(dod, y2, eventd, post_window);end;
format y2 pst pen yymmdd10.;run;
*remove patients who had invalid ob period;
data ppi_0314_clean_mi;
set ppi_0314_clean_mi;
if pen<pst then delete;
run; *707910;
proc sort data=ppi_0314_clean_mi;
by reference_key pst pen;run;

*mark event indicator;
data ppi_0314_clean_mi;
set ppi_0314_clean_mi;
if ~missing(eventd) and pst<=eventd<=pen then mi=1;
else mi=0;
run;
proc freq data=ppi_0314_clean_mi;
table mi*period;run; *pre:7264 and post: 518; 
data ppi_0314_clean_mi;
set ppi_0314_clean_mi;
drug=1;run;


/*****************************************************************************
*****************************************************************************
H2RAs dataset 
note: no Prescription start date and Prescription end date in the dataset
Use dispensing date instead: only requires a non-exposed group for comparison 
and dispensing date~ prescription start date
and no action status item in the dataset
*****************************************************************************
*****************************************************************************/
proc sql;
create table h2_all_0314op_rand as
select * from h.h2_all_0314op where reference_key in (select reference_key from h.h2_0314op_rand);
quit; *2656934;
*already checked all H2RAs are really H2RAs before;

/*data rm;
set h2_all_0314op_rand;
if rxen<rxst;
run; *132; */
data h2_demo_rand;
set h.h2_demo_rand;
dob=input(Date_of_Birth__yyyy_mm_dd_, yymmdd10.);
dod=input(Date_of_Registered_Death, yymmdd10.);
format dob dod yymmdd10.;run;
proc sql;
create table h2_all_0314op_rand_demo as
select * from h2_all_0314op_rand A left join (select dob, dod from h2_demo_rand B)
on A.reference_key=B.reference_key;
quit;
data rm2;
set h2_all_0314op_rand_demo;
if ~missing(dod) and dob>dod;
run; *0;
data rm3;
set h2_all_0314op_rand_demo;
dod=input(Date_of_Registered_Death, yymmdd10.);
if ~missing(dod) and disd>dod;
run; *0;
/* no action status
proc freq data=h2_all_0314op_rand_demo;
table action_status;run;
data h2_all_0314op_rand_demo;
set h2_all_0314op_rand_demo;
if action_status='Suspended' then delete;run; *2337543; */

*remove patients who had H2 prescription during 2000-2002;
data h2_all_0002;
set h.h2_all_0014;
disd=input(Dispensing_Date__yyyy_mm_dd_, yymmdd10.);
format disd yymmdd10.;
yr_disd=year(disd);
if 2000<=yr_disd<=2002;
run; *2241072;
proc sql;
create table h2_0314_clean as
select * from h2_all_0314op_rand_demo where reference_key not in (select reference_key from h2_all_0002);
quit; *2115801;

*find the first Rx during 2003-2014;
proc sql;
create table h2_0314_clean as
select *, min(disd) as min_rxst format yymmdd10. from h2_0314_clean group by reference_key;
quit;

*chop 60 days pre- and post-windows;
proc sort data=h2_0314_clean nodupkey;
by reference_key;run; *367384;

*not include the first day of PPI prescription for the prior period;
data h2_0314_clean_prior;
set h2_0314_clean;
period=0;
pre_window=min_rxst-61+1;
format pre_window yymmdd10.;
run;
data h2_0314_clean_post;
set h2_0314_clean;
post_window=min_rxst+60-1;
format post_window yymmdd10.;
period=1;
run;
data h2_0314_clean;
set h2_0314_clean_prior h2_0314_clean_post;run;

*Exclude patients aged<18 at the start of pre_window;
data rm_child;
set h2_0314_clean;
age_pre=(pre_window-dob)/365.25;
run;
data rm_child;
set rm_child;
if ~missing(age_pre) and age_pre<18;run;
proc sql;
create table h2_0314_clean_v2 as
select * from h2_0314_clean where reference_key not in (select reference_key from rm_child);
quit; *714358;

/*find MI event during pre- and post- windows*/
*remove patients who had MI before pre-window;
proc sql;
create table h2_hist_mi as
select * from h.h2_alldx_all where All_Diagnosis_Code__ICD9_ like '410%'
or All_Diagnosis_Code__ICD9_ like '412%';
quit; *27400;
data h2_hist_mi;
set h2_hist_mi;
ref_date=input(reference_date, yymmdd10.);
format ref_date yymmdd10.;
run;
proc sql;
create table rm as
select * from h2_0314_clean_v2 A left join (select ref_date from h2_hist_mi B)
on A.reference_key=B.reference_key;
quit;
data rm;
set rm;
if ~missing(ref_date) and ref_date<pre_window;
run; *5820;

proc sql;
create table h2_0314_clean_v3 as
select * from h2_0314_clean_v2 where reference_key not in (select reference_key from rm);
quit; *708040;

*first MI as outcome;
*MI identification in SAS editor: PPI SCCS.sas;
proc sql;
create table h2_0314_clean_mi as
select * from h2_0314_clean_v3 A left join (select eventd from hs.allmi_date B)
on A.reference_key=B.reference_key;
quit; *708040;

*mark study start and study end dates;
data h2_0314_clean_mi;
set h2_0314_clean_mi;
y2=input("2014/12/31", yymmdd10.);
if period=0 then do;
pst=pre_window;
pen=min(dod, y2, eventd, min_rxst-1);end;
if period=1 then do;
pst=min_rxst;
pen=min(dod, y2, eventd, post_window);end;
format y2 pst pen yymmdd10.;run;

*remove patients who had invalid ob period;
data h2_0314_clean_mi;
set h2_0314_clean_mi;
if pen<pst then delete;
run; *706479;
proc sort data=h2_0314_clean_mi;
by reference_key pst pen;run;

*mark event indicator;
data h2_0314_clean_mi;
set h2_0314_clean_mi;
if ~missing(eventd) and pst<=eventd<=pen then mi=1;
else mi=0;
run;
data h2_0314_clean_mi;
set h2_0314_clean_mi;
drug=0;run;

*Exclude patients who had ever prescribed PPIs during 2000-2002;
proc sql;
create table h2_0314_clean_mi_1 as
select * from h2_0314_clean_mi where reference_key not in (select reference_key from p.ppi_pb_0002);
quit; *701344;

*Exclude patients who had ever prescribed PPIs during study period;
proc sql;
create table rm_ppi as
select * from h2_0314_clean_mi_1 A left join (select rxst as ppirxst, rxen as ppirxen from ppi_clean_rxno_v2 B)
on A.reference_key=B.reference_key;
quit; *1078331;
data rm_ppi;
set rm_ppi;
if (~missing(ppirxst) and pst<=ppirxst<=pen) or (~missing(ppirxen) and pst<=ppirxen<=pen);
run;
proc sql;
create table h2_0314_clean_mi_2 as
select * from h2_0314_clean_mi_1 where reference_key not in (select reference_key from rm_ppi);
quit; *678172;

proc freq data=h2_0314_clean_mi_2;
table mi*period;run; *pre:1336 and post: 170;

data p.perr;
set ppi_0314_clean_mi h2_0314_clean_mi_2;
time=pen-pst+1;
keep reference_key drug mi period pst pen min_rxst dob dod eventd time;
run; *1386082;

proc sort data=p.perr;
by period;run;


ods output ParameterEstimates = t0;
proc phreg data=p.perr;
     class drug(ref='0');
     model time*mi(0)=drug/ ties=breslow rl;
	by period;
	run; 
	 quit;

proc transpose data=t0 out=a; 
run; 
data a;
set a;
if _NAME_='HazardRatio';
PERR=COL2/COL1;
run; *PERR: 0.57;


/*********************************************************************************
sensitivity analysis 1:
remove non_oral route at the first identified outpatient PPI Rx in the cohort*
********************************************************************************/
data perr_ppi;
set p.perr;
if drug=1;
run; *707910;
proc sql;
create table rx as
select * from p.ppi_pb_0314op where reference_key in (select reference_key from perr_ppi);
quit;
data rx;
set rx;
rxst=input(Prescription_Start_Date, yymmdd10.);
format rxst yymmdd10.;
run;
proc sql;
create table rx2 as
select *, min(rxst) as min_rxst from rx group by reference_key;
quit;
data rx2;
set rx2;
if min_rxst=rxst;
run;
data non_oral;
set rx2;
if route='INJECTION' or route='PARENTERAL' or missing(route);
run; *58;

proc sql;
create table perr_oralppi as
select * from perr_ppi where reference_key not in (select reference_key from non_oral);
quit; *707797;
data perr_h2;
set p.perr;
if drug=0;
run;
data p.perr_sen1;
set perr_h2 perr_oralppi;
run; *1385969;

proc sort data=p.perr_sen1;
by period;run;
ods output ParameterEstimates = t0;
proc phreg data=p.perr_sen1;
     class drug(ref='0');
     model time*mi(0)=drug/ ties=breslow rl;
	by period;
	run; 
	 quit;

proc transpose data=t0 out=a; 
run; 
data a;
set a;
if _NAME_='HazardRatio';
PERR=COL2/COL1;
run; *PERR: 0.57 same as the result as above;


/*********************************************************************************
sensitivity analysis 2:
remove patients who had inpatient PPIs at the first identified outpatient Rx in the cohort
*********************************************************************************/
data pbppi0314;
set p.ppi_pb_0312 p.ppi_pb_1314;
run;
data pbppi0314_rm;
set pbppi0314;
if Type_of_Patient__Drug_='I' or
Type_of_Patient__Drug_='D';run; *6250609;
proc sql;
create table ip_0314 as
select * from pbppi0314_rm where reference_key in (select reference_key from p.perr);
quit; *3557431;
data ip_0314;
set ip_0314;
rxst=input(prescription_start_date, yymmdd10.);
rxen=input(prescription_End_date, yymmdd10.);
format rxst rxen yymmdd10.;
run;
proc sql;
create table ip_rm as
select * from p.perr A left join (select rxst as ip_rxst, rxen as ip_rxen from ip_0314 B)
on A.reference_key=B.reference_key;
quit; *8509595;

*identify patient who had ever had inpatient PPIs in H2RAs group;
data ip_rm_h2;
set ip_rm;
if drug=0 and ~missing(ip_rxst) and (pst<=ip_rxst<=pen or pst<=ip_rxen<=pen);
run;
proc sql;
create table perr_h2_v2 as
select * from perr_h2 where reference_key not in (Select reference_key from ip_rm_h2);
quit; *661754;

*identify patient who had ever had inpatient PPIs in prior period in PPI group;
data ip_rm_ppi_prior;
set ip_rm;
if drug=1 and ~missing(ip_rxst) and period=0 and (pst<=ip_rxst<=pen or pst<=ip_rxen<=pen);
run; *662289;
data perr_prior_ppi;
set p.perr;
if period=0 and drug=1;
run;
proc sql;
create table perr_prior_ppi_v2 as
select * from perr_prior_ppi where reference_key not in (Select reference_key from ip_rm_ppi_prior);
quit; *239253;
data perr_post_ppi;
set p.perr;
if period=1 and drug=1;
run;

*combine datasets for sensitivity analysis 2;
data p.perr_sen2;
set perr_post_ppi perr_prior_ppi_v2 perr_h2_v2;
run; *1251330;

proc sort data=p.perr_sen2;
by period;run;
ods output ParameterEstimates = t0;
proc phreg data=p.perr_sen2;
     class drug(ref='0');
     model time*mi(0)=drug/ ties=breslow rl;
	by period;
	run; 
	 quit;

proc transpose data=t0 out=a; 
run; 
data a;
set a;
if _NAME_='HazardRatio';
PERR=COL2/COL1;
run; *PERR: 0.74;

proc freq data=p.perr_sen2;
table mi*period*drug;run;

/********************************************************************************
Sensitivity analysis 3:
also take the subsequent MI in the post period
find the subsequent MI event just after the start of post-period in PPI group
*********************************************************************************/
data ae_mi;
set dx.ppi_allmi;
if Patient_Type__IP_OP_A_E_="A";
run;
proc sql;
create table ip_mi as
select * from dx.ppi_mistrokeip where Dx_Px_code like '410%';
quit;
data ip_mi_d1;
set ip_mi;
if Dx_Px_Rank="D1";run;
data all_mi;
set ae_mi ip_mi_d1;
refd=input(reference_date, yymmdd10.);
if ~missing(refd) then eventd=refd;
if ~missing(admd) then eventd=admd;
format refd eventd yymmdd10.;run;

*identify event date to the post-period in PPI group;
data perr_post_ppi;
set p.perr_sen2;
if period=1 and drug=1;
run;
proc sql;
create table perr_post_ppi_v2 as
select * from perr_post_ppi A left join (select eventd as post_eventd from all_mi B)
on A.reference_key=B.reference_key;
quit;
data perr_post_ppi_v2;
set perr_post_ppi_v2;
if ~missing(post_eventd) and pst=<post_eventd<=pen;
run;
proc sql;
create table post_mi as
select *, min(post_eventd) as min_post_eventd format yymmdd10. from perr_post_ppi_v2 group by reference_key;
quit;
proc sort data=post_mi nodupkey;
by reference_key;run; *580;
*key first post-period MI event into the dataset;
proc sql;
create table perr_post_ppi_v3 as
select * from perr_post_ppi A left join (select min_post_eventd from post_mi B)
on A.reference_key=B.reference_key;
quit;
data perr_post_ppi_v3;
set perr_post_ppi_v3;
pen_new=min(pen, min_post_eventd);
format pen_new yymmdd10.;
if ~missing(min_post_eventd) and pst<=min_post_eventd<=pen_new then mi=1;
else mi=0;
drop time;
run;
data perr_post_ppi_v3;
set perr_post_ppi_v3;
time=pen_new-pst+1;run;

/*find the subsequent MI event just after the start of post-period in H2RA group*/
proc sql;
create table h2_allmi as
select * from h.h2_alldx_all where All_Diagnosis_Code__ICD9_ like '410%';
quit; *19873;
data ae_mi;
set h2_allmi;
if Patient_Type__IP_OP_A_E_="A";
run;
proc sql;
create table ip_mi as
select * from h.h2mi_IP_all where Dx_Px_code like '410%';
quit;
data ip_mi_d1;
set ip_mi;
if Dx_Px_Rank="D1";run;
data all_mi;
set ae_mi ip_mi_d1;
refd=input(reference_date, yymmdd10.);
if ~missing(refd) then eventd=refd;
if ~missing(admd) then eventd=admd;
format refd eventd yymmdd10.;run;

*identify event date to the post-period in H2RA group;
data perr_post_h2;
set p.perr_sen2;
if period=1 and drug=0;
run;
proc sql;
create table perr_post_h2_v2 as
select * from perr_post_h2 A left join (select eventd as post_eventd from all_mi B)
on A.reference_key=B.reference_key;
quit;
data perr_post_h2_v2;
set perr_post_h2_v2;
if ~missing(post_eventd) and pst=<post_eventd<=pen;
run;
proc sql;
create table post_mi as
select *, min(post_eventd) as min_post_eventd format yymmdd10. from perr_post_h2_v2 group by reference_key;
quit;
proc sort data=post_mi nodupkey;
by reference_key;run; *134;
*key first post-period MI event into the dataset;
proc sql;
create table perr_post_h2_v3 as
select * from perr_post_h2 A left join (select min_post_eventd from post_mi B)
on A.reference_key=B.reference_key;
quit;
data perr_post_h2_v3;
set perr_post_h2_v3;
pen_new=min(pen, min_post_eventd);
format pen_new yymmdd10.;
if ~missing(min_post_eventd) and pst<=min_post_eventd<=pen_new then mi=1;
else mi=0;
drop time;
run;
data perr_post_h2_v3;
set perr_post_h2_v3;
time=pen_new-pst+1;run;

*merge the enhanced dataset;
data prior;
set p.perr_sen2;
if period=0;run;
data p.perr_sen3;
set perr_post_ppi_v3 perr_post_h2_v3 prior;
run; *1251330;

proc sort data=p.perr_sen3;
by period;run;
ods output ParameterEstimates = t0;
proc phreg data=p.perr_sen3;
     class drug(ref='0');
     model time*mi(0)=drug/ ties=breslow rl;
	by period;
	run; 
	 quit;

proc transpose data=t0 out=a; 
run; 
data a;
set a;
if _NAME_='HazardRatio';
PERR=COL2/COL1;
run; *PERR: 0.81 ;

proc freq data=p.perr_sen3;
table drug*mi*period;run;

/*no of patients included*/
data ppi;
set p.perr_sen3;
if drug=1;
run;
proc sort data=ppi nodupkey out=ppi_hc;
by reference_key;run; *354783;

data h2;
set p.perr_sen3;
if drug=0;
run;
proc sort data=h2 nodupkey out=h2_hc;
by reference_key;run; *331489;
