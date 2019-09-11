import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String pushState = "";
  @override
  Widget build(BuildContext context) {
    bool _isVisible = true;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    void showToast() {
      setState(() {
        _isVisible = !_isVisible;
      });
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("협회소개",
              style: TextStyle(
                  color: Statics.shared.colors.titleTextColor,
                  fontSize: Statics.shared.fontSizes.title)),
          titleSpacing: 16.0,
          bottom: TabBar(
            labelColor: Statics.shared.colors.titleTextColor,
            labelStyle: (TextStyle(
              fontSize: Statics.shared.fontSizes.subTitle,
            )),
            tabs: [
              Tab(
                text: "협회정보",
              ),
              Tab(text: "조직도"),
            ],
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          centerTitle: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
        ),
        body: TabBarView(
          children: [
            //tab1
            Column(
              children: <Widget>[
                Container(
                  child: Image.asset("Resources/Images/intro.png"),
                )
              ],
            ),
            //tab2
            Column(
              children: <Widget>[
                Container(
                  child: Image.asset("Resources/Images/organization.png"),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Image.asset(
                                "Resources/Images/organization2.png"),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
