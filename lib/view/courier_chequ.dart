import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Cheque_Courier extends StatefulWidget {
  const Cheque_Courier({Key? key}) : super(key: key);

  @override
  _Cheque_CourierState createState() => _Cheque_CourierState();
}

class _Cheque_CourierState extends State<Cheque_Courier> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Confirmation",
          style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xffEE9591)),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.asset(
              "assets/banner2.png",
              scale: 10,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
                "Thank you for your great generosity! We, at Live4Better, greatly appreciate your donation.",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
            SizedBox(
              height: 10,
            ),
            Text(
              "Your support is invaluable to us, thank you again!",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Please send cheque to the below address.",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Address : I - 34, DLF Industrial Area, Phase I, Faridabad Pincode, 121003",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
