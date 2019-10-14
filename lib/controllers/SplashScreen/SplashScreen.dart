import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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
  DateTime backButtonPressTime;
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
        createDir();
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
    userInformation.fullName = resultPost.memberName;
    userInformation.hp = resultPost.hp;
    userInformation.loginCheck = 1;
    userInformation.userID = userId;
    userInformation.memberType = resultPost.memberType;
    userInformation.userIdx = resultPost.memberIdx;
    userInformation.email = resultPost.email;
    userInformation.school = resultPost.school;
    userInformation.gisu = resultPost.gisu;
    userInformation.address1 = resultPost.address1;
    userInformation.address2 = resultPost.address2;
    userInformation.postNo = resultPost.postNo;
    getSchool();
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

  createDir() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    userInformation.dirPath = appDocDirectory;
    var _localPath = appDocDirectory.path + "/Magazines";
    final myDir = new Directory(_localPath);
    myDir.exists().then((dirExist) {
      if (dirExist) {
        print('exists');
      } else {
        print('non-existent');

        new Directory(_localPath).create(recursive: true)
            // The created directory is returned as a Future.
            .then((Directory directory) {
          print('Path of New Dir: ' + directory.path);
        });
      }
    });
  }

  Future<List> getSchool() {
    //한번도 실행되지 않았을때(최초실행)
    return http.post(Strings.shared.controllers.jsonURL.schoolJson, body: {
      'mode': 'search',
      'CHCODE': userInformation.school,
    }).then((http.Response response) {
      final int statusCode = response.statusCode;
      //final String responseBody = response.body; //한글 깨짐
      final String responseBody = utf8.decode(response.bodyBytes);
      var responseJSON = json.decode(responseBody);
      var code = responseJSON["code"];

      if (statusCode == 200) {
        if (code == 200) {
          userInformation.schoolName = responseJSON["table"][0]["CCNAME"];
        }
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    setStatusBar(backgroundColor: Colors.white, isForegroundWhite: false);
    this.checkUserAgree((st) {
      if (st) {
        this.checkUserIsLogin((st) {
          if (st) {
            if (userInformation.mode == "") {
              //아직 로딩이 덜 되었을 경우. (main위젯 로드 후에 정보json를 뒤늦게 파싱)
              setState(() {});
            } else {
              Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new MainTabBar()));
            }
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

    return new Scaffold(
      body: Container(color: Colors.white),
    );
  }

  Future<bool> onWillPop(BuildContext context) async {
    const snackBarDuration = Duration(seconds: 3);

    final snackBar = SnackBar(
      content: Text('Press back again to leave'),
      duration: snackBarDuration,
    );

    DateTime currentTime = DateTime.now();

    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            currentTime.difference(backButtonPressTime) > snackBarDuration;

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = currentTime;
      Scaffold.of(context).showSnackBar(snackBar);
      return false;
    }

    return true;
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
  final String memberIdx;
  final String id;
  final String memberName;
  final String hp;
  final String memberType;
  final String email;
  final String school;
  final String gisu;
  final String address1;
  final String address2;
  final String postNo;

  Result(
      {this.idx,
      this.memberIdx,
      this.id,
      this.memberName,
      this.hp,
      this.memberType,
      this.email,
      this.school,
      this.gisu,
      this.address1,
      this.address2,
      this.postNo});

  factory Result.fromJson(Map<String, dynamic> json, String url) {
    if (url == Strings.shared.controllers.jsonURL.userinfoJson) {
      return Result(
          idx: json['idx'],
          memberIdx: json['member_idx'],
          id: json['id'],
          memberName: json['member_name'],
          hp: json['hp'],
          memberType: json['userType'],
          email: json['email'],
          school: json['school'],
          gisu: json['gisu'],
          address1: json['address1'],
          address2: json['address2'],
          postNo: json['postNo']);
    } else if (url == Strings.shared.controllers.jsonURL.loginJson) {}
  }
}
