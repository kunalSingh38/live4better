import 'dart:convert';
import 'dart:html' if (dart.library.html) 'dart:html' as html;
import 'dart:ui' as ui;
// // conditional import
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_for_better/constants.dart';
import 'package:live_for_better/view/UiFake.dart'
    if (dart.library.html) 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:live_for_better/view/thanks.dart';
import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class RazorPayWeb extends StatelessWidget {
  String orderId = "";
  String amount = "";
  Map map = {};
  RazorPayWeb(this.orderId, this.amount);

  @override
  Widget build(BuildContext context) {
    print(orderId.toString() + "--------------order id");
    //register view factory
    ui.platformViewRegistry.registerViewFactory("rzp-html", (int viewId) {
      IFrameElement element = IFrameElement();
//Event Listener
      window.onMessage.forEach((element) async {
        if (element.data == 'MODAL_CLOSED') {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Playment Closed / Failed");
        } else if (element.data.toString().contains("pay")) {
          print('PAYMENT SUCCESSFULL!!!!!!!');

          map["razorpay_order"] = orderId.toString();
          map["payment_id"] = element.data.toString();
          print(map);
          var response1 = await http
              .post(Uri.parse(URL + "update-payment"),
                  headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    // 'Authorization': 'Bearer ' + api_token.toString(),
                  },
                  body: jsonEncode(map))
              .then((value) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ThanksPage(paymentId: element.data.toString())));

            // Fluttertoast.showToast(
            //     msg: "Playment Success - " + element.data.toString());
          });
        }
      });

      // element.requestFullscreen();

      print("assets/assets/payment.html?razorpay_order=" +
          orderId.toString() +
          "&amount=" +
          amount.toString());
      element.src = "assets/assets/payment.html?razorpay_order=" +
          orderId.toString() +
          "&amount=" +
          amount.toString();
      element.style.border = 'none';
      return element;
    });
    return Scaffold(body: Builder(builder: (BuildContext context) {
      return Container(
        child: HtmlElementView(viewType: 'rzp-html'),
      );
    }));
  }
}

class SaveFilehelper {
  static Future<void> saveAndOpenFile(List<int> bytes, String bpcNo) async {
    try {
//Get external storage directory
      final directory = await getApplicationDocumentsDirectory();

//Get directory path
      final path = directory.path;

//Create an empty file to write PDF data
      io.File file = io.File('$path/' + bpcNo + '.pdf');

//Write PDF data
      await file.writeAsBytes(bytes, flush: true);

//Open the PDF document in mobile
      OpenFile.open('$path/' + bpcNo + '.pdf');
    } catch (e) {
      print(e);
    }
  }

  void DownloadForWeb(fileName, bytes, fileExtension) {
    // Comment these for mobile application

    html.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", fileName + fileExtension.toString())
      ..click();
  }
}
