%************************************************************************************************************************;
%* Project    : SMILE - SAS Macros, Intuitive Library Extension
%* Macro      : smile_pdf_read_bookmarks
%* Parameters : PDFFILE    - name of PDF file with bookmarks
%*              OUTDAT     - output dataset
%*              PDFBOX_JAR - path and jar file name for PDFBOX open source tool, e.g. &path/pdfbox-app-2.0.22.jar
%*
%* Purpose    : Read PDF Bookmarks into a SAS dataset with the variables level, title and page
%* Comment    : Make sure to download PDFBOX, e.g. from here https://pdfbox.apache.org/download.html - the full "app" version
%* Issues     : "unable to resolve class" messages mean the PDFBOX is not provided correctly.
%*              "ERROR: PROCEDURE GROOVY cannot be used when SAS is in the lock down state." means that your SAS environment
%*              does not support PROC GROOVY, for this the macro cannot run the groovy code.
%*
%* ExampleProg: ../programs/test_smile_pdf_read_bookmarks.sas
%*
%* Author     : Katja Glass
%* Creation   : 2021-02-13
%* License    : MIT
%*
%* Reference  : PDFBox contains a lot of useful functionalities (https://pdfbox.apache.org)
%*
%* SAS Version: SAS 9.4
%*
%************************************************************************************************************************;
/*
Examples:
%smile_pdf_read_bookmarks(pdfFile = <path>/ods_document_flat1.pdf,
                          outdat = book_flat1,
                          pdfbox_jar_path = <path>/pdfbox-app-2.0.22.jar)

%smile_pdf_read_bookmarks(pdfFile = <path>/ods_document_noflat1.pdf,
                          outdat = book_noflat1,
                          pdfbox_jar_path = <path>/pdfbox-app-2.0.22.jar)
*/
%************************************************************************************************************************;

%MACRO smile_pdf_read_bookmarks(pdfFile = , outdat = , pdfbox_jar_path = );

    %LOCAL jsonFile;

    FILENAME jsonFile TEMP;
    %LET jsonFile = %SYSFUNC(PATHNAME(jsonFile));

    FILENAME _rdbkpd TEMP;
    DATA _NULL_;
        FILE _rdbkpd LRECL=5000;

        PUT 'PROC GROOVY;';
        PUT '    ADD CLASSPATH = "' "&pdfbox_jar_path" '";';
        PUT '    SUBMIT;';
        PUT ;
        PUT '    import java.io.File;';
        PUT '    import java.io.FileWriter;';
        PUT '    import java.io.IOException;';
        PUT '    import java.io.PrintWriter;';
        PUT '    import java.util.ArrayList;';
        PUT ;
        PUT '    import org.apache.pdfbox.pdmodel.PDDocument;';
        PUT '    import org.apache.pdfbox.pdmodel.PDPage;';
        PUT '    import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDDocumentOutline;';
        PUT '    import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDOutlineItem;';
        PUT '    import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDOutlineNode;';
        PUT ;
        PUT '    public class PDFReadBookmarks {';
        PUT ;
        PUT '        public static void main(String[] args) throws IOException {';
        PUT '            ArrayList<String> aBookmarks = new ArrayList<String>();';
        PUT ;
        PUT '            // Read the PDF document and investigate bookmarks into a list (JSON formatted)';
        PUT '            PDDocument document = PDDocument.load(new File("' "&pdffile" '"));';
        PUT '            PDDocumentOutline outline =  document.getDocumentCatalog().getDocumentOutline();';
        PUT '            addBookmark(aBookmarks, document, outline, 1);';
        PUT '            document.close();';
        PUT ;
        PUT '            // Print bookmark information into a file';
        PUT '            FileWriter fileWriter = new FileWriter("' "&jsonFile" '");';
        PUT '            PrintWriter printWriter = new PrintWriter(fileWriter);';
        PUT '            printWriter.print(aBookmarks);';
        PUT '            printWriter.close();';
        PUT '        }';
        PUT ;
        PUT '        static public void addBookmark(ArrayList<String> bookmarks, PDDocument document, PDOutlineNode bookmark, int level) throws IOException';
        PUT '        {';
        PUT '            PDOutlineItem current = bookmark.getFirstChild();';
        PUT '            while (current != null)';
        PUT '            {';
        PUT '                PDPage currentPage = current.findDestinationPage(document);';
        PUT '                Integer pageNumber = document.getDocumentCatalog().getPages().indexOf(currentPage) + 1;';
        PUT '                String text = "\n{\"level\":" + level + ", \"title\":\"" + current.getTitle() + "\", \"page\":" + pageNumber + "}";';
        PUT '                bookmarks.add(text);';
        PUT '                addBookmark(bookmarks, document, current, level + 1);';
        PUT '                current = current.getNextSibling();';
        PUT '            }';
        PUT '        }';
        PUT '    }';
        PUT 'ENDSUBMIT;';
        PUT 'QUIT;';

    RUN;
    %INCLUDE _rdbkpd;

    LIBNAME jsonCont JSON "&jsonFile";

    DATA &outdat(DROP=ordinal_root);
        SET jsonCont.root;
    RUN;

%MEND smile_pdf_read_bookmarks;
