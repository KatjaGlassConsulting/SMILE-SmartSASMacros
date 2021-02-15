%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Purpose    : Example program for macro calls of %smile_pdf_merge
%* Author     : Katja Glass
%* Creation   : 2021-02-08
%* SAS Version: SAS 9.4
%* License    : MIT
%************************************************************************************************************************;

%LET root = /folders/myshortcuts/git/SMILE-SmartSASMacros;
%LET out = &root/results;
%LET libPath = &root/lib;

OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");

%* create four PDF files which should be merged;
%INCLUDE "&root/programs/example_pdf_merge_create_single_pdfs.sas";

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

%* first example with long bookmark titles;
%smile_pdf_merge(
    data            = content
  , outfile         = &out/pdf_merge_output1.pdf
  , pdfbox_jar_path = &libPath/pdfbox-app-2.0.22.jar
  , sourcefile      = &out/pdf_merge_program1.sas
  , run_groovy      = YES
);


DATA content2;
    ATTRIB inFile     FORMAT=$255.;
    ATTRIB bookmark FORMAT=$255.;
    inFile = "&out/input_pdf_merge_1.pdf"; bookmark = "Table 1"; OUTPUT;
    inFile = "&out/input_pdf_merge_2.pdf"; bookmark = "Table 2"; OUTPUT;
    inFile = "&out/input_pdf_merge_3.pdf"; bookmark = "Table 3"; OUTPUT;
    inFile = "&out/input_pdf_merge_4.pdf"; bookmark = "Table 4"; OUTPUT;
RUN;

%* second example with short bookmark titles;
%smile_pdf_merge(
    data            = content2
  , outfile         = &out/pdf_merge_output2.pdf
  , pdfbox_jar_path = &libPath/pdfbox-app-2.0.22.jar
  , sourcefile      = &out/pdf_merge_program2.sas
  , run_groovy      = YES
);

%* example where no temporary program for the PROC GROOVY code is created;
%smile_pdf_merge(
    data            = content2
  , outfile         = &out/pdf_merge_output2.pdf
  , pdfbox_jar_path = &libPath/pdfbox-app-2.0.22.jar
);

