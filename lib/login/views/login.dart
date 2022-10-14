// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
// import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_for_better/common_widgets.dart';
import 'package:live_for_better/dashboard/view/dashboard.dart';
import 'package:live_for_better/login/api/login_signup_api.dart';
import 'package:live_for_better/login/views/otp_verification.dart';

import 'package:live_for_better/login/views/signup.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController phoneNumberController = TextEditingController();

  Widget webViewLogin() => Row(
        children: [
          Expanded(child: Image.asset("assets/loginimage.png", scale: 4)),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "Dear Volunteer,\nplease Login with your Registered Phone Number ",
                    style: GoogleFonts.roboto(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[70])),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Phone Number",
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff4A4B57)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 400,
                  child: TextFormField(
                    cursorColor: Colors.black,
                    onChanged: (val) {
                      if (val.length == 10) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    style: TextStyle(color: Colors.black),
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    if (phoneNumberController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please enter your Mobile Number");
                    } else {
                      showLaoding(context);

                      LoginSignUpAPI()
                          .loginUser(phoneNumberController.text.toString())
                          .then((value) {
                        Navigator.of(context).pop();

                        if (value['ErrorCode'] == 0) {
                          Fluttertoast.showToast(
                              msg: "OTP Sent", toastLength: Toast.LENGTH_LONG);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OTPVerify(
                                        phoneNo: phoneNumberController.text
                                            .toString(),
                                        backto: "login",
                                        userId: value['Response']['user_id']
                                            .toString(),
                                        verificationCode:
                                            value['Response']['otp'].toString(),
                                      )));
                        } else if (value['ErrorCode'] == -99) {
                          Alert(
                                  context: context,
                                  title: "User not registered",
                                  buttons: [
                                    DialogButton(
                                        child: Text(
                                          "Sign Up",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 243, 237, 237),
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUpView()));
                                        })
                                  ],
                                  type: AlertType.error)
                              .show();
                        } else if (value['ErrorCode'] == -100) {
                          Alert(
                                  context: context,
                                  title: value['ErrorMessage'].toString(),
                                  type: AlertType.error)
                              .show();
                        }
                      });
                    }
                  },
                  child: Container(
                      height: 50,
                      width: 400,
                      decoration: BoxDecoration(
                          color: Color(0xffEE9591),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "Login",
                          style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        )),
                      )),
                ),
                Container(
                  width: 400,
                  child: Stack(alignment: Alignment.center, children: [
                    Divider(
                      thickness: 1,
                      height: 60,
                    ),
                    Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "OR",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Color(0xff344054)),
                          ),
                        ))
                  ]),
                ),
                Container(
                  width: 400,
                  child: Center(
                    child: TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(20)),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xffEE9591))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpView()));
                        },
                        child: Text(
                          "Not Registered Yet? Please click here to Join as Volunteer",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        )),
                  ),
                )
              ],
            ),
          ))
        ],
      );

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return size > 700
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "Live4Better Foundation",
                style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff4A4B57)),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
              backgroundColor: Color(0xffFFEDF6).withAlpha(0),
              elevation: 0,
            ),
            body: Center(child: webViewLogin()))
        : Scaffold(
            // resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Color(0xffFFF8EA),
                  image: DecorationImage(
                      image: AssetImage("assets/splash_image.png"),
                      scale: 4,
                      alignment: Alignment(0, -0.7))),
              child: Column(
                children: [
                  SizedBox(
                    height: 290,
                  ),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: Color(0xff4A4B57)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter your mobile number to login.",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xff4A4B57)),
                  )
                ],
              ),
            ),
            bottomSheet: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(0)),
                  color: Color(0xffEE9591),
                ),
                height: MediaQuery.of(context).size.height / 2.2,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          cursorColor: Colors.white,
                          onChanged: (val) {
                            if (val.length == 10) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: "Phone Number",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () async {
                            if (phoneNumberController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please enter your Mobile Number");
                            } else {
                              showLaoding(context);

                              LoginSignUpAPI()
                                  .loginUser(
                                      phoneNumberController.text.toString())
                                  .then((value) {
                                Navigator.of(context).pop();

                                if (value['ErrorCode'] == 0) {
                                  Fluttertoast.showToast(
                                      msg: "OTP Sent",
                                      toastLength: Toast.LENGTH_LONG);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OTPVerify(
                                                phoneNo: phoneNumberController
                                                    .text
                                                    .toString(),
                                                backto: "login",
                                                userId: value['Response']
                                                        ['user_id']
                                                    .toString(),
                                                verificationCode:
                                                    value['Response']['otp']
                                                        .toString(),
                                              )));
                                } else if (value['ErrorCode'] == -99) {
                                  Alert(
                                          context: context,
                                          title:
                                              value['ErrorMessage'].toString(),
                                          type: AlertType.error)
                                      .show();
                                } else if (value['ErrorCode'] == -100) {
                                  Alert(
                                          context: context,
                                          title:
                                              value['ErrorMessage'].toString(),
                                          type: AlertType.error)
                                      .show();
                                }
                              });
                            }
                          },
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Color(0xffFFF8EA),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  "Login",
                                  style: GoogleFonts.lato(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xff4A4B57)),
                                )),
                              )),
                        ),
                        Stack(alignment: Alignment.center, children: [
                          Divider(
                            thickness: 1,
                            height: 60,
                          ),
                          Container(
                            color: Color(0xffEE9591),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("OR"),
                            ),
                          )
                        ]),
                        InkWell(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpView()));
                          },
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Color(0xffFFF8EA),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  "Sign Up",
                                  style: GoogleFonts.lato(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xff4A4B57)),
                                )),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Container(
                        //         height: 50,
                        //         width: MediaQuery.of(context).size.width / 2.5,
                        //         decoration: BoxDecoration(
                        //             color: Colors.white.withOpacity(0.2),
                        //             borderRadius: BorderRadius.circular(25)),
                        //         child: Padding(
                        //           padding: EdgeInsets.all(10.0),
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Image.asset(
                        //                 "assets/facebook.png",
                        //                 scale: 2,
                        //               ),
                        //               SizedBox(
                        //                 width: 10,
                        //               ),
                        //               Text(
                        //                 "Facebook",
                        //                 style: GoogleFonts.lato(
                        //                     fontSize: 14,
                        //                     fontWeight: FontWeight.w700,
                        //                     color: Colors.white),
                        //               ),
                        //             ],
                        //           ),
                        //         )),
                        //     Container(
                        //         height: 50,
                        //         width: MediaQuery.of(context).size.width / 2.5,
                        //         decoration: BoxDecoration(
                        //             color: Colors.white.withOpacity(0.2),
                        //             borderRadius: BorderRadius.circular(25)),
                        //         child: Padding(
                        //           padding: EdgeInsets.all(10.0),
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Image.asset(
                        //                 "assets/google.png",
                        //                 scale: 50,
                        //               ),
                        //               SizedBox(
                        //                 width: 10,
                        //               ),
                        //               Text(
                        //                 "Google",
                        //                 style: GoogleFonts.lato(
                        //                     fontSize: 14,
                        //                     fontWeight: FontWeight.w700,
                        //                     color: Colors.white),
                        //               ),
                        //             ],
                        //           ),
                        //         ))
                        //   ],
                        // )
                      ]),
                ))));
  }
}
