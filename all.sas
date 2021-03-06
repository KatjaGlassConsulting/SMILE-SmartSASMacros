
%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Purpose    : This file contains all the macros in a single file - which means it can be 'included' in SAS with just 2 lines of code:
%*                  filename mc url "https://raw.githubusercontent.com/KatjaGlassConsulting/SMILE-SmartSASMacros/main/all.sas";
%*                  %INCLUDE mc;
%* Author     : Katja Glass
%************************************************************************************************************************;

OPTIONS NOQUOTELENMAX;

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
%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Macro      : smile_attrn
%* Parameters : DATA   - name of the SAS dataset
%*              ATTRIB - SAS ATTRN keyword (e.g. NOBS, CRDTE, ...)
%*
%* Purpose    : Function-style macro to return a numeric attribute of a dataset. The following attributes are available:
%*              ALTERPW, ANOBS, ANY, ARAND, ARWU, AUDIT, AUDIT_DATA, AUDIT_BEFORE, AUDIT_ERROR, CRDTE, ICONST, INDEX,
%*              ISINDEX, ISSUBSET, LRECL, LRID, MAXGEN, MAXRC, MODTE, NDEL, NEXTGEN, NLOBS, NLOBSF, NOBS, NVARS, PW, RADIX,
%*              READPW, REUSE, TAPE, WHSTMT, WRITEPW
%*
%* ExampleProg: ../programs/test_smile_attrn.sas
%*
%* Author     : Katja Glass
%* Creation   : 2021-02-19
%* License    : MIT
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
%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Macro      : smile_attr_var
%* Parameters : DATA   - name of the SAS dataset
%*              VAR    - name of variable
%*              ATTRIB - SAS variable attrib keyword (e.g. VARTYPE, VARLEN, VARLABEL, VARFMT and VARINFMT)
%*
%* Purpose    : Function-style macro to return a variable attribute of a dataset. The following attributes are available:
%*              VARTYPE, VARLEN, VARLABEL, VARFMT and VARINFMT
%*
%* ExampleProg: ../programs/test_smile_attr_var.sas
%*
%* Author     : Katja Glass
%* Creation   : 2021-02-19
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
%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Macro      : smile_pdf_merge
%* Parameters : DATA            - Input dataset containing INFILE and BOOKMARK variable,
%*                                INFILE containing single pdf files (one file per observation),
%*                                BOOKMARK containing the corresponding bookmark label for this file
%*              OUTFILE         - Output PDF file (not in quotes)
%*              PDFBOX_JAR_PATH - Path and jar file name for PDFBOX open source tool, e.g. &path/pdfbox-app-2.0.22.jar
%*              SOURCEFILE      - Optional SAS program file where PROC GROOVY code is stored, default is TEMP (only temporary)
%*              RUN_GROOVY      - NO/YES indicator whether to run the final GROOVY code (default YES)
%*
%* Purpose    : Merge multiple PDF files and create one bookmark entry per PDF file with PROC GROOVY and open-source Tool PDFBox
%* Comment    : Make sure to download PDFBOX, e.g. from here https://pdfbox.apache.org/download.html - the full "app" version
%* Issues     : "unable to resolve class" messages mean the PDFBOX is not provided correctly.
%*              "ERROR: PROCEDURE GROOVY cannot be used when SAS is in the lock down state." means that your SAS environment
%*              does not support PROC GROOVY, for this the macro cannot run the groovy code.
%*              "WARNUNG: Removed /IDTree from /Names dictionary, doesn't belong there" - this message is coming from PDFBox.
%*
%* ExampleProg: ../programs/test_smile_pdf_merge.sas
%*
%* Author     : Katja Glass
%* Creation   : 2021-01-29
%* License    : MIT
%*
%* Reference  : A paper explaining how to use PDFBOX with PROC GROOVY also for TOC is available in the following paper
%*              (https://www.lexjansen.com/phuse/2019/ct/CT05.pdf)
%*
%* SAS Version: SAS 9.4
%*
%************************************************************************************************************************;
/*
Examples:
DATA content;
    ATTRIB inFile     FORMAT=$255.;
    ATTRIB bookmark FORMAT=$255.;
    inFile = "&inPath/output_1.pdf";  bookmark = "Table 1";    OUTPUT;
    inFile = "&inPath/output_2.pdf";  bookmark = "Table 2";    OUTPUT;
    inFile = "&inPath/output_3.pdf";  bookmark = "Table 3";    OUTPUT;
RUN;
%smile_pdf_merge(
    data            = content
  , outfile         = &outPath/merged_output.pdf
  , pdfbox_jar_path = &libPath/pdfbox-app-2.0.22.jar
  , sourcefile      = &progPath/groovy_call.sas
  , run_groovy      = YES
);
*/
%************************************************************************************************************************;

%MACRO smile_pdf_merge(data = , outfile = , pdfbox_jar_path = , sourcefile = TEMP, run_groovy = YES);

    %LOCAL macro;
    %LET macro = &sysmacroname;

%*;
%* Error handling I - parameter checks;
%*;

    %* check: existence of required parameters (DATA, OUTFILE, PDFBOX_JAR_PATH), abort;
    %* check: existence of parameter SOURCEFILE, if not use TEMP;
    %* check: RUN_GROOVY must be NO or YES, abort;

    %IF %LENGTH(&data) = 0
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - DATA parameter is requried. Macro will abort.;
        %RETURN;
    %END;

    %IF %LENGTH(&outfile) = 0
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - OUTFILE parameter is requried. Macro will abort.;
        %RETURN;
    %END;

    %IF %LENGTH(&pdfbox_jar_path) = 0
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - PDFBOX_JAR_PATH parameter is requried. Macro will abort.;
        %RETURN;
    %END;

    %IF %LENGTH(&sourcefile) = 0
    %THEN %DO;
        %PUT %STR(WAR)NING: &macro - SOURCEFILE parameter is needed - TEMP will be used.;
        %LET sourcefile = TEMP;
    %END;

    %IF %UPCASE(&run_groovy) NE YES AND %UPCASE(&run_groovy) NE NO
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - RUN_GROOVY parameter must be NO or YES. Macro will abort.;
        %RETURN;
    %END;

    %* check: PDFBOX_JAR_PATH must exist and must be a ".jar" file;
    %IF %SYSFUNC(FILEEXIST(&pdfbox_jar_path)) = 0
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - PDFBOX_JAR_PATH file does not exist. Macro will abort.;
        %RETURN;
    %END;
    %IF %UPCASE(%SCAN(&pdfbox_jar_path,-1,.)) NE JAR
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - PDFBOX_JAR_PATH must be a ".jar" file. Macro will abort.;
        %RETURN;
    %END;

%*;
%* Preparations;
%*;

    %* include quotes around sourcefile if not available;
    DATA _NULL_;
        ATTRIB path FORMAT=$500.;
        path = SYMGET('sourcefile');
        IF UPCASE(STRIP(path)) NE "TEMP"
        THEN DO;
            IF SUBSTR(sourcefile,1,1) NE '"' AND SUBSTR(sourcefile,1,1) NE "'"
            THEN DO;
                CALL SYMPUT('sourcefile','"' || STRIP(path) || '"');
            END;
        END;
    RUN;

%*;
%* Error handling II - data checks;
%*;

    %LOCAL dsid rc error;
    %LET error = 0;

    %* check: existence of data, contains observations, contains variables infile and bookmark;
    %LET dsid=%SYSFUNC(OPEN(&data,is));
    %IF &dsid EQ 0
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - DATA (&data) does not exist. Macro will abort.;
        %RETURN;
    %END;
    %ELSE %IF %SYSFUNC(ATTRN(&dsid,NLOBS)) = 0
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - DATA (&data) does not contain any observations. Macro will abort.;
        %LET rc=%SYSFUNC(CLOSE(&dsid));
        %RETURN;
    %END;
    %ELSE %IF %SYSFUNC(VARNUM(&dsid,infile)) = 0 OR %SYSFUNC(VARNUM(&dsid,bookmark)) = 0
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - DATA (&data) does not contain required variables (infile and bookmark). Macro will abort.;
        %LET rc=%SYSFUNC(CLOSE(&dsid));
        %RETURN;
    %END;
    %LET rc=%SYSFUNC(CLOSE(&dsid));

    %* check: files in variable "infile" must exist;
    %* update BOOKMARK labels, replace double quotes;
    DATA _smile_indat;
        SET &data;
        RETAIN _smile_msg 0;
        IF FILEEXIST(infile) = 0
        THEN DO;
            PUT "%STR(ERR)OR: INFILE does not exist: " infile " - Macro will abort.";
            CALL SYMPUT('error','1');
        END;
        IF INDEX(bookmark,'"') > 0 AND _smile_msg = 0
        THEN DO;
            PUT "%STR(WAR)NING: Double quotes are not supported for BOOKMARK texts and are removed.";
            _smile_msg = 1;
        END;
        bookmark = TRANWRD(bookmark,'"','');
    RUN;

    %IF &error NE 0
    %THEN %DO;
        %GOTO end_macro;
    %END;

%*;
%* Create PROC GROOVY program file;
%*;

    FILENAME cmd &sourcefile;

    DATA _NULL_;
        FILE cmd LRECL=5000;
        SET _smile_indat END=_eof;
        IF _N_ = 1
        THEN DO;
            PUT "PROC GROOVY;";
            PUT "    ADD CLASSPATH = ""&pdfbox_jar_path"";";
            PUT "    SUBMIT;";
            PUT ;
            PUT "import org.apache.pdfbox.multipdf.PDFMergerUtility;";
            PUT "import org.apache.pdfbox.pdmodel.PDDocument;";
            PUT "import org.apache.pdfbox.pdmodel.interactive.documentnavigation.destination.PDPageDestination;";
            PUT "import org.apache.pdfbox.pdmodel.interactive.documentnavigation.destination.PDPageFitWidthDestination;";
            PUT "import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDDocumentOutline;";
            PUT "import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDOutlineItem;";
            PUT "import java.io.File;";
            PUT ;
            PUT "public class PDFMerge2 {";
            PUT "    public static void main(String[] args) {";
            PUT;
            PUT @8 "//Instantiating PDFMergerUtility class";
            PUT @8 "PDFMergerUtility PDFmerger = new PDFMergerUtility();";
            PUT ;
            PUT @8 "//Setting the destination file";
            PUT @8 "PDFmerger.setDestinationFileName(""&outfile"");";
            PUT ;
            PUT @8 "//adding the source files";
        END;
        PUT @8 "PDFmerger.addSource(new File(""" inFile +(-1) """));";
        IF _eof
        THEN DO;
            PUT @8 "PDFmerger.mergeDocuments(null);";
        END;
    RUN;

    DATA _NULL_;
        FILE cmd LRECL=5000 MOD;
        ATTRIB _temp FORMAT=$200.;
        SET _smile_indat END=_eof;
        IF _N_ = 1
        THEN DO;
            PUT @8 "//Open created document";
            PUT @8 "PDDocument document;";
            PUT @8 "PDPageDestination pageDestination;";
            PUT @8 "PDOutlineItem bookmark;";
            PUT @8 "document = PDDocument.load(new File(""&outfile""));";
            PUT ;
            PUT @8 "//Create a bookmark outline";
            PUT @8 "PDDocumentOutline documentOutline = new PDDocumentOutline();";
            PUT @8 "document.getDocumentCatalog().setDocumentOutline(documentOutline);";
            PUT @8 ;
            PUT @8 "int currentPage = 0;";
        END;

        _temp = SCAN(inFile,-1,"/\");
        PUT @8 "//Include file " _temp;
        PUT @8 "pageDestination = new PDPageFitWidthDestination();";
        PUT @8 "pageDestination.setPage(document.getPage(currentPage));";
        PUT @8 "bookmark = new PDOutlineItem();";
        PUT @8 "bookmark.setDestination(pageDestination);";
        PUT @8 "bookmark.setTitle(""" bookmark +(-1) """);";
        PUT @8 "documentOutline.addLast(bookmark);";
        PUT ;
        PUT @8 "//Change currentPage number";
        PUT @8 "currentPage += PDDocument.load(new File(""" inFile +(-1) """)).getNumberOfPages();";
        PUT ;
        IF _eof
        THEN DO;
            PUT @8 "//save document";
            PUT @8 "document.save(""&outfile"");";
            PUT ;
            PUT "}}";
            PUT "endsubmit;";
            PUT "quit;";
        END;
    RUN;

%*;
%* Optionally execute PROC GROOVY code;
%*;

    %IF %UPCASE(&run_groovy) = YES
    %THEN %DO;
        %PUT &macro: Run Groovy Program;
        %PUT &macro: The following warning might come from PDFBox: %STR(WAR)NING: Removed /IDTree from /Names dictionary ...;
        %INCLUDE cmd;
    %END;

%end_macro:

%*;
%* cleanup;
%*;

    FILENAME cmd;

    PROC DATASETS LIB=WORK NOWARN NOLIST;
        DELETE _smile_indat;
    RUN;


%MEND;
%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Macro      : smile_pdf_read_bookmarks
%* Parameters : PDFFILE    - name of PDF file with bookmarks
%*              OUTDAT     - output dataset
%*              PDFBOX_JAR - path and jar file name for PDFBOX open source tool, e.g. &path/pdfbox-app-2.0.22.jar
%*
%* Purpose    : Read PDF Bookmarks into a SAS dataset with the variables level, title and page
%* Comment    : Make sure to download PDFBOX, e.g. from here https://pdfbox.apache.org/download.html - the full "app" version
%* Issues     : "unable to resolve class" messages mean the PDFBOX is not provided correctly.
%*              "ERROR: PROCEDURE GROOVY cannot be used when SAS is in the lock down state." means that your SAS environment
%*              does not support PROC GROOVY, for this the macro cannot run the groovy code.
%*
%* ExampleProg: ../programs/test_smile_pdf_read_bookmarks.sas
%*
%* Author     : Katja Glass
%* Creation   : 2021-02-13
%* License    : MIT
%*
%* Reference  : PDFBox contains a lot of useful functionalities (https://pdfbox.apache.org)
%*
%* SAS Version: SAS 9.4
%*
%************************************************************************************************************************;
/*
Examples:
%smile_pdf_read_bookmarks(pdfFile = <path>/ods_document_flat1.pdf,
                          outdat = book_flat1,
                          pdfbox_jar_path = <path>/pdfbox-app-2.0.22.jar)

%smile_pdf_read_bookmarks(pdfFile = <path>/ods_document_noflat1.pdf,
                          outdat = book_noflat1,
                          pdfbox_jar_path = <path>/pdfbox-app-2.0.22.jar)
*/
%************************************************************************************************************************;

%MACRO smile_pdf_read_bookmarks(pdfFile = , outdat = , pdfbox_jar_path = );

    %LOCAL jsonFile;

    FILENAME jsonFile TEMP;
    %LET jsonFile = %SYSFUNC(PATHNAME(jsonFile));

    FILENAME _rdbkpd TEMP;
    DATA _NULL_;
        FILE _rdbkpd LRECL=5000;

        PUT 'PROC GROOVY;';
        PUT '    ADD CLASSPATH = "' "&pdfbox_jar_path" '";';
        PUT '    SUBMIT;';
        PUT ;
        PUT '    import java.io.File;';
        PUT '    import java.io.FileWriter;';
        PUT '    import java.io.IOException;';
        PUT '    import java.io.PrintWriter;';
        PUT '    import java.util.ArrayList;';
        PUT ;
        PUT '    import org.apache.pdfbox.pdmodel.PDDocument;';
        PUT '    import org.apache.pdfbox.pdmodel.PDPage;';
        PUT '    import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDDocumentOutline;';
        PUT '    import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDOutlineItem;';
        PUT '    import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDOutlineNode;';
        PUT ;
        PUT '    public class PDFReadBookmarks {';
        PUT ;
        PUT '        public static void main(String[] args) throws IOException {';
        PUT '            ArrayList<String> aBookmarks = new ArrayList<String>();';
        PUT ;
        PUT '            // Read the PDF document and investigate bookmarks into a list (JSON formatted)';
        PUT '            PDDocument document = PDDocument.load(new File("' "&pdffile" '"));';
        PUT '            PDDocumentOutline outline =  document.getDocumentCatalog().getDocumentOutline();';
        PUT '            addBookmark(aBookmarks, document, outline, 1);';
        PUT '            document.close();';
        PUT ;
        PUT '            // Print bookmark information into a file';
        PUT '            FileWriter fileWriter = new FileWriter("' "&jsonFile" '");';
        PUT '            PrintWriter printWriter = new PrintWriter(fileWriter);';
        PUT '            printWriter.print(aBookmarks);';
        PUT '            printWriter.close();';
        PUT '        }';
        PUT ;
        PUT '        static public void addBookmark(ArrayList<String> bookmarks, PDDocument document, PDOutlineNode bookmark, int level) throws IOException';
        PUT '        {';
        PUT '            PDOutlineItem current = bookmark.getFirstChild();';
        PUT '            while (current != null)';
        PUT '            {';
        PUT '                PDPage currentPage = current.findDestinationPage(document);';
        PUT '                Integer pageNumber = document.getDocumentCatalog().getPages().indexOf(currentPage) + 1;';
        PUT '                String text = "\n{\"level\":" + level + ", \"title\":\"" + current.getTitle() + "\", \"page\":" + pageNumber + "}";';
        PUT '                bookmarks.add(text);';
        PUT '                addBookmark(bookmarks, document, current, level + 1);';
        PUT '                current = current.getNextSibling();';
        PUT '            }';
        PUT '        }';
        PUT '    }';
        PUT 'ENDSUBMIT;';
        PUT 'QUIT;';

    RUN;
    %INCLUDE _rdbkpd;

    LIBNAME jsonCont JSON "&jsonFile";

    DATA &outdat(DROP=ordinal_root);
        SET jsonCont.root;
    RUN;

%MEND smile_pdf_read_bookmarks;
%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Macro      : smile_replace_in_text_files
%* Parameters : INPATH       - input directory (no quotes)
%*              OUTPATH      - output directory, if same as INPATH, files are overwritten (no quotes)
%*              REPLACE_FROM - text which should be replaced (with quotes)
%*              REPLACE_WITH - text that should newly be added (with quotes)
%*              FILETYPE     - extension of file types which should be processed, e.g. sas or txt (optional)
%*
%* Purpose    : Replace text from all files contained in a folder with a different text
%*
%* ExampleProg: ../programs/test_smile_replace_in_text_files.sas
%*
%* Author     : Katja Glass
%* Creation   : 2021-03-05
%* License    : MIT
%*
%* SAS Version: SAS 9.4
%*
%************************************************************************************************************************;
/*
Examples:
%* replace the default root path in all example files;
%smile_replace_in_text_files(
	inpath = /home/u49641771/smile/programs, 
	outpath = /home/u49641771/smile/programs,
	replace_from = '%LET root = /folders/myshortcuts/git/SMILE-SmartSASMacros;', 
	replace_to = '%LET root = /home/u49641771/smile;');

%* replace all tabls with four spaces;
%smile_replace_in_text_files(
	inpath = /home/u49641771/smile/programs, 
	outpath = /home/u49641771/smile/programs/blub,
	replace_from = '09'x, 
	replace_to = '    ');

%* replace all zero numbers with x in the output;
%smile_replace_in_text_files(
	inpath = /home/u49641771/smile/results, 
	outpath = /home/u49641771/smile/results/mod,
	replace_from = '0', 
	replace_to = 'x',
	filetype = lst);
*/
%************************************************************************************************************************;

%MACRO smile_replace_in_text_files(
	inpath = , 
	outpath = , 
	replace_from = , 
	replace_to = ,
	filetype =
);

	%LOCAL macro;
    %LET macro = &sysmacroname;
	
	%IF %SYSFUNC(FILEEXIST("&inpath")) < 1
	%THEN %DO;
		%PUT %STR(ERR)OR: &macro - INPATH folder does not exist: &inpath.;
        %RETURN;
	%END;
	
	%IF %SYSFUNC(FILEEXIST("&outpath")) < 1
	%THEN %DO;
		%PUT %STR(ERR)OR: &macro - OUTPATH folder does not exist: &inpath.;
        %RETURN;
	%END;
	
	%IF %LENGTH(&replace_from) = 0
	%THEN %DO;
		%PUT %STR(ERR)OR: &macro - REPLACE_FROM must be provided.;
        %RETURN;
	%END;
	
	%IF %LENGTH(&replace_to) = 0
	%THEN %DO;
		%PUT %STR(ERR)OR: &macro - REPLACE_FROM must be provided.;
        %RETURN;
	%END;
	
	%* read all files (ignore those without dot (folders));
	FILENAME myPath "&inpath";	
	DATA _dir (KEEP=filename);
		ATTRIB filename FORMAT=$200.;
		list = DOPEN('myPath');
		IF list > 0
		THEN DO;
			DO i = 1 to dnum(list);
    			filename = TRIM(DREAD(list,i));
    			%IF %LENGTH(&filetype) > 0
    			%THEN %DO;
    				IF INDEX(UPCASE(filename),"%UPCASE(.&filetype)") > 0
    					THEN OUTPUT;
    			%END;
    			%ELSE %DO;
    				IF INDEX(filename,".") > 0
    					THEN OUTPUT;
    			%END;
    		END;
    	END;
    	rc = CLOSE(list);
    RUN;    
    FILENAME myPath;
    
    %* re-create all files using a TRANWRD to perform replacement;
    DATA _NULL_;
    	SET _dir;
    	ATTRIB cmd FORMAT=$1000.;
    	ATTRIB from FORMAT=$1000.;
    	ATTRIB to FORMAT=$1000.;
    	from = SYMGET('replace_from');
    	to = SYMGET('replace_to');
    	%* create three filenames (input, output, temporary in-between (needed if input=output));
    	CALL EXECUTE('FILENAME _rep_tmp TEMP;');
    	cmd = "FILENAME _rep_in '&inpath/" || STRIP(filename) || "';";
		CALL EXECUTE(cmd);
    	cmd = "FILENAME _rep_out '&outpath/" || STRIP(filename) || "';";
		CALL EXECUTE(cmd);
		%* replace texts and create temporary file;
		CALL EXECUTE('DATA _NULL_;');
		CALL EXECUTE('	INFILE _rep_in LRECL=2000 END=_eof;');
		CALL EXECUTE('	FILE _rep_tmp LRECL=2000;');
		CALL EXECUTE('	ATTRIB line FORMAT=$2000.;');
		CALL EXECUTE('	INPUT;');
		CALL EXECUTE('	line = _INFILE_;');		
		cmd = "line = TRANWRD(line," || STRIP(from) || ", " || STRIP(to) || ');';
		PUT cmd = ;
		CALL EXECUTE(cmd);
		CALL EXECUTE('  IF LENGTHN(line) = 0 THEN PUT;');
		CALL EXECUTE('  ELSE DO;');
		CALL EXECUTE('	    pos = LENGTHN(line) - LENGTHN(STRIP(line)) + 1;');
		CALL EXECUTE('	    PUT @pos line;');
		CALL EXECUTE('  END;');
		CALL EXECUTE('RUN;');
		%* store temporary file as final file;
		CALL EXECUTE('DATA _NULL_;');
		CALL EXECUTE("	rc=FCOPY('_rep_tmp', '_rep_out');");
		CALL EXECUTE('RUN;');
    RUN;
    
    PROC DATASETS LIB=WORK NOLIST;
        DELETE _dir;
    RUN;
	
%MEND smile_replace_in_text_files;
%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Macro      : smile_url_check
%* Parameters : URL    - http(s) URL which should be checked in quotes
%*              RETURN - return code variable (scope should be global)
%*              INFO   - NO/YES indicator to print information to the log
%*
%* Purpose    : Check existence of URL and store result in return code, information can optionally be printed to the log
%* Comment    : Return codes are 0 - url found, 999 - no url provided,
%*              998 - url not provided in quotes, otherwise html-return code (e.g. 404 file not found)
%*
%* ExampleProg: ../programs/test_smile_url_check.sas
%*
%* Author     : Katja Glass
%* Creation   : 2021-02-19
%* License    : MIT
%*
%* Reference  : The idea from this macro is coming from a paper by Joseph Henry - The ABCs of PROC HTTP
%*              (https://www.sas.com/content/dam/SAS/support/en/sas-global-forum-proceedings/2019/3232-2019.pdf)
%*
%* SAS Version: SAS 9.4
%*
%************************************************************************************************************************;
/*
Examples:
OPTIONS NONOTES;
%GLOBAL rc;
%smile_url_check(url="https://github.com/phuse-org/phuse-scripts/blob/master/whitepapers/scriptathons/central/dummy.sas");
%PUT &rc;
%smile_url_check(url="https://github.com/phuse-org/phuse-scripts/blob/master/whitepapers/scriptathons/central/Box_Plot_Baseline.sas");
%PUT &rc;
*/
%************************************************************************************************************************;

%MACRO smile_url_check(url=, return=rc, info=NO);

    %LOCAL macro issue;
    %LET macro = &sysmacroname;
    %LET issue = 0;

    %* check: URL must be provided;
    %IF %LENGTH(&url) = 0
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - URL must be provided.;
        %IF %LENGTH(&return) > 0
        %THEN %DO;
            %LET &return = 999;
        %END;
        %RETURN;
    %END;

    %* check: URL must be provided in quotes;
    DATA _NULL_;
        ATTRIB url FORMAT=$2000.;
        url = SYMGET('url');
        IF NOT (SUBSTR(url,1,1) IN ("'",'"') AND SUBSTR(url,LENGTH(url))  IN ("'",'"'))
        THEN DO;
            PUT "ERR" "OR: &macro - URL must be provided in quotes.";
            %IF %LENGTH(&return) > 0
            %THEN %DO;
                CALL SYMPUT("&return", "998");
            %END;
            CALL SYMPUT("issue", "1");
        END;
    RUN;
    %IF &issue = 1
        %THEN %RETURN;

    %* perform URL check;
    FILENAME out TEMP;
    FILENAME hdrs TEMP;

    PROC HTTP URL=&url
        HEADEROUT=hdrs;
    RUN;

    DATA _NULL_;
        INFILE hdrs SCANOVER TRUNCOVER;
        INPUT @'HTTP/1.1' code 4. message $255.;

        %IF %LENGTH(&return) > 0
        %THEN %DO;
            IF code=200
                THEN CALL SYMPUT("&return", "0");
                ELSE CALL SYMPUT("&return", code);
        %END;
        %IF %UPCASE(&info) NE NO
        %THEN %DO;
            PUT "Return Code: " code;
            PUT "Return Message: " message;
        %END;
    RUN;

    FILENAME out;
    FILENAME hdrs;

%MEND smile_url_check;
%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Macro      : smile_url_download
%* Parameters : URL     - http(s) URL which should be checked in quotes
%*              OUTFILE - output file provided in quotes
%*              RETURN  - return code variable (scope should be global)
%*              INFO    - NO/YES indicator to print information to the log
%*
%* Purpose    : Downloads a file from an URL and store it locally on OUTFILE. Additionally return code can be stored and
%*              information can optionally be printed to the log.
%* Comment    : Return codes are 0 - URL found, 999 - no URL or OUTFILE provided,
%*              998 - URL or OUTFILE not provided in quotes, otherwise html-return code (e.g. 404 file not found)
%*
%* Author     : Katja Glass
%* Creation   : 2021-01-04
%* License    : MIT
%*
%* Reference  : The idea from this macro is coming from a paper by Joseph Henry - The ABCs of PROC HTTP
%*              (https://www.sas.com/content/dam/SAS/support/en/sas-global-forum-proceedings/2019/3232-2019.pdf)
%*
%* SAS Version: SAS 9.4
%*
%************************************************************************************************************************;
/*
Examples:
%smile_url_download(url="http://sas.cswenson.com/downloads/macros/AddFormatLib.sas",
                    outfile="/folders/myshortcuts/git/sas-dev/packages/chris_sas_macros/AddFormatLib.sas",
                    info=NO,
                    return=);
*/
%************************************************************************************************************************;

%MACRO smile_url_download(url=, outfile=, info=NO, return=);

    %LOCAL macro issue;
    %LET macro = &sysmacroname;
    %LET issue = 0;

    %* check: URL and OUTFILE must be provided;
    %IF %LENGTH(&url) = 0 OR %LENGTH(&outfile)
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - URL and OUTFILE must be provided.;
        %IF %LENGTH(&return) > 0
            %THEN %LET &return = 999;
        %RETURN;
    %END;

    %* check: URL and OUTFILE must be provided in quotes;
    DATA _NULL_;
        ATTRIB url FORMAT=$2000.;
        ATTRIB outfile FORMAT=$2000.;
        url = SYMGET('url');
        IF NOT (SUBSTR(url,1,1) IN ("'",'"') AND SUBSTR(url,LENGTH(url))  IN ("'",'"'))
        THEN DO;
            PUT "ERR" "OR: &macro - URL must be provided in quotes.";
            %IF %LENGTH(&return) > 0
                %THEN CALL SYMPUT("&return", "998");
            CALL SYMPUT("issue", "1");
        END;
        outfile = SYMGET('outfile');
        IF NOT (SUBSTR(outfile,1,1) IN ("'",'"') AND SUBSTR(outfile,LENGTH(outfile))  IN ("'",'"'))
        THEN DO;
            PUT "ERR" "OR: &macro - OUTFILE must be provided in quotes.";
            %IF %LENGTH(&return) > 0
                %THEN CALL SYMPUT("&return", "998");
            CALL SYMPUT("issue", "1");
        END;
    RUN;
    %IF &issue = 1
        %THEN %RETURN;

    FILENAME out &outfile;
    FILENAME hdrs TEMP;

    PROC HTTP URL=&url
        OUT=out
        HEADEROUT=hdrs;
    RUN;

    DATA _NULL_;
        INFILE hdrs SCANOVER TRUNCOVER;
        INPUT @'HTTP/1.1' code 4. message $255.;

        %IF %LENGTH(&return) > 0
        %THEN %DO;
            IF code=200
                THEN CALL SYMPUT("&return", "0");
                ELSE CALL SYMPUT("&return", code);
        %END;
        %IF %UPCASE(&info) NE NO
        %THEN %DO;
            PUT "Return Code: " code;
            PUT "Return Message: " message;
        %END;
    RUN;

%MEND smile_url_download;
