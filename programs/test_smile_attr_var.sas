%LET path = /folders/myshortcuts/git/SMILE-SmartSASMacros/macros;
%INCLUDE "&path/smile_attr_var.sas";

%PUT VARTYPE for name:  %smile_attr_var(sashelp.class, name, vartype);
%PUT VARTYPE for age:   %smile_attr_var(sashelp.class, age, vartype);
%PUT VARLABEL for name: %smile_attr_var(sashelp.class, name, varlabel);
%PUT VARLEN for name:   %smile_attr_var(sashelp.class, name, varlen);

%PUT data does not exist:     %smile_attr_var(dummy, name, varlen);
%PUT variable does not exist: %smile_attr_var(sashelp.class, dummy, varlen);
%PUT invalid attribute:       %smile_attr_var(sashelp.class, name, dummy);
