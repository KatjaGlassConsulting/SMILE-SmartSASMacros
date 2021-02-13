%************************************************************************************************************************;
%* Project    : SMILE – SAS Macros, Intuitive Library Extention 
%* Purpose    : Example program for macro calls of %smile_pdf_read_bookmarks
%* Author     : Katja Glass
%* Creation	  : 2021-02-13
%* SAS Version: SAS 9.4
%* License    : MIT
%************************************************************************************************************************;

%LET root = /folders/myshortcuts/git/SMILE-SmartSASMacros; 
OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");

%smile_pdf_read_bookmarks(pdfFile = &root/results/ods_document_flat1.pdf,
                          outdat = book_flat1,
                          pdfbox_jar_path = &root/lib/pdfbox-app-2.0.22.jar)

%smile_pdf_read_bookmarks(pdfFile = &root/results/ods_document_noflat1.pdf,
                          outdat = book_noflat1,
                          pdfbox_jar_path = &root/lib/pdfbox-app-2.0.22.jar)