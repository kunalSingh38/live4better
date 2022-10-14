// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_for_better/student/api/student_registartion_api.dart';
import 'package:live_for_better/student/view/single_student_details.dart';
import 'package:live_for_better/student/view/student_registration.dart';
import 'package:live_for_better/student/view/students_registered_list.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  List activites = [
    {
      "title": "New Student",
      "image": "assets/new_student.png",
      "bgcolor": "0xffF1C6B8",
      "borderColor": "0xffE96958",
      "page": StudentRegistrationForm(
        id: "",
        index: 0,
      )
    },
    {
      "title": "Scholarship",
      "image": "assets/existing_student.png",
      "bgcolor": "0xffEAD9FF",
      "borderColor": "0xff9764D7",
      "page": ""
    },
    // {
    //   "title": "Drafts Student",
    //   "image": "assets/new_student.png",
    //   "bgcolor": "0xffB5E0E3",
    //   "borderColor": "0xff82ced3",
    //   "page": ""
    // }
  ];

  List statusList = [
    {"title": "All", "count": "", "value": "all"},
    {"title": "Pending", "count": "", "value": "3"},
    {"title": "Approved", "count": "", "value": "1"},
    {"title": "Rejected", "count": "", "value": "2"}
  ];

  List firstfivestudentlist = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudentCount();
    getLastestList();
  }

  getStudentCount() async {
    print("called");
    StudentRegistrationAPI().getStudentStatusCount().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          statusList[0]['count'] = (int.parse(value["Pending"].toString()) +
                  int.parse(value["Approve"].toString()) +
                  int.parse(value["Reject"].toString()))
              .toString();
          statusList[1]['count'] = value["Pending"].toString();
          statusList[2]['count'] = value["Approve"].toString();
          statusList[3]['count'] = value["Reject"].toString();
        });
      }
    });
  }

  getLastestList() async {
    StudentRegistrationAPI().getRegisteredStudentList("all").then((value) {
      print(value);
      if (value.length > 0) {
        setState(() {
          firstfivestudentlist.clear();
          firstfivestudentlist = value;
          firstfivestudentlist.removeRange(5, firstfivestudentlist.length);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: false,
            title: Text(
              "Dashboard",
              style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffEE9591)),
            ),
            backgroundColor: Colors.transparent),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage("assets/sr_bg.png"), fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 8,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 10,
                          );
                        },
                        itemCount: statusList.length,
                        itemBuilder: (_, i) => Container(
                              height: 100,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Color(0xffF7C7C4), width: 2)),
                              child: InkWell(
                                onTap: () {
                                  if (statusList[i]['count'] == "0") {
                                    Fluttertoast.showToast(
                                        msg: "Total Count is 0.");
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisteredList(
                                                    pageFor: statusList[i]
                                                            ['title']
                                                        .toString(),
                                                    value: statusList[i]
                                                            ['value']
                                                        .toString())));
                                  }
                                },
                                child: GridTile(
                                  header: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Color(0xffFFEDF6),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Applications",
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff4A4B57)),
                                    )),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/pie-chart.png",
                                          scale: 1.5,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(statusList[i]['title'],
                                            style: GoogleFonts.roboto(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff4A4B57)))
                                      ],
                                    ),
                                  ),
                                  footer: Stack(children: [
                                    Align(
                                      alignment: Alignment(-0.5, -0.2),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 10),
                                        child: statusList[i]['count'] == null
                                            ? CircularProgressIndicator()
                                            : Text(
                                                statusList[i]['count']
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff4A4B57))),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: Image.asset("assets/button.png"))
                                  ]),
                                ),
                              ),
                            )),
                  ),
                  Expanded(
                      flex: 13,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("Activities",
                                style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff555555))),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 90,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    width: 10,
                                  );
                                },
                                itemCount: activites.length,
                                itemBuilder: (_, i) => InkWell(
                                      onTap: () {
                                        if (activites[i]['page']
                                            .toString()
                                            .isNotEmpty) {
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          activites[i]['page']))
                                              .then((value) {
                                            getLastestList();
                                            getStudentCount();
                                          });
                                        }
                                      },
                                      child: Container(
                                          // height: 50,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              color: Color(int.parse(
                                                  activites[i]['bgcolor'])),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Color(int.parse(
                                                      activites[i]
                                                          ['borderColor'])),
                                                  width: 2)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                activites[i]['image'],
                                                scale: 1,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(activites[i]['title'],
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xff555555)))
                                            ],
                                          )),
                                    )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("Student Status",
                                style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff555555))),
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 22,
                      child: ListView(
                        children: firstfivestudentlist.map((e) {
                          String status = "";
                          if (e['status'] == 1) {
                            status = "Approved";
                          } else if (e['status'] == 2) {
                            status = "Rejected";
                          } else if (e['status'] == 3) {
                            status = "Pending";
                          }
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Application: " + e['id'].toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff555555))),
                                      e['student_pic']
                                              .toString()
                                              .contains("student")
                                          ? CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                e['student_pic'].toString(),
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 30,
                                              backgroundImage: AssetImage(
                                                  "assets/avatar_2.png"),
                                            )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Full Name : ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xff555555))),
                                      Text(e['name'].toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff555555))),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Status : ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff555555))),
                                          Text(status,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff555555))),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SingleStudentDetails(
                                                        id: e['id'].toString(),
                                                        studentName: e['name']
                                                            .toString(),
                                                      )));
                                        },
                                        child: Text("View Details",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.blue)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ))
                ],
              ),
            )));
  }
}
