%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Purpose    : Example program for macro calls of %smile_replace_in_text_files
%* Author     : Katja Glass
%* Creation   : 2021-02-15
%* SAS Version: SAS 9.4
%* License    : MIT
%************************************************************************************************************************;

%* initialize macros;
%LET root = /folders/myshortcuts/git/SMILE-SmartSASMacros;
OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");
OPTIONS NONOTES;

%* support macro to create a text file;
%MACRO create_text_file();
	DATA _NULL_;
		FILE "&root/results/temp/example.sas";
		PUT "* This is a file created by a program to demonstrate text replacements";
		PUT "* Created: {todayDate}";
		PUT '%LET path = <path>;';
	RUN;
%MEND;

%* support macro to print content of text file;
%MACRO print_text_file();
	DATA _NULL_;
		INFILE "&root/results/temp/example.sas";
		INPUT;
		PUT _INFILE_;
	RUN;
%MEND;

*************************************************************************;
* Example 1 - replace <path> in all sas files;
*************************************************************************;

%* create a sas file;
%create_text_file();

%* file has been created with the following content (log-output);
%print_text_file();

%* call macro to replace <path> in all sas files;
%smile_replace_in_text_files(
	inpath = &root/results/temp,
	outpath = &root/results/temp,
	replace_from = '<path>',
	replace_to = 'c:\temp\myPath');

%* file contains the new text c:\temp\myPath instead of <path>;
%print_text_file();

*************************************************************************;
* Example 2 - replace {todayDate} in all sas files;
*************************************************************************;

%* create a sas file;
%create_text_file();

%* file has been created with the following content (log-output);
%print_text_file();

%* call macro to replace <path> in all sas files;
%smile_replace_in_text_files(
	inpath = &root/results/temp,
	outpath = &root/results/temp,
	replace_from = '{todayDate}',
	replace_to = "%SYSFUNC(date(),date9.)");

%* file contains the new text c:\temp\myPath instead of <path>;
%print_text_file();
