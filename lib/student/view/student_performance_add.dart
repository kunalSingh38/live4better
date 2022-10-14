import 'dart:convert';
import 'dart:io';

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
import 'package:path/path.dart' as p;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentPerformanceAdd extends StatefulWidget {
  String pageName = "";
  String studentId = "";
  String studentName = "";
  bool update = false;
  Map data = {};
  List enteredQuatar = [];
  StudentPerformanceAdd(
      {required this.pageName,
      required this.studentId,
      required this.studentName,
      required this.update,
      required this.data,
      required this.enteredQuatar});
  @override
  _StudentPerformanceAddState createState() => _StudentPerformanceAddState();
}

class _StudentPerformanceAddState extends State<StudentPerformanceAdd> {
  String quarterValue = "1";
  String session = "";
  String studentClass = "";
  TextEditingController attendanceValue = TextEditingController();
  TextEditingController marksValue = TextEditingController();
  TextEditingController remarkValue = TextEditingController();
  String resultValue = "pass";
  String marksheetFilePath = "";
  String marksheetFilePathShowOnly = "";
  String _verticalGroupValue = "Pass";
  String performanceId = "";
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
            // validator: (value) {
            //   if (value!.isEmpty)
            //     return "Required Field";
            //   else
            //     return null;
            // },
            maxLines: 3,
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

  GlobalKey<FormState> form = GlobalKey();
  List quatarMaster = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StudentRegistrationAPI().getStudentQuatar().then((value) {
      setState(() {
        quatarMaster.clear();
        value.forEach((element) {
          element['enabled'] = true;
        });
        quatarMaster.addAll(value);
      });

      quatarMaster.forEach((e1) {
        widget.enteredQuatar.forEach((e2) {
          if (e1['id'].toString() == e2['quarter'].toString()) {
            setState(() {
              e1['enabled'] = false;
            });
          }
        });
      });
      print(quatarMaster);
    });

