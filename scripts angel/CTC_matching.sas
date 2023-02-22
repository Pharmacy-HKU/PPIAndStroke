/*Created on 28 Jun 2016; 

Patients have to be aged 18 or above at first PPI OP prescription (nested case control)

Purpose: To match each case to 4 controls 

****
Use LC after one year/dob/study start earlier date
Excluded patients who had events throughout the observation period in the original cohort
****

Matching criteria:
1. Year of birth
2. Sex
*must be alive for control when match at cases' index date
*no replacement
*Use randon seed and re-order the list of the subjects
*cases can't be controls for another cases

Updated on 29 Jun 2016
1. control selection: only select those who had PPIs prescription<=56days (ie exclude those had >56 days)
2. clean the control datasets carefully and do 30 days overlapping to be consistent with SCCS analysis
*/
*remove the patients who had MI events and obtain a PPI OP cohort for matching;
libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname dx "C:\Users\Angel YS Wong\Desktop\PPI\program\dx";
libname an "C:\Users\Angel YS Wong\Desktop\PPI\program\drug";
libname lc "C:\Users\Angel YS Wong\Desktop\PPI\program\lc";
libname m "C:\Users\Angel YS Wong\Desktop\PPI\program\CTC";

/* Cases of MI*/
data ppi_allrw2;
set ppi_allrw; *see SAS editor: CCO;
dob_year=year(dob);
if sex='M' then do;
gender=1;end;
if sex='F' then do;
gender=0;end;
keep reference_key dob_year gender eventd st_st st_en;
run;
proc sort data=ppi_allrw2 nodupkey out=m.ppi_case;
by reference_key;
run; *727;
data a;
set ppi_allrw2;
if missing(dob_year) or missing(gender);
run; *0;
/* Controls
1. Need to add LC dates from LC rest + LC of MI/stroke
2. Need to exclude those with cases of MI or history of MI*/
*LC dates for all;
data lc_all;
set lc.ppi_lcrest_all lc.ppi_alllc;
drop lc_date min_lc;
run; *22608198;
/*adding LC date*/
data lc_all;
set lc_all;
if ~missing(Attendance_Date__yyyy_mm_dd_) then lc_date=input(Attendance_Date__yyyy_mm_dd_, yymmdd10.);
if ~missing(Admission_Date__yyyy_mm_dd_) then lc_date=input(Admission_Date__yyyy_mm_dd_, yymmdd10.);
if ~missing(Appointment_Date__yyyy_mm_dd_) then lc_date=input(Appointment_Date__yyyy_mm_dd_, yymmdd10.);
if ~missing(OT_Date__yyyy_mm_dd_) then lc_date=input(OT_Date__yyyy_mm_dd_, yymmdd10.);
if ~missing(PSY_Form__Service_Date__yyyy_mm_) then lc_date=input(PSY_Form__Service_Date__yyyy_mm_, yymmdd10.);
if ~missing(Injection_Date__yyyy_mm_dd_) then lc_date=input(Injection_Date__yyyy_mm_dd_, yymmdd10.);
format lc_date yymmdd10.;
run;
proc sql;
create table lc.lc_ctc as
select *, min(lc_date) as min_lc from lc_all group by reference_key;
quit;
data lc.lc_ctc;
set lc.lc_ctc;
format min_lc yymmdd10.;
run;
proc sort data=lc.lc_ctc nodupkey;
by reference_key;
run; *405209;
data lc.lc_ctc;
set lc.lc_ctc;
keep reference_key min_lc;run;

/*check p.ppi_pb_0314op dataset*/
proc freq data=p.ppi_pb_0314op;
table route;run;
data opppi_nonoral;
set p.ppi_pb_0314op;
if route not in ('ORAL' , 'PO')
or missing(route);
run;
proc sql;
create table op_oral0314 as
select * from p.ppi_pb_0314op where reference_key not in (select reference_key from opppi_nonoral);
quit; *2338703;
data op_oral0314;
set op_oral0314;
disd=input(Dispensing_Date__yyyy_mm_dd_,yymmdd10.);
ppirxst=input(prescription_start_date, yymmdd10.);
ppirxen=input(Prescription_End_Date, yymmdd10.);
dob=input(Date_of_Birth__yyyy_mm_dd_, yymmdd10.);
dod=input(Date_of_Registered_Death, yymmdd10.);
dur=ppirxen-ppirxst+1;
format disd ppirxst ppirxen dob dod yymmdd10.;
run;

