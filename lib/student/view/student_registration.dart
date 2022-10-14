// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_for_better/common_widgets.dart';
import 'package:live_for_better/constants.dart';
import 'package:live_for_better/student/api/student_registartion_api.dart';
import 'package:live_for_better/student/view/student_dashboard.dart';
import 'package:live_for_better/student/view/student_registration_page_success.dart';
import 'package:path/path.dart' as p;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentRegistrationForm extends StatefulWidget {
  String id = "";
  int index = 0;

  StudentRegistrationForm({required this.id, required this.index});
  @override
  _StudentRegistrationFormState createState() =>
      _StudentRegistrationFormState();
}

class _StudentRegistrationFormState extends State<StudentRegistrationForm>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<FormState> formKey2 = GlobalKey();
  GlobalKey<FormState> formKey3 = GlobalKey();
  GlobalKey<FormState> formKey4 = GlobalKey();
  GlobalKey<FormState> formKey5 = GlobalKey();
  GlobalKey<FormState> formKey6 = GlobalKey();
  String profilePath = "";
  String studentShowProfileOnly = "";
  String studentShowAdhareOnlyFront = "";
  String studentShowAdhareOnlyBack = "";
  String fatherShowAdharOnlyFront = "";
  String fatherShowAdharOnlyBack = "";
  String fatherShowDeathOnly = "";
  String motherShowAdharOnlyFront = "";
  String motherShowAdharOnlyBack = "";
  String motherShowDeathOnly = "";

  String studentBankDetailsCheckShowOnly = "";
  String schoolBankDetailsCheckPath = "";
  String schoolBankDetailsCheckShowOnly = "";

  final ImagePicker _picker = ImagePicker();
  String studentRegistartionNumber = "";
  String schoolId = "";
  String selectedSessionValue = "";
  String selectedGenderValue = "male";
  String selectedStandardValue = "";
  int selectedExpenseValue = 0;
  String fatherAliveValue = "yes";
  String motherAliveValue = "yes";
  TextEditingController studentName = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController session = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController adharCardNumber = TextEditingController();

  TextEditingController fatherName = TextEditingController();
  TextEditingController fatheMobile = TextEditingController();
  TextEditingController fatherAddress = TextEditingController();
  TextEditingController fatherAdharCardNumber = TextEditingController();
  TextEditingController fatherDeathCertificate = TextEditingController();
  TextEditingController fatherOccupation = TextEditingController();
  TextEditingController fatherIncome = TextEditingController();

  String fatherAdharCardFilePathFront = "";
  String fatherAdharCardFilePathBack = "";
  String fatherDeathCertificatePath = "";

  TextEditingController motherName = TextEditingController();
  TextEditingController motherMobile = TextEditingController();
  TextEditingController motherAddress = TextEditingController();
  TextEditingController motherAdharCardNumber = TextEditingController();
  TextEditingController motherDeathCertificate = TextEditingController();
  TextEditingController motherOccupation = TextEditingController();
  TextEditingController motherIncome = TextEditingController();

  String motherAdharCardFilePathFront = "";
  String motherAdharCardFilePathBack = "";
  String motherDeathCertificatePath = "";

  String adharCardFilePathFront = "";
  String adharCardFilePathBack = "";
  late TabController _controller;

//guardian_details
  TextEditingController guardianName = TextEditingController();
  TextEditingController guardianRelation = TextEditingController();
  TextEditingController guardianMobile = TextEditingController();
  TextEditingController guardianEmail = TextEditingController();

//student bank Details
  TextEditingController studentBankName = TextEditingController();
  TextEditingController studentBankBranch = TextEditingController();
  TextEditingController studentIfscCode = TextEditingController();
  TextEditingController studentAccountNumber = TextEditingController();
  String studentBankDetailsCheckPath = "";

//school details
  TextEditingController schoolName = TextEditingController();
  TextEditingController schoolTeacherName = TextEditingController();
  TextEditingController schoolMobile = TextEditingController();
  TextEditingController schoolEmail = TextEditingController();
  TextEditingController schoolAddress = TextEditingController();