    if (widget.update) {
      setState(() {
        quarterValue = widget.data['quarter'].toString();
        attendanceValue.text = widget.data['attendance'].toString();
        marksValue.text = widget.data['total_marks'].toString();
        remarkValue.text = widget.data['remark'] == null
            ? ""
            : widget.data['remark'].toString();
        resultValue = widget.data['result'].toString() == "PASS" ||
                widget.data['result'].toString() == "pass"
            ? "Pass"
            : "Fail";
        _verticalGroupValue = resultValue;
        marksheetFilePathShowOnly = widget.data['file_link'].toString();
        performanceId = widget.data['id'].toString();
        session = widget.data['session'].toString();
        studentClass = widget.data['student_class'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              title: Text(
                widget.pageName.toString(),
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
              backgroundColor: Colors.transparent),
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: form,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(
                                    widget.studentName,
                                    style: GoogleFonts.roboto(fontSize: 22),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Class - " + studentClass.toString(),
                                        style: GoogleFonts.roboto(fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Session - " + session.toString(),
                                        style: GoogleFonts.roboto(fontSize: 15),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            textLabels("Quatar"),
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
                                    value: quarterValue,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        quarterValue = newValue.toString();
                                      });
                                    },
                                    items: quatarMaster
                                        .map((e) => DropdownMenuItem(
                                              enabled: e['enabled'],
                                              child: Text(
                                                e['quarterly_name'].toString(),
                                                style: TextStyle(
                                                    color: e['enabled']
                                                        ? Colors.black
                                                        : Colors.grey),
                                              ),
                                              value: e['id'].toString(),
                                            ))
                                        .toList(),
                                  )),
                                );
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textLabels("Attendance (%)"),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty)
                                            return "Required Field";
                                          else
                                            return null;
                                        },
                                        controller: attendanceValue,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]+[.]{0,1}[0-9]*'))
                                        ],
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        onChanged: (val) {
                                          if (val.length == 5) {
                                            FocusScope.of(context).unfocus();
                                          }
                                        },
                                        maxLength: 5,
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
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textLabels("Marks (%)"),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty)
                                            return "Required Field";
                                          else
                                            return null;
                                        },
                                        controller: marksValue,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]+[.]{0,1}[0-9]*'))
                                        ],
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        onChanged: (val) {
                                          if (val.length == 5) {
                                            FocusScope.of(context).unfocus();
                                          }
                                        },
                                        maxLength: 5,
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
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            textLabels("Remarks"),
                            textField(remarkValue),
                            textLabels("Result"),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RadioGroup<String>.builder(
                                  direction: Axis.horizontal,
                                  groupValue: _verticalGroupValue,
                                  onChanged: (value) => setState(() {
                                    _verticalGroupValue = value!;
                                    setState(() {
                                      resultValue = _verticalGroupValue
                                          .toLowerCase()
                                          .toString();
                                    });
                                  }),
                                  textStyle: TextStyle(fontSize: 20),
                                  items: ["Pass", "Fail"],
                                  itemBuilder: (item) => RadioButtonBuilder(
                                    item,
                                  ),
                                  activeColor: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            kIsWeb
                                ? marksheetFilePathShowOnly.length != 0
                                    ? Card(
                                        elevation: 10,
                                        child: ListTile(
                                          title: Text(
                                            "Mark Sheet" +
                                                p.extension(
                                                    marksheetFilePathShowOnly
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
                                                    marksheetFilePathShowOnly)),
                                          ),
                                          trailing: InkWell(
                                            onTap: () {
                                              setState(() {
                                                marksheetFilePathShowOnly = "";
                                              });
                                            },
                                            child: Icon(
                                              Icons.clear,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      )
                                    : marksheetFilePath.isNotEmpty
                                        ? Card(
                                            elevation: 10,
                                            child: ListTile(
                                              title: Text(
                                                "Mark Sheet" +
                                                    p.extension(
                                                        marksheetFilePath
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
                                                  child: Image.memory(
                                                    base64Decode(
                                                        marksheetFilePath),
                                                    // scale: 3,
                                                  ),
                                                ),
                                              ),
                                              trailing: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    marksheetFilePath = "";
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
                                : marksheetFilePathShowOnly.length != 0
                                    ? Card(
                                        elevation: 10,
                                        child: ListTile(
                                          title: Text(
                                            "Mark Sheet" +
                                                p.extension(
                                                    marksheetFilePathShowOnly
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
                                                    marksheetFilePathShowOnly)),
                                          ),
                                          trailing: InkWell(
                                            onTap: () {
                                              setState(() {
                                                marksheetFilePathShowOnly = "";
                                              });
                                            },
                                            child: Icon(
                                              Icons.clear,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      )
                                    : marksheetFilePath.isNotEmpty
                                        ? Card(
                                            elevation: 10,
                                            child: ListTile(
                                              title: Text(
                                                "Mark Sheet" +
                                                    p.extension(
                                                        marksheetFilePath
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
                                                  child: Image.file(
                                                    File(marksheetFilePath),
                                                    // scale: 3,
                                                  ),
                                                ),
                                              ),
                                              trailing: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    marksheetFilePath = "";
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
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    showPhotoCaptureOptions();
                                    marksheetFilePathShowOnly = "";
                                  },
                                  icon: Icon(Icons.upload_file),
                                  label: Text("Upload MarkSheet")),
                            ),
                            SizedBox(
                              height: 30,
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
                                          child: widget.update
                                              ? Text(
                                                  "Update",
                                                  style: GoogleFonts.lato(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors.white),
                                                )
                                              : Text(
                                                  "Save",
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
                                  if (attendanceValue.text
                                          .toString()
                                          .indexOf(".") !=
                                      2) {
                                    alertShow("Attendance Format Wrong",
                                        "Required - like 85.23");
                                  } else if (marksValue.text
                                          .toString()
                                          .indexOf(".") !=
                                      2) {
                                    alertShow("Marks Format Wrong",
                                        "Required - like 85.23");
                                  } else if (marksheetFilePath.length == 0 &&
                                      marksheetFilePathShowOnly.length == 0) {
                                    alertShow("MarkSheet", "Required");
                                  } else if (form.currentState!.validate()) {
                                    showLaoding(context);
                                    var request = widget.update
                                        ? http.MultipartRequest(
                                            //for update
                                            'POST',
                                            Uri.parse(URL +
                                                "student-performance-update"))
                                        : http.MultipartRequest(
                                            //for add
                                            'POST',
                                            Uri.parse(URL +
                                                "student-performance-add"));
                                    request.headers.addAll({
                                      'Accept': 'application/json',
                                      // 'Authorization': 'Bearer ' + api_token.toString(),
                                    });

                                    request.fields['user_id'] =
                                        pref.getString("id").toString();

                                    request.fields['quarter'] =
                                        quarterValue.toString();
                                    request.fields['student_name'] =
                                        widget.studentId.toString();
                                    request.fields['attendance'] =
                                        attendanceValue.text.toString();
                                    request.fields['remark'] =
                                        remarkValue.text.toString();
                                    request.fields['marks'] =
                                        marksValue.text.toString();
                                    request.fields['result'] =
                                        resultValue.toString();

                                    if (widget.update) {
                                      request.fields[
                                              'student_performances_id'] =
                                          performanceId.toString();
                                    }

                                    if (marksheetFilePath.isNotEmpty) {
                                      if (kIsWeb) {
                                        request.fields['marksheet_file'] =
                                            marksheetFilePath;
                                      } else {
                                        request.fields['marksheet_file'] =
                                            base64Encode(File(marksheetFilePath)
                                                .readAsBytesSync());
                                      }
                                    }

                                    var response = await request.send();
                                    var respStr =
                                        await response.stream.bytesToString();

                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    print(request.fields);
                                    if (jsonDecode(respStr)['ErrorCode'] == 0) {
                                      Fluttertoast.showToast(
                                          msg: "Performance Added");
                                      Navigator.of(context).pop();
                                    } else {
                                      alertShow("Failed",
                                          "Add Performance Failed. Try Again.");
                                    }
                                  }
                                })
                          ]),
                    ),
                  )))),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                                  setState(() {
                                    marksheetFilePath = result.path.toString();
                                  });
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

                                setState(() {
                                  marksheetFilePath = base64Encode(f!);
                                });

                                Navigator.of(context).pop();
                              }
                            } else {
                              final XFile? result = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  maxHeight: 900,
                                  maxWidth: 1000,
                                  imageQuality: 90);

                              if (result != null) {
                                setState(() {
                                  marksheetFilePath = result.path.toString();
                                });
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

  final ImagePicker _picker = ImagePicker();
}
