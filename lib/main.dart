import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
import 'package:haegisa2/models/Chat/chatObject.dart';
import 'controllers/mainTabBar/MainTabBar.dart';
import 'controllers/sign/SignSelect.dart';
import 'models/statics/UserInfo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SplashScreen()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    FirebaseMessaging()
        .getToken()
        .then((val) => (print("FCM Token: ${val.toString()}")))
        .catchError((error) => print("FCM Token Error: ${error.toString()}"));

    FirebaseMessaging().getToken().then((token) {
      userInformation.userToken = token;
    });

    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: new Column(children: <Widget>[
              new Image.asset(
                'Resources/Images/splash.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                repeat: ImageRepeat.noRepeat,
              ),
            ]),
          ),
        ));
  }
}
