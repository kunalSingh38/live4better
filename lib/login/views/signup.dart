// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'dart:io';
import 'dart:typed_data';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_for_better/common_widgets.dart';
import 'package:live_for_better/constants.dart';
import 'package:live_for_better/login/api/login_signup_api.dart';
import 'package:live_for_better/login/views/otp_verification.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final ImagePicker _picker = ImagePicker();
  String profilePath = "";
  String adharCardFront = "";
  String adharCardBack = "";
  String photoIdProof = "";
  String backCancelCheque = "";

  bool isLoading = true;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailId = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController photoProofType = TextEditingController();
  TextEditingController photoProofTypeB = TextEditingController();
  TextEditingController addressProofType = TextEditingController();
  TextEditingController photoProof = TextEditingController();
  TextEditingController adharCardNumber = TextEditingController();
  TextEditingController panCardNumber = TextEditingController();

  TextEditingController addressProof = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController bankBranch = TextEditingController();
  TextEditingController bankIFSC = TextEditingController();
  TextEditingController bankAddress = TextEditingController();
  TextEditingController bankAC = TextEditingController();

  GlobalKey profilePhotoKey = GlobalKey();
  GlobalKey photoProofKey = GlobalKey();
  GlobalKey addressProofKey = GlobalKey();

  GlobalKey<FormState> key = new GlobalKey<FormState>();

  int selectAdhar = 0;

  Widget signupform(context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Live4Better Foundation",
              style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[70])),
          SizedBox(
            height: 10,
          ),
          Text("Please provide below details to Register as a Volunteer",
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey)),
          SizedBox(
            height: 20,
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              kIsWeb
                  ? profilePath.isNotEmpty
                      ? Center(
                          child: CircleAvatar(
                            radius: 90,
                            backgroundImage:
                                MemoryImage(base64Decode(profilePath)),
                          ),
                        )
                      : Center(
                          child: CircleAvatar(
                            radius: 90,
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage("profile_image.png"),
                          ),
                        )
                  : profilePath.isEmpty
                      ? Center(
                          child: CircleAvatar(
                            radius: 90,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage("assets/profile_image.png"),
                          ),
                        )
                      : Center(
                          child: CircleAvatar(
                            radius: 90,
                            backgroundImage: FileImage(File(profilePath)),
                          ),
                        ),
              Align(
                  alignment: Alignment(0.5, 0.5),
                  child: InkWell(
                    onTap: () {
                      // if (kIsWeb) {
                      //   getImageForWebProfile(context);
                      // } else {
                      showPhotoCaptureOptions("SPP");
                      // }
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/camera_icon.png",
                          scale: 16,
                        ),
                      ),
                    ),
                  ))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: key,
            child: ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 4,
                  xs: 12,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "First Name*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff757575),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          cursorColor: Color(0xff757575),
                          // onChanged: (val) {
                          //   if (val.length == 10) {
                          //     FocusScope.of(context).unfocus();
                          //   }
                          // },
                          style: TextStyle(color: Color(0xff757575)),
                          controller: firstName,
                          textCapitalization: TextCapitalization.words,
                          // keyboardType: TextInputType.phone,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline,
                                color: Color(0xff757575)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff757575)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  xs: 12,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Last Name (Optional)",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff757575),
                          ),
                        ),
                        TextFormField(
                          // validator: (value) {
                          //   if (value!.isEmpty)
                          //     return "Required Field";
                          //   else
                          //     return null;
                          // },
                          cursorColor: Color(0xff757575),
                          // onChanged: (val) {
                          //   if (val.length == 10) {
                          //     FocusScope.of(context).unfocus();
                          //   }
                          // },
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(color: Color(0xff757575)),
                          controller: lastName,
                          // keyboardType: TextInputType.phone,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline,
                                color: Color(0xff757575)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff757575)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  xs: 12,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email ID*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff757575),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          textCapitalization: TextCapitalization.words,
                          cursorColor: Color(0xff757575),
                          style: TextStyle(color: Color(0xff757575)),
                          controller: emailId,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined,
                                color: Color(0xff757575)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff757575)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  xs: 12,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mobile Number*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff757575),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          cursorColor: Color(0xff757575),
                          onChanged: (val) {
                            if (val.length == 10) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                          maxLength: 10,
                          style: TextStyle(color: Color(0xff757575)),
                          controller: mobileNumber,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon:
                                Icon(Icons.phone, color: Color(0xff757575)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff757575)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  xs: 12,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff757575),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          textCapitalization: TextCapitalization.words,
                          cursorColor: Color(0xff757575),
                          // onChanged: (val) {
                          //   if (val.length == 10) {
                          //     FocusScope.of(context).unfocus();
                          //   }
                          // },

                          style: TextStyle(color: Color(0xff757575)),
                          controller: address,
                          // keyboardType: TextInputType.phone,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_pin,
                                color: Color(0xff757575)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff757575)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  xs: 12,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bank Name*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff757575),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          textCapitalization: TextCapitalization.characters,
                          cursorColor: Color(0xff757575),
                          // onChanged: (val) {
                          //   if (val.length == 10) {
                          //     FocusScope.of(context).unfocus();
                          //   }
                          // },

                          style: TextStyle(color: Color(0xff757575)),
                          controller: bankName,
                          // keyboardType: TextInputType.phone,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined,
                                color: Color(0xff757575)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff757575)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  xs: 12,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bank Branch*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff757575),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          textCapitalization: TextCapitalization.characters,
                          cursorColor: Color(0xff757575),
                          // onChanged: (val) {
                          //   if (val.length == 10) {
                          //     FocusScope.of(context).unfocus();
                          //   }
                          // },

                          style: TextStyle(color: Color(0xff757575)),
                          controller: bankBranch,
                          // keyboardType: TextInputType.phone,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined,
                                color: Color(0xff757575)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff757575)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  xs: 12,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bank IFSC Code*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff757575),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          textCapitalization: TextCapitalization.characters,
                          cursorColor: Color(0xff757575),
                          onChanged: (val) {
                            if (val.length == 11) {
                              FocusScope.of(context).unfocus();
                            }
                          },

                          style: TextStyle(color: Color(0xff757575)),
                          controller: bankIFSC,
                          // keyboardType: TextInputType.phone,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined,
                                color: Color(0xff757575)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff757575)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  xs: 12,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bank A/C No.*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff757575),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          // textCapitalization: TextCapitalization.words,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.phone,
                          cursorColor: Color(0xff757575),
                          // onChanged: (val) {
                          //   if (val.length == 10) {
                          //     FocusScope.of(context).unfocus();
                          //   }
                          // },

                          style: TextStyle(color: Color(0xff757575)),
                          controller: bankAC,
                          // keyboardType: TextInputType.phone,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined,
                                color: Color(0xff757575)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff757575)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  xs: 12,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bank Address*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff757575),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          textCapitalization: TextCapitalization.characters,
                          cursorColor: Color(0xff757575),
                          // onChanged: (val) {
                          //   if (val.length == 10) {
                          //     FocusScope.of(context).unfocus();
                          //   }
                          // },

                          style: TextStyle(color: Color(0xff757575)),
                          controller: bankAddress,
                          // keyboardType: TextInputType.phone,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_pin,
                                color: Color(0xff757575)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff757575)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  xs: 12,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                showPhotoCaptureOptions("BCC");
                              },
                              child: Text("Upload - Bank Cheque")),
                        ),
                        backCancelCheque.isEmpty
                            ? SizedBox()
                            : SizedBox(
                                height: 200,
                                width: 200,
                                child: kIsWeb
                                    ? Image.memory(
                                        base64Decode(backCancelCheque))
                                    : Image.file(File(backCancelCheque)),
                              )
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  xs: 12,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Adhar Card Number*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff757575),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          cursorColor: Color(0xff757575),
                          onChanged: (val) {
                            if (val.length == 12) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                          maxLength: 12,
                          style: TextStyle(color: Color(0xff757575)),
                          controller: adharCardNumber,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon:
                                Icon(Icons.numbers, color: Color(0xff757575)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff757575)),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      showPhotoCaptureOptions("ACF");
                                    },
                                    child: Text("Front Side")),
                                adharCardFront.isEmpty
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 200,
                                        width: 100,
                                        child: kIsWeb
                                            ? Image.memory(
                                                base64Decode(adharCardFront))
                                            : Image.file(File(adharCardFront)),
                                      )
                              ],
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      showPhotoCaptureOptions("ACB");
                                    },
                                    child: Text("Back Side")),
                                adharCardBack.isEmpty
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 200,
                                        width: 100,
                                        child: kIsWeb
                                            ? Image.memory(
                                                base64Decode(adharCardBack))
                                            : Image.file(File(adharCardBack)),
                                      )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  xs: 12,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PAN Card Number*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff757575),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Required Field";
                            else
                              return null;
                          },
                          cursorColor: Color(0xff757575),
                          textCapitalization: TextCapitalization.characters,
                          style: TextStyle(color: Color(0xff757575)),
                          controller: panCardNumber,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon:
                                Icon(Icons.numbers, color: Color(0xff757575)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff757575)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                showPhotoCaptureOptions("PAN");
                              },
                              child: Text("Upload - PAN Card")),
                        ),
                        photoIdProof.isEmpty
                            ? SizedBox()
                            : SizedBox(
                                height: 200,
                                width: 200,
                                child: kIsWeb
                                    ? Image.memory(base64Decode(photoIdProof))
                                    : Image.file(File(photoIdProof)),
                              )
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
            onTap: () async {
              // if (profilePath.isEmpty) {
              //   alertShow("Select Profile", "Please select Profile Photo.");
              //   // Fluttertoast.showToast(msg: "Please select Profile Photo.");
              //   // Scrollable.ensureVisible(profilePhotoKey.currentContext);
              // } else
              if (!key.currentState!.validate()) {
                alertShow("Fields Empty", "Please fill all required fields.");
                // Fluttertoast.showToast(
                //     msg: "Please fill all required fields.");
              } else if (bankIFSC.text.length != 11) {
                alertShow("Inavlid IFSC",
                    "The IFSC code cannot be more or less than 11 digits.");
              } else if (backCancelCheque.isEmpty) {
                alertShow(
                    "Bank Cancel Cheque", "Please select Bank Cancel Cheque.");
                // Fluttertoast.showToast(msg: "Please select Photo ID Proof.");
              } else if (adharCardFront.isEmpty) {
                alertShow(
                    "Adhar Card Font Side", "Please select Adhar Card Proof.");
                // Fluttertoast.showToast(msg: "Please select Address Proof.");
              } else if (adharCardBack.isEmpty) {
                alertShow(
                    "Adhar Card Back Side", "Please select Adhar Card Proof.");
                // Fluttertoast.showToast(msg: "Please select Address Proof.");
              } else if (photoIdProof.isEmpty) {
                alertShow("PAN Card", "Please select PAN Card.");
                // Fluttertoast.showToast(msg: "Please select Address Proof.");
              } else {
                print("Working");
                Map map = {};
                map['first_name'] = firstName.text.toString();
                map['last_name'] = lastName.text.toString();
                map['mobile'] = mobileNumber.text.toString();
                // map['profile_pic'] = kIsWeb
                //     ? profilePath
                //     : base64Encode(File(profilePath).readAsBytesSync()).length;

                map['email'] = emailId.text.toString();
                map['address'] = address.text.toString();
                map['bank_name'] = bankName.text.toString();
                map['bank_branch'] = bankBranch.text.toString();
                map['bank_ifsc_code'] = bankIFSC.text.toString();
                map['bank_ac_number'] = bankAC.text.toString();
                map['volunteer_bank_cheque'] = kIsWeb
                    ? backCancelCheque
                    : base64Encode(File(backCancelCheque).readAsBytesSync());
                map['v_aadhar_front'] = kIsWeb
                    ? adharCardFront
                    : base64Encode(File(adharCardFront).readAsBytesSync());
                map['v_aadhar_back'] = kIsWeb
                    ? adharCardBack
                    : base64Encode(File(adharCardBack).readAsBytesSync());
                map['pan_card_photo'] = kIsWeb
                    ? photoIdProof
                    : base64Encode(File(photoIdProof).readAsBytesSync());
                map['aadhar_no'] = adharCardNumber.text.toString();
                map['pan_no'] = panCardNumber.text.toString();
                map['user_id'] = "";

                showLaoding(context);
                var response = await http.post(Uri.parse(URL + "signup-web"),
                    headers: {
                      'Accept': 'application/json',
                      'Content-Type': 'application/json',
                      // 'Authorization': 'Bearer ' + api_token.toString(),
                    },
                    body: jsonEncode(map));

                Navigator.of(context, rootNavigator: true).pop();

                if (jsonDecode(response.body)['ErrorCode'] == 0) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OTPVerify(
                                userId: jsonDecode(response.body)['Response']
                                        ['user_id']
                                    .toString(),
                                backto: "signup",
                                phoneNo: mobileNumber.text.toString(),
                                verificationCode: "",
                              )));
                } else {
                  // Fluttertoast.showToast(
                  //     msg: value['ErrorMessage'].toString(),
                  //     toastLength: Toast.LENGTH_LONG,
                  //     gravity: ToastGravity.CENTER);
                  Alert(
                    context: context,
                    // title: "WA",
                    type: AlertType.info,

                    desc: capitalize(
                        jsonDecode(response.body)['ErrorMessage'].toString()),
                    buttons: [
                      DialogButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                      )
                    ],
                  ).show();
                }
              }
            },
            child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Color(0xffEE9591),
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Submit",
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  )),
                )),
          ),
        ],
      ),
    );
  }

  void alertShow(title, desc) => Alert(
        context: context,
        title: title.toString(),
        desc: desc.toString(),
        type: AlertType.error,
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            width: 120,
          )
        ],
      ).show();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoginSignUpAPI().getIdentityProofListAPI().then((value) {
      setState(() {
        value.forEach((element) {
          element['selected'] = true;
          element['for'] = "";
        });

        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kIsWeb ? Colors.white : Color(0xffFFEDF6),
      appBar: AppBar(
        title: Text(
          "Sign Up",
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : kIsWeb
              ? Row(children: [
                  Expanded(
                      child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Center(
                        child: Image.asset(
                      "assets/signupimage.png",
                      scale: 4,
                    )),
                  )),
                  Expanded(
                      child: SingleChildScrollView(child: signupform(context)))
                ])
              : SingleChildScrollView(child: signupform(context)),
    );
  }

  Future<void> showPhotoCaptureOptions(String selectionFor) async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
                    child: Text(
                      'Select',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      kIsWeb
                          ? SizedBox()
                          : ElevatedButton.icon(
                              onPressed: () async {
                                final XFile? result = await _picker.pickImage(
                                    source: ImageSource.camera,
                                    maxHeight: 900,
                                    maxWidth: 1000,
                                    imageQuality: 90);
                                if (result != null) {
                                  switch (selectionFor) {
                                    case "SPP":
                                      setState(() {
                                        profilePath = result.path.toString();
                                      });
                                      break;
                                    case "ACF":
                                      setState(() {
                                        adharCardFront = result.path.toString();
                                      });
                                      break;
                                    case "ACB":
                                      setState(() {
                                        adharCardBack = result.path.toString();
                                      });
                                      break;
                                    case "PAN":
                                      setState(() {
                                        photoIdProof = result.path.toString();
                                      });
                                      break;
                                    case "BCC":
                                      setState(() {
                                        backCancelCheque =
                                            result.path.toString();
                                      });
                                      break;
                                  }
                                }
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side:
                                              BorderSide(color: Colors.grey)))),
                              icon: Icon(
                                Icons.camera,
                                color: Colors.black,
                              ),
                              label: Text(
                                "Camera",
                                style: TextStyle(color: Colors.black),
                              )),
                      SizedBox(
                        width: 30,
                      ),
                      ElevatedButton.icon(
                          onPressed: () async {
                            if (kIsWeb) {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();
                              if (result != null) {
                                var sel = result.files.first;
                                var f = sel.bytes;
                                switch (selectionFor) {
                                  case "SPP":
                                    setState(() {
                                      profilePath = base64Encode(f!);
                                    });
                                    break;
                                  case "ACF":
                                    setState(() {
                                      adharCardFront = base64Encode(f!);
                                    });
                                    break;
                                  case "ACB":
                                    setState(() {
                                      adharCardBack = base64Encode(f!);
                                    });
                                    break;
                                  case "PAN":
                                    setState(() {
                                      photoIdProof = base64Encode(f!);
                                    });
                                    break;
                                  case "BCC":
                                    setState(() {
                                      backCancelCheque = base64Encode(f!);
                                    });
                                    break;
                                }
                                Navigator.of(context).pop();
                              }
                            } else {
                              final XFile? result = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  maxHeight: 900,
                                  maxWidth: 1000,
                                  imageQuality: 90);

                              if (result != null) {
                                switch (selectionFor) {
                                  case "SPP":
                                    setState(() {
                                      profilePath = result.path.toString();
                                    });
                                    break;
                                  case "ACF":
                                    setState(() {
                                      adharCardFront = result.path.toString();
                                    });
                                    break;
                                  case "ACB":
                                    setState(() {
                                      adharCardBack = result.path.toString();
                                    });
                                    break;
                                  case "PAN":
                                    setState(() {
                                      photoIdProof = result.path.toString();
                                    });
                                    break;
                                  case "BCC":
                                    setState(() {
                                      backCancelCheque = result.path.toString();
                                    });
                                    break;
                                }
                              }
                              Navigator.of(context).pop();
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.grey)))),
                          icon: Icon(
                            Icons.photo,
                            color: Colors.black,
                          ),
                          label: Text(
                            "Gallery",
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  )
                ])));
  }

  // Future<void> showPhotoCaptureOptionsForAdhar(String val) async {
  //   await showModalBottomSheet(
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
  //       backgroundColor: Colors.white,
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (context) => Padding(
  //           padding: const EdgeInsets.all(20),
  //           child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 // Padding(
  //                 //   padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
  //                 //   child: Text(
  //                 //     'Select',
  //                 //     style:
  //                 //         TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //                 //   ),
  //                 // ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     ElevatedButton.icon(
  //                         onPressed: () async {
  //                           final XFile? result = await _picker.pickImage(
  //                             source: ImageSource.gallery,
  //                             imageQuality: 80,
  //                             maxHeight: 480,
  //                             maxWidth: 640,
  //                           );

  //                           if (result != null) {
  //                             for (var e in getIdentityProofList) {
  //                               if (e['selected'] == false &&
  //                                   e['for'] == 'photoFront') {
  //                                 setState(() {
  //                                   e['selected'] = true;
  //                                   e['for'] = "";
  //                                 });
  //                               }
  //                             }
  //                             for (var e in getIdentityProofList) {
  //                               if (val == e['id'].toString()) {
  //                                 setState(() {
  //                                   photoProof.text = e['name'].toString();
  //                                   photoProofType.text = e['id'].toString();
  //                                   e['selected'] = false;
  //                                   photoProofPath = result.path.toString();

  //                                   e['for'] = "photoFront";
  //                                 });
  //                               }
  //                             }
  //                           }
  //                           print(getIdentityProofList);
  //                           Navigator.of(context).pop();
  //                         },
  //                         style: ButtonStyle(
  //                             backgroundColor:
  //                                 MaterialStateProperty.all(Colors.white),
  //                             shape: MaterialStateProperty.all(
  //                                 RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(18.0),
  //                                     side: BorderSide(color: Colors.grey)))),
  //                         icon: Icon(
  //                           Icons.photo,
  //                           color: Colors.black,
  //                         ),
  //                         label: Text(
  //                           "Front Side",
  //                           style: TextStyle(color: Colors.black),
  //                         )),
  //                     SizedBox(
  //                       width: 30,
  //                     ),
  //                     ElevatedButton.icon(
  //                         onPressed: () async {
  //                           final XFile? result = await _picker.pickImage(
  //                             source: ImageSource.gallery,
  //                             imageQuality: 80,
  //                             maxHeight: 480,
  //                             maxWidth: 640,
  //                           );

  //                           if (result != null) {
  //                             for (var e in getIdentityProofList) {
  //                               if (e['selected'] == false &&
  //                                   e['for'] == 'photoBack') {
  //                                 setState(() {
  //                                   e['selected'] = true;
  //                                   e['for'] = "";
  //                                 });
  //                               }
  //                             }
  //                             for (var e in getIdentityProofList) {
  //                               if (val == e['id'].toString()) {
  //                                 setState(() {
  //                                   photoProofB.text = e['name'].toString();
  //                                   photoProofTypeB.text = e['id'].toString();
  //                                   e['selected'] = false;
  //                                   photoProofPathBack = result.path.toString();

  //                                   e['for'] = "photoBack";
  //                                 });
  //                               }
  //                             }
  //                           }
  //                           Navigator.of(context).pop();
  //                         },
  //                         style: ButtonStyle(
  //                             backgroundColor:
  //                                 MaterialStateProperty.all(Colors.white),
  //                             shape: MaterialStateProperty.all(
  //                                 RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(18.0),
  //                                     side: BorderSide(color: Colors.grey)))),
  //                         icon: Icon(
  //                           Icons.photo,
  //                           color: Colors.black,
  //                         ),
  //                         label: Text(
  //                           "Back Side",
  //                           style: TextStyle(color: Colors.black),
  //                         )),
  //                   ],
  //                 )
  //               ])));
  // }
}
