// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_for_better/student/api/student_registartion_api.dart';
import 'package:live_for_better/student/view/single_student_details.dart';
import 'package:live_for_better/student/view/student_performance_add.dart';
import 'package:live_for_better/student/view/student_performance_view.dart';
import 'package:live_for_better/student/view/student_registration.dart';

class RegisteredList extends StatefulWidget {
  String pageFor;
  String value;
  RegisteredList({required this.pageFor, required this.value});

  @override
  _RegisteredListState createState() => _RegisteredListState();
}

class _RegisteredListState extends State<RegisteredList> {
  List studentList = [];
  List studentListCopy = [];

  void seraching(String search) {
    List<Map<String, dynamic>> dummyListData = [];
    if (search.isNotEmpty) {
      studentListCopy.forEach((item) {
        item.forEach((key, value) {
          if (value.toString().toLowerCase().contains(search.toLowerCase())) {
            dummyListData.add(item);
          }
        });
      });
      setState(() {
        studentList.clear();
        studentList.addAll(dummyListData.toSet().toList());
      });
    } else {
      setState(() {
        studentList.clear();
        studentList.addAll(studentListCopy);
      });
    }
  }

  void getDetails() async {
    StudentRegistrationAPI()
        .getRegisteredStudentList(widget.value)
        .then((value) {
      if (value.length > 0) {
        setState(() {
          studentList.clear();
          studentList.addAll(value);
          studentListCopy.addAll(value);
          print(studentList);
        });
      }
    });
  }

  TextEditingController searchText = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Student List : ",
                style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff4A4B57)),
              ),
              Text(
                widget.pageFor,
                style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff4A4B57)),
              ),
            ],
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 0) {
                        FocusScope.of(context).unfocus();
                      }
                      seraching(value);
                    },
                    controller: searchText,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Search",
                        contentPadding: EdgeInsets.only(left: 10),
                        suffixIcon: IconButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                searchText.text = "";
                                studentList.clear();
                                studentList.addAll(studentListCopy);
                              });
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.red,
                            ))),
                  )),
                  Expanded(
                    flex: 8,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: studentList.map((e) {
                        String status = "";
                        if (e['status'] == 1) {
                          status = "Approved";
                        } else if (e['status'] == 2) {
                          status = "Rejected";
                        } else if (e['status'] == 3) {
                          status = "Pending";
                        }
                        return Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0XFF80CBC4))),
                          child: Column(
                            children: [
                              Stack(alignment: Alignment.topRight, children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Application: " + e['id'].toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff555555))),
                                      SizedBox(
                                        height: 10,
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
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          Color(0xff555555))),
                                              Text(status,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Color(0xff555555))),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SingleStudentDetails(
                                                            id: e['id']
                                                                .toString(),
                                                            studentName:
                                                                e['name']
                                                                    .toString(),
                                                          ))).then((value) {
                                                getDetails();
                                              });
                                            },
                                            child: Text("View Details",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.blue)),
                                          ),
                                        ],
                                      ),
                                      widget.pageFor == "Rejected"
                                          ? Column(
                                              children: [
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Reason : ",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Color(
                                                                0xff555555))),
                                                    Text(
                                                        e['reject_reason']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xff555555))),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: e['student_pic']
                                          .toString()
                                          .contains("student")
                                      ? CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(
                                              e['student_pic'].toString()),
                                        )
                                      : CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                              AssetImage("assets/avatar_2.png"),
                                        ),
                                )
                              ]),
                              widget.pageFor == "Approved"
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewStudentPerformance(
                                                      studentName:
                                                          e['name'].toString(),
                                                      studentId:
                                                          e['id'].toString(),
                                                    )));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.teal[50],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 5, 20, 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Achievments",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          Color(0xff555555))),
                                              Image.asset(
                                                "assets/performance.png",
                                                scale: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ))),
    );
  }
}
