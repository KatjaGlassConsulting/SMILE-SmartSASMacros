%************************************************************************************************************************;
%* Project    : SMILE – SAS Macros, Intuitive Library Extention 
%* Macro      : smile_attrc
%* Parameters : DATA   - name of the SAS dataset
%*              ATTRIB - SAS ATTRC keyword (e.g. TYPE, LIB, LABEL, SORTEDBY, ...)
%*              
%* Purpose    : Function-style macro to return a character attribute of a dataset. The following attributes are available: 
%*              CHARSET, COMPRESS, DATAREP, ENCODING, ENCRYPT, ENGINE, LABEL, LIB, MEM, MODE, MTYPE, SORTEDBY, SORTLVL, 
%*              SORTSEQ, TYPE
%* Comment    : When using MINOPERATOR and MINDELIMITER=',', then the ATTRIB parameter is checked for validitiy
%*
%* Author     : Katja Glass
%* Creation   : 2021-01-04
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

%MACRO smile_attrc(data, attrib) / MINOPERATOR MINDELIMITER=',';
    %LOCAL dsid rc macro;
    
    %LET macro = &sysmacroname;
    
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
