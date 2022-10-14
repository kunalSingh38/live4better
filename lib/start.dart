import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:live_for_better/dashboard_view_common.dart';
import 'package:live_for_better/view/introduction_web.dart';
import 'package:live_for_better/view/splash.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  redirect(context, size) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => kIsWeb
              ? size > 700
                  ? WebViewIntro()
                  : DashboardViewCommon()
              : SplashScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    redirect(context, MediaQuery.of(context).size.width);
    return Container();
  }
}
