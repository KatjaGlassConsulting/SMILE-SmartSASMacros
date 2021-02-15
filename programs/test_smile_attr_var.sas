%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Purpose    : Example program for macro calls of %smile_attr_var
%* Author     : Katja Glass
%* Creation   : 2021-02-15
%* SAS Version: SAS 9.4
%* License    : MIT
%************************************************************************************************************************;

%* initialize macros;
%LET root = /folders/myshortcuts/git/SMILE-SmartSASMacros;
OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");

*************************************************************************;
* Example 1 - simple examples (log-output);;
*************************************************************************;
%PUT VARTYPE for name:  %smile_attr_var(sashelp.class, name, vartype);
%PUT VARTYPE for age:   %smile_attr_var(sashelp.class, age, vartype);
%PUT VARLABEL for name: %smile_attr_var(sashelp.class, name, varlabel);
%PUT VARLEN for name:   %smile_attr_var(sashelp.class, name, varlen);

*************************************************************************;
* Example 2 - error case examples (log-output);
*************************************************************************;
%PUT data does not exist:     %smile_attr_var(dummy, name, varlen);
%PUT variable does not exist: %smile_attr_var(sashelp.class, dummy, varlen);
%PUT invalid attribute:       %smile_attr_var(sashelp.class, name, dummy);
