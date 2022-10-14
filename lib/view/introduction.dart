import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:live_for_better/dashboard_view_common.dart';
import 'package:live_for_better/login/views/login.dart';

class IntroDuctionScreen extends StatefulWidget {
  const IntroDuctionScreen({Key? key}) : super(key: key);

  @override
  _IntroDuctionScreenState createState() => _IntroDuctionScreenState();
}

class _IntroDuctionScreenState extends State<IntroDuctionScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardViewCommon()));
  }

  bool currentIndex = true;
  Widget _buildImage(String assetName) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.asset(
        'assets/$assetName',
        scale: 4,
      ),
    );
  }

  Widget titleWidget(data) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        data,
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: Color(0xff4A4B57)),
      ),
    );
  }

  Widget bodyWidget(data) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        data,
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
            fontSize: 14.0,
            height: 1.7,
            fontWeight: FontWeight.w500,
            color: currentIndex ? Color(0xff888888) : Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // const bodyStyle = TextStyle(fontSize: 19.0);

    // const pageDecoration = PageDecoration(

    //   titleTextStyle: TextStyle(
    //     fontSize: 20.0,
    //     fontWeight: FontWeight.w700,

    //   ),
    //   bodyTextStyle: bodyStyle,
    //   bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    //   pageColor: Colors.white,
    //   imagePadding: EdgeInsets.zero,
    // );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: currentIndex ? Colors.white : Color(0xffEE9591),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    _onIntroEnd(context);
                  },
                  child: Text("Skip",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: Color(0xff5A5B6A))))),
        ],
      ),
      body: SafeArea(
        child: IntroductionScreen(
          key: introKey,
          globalBackgroundColor:
              currentIndex ? Colors.white : Color(0xffEE9591),
          // globalHeader: Align(
          //   alignment: Alignment.topRight,
          //   child: SafeArea(
          //     child: TextButton(onPressed: () {}, child: Text("Skip")),
          //   ),
          // ),
          // globalFooter: SizedBox(
          //   width: double.infinity,
          //   height: 60,
          //   child: ElevatedButton(
          //     child: const Text(
          //       'Let\'s go right away!',
          //       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          //     ),
          //     onPressed: () => _onIntroEnd(context),
          //   ),
          // ),
          onChange: (val) {
            if (val % 2 == 0) {
              setState(() {
                currentIndex = true;
              });
            } else {
              setState(() {
                currentIndex = false;
              });
            }
            print(currentIndex);
          },
          pages: [
            PageViewModel(
              titleWidget: titleWidget(
                  "Provide education for socially backward children, especially girls"),
              bodyWidget: bodyWidget(
                  "Live 4 better is a purely non-political, non-religious and non-proﬁt organization. It is committed to educating the girl child and women empowerment."),
              image: _buildImage('intro_image_1.png'),
            ),
            PageViewModel(
              titleWidget: titleWidget(
                  "Promote a healthy and safe environment for girls"),
              bodyWidget: bodyWidget(
                " We believe that if a girl is educated, she will not only contribute to the economic development of the country but also lay the foundation of a just and equal society.",
              ),
              image: _buildImage('intro_image_2.png'),
            ),
            PageViewModel(
              titleWidget: titleWidget(
                  "Promote a healthy and safe environment for girls"),
              bodyWidget: bodyWidget(
                "We work to ensure that females from the most marginalized communities are empowered, live in dignity, and have secure livelihoods, allowing them to support their household and community.",
              ),
              image: _buildImage('intro_image_3.png'),
            ),
          ],
          onDone: () => _onIntroEnd(context),
          //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: false,
          skipOrBackFlex: 0,
          nextFlex: 0,
          showBackButton: false,
          //rtl: true, // Display as right-to-left
          back: const Icon(Icons.arrow_back),
          // skip: const Text('Skip',
          //     style: TextStyle(
          //         fontWeight: FontWeight.w900,
          //         fontSize: 14,
          //         color: Color(0xff5A5B6A))),
          next: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                  color: currentIndex ? Color(0xffEE9591) : Colors.white,
                  borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  "NEXT",
                  style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: currentIndex ? Colors.white : Color(0xffEE9591)),
                )),
              )),
          done: InkWell(
            onTap: () => _onIntroEnd(context),
            child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                    color: currentIndex ? Color(0xffEE9591) : Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "START",
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: currentIndex ? Colors.white : Color(0xffEE9591)),
                  )),
                )),
          ),
          curve: Curves.fastLinearToSlowEaseIn,
          controlsMargin: const EdgeInsets.all(16),
          controlsPadding: kIsWeb
              ? const EdgeInsets.all(12.0)
              : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          dotsDecorator: currentIndex
              ? const DotsDecorator(
                  size: Size(10.0, 10.0),
                  color: Color(0xffEE9591),
                  activeSize: Size(50.0, 10.0),
                  activeColor: Color(0xffEE9591),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                )
              : const DotsDecorator(
                  size: Size(10.0, 10.0),
                  color: Colors.white,
                  activeSize: Size(50.0, 10.0),
                  activeColor: Colors.white,
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
          dotsContainerDecorator: currentIndex
              ? const ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                )
              : const ShapeDecoration(
                  color: Color(0xffEE9591),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
        ),
      ),
    );
  }
}
