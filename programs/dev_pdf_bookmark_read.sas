%LET root = /folders/myshortcuts/git/SMILE-SmartSASMacros;
%LET out = &root/results;

DATA info;
	level = 1;
	title = "Table 1";
	page = 1;
	OUTPUT;
	level = 2;
	title = "Table 2";
	page = 5;
	OUTPUT;
RUN;

PROC JSON out="&out/test.json" PRETTY NOSASTAGS;
	EXPORT info;
RUN;	

LIBNAME x JSON "&out/test.json";
DATA myInfo(DROP=ordinal_root);
	SET x.root;
RUN;

LIBNAME x JSON "&out/pdf_bookmarks.json";
DATA myInfo(DROP=ordinal_root);
	SET x.root;
RUN;

%MACRO smile_pdf_read_bookmarks(pdfFile = , outdat = , pdfbox_jar_path = );

	%LOCAL jsonFile;
	
	FILENAME jsonFile TEMP;
	%LET jsonFile = %SYSFUNC(PATHNAME(jsonFile));
	
	PROC GROOVY;
	    ADD CLASSPATH = "/folders/myshortcuts/git/SMILE-SmartSASMacros/lib/pdfbox-app-2.0.22.jar";
	    SUBMIT;
	    
	    import java.io.File;
		import java.io.FileWriter;
		import java.io.IOException;
		import java.io.PrintWriter;
		import java.util.ArrayList;
		
		import org.apache.pdfbox.pdmodel.PDDocument;
		import org.apache.pdfbox.pdmodel.PDPage;
		import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDDocumentOutline;
		import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDOutlineItem;
		import org.apache.pdfbox.pdmodel.interactive.documentnavigation.outline.PDOutlineNode;
		
		public class PDFReadBookmarks {

			public static void main(String[] args) throws IOException {
				ArrayList<String> aBookmarks = new ArrayList<String>();
				
				// Read the PDF document and investigate bookmarks into a list (JSON formatted)
				PDDocument document = PDDocument.load(new File("&pdffile"));
				PDDocumentOutline outline =  document.getDocumentCatalog().getDocumentOutline();
				addBookmark(aBookmarks, document, outline, 1);
				document.close();
				
				// Print bookmark information into a file
			    FileWriter fileWriter = new FileWriter("&jsonFile");
			    PrintWriter printWriter = new PrintWriter(fileWriter);
			    printWriter.print(aBookmarks);
			    printWriter.close();
			}
			
			static public void addBookmark(ArrayList<String> bookmarks, PDDocument document, PDOutlineNode bookmark, int level) throws IOException
			{
			    PDOutlineItem current = bookmark.getFirstChild();
			    while (current != null)
			    {
			    	PDPage currentPage = current.findDestinationPage(document);
			    	Integer pageNumber = document.getDocumentCatalog().getPages().indexOf(currentPage) + 1;	    	
			    	String text = "\n{\"level\":" + level + ", \"title\":\"" + current.getTitle() + "\", \"page\":" + pageNumber + "}";
			        bookmarks.add(text);
			        addBookmark(bookmarks, document, current, level + 1);
			        current = current.getNextSibling();
			    }
			}
		}
	ENDSUBMIT;
	QUIT;
	
	LIBNAME jsonCont JSON "&jsonFile";
	
	DATA &outdat(DROP=ordinal_root);
		SET jsonCont.root;
	RUN;	
	
%MEND smile_pdf_read_bookmarks;
