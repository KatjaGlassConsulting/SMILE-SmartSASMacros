# TEST_SMILE_URL_CHECK

Example program for macro calls of %smile_url_check

 - Author     : Katja Glass
 - Creation   : 2021-02-18
 - SAS Version: SAS 9.4
 - License    : MIT
 

Initialize macros

```sas
%LET root = <path>;
OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");
```

 

Pre-requisite: Internet access must be available
 


## Example 1 - Check existence of URL items (first does not exist, second exist)

 

Call macros

```sas
OPTIONS NONOTES;
%GLOBAL rc;
%smile_url_check(url="https://github.com/phuse-org/phuse-scripts/blob/master/whitepapers/scriptathons/central/dummy.sas");
%PUT &rc;
%smile_url_check(url="https://github.com/phuse-org/phuse-scripts/blob/master/whitepapers/scriptathons/central/Box_Plot_Baseline.sas");
%PUT &rc;
```

 


**Log Output:**

```
404
0
```


## Example 2 - Invalid parameter values provided (error cases)

 

Call macros

```sas
%smile_url_check(url=);
%PUT &rc;
%smile_url_check(url=dummy);
%PUT &rc;
```


**Log Output:**

```
ERROR: SMILE_URL_CHECK - URL must be provided.
999
ERROR: SMILE_URL_CHECK - URL must be provided in quotes.
998
```

