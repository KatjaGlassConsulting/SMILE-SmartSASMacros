# TEST_SMILE_ATTRN

Example program for macro calls of %smile_attrn

- Author     : Katja Glass
- Creation   : 2021-02-15
- SAS Version: SAS 9.4
- License    : MIT
 

initialize macros

```sas
%LET root = /folders/myshortcuts/git/SMILE-SmartSASMacros;
OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");
 
```

##  Example 1 - simple examples

```sas
%PUT Class NOBS(1):  %smile_attrn(sashelp.class, nobs);
%PUT Class NOBS(2):  %smile_attrn(sashelp.class(WHERE=(age=16)), nobs);
%PUT Class NLOBS:    %smile_attrn(sashelp.class(WHERE=(age=16)), nlobs);
%PUT Class NLOBSF:   %smile_attrn(sashelp.class(WHERE=(age=16)), nlobsf);
%PUT Class ANOBS(1): %smile_attrn(sashelp.class, ANOBS);
%PUT Class ANOBS(2): %smile_attrn(sashelp.class(WHERE=(age=1)), ANOBS);
%PUT Class NVARS:    %smile_attrn(sashelp.class, NVARS);
 
```


**Log Output:**

```
Class NOBS(1):  19
Class NOBS(2):  19
Class NLOBS:    19
Class NLOBSF:   -1
Class ANOBS(1): 1
Class ANOBS(2): 1
Class NVARS:    5
 
```

##  Example 2 - error case examples

```sas
%PUT invalid data:      %smile_attrn(sashelp.class2, nobs);
%PUT invalid attribute: %smile_attrn(sashelp.class, dummy);
 
```


**Log Output:**

```
ERROR: SMILE_ATTRN - DATA (sashelp.class2) does not exist.
invalid data:      -1
ERROR: SMILE_ATTRN - Invalid value for ATTRIB (dummy).
invalid attribute: -1
```
