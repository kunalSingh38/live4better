// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:live_for_better/dashboard/view/dashboard.dart';
import 'package:live_for_better/dashboard/view/dashboard_view.dart';
import 'package:live_for_better/dashboard_view_common.dart';
import 'package:live_for_better/view/introduction.dart';
import 'package:live_for_better/view/introduction_web.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getScreen(context, size) {
    print(size);
    Timer(Duration(seconds: 1), () {
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => DashboardViewCommon()));

      // if (size > 700) {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (context) => WebViewIntro()));
      // } else {

      kIsWeb
          ? size > 700
              ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WebViewIntro()))
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DashboardViewCommon()))
          : checkLoggedIn();
      // }
    });
  }

  checkLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? isLoggedIn = (preferences.getBool('loggedIn') == null)
        ? false
        : preferences.getBool('loggedIn');

    if (isLoggedIn == true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false);
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => IntroDuctionScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    getScreen(context, MediaQuery.of(context).size.width);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/splash_image.png",
          scale: 4,
        ),
      ),
    );
  }
}
