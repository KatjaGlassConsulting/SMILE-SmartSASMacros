%************************************************************************************************************************;
%* Project    : SMILE – SAS Macros, Intuitive Library Extention 
%* Macro      : smile_attr_var
%* Parameters : DATA   - name of the SAS dataset
%*              VAR    - name of variable
%*              ATTRIB - SAS variable attrig keyword (e.g. VARTYPE, VARLEN, VARLABEL, VARFMT and VARINFMT)
%*              
%* Purpose    : Function-style macro to return a variable attribute of a dataset. The following attributes are available:
%*              VARTYPE, VARLEN, VARLABEL, VARFMT and VARINFMT
%*
%* Author     : Katja Glass
%* Creation   : 2021-01-04
%* License    : MIT
%*
%* Reference  : Main programming parts are coming from attrv.sas macro from Roland Rashleigh-Berry who 
%*              has published his code under the unlicence license in his utility package 
%*              (http://www.datasavantconsulting.com/roland/Spectre/download.html)
%*
%* SAS Version: SAS 9.4
%*
%************************************************************************************************************************;
/*
Examples:
%PUT VARTYPE for name:  %smile_attr_var(sashelp.class, name, vartype);
%PUT VARTYPE for age:   %smile_attr_var(sashelp.class, age, vartype);
%PUT VARLABEL for name: %smile_attr_var(sashelp.class, name, varlabel);
%PUT VARLEN for name:   %smile_attr_var(sashelp.class, name, varlen);
*/
%************************************************************************************************************************;

%MACRO smile_attr_var(data, var, attrib);
    %LOCAL dsid rc macro varnum;

    %LET macro = &sysmacroname;

    %* check for valid options for ATTRIB;
    %IF %UPCASE(&attrib) NE VARTYPE AND
        %UPCASE(&attrib) NE VARLEN AND
        %UPCASE(&attrib) NE VARLABEL AND
        %UPCASE(&attrib) NE VARFMT AND
        %UPCASE(&attrib) NE VARINFMT
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - Invalid value for ATTRIB (&attrib) - only the following are supported:;
        %PUT &macro - VARTYPE, VARLEN, VARLABEL, VARFMT and VARINFMT;
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
        %LET varnum = %SYSFUNC(VARNUM(&dsid,&var));
        %IF &varnum LT 1
        %THEN %DO;
            %PUT %STR(ERR)OR: &macro - Variable VAR (&var) does not exist in DATA (&data).;
            -1
            %RETURN;
        %END;
        %SYSFUNC(&attrib(&dsid,&varnum))
        %LET rc=%SYSFUNC(CLOSE(&dsid));
    %END;
%MEND smile_attr_var;

/**
  @file
  @brief returns a variable attribute of a dataset
  @details Function-style macro to return a variable attribute of a dataset.
  The following attributes are available:

    @li VARTYPE
    @li VARLEN
    @li VARLABE
    @li VARFMT
    @li VARINFMT

  @remark
  Main programming parts are coming from attrv.sas macro from Roland Rashleigh-Berry who has published his code under the unlicence license in his utility package
  (http://www.datasavantconsulting.com/roland/Spectre/download.html)

  Examples

        %PUT VARTYPE for name:  %smile_attr_var(sashelp.class, name, vartype);
        %PUT VARTYPE for age:   %smile_attr_var(sashelp.class, age, vartype);
        %PUT VARLABEL for name: %smile_attr_var(sashelp.class, name, varlabel);
        %PUT VARLEN for name:   %smile_attr_var(sashelp.class, name, varlen);

  @param data name of the SAS dataset
  @param var name of variable
  @param attrib SAS variable attrig keyword (e.g. VARTYPE, VARLEN, VARLABEL, VARFMT and VARINFMT)

  @version 9.4
  @author Katja Glass

**/
