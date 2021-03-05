# TEST_SMILE_ATTR_VAR

Example program for macro calls of %smile_attr_var

 - Author     : Katja Glass
 - Creation   : 2021-02-15
 - SAS Version: SAS 9.4
 - License    : MIT
 

initialize macros

```sas
%LET root = <path>;
OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");
```

 


## Example 1 - simple examples


```sas
%PUT VARTYPE for name:  %smile_attr_var(sashelp.class, name, vartype);
%PUT VARTYPE for age:   %smile_attr_var(sashelp.class, age, vartype);
%PUT VARLABEL for name: %smile_attr_var(sashelp.class, name, varlabel);
%PUT VARLEN for name:   %smile_attr_var(sashelp.class, name, varlen);
```

 


**Log Output:**

```
VARTYPE for name:  C
VARTYPE for age:   N
VARLABEL for name:
VARLEN for name:   8
```


## Example 2 - error case examples


```sas
%PUT data does not exist:     %smile_attr_var(dummy, name, varlen);
%PUT variable does not exist: %smile_attr_var(sashelp.class, dummy, varlen);
%PUT invalid attribute:       %smile_attr_var(sashelp.class, name, dummy);
```


**Log Output:**

```
ERROR: SMILE_ATTR_VAR - DATA (dummy) does not exist.
data does not exist:     -1
ERROR: SMILE_ATTR_VAR - Variable VAR (dummy) does not exist in DATA (sashelp.class).
variable does not exist: -1
ERROR: SMILE_ATTR_VAR - Invalid value for ATTRIB (dummy) - only the following are supported:
SMILE_ATTR_VAR - VARTYPE, VARLEN, VARLABEL, VARFMT and VARINFMT
invalid attribute:       -1
```

