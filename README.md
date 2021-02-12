# SMILE - Smart SAS Macros
SMILE stands for <b>S</b>mart SAS <b>M</b>acros - an <b>I</b>ntuitive <b>L</b>ibrary <b>E</b>xtension

Smile contains various small SAS macros supporting various tasks of a SAS programmer. Some macros are inspired by other open source macros and some by available papers. A complete overview can be seen below. More detailed documentation can be found in the macro headers or in the [wiki](https://github.com/KatjaGlassConsulting/SMILE-SmartSASMacros/wiki).

# Macro Overview

The following SAS macros are currently available:

Macro | Description
---|---
smile_attr_var |Function-style macro to return a variable attribute of a dataset. The following attributes are available: VARTYPE, VARLEN, VARLABEL, VARFMT and VARINFMT
smile_attrc |Function-style macro to return a character attribute of a dataset. The following attributes are available: CHARSET, COMPRESS, DATAREP, ENCODING, ENCRYPT, ENGINE, LABEL, LIB, MEM, MODE, MTYPE, SORTEDBY, SORTLVL, SORTSEQ, TYPE
smile_attrn |Function-style macro to return a numeric attribute of a dataset. The following attributes are available: ALTERPW, ANOBS, ANY, ARAND, ARWU, AUDIT, AUDIT_DATA, AUDIT_BEFORE, AUDIT_ERROR, CRDTE, ICONST, INDEX, ISINDEX, ISSUBSET, LRECL, LRID, MAXGEN, MAXRC, MODTE, NDEL, NEXTGEN, NLOBS, NLOBSF, NOBS, NVARS, PW, RADIX, READPW, REUSE, TAPE, WHSTMT, WRITEPW
smile_ods_document_flat_label |Flat navigation and optionally re-label navigation for ODS DOCUMENT. The navigation bookmark level is reduced to one level only. Optionally a label can be applied to all content items or the navigation label can be removed completely.
smile_pdf_merge |Merge multiple PDF files and create one bookmark entry per PDF file with PROC GROOVY and open-source Tool PDFBox
smile_url_check |Check existence of URL and store result in return code, information can optionally be printed to the log
smile_url_download |Downloads a file from an URL and store it locally on OUTFILE. Additionally return code can be stored and information can optionally be printed to the log.

# Getting Started

The macros can be cloned or downloaded directly from the GitHub repository to use this within any SAS environment. The macros has been developed under SAS 9.4 Unix, but are likely to run on other operating systems and also under other SAS versions like from SAS 9.2. 

To use the macros in any program, these can be included single by single via `%INCLUDE "<macro>";` or the folder where the macros are located can be included into the SASAUTOS path `OPTIONS SASAUTOS=(<path>, SASAUTOS);`. The macros can also be stored into a SAS Macro store and used from there.

The repository is using the following structure:

Folder | Content
--- |---
macros | This folder contains the core macros
programs | General programs can be found here - test_* programs are available to check the functionality of macros
results | Outputs generated through programs

# License

The macros and programs are using the MIT-License. See [LICENSE](https://github.com/KatjaGlassConsulting/SMILE-SmartSASMacros/blob/main/LICENSE) for more information.

# Contact

These macros has been developed by Katja Glass Consulting. Feel free to reach me through my [website](https://www.glacon.eu) or via [LinkedIn](https://www.linkedin.com/in/katja-glass-369022167/).

