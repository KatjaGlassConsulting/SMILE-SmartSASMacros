%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Purpose    : Example program for macro calls of %smile_url_check
%* Author     : Katja Glass
%* Creation   : 2021-01-18
%* SAS Version: SAS 9.4
%* License    : MIT
%************************************************************************************************************************;

%LET path = /folders/myshortcuts/git/SMILE-SmartSASMacros/macros;
%INCLUDE "&path/smile_url_check.sas";

OPTIONS NONOTES;
%GLOBAL rc;
%smile_url_check(url="https://github.com/phuse-org/phuse-scripts/blob/master/whitepapers/scriptathons/central/dummy.sas");
%PUT &rc;
%smile_url_check(url="https://github.com/phuse-org/phuse-scripts/blob/master/whitepapers/scriptathons/central/Box_Plot_Baseline.sas");
%PUT &rc;

%smile_url_check(url=);
%PUT &rc;
%smile_url_check(url=dummy);
%PUT &rc;
