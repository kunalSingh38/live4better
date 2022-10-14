import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_for_better/student/view/single_student_details.dart';

class RegistrationSuceess extends StatefulWidget {
  String id = "";
  String name = "";

  RegistrationSuceess({required this.id, required this.name});
  @override
  _RegistrationSuceessState createState() => _RegistrationSuceessState();
}

class _RegistrationSuceessState extends State<RegistrationSuceess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent.withOpacity(0),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            title: Text(
              "Registration Successful",
              style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff4A4B57)),
            )),
        body: Center(
          child: Card(
            elevation: 10,
            // color: Colors.green,
            child: Container(
              height: 400,
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/sucess.png", scale: 6),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Congratulations",
                    style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                  Text(
                    "Registration Successful",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingleStudentDetails(
                                  id: widget.id, studentName: widget.name)));
                    },
                    child: Text("Go To Profile"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
