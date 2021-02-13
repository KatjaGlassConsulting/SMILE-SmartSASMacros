%************************************************************************************************************************;
%* Project    : SMILE – SAS Macros, Intuitive Library Extention 
%* Purpose    : Example program for macro calls of %smile_attrn
%* Author     : Katja Glass
%* Creation	  : 2021-01-18
%* SAS Version: SAS 9.4
%* License    : MIT 
%************************************************************************************************************************;

%LET path = /folders/myshortcuts/git/SMILE-SmartSASMacros/macros;
%INCLUDE "&path/smile_attrn.sas";

OPTIONS MINOPERATOR MINDELIMITER=',';
%PUT %smile_attrn(sashelp.class, nobs);
%PUT %smile_attrn(sashelp.class2, nobs);
%PUT %smile_attrn(sashelp.class, dummy);

OPTIONS NOMINOPERATOR;
%PUT %smile_attrn(sashelp.class, nobs);
%PUT %smile_attrn(sashelp.class2, nobs);
%PUT %smile_attrn(sashelp.class, dummy);
