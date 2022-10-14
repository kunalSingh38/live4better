import 'dart:typed_data';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:live_for_better/view/payment.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:image/image.dart' as image;

class PrintReceiptPDF {
  double wi = 70;
  double he = 70;

  String convertDateFromStringShow(String strDate) {
    if (strDate != null) {
      String temp = '';
      for (int i = 8; i <= 9; i++) {
        temp = temp + strDate[i];
      }
      temp = temp + '-';
      for (int i = 5; i <= 6; i++) {
        temp = temp + strDate[i];
      }
      temp = temp + '-';
      for (int i = 0; i <= 3; i++) {
        temp = temp + strDate[i];
      }
      return temp;
      // print(todayDate);
      // print();
    } else
      return "";
  }

  String convertDateFromStringpost(String strDate) {
    //  DateTime todayDate = DateTime.parse(strDate);
    //  return formatDate(todayDate, [dd, '-', mm, '-', yyyy,]);
    String temp = '';
    for (int i = 0; i <= 9; i++) {
      temp = temp + strDate[i];
    }
    return temp;
    // print(todayDate);
    // print();
  }

//   void addWaterMark(page, bpc) {
//     if (locator<UserStore>().environment ==
//         "https://roams.cris.org.in/nodeJsTestAPI/") {
//       PdfGraphics graphics = page.graphics;

// //Watermark text
//       PdfGraphicsState state = graphics.save();

//       graphics.setTransparency(1);

//       graphics.rotateTransform(-40);

//       switch (bpc) {
//         case "BPC":
//           graphics.drawString(
//               'SPECIMEN COPY\nFOR TESTING / TRAINING PURPOSE ONLY\nNOT FOR LOCO PILOT AND GUARD',
//               PdfStandardFont(
//                 PdfFontFamily.helvetica,
//                 20,
//               ),
//               format: PdfStringFormat(alignment: PdfTextAlignment.center),
//               pen: PdfPens.black,
//               brush: PdfBrushes.black,
//               bounds: Rect.fromLTWH(-10, 400, 0, 0));
//           break;
//         case "NOTBPC":
//           graphics.drawString(
//               'SPECIMEN COPY', PdfStandardFont(PdfFontFamily.helvetica, 20),
//               pen: PdfPens.black,
//               brush: PdfBrushes.black,
//               bounds: Rect.fromLTWH(-80, 400, 0, 0));
//           break;
//       }

//       graphics.restore(state);
//     }
//   }

//   void setAppVersion(page, englishFont) {
//     page.graphics.drawString(
//         appinfo.AppInfo.version +
//             "\n" +
//             new DateTime.now().toString().split(" ")[0],
//         englishFont);
//   }

  double fontSizeXs = 5;
  double fontSize = 9;
  double fontSizeSmall = 8;
  double fontSizeSmall2 = 8.5;

  PdfStringFormat middleLeftAlign = PdfStringFormat(
      lineAlignment: PdfVerticalAlignment.top,
      alignment: PdfTextAlignment.left,
      measureTrailingSpaces: true,
      wordWrap: PdfWordWrapType.word,
      lineSpacing: -3);

  PdfStringFormat middleJustifyAlign = PdfStringFormat(
      lineAlignment: PdfVerticalAlignment.top,
      alignment: PdfTextAlignment.justify,
      measureTrailingSpaces: true,
      wordWrap: PdfWordWrapType.word,
      lineSpacing: -3);

  PdfStringFormat middleRightAlign = PdfStringFormat(
      lineAlignment: PdfVerticalAlignment.top,
      alignment: PdfTextAlignment.right,
      lineSpacing: -3);
  PdfStringFormat middleCenterAlign = PdfStringFormat(
      lineAlignment: PdfVerticalAlignment.top,
      alignment: PdfTextAlignment.center,
      lineSpacing: -3);

