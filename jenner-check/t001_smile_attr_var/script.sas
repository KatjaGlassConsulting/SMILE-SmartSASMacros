/* jenner-check bundle for macros/smile_attr_var.sas (KatjaGlassConsulting/SMILE-SmartSASMacros)
   The macro definition below is copied verbatim from the repo's macros/smile_attr_var.sas.
   The caller below is adapted from programs/test_smile_attr_var.sas: the repo's own
   %INCLUDE/SASAUTOS setup (which points at a local checkout path) is replaced with a direct
   macro definition in this file, since the bundle ships the macro inline instead of via
   %INCLUDE. The macro calls themselves (VARTYPE/VARLABEL/VARLEN + the three error cases)
   are unmodified from the repo's test program, including its use of sashelp.class. */

%MACRO smile_attr_var(data, var, attrib);
    %LOCAL dsid rc macro varnum;

    %LET macro = &sysmacroname;

    %* check: ATTRIB must contain valid options;
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

*************************************************************************;
* Example 1 - simple examples (log-output), from programs/test_smile_attr_var.sas;
*************************************************************************;
%PUT VARTYPE for name:  %smile_attr_var(sashelp.class, name, vartype);
%PUT VARTYPE for age:   %smile_attr_var(sashelp.class, age, vartype);
%PUT VARLABEL for name: %smile_attr_var(sashelp.class, name, varlabel);
%PUT VARLEN for name:   %smile_attr_var(sashelp.class, name, varlen);

*************************************************************************;
* Example 2 - error case examples (log-output);
*************************************************************************;
%PUT data does not exist:     %smile_attr_var(dummy, name, varlen);
%PUT variable does not exist: %smile_attr_var(sashelp.class, dummy, varlen);
%PUT invalid attribute:       %smile_attr_var(sashelp.class, name, dummy);
