import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
import 'package:haegisa2/controllers/sign/SignIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MiddleWare.dart';
import 'dart:async';
import 'dart:convert';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/views/buttons/Buttons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

String jsonMsg = "";

class JoinAlready extends StatefulWidget {
  String idValue = "";
  String passValue = "";
  String passValue2 = "";
  String email = "";

  @override
  _JoinInState createState() => _JoinInState();
}

class _JoinInState extends State<JoinAlready> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  TextEditingController _idController =
      new TextEditingController(text: userInformation.userID);

  void refreshUserInfo(onComplete()) async {
    await SharedPreferences.getInstance().then((val) {
      val
          .setString("app_user_login_info_userid", userInformation.userID)
          .then((val2) {
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    MiddleWare.shared.screenSize = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          centerTitle: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    child: Text("회원님은 이미 \n홈페이지 회원이세요",
                        style: TextStyle(
                            color: Statics.shared.colors.titleTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Statics.shared.fontSizes.title)), // Text
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      bottom: 10,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Text("기존 를",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Statics
                                .shared.fontSizes.supplementary)), // Text
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                      //아이디 입력
                      height: deviceHeight / 10,
                      child: TextField(
                        controller: _idController,
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
                          this.widget.idValue = str;
                        },
                        readOnly: true,
                      ),
                      alignment: Alignment.centerLeft),
                  SizedBox(height: 30),
                  Container(
                    child: Text("비밀번호 재설정",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Statics
                                .shared.fontSizes.supplementary)), // Text
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    child: Text("※ 영문+숫자+특수문자 조합 6~16자리 입력",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Statics.shared.fontSizes.small)), // Text
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                      //비밀번호 입력
                      height: deviceHeight / 10,
                      child: TextField(
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: Statics.shared.fontSizes.subTitle,
                              color: Statics.shared.colors.subTitleTextColor,
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText: "비밀번호 재설정"),
                        obscureText: true, // decoration
                        onChanged: (String str) {
                          this.widget.passValue = str;
                        },
                      ),
                      alignment: Alignment.centerLeft),
                  SizedBox(height: 10),
                  Container(
                      //비밀번호 확인
                      height: deviceHeight / 10,
                      child: TextField(
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: Statics.shared.fontSizes.subTitle,
                              color: Statics.shared.colors.subTitleTextColor,
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText: "비밀번호 재설정 확인"),
                        obscureText: true, // decoration
                        onChanged: (String str) {
                          this.widget.passValue2 = str;
                        },
                      ),
                      alignment: Alignment.centerLeft),
                  SizedBox(height: 20),
                  Container(
                    child: Row(
                      children: [
                        HaegisaButton(
                          text: "로그인",
                          iconURL: "Resources/Icons/Vector_3.2.png",
                          onPressed: () async {
                            if (this.widget.passValue == "" ||
                                this.widget.passValue2 == "") {
                              _displaySnackBar(context,
                                  Strings.shared.controllers.signIn.enterPass);
                              return;
                            }
                            if (this.widget.passValue !=
                                this.widget.passValue2) {
                              _displaySnackBar(context,
                                  Strings.shared.controllers.signIn.findPass);
                              return;
                            } else {
                              //※ 영문+숫자+특수문자 조합 6~16자리 입력 정규식
                              RegExp exp = new RegExp(
                                  r"^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,16}$");
                              print(exp.hasMatch(this.widget.passValue));
                              if (exp.hasMatch(this.widget.passValue) ==
                                  false) {
                                _displaySnackBar(
                                    context,
                                    Strings
                                        .shared.controllers.signIn.findPass2);
                              } else {
                                var map = new Map<String, dynamic>();
                                map["user_id"] = userInformation.userID;
                                map["user_new_pw"] = this.widget.passValue;

                                Result resultPost = await createPost(
                                    Strings.shared.controllers.jsonURL.findPW,
                                    body: map);

                                if (resultPost.code == "200") {
                                  var map = new Map<String, dynamic>();
                                  map["id"] = userInformation.userID;
                                  map["pwd"] = this.widget.passValue;
                                  Result resultPost = await createPost(
                                      Strings
                                          .shared.controllers.jsonURL.loginJson,
                                      body: map);
                                  if (jsonMsg == "ID is Wrong") {
                                    _displaySnackBar(
                                        context,
                                        Strings
                                            .shared.controllers.signIn.wrongID);
                                  } else if (jsonMsg == "PASSWORD is Wrong") {
                                    _displaySnackBar(
                                        context,
                                        Strings.shared.controllers.signIn
                                            .wrongPass);
                                  } else if (jsonMsg == "success") {
                                    await deviceinfo();

                                    userInformation.mode = "login";
                                    userInformation.fullName =
                                        resultPost.memberName;
                                    userInformation.hp = resultPost.hp;
                                    userInformation.loginCheck = 1;
                                    userInformation.userID =
                                        userInformation.userID;
                                    userInformation.memberType =
                                        resultPost.memberType;
                                    userInformation.userIdx =
                                        resultPost.memberIdx;
                                    userInformation.haegisa =
                                        resultPost.haegisa;

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
                                } else {
                                  _displaySnackBar(context,
                                      Strings.shared.controllers.signIn.error);
                                }
                              }
                            }
                          },
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    padding: const EdgeInsets.only(top: 10),
                  ),
                  SizedBox(height: 40),
                ], //Children
              ), // Column
              padding: const EdgeInsets.only(left: 32, right: 32),

              width: MiddleWare.shared.screenSize,
            ), // Container
          ],
        ));
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
        if (url == Strings.shared.controllers.jsonURL.loginJson) {
          for (var result in table) {
            return Result.fromJson(
                result, Strings.shared.controllers.jsonURL.loginJson);
          }
        } else if (url == Strings.shared.controllers.jsonURL.findPW) {
          return Result.fromJson(
              responseJSON, Strings.shared.controllers.jsonURL.loginJson);
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
  final String code;
  final String idx;
  final String memberIdx;
  final String id;
  final String memberName;
  final String hp;
  final String memberType;
  final String haegisa;

  Result(
      {this.code,
      this.idx,
      this.memberIdx,
      this.id,
      this.memberName,
      this.hp,
      this.memberType,
      this.haegisa});

  factory Result.fromJson(Map<String, dynamic> json, String url) {
    if (url == Strings.shared.controllers.jsonURL.loginJson) {
      return Result(
        code: json['code'],
        idx: json['idx'],
        memberIdx: json['member_idx'],
        id: json['id'],
        memberName: json['member_name'],
        hp: json['hp'],
        memberType: json['member_type'],
        haegisa: json['haegisa'],
      );
    } else if (url == Strings.shared.controllers.jsonURL.findPW) {
      return Result(code: json['code']);
    }
  }
}
