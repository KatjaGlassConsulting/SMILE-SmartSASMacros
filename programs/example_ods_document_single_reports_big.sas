%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Purpose    : Example program to create a multiple ODS DOCUMENTS with one output in each - quite many outputs
%* Author     : Katja Glass
%* Creation   : 2021-02-18
%* SAS Version: SAS 9.4
%* License    : MIT
%************************************************************************************************************************;

******************************************************************************;
* example;
******************************************************************************;

DATA cars;
    SET sashelp.cars;
    const = 1;
RUN;
PROC SORT DATA=cars; BY const make; RUN;

%MACRO _create_many_outputs();
    %DO i = 1 %TO 100;
        ODS DOCUMENT NAME=doc_res&i(WRITE);
        ODS PROCLABEL "Table &i: Car Output (many identical)";
        TITLE "Table &i: Car Output (many identical)";
        PROC REPORT DATA=cars nowd headline spacing=2 CONTENTS="";
            COLUMN const make model type msrp;
            DEFINE const / ORDER NOPRINT;
            BREAK BEFORE const / CONTENTS="" page;
        RUN;
        ODS DOCUMENT CLOSE;
    %END;
%MEND;
%_create_many_outputs();


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
