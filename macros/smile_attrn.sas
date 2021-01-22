%************************************************************************************************************************;
%* Project    : SMILE – SAS Macros, Intuitive Library Extention 
%* Macro      : smile_attrn
%* Parameters : DATA   - name of the SAS dataset
%*              ATTRIB - SAS ATTRN keyword (e.g. NOBS, CRDTE, ...)
%*              
%* Purpose    : Function-style macro to return a numeric attribute of a dataset. The following attributes are available:
%*              ALTERPW, ANOBS, ANY, ARAND, ARWU, AUDIT, AUDIT_DATA, AUDIT_BEFORE, AUDIT_ERROR, CRDTE, ICONST, INDEX, 
%*              ISINDEX, ISSUBSET, LRECL, LRID, MAXGEN, MAXRC, MODTE, NDEL, NEXTGEN, NLOBS, NLOBSF, NOBS, NVARS, PW, RADIX, 
%*              READPW, REUSE, TAPE, WHSTMT, WRITEPW
%*
%* Author     : Katja Glass
%* Creation   : 2021-01-04
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


%************************************************************************************************************************;
%**                                                                                                                    **;
%** License: MIT                                                                                                       **;
%**                                                                                                                    **;
%** Copyright (c) 2021 Katja Glass Consulting                                                                          **;
%**                                                                                                                    **;
%** Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated       **;
%** documentation files (the "Software"), to deal in the Software without restriction, including without limitation    **;
%** the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and   **;
%** to permit persons to whom the Software is furnished to do so, subject to the following conditions:                 **;
%**                                                                                                                    **;
%** The above copyright notice and this permission notice shall be included in all copies or substantial portions of   **;
%** the Software.                                                                                                      **;
%**                                                                                                                    **;
%** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO   **;
%** THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE     **;
%** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,**;
%** TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE     **;
%** SOFTWARE.                                                                                                          **;
%************************************************************************************************************************;

%MACRO smile_attrn(data, attrib) / MINOPERATOR MINDELIMITER=',';
    %LOCAL dsid rc macro;
    
    %LET macro = &sysmacroname;
    
    %* check for valid options for ATTRIB when MINOPERATOR and MINDELIMITER is set;    
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
