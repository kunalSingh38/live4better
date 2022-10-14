import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_for_better/common_widgets.dart';
import 'package:live_for_better/view/api.dart';
import 'package:live_for_better/view/donation_receipt_pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonationList extends StatefulWidget {
  const DonationList({Key? key}) : super(key: key);

  @override
  _DonationListState createState() => _DonationListState();
}

class _DonationListState extends State<DonationList> {
  List receipts = [];

  TextEditingController mobile = TextEditingController();
  TextEditingController pan = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => showPhotoCaptureOptions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title: Text(
            "Donation Receipts",
            style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xffEE9591)),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  showPhotoCaptureOptions();
                },
                child: Text("Not You"))
          ],
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
        body: ListView(
          children: receipts
              .map((e) => Card(
                    child: ListTile(
                      onTap: () {
                        print(e['payment_id'].toString());
                        // showLaoding(context);
                        DonationAPI()
                            .getReceiptDetails(e['payment_id'].toString())
                            .then((value) {
                          print(value);
                          // Navigator.of(context, rootNavigator: true).pop();
                          PrintReceiptPDF().downlLoadReceipt(value);
                        });
                      },
                      title: Text(
                        e['donor_name'].toString(),
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ),
                      trailing: Icon(Icons.download),
                      minVerticalPadding: 10,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e['mobile'].toString(),
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(e['address'].toString(),
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ));
  }

  Widget textLabels(String text) => Column(
        children: [
          Text(
            text,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xff344054)),
          ),
          SizedBox(
            height: 5,
          )
        ],
      );
  Future<void> showPhotoCaptureOptions() async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  textLabels("Mobile Number"),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty)
                        return "Required Field";
                      else
                        return null;
                    },
                    onChanged: (val) {
                      if (val.length == 10) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    maxLength: 10,
                    controller: mobile,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.phone,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD0D5DD))),
                        fillColor: Colors.white,
                        isDense: true,
                        filled: true),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  textLabels("PAN Number"),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty)
                        return "Required Field";
                      else
                        return null;
                    },
                    controller: pan,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD0D5DD))),
                        fillColor: Colors.white,
                        isDense: true,
                        filled: true),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        showLaoding(context);
                        DonationAPI()
                            .getDonationReceiptList(
                                mobile.text.toString(), pan.text.toString())
                            .then((value) {
                          setState(() {
                            receipts.clear();
                            receipts.addAll(value);
                            print(receipts);
                          });
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.of(context).pop();
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.grey)))),
                      child: Text(
                        "Search",
                        style: TextStyle(color: Colors.black),
                      )),
                ])));
  }
}
