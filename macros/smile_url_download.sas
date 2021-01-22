%************************************************************************************************************************;
%* Project    : SMILE – SAS Macros, Intuitive Library Extention 
%* Macro      : smile_url_download
%* Parameters : URL     - http(s) URL which should be checked in quotes
%*              OUTFILE - output file provided in quotes
%*              RETURN  - return code variable (scope should be global)
%*              INFO    - NO/YES indicator to print information to the log
%*              
%* Purpose    : Downloads a file from an URL and store it locally on OUTFILE. Additionally return code can be stored and
%*              information can optionally be printed to the log.
%* Comment    : Return codes are 0 - URL found, 999 - no URL or OUTFILE provided,
%*              998 - URL or OUTFILE not provided in quotes, otherwise html-return code (e.g. 404 file not found)
%*
%* Author     : Katja Glass
%* Creation   : 2021-01-04
%*
%* Reference  : The idea from this macro is coming from a paper by Joseph Henry - The ABCs of PROC HTTP
%*              (https://www.sas.com/content/dam/SAS/support/en/sas-global-forum-proceedings/2019/3232-2019.pdf)
%*
%* SAS Version: SAS 9.4
%*
%************************************************************************************************************************;
/*
Examples:
%smile_url_download(url="http://sas.cswenson.com/downloads/macros/AddFormatLib.sas", 
                    outfile="/folders/myshortcuts/git/sas-dev/packages/chris_sas_macros/AddFormatLib.sas", 
                    info=NO, 
                    return=);
*/
%************************************************************************************************************************;


%************************************************************************************************************************;
%**                                                                                                                    **;
%** License: MIT                                                                                                       **;
%**                                                                                                                    **;
%** Copyright (c) 2021 Katja Glass Consulting                                                                          **;
%**                                                                                                                    **;
%** Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated       **;
%** documentation files (the "Software"), to deal in the Software without restriction, including without limitation    **;
%** the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and   **;
%** to permit persons to whom the Software is furnished to do so, subject to the following conditions:                 **;
%**                                                                                                                    **;
%** The above copyright notice and this permission notice shall be included in all copies or substantial portions of   **;
%** the Software.                                                                                                      **;
%**                                                                                                                    **;
%** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO   **;
%** THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE     **;
%** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,**;
%** TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE     **;
%** SOFTWARE.                                                                                                          **;
%************************************************************************************************************************;

%MACRO smile_url_download(url=, outfile=, info=NO, return=);

    %LOCAL macro issue;    
    %LET macro = &sysmacroname;
    %LET issue = 0;
    
    %* check that URL and OUTFILE is provided;
    %IF %LENGTH(&url) = 0 OR %LENGTH(&outfile)
    %THEN %DO;
        %PUT %STR(ERR)OR: &macro - URL and OUTFILE must be provided.;
        %IF %LENGTH(&return) > 0
            %THEN %LET &return = 999;
        %RETURN;
    %END;
    
    %* check that URL and OUTFILE is provided in quotes;
    DATA _NULL_;
        ATTRIB url FORMAT=$2000.;
        ATTRIB outfile FORMAT=$2000.;
        url = SYMGET('url');
        IF NOT (SUBSTR(url,1,1) IN ("'",'"') AND SUBSTR(url,LENGTH(url))  IN ("'",'"'))
        THEN DO;
            PUT "ERR" "OR: &macro - URL must be provided in quotes.";
            %IF %LENGTH(&return) > 0
                %THEN CALL SYMPUT("&return", "998");
            CALL SYMPUT("issue", "1");
        END;
        outfile = SYMGET('outfile');
        IF NOT (SUBSTR(outfile,1,1) IN ("'",'"') AND SUBSTR(outfile,LENGTH(outfile))  IN ("'",'"'))
        THEN DO;
            PUT "ERR" "OR: &macro - OUTFILE must be provided in quotes.";
            %IF %LENGTH(&return) > 0
                %THEN CALL SYMPUT("&return", "998");
            CALL SYMPUT("issue", "1");
        END;
    RUN;
    %IF &issue = 1
        %THEN %RETURN;

    FILENAME out &outfile;
    FILENAME hdrs TEMP;

    PROC HTTP URL=&url
        OUT=out
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

%MEND smile_url_download;
