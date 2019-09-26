import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AlarmAgree extends StatefulWidget {
  @override
  _AlarmAgreeState createState() => _AlarmAgreeState();
}

class _AlarmAgreeState extends State<AlarmAgree> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String pushState = "";
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    SharedPreferences.getInstance().then((val) {
      if (pushState == "") {
        setState(() {
          if (val.getBool("user_pushStatus") == true) {
            pushState = "y";
          } else {
            pushState = "n";
          }
        });
      }
    });

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("알림 수신동의",
              style: TextStyle(
                  color: Statics.shared.colors.titleTextColor,
                  fontSize: Statics.shared.fontSizes.subTitle,
                  fontWeight: FontWeight.bold)),
          titleSpacing: 16.0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          centerTitle: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 10,
              color: Statics.shared.colors.lineColor,
              padding: const EdgeInsets.only(top: 20),
            ),
            Container(
                height: deviceWidth / 5,
                padding: const EdgeInsets.only(left: 20),
                child: Row(children: <Widget>[
                  Text(
                    "알림 수신동의",
                    style: TextStyle(
                        color: Statics.shared.colors.titleTextColor,
                        fontSize: Statics.shared.fontSizes.subTitleInContent),
                    textAlign: TextAlign.left,
                  ),
                  Spacer(),
                  SizedBox(
                    child: FlatButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: pushState == "y"
                          ? Image.asset('Resources/Icons/push_on.png',
                              scale: 3.0)
                          : Image.asset('Resources/Icons/push_off.png',
                              scale: 3.0),
                      onPressed: () {
                        //setpushState가 이후에 실행이 된다.
                        if (pushState == "n") {
                          _displaySnackBar(context, "푸시알림 받기를 동의하셨습니다.");
                        } else if (pushState == "y") {
                          _displaySnackBar(context, "푸시알림 받기를 거절하셨습니다.");
                        }
                        setpushState();
                      },
                    ),
                  )
                ])),
            Container(
              height: deviceHeight,
              color: Statics.shared.colors.lineColor,
              padding: const EdgeInsets.only(top: 20),
            ),
          ],

          // Container
        ));
  }

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 1500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  setpushState() {
    SharedPreferences.getInstance().then((val) {
      setState(() {
        if (val.getBool("user_pushStatus") == true) {
          pushState = "n";
          val.setBool("user_pushStatus", false);
        } else {
          pushState = "y";
          val.setBool("user_pushStatus", true);
        }

        var infomap = new Map<String, dynamic>();
        infomap["user_id"] = userInformation.userID;
        infomap["user_phone"] = userInformation.hp;
        infomap["reg_key"] = userInformation.userToken;
        infomap["os_type"] = userInformation.userDeviceOS;
        infomap["os_version"] = "";
        infomap["app_version"] = userInformation.appVersion;
        infomap["device_id"] = userInformation.userDeviceID;
        infomap["push_status"] = pushState;
        alarmAgree(Strings.shared.controllers.jsonURL.logininfoJson,
            body: infomap);
      });
    });
  }

  alarmAgree(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;
      //final String responseBody = response.body; //한글 깨짐
      final String responseBody = utf8.decode(response.bodyBytes);
      var responseJSON = json.decode(responseBody);
      var code = responseJSON["code"];

      if (statusCode == 200) {
        if (code == 200) {
          // If the call to the server was successful, parse the JSON
        } else {
          throw Exception('Failed to load post');
        }
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }
}
