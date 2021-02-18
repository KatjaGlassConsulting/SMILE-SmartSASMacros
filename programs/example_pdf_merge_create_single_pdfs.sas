%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Purpose    : Example program to create a single PDF output per table
%* Author     : Katja Glass
%* Creation   : 2021-02-18
%* SAS Version: SAS 9.4
%* License    : MIT
%************************************************************************************************************************;

******************************************************************************;
* example;
******************************************************************************;

ODS PDF FILE= "&out/input_pdf_merge_1.pdf" NOTOC;
TITLE "Table 1: By Group Report about shoes";
PROC REPORT DATA=sashelp.shoes(WHERE=(region IN ('Canada', 'Pacific'))) CONTENTS="";
   BY region;
   COLUMN region product sales;
   DEFINE region / ORDER NOPRINT;
RUN;
ODS PDF CLOSE;

%MACRO loopTroughMake(make,i);
    ODS PDF FILE= "&out/input_pdf_merge_&i..pdf" NOTOC;
    TITLE "Table &i: Multiple outputs - Cars for make = &make";
    PROC REPORT DATA=sashelp.cars(WHERE=(make = "&make")) nowd headline spacing=2;
        COLUMN make model type msrp;
    RUN;
    TITLE;
    ODS PDF CLOSE;
%MEND;

%loopTroughMake(Acura,2);
%loopTroughMake(Audi,3);
%loopTroughMake(BMW,4);
