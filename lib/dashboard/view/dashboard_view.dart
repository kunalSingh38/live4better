// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_for_better/main.dart';
import 'package:live_for_better/view/donation.dart';
import 'package:live_for_better/view/donations_list.dart';
import 'package:live_for_better/view/policy_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  List carsole = [
    {
      "image": "img_1.png",
      "heading": "Promote a healthy and safe environment for girls",
      "background": "bg_1.png",
      "label": "Scholarship awarded",
      "subLabel": "Lorem Ipsum Lorem Ipsum",
      "number": "3500"
    },
    {
      "image": "img_2.png",
      "heading": "Promote a healthy and safe environment for girls",
      "background": "bg_2.png",
      "label": "Active Volunteers",
      "subLabel": "Lorem Ipsum Lorem Ipsum",
      "number": "4000"
    },
    {
      "image": "img_3.png",
      "heading": "Promote a healthy and safe environment for girls",
      "background": "bg_3.png",
      "label": "Registered Students",
      "subLabel": "Lorem Ipsum Lorem Ipsum",
      "number": "5000"
    }
  ];

  GlobalKey<ScaffoldState> _key = GlobalKey();

  int _counter = 0;
  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title.toString(),
            notification.body.toString(),
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
                fullScreenIntent: true,
              ),
            ),
            payload: "");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
                fullScreenIntent: true,
              ),
            ),
            payload: "");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
      drawer: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(35), bottomRight: Radius.circular(35)),
        child: Drawer(
          backgroundColor: Colors.white.withOpacity(0.9),
          elevation: 10,
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,

            children: [
              DrawerHeader(
                  child: Image.asset(
                "assets/splash_image.png",
                scale: 7,
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  trailing: Image.asset(
                    "assets/donate.png",
                    scale: 13,
                  ),
                  title: Text("Pay Donation",
                      style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff4A4B57))),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Donation()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  trailing: Image.asset(
                    "assets/receipt_donor.png",
                    scale: 13,
                  ),
                  title: Text("Download Donation Receipt",
                      style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff4A4B57))),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DonationList()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  trailing: Image.asset(
                    "assets/policy.png",
                    scale: 13,
                  ),
                  title: Text("Privacy Policy",
                      style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff4A4B57))),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PolicyView(
                                  policy: "Privacy Policy",
                                  fileName: "privacy_policy.html",
                                )));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  trailing: Image.asset(
                    "assets/policy.png",
                    scale: 13,
                  ),
                  title: Text("Terms & Conditions",
                      style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff4A4B57))),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PolicyView(
                                  policy: "Terms & Conditions",
                                  fileName: "term_condition.html",
                                )));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  trailing: Image.asset(
                    "assets/policy.png",
                    scale: 13,
                  ),
                  title: Text("Shipping/Delivery Policy",
                      style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff4A4B57))),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PolicyView(
                                  policy: "Shipping/Delivery Policy",
                                  fileName: "shipping.html",
                                )));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  trailing: Image.asset(
                    "assets/policy.png",
                    scale: 13,
                  ),
                  title: Text("Refund & Cancellation Policy",
                      style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff4A4B57))),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PolicyView(
                                  policy: "Refund & Cancellation Policy",
                                  fileName: "refund.html",
                                )));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                _key.currentState!.openDrawer();
                              },
                              icon: Icon(Icons.menu)),
                          Image.asset(
                            "assets/splash_image.png",
                            scale: 1.5,
                          ),
                        ],
                      ),
                      Image.asset(
                        "assets/email.png",
                        scale: 2,
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                          items: carsole
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Text(e['heading'].toString(),
                                            style: GoogleFonts.roboto(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xff4A4B57))),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          height: kIsWeb ? 400 : 350,
                                          width: 350,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage("assets/" +
                                                      e['background']),
                                                  fit: BoxFit.fill)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Image.asset(
                                                "assets/" + e['image'],
                                                scale: 3,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  elevation: 10,
                                                  child: Container(
                                                    height: 80,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  e['label']
                                                                      .toString(),
                                                                  style: GoogleFonts.poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                                Text(
                                                                  e['subLabel']
                                                                      .toString(),
                                                                  style: GoogleFonts.inter(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ]),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Last Num.",
                                                                style: GoogleFonts.poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        11),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Image.asset(
                                                                      "assets/numberIcon.png"),
                                                                  Text(
                                                                    e['number']
                                                                            .toString() +
                                                                        "+",
                                                                    style: GoogleFonts.poppins(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                        // Stack(
                                        //   alignment: Alignment.center,
                                        //   children: [
                                        //     SizedBox(
                                        //       height: 300,
                                        //       child: Image.asset(
                                        //           "assets/" + e['background'],
                                        //           fit: BoxFit.fill),
                                        //     ),
                                        //     Image.asset(
                                        //       "assets/" + e['image'],
                                        //       scale: 4,
                                        //     ),
                                        //     Align(
                                        //       // alignment: Alignm,
                                        //       child: Padding(
                                        //         padding:
                                        //             const EdgeInsets.fromLTRB(
                                        //                 10, 30, 10, 10),
                                        //         child: Card(
                                        //           elevation: 10,
                                        //           child: ListTile(
                                        //               title: Text("data")),
                                        //         ),
                                        //       ),
                                        //     )
                                        //   ],
                                        // )
                                      ],
                                    ),
                                  ))
                              .toList(),
                          options: CarouselOptions(
                              autoPlay: true,
                              height: kIsWeb ? 500 : 450,
                              // enlargeCenterPage: true,
                              autoPlayInterval: Duration(seconds: 3))),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text("Area of Work",
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff4A4B57))),
                      ),
                      size > 700
                          ? Container(
                              height: 400,
                              child: GridView.count(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 20,
                                  childAspectRatio: 0.9,
                                  // physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  children: areaOfWork
                                      .map((e) => Stack(
                                            alignment: Alignment.centerLeft,
                                            children: [
                                              Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3.5,
                                                decoration: BoxDecoration(
                                                    // border:
                                                    //     Border.all(width: 1),
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                              ),
                                              Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    5,
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      // alignment: Alignment
                                                      //     .centerLeft,
                                                      fit: BoxFit.fill,
                                                      image: AssetImage(
                                                          "assets/" +
                                                              e['bgImage']),
                                                      // scale: 3,
                                                    )),
                                              ),
                                              Align(
                                                alignment: Alignment(-0.65, 1),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3.2,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      5.8,
                                                  decoration: BoxDecoration(
                                                      // color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        // alignment: Alignment
                                                        //     .centerLeft,
                                                        fit: BoxFit.fill,
                                                        image: AssetImage(
                                                            "assets/" +
                                                                e['fgImage']),
                                                        // scale: 3,
                                                      )),
                                                ),
                                              ),
                                              RotatedBox(
                                                quarterTurns: 3,
                                                child: Align(
                                                  alignment:
                                                      Alignment(0.5, 0.5),
                                                  child: ListTile(
                                                    minLeadingWidth: 1,
                                                    leading: RotatedBox(
                                                      quarterTurns: 1,
                                                      child: Image.asset(
                                                        "assets/" +
                                                            e['textIcon'],
                                                        scale: 2,
                                                      ),
                                                    ),
                                                    title: Text(e['text'],
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 20,
                                                            color: Color(
                                                                0xff888888))),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment(0.65, -1),
                                                  child: Image.asset(
                                                    "assets/buttonBase.png",
                                                    scale: 3.5,
                                                  )),
                                            ],
                                          ))
                                      .toList()),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                height: 300,
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: areaOfWork
                                        .map((e) => Stack(
                                              alignment: Alignment.bottomLeft,
                                              children: [
                                                Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  width: 220,
                                                  decoration: BoxDecoration(
                                                      // border:
                                                      //     Border.all(width: 1),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                ),
                                                Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      4.5,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        // alignment: Alignment
                                                        //     .centerLeft,
                                                        fit: BoxFit.fill,
                                                        image: AssetImage(
                                                            "assets/" +
                                                                e['bgImage']),
                                                        // scale: 3,
                                                      )),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment(-0.65, 1),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            3.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.2,
                                                    decoration: BoxDecoration(
                                                        // color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        image: DecorationImage(
                                                          // alignment: Alignment
                                                          //     .centerLeft,
                                                          fit: BoxFit.fill,
                                                          image: AssetImage(
                                                              "assets/" +
                                                                  e['fgImage']),
                                                          // scale: 3,
                                                        )),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 170),
                                                  child: RotatedBox(
                                                    quarterTurns: 3,
                                                    child: ListTile(
                                                      minLeadingWidth: 1,
                                                      leading: RotatedBox(
                                                        quarterTurns: 1,
                                                        child: Image.asset(
                                                          "assets/" +
                                                              e['textIcon'],
                                                          scale: 2,
                                                        ),
                                                      ),
                                                      title: Text(e['text'],
                                                          style: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 20,
                                                              color: Color(
                                                                  0xff888888))),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                    alignment: Alignment(0, -1),
                                                    child: Image.asset(
                                                      "assets/buttonBase.png",
                                                      scale: 3.5,
                                                    )),
                                              ],
                                            ))
                                        .toList()),
                              ),
                            ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  List areaOfWork = [
    {
      "bgImage": "aowbg_1.jpeg",
      "fgImage": "aowfg_1.png",
      "text": "Education",
      "textIcon": "aowicon_1.png",
      "link": ""
    },
    {
      "bgImage": "aowbg_2.jpeg",
      "fgImage": "aowfg_2.png",
      "text": "Livelihood",
      "textIcon": "aowicon_2.png",
      "link": ""
    },
    {
      "bgImage": "aowbg_3.jpeg",
      "fgImage": "aowfg_3.png",
      "text": "Social Justice and\nInclusion",
      "textIcon": "aowicon_3.png",
      "link": ""
    },
    {
      "bgImage": "aowbg_4.jpeg",
      "fgImage": "",
      "text": "Skill Devolepment",
      "textIcon": "aowicon_4.png",
      "link": ""
    }
  ];
}