//school bank details
  TextEditingController schoolBankName = TextEditingController();
  TextEditingController schoolBankBranch = TextEditingController();
  TextEditingController schoolIfscCode = TextEditingController();
  TextEditingController schoolAccountNumber = TextEditingController();
  List expenseAddedData = [];
  String _verticalGroupValue = "";
  List<String> expenseType = ["Monthly", "Annually"];

  TextEditingController expenseAmount = TextEditingController();

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

  List gender = ['male', 'female', 'other'];
  List fatherAlive = ['yes', 'no'];
  List motherAlive = ['yes', 'no'];
  List motherOccupationList = ['House Wife', 'Worker'];
  String motherOccupationListValue = "House Wife";
  List sessionList = [];
  List standardList = [];
  List expenseMaster = [];
  bool isLoading = true;

  List filledForm = [false, false, false, false, false];
  getDataMaster() async {
    StudentRegistrationAPI api = StudentRegistrationAPI();
    await api.getSessionList().then((value) {
      setState(() {
        sessionList = value;
        selectedSessionValue = sessionList[0]['id'].toString();
      });
    });

    await api.getSStandardList().then((value) {
      setState(() {
        standardList = value;
        selectedStandardValue = standardList[0]['id'].toString();
      });
    });
    await api.getExpenseList().then((value) {
      setState(() {
        expenseMaster.add(
            {"id": 0, "expense_name": "Select", "amount": "", "enabled": true});
        value.forEach((element) {
          element['amount'] = "";
          element['enabled'] = true;
        });

        expenseMaster.addAll(value);
      });

      preFilledReceipts.forEach((e1) {
        expenseMaster.forEach((e2) {
          if (e1['expense_id'] == e2['id']) {
            setState(() {
              e2['enabled'] = false;
              e2['amount'] = e1['expense_fee'].toString();
            });
          }
        });
      });
      print(expenseMaster);
    });

    setState(() {
      isLoading = false;
    });
  }

  List formTabs = [
    'Student Details',
    // 'Guardian Details',
    'Student Bank Details',
    'School Details',
    'School Bank Details',
    'School Fee Details'
  ];

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
  Widget studentRegistartion() => SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            kIsWeb
                                ? studentShowProfileOnly.length != 0
                                    ? Center(
                                        child: CircleAvatar(
                                          radius: 70,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(
                                              studentShowProfileOnly),
                                        ),
                                      )
                                    : profilePath.isEmpty
                                        ? Center(
                                            child: CircleAvatar(
                                              radius: 70,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage: AssetImage(
                                                  "assets/profile_image.png"),
                                            ),
                                          )
                                        : Center(
                                            child: CircleAvatar(
                                              radius: 70,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage: MemoryImage(
                                                  base64Decode(profilePath)),
                                            ),
                                          )
                                : profilePath.isEmpty
                                    ? studentShowProfileOnly.length == 0
                                        ? Center(
                                            child: CircleAvatar(
                                              radius: 70,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage: AssetImage(
                                                  "assets/profile_image.png"),
                                            ),
                                          )
                                        : Center(
                                            child: CircleAvatar(
                                              radius: 70,
                                              backgroundImage: NetworkImage(
                                                  studentShowProfileOnly),
                                            ),
                                          )
                                    : Center(
                                        child: CircleAvatar(
                                          radius: 70,
                                          backgroundImage:
                                              FileImage(File(profilePath)),
                                        ),
                                      ),
                            Align(
                                alignment: Alignment(0.4, 0.4),
                                child: InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    showPhotoCaptureOptions("SPP", 0);
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
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textLabels("Student Name"),
                              textField(studentName),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     Expanded(
                              //       child: textLabels("Gender"),
                              //       flex: 1,
                              //     ),
                              //     Expanded(
                              //       child: textLabels("Date of Birth"),
                              //       flex: 1,
                              //     ),
                              //   ],
                              // ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 2),
                                            child: textLabels("Gender"),
                                          ))),
                                  Expanded(
                                      flex: 3,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 90),
                                            child: textLabels("Date of Birth"),
                                          ))),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: FormField(
                                        builder: (FormFieldState state) {
                                          return InputDecorator(
                                            decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0))),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                isExpanded: true,
                                                value: selectedGenderValue,
                                                isDense: true,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selectedGenderValue =
                                                        newValue.toString();
                                                  });
                                                },
                                                items: gender.map((value) {
                                                  return DropdownMenuItem(
                                                    value: value.toString(),
                                                    child: Text(value
                                                        .toString()
                                                        .toUpperCase()),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller: dob,
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
                                          final DateTime? picked =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1950),
                                                  lastDate: DateTime(2101));
                                          if (picked != null)
                                            setState(() {
                                              dob.text = picked
                                                  .toString()
                                                  .split(" ")[0];
                                            });
                                        },
                                      ),
                                    ),
                                  ]),
                              SizedBox(
                                height: 8,
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     Expanded(
                              //       child: textLabels("Select Session"),
                              //       flex: 1,
                              //     ),
                              //     Expanded(
                              //       child: textLabels("Standard (Class)"),
                              //       flex: 1,
                              //     ),
                              //   ],
                              // ),

                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 2),
                                            child: textLabels("Session"),
                                          ))),
                                  Expanded(
                                      flex: 3,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 90),
                                            child: textLabels("Standard"),
                                          ))),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: FormField(
                                      builder: (FormFieldState state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0))),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              value: selectedSessionValue,
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedSessionValue =
                                                      newValue.toString();
                                                });
                                              },
                                              items: sessionList.map((value) {
                                                return DropdownMenuItem(
                                                  value: value['id'].toString(),
                                                  child: Text(
                                                      value['name'].toString()),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: FormField(
                                      builder: (FormFieldState state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0))),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              value: selectedStandardValue,
                                              isDense: true,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedStandardValue =
                                                      newValue.toString();
                                                });
                                              },
                                              items: standardList.map((value) {
                                                return DropdownMenuItem(
                                                  value: value['id'].toString(),
                                                  child: Text(
                                                      value['name'].toString()),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
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
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: mobileNumber,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffD0D5DD))),
                                    fillColor: Colors.white,
                                    counterText: "",
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(12),
                                    filled: true),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              textLabels("Address"),
                              textField(address),
                              SizedBox(
                                height: 8,
                              ),
                              textLabels("Adhar Card Number"),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return "Required Field";
                                  else
                                    return null;
                                },
                                controller: adharCardNumber,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (val) {
                                  if (val.length == 12) {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                decoration: InputDecoration(
                                    counterText: "",
                                    contentPadding: EdgeInsets.all(12),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffD0D5DD))),
                                    fillColor: Colors.white,
                                    isDense: true,
                                    filled: true),
                                maxLength: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        showPhotoCaptureOptions("SACF", 0);
                                      },
                                      child: Text("Front Side")),
                                  ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        showPhotoCaptureOptions("SACB", 0);
                                      },
                                      child: Text("Back Side"))
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: kIsWeb
                                        ? studentShowAdhareOnlyFront.length != 0
                                            ? Card(
                                                child: ListTile(
                                                  title: Text(
                                                    "Adhar_Card_Front" +
                                                        p.extension(
                                                            studentShowAdhareOnlyFront
                                                                .toString()),
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff344054)),
                                                  ),
                                                  subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                        height: 150,
                                                        child: Image.network(
                                                            studentShowAdhareOnlyFront)),
                                                  ),
                                                  trailing: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        studentShowAdhareOnlyFront =
                                                            "";
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.clear,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : adharCardFilePathFront.isNotEmpty
                                                ? Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        "Adhar_Card_Front" +
                                                            p.extension(
                                                                adharCardFilePathFront
                                                                    .toString()),
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff344054)),
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 150,
                                                          child: Image.memory(
                                                            base64Decode(
                                                                adharCardFilePathFront),
                                                            // scale: 3,
                                                          ),
                                                        ),
                                                      ),
                                                      trailing: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            adharCardFilePathFront =
                                                                "";
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox()
                                        : studentShowAdhareOnlyFront.length != 0
                                            ? Card(
                                                child: ListTile(
                                                  title: Text(
                                                    "Adhar_Card_Front" +
                                                        p.extension(
                                                            studentShowAdhareOnlyFront
                                                                .toString()),
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff344054)),
                                                  ),
                                                  subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                        height: 150,
                                                        child: Image.network(
                                                            studentShowAdhareOnlyFront)),
                                                  ),
                                                  trailing: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        studentShowAdhareOnlyFront =
                                                            "";
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.clear,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : adharCardFilePathFront.isNotEmpty
                                                ? Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        "Adhar_Card_Front" +
                                                            p.extension(
                                                                adharCardFilePathFront
                                                                    .toString()),
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff344054)),
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 150,
                                                          child: Image.file(
                                                            File(
                                                                adharCardFilePathFront),
                                                            // scale: 3,
                                                          ),
                                                        ),
                                                      ),
                                                      trailing: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            adharCardFilePathFront =
                                                                "";
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                  ),

                                  //back
                                  Expanded(
                                    child: kIsWeb
                                        ? studentShowAdhareOnlyBack.length != 0
                                            ? Card(
                                                child: ListTile(
                                                  title: Text(
                                                    "Adhar_Card_Back" +
                                                        p.extension(
                                                            studentShowAdhareOnlyBack
                                                                .toString()),
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff344054)),
                                                  ),
                                                  subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                        height: 150,
                                                        child: Image.network(
                                                            studentShowAdhareOnlyBack)),
                                                  ),
                                                  trailing: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        studentShowAdhareOnlyBack =
                                                            "";
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.clear,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : adharCardFilePathBack.isNotEmpty
                                                ? Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        "Adhar_Card_Back" +
                                                            p.extension(
                                                                adharCardFilePathBack
                                                                    .toString()),
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff344054)),
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 150,
                                                          child: Image.memory(
                                                            base64Decode(
                                                                adharCardFilePathBack),
                                                            // scale: 3,
                                                          ),
                                                        ),
                                                      ),
                                                      trailing: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            adharCardFilePathBack =
                                                                "";
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox()
                                        : studentShowAdhareOnlyBack.length != 0
                                            ? Card(
                                                child: ListTile(
                                                  title: Text(
                                                    "Adhar_Card" +
                                                        p.extension(
                                                            studentShowAdhareOnlyBack
                                                                .toString()),
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff344054)),
                                                  ),
                                                  subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                        height: 150,
                                                        child: Image.network(
                                                            studentShowAdhareOnlyBack)),
                                                  ),
                                                  trailing: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        studentShowAdhareOnlyBack =
                                                            "";
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.clear,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : adharCardFilePathBack.isNotEmpty
                                                ? Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        "Adhar_Card_Back" +
                                                            p.extension(
                                                                adharCardFilePathBack
                                                                    .toString()),
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff344054)),
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 150,
                                                          child: Image.file(
                                                            File(
                                                                adharCardFilePathBack),
                                                            // scale: 3,
                                                          ),
                                                        ),
                                                      ),
                                                      trailing: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            adharCardFilePathBack =
                                                                "";
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Stack(alignment: Alignment.center, children: [
                          Divider(
                            thickness: 1,
                            height: 10,
                          ),
                          Container(
                              color: Color(0xffffd5bc),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Father's Details",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Color(0xff344054)),
                                ),
                              ))
                        ]),
                        Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 2),
                                                child: textLabels("Alive"),
                                              ))),
                                      Expanded(
                                          flex: 3,
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: textLabels("Full Name"),
                                              ))),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FormField(
                                          builder: (FormFieldState state) {
                                            return InputDecorator(
                                              decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0))),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  value: fatherAliveValue,
                                                  isDense: true,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      fatherDeathCertificatePath =
                                                          "";
                                                      fatherAliveValue =
                                                          newValue.toString();
                                                    });
                                                  },
                                                  items:
                                                      fatherAlive.map((value) {
                                                    return DropdownMenuItem(
                                                      value: value.toString(),
                                                      child: Text(value
                                                          .toString()
                                                          .toUpperCase()),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty)
                                              return "Required Field";
                                            else
                                              return null;
                                          },
                                          controller: fatherName,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(12),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Color(0xffD0D5DD))),
                                              fillColor: Colors.white,
                                              isDense: true,
                                              filled: true),
                                        ),
                                        flex: 3,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  fatherAliveValue == "no"
                                      ? Column(
                                          children: [
                                            // textLabels("Death Certificate"),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    showPhotoCaptureOptions(
                                                        "FDC", 0);
                                                  },
                                                  icon: Icon(Icons.upload_file),
                                                  label: Text(
                                                      "Upload - Death Certificate")),
                                            ),
                                            // TextFormField(
                                            //   readOnly: true,
                                            //   controller:
                                            //       fatherDeathCertificate,
                                            //   textCapitalization:
                                            //       TextCapitalization.words,
                                            //   decoration: InputDecoration(
                                            //       suffixIcon: InkWell(
                                            //           onTap: () {
                                            //             FocusScope.of(context)
                                            //                 .unfocus();
                                            //             showPhotoCaptureOptions(
                                            //                 "FDC");
                                            //           },
                                            //           child: Icon(
                                            //               Icons.attachment)),
                                            //       border: OutlineInputBorder(
                                            //           borderSide: BorderSide(
                                            //               color: Color(
                                            //                   0xffD0D5DD))),
                                            //       fillColor: Colors.white,
                                            //       isDense: true,
                                            //       filled: true),
                                            // ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            kIsWeb
                                                ? fatherShowDeathOnly.length !=
                                                        0
                                                    ? Card(
                                                        child: ListTile(
                                                          title: Text(
                                                            "Father_Death_Card" +
                                                                p.extension(
                                                                    fatherShowDeathOnly
                                                                        .toString()),
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xff344054)),
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Image.network(
                                                                  fatherShowDeathOnly),
                                                            ),
                                                          ),
                                                          trailing: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                fatherShowDeathOnly =
                                                                    "";
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.clear,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : fatherDeathCertificatePath
                                                            .isNotEmpty
                                                        ? Card(
                                                            child: ListTile(
                                                              title: Text(
                                                                "Father_Death_Card" +
                                                                    p.extension(
                                                                        fatherDeathCertificatePath
                                                                            .toString()),
                                                                style: GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        0xff344054)),
                                                              ),
                                                              subtitle: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: SizedBox(
                                                                  height: 150,
                                                                  child: Image.memory(
                                                                      base64Decode(
                                                                          fatherDeathCertificatePath)),
                                                                ),
                                                              ),
                                                              trailing: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    fatherDeathCertificatePath =
                                                                        "";
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  Icons.clear,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox()
                                                : fatherShowDeathOnly.length !=
                                                        0
                                                    ? Card(
                                                        child: ListTile(
                                                          title: Text(
                                                            "Father_Death_Card" +
                                                                p.extension(
                                                                    fatherShowDeathOnly
                                                                        .toString()),
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xff344054)),
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Image.network(
                                                                  fatherShowDeathOnly),
                                                            ),
                                                          ),
                                                          trailing: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                fatherShowDeathOnly =
                                                                    "";
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.clear,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : fatherDeathCertificatePath
                                                            .isNotEmpty
                                                        ? Card(
                                                            child: ListTile(
                                                              title: Text(
                                                                "Father_Death_Card" +
                                                                    p.extension(
                                                                        fatherDeathCertificatePath
                                                                            .toString()),
                                                                style: GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        0xff344054)),
                                                              ),
                                                              subtitle: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: SizedBox(
                                                                  height: 150,
                                                                  child: Image
                                                                      .file(File(
                                                                          fatherDeathCertificatePath)),
                                                                ),
                                                              ),
                                                              trailing: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    fatherDeathCertificatePath =
                                                                        "";
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  Icons.clear,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox()
                                          ],
                                        )
                                      : SizedBox(),
                                  fatherAliveValue == "yes"
                                      ? textLabels("Father's Mobile")
                                      : textLabels(
                                          "Father's Mobile (Optional)"),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty &&
                                          fatherAliveValue == "yes")
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
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    controller: fatheMobile,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                        counterText: "",
                                        contentPadding: EdgeInsets.all(12),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffD0D5DD))),
                                        fillColor: Colors.white,
                                        isDense: true,
                                        filled: true),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  // textLabels("Address"),
                                  // textField(fatherAddress),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  textLabels("Adhar Card Number"),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return "Required Field";
                                      else
                                        return null;
                                    },
                                    onChanged: (val) {
                                      if (val.length == 12) {
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                    maxLength: 12,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    controller: fatherAdharCardNumber,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                        counterText: "",
                                        contentPadding: EdgeInsets.all(12),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffD0D5DD))),
                                        fillColor: Colors.white,
                                        isDense: true,
                                        filled: true),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            showPhotoCaptureOptions("FACF", 0);
                                          },
                                          child: Text("Front Side")),
                                      ElevatedButton(
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            showPhotoCaptureOptions("FACB", 0);
                                          },
                                          child: Text("Back Side"))
                                    ],
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: kIsWeb
                                            ? fatherShowAdharOnlyFront.length !=
                                                    0
                                                ? Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        "Father_Adhar_Card_Front" +
                                                            p.extension(
                                                                fatherShowAdharOnlyFront
                                                                    .toString()),
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff344054)),
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 150,
                                                          child: Image.network(
                                                              fatherShowAdharOnlyFront),
                                                        ),
                                                      ),
                                                      trailing: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            fatherShowAdharOnlyFront =
                                                                "";
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : fatherAdharCardFilePathFront
                                                        .isNotEmpty
                                                    ? Card(
                                                        child: ListTile(
                                                          title: Text(
                                                            "Father_Adhar_Card_Front" +
                                                                p.extension(
                                                                    fatherAdharCardFilePathFront
                                                                        .toString()),
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xff344054)),
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Image.memory(
                                                                  base64Decode(
                                                                      fatherAdharCardFilePathFront)),
                                                            ),
                                                          ),
                                                          trailing: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                fatherAdharCardFilePathFront =
                                                                    "";
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.clear,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox()
                                            : fatherShowAdharOnlyFront.length !=
                                                    0
                                                ? Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        "Father_Adhar_Card_Front" +
                                                            p.extension(
                                                                fatherShowAdharOnlyFront
                                                                    .toString()),
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff344054)),
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 150,
                                                          child: Image.network(
                                                              fatherShowAdharOnlyFront),
                                                        ),
                                                      ),
                                                      trailing: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            fatherShowAdharOnlyFront =
                                                                "";
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : fatherAdharCardFilePathFront
                                                        .isNotEmpty
                                                    ? Card(
                                                        child: ListTile(
                                                          title: Text(
                                                            "Father_Adhar_Card_Front" +
                                                                p.extension(
                                                                    fatherAdharCardFilePathFront
                                                                        .toString()),
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xff344054)),
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Image.file(
                                                                  File(
                                                                      fatherAdharCardFilePathFront)),
                                                            ),
                                                          ),
                                                          trailing: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                fatherAdharCardFilePathFront =
                                                                    "";
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.clear,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                      ),
                                      //back father adhar
                                      Expanded(
                                        child: kIsWeb
                                            ? fatherShowAdharOnlyBack.length !=
                                                    0
                                                ? Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        "Father_Adhar_Card_Back" +
                                                            p.extension(
                                                                fatherShowAdharOnlyBack
                                                                    .toString()),
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff344054)),
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 150,
                                                          child: Image.network(
                                                              fatherShowAdharOnlyBack),
                                                        ),
                                                      ),
                                                      trailing: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            fatherShowAdharOnlyBack =
                                                                "";
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : fatherAdharCardFilePathBack
                                                        .isNotEmpty
                                                    ? Card(
                                                        child: ListTile(
                                                          title: Text(
                                                            "Father_Adhar_Card_Back" +
                                                                p.extension(
                                                                    fatherAdharCardFilePathBack
                                                                        .toString()),
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xff344054)),
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Image.memory(
                                                                  base64Decode(
                                                                      fatherAdharCardFilePathBack)),
                                                            ),
                                                          ),
                                                          trailing: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                fatherAdharCardFilePathBack =
                                                                    "";
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.clear,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox()
                                            : fatherShowAdharOnlyBack.length !=
                                                    0
                                                ? Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        "Father_Adhar_Card_Back" +
                                                            p.extension(
                                                                fatherShowAdharOnlyBack
                                                                    .toString()),
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff344054)),
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 150,
                                                          child: Image.network(
                                                              fatherShowAdharOnlyBack),
                                                        ),
                                                      ),
                                                      trailing: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            fatherShowAdharOnlyBack =
                                                                "";
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : fatherAdharCardFilePathBack
                                                        .isNotEmpty
                                                    ? Card(
                                                        child: ListTile(
                                                          title: Text(
                                                            "Father_Adhar_Card_Back" +
                                                                p.extension(
                                                                    fatherAdharCardFilePathBack
                                                                        .toString()),
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xff344054)),
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Image.file(
                                                                  File(
                                                                      fatherAdharCardFilePathBack)),
                                                            ),
                                                          ),
                                                          trailing: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                fatherAdharCardFilePathBack =
                                                                    "";
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.clear,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                      ),
                                    ],
                                  ),
                                  fatherAliveValue == "yes"
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            textLabels("Father Occupation"),
                                            TextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty &&
                                                    fatherAliveValue == "yes")
                                                  return "Required Field";
                                                else
                                                  return null;
                                              },
                                              controller: fatherOccupation,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(12),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xffD0D5DD))),
                                                  fillColor: Colors.white,
                                                  isDense: true,
                                                  filled: true),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            textLabels(
                                                "Father Income (monthly)"),
                                            TextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty &&
                                                    fatherAliveValue == "yes")
                                                  return "Required Field";
                                                else
                                                  return null;
                                              },
                                              controller: fatherIncome,
                                              keyboardType: TextInputType.phone,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(12),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xffD0D5DD))),
                                                  fillColor: Colors.white,
                                                  isDense: true,
                                                  filled: true),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        )
                                      : SizedBox(),
                                ])),
                        Stack(alignment: Alignment.center, children: [
                          Divider(
                            thickness: 1,
                            height: 10,
                          ),
                          Container(
                              color: Color(0xffffd5bc),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Mother's Details",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Color(0xff344054)),
                                ),
                              ))
                        ]),
                        Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1, child: textLabels("Alive")),
                                      Expanded(
                                          flex: 3, child: textLabels("Name")),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FormField(
                                          builder: (FormFieldState state) {
                                            return InputDecorator(
                                              decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0))),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  value: motherAliveValue,
                                                  isDense: true,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      motherDeathCertificatePath =
                                                          "";
                                                      motherAliveValue =
                                                          newValue.toString();
                                                    });
                                                  },
                                                  items:
                                                      motherAlive.map((value) {
                                                    return DropdownMenuItem(
                                                      value: value.toString(),
                                                      child: Text(value
                                                          .toString()
                                                          .toUpperCase()),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty)
                                              return "Required Field";
                                            else
                                              return null;
                                          },
                                          controller: motherName,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(12),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Color(0xffD0D5DD))),
                                              fillColor: Colors.white,
                                              isDense: true,
                                              filled: true),
                                        ),
                                        flex: 3,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  motherAliveValue == "no"
                                      ? Column(
                                          children: [
                                            // textLabels(
                                            //     "Mother Death Certificate"),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    showPhotoCaptureOptions(
                                                        "MDC", 0);
                                                  },
                                                  icon: Icon(Icons.upload_file),
                                                  label: Text(
                                                      "Upload - Death Certificate")),
                                            ),

                                            // TextFormField(
                                            //   readOnly: true,
                                            //   controller:
                                            //       motherDeathCertificate,
                                            //   textCapitalization:
                                            //       TextCapitalization.words,
                                            //   decoration: InputDecoration(
                                            //       suffixIcon: InkWell(
                                            //           onTap: () {
                                            //             FocusScope.of(context)
                                            //                 .unfocus();
                                            //             showPhotoCaptureOptions(
                                            //                 "MDC");
                                            //           },
                                            //           child: Icon(
                                            //               Icons.attachment)),
                                            //       border: OutlineInputBorder(
                                            //           borderSide: BorderSide(
                                            //               color: Color(
                                            //                   0xffD0D5DD))),
                                            //       fillColor: Colors.white,
                                            //       isDense: true,
                                            //       filled: true),
                                            // ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            kIsWeb
                                                ? motherShowDeathOnly.length !=
                                                        0
                                                    ? Card(
                                                        child: ListTile(
                                                          title: Text(
                                                            "Mother_Death_Card" +
                                                                p.extension(
                                                                    motherShowDeathOnly
                                                                        .toString()),
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xff344054)),
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Image.network(
                                                                  motherShowDeathOnly),
                                                            ),
                                                          ),
                                                          trailing: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                motherShowDeathOnly =
                                                                    "";
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.clear,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : motherDeathCertificatePath
                                                            .isNotEmpty
                                                        ? Card(
                                                            child: ListTile(
                                                              title: Text(
                                                                "Mother_Death_Card" +
                                                                    p.extension(
                                                                        motherDeathCertificatePath
                                                                            .toString()),
                                                                style: GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        0xff344054)),
                                                              ),
                                                              subtitle: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: SizedBox(
                                                                  height: 150,
                                                                  child: Image.memory(
                                                                      base64Decode(
                                                                          motherDeathCertificatePath)),
                                                                ),
                                                              ),
                                                              trailing: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    motherDeathCertificatePath =
                                                                        "";
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  Icons.clear,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox()
                                                : motherShowDeathOnly.length !=
                                                        0
                                                    ? Card(
                                                        child: ListTile(
                                                          title: Text(
                                                            "Mother_Death_Card" +
                                                                p.extension(
                                                                    motherShowDeathOnly
                                                                        .toString()),
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xff344054)),
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Image.network(
                                                                  motherShowDeathOnly),
                                                            ),
                                                          ),
                                                          trailing: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                motherShowDeathOnly =
                                                                    "";
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.clear,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : motherDeathCertificatePath
                                                            .isNotEmpty
                                                        ? Card(
                                                            child: ListTile(
                                                              title: Text(
                                                                "Mother_Death_Card" +
                                                                    p.extension(
                                                                        motherDeathCertificatePath
                                                                            .toString()),
                                                                style: GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        0xff344054)),
                                                              ),
                                                              subtitle: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: SizedBox(
                                                                  height: 150,
                                                                  child: Image
                                                                      .file(File(
                                                                          motherDeathCertificatePath)),
                                                                ),
                                                              ),
                                                              trailing: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    motherDeathCertificatePath =
                                                                        "";
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  Icons.clear,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox()
                                          ],
                                        )
                                      : SizedBox(),
                                  motherAliveValue == "yes"
                                      ? textLabels("Mother's Mobile")
                                      : textLabels(
                                          "Mother's Mobile (Optional)"),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty &&
                                          motherAliveValue == "yes")
                                        return "Required Field";
                                      else
                                        return null;
                                    },
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (val) {
                                      if (val.length == 10) {
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                    maxLength: 10,
                                    controller: motherMobile,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffD0D5DD))),
                                        fillColor: Colors.white,
                                        isDense: true,
                                        counterText: "",
                                        contentPadding: EdgeInsets.all(12),
                                        filled: true),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  // textLabels("Address"),
                                  // textField(motherAddress),
                                  // SizedBox(
                                  //   height: 8,
                                  // ),
                                  textLabels("Adhar Card Number"),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return "Required Field";
                                      else
                                        return null;
                                    },
                                    onChanged: (val) {
                                      if (val.length == 12) {
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                    maxLength: 12,
                                    controller: motherAdharCardNumber,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                        counterText: "",
                                        contentPadding: EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffD0D5DD))),
                                        fillColor: Colors.white,
                                        isDense: true,
                                        filled: true),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            showPhotoCaptureOptions("MACF", 0);
                                          },
                                          child: Text("Front Side")),
                                      ElevatedButton(
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            showPhotoCaptureOptions("MACB", 0);
                                          },
                                          child: Text("Back Side"))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: kIsWeb
                                            ? motherShowAdharOnlyFront.length !=
                                                    0
                                                ? Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        "Mother_Adhar_Card_Front" +
                                                            p.extension(
                                                                motherShowAdharOnlyFront
                                                                    .toString()),
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff344054)),
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 150,
                                                          child: Image.network(
                                                              motherShowAdharOnlyFront),
                                                        ),
                                                      ),
                                                      trailing: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            motherShowAdharOnlyFront =
                                                                "";
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : motherAdharCardFilePathFront
                                                        .isNotEmpty
                                                    ? Card(
                                                        child: ListTile(
                                                          title: Text(
                                                            "Mother_Adhar_Card_Front" +
                                                                p.extension(
                                                                    motherAdharCardFilePathFront
                                                                        .toString()),
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xff344054)),
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Image.memory(
                                                                  base64Decode(
                                                                      motherAdharCardFilePathFront)),
                                                            ),
                                                          ),
                                                          trailing: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                motherAdharCardFilePathFront =
                                                                    "";
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.clear,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox()
                                            : motherShowAdharOnlyFront.length !=
                                                    0
                                                ? Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        "Mother_Adhar_Card_Front" +
                                                            p.extension(
                                                                motherShowAdharOnlyFront
                                                                    .toString()),
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff344054)),
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 150,
                                                          child: Image.network(
                                                              motherShowAdharOnlyFront),
                                                        ),
                                                      ),
                                                      trailing: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            motherShowAdharOnlyFront =
                                                                "";
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : motherAdharCardFilePathFront
                                                        .isNotEmpty
                                                    ? Card(
                                                        child: ListTile(
                                                          title: Text(
                                                            "Mother_Adhar_Card_Front" +
                                                                p.extension(
                                                                    motherAdharCardFilePathFront
                                                                        .toString()),
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xff344054)),
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Image.file(
                                                                  File(
                                                                      motherAdharCardFilePathFront)),
                                                            ),
                                                          ),
                                                          trailing: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                motherAdharCardFilePathFront =
                                                                    "";
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.clear,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                      ),
                                      //back mother adhar

                                      Expanded(
                                        child: kIsWeb
                                            ? motherShowAdharOnlyBack.length !=
                                                    0
                                                ? Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        "Mother_Adhar_Card_Back" +
                                                            p.extension(
                                                                motherShowAdharOnlyBack
                                                                    .toString()),
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff344054)),
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 150,
                                                          child: Image.network(
                                                              motherShowAdharOnlyBack),
                                                        ),
                                                      ),
                                                      trailing: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            motherShowAdharOnlyBack =
                                                                "";
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : motherAdharCardFilePathBack
                                                        .isNotEmpty
                                                    ? Card(
                                                        child: ListTile(
                                                          title: Text(
                                                            "Mother_Adhar_Card_Back" +
                                                                p.extension(
                                                                    motherAdharCardFilePathBack
                                                                        .toString()),
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xff344054)),
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Image.memory(
                                                                  base64Decode(
                                                                      motherAdharCardFilePathBack)),
                                                            ),
                                                          ),
                                                          trailing: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                motherAdharCardFilePathBack =
                                                                    "";
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.clear,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox()
                                            : motherShowAdharOnlyBack.length !=
                                                    0
                                                ? Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        "Mother_Adhar_Card_Back" +
                                                            p.extension(
                                                                motherShowAdharOnlyBack
                                                                    .toString()),
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff344054)),
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 150,
                                                          child: Image.network(
                                                              motherShowAdharOnlyBack),
                                                        ),
                                                      ),
                                                      trailing: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            motherShowAdharOnlyBack =
                                                                "";
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : motherAdharCardFilePathBack
                                                        .isNotEmpty
                                                    ? Card(
                                                        child: ListTile(
                                                          title: Text(
                                                            "Mother_Adhar_Card_Back" +
                                                                p.extension(
                                                                    motherAdharCardFilePathBack
                                                                        .toString()),
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xff344054)),
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 150,
                                                              child: Image.file(
                                                                  File(
                                                                      motherAdharCardFilePathBack)),
                                                            ),
                                                          ),
                                                          trailing: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                motherAdharCardFilePathBack =
                                                                    "";
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.clear,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                      ),
                                    ],
                                  ),

                                  motherAliveValue == "yes"
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            textLabels("Mother Occupation"),
                                            FormField(
                                              builder: (FormFieldState state) {
                                                return InputDecorator(
                                                  decoration: InputDecoration(
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0))),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton(
                                                      isExpanded: true,
                                                      value:
                                                          motherOccupationListValue,
                                                      isDense: true,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          motherOccupationListValue =
                                                              newValue
                                                                  .toString();
                                                        });
                                                      },
                                                      items:
                                                          motherOccupationList
                                                              .map((value) {
                                                        return DropdownMenuItem(
                                                          value:
                                                              value.toString(),
                                                          child: Text(value
                                                              .toString()
                                                              .toUpperCase()),
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
                                            textLabels(
                                                "Mother Income (monthly)"),
                                            TextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty &&
                                                    motherAliveValue == "yes")
                                                  return "Required Field";
                                                else
                                                  return null;
                                              },
                                              controller: motherIncome,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              keyboardType: TextInputType.phone,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(12),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xffD0D5DD))),
                                                  fillColor: Colors.white,
                                                  isDense: true,
                                                  filled: true),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )
                                      : SizedBox(),

                                  // textField(motherOccupation),

                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Color(0xffEE9591),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: filledForm[0]
                                                  ? Text(
                                                      "Update & Next",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color: Colors.white),
                                                    )
                                                  : Text(
                                                      "Save & Next",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color: Colors.white),
                                                    )),
                                        )),
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      // print(profilePath.length);

                                      if (studentShowProfileOnly.length == 0 &&
                                          profilePath.length == 0) {
                                        alertShow("Student\'s Profile Photo",
                                            "Required");
                                      } else if (studentShowAdhareOnlyFront
                                                  .length ==
                                              0 &&
                                          adharCardFilePathFront.length == 0) {
                                        alertShow("Student\'s Adhar Card Front",
                                            "Required");
                                      } else if (studentShowAdhareOnlyBack
                                                  .length ==
                                              0 &&
                                          adharCardFilePathBack.length == 0) {
                                        alertShow("Student\'s Adhar Card Back",
                                            "Required");
                                      } else if (fatherShowAdharOnlyFront
                                                  .length ==
                                              0 &&
                                          fatherAdharCardFilePathFront.length ==
                                              0) {
                                        alertShow("Father\'s Adhar Card Front",
                                            "Required");
                                      } else if (fatherShowAdharOnlyBack
                                                  .length ==
                                              0 &&
                                          fatherAdharCardFilePathBack.length ==
                                              0) {
                                        alertShow("Father\'s Adhar Card Back",
                                            "Required");
                                      } else if (fatherAliveValue == "no" &&
                                          fatherDeathCertificatePath.length ==
                                              0 &&
                                          fatherShowDeathOnly.length == 0) {
                                        alertShow("Father\'s Death Certificate",
                                            "Required");
                                      } else if (motherShowAdharOnlyFront
                                                  .length ==
                                              0 &&
                                          motherAdharCardFilePathFront.length ==
                                              0) {
                                        alertShow("Mother\'s Adhar Card Front",
                                            "Required");
                                      } else if (motherShowAdharOnlyBack
                                                  .length ==
                                              0 &&
                                          motherAdharCardFilePathBack.length ==
                                              0) {
                                        alertShow("Mother\'s Adhar Card Back",
                                            "Required");
                                      } else if (motherAliveValue == "no" &&
                                          motherDeathCertificatePath.length ==
                                              0 &&
                                          motherShowDeathOnly.length == 0) {
                                        alertShow("Mother\'s Death Certificate",
                                            "Required");
                                      } else if (formKey.currentState!
                                          .validate()) {
                                        showLaoding(context);
                                        var request = http.MultipartRequest(
                                            'POST',
                                            Uri.parse(URL +
                                                "student-personal-store"));
                                        request.headers.addAll({
                                          'Accept': 'application/json',
                                          // 'Authorization': 'Bearer ' + api_token.toString(),
                                        });

                                        request.fields['type'] = "1";
                                        request.fields['student_name'] =
                                            studentName.text.toString();
                                        request.fields['user_id'] =
                                            pref.getString("id").toString();
                                        request.fields['session'] =
                                            selectedSessionValue.toString();
                                        request.fields['adhaar_number'] =
                                            adharCardNumber.text.toString();

                                        request.fields['mobile'] =
                                            mobileNumber.text.toString();
                                        request.fields['dob'] =
                                            dob.text.toString();
                                        request.fields['address'] =
                                            address.text.toString();
                                        request.fields['student_age'] = "";
                                        request.fields['gender'] =
                                            selectedGenderValue.toString();
                                        request.fields['standard'] =
                                            selectedStandardValue.toString();
                                        request.fields['father_alive'] =
                                            fatherAliveValue.toString();
                                        request.fields['father_name'] =
                                            fatherName.text.toString();
                                        request.fields['father_occupation'] =
                                            fatherOccupation.text.toString();
                                        request.fields['father_adhaar'] =
                                            fatherAdharCardNumber.text
                                                .toString();
                                        request.fields['father_mobile'] =
                                            fatheMobile.text.toString();
                                        request.fields[
                                                'father_monthly_income'] =
                                            fatherIncome.text.toString();

                                        request.fields['mother_alive'] =
                                            motherAliveValue.toString();
                                        request.fields['mother_name'] =
                                            motherName.text.toString();
                                        request.fields['mother_occupation'] =
                                            motherOccupationListValue
                                                .toString();
                                        request.fields['mother_adhaar'] =
                                            motherAdharCardNumber.text
                                                .toString();
                                        request.fields['mother_mobile'] =
                                            motherMobile.text.toString();
                                        request.fields[
                                                'mother_monthly_income'] =
                                            motherIncome.text.toString();

                                        request.fields['student_id'] =
                                            studentRegistartionNumber
                                                .toString();

                                        double income1 = fatherIncome.text
                                                    .toString() ==
                                                ""
                                            ? 0
                                            : double.parse(
                                                fatherIncome.text.toString());

                                        double income2 = motherIncome.text
                                                    .toString() ==
                                                ""
                                            ? 0
                                            : double.parse(
                                                motherIncome.text.toString());

                                        request.fields['household_income'] =
                                            (income1 + income2).toString();

                                        if (profilePath.isNotEmpty) {
                                          if (kIsWeb) {
                                            request.fields[
                                                    'student_profile_pic'] =
                                                profilePath;
                                          } else {
                                            request.fields[
                                                    'student_profile_pic'] =
                                                base64Encode(File(profilePath)
                                                    .readAsBytesSync());
                                          }
                                        }
                                        if (adharCardFilePathFront.isNotEmpty) {
                                          if (kIsWeb) {
                                            request.fields[
                                                    'student_adhaar_file'] =
                                                adharCardFilePathFront;
                                          } else {
                                            request.fields[
                                                    'student_adhaar_file'] =
                                                base64Encode(
                                                    File(adharCardFilePathFront)
                                                        .readAsBytesSync());
                                          }
                                        }
                                        if (adharCardFilePathBack.isNotEmpty) {
                                          if (kIsWeb) {
                                            request.fields[
                                                    'student_adhaar_file_back'] =
                                                adharCardFilePathBack;
                                          } else {
                                            request.fields[
                                                    'student_adhaar_file_back'] =
                                                base64Encode(
                                                    File(adharCardFilePathBack)
                                                        .readAsBytesSync());
                                          }
                                        }

                                        if (motherDeathCertificatePath
                                            .isNotEmpty) {
                                          if (kIsWeb) {
                                            request.fields[
                                                    'mother_death_certificate'] =
                                                motherDeathCertificatePath;
                                          } else {
                                            request.fields[
                                                    'mother_death_certificate'] =
                                                base64Encode(File(
                                                        motherDeathCertificatePath)
                                                    .readAsBytesSync());
                                          }
                                        }

                                        if (motherAdharCardFilePathFront
                                            .isNotEmpty) {
                                          if (kIsWeb) {
                                            request.fields[
                                                    'mother_adhaar_file'] =
                                                motherAdharCardFilePathFront;
                                          } else {
                                            request.fields[
                                                    'mother_adhaar_file'] =
                                                base64Encode(File(
                                                        motherAdharCardFilePathFront)
                                                    .readAsBytesSync());
                                          }
                                        }
                                        if (motherAdharCardFilePathBack
                                            .isNotEmpty) {
                                          if (kIsWeb) {
                                            request.fields[
                                                    'mother_adhaar_file_back'] =
                                                motherAdharCardFilePathBack;
                                          } else {
                                            request.fields[
                                                    'mother_adhaar_file_back'] =
                                                base64Encode(File(
                                                        motherAdharCardFilePathBack)
                                                    .readAsBytesSync());
                                          }
                                        }
                                        if (fatherDeathCertificatePath
                                            .isNotEmpty) {
                                          if (kIsWeb) {
                                            request.fields[
                                                    'father_death_certificate'] =
                                                fatherDeathCertificatePath;
                                          } else {
                                            request.fields[
                                                    'father_death_certificate'] =
                                                base64Encode(File(
                                                        fatherDeathCertificatePath)
                                                    .readAsBytesSync());
                                          }
                                        }
                                        if (fatherAdharCardFilePathFront
                                            .isNotEmpty) {
                                          if (kIsWeb) {
                                            request.fields[
                                                    'father_adhaar_file'] =
                                                fatherAdharCardFilePathFront;
                                          } else {
                                            request.fields[
                                                    'father_adhaar_file'] =
                                                base64Encode(File(
                                                        fatherAdharCardFilePathFront)
                                                    .readAsBytesSync());
                                          }
                                        }
                                        if (fatherAdharCardFilePathBack
                                            .isNotEmpty) {
                                          if (kIsWeb) {
                                            request.fields[
                                                    'father_adhaar_file_back'] =
                                                fatherAdharCardFilePathBack;
                                          } else {
                                            request.fields[
                                                    'father_adhaar_file_back'] =
                                                base64Encode(File(
                                                        fatherAdharCardFilePathBack)
                                                    .readAsBytesSync());
                                          }
                                        }

                                        print(request.fields);
                                        var response = await request.send();
                                        var respStr = await response.stream
                                            .bytesToString();
                                        print(respStr);
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        if (jsonDecode(respStr)['ErrorCode'] ==
                                            0) {
                                          Alert(
                                            context: context,
                                            title: "Saved",
                                            type: AlertType.success,
                                            buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "Next",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    studentRegistartionNumber =
                                                        jsonDecode(respStr)[
                                                                    'Response']
                                                                ['student_id']
                                                            .toString();
                                                    currentIndex = 1;
                                                    filledForm[0] = true;
                                                  });

                                                  _controller.animateTo(
                                                      (_controller.index + 1));
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                },
                                              )
                                            ],
                                          ).show();
                                          // Fluttertoast.showToast(
                                          //     msg:
                                          //         "Student Data Saved Successfully");
                                        } else {
                                          alertShow(
                                              "Failed",
                                              "Student Registration Failed Try Again.\n" +
                                                  jsonDecode(respStr)[
                                                          'ErrorMessage']
                                                      .toString());
                                        }
                                      }
                                    },
                                  )
                                ]))
                      ],
                    ),
                  )),
            ),
          ],
        ),
      );

  Widget studentBankDetails() => Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Form(
          key: formKey3,
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textLabels("Bank Name"),
                          textField(studentBankName),
                          SizedBox(
                            height: 8,
                          ),
                          textLabels("Bank Branch"),
                          textField(studentBankBranch),
                          SizedBox(
                            height: 8,
                          ),
                          textLabels("IFSC Code"),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Required Field";
                              else
                                return null;
                            },
                            onChanged: (val) {
                              if (val.length == 11) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                            controller: studentIfscCode,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
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
                          SizedBox(
                            height: 8,
                          ),
                          textLabels("Account Number"),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Required Field";
                              else
                                return null;
                            },
                            controller: studentAccountNumber,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD0D5DD))),
                                fillColor: Colors.white,
                                isDense: true,
                                filled: true),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  showPhotoCaptureOptions("SBDC", 0);
                                },
                                icon: Icon(Icons.upload_file),
                                label: Text("Upload Cancelled Cheque")),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          kIsWeb
                              ? studentBankDetailsCheckShowOnly.length != 0
                                  ? Card(
                                      child: ListTile(
                                        title: Text(
                                          "Cancelled_Check" +
                                              p.extension(
                                                  studentBankDetailsCheckShowOnly
                                                      .toString()),
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xff344054)),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 150,
                                            child: Image.network(
                                                studentBankDetailsCheckShowOnly),
                                          ),
                                        ),
                                        trailing: InkWell(
                                          onTap: () {
                                            setState(() {
                                              studentBankDetailsCheckShowOnly =
                                                  "";
                                            });
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    )
                                  : studentBankDetailsCheckPath.isNotEmpty
                                      ? Card(
                                          child: ListTile(
                                            title: Text(
                                              "Cancelled_Check" +
                                                  p.extension(
                                                      studentBankDetailsCheckPath
                                                          .toString()),
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: Color(0xff344054)),
                                            ),
                                            subtitle: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: 150,
                                                child: Image.memory(base64Decode(
                                                    studentBankDetailsCheckPath)),
                                              ),
                                            ),
                                            trailing: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  studentBankDetailsCheckPath =
                                                      "";
                                                });
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox()
                              //////
                              : studentBankDetailsCheckShowOnly.length != 0
                                  ? Card(
                                      child: ListTile(
                                        title: Text(
                                          "Cancelled_Check" +
                                              p.extension(
                                                  studentBankDetailsCheckShowOnly
                                                      .toString()),
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xff344054)),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 150,
                                            child: Image.network(
                                                studentBankDetailsCheckShowOnly),
                                          ),
                                        ),
                                        trailing: InkWell(
                                          onTap: () {
                                            setState(() {
                                              studentBankDetailsCheckShowOnly =
                                                  "";
                                            });
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    )
                                  : studentBankDetailsCheckPath.isNotEmpty
                                      ? Card(
                                          child: ListTile(
                                            title: Text(
                                              "Cancelled_Check" +
                                                  p.extension(
                                                      studentBankDetailsCheckPath
                                                          .toString()),
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: Color(0xff344054)),
                                            ),
                                            subtitle: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: 150,
                                                child: Image.file(File(
                                                    studentBankDetailsCheckPath)),
                                              ),
                                            ),
                                            trailing: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  studentBankDetailsCheckPath =
                                                      "";
                                                });
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                          SizedBox(
                            height: 20,
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
                                      child: filledForm[1]
                                          ? Text(
                                              "Update & Next",
                                              style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white),
                                            )
                                          : Text(
                                              "Save & Next",
                                              style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white),
                                            )),
                                )),
                            onTap: () async {
                              FocusScope.of(context).unfocus();

                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();

                              if (filledForm[0]) {
                                print(studentBankDetailsCheckPath.length);
                                if (studentBankDetailsCheckPath.length == 0 &&
                                    studentBankDetailsCheckShowOnly.length ==
                                        0) {
                                  alertShow("Cancelled Check", "Required");
                                } else if (studentIfscCode.text.length != 11) {
                                  alertShow("Inavlid IFSC",
                                      "The IFSC code cannot be more or less than 11 digits.");
                                } else if (formKey3.currentState!.validate() &&
                                    studentRegistartionNumber.isNotEmpty) {
                                  showLaoding(context);
                                  var request = http.MultipartRequest('POST',
                                      Uri.parse(URL + "student-bank-store"));
                                  request.headers.addAll({
                                    'Accept': 'application/json',
                                    // 'Authorization': 'Bearer ' + api_token.toString(),
                                  });

                                  request.fields['bank_name'] =
                                      studentBankName.text.toString();
                                  request.fields['bank_branch'] =
                                      studentBankBranch.text.toString();
                                  request.fields['ifsc_code'] =
                                      studentIfscCode.text.toString();
                                  request.fields['bank_ac'] =
                                      studentAccountNumber.text.toString();
                                  request.fields['user_id'] =
                                      pref.getString("id").toString();
                                  request.fields['type'] = "1";
                                  request.fields['student_id'] =
                                      studentRegistartionNumber.toString();

                                  if (studentBankDetailsCheckPath.isNotEmpty) {
                                    if (kIsWeb) {
                                      request.fields['student_bank_cheque'] =
                                          studentBankDetailsCheckPath;
                                    } else {
                                      request.fields['student_bank_cheque'] =
                                          base64Encode(
                                              File(studentBankDetailsCheckPath)
                                                  .readAsBytesSync());
                                    }
                                  }

                                  var response = await request.send();
                                  var respStr =
                                      await response.stream.bytesToString();

                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  if (jsonDecode(respStr)['ErrorCode'] == 0) {
                                    Alert(
                                      context: context,
                                      title: "Saved",
                                      type: AlertType.success,
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "Next",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              currentIndex = 2;
                                              filledForm[1] = true;
                                            });

                                            _controller.animateTo(
                                                (_controller.index + 1));
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                        )
                                      ],
                                    ).show();
                                  } else {
                                    alertShow("Failed",
                                        "Student Bank Registration Failed. Try Again.");
                                  }
                                }
                              } else {
                                alertShow("Forms Empty",
                                    "Please fill previous forms.");
                              }
                            },
                          )
                        ]))
              ]))));
  Widget studentSchoolDetails() => Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Form(
          key: formKey4,
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textLabels("School Name"),
                          textField(schoolName),
                          textLabels("School Teacher's Name"),
                          textField(schoolTeacherName),
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
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: schoolMobile,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12),
                                counterText: "",
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD0D5DD))),
                                fillColor: Colors.white,
                                isDense: true,
                                filled: true),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          textLabels("Email Address"),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Required Field";
                              else
                                return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            controller: schoolEmail,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD0D5DD))),
                                fillColor: Colors.white,
                                isDense: true,
                                filled: true),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          textLabels("School Address"),
                          textField(schoolAddress),
                          SizedBox(
                            height: 20,
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
                                      child: filledForm[2]
                                          ? Text(
                                              "Update & Next",
                                              style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white),
                                            )
                                          : Text(
                                              "Save & Next",
                                              style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white),
                                            )),
                                )),
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              if (filledForm[0] && filledForm[1]) {
                                if (formKey4.currentState!.validate() &&
                                    studentRegistartionNumber.isNotEmpty) {
                                  showLaoding(context);

                                  var response = await http.post(
                                      Uri.parse(URL + "student-school-store"),
                                      headers: {
                                        'Accept': 'application/json',
                                        'Content-Type': 'application/json',
                                        // 'Authorization': 'Bearer ' + api_token.toString(),
                                      },
                                      body: jsonEncode({
                                        'school_name':
                                            schoolName.text.toString(),
                                        'school_teacher':
                                            schoolTeacherName.text.toString(),
                                        'mobile': schoolMobile.text.toString(),
                                        'email': schoolEmail.text.toString(),
                                        'address':
                                            schoolAddress.text.toString(),
                                        'user_id':
                                            pref.getString("id").toString(),
                                        'type': "1",
                                        'student_id': studentRegistartionNumber
                                            .toString(),
                                        'school_id': schoolId.toString()
                                      }));

                                  print({
                                    'school_name': schoolName.text.toString(),
                                    'school_teacher':
                                        schoolTeacherName.text.toString(),
                                    'mobile': schoolMobile.text.toString(),
                                    'email': schoolEmail.text.toString(),
                                    'address': schoolAddress.text.toString(),
                                    'user_id': pref.getString("id").toString(),
                                    'type': "1",
                                    'student_id':
                                        studentRegistartionNumber.toString(),
                                    'school_id': schoolId.toString()
                                  });
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();

                                  if (jsonDecode(response.body)['ErrorCode'] ==
                                      0) {
                                    Alert(
                                      context: context,
                                      title: "Saved",
                                      type: AlertType.success,
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "Next",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              currentIndex = 3;
                                              schoolId =
                                                  jsonDecode(response.body)[
                                                              'Response']
                                                          ['school_id']
                                                      .toString();
                                              filledForm[2] = true;
                                            });

                                            _controller.animateTo(
                                                (_controller.index + 1));
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                        )
                                      ],
                                    ).show();
                                  } else {
                                    alertShow("Failed",
                                        "School Registration Failed. Try Again.");
                                  }
                                  // if (jsonDecode(response.body)['ErrorCode'] ==
                                  //     0) {
                                  //   Fluttertoast.showToast(
                                  //       msg: "School Data Saved Successfully");
                                  //   setState(() {
                                  //     currentIndex = 3;
                                  //     schoolId =
                                  //         jsonDecode(response.body)['Response']
                                  //                 ['school_id']
                                  //             .toString();
                                  //     filledForm[2] = true;
                                  //   });

                                  //   _controller
                                  //       .animateTo((_controller.index + 1));
                                  // } else {
                                  //   Fluttertoast.showToast(
                                  //       msg:
                                  //           "School Registration Failed Try Again.");
                                  // }
                                }
                              } else {
                                alertShow("Forms Empty",
                                    "Please fill previous forms.");
                              }
                            },
                          )
                        ]))
              ]))));
  Widget studentSchoolBankDetails() => Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Form(
          key: formKey5,
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textLabels("School Bank Name"),
                          textField(schoolBankName),
                          SizedBox(
                            height: 8,
                          ),
                          textLabels("School Bank Branch"),
                          textField(schoolBankBranch),
                          SizedBox(
                            height: 8,
                          ),
                          textLabels("School IFSC Code"),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Required Field";
                              else
                                return null;
                            },
                            onChanged: (val) {
                              if (val.length == 11) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                            controller: schoolIfscCode,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
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
                          SizedBox(
                            height: 8,
                          ),
                          textLabels("School Account Number"),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Required Field";
                              else
                                return null;
                            },
                            controller: schoolAccountNumber,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD0D5DD))),
                                fillColor: Colors.white,
                                isDense: true,
                                filled: true),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  showPhotoCaptureOptions("ScBDC", 0);
                                },
                                icon: Icon(Icons.upload_file),
                                label: Text("Upload School Cheque Copy")),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          kIsWeb
                              ? schoolBankDetailsCheckShowOnly.length != 0
                                  ? Card(
                                      child: ListTile(
                                        title: Text(
                                          "Cancelled_Check" +
                                              p.extension(
                                                  schoolBankDetailsCheckShowOnly
                                                      .toString()),
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xff344054)),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 150,
                                            child: Image.network(
                                                schoolBankDetailsCheckShowOnly),
                                          ),
                                        ),
                                        trailing: InkWell(
                                          onTap: () {
                                            setState(() {
                                              schoolBankDetailsCheckShowOnly =
                                                  "";
                                            });
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    )
                                  : schoolBankDetailsCheckPath.isNotEmpty
                                      ? Card(
                                          child: ListTile(
                                            title: Text(
                                              "Cancelled_Check" +
                                                  p.extension(
                                                      schoolBankDetailsCheckPath
                                                          .toString()),
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: Color(0xff344054)),
                                            ),
                                            subtitle: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: 150,
                                                child: Image.memory(base64Decode(
                                                    schoolBankDetailsCheckPath)),
                                              ),
                                            ),
                                            trailing: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  schoolBankDetailsCheckPath =
                                                      "";
                                                });
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox()
                              : schoolBankDetailsCheckShowOnly.length != 0
                                  ? Card(
                                      child: ListTile(
                                        title: Text(
                                          "Cancelled_Check" +
                                              p.extension(
                                                  schoolBankDetailsCheckShowOnly
                                                      .toString()),
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xff344054)),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 150,
                                            child: Image.network(
                                                schoolBankDetailsCheckShowOnly),
                                          ),
                                        ),
                                        trailing: InkWell(
                                          onTap: () {
                                            setState(() {
                                              schoolBankDetailsCheckShowOnly =
                                                  "";
                                            });
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    )
                                  : schoolBankDetailsCheckPath.isNotEmpty
                                      ? Card(
                                          child: ListTile(
                                            title: Text(
                                              "Cancelled_Check" +
                                                  p.extension(
                                                      schoolBankDetailsCheckPath
                                                          .toString()),
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: Color(0xff344054)),
                                            ),
                                            subtitle: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: 150,
                                                child: Image.file(File(
                                                    schoolBankDetailsCheckPath)),
                                              ),
                                            ),
                                            trailing: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  schoolBankDetailsCheckPath =
                                                      "";
                                                });
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                          SizedBox(
                            height: 20,
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
                                        child: filledForm[3]
                                            ? Text(
                                                "Update & Next",
                                                style: GoogleFonts.lato(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                "Save & Next",
                                                style: GoogleFonts.lato(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white),
                                              )),
                                  )),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                if (filledForm[0] &&
                                    filledForm[1] &&
                                    filledForm[2]) {
                                  if (schoolBankDetailsCheckPath.length == 0 &&
                                      schoolBankDetailsCheckShowOnly.length ==
                                          0) {
                                    alertShow("Cheque Copy", "Required");
                                  } else if (schoolIfscCode.text.length != 11) {
                                    alertShow("Inavlid IFSC",
                                        "The IFSC code cannot be more or less than 11 digits.");
                                  } else if (formKey5.currentState!
                                      .validate()) {
                                    showLaoding(context);

                                    var request = http.MultipartRequest('POST',
                                        Uri.parse(URL + "school-bank-store"));
                                    request.headers.addAll({
                                      'Accept': 'application/json',
                                      // 'Authorization': 'Bearer ' + api_token.toString(),
                                    });

                                    request.fields['bank_name'] =
                                        schoolBankName.text.toString();
                                    request.fields['bank_branch'] =
                                        schoolBankBranch.text.toString();
                                    request.fields['ifsc_code'] =
                                        schoolIfscCode.text.toString();
                                    request.fields['bank_ac'] =
                                        schoolAccountNumber.text.toString();
                                    request.fields['user_id'] =
                                        pref.getString("id").toString();
                                    request.fields['type'] = "1";
                                    request.fields['student_id'] =
                                        studentRegistartionNumber.toString();
                                    request.fields['school_id'] =
                                        schoolId.toString();

                                    if (schoolBankDetailsCheckPath.isNotEmpty) {
                                      if (kIsWeb) {
                                        request.fields['school_fee_secular'] =
                                            schoolBankDetailsCheckPath;
                                      } else {
                                        request.fields['school_fee_secular'] =
                                            base64Encode(
                                                File(schoolBankDetailsCheckPath)
                                                    .readAsBytesSync());
                                      }
                                    }

                                    var response = await request.send();
                                    var respStr =
                                        await response.stream.bytesToString();
                                    print(jsonEncode(request.fields));
                                    print(respStr);
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    if (jsonDecode(respStr)['ErrorCode'] == 0) {
                                      Alert(
                                        context: context,
                                        title: "Saved",
                                        type: AlertType.success,
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "Next",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                currentIndex = 4;
                                                filledForm[3] = true;
                                              });

                                              _controller.animateTo(
                                                  (_controller.index + 1));
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                          )
                                        ],
                                      ).show();
                                    } else {
                                      alertShow("Failed",
                                          "School Bank Registration Failed. Try Again.");
                                    }
                                  }
                                } else {
                                  alertShow("Forms Empty",
                                      "Please fill previous forms.");
                                }
                              })
                        ]))
              ]))));
  // String tempFilePath = "";
  // String schoolReceiptShowOnly = "";
  List school_fee_recipt_list = [
    {"image": "assets/upload_image.png"}
  ];
  Widget studentSchoolFeeDetails() => Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Form(
          key: formKey6,
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GridView.count(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1.1,
                            children: school_fee_recipt_list.reversed.map((e) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.teal[50],
                                  ),
                                  child: e['image'] == "assets/upload_image.png"
                                      ? InkWell(
                                          onTap: () {
                                            // if (school_fee_recipt_list.length <=
                                            //     5) {
                                            FocusScope.of(context).unfocus();
                                            showPhotoCaptureOptions(
                                                "SRecipt", 0);
                                            // } else {
                                            //   Fluttertoast.showToast(
                                            //       msg:
                                            //           "Can't upload more than 5 uploads.",
                                            //       gravity: ToastGravity.CENTER);
                                            // }
                                          },
                                          child: Image.asset(
                                            e['image'],
                                            scale: 15,
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            if (e['new']) {
                                              setState(() {
                                                school_fee_recipt_list.removeAt(
                                                    school_fee_recipt_list
                                                        .indexOf(e));
                                              });
                                            } else {
                                              FocusScope.of(context).unfocus();
                                              showPhotoCaptureOptions(
                                                  "SReciptUpdate",
                                                  school_fee_recipt_list
                                                      .indexOf(e));
                                            }
                                          },
                                          child: kIsWeb
                                              ? Stack(
                                                  alignment: Alignment(0, 0),
                                                  children: [
                                                      showReceiptAlready
                                                          ? e['image']
                                                                  .toString()
                                                                  .contains(
                                                                      "https")
                                                              ? Image.network(
                                                                  e['image']
                                                                      .toString(),
                                                                  scale: 1,
                                                                )
                                                              : Image.memory(
                                                                  base64Decode(e[
                                                                          'image']
                                                                      .toString()),
                                                                  scale: 1,
                                                                )
                                                          : Image.memory(
                                                              base64Decode(e[
                                                                      'image']
                                                                  .toString()),
                                                              scale: 1,
                                                            ),
                                                      Align(
                                                          alignment: Alignment(
                                                              1.4, -1.4),
                                                          child: !e['new']
                                                              ? Icon(Icons
                                                                  .change_circle)
                                                              : Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .circle,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .clear,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 15,
                                                                    ),
                                                                  ],
                                                                ))
                                                    ])
                                              : Stack(
                                                  alignment: Alignment(0, 0),
                                                  children: [
                                                      showReceiptAlready
                                                          ? e['image']
                                                                  .toString()
                                                                  .contains(
                                                                      "https")
                                                              ? Image.network(
                                                                  e['image']
                                                                      .toString(),
                                                                  scale: 1,
                                                                )
                                                              : Image.file(
                                                                  File(e['image']
                                                                      .toString()),
                                                                  scale: 1,
                                                                )
                                                          : Image.file(
                                                              File(e['image']
                                                                  .toString()),
                                                              scale: 1,
                                                            ),
                                                      Align(
                                                          alignment: Alignment(
                                                              1.4, -1.4),
                                                          child: !e['new']
                                                              ? Icon(Icons
                                                                  .change_circle)
                                                              : Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .circle,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .clear,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 15,
                                                                    ),
                                                                  ],
                                                                ))
                                                    ]),
                                        ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          textLabels("Select Expense Type"),
                          FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: selectedExpenseValue,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedExpenseValue =
                                            int.parse(newValue.toString());
                                      });
                                    },
                                    items: expenseMaster.map((value) {
                                      return DropdownMenuItem(
                                        enabled: value['enabled'],
                                        value: int.parse(expenseMaster
                                            .indexOf(value)
                                            .toString()),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              value['expense_name']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: value['enabled']
                                                      ? Colors.black
                                                      : Colors.grey),
                                            ),
                                            value['expense_type'] == null
                                                ? SizedBox()
                                                : Text(
                                                    value["expense_type"] ==
                                                            "annualy"
                                                        ? "Annually"
                                                        : "Monthly",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        color: !value['enabled']
                                                            ? Colors.grey
                                                            : value['expense_type'] ==
                                                                    "monthly"
                                                                ? Colors.green
                                                                : Colors.blue),
                                                  )
                                          ],
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // textLabels("Payment Mode (Required)"),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // RadioGroup<String>.builder(
                              //   direction: Axis.horizontal,
                              //   groupValue: _verticalGroupValue,
                              //   onChanged: (value) => setState(() {
                              //     Fluttertoast.showToast(
                              //         msg: "Select Expense Type");
                              //     // _verticalGroupValue = value!;
                              //     // setState(() {
                              //     //   expenseMaster[selectedExpenseValue]
                              //     //           ['expense_payment'] =
                              //     //       _verticalGroupValue.toLowerCase();
                              //     // });
                              //   }),
                              //   textStyle: TextStyle(fontSize: 20),
                              //   items: expenseType,
                              //   itemBuilder: (item) => RadioButtonBuilder(
                              //     item,
                              //   ),
                              //   activeColor: Colors.red,
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              textLabels("Expense Amount\n(Required)"),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return "Required Field";
                                  else
                                    return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    expenseMaster[selectedExpenseValue]
                                        ['amount'] = "";
                                    expenseMaster[selectedExpenseValue]
                                        ['amount'] = val.toString();
                                  });
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: expenseAmount,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: TextButton(
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          if (expenseMaster[
                                                      selectedExpenseValue]
                                                  ['expense_name'] ==
                                              "Select") {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please select expense type");
                                          } else {
                                            if (expenseAmount.text.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please fill required fields");
                                            } else {
                                              setState(() {
                                                expenseMaster[
                                                        selectedExpenseValue]
                                                    ['enabled'] = false;
                                                expenseMaster[
                                                            selectedExpenseValue]
                                                        ['amount'] =
                                                    expenseAmount.text
                                                        .toString();
                                                expenseAmount.text = "";
                                                selectedExpenseValue = 0;
                                              });
                                            }
                                          }
                                          print(expenseMaster);
                                        },
                                        child: Text("ADD",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500)),
                                        style: ButtonStyle(
                                            // shape: MaterialStateProperty.all(
                                            //     RoundedRectangleBorder(
                                            //   borderRadius:
                                            //       BorderRadius.circular(18.0),
                                            // )),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.blue)),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(12),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffD0D5DD))),
                                    fillColor: Colors.white,
                                    isDense: true,
                                    filled: true),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Divider(
                                thickness: 1,
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Column(
                                    children: expenseMaster.map((e) {
                                      if (e['enabled'] == false) {
                                        return Card(
                                          elevation: 10,
                                          child: ListTile(
                                            title: Text(
                                              e['expense_name'].toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                                e["expense_type"] == "annualy"
                                                    ? "Annually" +
                                                        " / ₹ " +
                                                        e['amount']
                                                    : "Monthly" +
                                                        " / ₹ " +
                                                        e['amount'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    e['enabled'] = true;
                                                    e["amount"] = "";
                                                  });
                                                },
                                                icon: Icon(Icons.clear)),
                                          ),
                                        );
                                      }
                                      return SizedBox();
                                    }).toList(),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      if (filledForm[0] &&
                                          filledForm[1] &&
                                          filledForm[2] &&
                                          filledForm[3]) {
                                        bool havdata = false;
                                        for (var element in expenseMaster) {
                                          if (element['enabled'] == false) {
                                            havdata = true;
                                            break;
                                          }
                                        }
                                        if (school_fee_recipt_list.length < 2) {
                                          alertShow("Bill Receipt",
                                              "Atleast one receipt required");
                                        } else if (!havdata) {
                                          alertShow("Expense List Empty",
                                              "Please add atleast one expense");
                                        } else {
                                          showLaoding(context);
                                          SharedPreferences pref =
                                              await SharedPreferences
                                                  .getInstance();

                                          List finalExpenseMaster = [];
                                          for (var element in expenseMaster) {
                                            if (element['enabled'] == false) {
                                              finalExpenseMaster.add(element);
                                            }
                                          }
                                          double grand_total = 0;
                                          List tempExpenseNameL = [];
                                          List tempExpenseTypeL = [];
                                          List tempExpenseFeeL = [];
                                          for (var i = 0;
                                              i < finalExpenseMaster.length;
                                              i++) {
                                            tempExpenseNameL.add(
                                                finalExpenseMaster[i]['id']
                                                    .toString());
                                            tempExpenseTypeL.add(
                                                finalExpenseMaster[i]
                                                    ['expense_type']);
                                            tempExpenseFeeL.add(
                                                finalExpenseMaster[i]
                                                    ['amount']);
                                            grand_total = grand_total +
                                                double.parse(
                                                    finalExpenseMaster[i]
                                                        ['amount']);
                                          }

                                          List sentReceipt = [];
                                          for (var i = 0;
                                              i < school_fee_recipt_list.length;
                                              i++) {
                                            if (i != 0) {
                                              if (kIsWeb) {
                                                sentReceipt.add({
                                                  "id": school_fee_recipt_list[
                                                              i]['id'] ==
                                                          null
                                                      ? ""
                                                      : school_fee_recipt_list[
                                                          i]['id'],
                                                  "update":
                                                      school_fee_recipt_list[i]
                                                              ['new']
                                                          .toString(),
                                                  "image":
                                                      school_fee_recipt_list[i]
                                                          ['image'],
                                                });
                                              } else {
                                                sentReceipt.add({
                                                  "id": school_fee_recipt_list[
                                                              i]['id'] ==
                                                          null
                                                      ? ""
                                                      : school_fee_recipt_list[
                                                          i]['id'],
                                                  "update":
                                                      school_fee_recipt_list[i]
                                                              ['new']
                                                          .toString(),
                                                  "image": school_fee_recipt_list[
                                                              i]['new'] ==
                                                          true
                                                      ? base64Encode(File(
                                                              school_fee_recipt_list[
                                                                          i]
                                                                      ['image']
                                                                  .toString())
                                                          .readAsBytesSync())
                                                      : school_fee_recipt_list[
                                                              i]['image']
                                                          .toString(),
                                                });
                                              }
                                            }
                                          }

                                          Map map = {
                                            "user_id":
                                                pref.getString("id").toString(),
                                            "school_id": schoolId.toString(),
                                            "grand_total":
                                                grand_total.toString(),
                                            "student_id":
                                                studentRegistartionNumber
                                                    .toString(),
                                            "expense_name": tempExpenseNameL
                                                .join(",")
                                                .toString(),
                                            "expense_type": tempExpenseTypeL
                                                .join(",")
                                                .toString(),
                                            "expense_fee": tempExpenseFeeL
                                                .join(",")
                                                .toString(),
                                            "receiptMulti": sentReceipt,
                                          };
                                          print(jsonEncode({
                                            "user_id":
                                                pref.getString("id").toString(),
                                            "school_id": schoolId.toString(),
                                            "grand_total":
                                                grand_total.toString(),
                                            "student_id":
                                                studentRegistartionNumber
                                                    .toString(),
                                            "expense_name": tempExpenseNameL
                                                .join(",")
                                                .toString(),
                                            "expense_type": tempExpenseTypeL
                                                .join(",")
                                                .toString(),
                                            "expense_fee": tempExpenseFeeL
                                                .join(",")
                                                .toString(),
                                          }));
                                          var response = await http.post(
                                              Uri.parse(
                                                  URL + "school-fee-store"),
                                              headers: {
                                                'Accept': 'application/json',
                                                'Content-Type':
                                                    'application/json',
                                              },
                                              body: jsonEncode(map));

                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          print(response.body);
                                          if (jsonDecode(
                                                  response.body)['ErrorCode'] ==
                                              0) {
                                            if (widget.id.toString().length ==
                                                0) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RegistrationSuceess(
                                                            id: studentRegistartionNumber
                                                                .toString(),
                                                            name: studentName
                                                                .text
                                                                .toString(),
                                                          ))).then((value) =>
                                                  Navigator.of(context).pop());
                                            } else {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              Fluttertoast.showToast(
                                                  msg: "User Profile Updated");
                                            }
                                          } else {
                                            alertShow("Failed",
                                                "User Profile Updateded Failed. Try Again.");
                                          }
                                        }
                                      } else {
                                        alertShow("Forms Empty",
                                            "Please fill previous forms.");
                                      }
                                    },
                                    child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: filledForm[4]
                                                  ? Text(
                                                      "Update & Submit",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color: Colors.white),
                                                    )
                                                  : Text(
                                                      "Final Submit",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color: Colors.white),
                                                    )),
                                        )),
                                  )
                                ],
                              )
                            ],
                          ),
                        ]))
              ]))));
  int currentIndex = 0;

  String convertNull(value) {
    return value == null ? "" : value.toString();
  }

  List preFilledReceipts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataMaster();
    print(widget.id.toString());
    if (widget.id.toString().isNotEmpty) {
      setState(() {
        currentIndex = widget.index;
      });

      StudentRegistrationAPI()
          .getStudentFilledDetails(widget.id.toString())
          .then((value) async {
        setState(() {
          studentRegistartionNumber = widget.id.toString();
          if (studentRegistartionNumber.length != 0) {
            filledForm[0] = true;
          }
          studentShowProfileOnly = value['student_pic'].toString();
          studentName.text = value['name'].toString();
          selectedGenderValue = value['gender'].toString();
          dob.text = value['dob'].toString();
          selectedSessionValue = value['session'].toString();
          selectedStandardValue = value['student_class'].toString();
          mobileNumber.text = value['phone'].toString();
          address.text = value['address'].toString();
          adharCardNumber.text = value['student_adhaar'].toString();
          studentShowAdhareOnlyFront = value['student_adhaar_file'].toString();
          studentShowAdhareOnlyBack =
              value['student_adhaar_file_back'].toString();
          fatherAliveValue = value['is_father_alive'] == "yes" ? "yes" : "no";
          if (fatherAliveValue == "no") {
            print("not alive");
            fatherShowDeathOnly = value['father_death_certificate'].toString();
          }
          fatherName.text = convertNull(value['father_name'].toString());
          fatheMobile.text = convertNull(value['father_mobile']);
          fatherAdharCardNumber.text = value['father_adhaar'].toString();

          fatherShowAdharOnlyFront = value['father_adhaar_file'].toString();
          fatherShowAdharOnlyBack = value['father_adhaar_file_back'].toString();
          fatherOccupation.text = convertNull(value['father_occupation']);
          fatherIncome.text = convertNull(value['father_monthly_income']);

          motherAliveValue = value['is_mother_alive'] == "yes" ? "yes" : "no";

          if (motherAliveValue == "no") {
            motherShowDeathOnly = value['mother_death_certificate'].toString();
          }
          motherName.text = value['mother_name'].toString();
          motherMobile.text = convertNull(value['mother_mobile']);
          motherAdharCardNumber.text = value['mother_adhaar'].toString();
          motherShowAdharOnlyFront = value['mother_adhaar_file'].toString();
          motherShowAdharOnlyBack = value['mother_adhaar_file_back'].toString();
          motherOccupationListValue = convertNull(value['mother_occupation']);
          motherIncome.text = convertNull(value['mother_monthly_income']);

          studentBankName.text = convertNull(value['bank_name']);
          if (studentBankName.text.toString().length != 0 &&
              studentBankName.text.toString() != "null") {
            filledForm[1] = true;
          }
          studentBankBranch.text = convertNull(value['bank_branch']);
          studentIfscCode.text = convertNull(value['bank_ifsc_code']);
          studentAccountNumber.text = convertNull(value['bank_ac_number']);
          studentBankDetailsCheckShowOnly =
              value['student_bank_cheque'].toString().contains("bank")
                  ? value['student_bank_cheque'].toString()
                  : "";

          schoolId = value["school_detail"]["school_id"].toString();
          print(schoolId);
          if (schoolId != "null") {
            filledForm[2] = true;
          }
          schoolName.text = convertNull(value["school_detail"]["school_name"]);
          schoolTeacherName.text =
              convertNull(value["school_detail"]["school_teacher_name"]);
          schoolMobile.text =
              convertNull(value["school_detail"]["teacher_mobile"]);
          schoolEmail.text =
              convertNull(value["school_detail"]["teacher_email"]);
          schoolAddress.text =
              convertNull(value["school_detail"]["school_address"]);

          schoolBankName.text =
              convertNull(value["school_detail"]["bank_name"]);
          if (schoolBankName.text.toString().length != 0) {
            filledForm[3] = true;
          }
          schoolBankBranch.text =
              convertNull(value["school_detail"]["bank_branch"]);
          schoolIfscCode.text =
              convertNull(value["school_detail"]["bank_ifsc_code"]);
          schoolAccountNumber.text =
              convertNull(value["school_detail"]["bank_ac_number"]);
          schoolBankDetailsCheckShowOnly = value["school_detail"]
                      ["school_fee_secular"]
                  .toString()
                  .contains("fee")
              ? value["school_detail"]["school_fee_secular"].toString()
              : "";

          List temp = value["school_fee"];
          if (temp.length > 0) {
            filledForm[4] = true;
            preFilledReceipts.clear();
            preFilledReceipts.addAll(value["school_fee"]);
            // schoolReceiptShowOnly =
            //     value["school_fee_total"]["receipt"].toString();
          }

          List fee_receipt_multiple = value['fee_receipt_multiple'];
          if (fee_receipt_multiple.length > 0) {
            setState(() {
              showReceiptAlready = true;
            });
            fee_receipt_multiple.forEach((element) {
              setState(() {
                school_fee_recipt_list.add({
                  "image": element['receipt'].toString(),
                  "new": false,
                  "id": element['id'].toString()
                });
              });
            });
          }
        });
      });
      print(filledForm);
    }

    _controller = TabController(
        length: formTabs.length, vsync: this, initialIndex: currentIndex);
    _controller.addListener(onTap);
  }

  onTap() {
    setState(() {
      currentIndex = _controller.index;
    });

    print("Selected Index: " + _controller.index.toString());
  }

  bool showReceiptAlready = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: formTabs.length,
      initialIndex: currentIndex,
      child: WillPopScope(
        onWillPop: () async {
          return (await Alert(
                context: context,
                title: "All data will be lost.",
                content: Text("Do you want to continue."),
                type: AlertType.warning,
                buttons: [
                  DialogButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      }),
                  DialogButton(
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.of(context).pop();
                      })
                ],
              ).show()) ??
              false;
        },
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Student Registration",
                style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff4A4B57)),
              ),
              leading: IconButton(
                  onPressed: () {
                    Alert(
                      context: context,
                      title: "All data will be lost.",
                      content: Text("Do you want to continue."),
                      type: AlertType.warning,
                      buttons: [
                        DialogButton(
                            child: Text(
                              "Cancel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            }),
                        DialogButton(
                            child: Text(
                              "OK",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.of(context).pop();
                            })
                      ],
                    ).show();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
              backgroundColor: Colors.transparent,
              bottom: TabBar(
                physics: NeverScrollableScrollPhysics(),
                isScrollable: true,
                controller: _controller,
                labelColor: Colors.black,
                // onTap: (value) {
                //   switch (value) {
                //     case 1:
                //       if (filledForm[0]) {
                //         setState(() {
                //           _controller.index = 0;
                //         });
                //         Fluttertoast.showToast(
                //             msg: "Please fill Student Details");
                //       } else {
                //         setState(() {
                //           _controller.index = value;
                //         });
                //       }
                //       break;

                //     // case 2:
                //     //   if (filledForm[1]) {
                //     //     setState(() {
                //     //       _controller.index = 1;
                //     //     });
                //     //     Fluttertoast.showToast(
                //     //         msg: "Please fill Guardian Details");
                //     //   } else {
                //     //     setState(() {
                //     //       _controller.index = value;
                //     //     });
                //     //   }
                //     //   break;
                //     case 2:
                //       if (filledForm[1]) {
                //         setState(() {
                //           _controller.index = 1;
                //         });
                //         Fluttertoast.showToast(
                //             msg: "Please fill Student Bank Details");
                //       } else {
                //         setState(() {
                //           _controller.index = value;
                //         });
                //       }
                //       break;
                //     case 3:
                //       if (filledForm[2]) {
                //         setState(() {
                //           _controller.index = 2;
                //         });
                //         Fluttertoast.showToast(
                //             msg: "Please fill Student School Details");
                //       } else {
                //         setState(() {
                //           _controller.index = value;
                //         });
                //       }
                //       break;
                //     case 4:
                //       if (filledForm[3]) {
                //         setState(() {
                //           _controller.index = 3;
                //         });
                //         Fluttertoast.showToast(
                //             msg: "Please fill School Bank Details");
                //       } else {
                //         setState(() {
                //           _controller.index = value;
                //         });
                //       }
                //       break;
                //     case 5:
                //       if (filledForm[4]) {
                //         setState(() {
                //           _controller.index = 4;
                //         });
                //         Fluttertoast.showToast(
                //             msg: "Please fill School Fee Details");
                //       } else {
                //         setState(() {
                //           _controller.index = value;
                //         });
                //       }
                //       break;
                //   }
                // },
                tabs: formTabs.map((e) => Tab(text: e)).toList(),
              ),
            ),
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/sr_bg.png"),
                            fit: BoxFit.fill)),
                    child: TabBarView(controller: _controller,
                        // physics: NeverScrollableScrollPhysics(),
                        children: [
                          studentRegistartion(),
                          // guardianRegistration(),
                          studentBankDetails(),
                          studentSchoolDetails(),
                          studentSchoolBankDetails(),
                          studentSchoolFeeDetails()
                        ]))),
      ),
    );
  }

  Future<void> showPhotoCaptureOptions(
      String selectionFor, int replaceIndex) async {
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
                                        studentShowProfileOnly = "";
                                      });
                                      break;
                                    case "SACF":
                                      setState(() {
                                        adharCardFilePathFront =
                                            result.path.toString();
                                        studentShowAdhareOnlyFront = "";
                                      });
                                      break;
                                    case "SACB":
                                      setState(() {
                                        adharCardFilePathBack =
                                            result.path.toString();
                                        studentShowAdhareOnlyBack = "";
                                      });
                                      break;

                                    case "FACF":
                                      setState(() {
                                        fatherAdharCardFilePathFront =
                                            result.path.toString();
                                        fatherShowAdharOnlyFront = "";
                                      });
                                      break;
                                    case "FACB":
                                      setState(() {
                                        fatherAdharCardFilePathBack =
                                            result.path.toString();
                                        fatherShowAdharOnlyBack = "";
                                      });
                                      break;
                                    case "FDC":
                                      setState(() {
                                        fatherDeathCertificatePath =
                                            result.path.toString();
                                        fatherShowDeathOnly = "";
                                      });
                                      break;
                                    case "MACF":
                                      setState(() {
                                        motherAdharCardFilePathFront =
                                            result.path.toString();
                                        motherShowAdharOnlyFront = "";
                                      });
                                      break;
                                    case "MACB":
                                      setState(() {
                                        motherAdharCardFilePathBack =
                                            result.path.toString();
                                        motherShowAdharOnlyBack = "";
                                      });
                                      break;
                                    case "MDC":
                                      setState(() {
                                        motherDeathCertificatePath =
                                            result.path.toString();
                                        motherShowDeathOnly = "";
                                      });
                                      break;
                                    case "SBDC":
                                      setState(() {
                                        studentBankDetailsCheckPath =
                                            result.path.toString();
                                        studentBankDetailsCheckShowOnly = "";
                                      });
                                      break;
                                    case "ScBDC":
                                      setState(() {
                                        schoolBankDetailsCheckPath =
                                            result.path.toString();
                                        schoolBankDetailsCheckShowOnly = "";
                                      });
                                      break;
                                    case "SRecipt":
                                      setState(() {
                                        school_fee_recipt_list.add({
                                          "image": result.path.toString(),
                                          "new": true,
                                        });
                                      });
                                      break;
                                    case "SReciptUpdate":
                                      setState(() {
                                        school_fee_recipt_list[replaceIndex]
                                            ['image'] = result.path.toString();
                                        school_fee_recipt_list[replaceIndex]
                                            ['new'] = true;
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
                                  case "SACF":
                                    setState(() {
                                      adharCardFilePathFront = base64Encode(f!);
                                    });
                                    break;
                                  case "SACB":
                                    setState(() {
                                      adharCardFilePathBack = base64Encode(f!);
                                    });
                                    break;
                                  case "FACF":
                                    setState(() {
                                      fatherAdharCardFilePathFront =
                                          base64Encode(f!);
                                    });
                                    break;
                                  case "FACB":
                                    setState(() {
                                      fatherAdharCardFilePathBack =
                                          base64Encode(f!);
                                    });
                                    break;

                                  case "FDC":
                                    setState(() {
                                      fatherDeathCertificatePath =
                                          base64Encode(f!);
                                    });
                                    break;
                                  case "MACF":
                                    setState(() {
                                      motherAdharCardFilePathFront =
                                          base64Encode(f!);
                                    });
                                    break;
                                  case "MACB":
                                    setState(() {
                                      motherAdharCardFilePathBack =
                                          base64Encode(f!);
                                    });
                                    break;
                                  case "MDC":
                                    setState(() {
                                      motherDeathCertificatePath =
                                          base64Encode(f!);
                                    });
                                    break;
                                  case "SBDC":
                                    setState(() {
                                      studentBankDetailsCheckPath =
                                          base64Encode(f!);
                                    });
                                    break;
                                  case "ScBDC":
                                    setState(() {
                                      schoolBankDetailsCheckPath =
                                          base64Encode(f!);
                                    });
                                    break;
                                  case "SRecipt":
                                    setState(() {
                                      school_fee_recipt_list.add({
                                        "image": base64Encode(f!),
                                        "new": true
                                      });
                                    });
                                    break;
                                  case "SReciptUpdate":
                                    setState(() {
                                      school_fee_recipt_list[replaceIndex]
                                          ['image'] = base64Encode(f!);
                                      school_fee_recipt_list[replaceIndex]
                                          ['new'] = true;
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
                                      studentShowProfileOnly = "";
                                    });
                                    break;
                                  case "SACF":
                                    setState(() {
                                      adharCardFilePathFront =
                                          result.path.toString();
                                      studentShowAdhareOnlyFront = "";
                                    });
                                    break;
                                  case "SACB":
                                    setState(() {
                                      adharCardFilePathBack =
                                          result.path.toString();
                                      studentShowAdhareOnlyBack = "";
                                    });
                                    break;
                                  case "FACF":
                                    setState(() {
                                      fatherAdharCardFilePathFront =
                                          result.path.toString();
                                      fatherShowAdharOnlyFront = "";
                                    });
                                    break;
                                  case "FACB":
                                    setState(() {
                                      fatherAdharCardFilePathBack =
                                          result.path.toString();
                                      fatherShowAdharOnlyBack = "";
                                    });
                                    break;
                                  case "FDC":
                                    setState(() {
                                      fatherDeathCertificatePath =
                                          result.path.toString();
                                      fatherShowDeathOnly = "";
                                    });
                                    break;
                                  case "MACF":
                                    setState(() {
                                      motherAdharCardFilePathFront =
                                          result.path.toString();
                                      motherShowAdharOnlyFront = "";
                                    });
                                    break;
                                  case "MACB":
                                    setState(() {
                                      motherAdharCardFilePathBack =
                                          result.path.toString();
                                      motherShowAdharOnlyBack = "";
                                    });
                                    break;
                                  case "MDC":
                                    setState(() {
                                      motherDeathCertificatePath =
                                          result.path.toString();
                                      motherShowDeathOnly = "";
                                    });
                                    break;
                                  case "SBDC":
                                    setState(() {
                                      studentBankDetailsCheckPath =
                                          result.path.toString();
                                      studentBankDetailsCheckShowOnly = "";
                                    });
                                    break;
                                  case "ScBDC":
                                    setState(() {
                                      schoolBankDetailsCheckPath =
                                          result.path.toString();
                                      schoolBankDetailsCheckShowOnly = "";
                                    });
                                    break;
                                  case "SRecipt":
                                    setState(() {
                                      school_fee_recipt_list.add({
                                        "image": result.path.toString(),
                                        "new": true
                                      });
                                    });
                                    break;
                                  case "SReciptUpdate":
                                    setState(() {
                                      school_fee_recipt_list[replaceIndex]
                                          ['image'] = result.path.toString();
                                      school_fee_recipt_list[replaceIndex]
                                          ['new'] = true;
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
}
