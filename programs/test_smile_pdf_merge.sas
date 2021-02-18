%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Purpose    : Example program for macro calls of %smile_pdf_merge
%* Author     : Katja Glass
%* Creation   : 2021-02-18
%* SAS Version: SAS 9.4
%* License    : MIT
%************************************************************************************************************************;

%* Initialize macros and variables;
%LET root = /folders/myshortcuts/git/SMILE-SmartSASMacros;
%LET out = &root/results;
%LET libPath = &root/lib;

OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");

%* Create four PDF files which should be merged;
%INCLUDE "&root/programs/example_pdf_merge_create_single_pdfs.sas";

*************************************************************************;
* Example 1 - Merge PDF Documents - Create long titles;
*************************************************************************;

%* Create the content dataset to specify files and bookmark labels;
DATA content;
    ATTRIB inFile     FORMAT=$255.;
    ATTRIB bookmark FORMAT=$255.;
    inFile = "&out/input_pdf_merge_1.pdf";
    bookmark = "Table 1: By Group Report about shoes";
    OUTPUT;
    inFile = "&out/input_pdf_merge_2.pdf";
    bookmark = "Table 2: Multiple outputs - Cars for make = Acura";
    OUTPUT;
    inFile = "&out/input_pdf_merge_3.pdf";
    bookmark = "Table 3: Multiple outputs - Cars for make = Audi";
    OUTPUT;
    inFile = "&out/input_pdf_merge_4.pdf";
    bookmark = "Table 4: Multiple outputs - Cars for make = BMW";
    OUTPUT;
RUN;

%* CONTENT dataset created (dataset: content);

%* Call macro to merge documents, additionally store GROOVY program;
%smile_pdf_merge(
    data            = content
  , outfile         = &out/pdf_merge_output1.pdf
  , pdfbox_jar_path = &libPath/pdfbox-app-2.0.22.jar
  , sourcefile      = &out/pdf_merge_program1.sas
  , run_groovy      = YES
);

%* Desired PDF file has been created (screenshot: screen_pdf_merge1.jpg);

*************************************************************************;
* Example 2 - Merge PDF Documents - Create short titles;
*************************************************************************;

%* Create the content dataset to specify files and bookmark labels;
DATA content2;
    ATTRIB inFile     FORMAT=$255.;
    ATTRIB bookmark FORMAT=$255.;
    inFile = "&out/input_pdf_merge_1.pdf"; bookmark = "Table 1"; OUTPUT;
    inFile = "&out/input_pdf_merge_2.pdf"; bookmark = "Table 2"; OUTPUT;
    inFile = "&out/input_pdf_merge_3.pdf"; bookmark = "Table 3"; OUTPUT;
    inFile = "&out/input_pdf_merge_4.pdf"; bookmark = "Table 4"; OUTPUT;
RUN;

%* CONTENT dataset created (dataset: content);

%* Call macro to merge documents;
%smile_pdf_merge(
    data            = content2
  , outfile         = &out/pdf_merge_output2.pdf
  , pdfbox_jar_path = &libPath/pdfbox-app-2.0.22.jar
  , sourcefile      = &out/pdf_merge_program2.sas
  , run_groovy      = YES
);

%* Desired PDF file has been created (screenshot: screen_pdf_merge2.jpg);

*************************************************************************;
* Example 3 - Merge PDF Documents - Do not store GROOVY program;
*************************************************************************;

%* Call macro to merge documents, do not store GROOVY program;
%smile_pdf_merge(
    data            = content2
  , outfile         = &out/pdf_merge_output2.pdf
  , pdfbox_jar_path = &libPath/pdfbox-app-2.0.22.jar
);

%* Desired PDF file has been created (screenshot: screen_pdf_merge2.jpg);
