// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:live_for_better/login/views/login.dart';
import 'package:live_for_better/login/views/signup.dart';
import 'package:live_for_better/view/donation.dart';
import 'package:live_for_better/view/donations_list.dart';
import 'package:live_for_better/view/pdfView.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class WebViewIntro extends StatefulWidget {
  @override
  _WebViewIntroState createState() => _WebViewIntroState();
}

class _WebViewIntroState extends State<WebViewIntro> {
  late VideoPlayerController _controller;
  bool isPly = false;
  TextStyle header = GoogleFonts.roboto(
      fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xff555555));
  GlobalKey aboutuskey = GlobalKey();
  GlobalKey impackStory = GlobalKey();
  GlobalKey contactUs = GlobalKey();
  GlobalKey home = GlobalKey();
  List<Widget> childrens(aboutuskey, impackStory, contactUs, home) {
    return [
      InkWell(
          onTap: () {
            Scrollable.ensureVisible(home.currentContext,
                duration: Duration(milliseconds: 1300));
          },
          child: Text("Home", style: header)),
      SizedBox(
        width: 20,
      ),
      InkWell(
          onTap: () {
            Scrollable.ensureVisible(aboutuskey.currentContext,
                duration: Duration(milliseconds: 1300));
          },
          child: Text("About us", style: header)),
      SizedBox(
        width: 20,
      ),
      InkWell(
          onTap: () {
            Scrollable.ensureVisible(impackStory.currentContext,
                duration: Duration(milliseconds: 1300));
          },
          child: Text("Impact stories", style: header)),
      SizedBox(
        width: 20,
      ),
      InkWell(
          onTap: () {
            Scrollable.ensureVisible(contactUs.currentContext,
                duration: Duration(milliseconds: 1300));
          },
          child: Text("Contact Us", style: header)),
      SizedBox(
        width: 20,
      ),
      InkWell(
        onTap: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpView()));
        },
        child: Container(
            height: 40,
            width: 80,
            decoration: BoxDecoration(
                color: Color(0xffEE9591),
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "Register",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.white),
              )),
            )),
      ),
      SizedBox(
        width: 20,
      ),
      InkWell(
        onTap: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginView()));
        },
        child: Container(
            height: 40,
            width: 80,
            decoration: BoxDecoration(
                color: Color(0xffEE9591),
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "Login",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.white),
              )),
            )),
      ),
      SizedBox(
        width: 20,
      ),
      Container(
        height: 40,
        width: 150,
        decoration: BoxDecoration(
            color: Color(0xffEE9591), borderRadius: BorderRadius.circular(15)),
        child: FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                  fillColor: Color(0xffEE9591),
                  filled: true,
                  isDense: true,
                  contentPadding: EdgeInsets.all(12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: true,
                  value: "Donation",
                  isDense: true,
                  onChanged: (newValue) {
                    if (newValue.toString() == "Pay Now") {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Donation()));
                    } else if (newValue.toString() ==
                        "Download Donation Receipt") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DonationList()));
                    }
                  },
                  items: ["Donation", "Pay Now", "Download Donation Receipt"]
                      .map((value) {
                    return DropdownMenuItem(
                      value: value.toString(),
                      child: Text(
                        value.toString().toString(),
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  // int currentIndex = 0;
  List banerData = [
    {
      "label":
          "Live 4 better is a purely non-political, non-religious and non-proﬁt organization. It is committed to educating the girl child and women empowerment. Though there are many social evils and gaps in the progress of our country, perhaps none are as compelling as the lack of literacy and social status among girl children...",
      "label2":
          "Provide education for socially backward children, especially girls",
      "image": "banner1.png"
    },
    {
      "label":
          "The sole reason for the existence of Live 4 better foundation is EMPOWERMENT. We believe that if a girl is educated, she will not only contribute to the economic development of the country but also lay the foundation of a just and equal society.",
      "label2": "Promote a healthy and safe environment for girls",
      "image": "banner2.png"
    },
    {
      "label":
          "We work to ensure that females from the most marginalized communities are empowered, live in dignity, and have secure livelihoods, allowing them to support their household and community.",
      "label2": "Promote a healthy and safe environment for girls",
      "image": "banner3.png"
    }
  ];
  List ourReach = [
    {
      "label": "100+",
      "label2": "Active Volunteers",
    },
    {
      "label": "1,000+",
      "label2": "Active Students",
    },
    {
      "label": "2,500+",
      "label2": "Total Students",
    },
    {
      "label": "5,000+",
      "label2": "Scholarship Granted",
    },
  ];

  List extra = [
    {"title": "About Us", "id": "1", "key": ""},
    {"title": "Twitter", "id": "2", "key": ""},
    {"title": "Privacy Policy", "id": "6", "key": ""},
    {"title": "Impact Stories", "id": "4", "key": ""},
    {"title": "Facebook", "id": "5", "key": ""},
    {"title": "", "id": "11", "key": ""},
    {"title": "Donate Now", "id": "7", "key": ""},
    {"title": "Instgram", "id": "8", "key": ""},
    {"title": "", "id": "9", "key": ""},
    {"title": "", "id": "10", "key": ""},
    {"title": "LinkedIn", "id": "3", "key": ""},
  ];
  Widget currentBanner(e) {
    return Stack(
      children: [
        Positioned(
          left: 20,
          top: 30,
          // alignment: Alignment(-0.99, -0.8),
          child: Text(
            "Live 4 better",
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                fontSize: 50,
                color: Color(0xff555555)),
          ),
        ),
        Positioned(
          left: 20,
          top: 130,
          // alignment: Alignment(-0.98, -0.3),
          child: SizedBox(
            width: 400,
            child: Text(
              e['label'].toString(),
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xff888888)),
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 300,
          // alignment: Alignment(-0.98, 0.3),
          child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width / 3.5,
              decoration: BoxDecoration(
                  color: Color(0xffEE9591),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Center(
                  child: Text(
                    e['label2'].toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              )),
        ),
        Positioned(
            top: 50,
            right: 100,
            // alignment: Alignment(0.6, 0),
            child: Image.asset(
              "assets/" + e['image'],
              scale: 5,
            )),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: SizedBox(
        //       width: 150,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           IconButton(
        //               onPressed: () {
        //                 if (currentIndex > 0) {
        //                   setState(() {
        //                     currentIndex = currentIndex - 1;
        //                   });
        //                 } else {
        //                   setState(() {
        //                     currentIndex = banerData.length - 1;
        //                   });
        //                 }
        //               },
        //               icon: Icon(Icons.arrow_back_ios)),
        //           IconButton(
        //               onPressed: () {
        //                 if (currentIndex < banerData.length - 1) {
        //                   setState(() {
        //                     currentIndex = currentIndex + 1;
        //                   });
        //                 } else {
        //                   setState(() {
        //                     currentIndex = 0;
        //                   });
        //                 }
        //               },
        //               icon: Icon(Icons.arrow_forward_ios))
        //         ],
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }

  Widget data(e) {
    return InkWell(
      onTap: () {
        if (ourReach.indexOf(e) == 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpView()));
        }
      },
      child: Card(
        elevation: 10,
        child: Container(
          height: 150,
          width: 250,
          child: Stack(
            children: [
              Positioned(
                left: 20,
                top: 30,
                child: Text(
                  e['label'].toString(),
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 33,
                      color: Color(0xffF8877F)),
                ),
              ),
              Positioned(
                  right: 20,
                  top: 30,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "assets/imgback.png",
                        scale: 3.5,
                      ),
                      Image.asset("assets/img1.png")
                    ],
                  )),
              Positioned(
                  left: 20,
                  top: 80,
                  child: Text(e['label2'].toString(),
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black))),
              // Align(
              //     alignment: Alignment(-0.6, 0.5),
              //     child: Text("Lorem Ipsum Lorem Ipsum",
              //         style: GoogleFonts.inter(
              //             fontWeight: FontWeight.w500,
              //             fontSize: 9,
              //             color: Colors.black)))
            ],
          ),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset('assets/video.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    // _controller.initialize().then((value) {
    //   _controller.play();
    // });
    // _controller.play();
    // Timer.periodic(Duration(seconds: 10), (t) {
    //   if (currentIndex < banerData.length - 1) {
    //     setState(() {
    //       currentIndex = currentIndex + 1;
    //     });
    //   } else {
    //     setState(() {
    //       currentIndex = 0;
    //     });
    //   }
    // });
  }

  List ourLatest = [
    {
      "name": "Project Butterflies",
      "text": "By Deepalaya\nQuarter Repot (Sep'22 - Nov'22)"
    },
    {
      "name": "Nagma",
      "text":
          "Last week nagma join as a volunteer and take responsibility of four girls."
    },
    {
      "name": "Roashni Kumar",
      "text":
          "Roshni won silver medal in english essay competition which was supported by her guardians."
    },
    {
      "name": "Shelja",
      "text":
          "Shelja share her story that how she created a group of womens for supporting and take caring of small childrens who's parents died in COVID-19."
    },
    {
      "name": "Competition",
      "text":
          "A competition was organized by Live4Better Foundation for encouraging other children."
    },
    {
      "name": "Rekha Story",
      "text":
          "With the help of Live Better Foundation Rekha pass her 10th standard and she want to become teacher in future."
    },
    {
      "name": "Pinki",
      "text":
          "Pinki is supported by Reshma Kumari. Now she is a full time guardian of her, She is also in the process of adopting more girls like pinki."
    },
  ];
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await launchUrl(Uri.parse("https://wa.me/919718969789"));
          },
          child: Image.asset("assets/whatsapp.png")),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 100,
                  right: 100,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/splash_image.png",
                      scale: 7,
                    ),
                    size < 700
                        ? Column(
                            children: childrens(
                                aboutuskey, impackStory, contactUs, home),
                          )
                        : Row(
                            children: childrens(
                                aboutuskey, impackStory, contactUs, home),
                          )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 100,
                  right: 100,
                ),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                            key: home,
                            width: MediaQuery.of(context).size.width,
                            height: 500,
                            // color: Colors.black,
                            decoration: BoxDecoration(
                              // border: Border.all(width: 2),
                              image: DecorationImage(
                                  image: AssetImage("assets/rectangle.png"),
                                  fit: BoxFit.fill),
                            ),
                            child: ImageSlideshow(
                                autoPlayInterval: 3000,

                                /// Loops back to first slide.
                                isLoop: true,
                                children: banerData.map((e) {
                                  return currentBanner(e);
                                }).toList())),
                        SizedBox(
                          height: 50,
                        ),
                        _controller.value.isInitialized
                            ? Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: VideoPlayer(
                                      _controller,
                                    ),
                                  ),
                                  isPly
                                      ? InkWell(
                                          onTap: () {
                                            // print(_controller.value.isPlaying);
                                            if (isPly) {
                                              _controller.pause();
                                            } else {
                                              _controller.play();
                                            }
                                            setState(() {
                                              isPly = !isPly;
                                            });
                                          },
                                          child: Icon(
                                            Icons.pause_circle,
                                            size: 80,
                                            color: Colors.white,
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            // print(_controller.value.isPlaying);
                                            if (isPly) {
                                              _controller.pause();
                                            } else {
                                              _controller.play();
                                            }
                                            setState(() {
                                              isPly = !isPly;
                                            });
                                          },
                                          child: Icon(
                                            Icons.play_circle,
                                            size: 80,
                                            color: Colors.white,
                                          ),
                                        )
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 50,
                        ),
                        Stack(alignment: Alignment(0, 0.3), children: [
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                // color: Colors.black,
                                decoration: BoxDecoration(
                                  // border: Border.all(width: 2),
                                  image: DecorationImage(
                                      image:
                                          AssetImage("assets/rectangle_2.png"),
                                      fit: BoxFit.fill),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40, left: 80, right: 80),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Our Reach",
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 36,
                                            color: Color(0xff101828)),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                          "In keeping with its philosophy of 'Real Work Real Change', Smile Foundation , an NGO in Delhi, India to support the underserved, has taken its intervention into the interiors of India, reaching the unreached in the remotest of rural areas and urban slums with our services and making this helping foundation in India, the best NGO in India.",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: Color(0xff667085))),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                              )
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children:
                                    ourReach.map((e) => data(e)).toList()),
                          )
                        ]),

                        // InkWell(
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => PdfViewer()));
                        //   },
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width,
                        //     height: 200,
                        //     // color: Colors.black,
                        //     decoration: BoxDecoration(
                        //       // border: Border.all(width: 2),
                        //       image: DecorationImage(
                        //           image: AssetImage("assets/rectangle_2.png"),
                        //           fit: BoxFit.fill),
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(20),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text("Project\nButterflies",
                        //               style: GoogleFonts.inter(
                        //                   fontWeight: FontWeight.w600,
                        //                   fontSize: 36,
                        //                   color: Color(0xff101828))),
                        //           Text("AY 2022-23",
                        //               style: GoogleFonts.inter(
                        //                   fontWeight: FontWeight.w600,
                        //                   fontSize: 18,
                        //                   color: Color(0xff101828))),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          key: impackStory,
                          color: Color(0xffFEF8F8),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(80, 40, 80, 40),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Our",
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 40,
                                            color: Color(0xff101828))),
                                    Text("Latest",
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 40,
                                            color: Color(0xffEE9591))),
                                    Text("?",
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 40,
                                            color: Color(0xff101828)))
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GridView.count(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 30,
                                  childAspectRatio: 0.65,
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  children: ourLatest.map((e) {
                                    String image = "assets/demoImg" +
                                        (ourLatest.indexOf(e) + 1).toString() +
                                        ".png";
                                    print(image);
                                    return InkWell(
                                      onTap: () {
                                        if (ourLatest.indexOf(e) == 0) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PdfViewer()));
                                        }
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(30),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: Container(
                                                    height: 250,
                                                    width: 250,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                              image,
                                                            ),
                                                            scale: 5,
                                                            fit: BoxFit.fill),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(30),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        e['name'].toString(),
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 24,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        e['text'].toString(),
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xff667085)),
                                                      ),
                                                      // SizedBox(
                                                      //   height: 30,
                                                      // ),
                                                      // Row(
                                                      //   mainAxisAlignment:
                                                      //       MainAxisAlignment
                                                      //           .start,
                                                      //   children: [
                                                      //     CircleAvatar(
                                                      //       child: Image.asset(
                                                      //           "assets/avatar.png"),
                                                      //     ),
                                                      //     SizedBox(
                                                      //       width: 15,
                                                      //     ),
                                                      //     Column(
                                                      //       crossAxisAlignment:
                                                      //           CrossAxisAlignment
                                                      //               .start,
                                                      //       children: [
                                                      //         Text("Sunil Kumar"),
                                                      //         Text("20 Jan 2022")
                                                      //       ],
                                                      //     )
                                                      //   ],
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/rectangle_3.jpeg"),
                                          fit: BoxFit.fill)),
                                ),
                                Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    color: Color(0xfffef9f8)),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(100, 30, 100, 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Areas of Work",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 40,
                                          color: Color(0xff555555))),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  GridView.count(
                                      crossAxisCount: 4,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 20,
                                      childAspectRatio: 0.9,
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      children: areaOfWork
                                          .map((e) => Stack(
                                                alignment: Alignment.centerLeft,
                                                children: [
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            3.5,
                                                    decoration: BoxDecoration(
                                                        // border:
                                                        //     Border.all(width: 1),
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                  ),
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            5,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
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
                                                                  .height /
                                                              5.8,
                                                      decoration: BoxDecoration(
                                                          // color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image:
                                                              DecorationImage(
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
                                                        title: Text(
                                                            e['text']
                                                                .toString(),
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
                                                  Positioned(
                                                      top: 1,
                                                      right: 35,
                                                      child: Image.asset(
                                                        "assets/buttonBase.png",
                                                        scale: 3.5,
                                                      )),
                                                ],
                                              ))
                                          .toList()),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(100, 50, 100, 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("About us",
                                            key: aboutuskey,
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: Color(0xff7F56D9))),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("About the fondation",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 48,
                                                color: Colors.black)),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                            "The sole reason for the existence of Live 4 better foundation is EMPOWERMENT. We believe that if a girl is educated, she will not only contribute to the economic development of the country but also lay the foundation of a just and equal society.",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                                color: Color(0xff667085))),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("A dream that lives on",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 38,
                                                color: Colors.black)),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                            "The sole reason for the existence of Live 4 better foundation is EMPOWERMENT. We believe that if a girl is educated, she will not only contribute to the economic development of the country but also lay the foundation of a just and equal society.",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                                color: Color(0xff667085))),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                      Image.asset("assets/rectangle_4.png"),
                                      Image.asset("assets/devi.png")
                                    ]))
                              ],
                            ),
                          ),
                        ),
                        Container(
                            color: Color(0xffFEF8F8),
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(100, 100, 100, 50),
                              child: Column(
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "Our Vision",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 38,
                                                color: Color(0xffEE9591))),
                                        TextSpan(
                                            text:
                                                " We are driven by the vision of a world where all women, particularly women from underprivileged backgrounds enjoy equal status in terms of availing healthcare, education, and income.",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 38,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Image.asset(
                                    "assets/splash_image.png",
                                    scale: 5,
                                  ),
                                ],
                              ),
                            )),
                        Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          color: Color(0xffF9FAFB),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(100, 50, 100, 50),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "Join our team of 100+ Active Volunteers",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 36,
                                          color: Colors.black)),
                                  // Text("Join over 100+ Active Volunteers",
                                  //     style: GoogleFonts.inter(
                                  //         fontWeight: FontWeight.w400,
                                  //         fontSize: 20,
                                  //         color: Color(0xff667085))),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // ElevatedButton(
                                      //     style: ButtonStyle(
                                      //         backgroundColor:
                                      //             MaterialStateProperty.all(
                                      //                 Colors.white),
                                      //         elevation:
                                      //             MaterialStateProperty.all(10)),
                                      //     onPressed: () {},
                                      //     child: Text("Learn More",
                                      //         style: GoogleFonts.inter(
                                      //             fontWeight: FontWeight.w500,
                                      //             fontSize: 16,
                                      //             color: Color(0xff667085)))),
                                      // SizedBox(
                                      //   width: 20,
                                      // ),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xffEE9591)),
                                              elevation:
                                                  MaterialStateProperty.all(
                                                      10)),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SignUpView()));
                                          },
                                          child: Text("Get Started",
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Colors.white)))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          key: contactUs,
                          height: 350,
                          width: MediaQuery.of(context).size.width,
                          color: Color(0xffEE9591),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(100, 30, 100, 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/splash_image.png",
                                      scale: 6,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                        "Head Office :I-34 DIf Industrial Area Phase - 1 Sector - 31 Faridabad Pincode - 121003 Haryana",
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: Colors.white)),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ListTile(
                                        leading: Icon(
                                          Icons.call,
                                          color: Colors.black,
                                        ),
                                        title: Text("Helpline : +91-9718969789",
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: Colors.white)))
                                  ],
                                )),
                                Expanded(child: SizedBox()),
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 4,
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    children: extra.map((e) {
                                      return InkWell(
                                        onTap: () async {
                                          switch (e['id'].toString()) {
                                            case "1":
                                              Scrollable.ensureVisible(
                                                  aboutuskey.currentContext!,
                                                  duration: Duration(
                                                      milliseconds: 1300));
                                              break;
                                            case "4":
                                              Scrollable.ensureVisible(
                                                  impackStory.currentContext!,
                                                  duration: Duration(
                                                      milliseconds: 1300));
                                              break;
                                            case "6":
                                              launchUrl(Uri.parse(
                                                  "https://www.live4better.com/privacy_policy.html"));

                                              break;
                                            case "7":
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Donation()));

                                              break;
                                          }
                                        },
                                        child: Text(e['title'].toString(),
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: Colors.white)),
                                      );
                                    }).toList(),
                                  ),
                                  flex: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //   height: 100,
                        //   width: MediaQuery.of(context).size.width,
                        //   child: Padding(
                        //     padding:
                        //         const EdgeInsets.fromLTRB(100, 10, 100, 10),
                        //     child: Row(
                        //       children: [
                        //         Text("© All rights reserved.",
                        //             style: GoogleFonts.inter(
                        //                 fontWeight: FontWeight.w400,
                        //                 fontSize: 16,
                        //                 color: Colors.black))
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
