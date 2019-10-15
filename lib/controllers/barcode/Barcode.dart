import 'dart:convert';

import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_flutter/barcode_flutter.dart';

int requestCode;

class Barcode extends StatefulWidget {
  @override
  _BarcodeState createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          title: Container(
              child: Text("출입증",
                  style: TextStyle(
                      color: Statics.shared.colors.titleTextColor,
                      fontSize: Statics.shared.fontSizes.subTitle,
                      fontWeight: FontWeight.bold)),
              margin: const EdgeInsets.only(left: 8)),
          centerTitle: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
        ),
        body: Container(
            alignment: Alignment.center,
            color: Statics.shared.colors.mainBackgroundVeryLightSilverBlue,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                memberType(userInformation.memberType)
              ],
            )));
  }

  Widget memberType(String code) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    if (code == "51001") {
      return Column(
        children: <Widget>[
          Image.asset(
            "Resources/Images/barcodeType1.png",
            width: deviceWidth / 1.12,
          ),
          Container(
              padding: new EdgeInsets.only(left: 20.0, right: 20.0),
              constraints: new BoxConstraints.expand(
                  height: deviceHeight / 1.5, width: deviceWidth / 1.1),
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage('Resources/Images/bgBarcode.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: new EdgeInsets.only(
                          top: deviceHeight / 10, bottom: deviceHeight / 20),
                      child: Image.asset("Resources/Images/barcodeLounge.png",
                          scale: 3.0)),
                  Container(
                      alignment: Alignment.center,
                      height: deviceHeight / 8,
                      child: new BarCodeImage(
                        data:
                            userInformation.userIdx, // Code string. (required)
                        codeType: BarCodeType.Code39, // Code type (required)
                        lineWidth:
                            1.8, // width for a single black/white bar (default: 2.0)
                        barHeight: deviceHeight /
                            8, // height for the entire widget (default: 100.0)
                        hasText:
                            false, // Render with text label or not (default: false)
                        onError: (error) {
                          // Error handler
                          print('error = $error');
                        },
                      )),
                  Container(
                    alignment: Alignment.center,
                    padding: new EdgeInsets.only(
                        top: deviceHeight / 10, bottom: deviceHeight / 20),
                    child: Text(
                        "회원님은 해기사들의 복합 문화 공간인 라운지M(한국해기사협회 빌딩 1층)을 자유롭게 이용 가능하십니다",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.supplementary,
                        )),
                  ),
                ],
              ))
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Image.asset(
            "Resources/Images/barcodeType2.png",
            width: deviceWidth / 1.12,
          ),
          Container(
              padding: new EdgeInsets.only(left: 20.0, right: 20.0),
              constraints: new BoxConstraints.expand(
                  height: deviceHeight / 1.5, width: deviceWidth / 1.1),
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage('Resources/Images/bgBarcode.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: new EdgeInsets.only(
                        top: deviceHeight / 10, bottom: deviceHeight / 20),
                    child: Image.asset("Resources/Images/barcodeLounge.png",
                        scale: 3.0),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: new EdgeInsets.only(
                      top: deviceHeight / 20,
                    ),
                    child: Text(
                        "원이 되시면 해기사들의 복합 문화 공간인 라운지M(한국해기사협회 빌딩 1층)을 자유롭게 이용 가능하십니다.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.supplementary,
                        )),
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: new EdgeInsets.only(
                        top: deviceHeight / 20,
                      ),
                      child: FlatButton(
                          child: Text("정회원으로 전환하기 >",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Statics.shared.colors.mainColor,
                                  fontSize: Statics
                                      .shared.fontSizes.subTitleInContent,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (_) => authAlert());
                          })),
                ],
              )),
        ],
      );
    }
  }

  Widget authAlert() {
    var height;
    if (userInformation.userDeviceOS == "i") {
      height = MediaQuery.of(context).size.height / 1.2;
    } else {
      height = MediaQuery.of(context).size.height / 1.4;
    }
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
        color: Colors.white,
        height: height,
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
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              child: Text(
                "정회원으로 전환 신청하기",
                style: TextStyle(
                    color: Statics.shared.colors.mainColor,
                    fontSize: Statics.shared.fontSizes.titleInContent,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 60,
            ),
            Container(
                child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              color: Statics.shared.colors.lineColor,
              padding:
                  const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 28),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "MERIT",
                    style: TextStyle(
                        color: Statics.shared.colors.mainColor,
                        fontSize: Statics.shared.fontSizes.subTitleInContent,
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
            SizedBox(
              height: MediaQuery.of(context).size.height / 60,
            ),
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
                        "※ 전환신청하시면 협회에서 빠른시간내에 연락드리겠습니다.",
                        style: TextStyle(
                          color: Statics.shared.colors.subTitleTextColor,
                          fontSize: Statics.shared.fontSizes.supplementary,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height / 60,
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: SizedBox(
                    height: MediaQuery.of(context).size.height / 14,
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
                    height: MediaQuery.of(context).size.height / 14,
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
