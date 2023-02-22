/*Updated on 21 Nov 2016
Purpose: document the cross-checking datasets for PPIs vs MI project*/

libname c "W:\Angel\MPhil\cross_check\PPIs_MI\SCCS_original\Celine";
libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";
libname ne "C:\Users\Angel YS Wong\Desktop\PPI\program\negative exposure";
libname hs "C:\Users\Angel YS Wong\Desktop\H2RA\program\SCCS";
libname cc "W:\Angel\MPhil\cross_check\PPIs_MI\SCCS_H2RA\Celine";
libname pp "C:\Users\Angel YS Wong\Desktop\PPI\program\additional analysis";

/*checking SCCS primary analysis only considering PPIs*/
data celine;
set c.final_primary;
keep reference_key rxst rxed st_st nnst_en admit event age r;
run;*21579;
data celine;
set celine;
if r=5 then rw=0;
if r=4 then rw=1;
if r=1 then rw=2;
if r=2 then rw=3;
if r=3 then rw=4;
run;
proc sql;
create table a_c as
select * from p.primary_risk_final A left join (select rxst, rxed, rw, admit, age as c_age from celine B)
on A.reference_key=B.reference_key and A.pst=B.rxst;
quit; *21579;

data a_c2;
set a_c;
if missing(rxst);
run; *0;
data a_c2;
set a_c;
if pen~=rxed;
run; *0;
data a_c2;
set a_c;
if r~=rw;
run; *0;
data a_c2;
set a_c;
if eventd~=admit;
run; *0;
data a_c2;
set a_c;
if age~=c_age;
run;*0; 

/*checking multiple exposures
Updated on 14 Nov 2016*/
data celine;
set c.final;
keep reference_key rxst rxed st_st nnst_en admit event age r cla nlr nhr;
run;*21351, me: 21351;
proc sql;
create table a_c as
select * from celine where reference_key not in (select reference_key from p.all4_cl_nshl_rw);
quit; *0;
proc sql;
create table a_c as
select * from p.all4_cl_nshl_rw where reference_key not in (select reference_key from celine);
quit; *0;
data celine;
set celine;
if r=5 then rw=0;
if r=4 then rw=1;
if r=1 then rw=2;
if r=2 then rw=3;
if r=3 then rw=4;
run;
data final;
set p.all4_cl_nshl_rw;
if pst<=eventd<=pen then event=1;
else event=0;
run;
proc sql;
create table a_c as
select * from final A left join (select rxst, rxed, rw, admit, age as c_age, cla, nlr, nhr, event as c_event from celine B)
on A.reference_key=B.reference_key and A.pst=B.rxst;
quit; *21351;
data a_c2;
set a_c;
if missing(rxst);
run; *0;
data a_c2;
set a_c;
if pen~=rxed;
run; *0;
data a_c2;
set a_c;
if cla~=cl;
run; *0;
data a_c2;
set a_c;
if nlr~=nsl;
run; *0;
data a_c2;
set a_c;
if nhr~=nsh;
run; *0;
data a_c2;
set a_c;
if r~=rw;
run; *0;
data a_c2;
set a_c;
if age~=c_age;
run; *0;
data a_c2;
set a_c;
if event~=c_event;
run; *0;
*same datasets, done checking;

/*Updated on 14 Nov 2016
SA(1) Remove Px who had GI bleed that required hospitalization 60d before any OP PPI start date*/

data celine;
set c.sa1_final;
keep reference_key rxst rxed st_st nnst_en admit event age r;
run;*21441;
data celine;
set celine;
if r=5 then rw=0;
if r=4 then rw=1;
if r=1 then rw=2;
if r=2 then rw=3;
if r=3 then rw=4;
run;
proc sql;
create table a_c as
select * from p.sen5_gib A left join (select rxst, rxed, rw, admit, age as c_age, event as c_event, st_st as cst_st, nnst_en from celine B)
on A.reference_key=B.reference_key and A.pst=B.rxst;
quit; *21441;

