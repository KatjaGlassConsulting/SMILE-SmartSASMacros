%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Purpose    : Example program for macro calls of %smile_url_check
%* Author     : Katja Glass
%* Creation   : 2021-02-18
%* SAS Version: SAS 9.4
%* License    : MIT
%************************************************************************************************************************;

%* Initialize macros;
%LET root = /folders/myshortcuts/git/SMILE-SmartSASMacros;
OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");

%* Pre-requisite: Internet access must be available;

***********************************************************************************;
* Example 1 - Check existence of URL items (first does not exist, second exist)
***********************************************************************************;

%* Call macros (log-output);
OPTIONS NONOTES;
%GLOBAL rc;
%smile_url_check(url="https://github.com/phuse-org/phuse-scripts/blob/master/whitepapers/scriptathons/central/dummy.sas");
%PUT &rc;
%smile_url_check(url="https://github.com/phuse-org/phuse-scripts/blob/master/whitepapers/scriptathons/central/Box_Plot_Baseline.sas");
%PUT &rc;

***********************************************************************************;
* Example 2 - Invalid parameter values provided (error cases)
***********************************************************************************;

%* Call macros (log-output);
%smile_url_check(url=);
%PUT &rc;
%smile_url_check(url=dummy);
%PUT &rc;
