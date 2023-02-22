/*Created on 10 July 2017
Purpose: use bootstrapping to calculate the 95% CI

See Weiner 2008 et al.

Confidence intervals for the ‘PERR’
Specifically we bootstrapped subjects to create a sample the same size
as this cohort. For each bootstrap sample, we obtained
the ‘PERR’ adjusted HR. After repeating this 999
times, the ‘PERR’ adjusted HRs were sorted and the
25th and 975th were considered the lower and upper
limits of the 95% confidence interval of the adjusted HR.

*/
libname p "C:\Users\Angel YS Wong\Desktop\PPI\program\PB_PPI";

/*primary analysis
without considering inpatient PPIs*/
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
run;

/*start bootstrap*/
%let rep = 1000;
proc surveyselect data= p.perr out=bootsample
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

data p.t1;
set t1;
run;
data a;
set p.t1;run;
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
run; *0.48-0.69;


/*sensitivity analysis 2
considering inpatient PPIs*/

*start bootstrap;
%let rep = 1000;
proc surveyselect data= p.perr_sen2 out=bootsample
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

data p.t1_sen2;
set t1;
run;
data a;
set p.t1_sen2;run;
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
run; *0.61-0.91;


/*sensitivity analysis 3
considering subsequent event of MI*/

*start bootstrap;
%let rep = 1000;
proc surveyselect data= p.perr_sen3 out=bootsample
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

data p.t1_sen3;
set t1;
run;
data a;
set p.t1_sen3;run;
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
run; *0.67-1.00;
