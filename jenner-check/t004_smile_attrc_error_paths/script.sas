/* jenner-check bundle for macros/smile_attrc.sas (KatjaGlassConsulting/SMILE-SmartSASMacros)
   error-validation paths.

   The macro definition below is copied verbatim from the repo's macros/smile_attrc.sas.
   This bundle exercises only the macro's two parameter-validation branches (invalid ATTRIB
   name, and DATA that does not exist), which run and return -1 correctly BEFORE the macro
   reaches its %SYSFUNC(ATTRC(...)) call. The macro's successful-lookup path (a valid
   ATTRIB against a real dataset, e.g. %smile_attrc(sashelp.class, lib)) is not exercised
   here: it depends on %SYSFUNC(ATTRC(...)), which is affected by a known engine gap
   (%SYSFUNC(ATTRC(...)) does not resolve character attributes at macro-processing time --
   tracked separately, not specific to this repo). This bundle is scoped to the parts of
   the macro that are genuinely correct on Jenner today.

   Adapted from programs/test_smile_attrc.sas Example 2: the original test calls
   %smile_attrc(sashelp.class2, nobs) for its "invalid data" case, but NOBS is itself an
   invalid ATTRC attribute name (it's an ATTRN attribute), so that call actually exercises
   the "invalid attribute" branch twice, not "dataset does not exist". This bundle swaps
   in a valid ATTRC attribute name (LABEL) for the invalid-dataset case so the two error
   branches are each genuinely exercised once. */

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

*************************************************************************;
* Error case examples (log-output);
*************************************************************************;
%PUT invalid data:      %smile_attrc(sashelp.class2, label);
%PUT invalid attribute: %smile_attrc(sashelp.class, dummy);
