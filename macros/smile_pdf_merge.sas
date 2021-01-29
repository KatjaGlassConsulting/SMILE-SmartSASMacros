%************************************************************************************************************************;
%* Project    : SMILE – SAS Macros, Intuitive Library Extention 
%* Macro      : smile_pdf_merge
%* Parameters : DATA	        - Input dataset containing INFILE and BOOKMARK variable,
%*                                INFILE containing single pdf files (one file per observation),
%*                                BOOKMARK contaiing the corresponding bookmark label for this file
%*              OUTFILE         - Output PDF file (not in quotes)
%*              PDFBOX_JAR_PATH - Path and jar file name for PDFBOX open source tool, e.g. &path/pdfbox-app-2.0.22.jar
%*              SOURCEFILE      - Optional sas program file where PROC GROOVY code is stored, default is TEMP (only temporary)
%*              RUN_GROOVY      - NO/YES indicator whether to run the final GROOVY code (default YES)
%*              
%* Purpose    : Merge multiple PDF files and create one bookmark entry per PDF file
%* Comment    : Make sure to download PDFBOX, e.g. from here https://pdfbox.apache.org/download.html - the full "app" version
%* Issues     : "unable to resolve class" messages mean the PDFBOX is not provided correctly.
%*              "ERROR: PROCEDURE GROOVY cannot be used when SAS is in the lockdown state." means that your SAS environment 
%*              does not support PROC GROOVY, for this the macro cannot run the groovy code.
%*
%* ExampleProg: ../programs/test_smile_pdf_merge.sas
%*
%* Author     : Katja Glass
%* Creation   : 2021-01-29
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