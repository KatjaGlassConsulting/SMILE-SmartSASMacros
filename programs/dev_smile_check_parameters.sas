%MACRO smile_check_parameters(
	name         = ,
	value        = ,
	type         = ,
	return       = ,
	macro        = ,
	print_error  = Y
);
	
	%IF %UPCASE(&type) = FILE
	%THEN %DO;
		%IF %SYSFUNC(FILEEXIST(&value))
	%END;
	
	
	
%MEND smile_check_parameters;