  Future<void> downlLoadReceipt(Map data) async {
    try {
// Create a new PDF document.
      final PdfDocument document = PdfDocument();
      // document.security.userPassword = 'hello';
      document.pageSettings.margins.all = 20;
// Add a new page to the document.
      final PdfPage page = document.pages.add();
      // addWaterMark(page, "BPC");

      PdfStandardFont englishFont =
          PdfStandardFont(PdfFontFamily.helvetica, fontSize);
      PdfStandardFont englishFontVer =
          PdfStandardFont(PdfFontFamily.helvetica, fontSizeXs);

      PdfGridCellStyle withoutBorderFontEnglish = PdfGridCellStyle(
          font: englishFont,
          borders: PdfBorders(
              left: PdfPen(PdfColor(255, 255, 255, 0)),
              top: PdfPen(PdfColor(255, 255, 255, 0)),
              bottom: PdfPen(PdfColor(255, 255, 255, 0)),
              right: PdfPen(PdfColor(255, 255, 255, 0))));

      PdfGridCellStyle withoutBorderFontBoldEnglish = PdfGridCellStyle(
          font: PdfStandardFont(PdfFontFamily.helvetica, fontSize,
              style: PdfFontStyle.bold),
          borders: PdfBorders(
              left: PdfPen(PdfColor(255, 255, 255, 0)),
              top: PdfPen(PdfColor(255, 255, 255, 0)),
              bottom: PdfPen(PdfColor(255, 255, 255, 0)),
              right: PdfPen(PdfColor(255, 255, 255, 0))));

      PdfGridCellStyle withBorderFontEnglish = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 4),
          font: englishFont,
          borders: PdfBorders(
              left: PdfPen(PdfColor(0, 0, 0)),
              top: PdfPen(PdfColor(0, 0, 0)),
              bottom: PdfPen(PdfColor(0, 0, 0)),
              right: PdfPen(PdfColor(0, 0, 0))));
      PdfGridCellStyle withBorderFontBoldEnglish = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 4, top: 4),
          font: PdfStandardFont(PdfFontFamily.helvetica, fontSize,
              style: PdfFontStyle.bold),
          borders: PdfBorders(
              left: PdfPen(PdfColor(0, 0, 0)),
              top: PdfPen(PdfColor(0, 0, 0)),
              bottom: PdfPen(PdfColor(0, 0, 0)),
              right: PdfPen(PdfColor(0, 0, 0))));

//add app version

      PdfGrid grid = PdfGrid();
      grid.columns.add(count: 7);

      final ccTop = await rootBundle.load('assets/receipt_head.jpeg');