data a_c2;
set a_c;
if missing(rxst);
run; *0;
data a_c2;
set a_c;
if pen~=rxed;
run; *0;
data a_c2;
set a_c;
if r~=rw;
run; *0;
data a_c2;
set a_c;
if eventd~=admit;
run; *0;
data a_c2;
set a_c;
if age~=c_age;
run;*0; 
data a_c2;
set a_c;
if st_st~=cst_st;
run;*0; 
data a_c2;
set a_c;
if st_en~=nnst_en;
run;*0; 
data a_c2;
set a_c;
if c_event~=event;
run;*0; 
*Same datasets! done cross-checking;

/*Updated on 14 Nov 2016
data celine;
SA(2) re-do multiple exposure SCCS with NSAID as a whole group, not divide them to low or high risk*/
data celine;
set c.sa2_final;
keep reference_key rxst rxed st_st nnst_en admit event age r cla nsaid;
run;*21052;
set celine;
if r=5 then rw=0;
if r=4 then rw=1;
if r=1 then rw=2;
if r=2 then rw=3;
if r=3 then rw=4;
run;
data final;
set p.all4_cl_ns_rw;
if pst<=eventd<=pen then event=1;
else event=0;
run;
proc sql;
create table a_c as
select * from final A left join (select rxst, rxed, rw, admit, age as c_age, cla, nsaid, event as c_event from celine B)
on A.reference_key=B.reference_key and A.pst=B.rxst;
quit; *21052;

data a_c2;
set a_c;
if missing(rxst);
run; *0;
data a_c2;
set a_c;
if pen~=rxed;
run; *0;
data a_c2;
set a_c;
if cla~=cl;
run; *0;
data a_c2;
set a_c;
if ns~=nsaid;
run; *0;
data a_c2;
set a_c;
if r~=rw;
run; *0;
data a_c2;
set a_c;
if age~=c_age;
run; *0;
data a_c2;
set a_c;
if event~=c_event;
run; *0;
*Same datasets! done cross-checking;

/*Updated on 14 Nov 2016
SA(3) chop risk period to: exposure period, 1-30d, 31-60d (no need adjusted CLA NSAID Low risk NSAID high risk)*/
data celine;
set c.sa3_final;
keep reference_key rxst rxed st_st nnst_en admit event age r;
run;*20937;
data celine;
set celine;
if r=5 then rw=0;
if r=2 then rw=1;
if r=1 then rw=2;
if r=3 then rw=3;
if r=4 then rw=4;
run;
proc sql;
create table a_c as
select * from p.sen3_primary_risk_final A left join (select rxst, rxed, rw, admit, age as c_age, event as c_event, st_st as cst_st, nnst_en from celine B)
on A.reference_key=B.reference_key and A.pst=B.rxst;
quit; *20937;
data a_c2;
set a_c;
if missing(pst);
run; *0;
data a_c2;
set a_c;
if pen~=rxed;
run; *0;
data a_c2;
set a_c;
if r~=rw;
run; *0;
data a_c2;
set a_c;
if eventd~=admit;
run; *0;
data a_c2;
set a_c;
if age~=c_age;
run;*0; 
data a_c2;
set a_c;
if st_st~=cst_st;
run;*0; 
data a_c2;
set a_c;
if st_en~=nnst_en;
run;*0; 
data a_c2;
set a_c;
if c_event~=event;
run;*0; 
*Same datasets! done cross-checking;


/*Updated on 14 Nov 2016
SA(4) Exclude Px who had PPI Rx dur of >56d after overlapping with <=30d gap*/
data celine;
set c.sa4_final;
keep reference_key rxst rxed st_st nnst_en admit event age r;
run;*19890;
data celine;
set celine;
if r=5 then rw=0;
if r=4 then rw=1;
if r=1 then rw=2;
if r=2 then rw=3;
if r=3 then rw=4;
run;
proc sql;
create table a_c as
select * from p.sen4_primary_risk_final A left join (select rxst, rxed, rw, admit, age as c_age, event as c_event, st_st as cst_st, nnst_en from celine B)
on A.reference_key=B.reference_key and A.pst=B.rxst;
quit; *19890;
data a_c2;
set a_c;
if missing(rxst);
run; *0;
data a_c2;
set a_c;
if pen~=rxed;
run; *0;
data a_c2;
set a_c;
if r~=rw;
run; *0;
data a_c2;
set a_c;
if eventd~=admit;
run; *0;
data a_c2;
set a_c;
if age~=c_age;
run;*0; 
data a_c2;
set a_c;
if st_st~=cst_st;
run;*0; 
data a_c2;
set a_c;
if st_en~=nnst_en;
run;*0; 
data a_c2;
set a_c;
if c_event~=event;
run;*0; 
*Same datasets! done cross-checking;

