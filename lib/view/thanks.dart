import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_for_better/common_widgets.dart';
import 'package:live_for_better/view/api.dart';
import 'package:live_for_better/view/donation_receipt_pdf.dart';

class ThanksPage extends StatefulWidget {
  String paymentId;
  ThanksPage({required this.paymentId});
  @override
  _ThanksPageState createState() => _ThanksPageState();
}

class _ThanksPageState extends State<ThanksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Thank You",
          style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xffEE9591)),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/banner2.png",
                scale: 8,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  "Thank you for your great generosity! We, at Live4Better, greatly appreciate your donation.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
              SizedBox(
                height: 10,
              ),
              Text(
                "Your support is invaluable to us, thank you again!",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Download Receipt",
                style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  showLaoding(context);
                  DonationAPI()
                      .getReceiptDetails(widget.paymentId.toString())
                      .then((value) {
                    Navigator.of(context, rootNavigator: true).pop();
                    PrintReceiptPDF().downlLoadReceipt(value);
                  });
                },
                child: Image.asset(
                  "assets/receipt_donor.png",
                  scale: 10,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
