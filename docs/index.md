# Overview

The following macros are available in the SMILE - Smart SAS Macros - an Intuitive Library Extension.
 
Macro | Description
---|---
smile_attr_var |Function-style macro to return a variable attribute of a dataset. The following attributes are available: VARTYPE, VARLEN, VARLABEL, VARFMT and VARINFMT
smile_attrc |Function-style macro to return a character attribute of a dataset. The following attributes are available: CHARSET, COMPRESS, DATAREP, ENCODING, ENCRYPT, ENGINE, LABEL, LIB, MEM, MODE, MTYPE, SORTEDBY, SORTLVL, SORTSEQ, TYPE
smile_attrn |Function-style macro to return a numeric attribute of a dataset. The following attributes are available: ALTERPW, ANOBS, ANY, ARAND, ARWU, AUDIT, AUDIT_DATA, AUDIT_BEFORE, AUDIT_ERROR, CRDTE, ICONST, INDEX, ISINDEX, ISSUBSET, LRECL, LRID, MAXGEN, MAXRC, MODTE, NDEL, NEXTGEN, NLOBS, NLOBSF, NOBS, NVARS, PW, RADIX, READPW, REUSE, TAPE, WHSTMT, WRITEPW
smile_ods_document_flat_label |Flat navigation and optionally re-label navigation for ODS DOCUMENT. The navigation bookmark level is reduced to one level only. Optionally a label can be applied to all content items or the navigation label can be removed completely.
smile_pdf_merge |Merge multiple PDF files and create one bookmark entry per PDF file with PROC GROOVY and open-source Tool PDFBox
smile_pdf_read_bookmarks |Read PDF Bookmarks into a SAS dataset with the variables level, title and page
smile_url_check |Check existence of URL and store result in return code, information can optionally be printed to the log
smile_url_download |Downloads a file from an URL and store it locally on OUTFILE. Additionally return code can be stored and information can optionally be printed to the log.

## Macros


### smile_attr_var

