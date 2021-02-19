# Macro SMILE_ATTRC

Function-style macro to return a character attribute of a dataset. The following attributes are available: CHARSET, COMPRESS, DATAREP, ENCODING, ENCRYPT, ENGINE, LABEL, LIB, MEM, MODE, MTYPE, SORTEDBY, SORTLVL, SORTSEQ, TYPE

- Author: Katja Glass
- Date: 2021-02-19
- SAS Version: SAS 9.4
- License: MIT
- Reference: Main programming parts are coming from attrc.sas macro from Roland Rashleigh-Berry who has published his code under the unlicence license in his utility package (http://www.datasavantconsulting.com/roland/Spectre/download.html)
- Example Program: [test_smile_attrc](test_smile_attrc.md)

## Parameters

Parameter | Description
---|---
DATA |name of the SAS dataset
ATTRIB |SAS ATTRC keyword (e.g. TYPE, LIB, LABEL, SORTEDBY, ...)

<br/>


## Examples

```
%PUT library of dataset: %smile_attrc(sashelp.class, lib);
PROC SORT DATA=sashelp.class OUT=class; BY sex name; RUN;
%PUT class is sorted by: %smile_attrc(class, SORTEDBY);
%PUT sashelp.class is sorted by: %smile_attrc(sashelp.class, SORTEDBY);
```

## Checks

- ATTRIB must contain valid options;

## Macro

``` sas linenums="1"
%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Macro      : smile_attrc
%* Parameters : DATA   - name of the SAS dataset
%*              ATTRIB - SAS ATTRC keyword (e.g. TYPE, LIB, LABEL, SORTEDBY, ...)
%*
%* Purpose    : Function-style macro to return a character attribute of a dataset. The following attributes are available:
%*              CHARSET, COMPRESS, DATAREP, ENCODING, ENCRYPT, ENGINE, LABEL, LIB, MEM, MODE, MTYPE, SORTEDBY, SORTLVL,
%*              SORTSEQ, TYPE
%*
%* ExampleProg: ../programs/test_smile_attrc.sas
%*
%* Author     : Katja Glass
%* Creation   : 2021-02-19
%* License    : MIT
%*
%* Reference  : Main programming parts are coming from attrc.sas macro from Roland Rashleigh-Berry who
%*              has published his code under the unlicence license in his utility package
%*              (http://www.datasavantconsulting.com/roland/Spectre/download.html)
%*
%* SAS Version: SAS 9.4
%*
%************************************************************************************************************************;
/*
Examples:
%PUT library of dataset: %smile_attrc(sashelp.class, lib);
PROC SORT DATA=sashelp.class OUT=class; BY sex name; RUN;
%PUT class is sorted by: %smile_attrc(class, SORTEDBY);
%PUT sashelp.class is sorted by: %smile_attrc(sashelp.class, SORTEDBY);
*/
%************************************************************************************************************************;
 
%MACRO smile_attrc(data, attrib) / MINOPERATOR MINDELIMITER=',';
   %LOCAL dsid rc macro;
 
   %LET macro = &sysmacroname;
 
   %* check: ATTRIB must contain valid options;
   %IF NOT (%UPCASE(&attrib) IN (CHARSET,COMPRESS,DATAREP,ENCODING,ENCRYPT,ENGINE,LABEL,LIB,MEM,MODE,MTYPE,
                                 SORTEDBY,SORTLVL,SORTSEQ,TYPE))
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
       %SYSFUNC(attrc(&dsid,&attrib))
       %LET rc=%SYSFUNC(CLOSE(&dsid));
   %END;
%MEND smile_attrc;
```

