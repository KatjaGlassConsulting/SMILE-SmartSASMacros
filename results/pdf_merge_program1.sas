PROC GROOVY;
    ADD CLASSPATH = "/folders/myshortcuts/git/SMILE-SmartSASMacros/lib/pdfbox-app-2.0.22.jar";
    SUBMIT;

import org.apache.pdfbox.multipdf.PDFMergerUtility;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.interactive.documentnavigation.destination.PDPageDestination;
import org.apache.pdfbox.pdmodel.interactive.documentnavigation.destination.PDPageFitWidthDestination;
import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDDocumentOutline;
import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDOutlineItem;
import java.io.File;

public class PDFMerge2 {
    public static void main(String[] args) {

       //Instantiating PDFMergerUtility class
       PDFMergerUtility PDFmerger = new PDFMergerUtility();

       //Setting the destination file
       PDFmerger.setDestinationFileName("/folders/myshortcuts/git/SMILE-SmartSASMacros/results/pdf_merge_output1.pdf");

       //adding the source files
       PDFmerger.addSource(new File("/folders/myshortcuts/git/SMILE-SmartSASMacros/results/input_pdf_merge_1.pdf"));
       PDFmerger.addSource(new File("/folders/myshortcuts/git/SMILE-SmartSASMacros/results/input_pdf_merge_2.pdf"));
       PDFmerger.addSource(new File("/folders/myshortcuts/git/SMILE-SmartSASMacros/results/input_pdf_merge_3.pdf"));
       PDFmerger.addSource(new File("/folders/myshortcuts/git/SMILE-SmartSASMacros/results/input_pdf_merge_4.pdf"));
       PDFmerger.mergeDocuments(null);
       //Open created document
       PDDocument document;
       PDPageDestination pageDestination;
       PDOutlineItem bookmark;
       document = PDDocument.load(new File("/folders/myshortcuts/git/SMILE-SmartSASMacros/results/pdf_merge_output1.pdf"));

       //Create a bookmark outline
       PDDocumentOutline documentOutline = new PDDocumentOutline();
       document.getDocumentCatalog().setDocumentOutline(documentOutline);

       int currentPage = 0;
       //Include file input_pdf_merge_1.pdf
       pageDestination = new PDPageFitWidthDestination();
       pageDestination.setPage(document.getPage(currentPage));
       bookmark = new PDOutlineItem();
       bookmark.setDestination(pageDestination);
       bookmark.setTitle("Table 1: By Group Report about shoes");
       documentOutline.addLast(bookmark);

       //Change currentPage number
       currentPage += PDDocument.load(new File("/folders/myshortcuts/git/SMILE-SmartSASMacros/results/input_pdf_merge_1.pdf")).getNumberOfPages();

       //Include file input_pdf_merge_2.pdf
       pageDestination = new PDPageFitWidthDestination();
       pageDestination.setPage(document.getPage(currentPage));
       bookmark = new PDOutlineItem();
       bookmark.setDestination(pageDestination);
       bookmark.setTitle("Table 2: Multiple outputs - Cars for make = Acura");
       documentOutline.addLast(bookmark);

       //Change currentPage number
       currentPage += PDDocument.load(new File("/folders/myshortcuts/git/SMILE-SmartSASMacros/results/input_pdf_merge_2.pdf")).getNumberOfPages();

       //Include file input_pdf_merge_3.pdf
       pageDestination = new PDPageFitWidthDestination();
       pageDestination.setPage(document.getPage(currentPage));
       bookmark = new PDOutlineItem();
       bookmark.setDestination(pageDestination);
       bookmark.setTitle("Table 3: Multiple outputs - Cars for make = Audi");
       documentOutline.addLast(bookmark);

       //Change currentPage number
       currentPage += PDDocument.load(new File("/folders/myshortcuts/git/SMILE-SmartSASMacros/results/input_pdf_merge_3.pdf")).getNumberOfPages();

       //Include file input_pdf_merge_4.pdf
       pageDestination = new PDPageFitWidthDestination();
       pageDestination.setPage(document.getPage(currentPage));
       bookmark = new PDOutlineItem();
       bookmark.setDestination(pageDestination);
       bookmark.setTitle("Table 4: Multiple outputs - Cars for make = BMW");
       documentOutline.addLast(bookmark);

       //Change currentPage number
       currentPage += PDDocument.load(new File("/folders/myshortcuts/git/SMILE-SmartSASMacros/results/input_pdf_merge_4.pdf")).getNumberOfPages();

       //save document
       document.save("/folders/myshortcuts/git/SMILE-SmartSASMacros/results/pdf_merge_output1.pdf");

}}
endsubmit;
quit;
