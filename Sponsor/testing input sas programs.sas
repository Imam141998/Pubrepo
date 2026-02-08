
/*****************************************************************************************
Program Name : testing input sas programs.sas
Purpose      : Test execution of CRO macro catalog using simulated / sample input data.
               This program validates macro functionality, input handling, and
               derived outputs in a sponsor environment.

Author       : Imam Noorbhash
Created On   : 2026-02-08

Input Data   : Simulated / sample SAS datasets created within the program
               (e.g., SDTM-/ADaM-like structures as applicable).

Output Data  : Temporary WORK datasets and/or test output datasets
               created for validation purposes only.

Macro Usage  : Macros are sourced from the compiled CRO macro catalog
               (SASMACR.sas7bcat). No %INCLUDE statements are used.

Environment  : Sponsor validation / local test environment

Pre-requisite:
   - Macro catalog must be assigned prior to execution:
       libname macrocat "<path>\SASMACR.sas7bcat";
       options mstored sasmstore=macrocat;

Notes        :
   - This program is intended for macro testing and validation only.
   - Not for production or clinical reporting use.
   - Any changes to macro inputs or logic should be revalidated.

*****************************************************************************************/
libname macrocat "F:\sponsor end";

option mstored sasmstore=macrocat;



%srt(sashelp.class out=cls,age);

data vs_input;
    length USUBJID $12 RFSTDTC VSDTC $10;
    format RFSTDT VSDT date9.;
    
    infile datalines dlm='|' truncover;
    input 
        USUBJID $
        RFSTDTC $
        VSDTC   $;

    /* Convert to numeric dates if needed */
    RFSTDT = input(RFSTDTC, yymmdd10.);
    VSDT   = input(VSDTC,   yymmdd10.);

datalines;
SUBJ-001|2023-01-10|2023-01-08
SUBJ-001|2023-01-10|2023-01-10
SUBJ-001|2023-01-10|2023-01-12
SUBJ-001|2023-01-10|2023-01-20
SUBJ-002|2023-02-01|2023-01-31
SUBJ-002|2023-02-01|2023-02-01
SUBJ-002|2023-02-01|2023-02-05
SUBJ-003|2023-03-15|2023-03-15
SUBJ-003|2023-03-15|2023-03-16
SUBJ-003|2023-03-15|2023-03-25
;
run;

data fin;
set vs_input;
%stdy(REFDATE=RFSTDT,DATE=VSDT,DY=vsdy);
%DTC_DT(dtcdt=RFSTDTC,dat_var=TRTSDT,time_var=,datetime_var=);
run;


data lb_sim;
    length STUDYID $10 USUBJID $20 LBTESTCD $8 LBTEST $40
           LBDTC $10 VISIT $40;
    format LBSTRESN 8.2;

    infile datalines dlm='|' truncover;
    input STUDYID $
          USUBJID $
          LBTESTCD $
          LBTEST $
          VISIT $
          LBDTC $
          LBSTRESN ;

datalines;
STUDY01|SUBJ-001|ALT|Alanine Aminotransferase|SCREENING|2023-01-01|45
STUDY01|SUBJ-001|ALT|Alanine Aminotransferase|BASELINE|2023-01-05|50
STUDY01|SUBJ-001|ALT|Alanine Aminotransferase|DAY 1|2023-01-06|55
STUDY01|SUBJ-001|ALT|Alanine Aminotransferase|DAY 7|2023-01-12|60
STUDY01|SUBJ-001|AST|Aspartate Aminotransferase|SCREENING|2023-01-02|40
STUDY01|SUBJ-001|AST|Aspartate Aminotransferase|DAY 1|2023-01-06|42
STUDY01|SUBJ-002|ALT|Alanine Aminotransferase|SCREENING|2023-02-01|48
STUDY01|SUBJ-002|ALT|Alanine Aminotransferase|DAY 1|2023-02-04|52
STUDY01|SUBJ-002|ALT|Alanine Aminotransferase|DAY 7|2023-02-10|.
;
run;

data dm;
    length STUDYID $10 USUBJID $20 RFSTDTC $10;
    infile datalines dlm='|' truncover;
    input STUDYID $ USUBJID $ RFSTDTC $;
datalines;
STUDY01|SUBJ-001|2023-01-06
STUDY01|SUBJ-002|2023-02-04
;
run;

data lb;
merge dm(in=a) lb_sim(in=b);
by usubjid;
if a and b;
run;
%dd_blfl(indsn=lb,outdsn=final, flagvar=LBBLFL,cond=%str(LBSTRESN  ne . and . < input(LBDTC,yymmdd10.)  < input(RFSTDTC,yymmdd10.)) ,
byvar=USUBJID LBTESTCD LBDTC,keepvars=,lastdot=lbtestcd);