*key LC (after 1y) into the OP PPI dataset;
proc sql;
create table ppi_pb_0314op as
select * from op_oral0314 A left join (select min_lc from lc.lc_ctc B)
on A.reference_key=B.reference_key;
quit; *2338703;
data miss_lc;
set ppi_pb_0314op;
if missing(min_lc);
run;
proc sort data=miss_lc nodupkey;
by reference_key;run; *53;
data ppi_pb_0314op;
set ppi_pb_0314op;
if missing(min_lc) then delete;
run; *2338621;

*key admission date to alldx data;
proc sql;
create table allmi as
select * from dx.dx_all9315jj where All_Diagnosis_Code__ICD9_ like '410%' or All_Diagnosis_Code__ICD9_ like '412%'; ****and 412 too;
quit; *87889;
proc freq data=allmi;
table All_Diagnosis_Code__ICD9_;
run;
data allmi;
set allmi;
refd=input(reference_date, yymmdd10.);
format refd yymmdd10.;
run;
proc sql;
create table allmi_min as
select min(refd) as min_refd format yymmdd10., * from allmi group by reference_key;
quit;
*IP;
data allmi_min_ip;
set allmi_min;
if Patient_Type__IP_OP_A_E_="I";run; *83916;
data mistrokeip;
set dx.ppi_mistrokeip dx.mi412_ip_all;
admd=input(Admission_Date__yyyy_mm_dd_, yymmdd10.);
dischd=input(Discharge_Date__yyyy_mm_dd_, yymmdd10.);
format admd dischd yymmdd10.;run; *6025944;
* key adm, discharge date to arrh_min_ip;
proc sql;
create table allmi_min_ip_adm as
select * from allmi_min_ip A left join (select admd, dischd, Dx_Px_code from mistrokeip B)
on A.reference_key=B.reference_key and A.All_Diagnosis_Code__ICD9_=B.Dx_Px_code;
quit;
data allmi_min_ip_adm;
set allmi_min_ip_adm;
if admd<refd<=dischd or admd=refd=dischd;run;
*Find min date for admission date;
proc sql;
create table allmi_min_ip_adm as
select *, min(admd) as tempd format yymmdd10. from allmi_min_ip_adm group by reference_key;quit;
*OP and AE;
data allmi_min_ao;
set allmi_min;
if Patient_Type__IP_OP_A_E_="A" or Patient_Type__IP_OP_A_E_="O";run; *3973;
data allmi_min_ao;
set allmi_min_ao;
tempd=refd;format tempd yymmdd10.;run;
data allmi_earlydate;
set allmi_min_ao allmi_min_ip_adm;
run;
proc sort data=allmi_earlydate;
by reference_key tempd;run; 
proc sort data=allmi_earlydate nodupkey;
by reference_key;run; *37987;
data p.allmi_earlydate;
set allmi_earlydate;
year_tempd=year(tempd);
if year_tempd<=2014;
run; *37946;

/*remove patients who had 412 and 410 codes from the outpatient PPIs dataset*/
proc sql;
create table ppi_ctrl_clean as
select * from ppi_pb_0314op where reference_key not in (select reference_key from p.allmi_earlydate);
quit; *2006326;
proc sql;
create table m.ppi_ctrl_clean as
select * from ppi_ctrl_clean where reference_key not in (select reference_key from m.ppi_case);
quit; *2006326;

data m.ppi_ctrl_clean;
set m.ppi_ctrl_clean;
if action_status='Suspended' then delete;run; *2006326;
*exclude patients whose PPIs prescription more than 8 weeks during ob period;
data a;
set m.ppi_ctrl_clean;
if missing(dur);run;
data ppi_lodur;
set m.ppi_ctrl_clean;
if dur>56;run; *1218544;
proc sql;
create table ppi_shdur as
select * from m.ppi_ctrl_clean where reference_key not in (select reference_key from ppi_lodur);
quit; *303142;

data rm;
set ppi_shdur;
if ppirxen<ppirxst;
run; *29;
data rm2;
set ppi_shdur;
if ~missing(dod) and dob>dod;
run; *0;
data rm3;
set ppi_shdur;
if ~missing(dod) and ppirxst>dod;
run; *7;
data rm_all;
set rm rm2 rm3;run; *36;
proc sql;
create table m.ppi_shdur as
select * from ppi_shdur where reference_key not in (select reference_key from rm_all);
quit; *303056;


