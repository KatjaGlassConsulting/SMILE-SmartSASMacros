%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Purpose    : Example program for macro calls of %smile_attrn
%* Author     : Katja Glass
%* Creation   : 2021-02-15
%* SAS Version: SAS 9.4
%* License    : MIT
%************************************************************************************************************************;

%* initialize macros;
%LET root = /folders/myshortcuts/git/SMILE-SmartSASMacros;
OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");

*************************************************************************;
* Example 1 - simple examples (log-output);
*************************************************************************;
%PUT Class NOBS(1):  %smile_attrn(sashelp.class, nobs);
%PUT Class NOBS(2):  %smile_attrn(sashelp.class(WHERE=(age=16)), nobs);
%PUT Class NLOBS:    %smile_attrn(sashelp.class(WHERE=(age=16)), nlobs);
%PUT Class NLOBSF:   %smile_attrn(sashelp.class(WHERE=(age=16)), nlobsf);
%PUT Class ANOBS(1): %smile_attrn(sashelp.class, ANOBS);
%PUT Class ANOBS(2): %smile_attrn(sashelp.class(WHERE=(age=1)), ANOBS);
%PUT Class NVARS:    %smile_attrn(sashelp.class, NVARS);


*************************************************************************;
* Example 2 - error case examples (log-output);
*************************************************************************;
%PUT invalid data:      %smile_attrn(sashelp.class2, nobs);
%PUT invalid attribute: %smile_attrn(sashelp.class, dummy);

