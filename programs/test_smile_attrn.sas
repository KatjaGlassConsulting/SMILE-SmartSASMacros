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