/*Updated on 15 Nov 2016
additional H2RA analysis*/
data celine;
set c.final_h2;
keep reference_key rxst rxed st_st nnst_en admit event age r h2;
run;*9351;
data celine;
set celine;
if r=5 then rw=0;
if r=4 then rw=1;
if r=1 then rw=2;
if r=2 then rw=3;
if r=3 then rw=4;
run;
data final;
set ne.all4_h2_rw4;
if pst<=eventd<=pen then event=1;
else event=0;
run;
proc sql;
create table a_c as
select * from final A left join (select rxst, rxed, rw, admit, age as c_age, h2 as c_h2, event as c_event from celine B)
on A.reference_key=B.reference_key and A.pst=B.rxst;
quit; *9351;

data a_c2;
set a_c;
if missing(rxst);
run; *0;
data a_c2;
set a_c;
if pen~=rxed;
run; *0;
data a_c2;
set a_c;
if h2~=c_h2;
run; *0;
data a_c2;
set a_c;
if r~=rw;
run; *0;
data a_c2;
set a_c;
if age~=c_age;
run; *0;
data a_c2;
set a_c;
if event~=c_event;
run; *0;
*Same datasets! done cross-checking;

/*Updated on 17 Nov 2016
CTC analysis for PPIs vs MI*/
libname c "W:\Angel\MPhil\cross_check\PPIs_MI\CTC\Celine";
libname m "C:\Users\Angel YS Wong\Desktop\PPI\program\CTC";

*risk window 1 (day 1-14);
data c_1to14;
set c.d01_14_final;
run; *136031, me 135930;
data c_1to14;
set c_1to14;
if reference_key=361284 then delete;
run; *135930, delete this person because can't be matched with others;
proc sql;
create table a_c as
select * from c_1to14 A left join (select cc_pst, cc_pen, rw, exp, matchid, mi from m.ctc_rw1 B)
on A.reference_key=B.reference_key and A.pst=B.cc_pst;
quit; *135930;
data a_c2;
set a_c;
if missing(cc_pst);
run;  *0;
data a_c2;
set a_c;
if cc_pen~=ped;
run; *0;
data a_c2;
set a_c;
if rw~=r;
run; *0;
data a_c2;
set a_c;
if exp~=expose;
run; *0;
data a_c2;
set a_c;
if matchid~=refkey_matched;
run; *0;
data a_c2;
set a_c;
if case~=mi;
run; *0;
*checked, same dataset!;

*risk window 2 (day 15-30);
data c_15to30;
set c.d15_30_final;
run; *143093, me 142992;
data c_15to30;
set c_15to30;
if reference_key=361284 then delete;
run; *142992;
proc sql;
create table a_c as
select * from c_15to30 A left join (select cc_pst, cc_pen, rw, exp, matchid, mi from m.ctc_rw2 B)
on A.reference_key=B.reference_key and A.pst=B.cc_pst;
quit; *142992;
data a_c2;
set a_c;
if missing(cc_pst);
run;  *0;
data a_c2;
set a_c;
if cc_pen~=ped;
run; *0;
data a_c2;
set a_c;
if rw~=r;
run; *0;
data a_c2;
set a_c;
if exp~=expose;
run; *0;
data a_c2;
set a_c;
if matchid~=refkey_matched;
run; *0;
data a_c2;
set a_c;
if case~=mi;
run; *0;
*checked, same dataset!;

