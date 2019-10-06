import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:http/http.dart' as http;

class RequestMember extends StatelessWidget {
  double avatarRadius = 30;
  int requestCode;
  String title = "";
  String avatarLink = "";
  String shortDescription = "";
  VoidCallback onTapped;
  bool hasBlueBadge = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  RequestMember(
      {String title = "",
      String avatarLink = "",
      String shortDescription = "",
      VoidCallback onTapped,
      bool hasBlueBadge = true}) {
    this.title = title;
    this.avatarLink = avatarLink;
    this.shortDescription = shortDescription;
    this.onTapped = onTapped;
    this.hasBlueBadge = hasBlueBadge;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    return AlertDialog(
      key: _scaffoldKey,
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height / 1.4,
        width: MediaQuery.of(context).size.width / 1.1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 30),
              child: Image.asset(
                "Resources/Images/requestMember.png",
                scale: 3.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                "정회원으로 전환 신청하기",
                style: TextStyle(
                    color: Statics.shared.colors.mainColor,
                    fontSize: Statics.shared.fontSizes.titleInContent,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width / 1.5,
                color: Statics.shared.colors.lineColor,
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 8, left: 8, right: 8, bottom: 8),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "MERIT",
                        style: TextStyle(
                            color: Statics.shared.colors.mainColor,
                            fontSize:
                                Statics.shared.fontSizes.subTitleInContent,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6),
                      Text(
                        "- 협회내 참여권 및 투표권 행사가능",
                        style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.supplementary,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "- 한국해기사협회지1층  휴게 라운지 무료 이용가능",
                        style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.supplementary,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                )),
            Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Container(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "※ 정회원은 소정의 회비를 납부하고 본 협회의 제 규정과 결의사항을 준수 실천할 의무가 있습니다.",
                        style: TextStyle(
                            color: Statics.shared.colors.subTitleTextColor,
                            fontSize: Statics.shared.fontSizes.supplementary),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "※ 전환신청하시면 협회에서 빠른시간내에 연락드리겠습��다.",
                        style: TextStyle(
                          color: Statics.shared.colors.subTitleTextColor,
                          fontSize: Statics.shared.fontSizes.supplementary,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                )),
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                    child: FlatButton(
                      color: Statics.shared.colors.captionColor,
                      child: Text(
                        "닫기",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Statics.shared.fontSizes.content),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )),
                  Expanded(
                      child: SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                    child: FlatButton(
                      color: Statics.shared.colors.mainColor,
                      child: Text(
                        "신청하기",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Statics.shared.fontSizes.content),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        print("requestMembership");
                        typeSubmit();
                        Navigator.of(context).pop();
                        if (requestCode == 200) {
                          _displaySnackBar(context, "정회원 신청이 완료되었습니다.");
                        } else {
                          _displaySnackBar(
                              context, "오류가 발생하였습니다. 관리자에게 연락바랍니다.");
                        }
                      },
                    ),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 1500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  typeSubmit() {
    var infomap = new Map<String, dynamic>();
    infomap["mode"] = "submit";
    infomap["userId"] = userInformation.userID;

    return http
        .post(Strings.shared.controllers.jsonURL.requestMemberJson,
            body: infomap)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      //final String responseBody = response.body; //한글 깨짐
      final String responseBody = utf8.decode(response.bodyBytes);
      var responseJSON = json.decode(responseBody);
      var code = responseJSON["code"];

      if (statusCode == 200) {
        if (code == 200) {
          // If the call to the server was successful, parse the JSON
          requestCode = 200;
        } else {
          // If that call was not successful, throw an error.
          requestCode = 0;
          throw Exception('Failed to load post');
        }
      } else {
        // If that call was not successful, throw an error.
        requestCode = 0;
        throw Exception('Failed to load post');
      }
    });
  }
}
