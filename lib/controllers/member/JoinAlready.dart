import 'package:flutter/material.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
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
          title: Text(Strings.shared.controllers.signIn.forgetPasswordTitle),
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
                    child: Text("기존 아이디",
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
                            if (this.widget.idValue == "") {
                              _displaySnackBar(context,
                                  Strings.shared.controllers.signIn.enterID);
                              return;
                            }
                            if (this.widget.idValue.length < 6) {
                              _displaySnackBar(context,
                                  Strings.shared.controllers.signIn.findID3);
                              return;
                            }
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

                                map = new Map<String, dynamic>();
                                map["mode"] = "insert";
                                map["member_idx"] = userInformation.userIdx;
                                map["user_id"] = this.widget.idValue;
                                map["password"] = this.widget.passValue;
                                map["email"] = this.widget.email;
                                map["member_name"] = userInformation.fullName;
                                map["USER_PHONE"] = userInformation.hp;
                                map["USER_JUMIN"] = userInformation.birth;

                                Result memberJoin = await createPost(
                                    Strings.shared.controllers.jsonURL.joinJson,
                                    body: map);

                                if (memberJoin.code != "200") {
                                  _displaySnackBar(context,
                                      Strings.shared.controllers.signIn.error2);
                                } else {
                                  await deviceinfo();

                                  userInformation.mode = "login";
                                  userInformation.loginCheck = 1;
                                  userInformation.userID = this.widget.idValue;

                                  var map = new Map<String, dynamic>();
                                  map["user_id"] = this.widget.idValue;
                                  map["user_phone"] = userInformation.hp;
                                  map["reg_key"] = userInformation.userToken;
                                  map["os_type"] = userInformation.userDeviceOS;
                                  map["os_version"] = "";
                                  map["app_version"] =
                                      userInformation.appVersion;
                                  map["device_id"] =
                                      userInformation.userDeviceID;
                                  map["push_status"] = "y";
                                  await createPost(
                                      Strings.shared.controllers.jsonURL
                                          .logininfoJson,
                                      body: map);

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('가입완료'),
                                          content: Text(
                                              "회원가입이 완료되었습니다.\n가입된 아이디로 로그인 해주십시오."),
                                          actions: <Widget>[
                                            new FlatButton(
                                              child: new Text('확인'),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (context) =>
                                                            new SplashScreen()));
                                              },
                                            )
                                          ],
                                        );
                                      });
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

//JSON 데이터
class School {
  School({
    this.chcode,
    this.ccname,
  });

  final String chcode;
  final String ccname;
}
