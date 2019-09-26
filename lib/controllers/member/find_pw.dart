import 'package:flutter/material.dart';
import 'package:haegisa2/controllers/sign/SignIn.dart';
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
import 'package:flutter/services.dart';

String passValue = "";
String passValue2 = "";
String jsonMsg = "";

class FindPW extends StatefulWidget {
  @override
  _FindInState createState() => _FindInState();
}

class _FindInState extends State<FindPW> {
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Strings.shared.controllers.signIn.forgetPasswordTitle),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(top: 80, bottom: 10),
                child: TextField(
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: Statics.shared.fontSizes.subTitle,
                        color: Statics.shared.colors.subTitleTextColor,
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: Strings.shared.controllers.signIn.txtHintPass),
                  obscureText: true, // decoration
                  onChanged: (String str) {
                    passValue = str;
                  },
                ),
                alignment: Alignment.centerLeft),
            SizedBox(height: 5),
            Container(
                child: TextField(
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: Statics.shared.fontSizes.subTitle,
                        color: Statics.shared.colors.subTitleTextColor,
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: Strings.shared.controllers.signIn.txtHintPass2),
                  obscureText: true, // decoration
                  onChanged: (String str) {
                    passValue2 = str;
                  },
                ),
                alignment: Alignment.centerLeft),
            SizedBox(height: 5),
            Container(
                child: Row(
                  children: [
                    FlatButton(
                      child: Row(children: [
                        Text(Strings.shared.controllers.signIn.change,
                            style: TextStyle(
                                color: Statics.shared.colors.titleTextColor,
                                fontSize:
                                    Statics.shared.fontSizes.supplementary)),
                        Image.asset('Resources/Icons/btn_next_blue.png',
                            width: 28, height: 28),
                      ]),
                      onPressed: () async {
                        if (passValue == "" || passValue2 == "") {
                          _displaySnackBar(context,
                              Strings.shared.controllers.signIn.enterPass);
                          return;
                        }
                        if (passValue != passValue2) {
                          _displaySnackBar(context,
                              Strings.shared.controllers.signIn.findPass);
                        } else {
                          //※ 영문+숫자+특수문자 조합 6~16자리 입력 정규식
                          RegExp exp = new RegExp(
                              r"^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,16}$");
                          print(exp.hasMatch(passValue));
                          if (exp.hasMatch(passValue) == false) {
                            _displaySnackBar(context,
                                Strings.shared.controllers.signIn.findPass2);
                          } else {
                            var map = new Map<String, dynamic>();
                            map["user_id"] = userInformation.userID;
                            map["user_new_pw"] = passValue;

                            Result resultPost = await createPost(
                                Strings.shared.controllers.jsonURL.findPW,
                                body: map);

                            if (resultPost.code == "200") {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new SignIn()));
                            } else {
                              _displaySnackBar(context,
                                  Strings.shared.controllers.signIn.error);
                            }
                          }
                        }
                      },
                    ),
                  ], // Row Children
                  mainAxisAlignment: MainAxisAlignment.center,
                ), // Row
                alignment: Alignment.center),
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
      return Result.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  });
}

//JSON 데이터
class Result {
  final String code;

  Result({this.code});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      code: json['code'],
    );
  }
}
