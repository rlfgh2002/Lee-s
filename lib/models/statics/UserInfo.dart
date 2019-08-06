import 'package:flutter/material.dart';
import 'package:haegisa2/models/User.dart';
import 'package:haegisa2/models/database/MyDataBase.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io' show Platform;

class _UserInfo {
  static _UserInfo shared = _UserInfo();
  _UserInfo() {}

  String fullName = ""; //이름
  String mode = ""; //회원 모드
  String hp = ""; //휴대폰 번호
  String userDeviceID = ""; //휴대폰 아이디(유니크)
  String userToken = ""; //토큰
  String appVersion = ""; //다운로드한 어플 버전
  String userDeviceOS = ""; //모바일 OS
  String userID = ""; //아이디
  String userIdx = ""; //유저 인덱스
  String gender = ""; //0 : 여자, 1 : 남자
  String birth = ""; //0 : 여자, 1 : 남자
  String agree = "";
  User userData;
  int autoCheck = 0;
  int loginCheck = 0;

  logout() async {
    userInformation.fullName = "";
    userInformation.mode = "";
    userInformation.hp = "";
    userInformation.userDeviceID = "";
    userInformation.userToken = "";
    userInformation.appVersion = "";
    userInformation.userDeviceOS = "";
    userInformation.userID = "";
    userInformation.userIdx = "";
    userInformation.gender = "";
    userInformation.birth = "";
    userInformation.agree = "";
    userInformation.autoCheck = 0;
    userInformation.loginCheck = 0;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("app_user_login_info_islogin", false);
    sharedPreferences.setString("app_user_login_info_userid", "");
  }

  // Other User Information will Store Here...
}

final _UserInfo userInformation = _UserInfo.shared;

Future<Null> deviceinfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    //String appName = packageInfo.appName;
    //String packageName = packageInfo.packageName;
    userInformation.appVersion = packageInfo.version;
    //String buildNumber = packageInfo.buildNumber;
  });

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    userInformation.userDeviceID = androidInfo.androidId;
    userInformation.userDeviceOS = "a";
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    userInformation.userDeviceID = iosInfo.identifierForVendor;
    userInformation.userDeviceOS = "i";
  } else {
    userInformation.userDeviceOS = "e";
  }
}

class UserinfoDB {
  int idx;
  String userIdx;
  String userID;
  String userToken;
  int agree;
  int autoCheck;
  int loginCheck;
  int pushStatus;

  UserinfoDB({
    this.idx,
    this.userIdx,
    this.userID,
    this.userToken,
    this.agree,
    this.autoCheck,
    this.loginCheck,
    this.pushStatus,
  });

  factory UserinfoDB.fromJson(Map<String, dynamic> data) => new UserinfoDB(
        idx: data["idx"],
        userIdx: data["userIdx"],
        userID: data["userID"],
        userToken: data["userToken"],
        agree: data["agree"],
        autoCheck: data["autoCheck"],
        loginCheck: data["loginCheck"],
        pushStatus: data["pushStatus"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "userIdx": userIdx,
        "userID": userID,
        "userToken": userToken,
        "agree": agree,
        "autoCheck": autoCheck,
        "loginCheck": loginCheck,
        "pushStatus": pushStatus,
      };
}

// Future<List> getUserinfo() async {
//   var database = await createDatabase();
//   var result = database.rawQuery('SELECT * FROM userInfo');
//   return result.toList();
// }

getUserinfo() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'my_db.db');
  // open the database
  await openDatabase(path).then((db) {
    List<Map<String, dynamic>> myList = [];
    db.rawQuery("SELECT * FROM tblUserinfo WHERE Id = 1").then((lists) {
      for (int i = 0; i < lists.length; i++) {
        myList.add(lists[i]);
        print(
            ":::::::::: DB SELECT ROW (${i}) => [${lists[i].toString()}] ::::::::::");
        print("list : " + myList[0]['agree'].toString());
      } // for loop
      Map<String, dynamic> resultMap() => {
            "idx": myList[0]['id'].toString(),
            "userIdx": myList[0]['userIdx'].toString(),
            "userID": myList[0]['userID'].toString(),
            "userToken": myList[0]['userToken'].toString(),
            "agree": myList[0]['agree'].toString(),
            "autoCheck": myList[0]['autoCheck'].toString(),
            "loginCheck": myList[0]['loginCheck'].toString(),
            "pushStatus": myList[0]['pushStatus'].parseInt(),
          };
      userInformation.agree = myList[0]['agree'].toString();
      print(userInformation.agree);
      return UserinfoDB.fromJson(resultMap());
    });
    db.close();
  });
}

// getUserinfo() async {
//   var database = await createDatabase();
//   var result = database.rawQuery('SELECT * FROM userInfo WHERE idx = 1');

//   return result;

//   // Map<String, dynamic> resultMap() => {
//   //       "idx": idx,
//   //       "userIdx": userIdx,
//   //       "userID": userID,
//   //       "userToken": userToken,
//   //       "agree": agree,
//   //       "autoCheck": autoCheck,
//   //       "loginCheck": loginCheck,
//   //       "pushStatus": pushStatus,
//   //     };

//   //return Userinfo.fromJson(resultMap());
// }
