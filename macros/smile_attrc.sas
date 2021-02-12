/**
  @file
  @brief returns a variable attribute of a dataset
  @details Function-style macro to return a character attribute of a dataset.
  The following attributes are available:


    @li CHARSET
    @li COMPRESS
    @li DATAREP
    @li ENCODING
    @li ENCRYPT
    @li ENGINE
    @li LABEL
    @li LIB
    @li MEM
    @li MODE
    @li MTYPE
    @li SORTEDBY
    @li SORTLVL
    @li SORTSEQ
    @li TYPE

  Reference  : Main programming parts are coming from attrv.sas macro from Roland Rashleigh-Berry who
           has published his code under the unlicence license in his utility package
            (http://www.datasavantconsulting.com/roland/Spectre/download.html)

  Examples:

        %PUT library of dataset: %smile_attrc(sashelp.class, lib);
        PROC SORT DATA=sashelp.class OUT=class; BY sex name; RUN;
        %PUT class is sorted by: %smile_attrc(class, SORTEDBY);
        %PUT sashelp.class is sorted by: %smile_attrc(sashelp.class, SORTEDBY);

  @param data name of the SAS dataset
  @param attrib SAS ATTRC keyword (e.g. TYPE, LIB, LABEL, SORTEDBY, ...)

  @version 9.4
  @author Katja Glass

**/

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
