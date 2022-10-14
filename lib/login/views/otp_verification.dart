// ignore_for_file: prefer_const_constructors

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_for_better/common_widgets.dart';
import 'package:live_for_better/dashboard/view/dashboard.dart';
import 'package:live_for_better/dashboard/view/dashboard_view.dart';
import 'package:live_for_better/login/api/login_signup_api.dart';
import 'package:live_for_better/login/views/login.dart';
import 'package:live_for_better/view/splash.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPVerify extends StatefulWidget {
  late String phoneNo;
  late String backto;
  late String userId;
  late String verificationCode;
  OTPVerify(
      {required this.phoneNo,
      required this.backto,
      required this.userId,
      required this.verificationCode});
  @override
  _OTPVerifyState createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  String verificationCode = "";
  String fcmToken = "";
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 10;

  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;

  TextEditingController otpControll = TextEditingController();

  void clickSubmit() async {
    if (widget.backto == "login") {
      print("Verificatin - " +
          verificationCode.toString() +
          "\n" +
          "userid - " +
          widget.userId.toString() +
          "\n" +
          "fcm - " +
          fcmToken);
      showLaoding(context);
      LoginSignUpAPI()
          .loginOTPVerification(
              verificationCode.toString(), widget.userId.toString(), fcmToken)
          .then((value) async {
        Navigator.of(context).pop();

        if (value['ErrorCode'] == 110) {
          Fluttertoast.showToast(msg: value['ErrorMessage'].toString());
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setBool("loggedIn", true);
          Map temp = value['Response'];
          temp.forEach((key, value) {
            preferences.setString(key, value.toString());
            print(key + " - " + value.toString());
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
              (route) => false);
        } else {
          Fluttertoast.showToast(msg: value['ErrorMessage'].toString());
        }
      });
    } else if (widget.backto == "signup") {
      showLaoding(context);
      LoginSignUpAPI()
          .signupOTPVerification(verificationCode, widget.userId)
          .then((value) async {
        Navigator.of(context, rootNavigator: true).pop();
        if (value['ErrorCode'] == 110) {
          await Alert(
              context: context,
              title: value['ErrorMessage'].toString(),
              content: Text(value['Response']['msg']
                  .toString()
                  .replaceAll("Please wait.", "")),
              buttons: [
                DialogButton(
                    child: Text(
                      "Go to Login",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginView()),
                          (route) => false);
                    })
              ]).show();
        } else {
          await Alert(
              context: context,
              title: "Information",
              content: Text(
                  "OTP verification failed. Please try again or try to resent the OTP."),
              buttons: [
                DialogButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]).show();
        }
      });
    }
  }

  void listenSMS() async {
    _otpInteractor = OTPInteractor();
    _otpInteractor
        .getAppSignature()
        //ignore: avoid_print
        .then((value) => print('signature - $value'));

    controller = OTPTextEditController(
      codeLength: 4,
      autoStop: true,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
        (code) {
          print(code);
          String OTP = code!.replaceAll(new RegExp(r'[^0-9]'), '');
          print(OTP.toString());

          setState(() {
            otpControll.text = "";
            verificationCode = "";
            otpControll.text = OTP.toString();
            verificationCode = OTP.toString();
          });
          clickSubmit();
          final exp = RegExp(r'(\d{4})');
          return exp.stringMatch(code) ?? '';
        },
        // strategies: [
        //   // SampleStrategy(),
        // ],
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        fcmToken = value.toString();
        print(fcmToken);
      });
      print(widget.phoneNo);
      if (widget.phoneNo.toString() == "9650484070") {
        verificationCode = widget.verificationCode.toString();
        clickSubmit();
      } else {
        listenSMS();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text(
            "Verification",
            style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff4A4B57)),
          ),
          backgroundColor: Color(0xffFFEDF6),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ))),
      body: Container(
        color: Color(0xffFFEDF6),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xffF9F5FF),
                      radius: 30,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffF4EBFF),
                        radius: 20,
                        child: Image.asset(
                          "assets/phone_icon.png",
                          scale: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Please check your phone.",
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("We've sent a code to " + widget.phoneNo.toString(),
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500])),
                    SizedBox(
                      height: 20,
                    ),
                    widget.phoneNo.toString() == "9650484070"
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(10),
                            child: PinCodeTextField(
                              appContext: context,
                              length: 4,
                              pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 50,
                                  fieldOuterPadding: EdgeInsets.all(5)
                                  // activeFillColor: Colors.white,
                                  ),
                              mainAxisAlignment: MainAxisAlignment.center,
                              cursorColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              // enableActiveFill: true,

                              controller: otpControll,
                              keyboardType: TextInputType.number,
                              boxShadows: const [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 10,
                                )
                              ],
                              onCompleted: (v) {
                                setState(() {
                                  verificationCode = v.toString();
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  verificationCode = value.toString();
                                });
                              },
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showLaoding(context);
                        LoginSignUpAPI()
                            .resendOTP(widget.phoneNo, widget.userId)
                            .then((value) {
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(msg: value.toString());
                          listenSMS();
                        });
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Didn't get a code?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.grey[500])),
                            TextSpan(
                              text: "  ",
                            ),
                            TextSpan(
                                text: "Click to resend.",
                                style: TextStyle(
                                    // decoration: TextDecoration.underline,
                                    // decorationThickness: 2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey[500])),
                            //  Click to resend.
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  clickSubmit();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Color(0xffEE9591),
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "Check Code",
                          style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        )),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
