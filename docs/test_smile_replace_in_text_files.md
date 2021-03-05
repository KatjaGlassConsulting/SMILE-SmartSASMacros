# TEST_SMILE_REPLACE_IN_TEXT_FILES

Example program for macro calls of %smile_replace_in_text_files

 - Author     : Katja Glass
 - Creation   : 2021-02-15
 - SAS Version: SAS 9.4
 - License    : MIT
 

initialize macros

```sas
%LET root = <path>;
OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");
OPTIONS NONOTES;
```

 

support macro to create a text file

```sas
%MACRO create_text_file();
	DATA _NULL_;
		FILE "&root/results/temp/example.sas";
		PUT "* This is a file created by a program to demonstrate text replacements";
		PUT "* Created: {todayDate}";
		PUT '%LET path = <path>;';
	RUN;
%MEND;
```

 

support macro to print content of text file

```sas
%MACRO print_text_file();
	DATA _NULL_;
		INFILE "&root/results/temp/example.sas";
		INPUT;
		PUT _INFILE_;
	RUN;
%MEND;
```

 


## Example 1 - replace <path> in all sas files

 

create a sas file

```sas
%create_text_file();
```

 

file has been created with the following content

```sas
%print_text_file();
```

 


**Log Output:**

```
* This is a file created by a program to demonstrate text replacements
* Created: {todayDate}
%LET path = <path>;
```

call macro to replace <path> in all sas files

```sas
%smile_replace_in_text_files(
	inpath = &root/results/temp,
	outpath = &root/results/temp,
	replace_from = '<path>',
	replace_to = 'c:\temp\myPath');
```

 

file contains the new text

```sas
%print_text_file();
```

 


**Log Output:**

```
* This is a file created by a program to demonstrate text replacements
* Created: {todayDate}
%LET path = c:\temp\myPath;
```


## Example 2 - replace {todayDate} in all sas files

 

create a sas file

```sas
%create_text_file();
```

 

file has been created with the following content

```sas
%print_text_file();
```

 


**Log Output:**

```
* This is a file created by a program to demonstrate text replacements
* Created: {todayDate}
%LET path = <path>;
```

call macro to replace <path> in all sas files

```sas
%smile_replace_in_text_files(
	inpath = &root/results/temp,
	outpath = &root/results/temp,
	replace_from = '{todayDate}',
	replace_to = "%SYSFUNC(date(),date9.)");
```

 

file contains the current date

```sas
%print_text_file();
```


**Log Output:**

```
* This is a file created by a program to demonstrate text replacements
* Created: 05MAR2021
%LET path = <path>;
```

