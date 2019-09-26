import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

String idValue = "";
String passValue = "";
String jsonMsg = "";

class SignAuth extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignAuth> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    MiddleWare.shared.screenSize = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        centerTitle: false,
        elevation: 0,
        key: _scaffoldKey,
        iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
                child: Text(
                  Strings.shared.controllers.signSelect.title4,
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
                  Strings.shared.controllers.signSelect.title5,
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
                  child: Image.asset(
                    "Resources/Icons/btn_certi.png",
                    scale: 2.0,
                  ),
                  onPressed: () {
                    userInformation.mode = "join";
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new Auth()));
                  },
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 20)),
            SizedBox(height: 40),
          ], //Children
        ), // Column
        padding: const EdgeInsets.only(left: 32, right: 32),

        width: MiddleWare.shared.screenSize,
      ), // Container
    );
  } // user is logged in

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 1500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

Future<Result> createPost(String url, {Map body}) async {
  jsonMsg = "";
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;
    //final String responseBody = response.body; //한글 깨짐
    final String responseBody = utf8.decode(response.bodyBytes);
    var responseJSON = json.decode(responseBody);
    var code = responseJSON["code"];
    jsonMsg = responseJSON['msg'];

    if (statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var table = responseJSON["table"];
      if (code == "200") {
        for (var result in table) {
          return Result.fromJson(result);
        }
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  });
}

//JSON 데이터
class Result {
  final String idx;
  final String member_idx;
  final String id;
  final String member_name;

  Result({this.idx, this.member_idx, this.id, this.member_name});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      idx: json['idx'],
      member_idx: json['member_idx'],
      id: json['id'],
      member_name: json['member_name'],
    );
  }
}