*risk window 3 (day 31-60);
data c_31to60;
set c.d31_60_final;
run; *188049, me 187956;
data c_31to60;
set c_31to60;
if reference_key=361284 then delete;
run; *187956;
proc sql;
create table a_c as
select * from c_31to60 A left join (select cc_pst, cc_pen, rw, exp, matchid, mi from m.ctc_rw3 B)
on A.reference_key=B.reference_key and A.pst=B.cc_pst;
quit; *187956;
data a_c2;
set a_c;
if missing(cc_pst);
run;  *0;
data a_c2;
set a_c;
if cc_pen~=ped;
run; *0;
data a_c2;
set a_c;
if rw~=r;
run; *0;
data a_c2;
set a_c;
if exp~=expose;
run; *0;
data a_c2;
set a_c;
if matchid~=refkey_matched;
run; *0;
data a_c2;
set a_c;
if case~=mi;
run; *0;
*checked, same dataset!;

/*Updated on 18 Nov 2016
CTC analysis for PPIs vs MI and H2 blockers*/

*risk window 1 (day 1-14);
data c_1to14;
set c.d01_14h2final;
run; *136031, me 135930;
data c_1to14;
set c_1to14;
if reference_key=361284 then delete;
run; *135930, delete this person because can't be matched with others;
proc sql;
create table a_c as
select * from c_1to14 A left join (select cc_pst, cc_pen, rw, exp, matchid, mi, h2b from m.ctc_h2_1 B)
on A.reference_key=B.reference_key and A.pst=B.cc_pst;
quit; *135930;
data a_c2;
set a_c;
if missing(cc_pst);
run;  *0;
data a_c2;
set a_c;
if cc_pen~=ped;
run; *0;
data a_c2;
set a_c;
if rw~=r;
run; *0;
data a_c2;
set a_c;
if exp~=expose;
run; *0;
data a_c2;
set a_c;
if matchid~=refkey_matched;
run; *0;
data a_c2;
set a_c;
if case~=mi;
run; *0;
data a_c2;
set a_c;
if h2_expose~=h2b;
run; *0; 

*same dataset!;

*risk window 2 (day 15-30);
data c_15to30;
set c.d15_30h2final;
run; *143093, me 142992;
data c_15to30;
set c_15to30;
if reference_key=361284 then delete;
run; *142992;
proc sql;
create table a_c as
select * from c_15to30 A left join (select cc_pst, cc_pen, rw, exp, matchid, mi, h2b from m.ctc_h2_2 B)
on A.reference_key=B.reference_key and A.pst=B.cc_pst;
quit; *142992;
data a_c2;
set a_c;
if missing(cc_pst);
run;  *0;
data a_c2;
set a_c;
if cc_pen~=ped;
run; *0;
data a_c2;
set a_c;
if rw~=r;
run; *0;
data a_c2;
set a_c;
if exp~=expose;
run; *0;
data a_c2;
set a_c;
if matchid~=refkey_matched;
run; *0;
data a_c2;
set a_c;
if case~=mi;
run; *0;
data a_c2;
set a_c;
if h2_expose~=h2b;
run; *0; 
*same dataset!;
*risk window 3 (day 31-60);
data c_31to60;
set c.d31_60h2final;
run; *188049, me 187956;
data c_31to60;
set c_31to60;
if reference_key=361284 then delete;
run; *187956;
proc sql;
create table a_c as
select * from c_31to60 A left join (select cc_pst, cc_pen, rw, exp, matchid, mi, h2b from m.ctc_h2_3 B)
on A.reference_key=B.reference_key and A.pst=B.cc_pst;
quit; *187956;
data a_c2;
set a_c;
if missing(cc_pst);
run;  *0;
data a_c2;
set a_c;
if cc_pen~=ped;
run; *0;
data a_c2;
set a_c;
if rw~=r;
run; *0;
data a_c2;
set a_c;
if exp~=expose;
run; *0;
data a_c2;
set a_c;
if matchid~=refkey_matched;
run; *0;
data a_c2;
set a_c;
if case~=mi;
run; *0;
data a_c2;
set a_c;
if h2_expose~=h2b;
run; *0;
*same dataset!; 