//Draw the image

      page.graphics.drawImage(
          PdfBitmap(ccTop.buffer.asUint8List()), Rect.fromLTWH(20, 0, 550, 90));

      PdfGridRow row1 = grid.rows.add();

      row1.cells[0].value = 'Receipt No : ' +
          data['donation_receipt_no']['receipt_no'].toString();
      row1.cells[0].columnSpan = 5;
      row1.cells[0].stringFormat = middleLeftAlign;
      row1.cells[0].style = withoutBorderFontBoldEnglish;

      row1.cells[5].value =
          'Date :' + data['created_at'].toString().split('T')[0];
      row1.cells[5].columnSpan = 2;
      row1.cells[5].stringFormat = middleLeftAlign;
      row1.cells[5].style = withoutBorderFontBoldEnglish;

      PdfGridRow rowspace = grid.rows.add();

      rowspace.cells[0].value = '\n\n';
      rowspace.cells[0].columnSpan = 7;
      rowspace.cells[0].style = withoutBorderFontBoldEnglish;

      PdfGridRow row2 = grid.rows.add();

      row2.cells[0].value = 'DONATION RECEIPT & TAX EXEMPTION CERTIFICATE';
      row2.cells[0].columnSpan = 7;
      row2.cells[0].stringFormat = middleLeftAlign;
      row2.cells[0].style = PdfGridCellStyle(
          font: PdfStandardFont(PdfFontFamily.helvetica, 14,
              multiStyle: [PdfFontStyle.underline, PdfFontStyle.bold]),
          textBrush: PdfBrushes.orange,
          borders: PdfBorders(
              left: PdfPen(PdfColor(255, 255, 255, 0)),
              top: PdfPen(PdfColor(255, 255, 255, 0)),
              bottom: PdfPen(PdfColor(255, 255, 255, 0)),
              right: PdfPen(PdfColor(255, 255, 255, 0))));

      PdfGridRow rowspace1 = grid.rows.add();

      rowspace1.cells[0].value = '\n\n\n\n';
      rowspace1.cells[0].columnSpan = 7;
      rowspace1.cells[0].style = withoutBorderFontBoldEnglish;

      PdfGridRow row3 = grid.rows.add();

      row3.cells[0].value = 'To :';
      row3.cells[0].columnSpan = 2;
      row3.cells[0].stringFormat = middleLeftAlign;
      row3.cells[0].style = withoutBorderFontBoldEnglish;
      row3.cells[2].value =
          data['donor_name'].toString() + ", \n" + data['address'].toString();
      row3.cells[2].columnSpan = 5;
      row3.cells[2].stringFormat = PdfStringFormat(
          lineAlignment: PdfVerticalAlignment.top,
          alignment: PdfTextAlignment.left,
          measureTrailingSpaces: true,
          wordWrap: PdfWordWrapType.word,
          lineSpacing: 1);
      row3.cells[2].style = withoutBorderFontBoldEnglish;

      PdfGridRow rowspace2 = grid.rows.add();

      rowspace2.cells[0].value = '\n\n';
      rowspace2.cells[0].columnSpan = 7;
      rowspace2.cells[0].style = withoutBorderFontBoldEnglish;

      PdfGridRow row4;

      List temp = [
        {"label": "Mobile", "id": "mobile"},
        {"label": "Email", "id": "email"},
        {"label": "PAN", "id": "pan_number"},
        {"label": "Mode of Payment", "id": "mode_of_payment"},
        {"label": "Instrument No.", "id": "description"},
        {"label": "Type of Donor", "id": "type_of_donor"}
      ];

      for (var i = 0; i < temp.length; i++) {
        row4 = grid.rows.add();
        row4.cells[0].value = temp[i]['label'].toString();
        row4.cells[0].columnSpan = 2;
        row4.cells[0].stringFormat = middleLeftAlign;
        row4.cells[0].style = withoutBorderFontBoldEnglish;
        row4.cells[2].value = data[temp[i]['id'].toString()].toString();
        row4.cells[2].columnSpan = 5;
        row4.cells[2].stringFormat = middleLeftAlign;
        row4.cells[2].style = withoutBorderFontEnglish;
      }

      PdfGridRow rowspace3 = grid.rows.add();

      rowspace3.cells[0].value = '\n\n\n';
      rowspace3.cells[0].columnSpan = 7;
      rowspace3.cells[0].style = withoutBorderFontBoldEnglish;

      PdfGridRow row5 = grid.rows.add();

      row5.cells[0].value =
          'We at the Live 4 Better Foundation are grateful for your support towards the corpus fund.\n\nThe Foundation humbly acknowledges the receipt of your kind donation of Rs. ' +
              data['amount'].toString() +
              ' on ' +
              data['created_at'].toString().split('T')[0] +
              '.\n\nYour invaluable contribution will help us to support health, learning, and happiness of children and women across India.';
      row5.cells[0].columnSpan = 7;
      row5.cells[0].stringFormat = PdfStringFormat(
          lineAlignment: PdfVerticalAlignment.top,
          alignment: PdfTextAlignment.left,
          measureTrailingSpaces: true,
          wordWrap: PdfWordWrapType.word,
          lineSpacing: 1);
      row5.cells[0].style = PdfGridCellStyle(
          font: PdfStandardFont(
            PdfFontFamily.helvetica,
            10,
          ),
          borders: PdfBorders(
              left: PdfPen(PdfColor(255, 255, 255, 0)),
              top: PdfPen(PdfColor(255, 255, 255, 0)),
              bottom: PdfPen(PdfColor(255, 255, 255, 0)),
              right: PdfPen(PdfColor(255, 255, 255, 0))));

      PdfGridRow rowspace4 = grid.rows.add();

      rowspace4.cells[0].value = '\n\n\n\n';
      rowspace4.cells[0].columnSpan = 7;
      rowspace4.cells[0].style = withoutBorderFontBoldEnglish;

      PdfGridRow row6 = grid.rows.add();

      row6.cells[0].value = 'For The Live 4 Better Foundation';
      row6.cells[0].columnSpan = 7;
      row6.cells[0].stringFormat = middleLeftAlign;
      row6.cells[0].style = PdfGridCellStyle(
          font: PdfStandardFont(PdfFontFamily.helvetica, 10,
              multiStyle: [PdfFontStyle.italic, PdfFontStyle.bold]),
          borders: PdfBorders(
              left: PdfPen(PdfColor(255, 255, 255, 0)),
              top: PdfPen(PdfColor(255, 255, 255, 0)),
              bottom: PdfPen(PdfColor(255, 255, 255, 0)),
              right: PdfPen(PdfColor(255, 255, 255, 0))));
      PdfGridRow rowspace5 = grid.rows.add();

      rowspace5.cells[0].value = '\n\n\n\n';
      rowspace5.cells[0].columnSpan = 7;
      rowspace5.cells[0].style = withoutBorderFontBoldEnglish;

      PdfGridRow row7 = grid.rows.add();

      row7.cells[0].value = 'Authorised Signatory';
      row7.cells[0].columnSpan = 7;
      row7.cells[0].stringFormat = middleLeftAlign;
      row7.cells[0].style = PdfGridCellStyle(
          font: PdfStandardFont(PdfFontFamily.helvetica, fontSize, multiStyle: [
            PdfFontStyle.italic,
          ]),
          borders: PdfBorders(
              left: PdfPen(PdfColor(255, 255, 255, 0)),
              top: PdfPen(PdfColor(255, 255, 255, 0)),
              bottom: PdfPen(PdfColor(255, 255, 255, 0)),
              right: PdfPen(PdfColor(255, 255, 255, 0))));

      PdfGridRow rowspace6 = grid.rows.add();

      rowspace6.cells[0].value = '\n\n\n\n\n';
      rowspace6.cells[0].columnSpan = 7;
      rowspace6.cells[0].style = withoutBorderFontBoldEnglish;

      PdfGridRow row8 = grid.rows.add();

      row8.cells[0].value =
          'Donation to Live 4 Better Foundation qualify for tax deduction under Section 80 G (5) of the Income Tax Act of India, vide Unique Registration Number AABTL9422GE20216 date 24.09.2021 granted by Principal Commissioner of Income Tax (exemptions), Chandigarh valid for AY 2022-23 to AY 2024-25. Hence, upon realisation of the donation amount, this donation receipt qualifies to be considered as a Tax Exemption Certificate. It is important to note that this receipt is invalid in case of non- realisation of the donation amount or reversal of the realised amount for any reason.';
      row8.cells[0].columnSpan = 7;
      row8.cells[0].stringFormat = PdfStringFormat(
          lineAlignment: PdfVerticalAlignment.top,
          alignment: PdfTextAlignment.justify,
          measureTrailingSpaces: true,
          wordWrap: PdfWordWrapType.word,
          lineSpacing: 1);
      ;
      row8.cells[0].style = withoutBorderFontEnglish;
      grid.draw(
        page: page,
        bounds: const Rect.fromLTWH(50, 110, 500, 0),
      );

      final List<int> bytes = document.save();

      document.dispose();

      if (kIsWeb) {
        SaveFilehelper().DownloadForWeb(
            data['donation_receipt_no']['receipt_no'].toString(),
            bytes,
            ".pdf");
      } else {
        SaveFilehelper.saveAndOpenFile(
            bytes,
            "live4better_donoation_receipt_" +
                data['donation_receipt_no']['receipt_no'].toString());
      }
    } catch (e) {
      print(e);
    }
  }
}
