# Macro SMILE_ATTRN

Function-style macro to return a numeric attribute of a dataset. The following attributes are available: ALTERPW, ANOBS, ANY, ARAND, ARWU, AUDIT, AUDIT_DATA, AUDIT_BEFORE, AUDIT_ERROR, CRDTE, ICONST, INDEX, ISINDEX, ISSUBSET, LRECL, LRID, MAXGEN, MAXRC, MODTE, NDEL, NEXTGEN, NLOBS, NLOBSF, NOBS, NVARS, PW, RADIX, READPW, REUSE, TAPE, WHSTMT, WRITEPW

- Author: Katja Glass
- Date: 2021-02-19
- SAS Version: SAS 9.4
- License: MIT
- Reference: Main programming parts are coming from attrn.sas macro from Roland Rashleigh-Berry who has published his code under the unlicence license in his utility package (http://www.datasavantconsulting.com/roland/Spectre/download.html)
- Example Program: [test_smile_attrn](test_smile_attrn.md)

## Parameters

Parameter | Description
---|---
DATA |name of the SAS dataset
ATTRIB |SAS ATTRN keyword (e.g. NOBS, CRDTE, ...)

<br/>


## Examples

```
%PUT Number of observations: %smile_attrn(sashelp.class, nobs);
%IF %smile_attrn(sashelp.class, nvars) > 0 %THEN %PUT Dataset has variables;
```

## Checks

- ATTRIB must contain valid options;

## Macro

``` sas linenums="1"
%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Macro      : smile_attrn
%* Parameters : DATA   - name of the SAS dataset
%*              ATTRIB - SAS ATTRN keyword (e.g. NOBS, CRDTE, ...)
%*
%* Purpose    : Function-style macro to return a numeric attribute of a dataset. The following attributes are available:
%*              ALTERPW, ANOBS, ANY, ARAND, ARWU, AUDIT, AUDIT_DATA, AUDIT_BEFORE, AUDIT_ERROR, CRDTE, ICONST, INDEX,
%*              ISINDEX, ISSUBSET, LRECL, LRID, MAXGEN, MAXRC, MODTE, NDEL, NEXTGEN, NLOBS, NLOBSF, NOBS, NVARS, PW, RADIX,
%*              READPW, REUSE, TAPE, WHSTMT, WRITEPW
%*
%* ExampleProg: ../programs/test_smile_attrn.sas
%*
%* Author     : Katja Glass
%* Creation   : 2021-02-19
%* License    : MIT
%*
%* Reference  : Main programming parts are coming from attrn.sas macro from Roland Rashleigh-Berry who
%*              has published his code under the unlicence license in his utility package
%*              (http://www.datasavantconsulting.com/roland/Spectre/download.html)
%*
%* SAS Version: SAS 9.4
%*
%************************************************************************************************************************;
/*
Examples:
%PUT Number of observations: %smile_attrn(sashelp.class, nobs);
%IF %smile_attrn(sashelp.class, nvars) > 0 %THEN %PUT Dataset has variables;
*/
%************************************************************************************************************************;
 
%MACRO smile_attrn(data, attrib) / MINOPERATOR MINDELIMITER=',';
   %LOCAL dsid rc macro;
 
   %LET macro = &sysmacroname;
 
   %* check: ATTRIB must contain valid options;
   %IF NOT (%UPCASE(&attrib) IN (ALTERPW,ANOBS,ANY,ARAND,ARWU,AUDIT,AUDIT_DATA,AUDIT_BEFORE,AUDIT_ERROR,CRDTE,ICONST,INDEX,
                                ISINDEX,ISSUBSET,LRECL,LRID,MAXGEN,MAXRC,MODTE,NDEL,NEXTGEN,NLOBS,NLOBSF,NOBS,NVARS,PW,RADIX,
                                READPW,REUSE,TAPE,WHSTMT,WRITEPW))
   %THEN %DO;
       %PUT %STR(ERR)OR: &macro - Invalid value for ATTRIB (&attrib).;
       -1
       %RETURN;
   %END;
 
   %* perform action and put value for processing;
   %LET dsid=%SYSFUNC(OPEN(&data,is));
 
   %IF &dsid EQ 0
   %THEN %DO;
       %PUT %STR(ERR)OR: &macro - DATA (&data) does not exist.;
       -1
   %END;
   %ELSE %DO;
       %SYSFUNC(attrn(&dsid,&attrib))
       %LET rc=%SYSFUNC(CLOSE(&dsid));
   %END;
%MEND smile_attrn;
```

