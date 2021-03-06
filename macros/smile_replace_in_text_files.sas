%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Macro      : smile_replace_in_text_files
%* Parameters : INPATH       - input directory (no quotes)
%*              OUTPATH      - output directory, if same as INPATH, files are overwritten (no quotes)
%*              REPLACE_FROM - text which should be replaced (with quotes)
%*              REPLACE_WITH - text that should newly be added (with quotes)
%*              FILETYPE     - extension of file types which should be processed, e.g. sas or txt (optional)
%*
%* Purpose    : Replace text from all files contained in a folder with a different text
%*
%* ExampleProg: ../programs/test_smile_replace_in_text_files.sas
%*
%* Author     : Katja Glass
%* Creation   : 2021-03-05
%* License    : MIT
%*
%* SAS Version: SAS 9.4
%*
%************************************************************************************************************************;
/*
Examples:
%* replace the default root path in all example files;
%smile_replace_in_text_files(
	inpath = /home/u49641771/smile/programs, 
	outpath = /home/u49641771/smile/programs,
	replace_from = '%LET root = /folders/myshortcuts/git/SMILE-SmartSASMacros;', 
	replace_to = '%LET root = /home/u49641771/smile;');

%* replace all tabls with four spaces;
%smile_replace_in_text_files(
	inpath = /home/u49641771/smile/programs, 
	outpath = /home/u49641771/smile/programs/blub,
	replace_from = '09'x, 
	replace_to = '    ');

%* replace all zero numbers with x in the output;
%smile_replace_in_text_files(
	inpath = /home/u49641771/smile/results, 
	outpath = /home/u49641771/smile/results/mod,
	replace_from = '0', 
	replace_to = 'x',
	filetype = lst);
*/
%************************************************************************************************************************;

%MACRO smile_replace_in_text_files(
	inpath = , 
	outpath = , 
	replace_from = , 
	replace_to = ,
	filetype =
);

	%LOCAL macro;
    %LET macro = &sysmacroname;
	
	%IF %SYSFUNC(FILEEXIST("&inpath")) < 1
	%THEN %DO;
		%PUT %STR(ERR)OR: &macro - INPATH folder does not exist: &inpath.;
        %RETURN;
	%END;
	
	%IF %SYSFUNC(FILEEXIST("&outpath")) < 1
	%THEN %DO;
		%PUT %STR(ERR)OR: &macro - OUTPATH folder does not exist: &inpath.;
        %RETURN;
	%END;
	
	%IF %LENGTH(&replace_from) = 0
	%THEN %DO;
		%PUT %STR(ERR)OR: &macro - REPLACE_FROM must be provided.;
        %RETURN;
	%END;
	
	%IF %LENGTH(&replace_to) = 0
	%THEN %DO;
		%PUT %STR(ERR)OR: &macro - REPLACE_FROM must be provided.;
        %RETURN;
	%END;
	
	%* read all files (ignore those without dot (folders));
	FILENAME myPath "&inpath";	
	DATA _dir (KEEP=filename);
		ATTRIB filename FORMAT=$200.;
		list = DOPEN('myPath');
		IF list > 0
		THEN DO;
			DO i = 1 to dnum(list);
    			filename = TRIM(DREAD(list,i));
    			%IF %LENGTH(&filetype) > 0
    			%THEN %DO;
    				IF INDEX(UPCASE(filename),"%UPCASE(.&filetype)") > 0
    					THEN OUTPUT;
    			%END;
    			%ELSE %DO;
    				IF INDEX(filename,".") > 0
    					THEN OUTPUT;
    			%END;
    		END;
    	END;
    	rc = CLOSE(list);
    RUN;    
    FILENAME myPath;
    
    %* re-create all files using a TRANWRD to perform replacement;
    DATA _NULL_;
    	SET _dir;
    	ATTRIB cmd FORMAT=$1000.;
    	ATTRIB from FORMAT=$1000.;
    	ATTRIB to FORMAT=$1000.;
    	from = SYMGET('replace_from');
    	to = SYMGET('replace_to');
    	%* create three filenames (input, output, temporary in-between (needed if input=output));
    	CALL EXECUTE('FILENAME _rep_tmp TEMP;');
    	cmd = "FILENAME _rep_in '&inpath/" || STRIP(filename) || "';";
		CALL EXECUTE(cmd);
    	cmd = "FILENAME _rep_out '&outpath/" || STRIP(filename) || "';";
		CALL EXECUTE(cmd);
		%* replace texts and create temporary file;
		CALL EXECUTE('DATA _NULL_;');
		CALL EXECUTE('	INFILE _rep_in LRECL=2000 END=_eof;');
		CALL EXECUTE('	FILE _rep_tmp LRECL=2000;');
		CALL EXECUTE('	ATTRIB line FORMAT=$2000.;');
		CALL EXECUTE('	INPUT;');
		CALL EXECUTE('	line = _INFILE_;');		
		cmd = "line = TRANWRD(line," || STRIP(from) || ", " || STRIP(to) || ');';
		PUT cmd = ;
		CALL EXECUTE(cmd);
		CALL EXECUTE('  IF LENGTHN(line) = 0 THEN PUT;');
		CALL EXECUTE('  ELSE DO;');
		CALL EXECUTE('	    pos = LENGTHN(line) - LENGTHN(STRIP(line)) + 1;');
		CALL EXECUTE('	    PUT @pos line;');
		CALL EXECUTE('  END;');
		CALL EXECUTE('RUN;');
		%* store temporary file as final file;
		CALL EXECUTE('DATA _NULL_;');
		CALL EXECUTE("	rc=FCOPY('_rep_tmp', '_rep_out');");
		CALL EXECUTE('RUN;');
    RUN;
    
    PROC DATASETS LIB=WORK NOLIST;
        DELETE _dir;
    RUN;
	
%MEND smile_replace_in_text_files;
