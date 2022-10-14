import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_for_better/student/api/student_registartion_api.dart';
import 'package:live_for_better/student/view/student_performance_add.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ViewStudentPerformance extends StatefulWidget {
  String studentId = "";
  String studentName = "";
  ViewStudentPerformance({required this.studentId, required this.studentName});

  @override
  _ViewStudentPerformanceState createState() => _ViewStudentPerformanceState();
}

class _ViewStudentPerformanceState extends State<ViewStudentPerformance> {
  List list = [];
  String session = "";
  String studentClass = "";
  bool isLoading = true;
  List quatarMaster = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StudentRegistrationAPI()
        .getStudentPerformanceList(widget.studentId)
        .then((value) {
      if (value.length != 0) {
        setState(() {
          list.clear();
          list.addAll(value.reversed);
          isLoading = false;

          session = list[0]['session'].toString();
          studentClass = list[0]['student_class'].toString();
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });

    StudentRegistrationAPI().getStudentQuatar().then((value) {
      setState(() {
        quatarMaster.clear();
        quatarMaster.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            elevation: 0,
            centerTitle: false,
            title: Text(
              "Performances",
              style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff4A4B57)),
            ),
            actions: [
              TextButton.icon(
                  onPressed: () {
                    if (list.length == 4) {
                      Fluttertoast.showToast(
                          msg: "You have entered all quatar performances");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentPerformanceAdd(
                                  data: {},
                                  enteredQuatar: list,
                                  update: false,
                                  studentName: widget.studentName.toString(),
                                  studentId: widget.studentId.toString(),
                                  pageName: "Add Performance"))).then((value) {
                        setState(() {
                          isLoading = true;
                        });
                        StudentRegistrationAPI()
                            .getStudentPerformanceList(widget.studentId)
                            .then((value) {
                          setState(() {
                            list.clear();
                            list.addAll(value.reversed);
                            isLoading = false;
                          });
                        });
                      });
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text("ADD"))
            ],
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
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
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
                      isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : list.length == 0
                              ? Center(
                                  child: Text("No Performances"),
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 1.42,
                                  child: ListView(
                                    padding: EdgeInsets.zero,
                                    children: list.map((e) {
                                      return Card(
                                          child: Column(
                                        children: [
                                          ListTile(
                                            // tileColor: Colors.green,

                                            trailing: InkWell(
                                              onTap: () {
                                                showDialog(
                                                    useSafeArea: true,
                                                    barrierDismissible: true,
                                                    context: context,
                                                    builder: (context) =>
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Image.network(
                                                            e['file_link']
                                                                .toString(),
                                                          ),
                                                        ));
                                                // Alert(
                                                //     context: context,
                                                //     title: "Marksheet",
                                                //     onWillPopActive: false,
                                                //     content: SizedBox(
                                                //       height:
                                                //           MediaQuery.of(context)
                                                //               .size
                                                //               .height,
                                                //       width:
                                                //           MediaQuery.of(context)
                                                //               .size
                                                //               .width,
                                                //       child: Image.network(
                                                //           e['file_link']
                                                //               .toString()),
                                                //     )).show();
                                              },
                                              child: SizedBox(
                                                width: 60,
                                                child: Image.network(
                                                    e['file_link'].toString()),
                                              ),
                                            ),
                                            title: Row(
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text: '',
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style,
                                                    children: [
                                                      TextSpan(
                                                          text: quatarMaster
                                                              .where((element) =>
                                                                  element["id"]
                                                                      .toString() ==
                                                                  e["quarter"]
                                                                      .toString())
                                                              .first['quarterly_name'],
                                                          style: TextStyle(fontSize: 18)),
                                                      TextSpan(
                                                          text: " (" +
                                                              e['result']
                                                                  .toString()
                                                                  .toUpperCase() +
                                                              ")",
                                                          style: TextStyle(
                                                              color: e['result']
                                                                              .toString() ==
                                                                          "pass" ||
                                                                      e['result']
                                                                              .toString() ==
                                                                          "PASS"
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Attendance"),
                                                    Text(e['attendance']
                                                            .toString() +
                                                        "%")
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Total Marks"),
                                                    Text(e['total_marks']
                                                        .toString())
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Date"),
                                                    Text(e['created_at']
                                                        .toString()
                                                        .split("T")[0])
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text("Remarks"),
                                                Text(e['remark'] == null
                                                    ? "-"
                                                    : e['remark'].toString())
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        StudentPerformanceAdd(
                                                            enteredQuatar: list,
                                                            data: e,
                                                            studentName: widget
                                                                .studentName
                                                                .toString(),
                                                            studentId:
                                                                e['student_id']
                                                                    .toString(),
                                                            update: true,
                                                            pageName:
                                                                "Update Performance"),
                                                  )).then((value) {
                                                StudentRegistrationAPI()
                                                    .getStudentPerformanceList(
                                                        widget.studentId)
                                                    .then((value) {
                                                  setState(() {
                                                    list.clear();
                                                    list.addAll(value.reversed);
                                                    isLoading = false;
                                                  });
                                                });
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.teal[50],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 5, 15, 5),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("EDIT"),
                                                      Icon(Icons.arrow_forward)
                                                    ]),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                                    }).toList(),
                                  ),
                                )
                    ])))));
  }
}
