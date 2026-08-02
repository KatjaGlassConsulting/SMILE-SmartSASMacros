/* jenner-check bundle adapted from programs/example_pdf_merge_create_single_pdfs.sas
   (KatjaGlassConsulting/SMILE-SmartSASMacros).

   Two adaptations from the original:
   1. The PROC REPORT DATA=sashelp.shoes(...) block is dropped -- SASHELP.SHOES is not
      one of the SASHELP tables this Jenner build ships (confirmed: PROC PRINT
      DATA=sashelp.shoes fails with "Dataset SASHELP.SHOES not found").
   2. The CONTENTS="" option on both PROC REPORT statements is dropped -- Jenner's
      parser does not yet accept PROC REPORT's documented statement-level CONTENTS=
      option (a genuine parser gap, filed as a Jenner regression test separately).
   3. The car makes looped over are Acura/BMW/Honda instead of Acura/Audi/BMW --
      this Jenner build's built-in sashelp.cars is a smaller curated subset with no
      Audi rows (confirmed via PROC SQL GROUP BY make), so Audi was swapped for
      Honda, which has rows.
   Everything else -- the PROC REPORT COLUMN list, the WHERE= filtering, the
   macro loop structure, ODS PDF usage -- is unmodified from the repo's script. */

%LET out = .;

%MACRO loopTroughMake(make,i);
    ODS PDF FILE= "&out/input_pdf_merge_&i..pdf" NOTOC;
    TITLE "Table &i: Multiple outputs - Cars for make = &make";
    PROC REPORT DATA=sashelp.cars(WHERE=(make = "&make")) nowd headline spacing=2;
        COLUMN make model type msrp;
    RUN;
    TITLE;
    ODS PDF CLOSE;
%MEND;

%loopTroughMake(Acura,2);
%loopTroughMake(BMW,3);
%loopTroughMake(Honda,4);