proc freq data=m.ppi_shdur;
table drug_name;run;
data m.ppi_shdur;
set m.ppi_shdur;
if substr(drug_name,1,9)='BENZHEXOL'
or substr(drug_name,1,9)='MEFENAMIC' then delete;
run; *303054;
*control dataset;
/*handle overlapping*/
data m.ppi_shdur_o;
set m.ppi_shdur;
run; *before overlap 30 apart: 303054, after:203443;
%macro consec(max=, input=, day=, patid=, rxst=, rxen=);
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
if ~missing(Prxst)and 0<=Prxst-&rxen<=&day then do &rxen=Prxen;
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
%mend consec(max=, input=, day=, patid=, rxst=, rxen=);
%consec(max=160, input=m.ppi_shdur_o, day=30, patid=reference_key, rxst=ppirxst, rxen=ppirxen);

data m.ppi_shdur_o;
set m.ppi_shdur_o;
lc12=min_lc+365;
y1=input("2003/01/01", yymmdd10.);
y2=input("2014/12/31", yymmdd10.);
st_st=max(dob, y1, lc12);
st_en=min(dod, y2);
format lc12 y1 y2 st_st st_en yymmdd10.;
run; *203444;
data rm;
set m.ppi_shdur_o;
if st_en<st_st or ppirxst>st_en or ppirxen<st_st;
run; *10802;
proc sql;
create table m.ppi_shdur_o as
select * from m.ppi_shdur_o where reference_key not in (select reference_key from rm);
quit; *191610;
proc freq data=m.ppi_shdur_o;
table sex;run; *no missing;

data m.ppi_shdur_clean;
set m.ppi_shdur_o;
run;

data m.ppi_shdur_clean;
set m.ppi_shdur_clean;
dob_year=year(dob);
if sex='M' then do;
gender=1;end;
if sex='F' then do;
gender=0;end;
keep reference_key dob_year gender st_st st_en;
run;
data a;
set m.ppi_shdur_clean;
if missing(dob_year) or missing(gender);
run; *0;
proc sort data=m.ppi_shdur_clean nodupkey;
by reference_key;
run; *156379;

/* start matching*/
proc sort data=m.ppi_shdur_clean; by reference_key;
run;
data m.ppi_shdur_clean;
set m.ppi_shdur_clean;
 call streaminit(123456789); *keep the sequence from the rand seed;
    rand = rand("Uniform"); output;run;
