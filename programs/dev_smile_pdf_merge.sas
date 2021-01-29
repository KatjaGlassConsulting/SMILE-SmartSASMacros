%LET inPath = /folders/myshortcuts/git/sas-dev/Reindeer/out/pdfs;
%LET libPath = /folders/myshortcuts/git/SMILE-SmartSASMacros/lib;

DATA content;
    ATTRIB inFile     FORMAT=$255.;
    ATTRIB bookmark FORMAT=$255.;
    inFile = "&inPath/multi_pdf_1.pdf";
    bookmark = "Table 1: By Group Report about shoes";
    OUTPUT;
    inFile = "&inPath/multi_pdf_2.pdf";
    bookmark = "Table 2: Table Class Output";
    OUTPUT;
    inFile = "&inPath/multi_pdf_3.pdf";
    bookmark = 'Table 3: Multiple outputs - Cars for make = "Acura"';
    OUTPUT;
RUN;

%*smile_pdf_merge(
    data            = content
  , outfile         = &inPath/test.pdf
  , pdfbox_jar_path = &inPath/pdfbox-app-2.0.22.jar
  , sourcefile      = &inPath/program.sas
  , run_groovy      = YES
);

%smile_pdf_merge(
    data            = content
  , outfile         = &inPath/test2.pdf
  , pdfbox_jar_path = &libPath/pdfbox-app-2.0.22.jar
);

