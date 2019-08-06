import 'package:flutter/material.dart';
import 'package:haegisa2/main.dart';
import 'MiddleWare.dart';
import 'dart:async';
import 'dart:convert';
import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:haegisa2/controllers/auth/auth.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/views/buttons/Buttons.dart';
import 'package:http/http.dart' as http;

class Agree extends StatefulWidget {
  @override
  _AgreeInState createState() => _AgreeInState();
}

class _AgreeInState extends State<Agree> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    MiddleWare.shared.screenSize = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
                child: Text(
                  Strings.shared.controllers.term.terms_title,
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.title,
                    fontWeight: FontWeight.bold,
                    color: Statics.shared.colors.titleTextColor,
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 70)),
            Container(
                child: Text(
                  Strings.shared.controllers.term.terms_title_detial,
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.subTitle,
                    color: Statics.shared.colors.subTitleTextColor,
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(right: 64, top: 20)),
            SizedBox(height: 40),
            Container(
                child: FlatButton(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "Resources/Icons/radio_inactive.png",
                          scale: 4.0,
                        ),
                        Text(
                          " " +
                              Strings.shared.controllers.term
                                  .terms_accept_all_title,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: Statics.shared.fontSizes.supplementary),
                          textAlign: TextAlign.left,
                        ),
                      ]),
                  onPressed: () {},
                  padding: const EdgeInsets.only(right: 64),
                ),
                padding: const EdgeInsets.only(bottom: 20)),
            Container(
                child: Column(children: [
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "Resources/Icons/radio_inactive.png",
                                scale: 4.0,
                              ),
                              Text(
                                " " +
                                    Strings.shared.controllers.term
                                        .terms_terms_title
                                        .substring(0, 12),
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                Strings
                                    .shared.controllers.term.terms_terms_title
                                    .substring(12, 17),
                                style: TextStyle(
                                    color: Statics.shared.colors.mainColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary),
                                textAlign: TextAlign.left,
                              ),
                              FlatButton(
                                  child: Text(
                                    Strings.shared.controllers.term.terms_view,
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.subTitleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary,
                                        decoration: TextDecoration.underline),
                                    textAlign: TextAlign.left,
                                  ),
                                  onPressed: () {},
                                  padding: const EdgeInsets.only(right: 64))
                            ]),
                        onPressed: () {},
                        padding: const EdgeInsets.only(right: 64),
                      ),
                    ]),
              ),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "Resources/Icons/radio_inactive.png",
                                scale: 4.0,
                              ),
                              Text(
                                " " +
                                    Strings.shared.controllers.term
                                        .terms_policy_title
                                        .substring(0, 15),
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                Strings
                                    .shared.controllers.term.terms_policy_title
                                    .substring(15, 20),
                                style: TextStyle(
                                    color: Statics.shared.colors.mainColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary),
                                textAlign: TextAlign.left,
                              ),
                              FlatButton(
                                child: Text(
                                  Strings.shared.controllers.term.terms_view,
                                  style: TextStyle(
                                      color: Statics
                                          .shared.colors.subTitleTextColor,
                                      fontSize: Statics
                                          .shared.fontSizes.supplementary,
                                      decoration: TextDecoration.underline),
                                  textAlign: TextAlign.left,
                                ),
                                onPressed: () {},
                                padding: const EdgeInsets.only(right: 64),
                              )
                            ]),
                        onPressed: () {},
                        padding: const EdgeInsets.only(right: 10),
                      ),
                    ]),
              ),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "Resources/Icons/radio_inactive.png",
                                scale: 4.0,
                              ),
                              Text(
                                " " +
                                    Strings.shared.controllers.term
                                        .terms_notification_title,
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary),
                                textAlign: TextAlign.left,
                              ),
                            ]),
                        onPressed: () {},
                        padding: const EdgeInsets.only(right: 10),
                      ),
                    ]),
              )
            ])),
            SizedBox(height: 40),
          ], //Children
        ), // Column
        padding: const EdgeInsets.only(left: 32, right: 32),

        width: MiddleWare.shared.screenSize,
      ), // Container
    );
  } // user is logged in

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(content: Text(str));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
