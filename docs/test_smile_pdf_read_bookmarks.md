# TEST_SMILE_PDF_READ_BOOKMARKS

Example program for macro calls of %smile_pdf_read_bookmarks

 - Author     : Katja Glass
 - Creation   : 2021-02-18
 - SAS Version: SAS 9.4
 - License    : MIT
 

Initialize macros

```sas
%LET root = <path>;
OPTIONS SASAUTOS=(SASAUTOS, "&root/macros");
```

 


## Example 1 - Read bookmarks from a document containing one bookmark level

 


```sas
%smile_pdf_read_bookmarks(pdfFile = &root/results/ods_document_flat1.pdf,
                         outdat = book_flat1,
                         pdfbox_jar_path = &root/lib/pdfbox-app-2.0.22.jar);
```

 

Bookmarks and levels are stored in BOOK_FLAT1
 

LEVEL |TITLE |PAGE
--- | --- | ---
1 |Table 1: By Group Report about shoes |1
1 |Table 2: Table Class Output |5
1 |Table 3: Multiple outputs - Cars for make = Acura |6
1 |Table 4: Multiple outputs - Cars for make = Audi |7
1 |Table 5: Multiple outputs - Cars for make = BMW |8
1 |Table 6: Different label |9
1 |Figure 1: Class graphic |10
 
 

 


## Example 2 - Read bookmarks from a document containing several bookmark levels

 


```sas
%smile_pdf_read_bookmarks(pdfFile = &root/results/ods_document_noflat1.pdf,
                         outdat = book_noflat1,
                         pdfbox_jar_path = &root/lib/pdfbox-app-2.0.22.jar);
```

 

Bookmarks and levels are stored in BOOK_NOFLAT1
 

LEVEL |TITLE |PAGE
--- | --- | ---
1 |Table 1: By Group Report about shoes |1
2 |Region=Canada |1
2 |Region=Pacific |3
1 |Table 2: Table Class Output |5
1 |Table 3: Multiple outputs - Cars for make = Acura |6
1 |Table 4: Multiple outputs - Cars for make = Audi |7
1 |Table 5: Multiple outputs - Cars for make = BMW |8
1 |Table 6: Different label |9
1 |Figure 1: Class graphic |10
2 |The SGPlot Procedure |10
 
