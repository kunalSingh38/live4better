// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_for_better/common_widgets.dart';
import 'package:live_for_better/constants.dart';
import 'package:live_for_better/view/api.dart';
import 'package:live_for_better/view/courier_chequ.dart';
import 'package:live_for_better/view/payment.dart';
import 'package:live_for_better/view/thanks.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:universal_io/io.dart';

class Donation extends StatefulWidget {
  const Donation({Key? key}) : super(key: key);

  @override
  _DonationState createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  TextEditingController donorName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController pan = TextEditingController();
  TextEditingController instrument = TextEditingController();
  TextEditingController cheNo = TextEditingController();
  TextEditingController cheDate = TextEditingController();
  TextEditingController cheBankName = TextEditingController();

  TextEditingController amount = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List paymentMode = ["Online", "Cheque"];
  String paymentModeValue = "Online";
  List typeOfDonor = ["Individual", "Corporate", "NGO"];
  String typeOfDonorValue = "Individual";
  List purpose = [];

  List sectionCode = ["80 G"];
  String sectionCodeValue = "80 G";
  String purposeValue = "2";
  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid || Platform.isIOS) {
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }

    DonationAPI().getDonationNatureList().then((value) {
      setState(() {
        purpose.addAll(value);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(String razorpay_order) async {
    var options = {
      // 'key': 'rzp_test_MhKrOdDQM8C8PL',
      'key': 'rzp_live_gsrRdTAL36LTCW',
      'order_id': razorpay_order,
      'name': 'Live4Better',
      'description': '',
      'timeout': 600, // in seconds
      'prefill': {
        'contact': mobile.text.toString(),
        'email': email.text.toString()
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print("-------" + e.toString());
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print(jsonEncode({
      "razorpay_order": response.orderId.toString(),
      "payment_id": response.paymentId.toString(),
    }));
    var response1 = await http.post(Uri.parse(URL + "update-payment"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ' + api_token.toString(),
        },
        body: jsonEncode({
          "razorpay_order": response.orderId.toString(),
          "payment_id": response.paymentId.toString(),
        }));

    if (jsonDecode(response1.body)['ErrorCode'] == 0) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ThanksPage(
                    paymentId: response.paymentId.toString(),
                  )));
    } else {
      Fluttertoast.showToast(msg: "Payment Failed");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    /* Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
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

  Widget textField(TextEditingController controller) => Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value!.isEmpty)
                return "Required Field";
              else
                return null;
            },
            controller: controller,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD0D5DD))),
                fillColor: Colors.white,
                isDense: true,
                filled: true),
          ),
          SizedBox(
            height: 10,
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title: Text(
            "Donation",
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
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/sr_bg.png"), fit: BoxFit.fill)),
            child: kIsWeb
                ? Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset("assets/intro_image_1.png")),
                      )),
                      Expanded(child: formView())
                    ],
                  )
                : formView()));
  }

  Widget formView() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Donation Form",
                      style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff101828)),
                    ),
                    Image.asset(
                      "assets/donation.png",
                      scale: 10,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                textLabels("Section Code"),
                FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          value: sectionCodeValue,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              sectionCodeValue = newValue.toString();
                            });
                          },
                          items: sectionCode.map((value) {
                            return DropdownMenuItem(
                              value: value.toString(),
                              child: Text(
                                value.toString(),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                textLabels("Donor Name"),
                textField(donorName),
                textLabels("Address"),
                textField(address),
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
                      contentPadding: EdgeInsets.all(12),
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
                textLabels("Email ID"),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Required Field";
                    else
                      return null;
                  },
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
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
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD0D5DD))),
                      fillColor: Colors.white,
                      isDense: true,
                      filled: true),
                ),
                SizedBox(
                  height: 10,
                ),
                textLabels("Mode of Payment"),
                FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          value: paymentModeValue,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              paymentModeValue = newValue.toString();
                            });
                          },
                          items: paymentMode.map((value) {
                            return DropdownMenuItem(
                              value: value.toString(),
                              child: Text(
                                value.toString(),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                paymentModeValue == "Cheque"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textLabels("Cheque Number"),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Required Field";
                              else
                                return null;
                            },
                            maxLength: 6,
                            onChanged: (val) {
                              if (val.length == 6) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                            controller: cheNo,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                counterText: "",
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD0D5DD))),
                                fillColor: Colors.white,
                                isDense: true,
                                filled: true),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          textLabels("Cheque Date"),
                          TextFormField(
                            controller: cheDate,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(),
                              fillColor: Colors.white,
                              filled: true,
                              isCollapsed: true,
                              isDense: true,
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Please select Date of Birth";
                              }
                              return null;
                            },
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now());
                              if (picked != null)
                                setState(() {
                                  cheDate.text =
                                      picked.toString().split(" ")[0];
                                });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          textLabels("Bank Name"),
                          textField(cheBankName),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      )
                    : SizedBox(
                        height: 10,
                      ),
                textLabels("Type of Donor"),
                FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          value: typeOfDonorValue,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              typeOfDonorValue = newValue.toString();
                            });
                          },
                          items: typeOfDonor.map((value) {
                            return DropdownMenuItem(
                              value: value.toString(),
                              child: Text(
                                value.toString(),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                textLabels("Nature of Donoation"),
                FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          value: purposeValue,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              purposeValue = newValue.toString();
                            });
                          },
                          items: purpose.map((value) {
                            return DropdownMenuItem(
                              value: value['id'].toString(),
                              child: Text(
                                value['name'].toString(),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                textLabels("Amount of Donation"),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Required Field";
                    else
                      return null;
                  },
                  controller: amount,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD0D5DD))),
                      fillColor: Colors.white,
                      isDense: true,
                      filled: true),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                    child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xffEE9591),
                            borderRadius: BorderRadius.circular(25)),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            "PAY",
                            style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          )),
                        )),
                    onTap: () async {
                      print(paymentModeValue);
                      if (formKey.currentState!.validate()) {
                        if (paymentModeValue == "Cheque") {
                          var response1 =
                              await http.post(Uri.parse(URL + "donation"),
                                  headers: {
                                    'Accept': 'application/json',
                                    'Content-Type': 'application/json',
                                    // 'Authorization': 'Bearer ' + api_token.toString(),
                                  },
                                  body: jsonEncode({
                                    "donor_name": donorName.text.toString(),
                                    "address": address.text.toString(),
                                    "mobile": mobile.text.toString(),
                                    "email": email.text.toString(),
                                    "pan_number": pan.text.toString(),
                                    "mode_of_payment": paymentModeValue,
                                    "type_of_donor": typeOfDonorValue,
                                    "purpose_of_donation": purposeValue,
                                    "amount": amount.text.toString(),
                                    "payment_status": "pending",
                                    "payment_id": "",
                                    "cheque_no": cheNo.text.toString(),
                                    "bank_name": cheBankName.text.toString(),
                                    "cheque_date": cheDate.text.toString()
                                  }));

                          print(jsonDecode(response1.body));
                          if (jsonDecode(response1.body)['ErrorCode'] == 0) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Cheque_Courier()));
                          } else {
                            Alert(
                                    context: context,
                                    title: "Failed",
                                    content: Text("Donation Failed. Try Again"))
                                .show();
                          }
                        } else {
                          if (kIsWeb) {
                            var response1 =
                                await http.post(Uri.parse(URL + "donation"),
                                    headers: {
                                      'Accept': 'application/json',
                                      'Content-Type': 'application/json',
                                      // 'Authorization': 'Bearer ' + api_token.toString(),
                                    },
                                    body: jsonEncode({
                                      "donor_name": donorName.text.toString(),
                                      "address": address.text.toString(),
                                      "mobile": mobile.text.toString(),
                                      "email": email.text.toString(),
                                      "pan_number": pan.text.toString(),
                                      "mode_of_payment": paymentModeValue,
                                      "type_of_donor": typeOfDonorValue,
                                      "purpose_of_donation": purposeValue,
                                      "amount": amount.text.toString(),
                                      "payment_status": "success",
                                    }));
                            print(response1.body);
                            if (jsonDecode(response1.body)['ErrorCode'] == 0) {
                              print(jsonDecode(response1.body));
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: ((context) => RazorPayWeb(
                              //             jsonDecode(response1.body)['Response']
                              //                     ['razorpay_order']
                              //                 .toString(),
                              //             jsonDecode(response1.body)['Response']
                              //                     ['amount']
                              //                 .toString()))));
                            }
                          } else {
                            var response1 =
                                await http.post(Uri.parse(URL + "donation"),
                                    headers: {
                                      'Accept': 'application/json',
                                      'Content-Type': 'application/json',
                                      // 'Authorization': 'Bearer ' + api_token.toString(),
                                    },
                                    body: jsonEncode({
                                      "donor_name": donorName.text.toString(),
                                      "address": address.text.toString(),
                                      "mobile": mobile.text.toString(),
                                      "email": email.text.toString(),
                                      "pan_number": pan.text.toString(),
                                      "mode_of_payment": paymentModeValue,
                                      "type_of_donor": typeOfDonorValue,
                                      "purpose_of_donation": purposeValue,
                                      "amount": amount.text.toString(),
                                      "payment_status": "success",
                                    }));
                            print(response1.body);
                            if (jsonDecode(response1.body)['ErrorCode'] == 0) {
                              openCheckout(
                                  jsonDecode(response1.body)['Response']
                                          ['razorpay_order']
                                      .toString());
                            }
                          }
                        }
                      }
                    })
              ],
            ),
          ),
        ),
      );
}
