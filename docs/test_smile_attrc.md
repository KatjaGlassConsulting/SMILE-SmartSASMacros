# TEST_SMILE_ATTRC

Example program for macro calls of %smile_attrc

 - Author     : Katja Glass
 - Creation   : 2021-02-18
 - SAS Version: SAS 9.4
 - License    : MIT
 

Initialize macros

```sas
%LET root = <path>;
OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");
```

 


## Example 1 - simple examples

 

Create test data

```sas
DATA class(LABEL="SASHELP Example Dataset");
   SET sashelp.class;
RUN;
PROC SORT DATA=class; BY sex; RUN;
```

 

Call macros

```sas
%PUT Class label:     %smile_attrc(class, label);
%PUT Class sort vars: %smile_attrc(class, sortedby);
%PUT Class library:   %smile_attrc(sashelp.class, lib);
%PUT Class encoding:  %smile_attrc(sashelp.class, encoding);
```

 


**Log Output:**

```
Class label:     SASHELP Example Dataset
Class sort vars:  Sex
Class library:   SASHELP
Class encoding:  us-ascii  ASCII (ANSI)
```

 


## Example 2 - error case examples


```sas
%PUT invalid data:      %smile_attrc(sashelp.class2, nobs);
%PUT invalid attribute: %smile_attrc(sashelp.class, dummy);
```

 


**Log Output:**

```
ERROR: SMILE_ATTRC - Invalid value for ATTRIB (nobs).
invalid data:      -1
ERROR: SMILE_ATTRC - Invalid value for ATTRIB (dummy).
invalid attribute: -1
```

