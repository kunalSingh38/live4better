import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:live_for_better/dashboard_view_common.dart';
import 'package:live_for_better/view/introduction_web.dart';
import 'package:live_for_better/view/splash.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:universal_io/io.dart';

// import 'package:mac_address/mac_address.dart';
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(); //for app
  } else {
    await Firebase.initializeApp(
        //for web
        options: FirebaseOptions(
            apiKey: "AIzaSyDE3SDhwpAqge6i0gqdjUO6df6EC918amc",
            authDomain: "live4better-da8b9.firebaseapp.com",
            projectId: "live4better-da8b9",
            storageBucket: "live4better-da8b9.appspot.com",
            messagingSenderId: "664187325895",
            appId: "1:664187325895:web:28a084512a8e26dcee5de2",
            measurementId: "G-Q0Z66NKLWK"));
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
  // var mac = await GetMac.macAddress;
  // print(mac + " mac address");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live 4 Better',
      debugShowCheckedModeBanner: false,
      // builder: (context, widget) => ResponsiveWrapper.builder(
      //     BouncingScrollWrapper.builder(context, widget!),
      //     maxWidth: 800,
      //     minWidth: 450,
      //     defaultScale: true,
      //     breakpoints: [
      //       ResponsiveBreakpoint.resize(450, name: MOBILE),
      //       // ResponsiveBreakpoint.autoScale(450, name: TABLET),
      //       // ResponsiveBreakpoint.resize(450, name: DESKTOP),
      //     ],
      //     background: Container(color: Color(0xFFF5F5F5))),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
