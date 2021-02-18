%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Purpose    : Example program to create a multiple ODS DOCUMENTS with one output in each
%* Author     : Katja Glass
%* Creation   : 2021-02-18
%* SAS Version: SAS 9.4
%* License    : MIT
%************************************************************************************************************************;

******************************************************************************;
* example;
******************************************************************************;

* prepare datasets;
DATA class;
    SET sashelp.class;
    const = 1;
RUN;
PROC SORT DATA=class; BY const sex;RUN;

DATA shoes;
   SET sashelp.shoes;
   WHERE region in ('Canada', 'Pacific');
RUN;
PROC SORT DATA=shoes; BY region product; RUN;

DATA cars;
    SET sashelp.cars;
    const = 1;
RUN;

ODS _ALL_ CLOSE;
* start new ODS DOCUMENT;
ODS DOCUMENT NAME=doc_res1(WRITE);

* create output;
ODS PROCLABEL "Table 1: By Group Report about shoes";
TITLE "Table 1: By Group Report about shoes";
PROC REPORT DATA=shoes CONTENTS="";
   BY region;
   COLUMN region product sales;
   DEFINE region / ORDER NOPRINT;
   BREAK BEFORE region / CONTENTS="" page;
RUN;
ODS DOCUMENT CLOSE;

ODS DOCUMENT NAME=doc_res2(WRITE);
ODS PROCLABEL "Table 2: Table Class Output";
TITLE "Table 2: Table Class Output";
PROC REPORT DATA=class CONTENTS="";
   COLUMN const name sex age height weight;
   DEFINE const / ORDER NOPRINT;
   BREAK BEFORE const / CONTENTS="" page;
RUN;
ODS DOCUMENT CLOSE;


%MACRO loopTroughMake(make,i);
    ODS DOCUMENT NAME=doc_res&i(WRITE);
    ODS PROCLABEL "Table &i: Multiple outputs - Cars for make = &make";
    TITLE "Table &i: Multiple outputs - Cars for make = &make";
    PROC REPORT DATA=cars(WHERE=(make = "&make")) nowd headline spacing=2 CONTENTS="";
        COLUMN const make model type msrp;
        DEFINE const / ORDER NOPRINT;
        BREAK BEFORE const / CONTENTS="" page;
    RUN;
    TITLE;
    ODS DOCUMENT CLOSE;
%MEND;

%loopTroughMake(Acura,3);
%loopTroughMake(Audi,4);
%loopTroughMake(BMW,5);

ODS DOCUMENT NAME=doc_res6(WRITE);
ODS PROCLABEL "Table 6: Different label";
TITLE "Table 6: Different title and label";
PROC REPORT DATA=class CONTENTS="";
   COLUMN const name sex age height weight;
   DEFINE const / ORDER NOPRINT;
   BREAK BEFORE const / CONTENTS="" page;
RUN;
ODS DOCUMENT CLOSE;

ODS DOCUMENT NAME=doc_res_f1(WRITE);
ODS PROCLABEL "Figure 1: Class graphic";
PROC SGPLOT DATA = sashelp.class;
    VBAR age / GROUP = sex;
    TITLE 'Figure 1: Class overview by sex and age';
RUN;
ODS DOCUMENT CLOSE;

%***********************************************************************************************;
%* a special output containing a custom TOC is created with the following code;
%***********************************************************************************************;

DATA titles;
    LENGTH const 8 link $50 cat $50 caption $230 page 8;
    const = 1; link = "#table1_x1";  cat = "Table 1"; caption = "content for 1"; page = 2;   OUTPUT;
    const = 1; link = "#table2_x1";  cat = "Table 2"; caption = "content for 2"; page = 6;   OUTPUT;
    const = 1; link = "#table3_x1";  cat = "Table 3"; caption = "content for 3"; page = 7;   OUTPUT;
    const = 1; link = "#table4_x1";  cat = "Table 4"; caption = "content for 4"; page = 8;   OUTPUT;
RUN;

TITLE; FOOTNOTE;
ODS DOCUMENT NAME = work.doc_toc(write);
ODS PROCLABEL = "Table of Contents";
PROC REPORT DATA = titles NOWD SPLIT = ' ' NOHEADER CONTENTS = "";
    COLUMN const link cat caption page;
    DEFINE const / ORDER NOPRINT;
    DEFINE link / NOPRINT;
    COMPUTE cat;
        CALL define(_col_, 'url', link);
    ENDCOMP;
    COMPUTE caption;
        CALL define(_col_, 'url', link);
    ENDCOMP;
    COMPUTE page;
        CALL define(_col_, 'url', link);
    ENDCOMP;
    BREAK BEFORE const / CONTENTS = "" PAGE;
RUN;
ODS DOCUMENT CLOSE;

