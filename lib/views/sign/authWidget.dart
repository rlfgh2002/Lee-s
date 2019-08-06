import 'package:flutter/material.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
import 'package:haegisa2/controllers/auth/auth.dart';
import 'package:haegisa2/main.dart';
import 'dart:async';
import 'dart:convert';
import 'package:haegisa2/controllers/member/find_pw.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/views/buttons/Buttons.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

String idValue = "";
String passValue = "";
String jsonMsg = "";

class AuthWidget extends StatefulWidget {
  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      "Resources/Images/no_member.png",
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 40, bottom: 10),
                    child: Text(
                      Strings.shared.controllers.signSelect.title3,
                      style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.supplementary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Text(
                          Strings.shared.controllers.signSelect.title3_1
                              .substring(0, 13),
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.subTitle,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          Strings.shared.controllers.signSelect.title3_1
                              .substring(13, 14),
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.content),
                          textAlign: TextAlign.center,
                        ),
                      ])),
                  Expanded(
                    child: Text(
                      Strings.shared.controllers.signSelect.title3_1
                          .substring(14, 28),
                      style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.content),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                      // This align moves the children to the bottom
                      child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          // This container holds all the children that will be aligned
                          // on the bottom and should not scroll with the above ListView
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              Image.asset(
                                'Resources/Icons/Line2.png',
                              ),
                              FlatButton(
                                padding:
                                    const EdgeInsets.only(top: 30, bottom: 30),
                                child: Text(
                                  Strings.shared.controllers.signSelect.confirm,
                                  style: TextStyle(
                                      color:
                                          Statics.shared.colors.titleTextColor,
                                      fontSize:
                                          Statics.shared.fontSizes.content),
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  flutterWebviewPlugin.close();
                                  userInformation.loginCheck = 0;
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new SplashScreen()));
                                },
                              ),
                            ],
                          ))))
                ],
              ),
            ),
          );
        });
  }
}
