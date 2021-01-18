%************************************************************************************************************************;
%* Project    : n.a. 
%* Purpose    : Example program for available SAS TOC issue
%* Author     : Katja Glass
%* Creation	  : 2021-01-18
%* SAS Version: SAS 9.4
%* License    : MIT (see bottom)
%************************************************************************************************************************;

%LET root = /folders/myshortcuts/git/SMILE-SmartSASMacros;
%LET out = &root/results;

DATA class;
	SET sashelp.class;
	const = 1;
RUN;
PROC SORT DATA=class; BY sex; RUN;
       
* start new ODS DOCUMENT;
ODS DOCUMENT NAME=doc_results(WRITE);       

* create outputs;
ODS PROCLABEL="Table 1: By Group Report about class";
TITLE "Table 1: By Group Report about class";
PROC REPORT DATA=class CONTENTS=""; 
   BY sex;
   COLUMN sex name age height weight; 
   DEFINE sex / GROUP NOPRINT; 
   BREAK BEFORE sex / CONTENTS="" page; 
RUN; 

TITLE "Table 2: Table Class Output";
ODS PROCLABEL "Table 2: Table Class Output";	
PROC REPORT DATA=class CONTENTS="";
   COLUMN const name sex age height weight;
   DEFINE const / GROUP NOPRINT; 
   BREAK BEFORE const / CONTENTS="" page;
RUN; 

ODS DOCUMENT CLOSE;

PROC DOCUMENT NAME=doc_results(READ);
    LIST / levels=all details;
RUN;

PROC DOCUMENT NAME=doc_results;
	COPY \Report#1\ByGroup1#1\Report#1 TO \Report#1;
	COPY \Report#1\ByGroup2#1\Report#1 TO \Report#1;
	DELETE \Report#1\ByGroup1#1;
	DELETE \Report#1\ByGroup2#1;
RUN;QUIT;

PROC DOCUMENT NAME=doc_results(READ);
    LIST / levels=all details;
RUN;

ODS PDF FILE= "&out/bug_sas_toc.pdf" contents;
PROC DOCUMENT name=doc_results; replay; QUIT;
ODS PDF CLOSE;

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

