/* jenner-check bundle for macros/smile_attr_var.sas (KatjaGlassConsulting/SMILE-SmartSASMacros)
   The macro definition below is copied verbatim from the repo's macros/smile_attr_var.sas.
   The macro itself is function-style and only ever returns values via %PUT in the repo's
   own test program (programs/test_smile_attr_var.sas) -- this bundle instead collects the
   macro's return values for two sashelp.class variables (NAME, AGE) into a small dataset
   and PROC PRINTs it, so the macro's actual results are visible in the run's listing output
   rather than only its log. The macro calls and the two variables/attributes chosen are
   the same ones used in the repo's own test program. */

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

DATA var_attrs;
    LENGTH var_name $32 vartype $1 varlabel $200 varlen 8;
    var_name = "Name"; vartype = "%smile_attr_var(sashelp.class, name, vartype)";
    varlabel = "%smile_attr_var(sashelp.class, name, varlabel)";
    varlen = %smile_attr_var(sashelp.class, name, varlen);
    OUTPUT;
    var_name = "Age"; vartype = "%smile_attr_var(sashelp.class, age, vartype)";
    varlabel = "%smile_attr_var(sashelp.class, age, varlabel)";
    varlen = %smile_attr_var(sashelp.class, age, varlen);
    OUTPUT;
RUN;

PROC PRINT DATA=var_attrs NOOBS;
RUN;