Key | Description
---|---
Name |smile_attr_var
Purpose |Function-style macro to return a variable attribute of a dataset. The following attributes are available: VARTYPE, VARLEN, VARLABEL, VARFMT and VARINFMT
SAS Version |SAS 9.4
Author |Katja Glass
Date |2021-02-19
Example Program |../programs/test_smile_attr_var.sas
Reference |Main programming parts are coming from attrv.sas macro from Roland Rashleigh-Berry who has published his code under the unlicence license in his utility package (http://www.datasavantconsulting.com/roland/Spectre/download.html)

********************************************

The following parameters are used:

Parameter | Description
---|---
DATA |name of the SAS dataset
VAR |name of variable
ATTRIB |SAS variable attrib keyword (e.g. VARTYPE, VARLEN, VARLABEL, VARFMT and VARINFMT)

<br/>


### smile_attrc

Key | Description
---|---
Name |smile_attrc
Purpose |Function-style macro to return a character attribute of a dataset. The following attributes are available: CHARSET, COMPRESS, DATAREP, ENCODING, ENCRYPT, ENGINE, LABEL, LIB, MEM, MODE, MTYPE, SORTEDBY, SORTLVL, SORTSEQ, TYPE
SAS Version |SAS 9.4
Author |Katja Glass
Date |2021-02-19
Example Program |../programs/test_smile_attrc.sas
Reference |Main programming parts are coming from attrc.sas macro from Roland Rashleigh-Berry who has published his code under the unlicence license in his utility package (http://www.datasavantconsulting.com/roland/Spectre/download.html)

********************************************

The following parameters are used:

Parameter | Description
---|---
DATA |name of the SAS dataset
ATTRIB |SAS ATTRC keyword (e.g. TYPE, LIB, LABEL, SORTEDBY, ...)

<br/>


### smile_attrn

Key | Description
---|---
Name |smile_attrn
Purpose |Function-style macro to return a numeric attribute of a dataset. The following attributes are available: ALTERPW, ANOBS, ANY, ARAND, ARWU, AUDIT, AUDIT_DATA, AUDIT_BEFORE, AUDIT_ERROR, CRDTE, ICONST, INDEX, ISINDEX, ISSUBSET, LRECL, LRID, MAXGEN, MAXRC, MODTE, NDEL, NEXTGEN, NLOBS, NLOBSF, NOBS, NVARS, PW, RADIX, READPW, REUSE, TAPE, WHSTMT, WRITEPW
SAS Version |SAS 9.4
Author |Katja Glass
Date |2021-02-19
Example Program |../programs/test_smile_attrn.sas
Reference |Main programming parts are coming from attrn.sas macro from Roland Rashleigh-Berry who has published his code under the unlicence license in his utility package (http://www.datasavantconsulting.com/roland/Spectre/download.html)

********************************************

The following parameters are used:

Parameter | Description
---|---
DATA |name of the SAS dataset
ATTRIB |SAS ATTRN keyword (e.g. NOBS, CRDTE, ...)

<br/>


### smile_ods_document_flat_label

Key | Description
---|---
Name |smile_ods_document_flat_label
Purpose |Flat navigation and optionally re-label navigation for ODS DOCUMENT. The navigation bookmark level is reduced to one level only. Optionally a label can be applied to all content items or the navigation label can be removed completely.
Comment |The navigation in PDF documents can be one level only with this macro. CONTENTS="" must be applied to the PROC REPORT as option and additionally for a BREAK BEFORE PAGE option.
Issues |The table of contents created per default by SAS (ODS PDF option TOC) is not linking the pages correctly when using BY groups and having one ODS DOCUMENT with multiple outputs, using single ODS DOCUMENTS (one per each output) then this is working correctly. In such a case, do use not a TOC or create an own TOC, e.g. like described here: https://www.mwsug.org/proceedings/2012/S1/MWSUG-2012-S125.pdf
SAS Version |SAS 9.4
Author |Katja Glass
Date |2021-02-15
Example Program |../programs/test_smile_ods_document_flat_label.sas
Reference |A nice overview of ODS DOCUMENT can be found here: https://support.sas.com/resources/papers/proceedings12/273-2012.pdf

********************************************

The following parameters are used:

Parameter | Description
---|---
DOCUMENT |ODS Document item store
LABEL |One label to apply on first element, all other labels are removed (optional), if not provided, labels are just rearranged and additional BY-labels removed
BOOKMARKLABEL |Indicator whether to use Bookmark Labels if none is specified (YES Default), if LABEL is missing and BOOKMARKLABEL = NO, all labels are removed

<br/>


### smile_pdf_merge

Key | Description
---|---
Name |smile_pdf_merge
Purpose |Merge multiple PDF files and create one bookmark entry per PDF file with PROC GROOVY and open-source Tool PDFBox
Comment |Make sure to download PDFBOX, e.g. from here https://pdfbox.apache.org/download.html - the full "app" version
Issues |"unable to resolve class" messages mean the PDFBOX is not provided correctly. "ERROR: PROCEDURE GROOVY cannot be used when SAS is in the lock down state." means that your SAS environment does not support PROC GROOVY, for this the macro cannot run the groovy code. "WARNUNG: Removed /IDTree from /Names dictionary, doesn't belong there" - this message is coming from PDFBox.
SAS Version |SAS 9.4
Author |Katja Glass
Date |2021-01-29
Example Program |../programs/test_smile_pdf_merge.sas
Reference |A paper explaining how to use PDFBOX with PROC GROOVY also for TOC is available in the following paper (https://www.lexjansen.com/phuse/2019/ct/CT05.pdf)

********************************************

The following parameters are used:

Parameter | Description
---|---
DATA |Input dataset containing INFILE and BOOKMARK variable, INFILE containing single pdf files (one file per observation), BOOKMARK containing the corresponding bookmark label for this file
OUTFILE |Output PDF file (not in quotes)
PDFBOX_JAR_PATH |Path and jar file name for PDFBOX open source tool, e.g. &path/pdfbox-app-2.0.22.jar
SOURCEFILE |Optional SAS program file where PROC GROOVY code is stored, default is TEMP (only temporary)
RUN_GROOVY |NO/YES indicator whether to run the final GROOVY code (default YES)

<br/>


### smile_pdf_read_bookmarks

Key | Description
---|---
Name |smile_pdf_read_bookmarks
Purpose |Read PDF Bookmarks into a SAS dataset with the variables level, title and page
Comment |Make sure to download PDFBOX, e.g. from here https://pdfbox.apache.org/download.html - the full "app" version
Issues |"unable to resolve class" messages mean the PDFBOX is not provided correctly. "ERROR: PROCEDURE GROOVY cannot be used when SAS is in the lock down state." means that your SAS environment does not support PROC GROOVY, for this the macro cannot run the groovy code.
SAS Version |SAS 9.4
Author |Katja Glass
Date |2021-02-13
Example Program |../programs/test_smile_pdf_read_bookmarks.sas
Reference |PDFBox contains a lot of useful functionalities (https://pdfbox.apache.org)

********************************************

The following parameters are used:

Parameter | Description
---|---
PDFFILE |name of PDF file with bookmarks
OUTDAT |output dataset
PDFBOX_JAR |path and jar file name for PDFBOX open source tool, e.g. &path/pdfbox-app-2.0.22.jar

<br/>


### smile_url_check

Key | Description
---|---
Name |smile_url_check
Purpose |Check existence of URL and store result in return code, information can optionally be printed to the log
Comment |Return codes are 0 - url found, 999 - no url provided, 998 - url not provided in quotes, otherwise html-return code (e.g. 404 file not found)
SAS Version |SAS 9.4
Author |Katja Glass
Date |2021-02-19
Example Program |../programs/test_smile_url_check.sas
Reference |The idea from this macro is coming from a paper by Joseph Henry - The ABCs of PROC HTTP (https://www.sas.com/content/dam/SAS/support/en/sas-global-forum-proceedings/2019/3232-2019.pdf)

********************************************

The following parameters are used:

Parameter | Description
---|---
URL |http(s) URL which should be checked in quotes
RETURN |return code variable (scope should be global)
INFO |NO/YES indicator to print information to the log

<br/>


### smile_url_download

Key | Description
---|---
Name |smile_url_download
Purpose |Downloads a file from an URL and store it locally on OUTFILE. Additionally return code can be stored and information can optionally be printed to the log.
Comment |Return codes are 0 - URL found, 999 - no URL or OUTFILE provided, 998 - URL or OUTFILE not provided in quotes, otherwise html-return code (e.g. 404 file not found)
SAS Version |SAS 9.4
Author |Katja Glass
Date |2021-01-04
Reference |The idea from this macro is coming from a paper by Joseph Henry - The ABCs of PROC HTTP (https://www.sas.com/content/dam/SAS/support/en/sas-global-forum-proceedings/2019/3232-2019.pdf)

********************************************

The following parameters are used:

Parameter | Description
---|---
URL |http(s) URL which should be checked in quotes
OUTFILE |output file provided in quotes
RETURN |return code variable (scope should be global)
INFO |NO/YES indicator to print information to the log

<br/>

