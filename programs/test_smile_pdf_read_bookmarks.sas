%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Purpose    : Example program for macro calls of %smile_pdf_read_bookmarks
%* Author     : Katja Glass
%* Creation   : 2021-02-18
%* SAS Version: SAS 9.4
%* License    : MIT
%************************************************************************************************************************;

%* Initialize macros;
%LET root = /folders/myshortcuts/git/SMILE-SmartSASMacros;
OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");

***************************************************************************************************;
* Example 1 - Read bookmarks from a document containing one bookmark level;
***************************************************************************************************;

%smile_pdf_read_bookmarks(pdfFile = &root/results/ods_document_flat1.pdf,
                          outdat = book_flat1,
                          pdfbox_jar_path = &root/lib/pdfbox-app-2.0.22.jar);

%* Bookmarks and levels are stored in BOOK_FLAT1 (dataset: book_flat1);


***************************************************************************************************;
* Example 2 - Read bookmarks from a document containing several bookmark levels;
***************************************************************************************************;

%smile_pdf_read_bookmarks(pdfFile = &root/results/ods_document_noflat1.pdf,
                          outdat = book_noflat1,
                          pdfbox_jar_path = &root/lib/pdfbox-app-2.0.22.jar);

%* Bookmarks and levels are stored in BOOK_NOFLAT1 (dataset: book_noflat1);