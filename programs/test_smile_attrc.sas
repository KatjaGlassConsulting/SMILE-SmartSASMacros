%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Purpose    : Example program for macro calls of %smile_attrc
%* Author     : Katja Glass
%* Creation   : 2021-02-18
%* SAS Version: SAS 9.4
%* License    : MIT
%************************************************************************************************************************;

%* Initialize macros;
%LET root = /folders/myshortcuts/git/SMILE-SmartSASMacros;
OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");

*************************************************************************;
* Example 1 - simple examples
*************************************************************************;

%* Create test data;
DATA class(LABEL="SASHELP Example Dataset");
    SET sashelp.class;
RUN;
PROC SORT DATA=class; BY sex; RUN;

%* Call macros (log-output);
%PUT Class label:     %smile_attrc(class, label);
%PUT Class sort vars: %smile_attrc(class, sortedby);
%PUT Class library:   %smile_attrc(sashelp.class, lib);
%PUT Class encoding:  %smile_attrc(sashelp.class, encoding);


*************************************************************************;
* Example 2 - error case examples (log-output);
*************************************************************************;
%PUT invalid data:      %smile_attrc(sashelp.class2, nobs);
%PUT invalid attribute: %smile_attrc(sashelp.class, dummy);

