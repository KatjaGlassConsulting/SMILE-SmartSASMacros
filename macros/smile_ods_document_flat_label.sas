%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Macro      : smile_ods_document_flat_label
%* Parameters : DOCUMENT      - ODS Document item store
%*              LABEL         - One label to apply on first element, all other labels are removed (optional),
%*                              if not provided, labels are just rearranged and additional BY-labels removed
%*              BOOKMARKLABEL - Indicator whether to use Bookmark Labels if none is specified (YES Default),
%*                              if LABEL is missing and BOOKMARKLABEL = NO, all labels are removed
%*
%* Purpose    : Flat navigation and optionally re-label navigation for ODS DOCUMENT. The navigation bookmark level is
%*              reduced to one level only. Optionally a label can be applied to all content items or the navigation label
%*              can be removed completely.
%* Comment    : The navigation in PDF documents can be one level only with this macro. CONTENTS="" must be applied to
%*              the PROC REPORT as option and additionally for a BREAK BEFORE PAGE option.
%* Issues     : The table of contents created per default by SAS (ODS PDF option TOC) is not linking the pages correctly when
%*              using BY groups and having one ODS DOCUMENT with multiple outputs, using single ODS DOCUMENTS (one per each output)
%*              then this is working correctly. In such a case, do use not a TOC or create an own TOC, e.g. like described here:
%*              https://www.mwsug.org/proceedings/2012/S1/MWSUG-2012-S125.pdf
%*
%* ExampleProg: ../programs/test_smile_ods_document_flat_label.sas
%*
%* Author     : Katja Glass
%* Creation   : 2021-02-15
%* License    : MIT
%*
%* Reference  : A nice overview of ODS DOCUMENT can be found here: https://support.sas.com/resources/papers/proceedings12/273-2012.pdf
%*
%* SAS Version: SAS 9.4
%*
%************************************************************************************************************************;
/*
Examples:
%*This will flatten the navigation and use the labels originally set with ODS PROCLABEL;
%smile_ods_document_flat_label(document=doc_reports);

%*This will flatten the navigation and use the label "Table 1.1.1" applied to all items of this store;
%smile_ods_document_flat_label(document=doc_report1, label=Table 1.1.1);

%*This will flatten the navigation and use no navigation label at all (no navigation link at all for these items);
%smile_ods_document_flat_label(document=doc_report1, label=, bookmarklabel = NO);
*/
%************************************************************************************************************************;

%MACRO smile_ods_document_flat_label(document=, label=, bookmarkLabel = yes);

    %LOCAL macro _temp;
    %LET macro = &sysmacroname;
    %LET _temp = -1;

%*;
%* Error handling I;
%*;

    %* check: DOCUMENT must be specified;
    %IF %LENGTH(&document) = 0
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - DOCUMENT parameter is required. Macro will abort;
        %RETURN;
    %END;

    %* check: BOOKMARKLABEL must be YES or NO;
    %IF %UPCASE(&bookmarkLabel) NE YES AND %UPCASE(&bookmarkLabel) NE NO
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - BOOKMARKLABEL parameter must either be NO or YES. Macro will abort;
        %RETURN;
    %END;

    %* check - DOCUMENT must be an existing item store in WORK;
    PROC SQL NOPRINT;
        SELECT 1 INTO :_temp FROM SASHELP.VMEMBER
            WHERE libname="WORK" AND memname="%UPCASE(&document)" AND memtype = "ITEMSTOR";
    RUN;QUIT;
    %IF &_temp NE 1
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - DOCUMENT (&document) is no existing ODS DOCUMENT. Macro will abort;
        %RETURN;
    %END;

%*;
%* Read information;
%*;

    ODS SELECT NONE;
    PROC DOCUMENT NAME = &document;
        LIST / DETAILS LEVELS=all;
        ODS OUTPUT PROPERTIES = _props;
    RUN;QUIT;
    ODS SELECT ALL;

%*;
%* Error handling II;
%*;

    %* check: DOCUMENT must contain content;
    %LET _temp = -1;
    PROC SQL NOPRINT;
        SELECT nobs INTO :_temp FROM SASHELP.VTABLE WHERE libname="WORK" AND memname="_PROPS";
    RUN;QUIT;
    %IF &_temp = 0
    %THEN %DO;
        %PUT %STR(WAR)NING: &macro - DOCUMENT (&document) does not contain any observations - no action done;
        %RETURN;
    %END;

%*;
%* Processing;
%*;

    %* create a generic processing for PROC DOCUMENT;
    %* Step 1: move all reports to /all and apply label;
    DATA _NULL_;
        SET _props END=_eof;
        ATTRIB coreLabel FORMAT=$200.;
        RETAIN coreLabel;
        RETAIN _count 1 _first 0 _core 0;

        IF _N_ = 1
        THEN DO;
            CALL EXECUTE("PROC DOCUMENT NAME=&document;");
        END;

        IF COUNT(path,"\") = 1 AND type = "Dir"
        THEN DO;
            _core = 1;
            %IF %UPCASE(&bookmarkLabel) NE YES
            %THEN %DO;
                CALL MISSING(coreLabel);
                PUT "updateOdsDocument - No label is used";
            %END;
            %ELSE %IF %LENGTH("&label") > 2
            %THEN %DO;
                coreLabel = "&label";
            %END;
            %ELSE %DO;
                coreLabel = label;
                _first = 0;

            %END;
        END;

        IF type NE "Dir" AND _core
        THEN DO;
            CALL EXECUTE('MOVE ' || STRIP(path) || ' to \all;');
            IF _first = 0
                THEN CALL EXECUTE('SETLABEL \all#' || STRIP(PUT(_count,BEST.)) || " '" || STRIP(coreLabel) || "';");
            _first = 1;
            _count = _count + 1;
        END;

        IF _eof
        THEN DO;
            CALL EXECUTE('RUN;QUIT;');
        END;
    RUN;

    %* Step 2: remove all old hierarchies;
    DATA _NULL_;
        SET _props END=_eof;
        IF _N_ = 1
            THEN CALL EXECUTE("PROC DOCUMENT NAME=&document;");
        IF COUNT(path,"\") = 1 AND type = "Dir"
            THEN CALL EXECUTE('DELETE ' || STRIP(path) || ";");
        IF _eof
            THEN CALL EXECUTE('RUN;QUIT;');
    RUN;

%*;
%* Cleanup;
%*;

    PROC DATASETS LIB=WORK;
        DELETE _props;
    RUN;

%MEND smile_ods_document_flat_label;
