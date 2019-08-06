import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:haegisa2/controllers/sign/SignSelect.dart';
import 'package:haegisa2/controllers/Auth/Terms.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkUserAgree(onComplete(bool res)) async {
    await SharedPreferences.getInstance().then((val) {
      bool status = val.getBool("user_agree");
      if (status == false || status == null) {
        onComplete(false);
      } else {
        onComplete(true);
      }
    });
  }

  void checkUserIsLogin(onComplete(bool res)) async {
    await SharedPreferences.getInstance().then((val) {
      bool status = val.getBool("app_user_login_info_islogin");
      if (status == false || status == null) {
        onComplete(false);
      } else {
        onComplete(true);
        getUserinfoJson();
      }
    });
  }

  getUserinfoJson() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String userId = "";
    String pushState = "n";
    await SharedPreferences.getInstance().then((val) {
      userId = val.getString("app_user_login_info_userid");
      if (val.getBool("user_pushStatus") == true) {
        pushState = "y";
      }
    });

    var map = new Map<String, dynamic>();
    map["id"] = userId;
    Result resultPost = await createPost(
        Strings.shared.controllers.jsonURL.userinfoJson,
        body: map);

    await deviceinfo();

    userInformation.mode = "login";
    userInformation.fullName = resultPost.member_name;
    userInformation.hp = resultPost.hp;
    userInformation.loginCheck = 1;
    userInformation.userID = userId;
    _firebaseMessaging.getToken().then((token) {
      print(token);
      userInformation.userToken = token;
    });

    var infomap = new Map<String, dynamic>();
    infomap["user_id"] = userId;
    infomap["user_phone"] = userInformation.hp;
    infomap["reg_key"] = userInformation.userToken;
    infomap["os_type"] = userInformation.userDeviceOS;
    infomap["os_version"] = "";
    infomap["app_version"] = userInformation.appVersion;
    infomap["device_id"] = userInformation.userDeviceID;
    infomap["push_status"] = pushState;
    await createPost(Strings.shared.controllers.jsonURL.logininfoJson,
        body: infomap);
  }

  @override
  Widget build(BuildContext context) {
    this.checkUserAgree((st) {
      if (st) {
        this.checkUserIsLogin((st) {
          if (st) {
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => new MainTabBar()));
          } // user is logged in
          else {
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => new SignSelect()));
          } // user is Not logged in
        });
      } // user is logged in
      else {
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => new TermsPage()));
      } // user is Not logged in
    });

    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Container(color: Colors.white),
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
        if (url == Strings.shared.controllers.jsonURL.userinfoJson) {
          for (var result in table) {
            return Result.fromJson(
                result, Strings.shared.controllers.jsonURL.userinfoJson);
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
    if (url == Strings.shared.controllers.jsonURL.userinfoJson) {
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
