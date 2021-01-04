%LET path = /folders/myshortcuts/git/sas-dev/macro_dev/;
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