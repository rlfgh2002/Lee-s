import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
import 'package:haegisa2/models/Chat/chatObject.dart';
import 'package:haegisa2/models/myFuncs.dart';
import 'package:haegisa2/views/MainTabBar/NoInternetPopUp.dart';
import 'controllers/mainTabBar/MainTabBar.dart';
import 'controllers/mainTabBar/MiddleWare.dart';
import 'controllers/sign/SignSelect.dart';
import 'models/statics/UserInfo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(new MaterialApp(
    // localizationsDelegates: [
    //   // ... app-specific localization delegate[s] here
    //   GlobalMaterialLocalizations.delegate,
    //   GlobalWidgetsLocalizations.delegate,
    //   GlobalCupertinoLocalizations.delegate,
    // ],
    // // supportedLocales: [
    // //   const Locale('ko', 'KR'),
    // // ],
    // // locale: Locale('ko', 'KR'),
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription subscription;
  FirebaseMessaging mainFirebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) iOS_Permission();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result.index == 2) {
        // no internet connected
        print("showNoInternet");
        showNoInternet(context);
      }
    });

    new Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SplashScreen()),
            ));
  }

  void checkInternet(BuildContext ctx) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      print("showNoInternet2");
      showNoInternet(ctx);
    }
  }

  void showNoInternet(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return NoInternetAlertWidget(
            popUpWidth: MediaQuery.of(context).size.width,
            onPressClose: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          ).dialog();
        });
  }

  void iOS_Permission() {
    mainFirebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    mainFirebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));
    //세로 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    FirebaseMessaging()
        .getToken()
        .then((val) => (print("FCM Token2: ${val.toString()}")))
        .catchError((error) => print("FCM Token3 Error: ${error.toString()}"));

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
