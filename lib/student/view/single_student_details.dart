// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_for_better/student/api/student_registartion_api.dart';
import 'package:live_for_better/student/view/student_registration.dart';
import 'package:live_for_better/student/view/student_registration_page_success.dart';
import 'package:live_for_better/student/view/view_image.dart';

class SingleStudentDetails extends StatefulWidget {
  String id;
  String studentName;
  SingleStudentDetails({required this.id, required this.studentName});

  @override
  _SingleStudentDetailsState createState() => _SingleStudentDetailsState();
}

class _SingleStudentDetailsState extends State<SingleStudentDetails>
    with SingleTickerProviderStateMixin {
  Map data = {};

  List formTabs = [
    'Student Details',
    // 'Guardian Details',
    'Student Bank Details',
    'School Details',
    'School Bank Details',
    'School Fee Details'
  ];
  bool loading = true;
  List expenseMaster = [];
  List sessionMaster = [];
  List standartMaster = [];
  late TabController _controller;
  List schoolAttachment = [];

  void getAllData() async {
    await StudentRegistrationAPI().getExpenseList().then((value) {
      setState(() {
        expenseMaster = value;
      });
    });
    await StudentRegistrationAPI().getSessionList().then((value) {
      setState(() {
        sessionMaster = value;
      });
    });
    await StudentRegistrationAPI().getSStandardList().then((value) {
      setState(() {
        standartMaster = value;
      });
    });
    await StudentRegistrationAPI()
        .getStudentFilledDetails(widget.id.toString())
        .then((value) {
      setState(() {
        data.addAll(value);
      });
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllData();
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

  int currentIndex = 0;

  Widget attchmentsView(fileLink, String name) {
    print(fileLink);
    return fileLink != null
        ? InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewImage(file: fileLink.toString())));
            },
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(22),
                ),
                height: 100,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    fileLink,
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                )),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(name + " N/A"),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : DefaultTabController(
            length: formTabs.length,
            initialIndex: currentIndex,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: false,
                title: Text(
                  "Student Details",
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xffEE9591)),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => StudentRegistrationForm(
                                    id: widget.id.toString(),
                                    index: currentIndex,
                                  ))),
                        ).then((value) {
                          StudentRegistrationAPI()
                              .getStudentFilledDetails(widget.id.toString())
                              .then((value) {
                            setState(() {
                              data.clear();
                              data.addAll(value);
                              loading = false;
                            });
                          });
                        });
                      },
                      child: Text("EDIT",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                          padding: MaterialStateProperty.all(EdgeInsets.all(2)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green)),
                    ),
                  )
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
                bottom: TabBar(
                  controller: _controller,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                  isScrollable: true,
                  tabs: formTabs.map((e) => Tab(text: e)).toList(),
                ),
              ),
              body: TabBarView(
                controller: _controller,
                children: [
                  studentDetails(),
                  // uuardianDetails(),
                  studentBankDetails(),
                  schoolDetails(),
                  schoolBankDetails(),
                  schoolFeeDetails(
                      data["school_fee"], data['fee_receipt_multiple']),
                ]
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: e,
                      ),
                    )
                    .toList(),
              ),
            ));
  }

  Widget labelRow(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xff4A4B57)),
          ),
          Flexible(
            child: value == "null"
                ? Text("-")
                : Text(
                    value,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff4A4B57)),
                  ),
          )
        ],
      );

  Widget studentDetails() => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            data['student_pic'].toString().contains("student")
                ? Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(data['student_pic']),
                    ),
                  )
                : Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage("assets/profile_image.png"),
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            labelRow("Name", data["name"].toString()),
            SizedBox(
              height: 8,
            ),
            labelRow("Date of Birth", data["dob"].toString()),
            SizedBox(
              height: 8,
            ),
            labelRow("Gender", data["gender"].toString()),
            SizedBox(
              height: 8,
            ),
            labelRow(
                "Session",
                sessionMaster
                    .where((element) =>
                        element["id"].toString() == data["session"].toString())
                    .first['name']),
            SizedBox(
              height: 8,
            ),
            labelRow(
                "Standard",
                standartMaster
                    .where((element) =>
                        element["id"].toString() ==
                        data["student_class"].toString())
                    .first['name']),
            SizedBox(
              height: 8,
            ),
            labelRow("Phone", data["phone"].toString()),
            SizedBox(
              height: 8,
            ),
            labelRow("Address", data["address"].toString()),
            SizedBox(
              height: 8,
            ),
            labelRow("Student's Adhaar", data["student_adhaar"].toString()),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                attchmentsView(data['student_adhaar_file'], "Front Side"),
                attchmentsView(data['student_adhaar_file_back'], "Back Side"),
              ],
            ),

            Divider(
              thickness: 1,
              color: Colors.green,
              height: 25,
            ),
            labelRow("Father's Name", data["father_name"].toString()),
            SizedBox(
              height: 8,
            ),
            labelRow("Father Occup.", data["father_occupation"].toString()),
            SizedBox(
              height: 8,
            ),
            labelRow("Father's Adhar No.", data["father_adhaar"].toString()),

            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                attchmentsView(data['father_adhaar_file'], "Front Side"),
                attchmentsView(data['father_adhaar_file_back'], "Back Side"),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            labelRow("Father's Mobile", data["father_mobile"].toString()),
            SizedBox(
              height: 8,
            ),
            labelRow("Father's Monthly Income",
                data["father_monthly_income"].toString()),
            SizedBox(
              height: 8,
            ),

            data['father_death_certificate'] != null
                ? SizedBox()
                : attchmentsView(
                    data['father_death_certificate'], "Father's Death Cert."),
            Divider(
              thickness: 1,
              color: Colors.green,
              height: 30,
            ),
            labelRow("Mother's Name", data["mother_name"].toString()),

            SizedBox(
              height: 8,
            ),
            labelRow("Mother's Occup.", data["mother_occupation"].toString()),
            SizedBox(
              height: 8,
            ),
            labelRow("Mother's Adhar No.", data["mother_adhaar"].toString()),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                attchmentsView(data['mother_adhaar_file'], "Front Side"),
                attchmentsView(data['mother_adhaar_file_back'], "Back Side"),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            labelRow("Mother's Mobile", data["mother_mobile"].toString()),
            SizedBox(
              height: 8,
            ),
            labelRow("Mother's Monthly Income",
                data["mother_monthly_income"].toString()),
            SizedBox(
              height: 8,
            ),
            data['mother_death_certificate'] != null
                ? SizedBox()
                : Column(
                    children: [
                      attchmentsView(data['mother_death_certificate'],
                          "Mother's Death Cert."),
                    ],
                  ),

            // Divider(
            //   thickness: 1,
            //   color: Colors.white,
            //   height: 25,
            // ),
            // labelRow("", data[""].toString()),
            // Divider(
            //   thickness: 1,
            //   color: Colors.white,
            //   height: 25,
            // ),
          ],
        ),
      );
  // Widget uuardianDetails() => SingleChildScrollView(
  //         child: Column(children: [
  //       labelRow("Name", data["guardian_name"].toString()),
  //       Divider(
  //         thickness: 1,
  //         color: Colors.white,
  //         height: 25,
  //       ),
  //       labelRow("Mobile", data["guardian_mobile"].toString()),
  //       Divider(
  //         thickness: 1,
  //         color: Colors.white,
  //         height: 25,
  //       ),
  //       labelRow("Email", data["guardian_email"].toString()),
  //       Divider(
  //         thickness: 1,
  //         color: Colors.white,
  //         height: 25,
  //       ),
  //       labelRow(
  //           "Relation With Student", data["relation_with_student"].toString()),
  //     ]));
  Widget studentBankDetails() => SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        labelRow("Name", data["bank_name"].toString()),
        SizedBox(
          height: 8,
        ),
        labelRow("Branch", data["bank_branch"].toString()),
        SizedBox(
          height: 8,
        ),
        labelRow("IFSC Code", data["bank_ifsc_code"].toString()),
        SizedBox(
          height: 8,
        ),
        labelRow("A/C Number", data["bank_ac_number"].toString()),
        SizedBox(
          height: 8,
        ),
        attchmentsView(data['student_bank_cheque'], "Student's Bank Cheque")
      ]));
  Widget schoolDetails() => data["school_detail"] == null
      ? Center(
          child: Text("No details"),
        )
      : SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          labelRow("Name", data["school_detail"]["school_name"].toString()),
          SizedBox(
            height: 8,
          ),
          labelRow("Teacher's Name",
              data["school_detail"]["school_teacher_name"].toString()),
          SizedBox(
            height: 8,
          ),
          labelRow("Teacher's Mobile",
              data["school_detail"]["teacher_mobile"].toString()),
          SizedBox(
            height: 8,
          ),
          labelRow("Teacher's Email",
              data["school_detail"]["teacher_email"].toString()),
          SizedBox(
            height: 8,
          ),
          labelRow("School's Address",
              data["school_detail"]["school_address"].toString()),
        ]));
  Widget schoolBankDetails() => data["school_detail"] == null
      ? Center(
          child: Text("No details"),
        )
      : SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          labelRow("Bank Name", data["school_detail"]["bank_name"].toString()),
          SizedBox(
            height: 8,
          ),
          labelRow(
              "Bank Branch", data["school_detail"]["bank_branch"].toString()),
          SizedBox(
            height: 8,
          ),
          labelRow("Bank IFSC Code",
              data["school_detail"]["bank_ifsc_code"].toString()),
          SizedBox(
            height: 8,
          ),
          labelRow("Bank A/C No.",
              data["school_detail"]["bank_ac_number"].toString()),
          SizedBox(
            height: 8,
          ),
          attchmentsView(data["school_detail"]['school_fee_secular'],
              "School's Fee Circular"),
        ]));
  Widget schoolFeeDetails(List schoolfee, List fee_receipt_multiple) =>
      schoolfee.length == 0
          ? Center(
              child: Text("No details"),
            )
          : SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                    children: schoolfee.map((e) {
                  String expenseType = "";
                  expenseMaster.forEach((element) {
                    if (element['id'].toString() ==
                        e['expense_id'].toString()) {
                      expenseType = element['expense_name'];
                    }
                  });
                  return Column(
                    children: [
                      Column(
                        children: [
                          labelRow("Expense Name", expenseType.toString()),
                          SizedBox(
                            height: 8,
                          ),
                          labelRow("Expense Type",
                              e['expense_type'].toString().toUpperCase()),
                          SizedBox(
                            height: 8,
                          ),
                          labelRow("Expense Fee", e['expense_fee'].toString()),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.white,
                        height: 25,
                      ),
                    ],
                  );
                }).toList()),
                SizedBox(
                  height: 10,
                ),
                GridView.count(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1,
                  children: fee_receipt_multiple.map((e) {
                    return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child:
                            attchmentsView(e['receipt'].toString(), "Upload"));
                  }).toList(),
                ),
              ],
            ));
}
