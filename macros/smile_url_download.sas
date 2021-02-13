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
%smile_url_download(url="http://sas.cswenson.com/downloads/macros/AddFormatLib.sas", 
                    outfile="/folders/myshortcuts/git/sas-dev/packages/chris_sas_macros/AddFormatLib.sas", 
                    info=NO, 
                    return=);
*/
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