/*Updated on 29 Dec 2016
checking SCCS primary analysis only considering short-term H2RAs*/
data celine;
set cc.final_h2durlessthan56d;
keep reference_key rxst rxed st_st st_en admit event age r;
run;*18715;
data celine;
set celine;
if r=5 then rw=0;
if r=4 then rw=1;
if r=1 then rw=2;
if r=2 then rw=3;
if r=3 then rw=4;
run;

proc sql;
create table a_c as
select * from hs.primary_risk_final A left join (select rxst, rxed, rw, admit, age as c_age, st_st as c_stst, st_en as c_sten from celine B)
on A.reference_key=B.reference_key and A.pst=B.rxst;
quit; *18715;

data a_c2;
set a_c;
if missing(rxst);
run; *0;
data a_c2;
set a_c;
if pen~=rxed;
run; *0;
data a_c2;
set a_c;
if r~=rw;
run; *0;
data a_c2;
set a_c;
if eventd~=admit;
run; *0;
data a_c2;
set a_c;
if age~=c_age;
run;*0; 
data a_c2;
set a_c;
if st_st~=c_stst;
run;*0;
data a_c2;
set a_c;
if st_en~=c_sten;
run; *0;

*all are same;

/*Updated on 29 Dec 2016
checking SCCS primary analysis considering all H2RAs*/
data celine;
set cc.final_h2alldur;
keep reference_key rxst rxed st_st st_en admit event age r;
run;*34155;
data celine;
set celine;
if r=5 then rw=0;
if r=4 then rw=1;
if r=1 then rw=2;
if r=2 then rw=3;
if r=3 then rw=4;
run;

proc sql;
create table a_c as
select * from celine where reference_key not in (select reference_key from hsa.primary_risk_final2);
quit; *0;
proc sql;
create table a_c as
select * from hsa.primary_risk_final2 where reference_key not in (select reference_key from celine);
quit; *0;

proc sql;
create table a_c as
select * from hsa.primary_risk_final2 A left join (select rxst, rxed, rw, admit, age as c_age, st_st as c_stst, st_en as c_sten from celine B)
on A.reference_key=B.reference_key and A.pst=B.rxst;
quit; *34155;

data a_c2;
set a_c;
if missing(rxst);
run; *0;
data a_c2;
set a_c;
if pen~=rxed;
run; *0;
data a_c2;
set a_c;
if r~=rw;
run; *0;
data a_c2;
set a_c;
if eventd~=admit;
run; *0;
data a_c2;
set a_c;
if age~=c_age;
run;*0; 
data a_c2;
set a_c;
if st_st~=c_stst;
run; *0;
data a_c2;
set a_c;
if st_en~=c_sten;
run; *0;

*all are same;


/*Updated on 30 Dec 2016
checking SCCS primary analysis considering all PPIs*/
data celine;
set c.final_alldur;
keep reference_key rxst rxed st_st nnst_en admit event age r;
run;*41273;
data celine;
set celine;
if r=5 then rw=0;
if r=4 then rw=1;
if r=1 then rw=2;
if r=2 then rw=3;
if r=3 then rw=4;
run;

proc sql;
create table a_c as
select * from celine where reference_key not in (select reference_key from pp.primary_risk_final2);
quit; *0;
proc sort data=a_c nodupkey;
by reference_key;
run;
proc sql;
create table a_c as
select * from pp.primary_risk_final2 where reference_key not in (select reference_key from celine);
quit; *0;

proc sql;
create table a_c as
select * from pp.primary_risk_final2 A left join (select rxst, rxed, rw, admit, age as c_age, st_st as c_stst, nnst_en as c_sten from celine B)
on A.reference_key=B.reference_key and A.pst=B.rxst;
quit; *41273;

data a_c2;
set a_c;
if missing(rxst);
run; *0;
data a_c2;
set a_c;
if pen~=rxed;
run; *0;
data a_c2;
set a_c;
if r~=rw;
run; *0;
data a_c2;
set a_c;
if eventd~=admit;
run; *0;
data a_c2;
set a_c;
if age~=c_age;
run;*0; 
data a_c2;
set a_c;
if st_st~=c_stst;
run; *0;
data a_c2;
set a_c;
if st_en~=c_sten;
run; *0;

*all are the same;

