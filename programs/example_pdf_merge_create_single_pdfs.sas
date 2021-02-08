%************************************************************************************************************************;
%* Project    : SMILE – SAS Macros, Intuitive Library Extention 
%* Purpose    : Example program to create a single PDF output per table
%* Author     : Katja Glass
%* Creation	  : 2021-01-29
%* SAS Version: SAS 9.4
%* License    : MIT (see bottom)
%************************************************************************************************************************;

******************************************************************************;
* example;
******************************************************************************;

ODS PDF FILE= "&out/input_pdf_merge_1.pdf" NOTOC;
TITLE "Table 1: By Group Report about shoes";
PROC REPORT DATA=sashelp.shoes(WHERE=(region IN ('Canada', 'Pacific'))) CONTENTS=""; 
   BY region;
   COLUMN region product sales; 
   DEFINE region / GROUP NOPRINT;
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
