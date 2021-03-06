import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
import 'package:haegisa2/controllers/auth/auth.dart';
import 'package:haegisa2/controllers/member/JoinAlready.dart';
import 'package:haegisa2/controllers/member/join.dart';
import 'package:url_launcher/url_launcher.dart';
import 'MiddleWare.dart';
import 'dart:async';
import 'dart:convert';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignAuth.dart';

String idValue = "";
String passValue = "";
String jsonMsg = "";

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _idChecked = false;
  bool _pwdChecked = false;

  void refreshUserInfo(onComplete()) async {
    await SharedPreferences.getInstance().then((val) {
      val.setString("app_user_login_info_userid", idValue).then((val2) {
        if (val2) {
          val.setBool("app_user_login_info_islogin", true).then((val3) {
            if (val3) {
              onComplete();
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    MiddleWare.shared.screenSize = MediaQuery.of(context).size.width;

    _firebaseMessaging.getToken().then((token) {
      userInformation.userToken = token; // Print the Token in Console
    });

    _firebaseMessaging.getToken().then((token) {
      userInformation.userToken = token; // Print the Token in Console
    });

    return new WillPopScope(
        onWillPop: () async => _onBackPressed(),
        child: new Scaffold(
          key: _scaffoldKey,
          body: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Text(
                      Strings.shared.controllers.signIn.title1,
                      style: TextStyle(
                        fontSize: Statics.shared.fontSizes.title,
                        color: Statics.shared.colors.titleTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.centerLeft),
                Container(
                    child: Text(
                      Strings.shared.controllers.signIn.title2,
                      style: TextStyle(
                          fontSize: Statics.shared.fontSizes.title,
                          color: Statics.shared.colors.mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.centerLeft),
                Container(
                    child: Text(
                      Strings.shared.controllers.signIn.subTitle,
                      style: TextStyle(
                        fontSize: Statics.shared.fontSizes.subTitle,
                        color: Color(0xFF333364B),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 20)),
                SizedBox(height: 25),

                //아이디 입력
                Container(
                    child: TextField(
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: Statics.shared.fontSizes.subTitle,
                            color: Statics.shared.colors.subTitleTextColor,
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.perm_identity),
                          hintText: Strings.shared.controllers.signIn
                              .txtHintUser), // decoration
                      onChanged: (String str) {
                        idValue = str;
                        if (str.length > 0) {
                          _idChecked = true;
                        } else {
                          _idChecked = false;
                        }
                      },
                    ),
                    alignment: Alignment.centerLeft),
                SizedBox(height: 10),

                //패스워드 입력
                Container(
                    child: TextField(
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: Statics.shared.fontSizes.subTitle,
                            color: Statics.shared.colors.subTitleTextColor,
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock_outline),
                          hintText:
                              Strings.shared.controllers.signIn.txtHintPass),
                      obscureText: true, // decoration
                      onChanged: (String str) {
                        passValue = str;
                        if (str.length > 0) {
                          _pwdChecked = true;
                        } else {
                          _pwdChecked = false;
                        }
                      },
                    ),
                    alignment: Alignment.centerLeft),
                SizedBox(height: 5),
                Container(
                    child: Row(
                      children: [
                        FlatButton(
                          child: Text(
                              Strings.shared.controllers.signIn.findIDTitle,
                              style: TextStyle(
                                  color: Statics.shared.colors.titleTextColor,
                                  fontSize: Statics
                                      .shared.fontSizes.supplementary)), // Text
                          onPressed: () {
                            userInformation.mode = "find_id";
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new Auth()));
                          },
                          padding: const EdgeInsets.all(0),
                        ), // Flat Button -> FindID
                        Text("  |  ",
                            style: TextStyle(
                                color:
                                    Statics.shared.colors.subTitleTextColor)),
                        FlatButton(
                          child: Text(
                              Strings.shared.controllers.signIn
                                  .forgetPasswordTitle,
                              style: TextStyle(
                                  color: Statics.shared.colors.titleTextColor,
                                  fontSize: Statics
                                      .shared.fontSizes.supplementary)), // Text
                          onPressed: () {
                            userInformation.mode = "find_pw";
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new Auth()));
                          },
                          padding: const EdgeInsets.all(0),
                        ), // Flat Button -> ForgetPassword
                      ], // Row Children
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                    ), // Row
                    alignment: Alignment.centerRight),

                Container(
                    height: 60,
                    alignment: FractionalOffset.bottomCenter,
                    child: new SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.all(20),
                        color: _idChecked && _pwdChecked
                            ? Statics.shared.colors.mainColor
                            : Statics.shared.colors.subTitleTextColor,
                        child: Text(
                            Strings.shared.controllers.signIn.loginBtnTitle,
                            style: TextStyle(
                                fontSize: Statics.shared.fontSizes.subTitle,
                                color: Colors.white)),
                        onPressed: () async {
                          if (_idChecked == true && _pwdChecked) {
                            if (trim(idValue) == "") {
                              _displaySnackBar(context,
                                  Strings.shared.controllers.signIn.enterID);
                            } else if (trim(passValue) == "") {
                              _displaySnackBar(context,
                                  Strings.shared.controllers.signIn.enterPass);
                            }

                            var map = new Map<String, dynamic>();
                            map["id"] = idValue;
                            map["pwd"] = passValue;
                            Result resultPost = await createPost(
                                Strings.shared.controllers.jsonURL.loginJson,
                                body: map);
                            if (jsonMsg == "ID is Wrong") {
                              _displaySnackBar(context,
                                  Strings.shared.controllers.signIn.wrongID);
                            } else if (jsonMsg == "PASSWORD is Wrong") {
                              _displaySnackBar(context,
                                  Strings.shared.controllers.signIn.wrongPass);
                            } else if (jsonMsg == "success") {
                              await deviceinfo();

                              userInformation.mode = "login";
                              userInformation.fullName = resultPost.memberName;
                              userInformation.hp = resultPost.hp;
                              userInformation.loginCheck = 1;
                              userInformation.userID = idValue;
                              userInformation.memberType =
                                  resultPost.memberType;
                              userInformation.userIdx = resultPost.memberIdx;
                              userInformation.haegisa = resultPost.haegisa;

                              _firebaseMessaging.getToken().then((token) {
                                print(token);
                                userInformation.userToken = token;
                              });

                              this.refreshUserInfo(() {
                                Navigator.pushReplacement(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            new SplashScreen()));
                              });
                            }
                          }
                        },
                      ),
                    )),
                Row(children: <Widget>[
                  Expanded(child: Divider(height: 30)),
                ]),
                Container(
                    height: 60,
                    alignment: FractionalOffset.bottomCenter,
                    child: new SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Statics.shared.colors.mainColor, width: 1),
                        ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.all(20),
                        color: Colors.white,
                        child: Text(Strings.shared.controllers.signIn.joinTitle,
                            style: TextStyle(
                                fontSize: Statics.shared.fontSizes.subTitle,
                                color: Statics.shared.colors.mainColor)),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new SignAuth()));
                        },
                      ),
                    )),
              ], //Children
            ), // Column
            padding: const EdgeInsets.only(left: 32, right: 32),
            width: MiddleWare.shared.screenSize,
          ), // Container
        ));
  } // user is logged in

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 1500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget authAlert() {
    var height;
    if (userInformation.userDeviceOS == "i") {
      height = MediaQuery.of(context).size.height / 1.2;
    } else {
      height = MediaQuery.of(context).size.height / 1.6;
    }
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
        height: height,
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
                            Navigator.pushReplacement(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new SplashScreen()));
                          },
                        ),
                      ],
                    ))))
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => AlertDialog(
              title: new Text("앱 종료"),
              content: new Text("앱을 종료하시겠습니까?",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: Statics.shared.fontSizes.supplementary)),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("취소",
                      style: TextStyle(
                          fontSize: Statics.shared.fontSizes.supplementary,
                          color: Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text(
                    "종료",
                    style: TextStyle(
                        fontSize: Statics.shared.fontSizes.supplementary,
                        color: Colors.red),
                  ),
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                ),
              ],
            ));
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
        if (url == Strings.shared.controllers.jsonURL.loginJson) {
          for (var result in table) {
            return Result.fromJson(
                result, Strings.shared.controllers.jsonURL.loginJson);
          }
        } else if (url == Strings.shared.controllers.jsonURL.logininfoJson) {
          //nothing
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
  final String memberIdx;
  final String id;
  final String memberName;
  final String hp;
  final String memberType;
  final String haegisa;

  Result(
      {this.idx,
      this.memberIdx,
      this.id,
      this.memberName,
      this.hp,
      this.memberType,
      this.haegisa});

  factory Result.fromJson(Map<String, dynamic> json, String url) {
    if (url == Strings.shared.controllers.jsonURL.loginJson) {
      return Result(
        idx: json['idx'],
        memberIdx: json['member_idx'],
        id: json['id'],
        memberName: json['member_name'],
        hp: json['hp'],
        memberType: json['member_type'],
        haegisa: json['haegisa'],
      );
    } else if (url == Strings.shared.controllers.jsonURL.loginJson) {}
  }
}
