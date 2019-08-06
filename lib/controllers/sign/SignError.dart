import 'package:flutter/material.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
import 'MiddleWare.dart';
import 'dart:async';
import 'dart:convert';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/controllers/sign/SignSelect.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class SignError extends StatefulWidget {
  String alertMessage;

  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<SignError> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: AlertDialog(
        contentPadding: EdgeInsets.all(0.0),
        content: Container(
          height: MediaQuery.of(context).size.height / 1.4,
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
                      fontSize: Statics.shared.fontSizes.subTitleInContent),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(bottom: 10),
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
                              fontSize:
                                  Statics.shared.fontSizes.subTitleInContent),
                          textAlign: TextAlign.center,
                        ),
                      ])),
              Container(
                child: Text(
                  Strings.shared.controllers.signSelect.title3_2,
                  style: TextStyle(
                      color: Statics.shared.colors.titleTextColor,
                      fontSize: Statics.shared.fontSizes.subTitleInContent),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "",
                  style: TextStyle(
                      color: Statics.shared.colors.titleTextColor,
                      fontSize: Statics.shared.fontSizes.subTitleInContent),
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
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Text(
                              Strings.shared.controllers.signSelect.confirm,
                              style: TextStyle(
                                  color: Statics.shared.colors.titleTextColor,
                                  fontSize: Statics.shared.fontSizes.content),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              userInformation.loginCheck = 0;
                              Navigator.of(context, rootNavigator: true).pop();
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
      )),
    );
  }
}
