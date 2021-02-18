%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Purpose    : Example program to create an ODS DOCUMENT with many outputs
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
ODS DOCUMENT NAME=doc_results(WRITE);

* create outputs;
ODS PROCLABEL="Table 1: By Group Report about shoes";
TITLE "Table 1: By Group Report about shoes";
PROC REPORT DATA=shoes CONTENTS="";
   BY region;
   COLUMN region product sales;
   DEFINE region / ORDER NOPRINT;
   BREAK BEFORE region / CONTENTS="" page;
RUN;

TITLE "Table 2: Table Class Output";
ODS PROCLABEL "Table 2: Table Class Output";
PROC REPORT DATA=class CONTENTS="";
   COLUMN const name sex age height weight;
   DEFINE const / ORDER NOPRINT;
   BREAK BEFORE const / CONTENTS="" page;
RUN;


%MACRO loopTroughMake(make,i);
    TITLE "Table &i: Multiple outputs - Cars for make = &make";
    ODS PROCLABEL "Table &i: Multiple outputs - Cars for make = &make";
    PROC REPORT DATA=cars(WHERE=(make = "&make")) nowd headline spacing=2 CONTENTS="";
        COLUMN const make model type msrp;
        DEFINE const / ORDER NOPRINT;
        BREAK BEFORE const / CONTENTS="" page;
    RUN;
    TITLE;
%MEND;

%loopTroughMake(Acura,3);
%loopTroughMake(Audi,4);
%loopTroughMake(BMW,5);

ODS PROCLABEL="Table 6: Different label";
TITLE "Table 6: Different title and label";
PROC REPORT DATA=class CONTENTS="";
   COLUMN const name sex age height weight;
   DEFINE const / ORDER NOPRINT;
   BREAK BEFORE const / CONTENTS="" page;
RUN;

ODS PROCLABEL="Figure 1: Class graphic";
PROC SGPLOT DATA = sashelp.class;
    VBAR age / GROUP = sex;
    TITLE 'Figure 1: Class overview by sex and age';
RUN;
ODS DOCUMENT CLOSE;

