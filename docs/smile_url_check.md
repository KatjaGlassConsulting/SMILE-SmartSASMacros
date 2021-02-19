# Macro SMILE_URL_CHECK

Check existence of URL and store result in return code, information can optionally be printed to the log

- Author: Katja Glass
- Date: 2021-02-19
- SAS Version: SAS 9.4
- License: MIT
- Comment: Return codes are 0 - url found, 999 - no url provided, 998 - url not provided in quotes, otherwise html-return code (e.g. 404 file not found)
- Reference: The idea from this macro is coming from a paper by Joseph Henry - The ABCs of PROC HTTP (https://www.sas.com/content/dam/SAS/support/en/sas-global-forum-proceedings/2019/3232-2019.pdf)
- Example Program: [test_smile_url_check](test_smile_url_check.md)

## Parameters

Parameter | Description
---|---
URL |http(s) URL which should be checked in quotes
RETURN |return code variable (scope should be global)
INFO |NO/YES indicator to print information to the log

<br/>


## Examples

```
OPTIONS NONOTES;
%GLOBAL rc;
%smile_url_check(url="https://github.com/phuse-org/phuse-scripts/blob/master/whitepapers/scriptathons/central/dummy.sas");
%PUT &rc;
%smile_url_check(url="https://github.com/phuse-org/phuse-scripts/blob/master/whitepapers/scriptathons/central/Box_Plot_Baseline.sas");
%PUT &rc;
```

## Checks

- URL must be provided;
- URL must be provided in quotes;

## Macro

``` sas linenums="1"
%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Macro      : smile_url_check
%* Parameters : URL    - http(s) URL which should be checked in quotes
%*              RETURN - return code variable (scope should be global)
%*              INFO   - NO/YES indicator to print information to the log
%*
%* Purpose    : Check existence of URL and store result in return code, information can optionally be printed to the log
%* Comment    : Return codes are 0 - url found, 999 - no url provided,
%*              998 - url not provided in quotes, otherwise html-return code (e.g. 404 file not found)
%*
%* ExampleProg: ../programs/test_smile_url_check.sas
%*
%* Author     : Katja Glass
%* Creation   : 2021-02-19
%* License    : MIT
%*
%* Reference  : The idea from this macro is coming from a paper by Joseph Henry - The ABCs of PROC HTTP
%*              (https://www.sas.com/content/dam/SAS/support/en/sas-global-forum-proceedings/2019/3232-2019.pdf)
%*
%* SAS Version: SAS 9.4
%*
%************************************************************************************************************************;
/*
Examples:
OPTIONS NONOTES;
%GLOBAL rc;
%smile_url_check(url="https://github.com/phuse-org/phuse-scripts/blob/master/whitepapers/scriptathons/central/dummy.sas");
%PUT &rc;
%smile_url_check(url="https://github.com/phuse-org/phuse-scripts/blob/master/whitepapers/scriptathons/central/Box_Plot_Baseline.sas");
%PUT &rc;
*/
%************************************************************************************************************************;
 
%MACRO smile_url_check(url=, return=rc, info=NO);
 
   %LOCAL macro issue;
   %LET macro = &sysmacroname;
   %LET issue = 0;
 
   %* check: URL must be provided;
   %IF %LENGTH(&url) = 0
   %THEN %DO;
       %PUT %STR(ERR)OR: &macro - URL must be provided.;
       %IF %LENGTH(&return) > 0
       %THEN %DO;
           %LET &return = 999;
       %END;
       %RETURN;
   %END;
 
   %* check: URL must be provided in quotes;
   DATA _NULL_;
       ATTRIB url FORMAT=$2000.;
       url = SYMGET('url');
       IF NOT (SUBSTR(url,1,1) IN ("'",'"') AND SUBSTR(url,LENGTH(url))  IN ("'",'"'))
       THEN DO;
           PUT "ERR" "OR: &macro - URL must be provided in quotes.";
           %IF %LENGTH(&return) > 0
           %THEN %DO;
               CALL SYMPUT("&return", "998");
           %END;
           CALL SYMPUT("issue", "1");
       END;
   RUN;
   %IF &issue = 1
       %THEN %RETURN;
 
   %* perform URL check;
   FILENAME out TEMP;
   FILENAME hdrs TEMP;
 
   PROC HTTP URL=&url
       HEADEROUT=hdrs;
   RUN;
 
   DATA _NULL_;
       INFILE hdrs SCANOVER TRUNCOVER;
       INPUT @'HTTP/1.1' code 4. message $255.;
 
       %IF %LENGTH(&return) > 0
       %THEN %DO;
           IF code=200
               THEN CALL SYMPUT("&return", "0");
               ELSE CALL SYMPUT("&return", code);
       %END;
       %IF %UPCASE(&info) NE NO
       %THEN %DO;
           PUT "Return Code: " code;
           PUT "Return Message: " message;
       %END;
   RUN;
 
   FILENAME out;
   FILENAME hdrs;
 
%MEND smile_url_check;
```