proc sort data=m.ppi_case; by reference_key;
proc sort data=m.ppi_shdur_clean; by rand;
run;
proc printto log="C:\Users\Angel YS Wong\Desktop\PPI\program\CTC\match1.log";
run;
%macro matches(dataf=,datal=,outdata=);
%if %sysfunc(exist(&outdata)) %then %do;
proc datasets;
delete &outdata;
Run;
%end;
/* Determine the number of observations in the case data set. */
data _null_;
dsid=open("&dataf",'i');
nobs=attrn(dsid,'nobs');
call symput('nobs',nobs);
Run;
data datalast;
set &datal;
Run;
%put nobs = &nobs;
%do n=1 %to &nobs;
/* Determine the number of observations in the control data
set. */
data _null_;
dsid=open("datalast",'i');
nobs=attrn(dsid,'nobs');
call symput('conobs',nobs);
Run;
%let mmatch=1;
data matches1;
choose=&n;
set &dataf point=choose;
output;
stop;
Run;
/* The match indicator variable is set to zero, the
variables in the control data set are renamed, and the
matching criteria is coded. */
data matches1;
set matches1;
i=1;
match=0;
do until(match=1);
/* Set the control data set and rename the variables*/
set datalast(rename=(reference_key=reference_key_ctrl
dob_year=dob_year_ctrl
gender=gender_ctrl
st_st=stst_ctrl
st_en=sten_ctrl)
) point=i;
/* If the control matches the case, set match=1 to allow
for this matched control to be appended to the match
data set and deleted from the control data set. */
if reference_key~=reference_key_ctrl and dob_year=dob_year_ctrl and gender=gender_ctrl and stst_ctrl<=eventd<=sten_ctrl then do;
match=1;
call symput("matchn",i);
output;
end;
/* If the control does not match the case and all controls
have been examined as potential matches, set match=1 to
exit the do loop. */
if match=0 and i=&conobs then do;
call symput("mmatch",match);
match=1;
end;
/* If the control does not match the case and all controls
have not been examined, set match=0 and go to the next
control. */
if match=0 then i=i+1;
end;
stop;
Run;
/* Append the matches to the matched data set and deleted
the matched control from the control data set. */
%if &mmatch=1 %then %do;
proc append base=&outdata data=matches1 force;
Run;
data datalast;
set datalast;
if _n_=&matchn then delete;
Run;
%end;
%end;
proc print data=&outdata;
title 'Matched Data Set';
Run;
%mend;
%matches(dataf=m.ppi_case,datal=m.ppi_shdur_clean,outdata=m.match1);
/*726 matches*/
PROC PRINTTO PRINT=PRINT LOG=LOG ;
RUN;
proc sql;
create table m.ppi_ctrl_clean2 as
select * from m.ppi_shdur_clean where reference_key not in (Select reference_key_ctrl from m.match1);
quit; *155653;
proc printto log="C:\Users\Angel YS Wong\Desktop\PPI\program\CTC\match2.log";
run;
%macro matches(dataf=,datal=,outdata=);
%if %sysfunc(exist(&outdata)) %then %do;
proc datasets;
delete &outdata;
Run;
%end;
/* Determine the number of observations in the case data set. */
data _null_;
dsid=open("&dataf",'i');
nobs=attrn(dsid,'nobs');
call symput('nobs',nobs);
Run;
data datalast;
set &datal;
Run;
%put nobs = &nobs;
%do n=1 %to &nobs;
/* Determine the number of observations in the control data
set. */
data _null_;
dsid=open("datalast",'i');
nobs=attrn(dsid,'nobs');
call symput('conobs',nobs);
Run;
%let mmatch=1;
data matches1;
choose=&n;
set &dataf point=choose;
output;
stop;
Run;
/* The match indicator variable is set to zero, the
variables in the control data set are renamed, and the
matching criteria is coded. */
data matches1;
set matches1;
i=1;
match=0;
do until(match=1);
/* Set the control data set and rename the variables*/
set datalast(rename=(reference_key=reference_key_ctrl
dob_year=dob_year_ctrl
gender=gender_ctrl
st_st=stst_ctrl
st_en=sten_ctrl)
) point=i;
/* If the control matches the case, set match=1 to allow
for this matched control to be appended to the match
data set and deleted from the control data set. */
if reference_key~=reference_key_ctrl and dob_year=dob_year_ctrl and gender=gender_ctrl and stst_ctrl<=eventd<=sten_ctrl then do;
match=1;
call symput("matchn",i);
output;
end;
/* If the control does not match the case and all controls
have been examined as potential matches, set match=1 to
exit the do loop. */
if match=0 and i=&conobs then do;
call symput("mmatch",match);
match=1;
end;
/* If the control does not match the case and all controls
have not been examined, set match=0 and go to the next
control. */
if match=0 then i=i+1;
end;
stop;
Run;
/* Append the matches to the matched data set and deleted
the matched control from the control data set. */
%if &mmatch=1 %then %do;
proc append base=&outdata data=matches1 force;
Run;
data datalast;
set datalast;
if _n_=&matchn then delete;
Run;
%end;
%end;
proc print data=&outdata;
title 'Matched Data Set';
Run;
%mend;
%matches(dataf=m.ppi_case,datal=m.ppi_ctrl_clean2,outdata=m.match2);
/*726 matches*/
PROC PRINTTO PRINT=PRINT LOG=LOG ;
RUN;
proc sql;
create table m.ppi_ctrl_clean3 as
select * from m.ppi_ctrl_clean2 where reference_key not in (Select reference_key_ctrl from m.match2);
quit; *154927;
proc printto log="C:\Users\Angel YS Wong\Desktop\PPI\program\CTC\match3.log";
run;
%macro matches(dataf=,datal=,outdata=);
%if %sysfunc(exist(&outdata)) %then %do;
proc datasets;
delete &outdata;
Run;
%end;
/* Determine the number of observations in the case data set. */
data _null_;
dsid=open("&dataf",'i');
nobs=attrn(dsid,'nobs');
call symput('nobs',nobs);
Run;
data datalast;
set &datal;
Run;
%put nobs = &nobs;
%do n=1 %to &nobs;
/* Determine the number of observations in the control data
set. */
data _null_;
dsid=open("datalast",'i');
nobs=attrn(dsid,'nobs');
call symput('conobs',nobs);
Run;
%let mmatch=1;
data matches1;
choose=&n;
set &dataf point=choose;
output;
stop;
Run;
/* The match indicator variable is set to zero, the
variables in the control data set are renamed, and the
matching criteria is coded. */
data matches1;
set matches1;
i=1;
match=0;
do until(match=1);
/* Set the control data set and rename the variables*/
set datalast(rename=(reference_key=reference_key_ctrl
dob_year=dob_year_ctrl
gender=gender_ctrl
st_st=stst_ctrl
st_en=sten_ctrl)
) point=i;
/* If the control matches the case, set match=1 to allow
for this matched control to be appended to the match
data set and deleted from the control data set. */
if reference_key~=reference_key_ctrl and dob_year=dob_year_ctrl and gender=gender_ctrl and stst_ctrl<=eventd<=sten_ctrl then do;
match=1;
call symput("matchn",i);
output;
end;
/* If the control does not match the case and all controls
have been examined as potential matches, set match=1 to
exit the do loop. */
if match=0 and i=&conobs then do;
call symput("mmatch",match);
match=1;
end;
/* If the control does not match the case and all controls
have not been examined, set match=0 and go to the next
control. */
if match=0 then i=i+1;
end;
stop;
Run;
/* Append the matches to the matched data set and deleted
the matched control from the control data set. */
%if &mmatch=1 %then %do;
proc append base=&outdata data=matches1 force;
Run;
data datalast;
set datalast;
if _n_=&matchn then delete;
Run;
%end;
%end;
proc print data=&outdata;
title 'Matched Data Set';
Run;
%mend;
%matches(dataf=m.ppi_case,datal=m.ppi_ctrl_clean3,outdata=m.match3);
/*726 matches*/
PROC PRINTTO PRINT=PRINT LOG=LOG ;
RUN;
proc sql;
create table m.ppi_ctrl_clean4 as
select * from m.ppi_ctrl_clean3 where reference_key not in (Select reference_key_ctrl from m.match3);
quit; *154201;
proc printto log="C:\Users\Angel YS Wong\Desktop\PPI\program\CTC\match4.log";
run;
%macro matches(dataf=,datal=,outdata=);
%if %sysfunc(exist(&outdata)) %then %do;
proc datasets;
delete &outdata;
Run;
%end;
/* Determine the number of observations in the case data set. */
data _null_;
dsid=open("&dataf",'i');
nobs=attrn(dsid,'nobs');
call symput('nobs',nobs);
Run;
data datalast;
set &datal;
Run;
%put nobs = &nobs;
%do n=1 %to &nobs;
/* Determine the number of observations in the control data
set. */
data _null_;
dsid=open("datalast",'i');
nobs=attrn(dsid,'nobs');
call symput('conobs',nobs);
Run;
%let mmatch=1;
data matches1;
choose=&n;
set &dataf point=choose;
output;
stop;
Run;
/* The match indicator variable is set to zero, the
variables in the control data set are renamed, and the
matching criteria is coded. */
data matches1;
set matches1;
i=1;
match=0;
do until(match=1);
/* Set the control data set and rename the variables*/
set datalast(rename=(reference_key=reference_key_ctrl
dob_year=dob_year_ctrl
gender=gender_ctrl
st_st=stst_ctrl
st_en=sten_ctrl)
) point=i;
/* If the control matches the case, set match=1 to allow
for this matched control to be appended to the match
data set and deleted from the control data set. */
if reference_key~=reference_key_ctrl and dob_year=dob_year_ctrl and gender=gender_ctrl and stst_ctrl<=eventd<=sten_ctrl then do;
match=1;
call symput("matchn",i);
output;
end;
/* If the control does not match the case and all controls
have been examined as potential matches, set match=1 to
exit the do loop. */
if match=0 and i=&conobs then do;
call symput("mmatch",match);
match=1;
end;
/* If the control does not match the case and all controls
have not been examined, set match=0 and go to the next
control. */
if match=0 then i=i+1;
end;
stop;
Run;
/* Append the matches to the matched data set and deleted
the matched control from the control data set. */
%if &mmatch=1 %then %do;
proc append base=&outdata data=matches1 force;
Run;
data datalast;
set datalast;
if _n_=&matchn then delete;
Run;
%end;
%end;
proc print data=&outdata;
title 'Matched Data Set';
Run;
%mend;
%matches(dataf=m.ppi_case,datal=m.ppi_ctrl_clean4,outdata=m.match4);
/*725 matches*/

data m.match_all;
set m.match1 m.match2 m.match3 m.match4;
run; *2903;

proc sql;
create table case_left as
select * from m.ppi_case where reference_key not in (select reference_key from m.match_all);
quit; *1, born in year of 1901;

proc sort data=m.match_all nodupkey out=a;
by reference_key_ctrl;run;*2903;
data a;
set m.match_all;
if dob_year~=dob_year_ctrl;
run; *same;
data a;
set m.match_all;
if gender~=gender_ctrl;
run; *same;
data a;
set m.match_all;
if stst_ctrl<=eventd<=sten_ctrl;
run; *yes;

data match_all;
set m.match_all;
keep reference_key_ctrl;run;
PROC EXPORT DATA= match_all
            OUTFILE= "C:\Users\Angel YS Wong\Desktop\PPI\CDARS Data\refkey\match_all.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=No;
RUN;

