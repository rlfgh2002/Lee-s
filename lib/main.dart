import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
import 'package:haegisa2/models/Chat/chatObject.dart';
import 'controllers/mainTabBar/MainTabBar.dart';
import 'controllers/sign/SignSelect.dart';
import 'models/statics/UserInfo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
// test

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging()
        .getToken()
        .then((val) => (print("FCM Token: ${val.toString()}")))
        .catchError((error) => print("FCM Token Error: ${error.toString()}"));

    FirebaseMessaging().getToken().then((token) {
      userInformation.userToken = token;
    });

    return WillPopScope(
        onWillPop: () async => false,
        child: new MaterialApp(
          title: 'Haegisa',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
        ));
  }
}
