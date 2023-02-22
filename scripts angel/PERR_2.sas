/*Created on 28 Jul 2017
Purpose: To


*/
data perr_ppi;
set p.perr;
if drug=1;
run; *707910;
data perr_h2;
set p.perr;
if drug=0;
run;
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
proc sql;
create table perr_ppi_v2 as
select * from perr_ppi where reference_key not in (Select reference_key from ip_rm_ppi_prior);
quit; *474046;

*combine datasets for sensitivity analysis 2;
data p.perr_sen2_v2;
set perr_ppi_v2 perr_h2_v2;
run; *1135800;

proc sort data=p.perr_sen2_v2;
by period;run;
ods output ParameterEstimates = t0;
proc phreg data=p.perr_sen2_v2;
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
run; *PERR: 0.36;

proc freq data=p.perr_sen2_v2;
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
set p.perr_sen2_v2;
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
by reference_key;run; *176;
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
set p.perr_sen2_v2;
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
set p.perr_sen2_v2;
if period=0;run;
data p.perr_sen3_v2;
set perr_post_ppi_v3 perr_post_h2_v3 prior;
run; *1135800;

proc sort data=p.perr_sen3_v2;
by period;run;
ods output ParameterEstimates = t0;
proc phreg data=p.perr_sen3_v2;
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
run; *PERR: 0.37;

proc freq data=p.perr_sen3_v2;
table mi*period*drug;run;

/*sensitivity analysis 3 version 2
considering subsequent event of MI*/

*start bootstrap;
%let rep = 1000;
proc surveyselect data= p.perr_sen3_v2 out=bootsample
     seed = 1347 method = urs
	 samprate = 1 outhits rep = &rep;
run;
ods listing close;

/*obtain HR estimates in each bootstrap samples*/
ods output  ParameterEstimates = t1;
proc phreg data=bootsample;
     by replicate period;
     model time*mi(0)=drug/ ties=breslow rl;
     run; 
	 quit;

data p.t1_sen3_v2;
set t1;
run;
data a;
set p.t1_sen3_v2;run;
proc sort data=a;
by replicate;run;
proc transpose data=a out=aa;
by replicate;run;
data aa;
set aa;
if _NAME_='HazardRatio';
PERR=COL2/COL1;
if replicate=1000 then delete;run;
run;
proc sort data=aa;
by perr;run;
data aa;
set aa;
nid=_n_;run;
data ci;
set aa;
if nid=25 or nid=975;
run; *0.29-0.46;
