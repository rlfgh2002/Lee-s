import 'package:flutter/material.dart';
import 'package:haegisa2/controllers/auth/auth.dart';
import 'package:haegisa2/main.dart';
import 'MiddleWare.dart';
import 'dart:async';
import 'dart:convert';
import 'package:haegisa2/controllers/member/find_pw.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/views/buttons/Buttons.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void refreshUserInfo(onComplete()) async {
    await SharedPreferences.getInstance().then((val){
      val.setString("app_user_login_info_userid", idValue).then((val2){
        if(val2){
          val.setBool("app_user_login_info_islogin", true).then((val3){
            if(val3){
              onComplete();
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MiddleWare.shared.screenSize = MediaQuery.of(context).size.width;

    _firebaseMessaging.getToken().then((token) {
      userInformation.userToken = token; // Print the Token in Console
    });

    _firebaseMessaging.getToken().then((token) {
      userInformation.userToken = token; // Print the Token in Console
    });

    return Scaffold(
      key: _scaffoldKey,
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
                  Strings.shared.controllers.signIn.title1,
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.title,
                    color: Statics.shared.colors.titleTextColor,
                  ),
                ),
                alignment: Alignment.centerLeft),
            Container(
                child: Text(
                  Strings.shared.controllers.signIn.title2,
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.title,
                    color: Statics.shared.colors.mainColor,
                  ),
                ),
                alignment: Alignment.centerLeft),
            Container(
                child: Text(
                  Strings.shared.controllers.signIn.subTitle,
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.subTitle,
                    color: Statics.shared.colors.subTitleTextColor,
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(right: 64, top: 20)),
            SizedBox(height: 40),

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
                      hintText: Strings
                          .shared.controllers.signIn.txtHintUser), // decoration
                  onChanged: (String str) {
                    idValue = str;
                  },
                ),
                alignment: Alignment.centerLeft),
            SizedBox(height: 15),

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
                      hintText: Strings.shared.controllers.signIn.txtHintPass),
                  obscureText: true, // decoration
                  onChanged: (String str) {
                    passValue = str;
                  },
                ),
                alignment: Alignment.centerLeft),
            SizedBox(height: 5),
            Container(
                child: Row(
                  children: [
                    FlatButton(
                      child: Text(Strings.shared.controllers.signIn.findIDTitle,
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
                            color: Statics.shared.colors.subTitleTextColor)),
                    FlatButton(
                      child: Text(
                          Strings.shared.controllers.signIn.forgetPasswordTitle,
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
              child: Row(
                children: [
                  HeagisaButton(
                    text: Strings.shared.controllers.signIn.loginBtnTitle,
                    iconURL: "Resources/Icons/Vector 3.2.png",
                    onPressed: () async {

                      if (trim(idValue) == "") {
                        _displaySnackBar(
                            context, Strings.shared.controllers.signIn.enterID);
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
                        _displaySnackBar(
                            context, Strings.shared.controllers.signIn.wrongID);
                      } else if (jsonMsg == "PASSWORD is Wrong") {
                        _displaySnackBar(context,
                            Strings.shared.controllers.signIn.wrongPass);
                      } else if (jsonMsg == "no haegisa member") {
                        //해기사 회원이 아닐 시 팝업
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
                                  padding: const EdgeInsets.only(
                                      top: 40, bottom: 10),
                                  child: Text(
                                    Strings
                                        .shared.controllers.signSelect.title3,
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                      Text(
                                        Strings.shared.controllers.signSelect
                                            .title3_1
                                            .substring(0, 13),
                                        style: TextStyle(
                                            color: Statics
                                                .shared.colors.titleTextColor,
                                            fontSize: Statics
                                                .shared.fontSizes.subTitle,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        Strings.shared.controllers.signSelect
                                            .title3_1
                                            .substring(13, 14),
                                        style: TextStyle(
                                            color: Statics
                                                .shared.colors.titleTextColor,
                                            fontSize: Statics
                                                .shared.fontSizes.content),
                                        textAlign: TextAlign.center,
                                      ),
                                    ])),
                                Expanded(
                                  child: Text(
                                    Strings
                                        .shared.controllers.signSelect.title3_1
                                        .substring(14, 28),
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize:
                                            Statics.shared.fontSizes.content),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                    // This align moves the children to the bottom
                                    child: Align(
                                        alignment:
                                            FractionalOffset.bottomCenter,
                                        // This container holds all the children that will be aligned
                                        // on the bottom and should not scroll with the above ListView
                                        child: Container(
                                            child: Column(
                                          children: <Widget>[
                                            Image.asset(
                                              'Resources/Icons/Line2.png',
                                            ),
                                            FlatButton(
                                              padding: const EdgeInsets.only(
                                                  top: 30, bottom: 30),
                                              child: Text(
                                                Strings.shared.controllers
                                                    .signSelect.confirm,
                                                style: TextStyle(
                                                    color: Statics.shared.colors
                                                        .titleTextColor,
                                                    fontSize: Statics.shared
                                                        .fontSizes.content),
                                                textAlign: TextAlign.center,
                                              ),
                                              onPressed: () {
                                                userInformation.lognCheck = 0;

                                                print("LOGGGGG XXX OUT");

                                                this.refreshUserInfo((){

                                                  Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(
                                                          builder: (context) =>
                                                          new MyApp()));

                                                });

                                              },
                                            ),
                                          ],
                                        ))))
                              ],
                            ),
                          ),
                        );
                      } else if (jsonMsg == "success") {

                        await deviceinfo();

                        userInformation.mode = "login";
                        userInformation.fullName = resultPost.member_name;
                        userInformation.hp = resultPost.hp;
                        userInformation.lognCheck = 1;
                        userInformation.userID = idValue;

                        var map = new Map<String, dynamic>();
                        map["user_id"] = idValue;
                        map["user_phone"] = userInformation.hp;
                        map["reg_key"] = userInformation.userToken;
                        map["os_type"] = userInformation.userDeviceOS;
                        map["os_version"] = "";
                        map["app_version"] = userInformation.appVersion;
                        map["device_id"] = userInformation.userDeviceID;
                        map["push_status"] = "y";
                        await createPost(
                            Strings.shared.controllers.jsonURL.logininfoJson,
                            body: map);

                        this.refreshUserInfo((){

                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                  new MyApp()));

                        });
                      }
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              padding: const EdgeInsets.only(top: 100),
            ),
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
  final String member_idx;
  final String id;
  final String member_name;
  final String hp;

  Result({this.idx, this.member_idx, this.id, this.member_name, this.hp});

  factory Result.fromJson(Map<String, dynamic> json, String url) {
    if (url == Strings.shared.controllers.jsonURL.loginJson) {
      return Result(
        idx: json['idx'],
        member_idx: json['member_idx'],
        id: json['id'],
        member_name: json['member_name'],
        hp: json['hp'],
      );
    } else if (url == Strings.shared.controllers.jsonURL.loginJson) {}
  }
}
