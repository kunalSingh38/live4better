import 'package:flutter/material.dart';
import 'package:live_for_better/dashboard/view/dashboard.dart';
import 'package:live_for_better/view/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () async {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Do you want to logout"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel")),
                      TextButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(() {
                              DashboardState.currentTab = 0;
                            });

                            await prefs.clear().then((value) {
                              Navigator.of(context, rootNavigator: true)
                                  .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => SplashScreen()),
                                      (route) => false);
                            });
                          },
                          child: Text("Logout"))
                    ],
                  ));
        },
        child: Image.asset(
          "assets/logout_btn.png",
          scale: 7,
        ),
      ),
    );
  }
}
