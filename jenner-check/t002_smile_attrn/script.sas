/* jenner-check bundle for macros/smile_attrn.sas (KatjaGlassConsulting/SMILE-SmartSASMacros)
   The macro definition below is copied verbatim from the repo's macros/smile_attrn.sas.
   The caller below is adapted from programs/test_smile_attrn.sas: the repo's own
   %INCLUDE/SASAUTOS setup is replaced with a direct macro definition in this file.
   The macro calls themselves (NOBS/NLOBS/NLOBSF/ANOBS/NVARS against sashelp.class,
   including the WHERE= dataset-option cases, plus the two error cases) are unmodified
   from the repo's test program. */

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

*************************************************************************;
* Example 1 - simple examples (log-output), from programs/test_smile_attrn.sas;
*************************************************************************;
%PUT Class NOBS(1):  %smile_attrn(sashelp.class, nobs);
%PUT Class NOBS(2):  %smile_attrn(sashelp.class(WHERE=(age=16)), nobs);
%PUT Class NLOBS:    %smile_attrn(sashelp.class(WHERE=(age=16)), nlobs);
%PUT Class NLOBSF:   %smile_attrn(sashelp.class(WHERE=(age=16)), nlobsf);
%PUT Class ANOBS(1): %smile_attrn(sashelp.class, ANOBS);
%PUT Class ANOBS(2): %smile_attrn(sashelp.class(WHERE=(age=1)), ANOBS);
%PUT Class NVARS:    %smile_attrn(sashelp.class, NVARS);

*************************************************************************;
* Example 2 - error case examples (log-output);
*************************************************************************;
%PUT invalid data:      %smile_attrn(sashelp.class2, nobs);
%PUT invalid attribute: %smile_attrn(sashelp.class, dummy);
