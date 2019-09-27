import 'package:haegisa2/models/User.dart';
import 'package:device_info/device_info.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io' show Directory, Platform;

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
  String memberType = ""; // 1:정회원 2:준회원
  String email; //이메일
  String school; //학교코드
  String gisu; //기수
  Directory dirPath; //첨부파일 다운로드 기본경로

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
    userInformation.memberType = "";
    userInformation.email = "";
    userInformation.school = "";
    userInformation.gisu = "";
    userInformation.dirPath;

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

    Statics.shared.fontSizes.title = 26;
    Statics.shared.fontSizes.subTitle = 16;
    Statics.shared.fontSizes.titleInContent = 20;
    Statics.shared.fontSizes.subTitleInContent = 16;

    Statics.shared.fontSizes.contentBig = 20;
    Statics.shared.fontSizes.supplementaryBig = 17;

    Statics.shared.fontSizes.content = 16;
    Statics.shared.fontSizes.supplementary = 14;

    Statics.shared.fontSizes.medium = 14;
    Statics.shared.fontSizes.small = 13;

    Statics.shared.fontSizes.verySmall = 11;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    userInformation.userDeviceID = iosInfo.identifierForVendor;
    userInformation.userDeviceOS = "i";
  } else {
    userInformation.userDeviceOS = "e";
  }
}
