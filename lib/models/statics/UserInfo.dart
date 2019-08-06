import 'package:flutter/material.dart';
import 'package:haegisa2/models/User.dart';
import 'package:haegisa2/models/database/dbConfig.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'package:sqflite/sqflite.dart';
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
  User userData;
  int autoCheck = 0;
  int lognCheck = 0;

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
  int lognCheck;
  int pushStatus;

  UserinfoDB({
    this.idx,
    this.userIdx,
    this.userID,
    this.userToken,
    this.agree,
    this.autoCheck,
    this.lognCheck,
    this.pushStatus,
  });

  factory UserinfoDB.fromJson(Map<String, dynamic> data) => new UserinfoDB(
        idx: data["idx"],
        userIdx: data["userIdx"],
        userID: data["userID"],
        userToken: data["userToken"],
        agree: data["agree"],
        autoCheck: data["autoCheck"],
        lognCheck: data["lognCheck"],
        pushStatus: data["pushStatus"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "userIdx": userIdx,
        "userID": userID,
        "userToken": userToken,
        "agree": agree,
        "autoCheck": autoCheck,
        "lognCheck": lognCheck,
        "pushStatus": pushStatus,
      };
}

// Future<List> getUserinfo() async {
//   var database = await createDatabase();
//   var result = database.rawQuery('SELECT * FROM userInfo');
//   return result.toList();
// }

getUserinfo() async {
  Database db = await DatabaseHelper.instance.database;
  var result = await db.rawQuery('SELECT * FROM userInfo WHERE idx = 1');
  Map<String, dynamic> resultMap() => {
        "idx": result[0]['idx'],
        "userIdx": result[0]['userIdx'],
        "userID": result[0]['userID'],
        "userToken": result[0]['userToken'],
        "agree": result[0]['agree'],
        "autoCheck": result[0]['autoCheck'],
        "lognCheck": result[0]['lognCheck'],
        "pushStatus": result[0]['pushStatus'],
      };
  return UserinfoDB.fromJson(resultMap());
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
//   //       "lognCheck": lognCheck,
//   //       "pushStatus": pushStatus,
//   //     };

//   //return Userinfo.fromJson(resultMap());
// }
