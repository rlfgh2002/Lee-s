import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/profile/AlarmAgree.dart';
import 'package:haegisa2/controllers/profile/FeeHistory.dart';
import 'package:haegisa2/controllers/profile/HumanRights.dart';
import 'package:haegisa2/controllers/profile/Inquiry.dart';
import 'package:haegisa2/controllers/profile/Occasion.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/controllers/profile/UserInfo.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'Advisory.dart';
import 'Terms.dart';

int requestCode;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));
    String typeAsset = "";
    String typeTitle = "";
    Color typeColor;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    bool _isMember = false;
    String currentVersion;

    if (userInformation.memberType == "51001") {
      typeAsset = "Resources/Icons/user_type_01.png";
      typeTitle = Strings.shared.controllers.profile.memberType1;
      typeColor = Statics.shared.colors.mainColor;
      _isMember = false;
    } else if (userInformation.memberType == "51002") {
      typeAsset = "Resources/Icons/user_type_02.png";
      typeTitle = Strings.shared.controllers.profile.memberType2;
      typeColor = Statics.shared.colors.subColor;
      _isMember = true;
    } else {
      typeAsset = "Resources/Icons/user_type_03.png";
      typeTitle = Strings.shared.controllers.profile.memberType3;
      typeColor = Statics.shared.colors.captionColor;
      _isMember = false;
    }
    getVersion();

    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(Strings.shared.controllers.profile.appTitle,
                style: TextStyle(
                    color: Statics.shared.colors.titleTextColor,
                    fontSize: Statics.shared.fontSizes.subTitle,
                    fontWeight: FontWeight.bold)),
            titleSpacing: 16.0,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            centerTitle: false,
            elevation: 0,
            iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
          ),

          body: Container(
            color: Colors.white,
            child: ListView(
              children: [
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(typeAsset, scale: 3),
                        Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(userInformation.fullName + "님은 ",
                                        style: TextStyle(
                                            color: Statics
                                                .shared.colors.titleTextColor,
                                            fontSize: Statics.shared.fontSizes
                                                .titleInContent)),
                                    Text(typeTitle,
                                        style: TextStyle(
                                            color: typeColor,
                                            fontSize: Statics.shared.fontSizes
                                                .titleInContent)),
                                    Text(" 입니다",
                                        style: TextStyle(
                                            color: Statics
                                                .shared.colors.titleTextColor,
                                            fontSize: Statics.shared.fontSizes
                                                .titleInContent)),
                                  ],
                                ),
                                Visibility(
                                  visible: _isMember,
                                  child: new InkWell(
                                    onTap: () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (_) => requestAlert());
                                    },
                                    child: Text(Strings
                                        .shared.controllers.profile.submitType),
                                  ),
                                )
                              ],
                            ))
                      ]), //Row
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20, bottom: 15, top: 15),
                ),
                Image.asset('Resources/Icons/Line3.png'),
                Container(
                  child: Column(children: [
                    Container(
                        child: IntrinsicHeight(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            child: FlatButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Row(children: [
                                Image.asset('Resources/Icons/btn_human.png',
                                    scale: 2.8),
                                Text(" 인권상담",
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary)),
                              ]),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            new HumanRights()));
                              },
                            ),
                            width: deviceWidth / 2,
                            height: deviceWidth / 5.5,
                          ),
                          VerticalDivider(width: 0),
                          SizedBox(
                            child: FlatButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Row(children: [
                                Image.asset('Resources/Icons/btn_inquiry.png',
                                    scale: 2.8),
                                Text(
                                    " " +
                                        Strings
                                            .shared.controllers.profile.inquiry,
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary)),
                              ]),
                              onPressed: () {
                                UserInfo.shared.g_address1 = "";
                                UserInfo.shared.g_postNo = "";

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Inquiry()),
                                );
                              },
                            ),
                            width: deviceWidth / 2,
                            height: deviceWidth / 5.5,
                          )
                        ],
                      ), // Row Children
                    )),
                    Row(children: <Widget>[
                      Expanded(child: Divider(height: 0)),
                    ]),
                    Container(
                        child: IntrinsicHeight(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            child: FlatButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Row(children: [
                                Image.asset('Resources/Icons/btn_occasion.png',
                                    scale: 2.8),
                                Text(
                                    " " +
                                        Strings.shared.controllers.profile
                                            .occasion,
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary)),
                              ]),
                              onPressed: () {
                                UserInfo.shared.g_address1 = "";
                                UserInfo.shared.g_postNo = "";

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Occasion()),
                                );
                              },
                            ),
                            width: deviceWidth / 2,
                            height: deviceWidth / 5.5,
                          ),
                          VerticalDivider(width: 0),
                          SizedBox(
                              child: FlatButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Row(children: [
                                  Image.asset(
                                      'Resources/Icons/btn_advisory.png',
                                      scale: 2.8),
                                  Text(
                                      " " +
                                          Strings.shared.controllers.profile
                                              .advisory,
                                      style: TextStyle(
                                          color: Statics
                                              .shared.colors.titleTextColor,
                                          fontSize: Statics
                                              .shared.fontSizes.supplementary)),
                                ]),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new Advisory()));
                                },
                              ),
                              width: deviceWidth / 2,
                              height: deviceWidth / 6.5)
                        ],
                      ), // Row Children
                    )),
                  ]), // Row
                ),
                Image.asset('Resources/Icons/Line3.png', width: 34),
                Container(
                  child: Column(children: [
                    Container(
                        height: deviceWidth / 5.5,
                        padding: const EdgeInsets.only(left: 20, right: 5),
                        child: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: new Row(
                            children: <Widget>[
                              Text(
                                Strings.shared.controllers.profile.infoModify,
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary),
                                textAlign: TextAlign.left,
                              ),
                              Spacer(),
                              SizedBox(
                                width: 50,
                                child: Image.asset(
                                    'Resources/Icons/Vector 3.2.png',
                                    width: 10,
                                    scale: 4),
                              )
                            ],
                          ), // Row Children
                          onPressed: () async {
                            UserInfo.shared.g_address1 = "";
                            UserInfo.shared.g_postNo = "";

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfo()),
                            );

                            // After the Selection Screen returns a result, hide any previous snackbars
                            // and show the new result.
                            if (result != null && result != "") {
                              _displaySnackBar(context, "$result");
                            }
                          },
                        )),
                    Row(children: <Widget>[
                      Expanded(child: Divider(height: 0)),
                    ]),
                    // Container(
                    //     height: deviceWidth / 5.5,
                    //     padding: const EdgeInsets.only(left: 20, right: 5),
                    //     child: FlatButton(
                    //       splashColor: Colors.transparent,
                    //       highlightColor: Colors.transparent,
                    //       child: new Row(
                    //         children: <Widget>[
                    //           Text(
                    //             Strings.shared.controllers.profile.feehistory,
                    //             style: TextStyle(
                    //                 color: Statics.shared.colors.titleTextColor,
                    //                 fontSize:
                    //                     Statics.shared.fontSizes.supplementary),
                    //             textAlign: TextAlign.left,
                    //           ),
                    //           Spacer(),
                    //           SizedBox(
                    //             width: 50,
                    //             child: Image.asset(
                    //                 'Resources/Icons/Vector 3.2.png',
                    //                 width: 10,
                    //                 scale: 4),
                    //           )
                    //         ],
                    //       ), // Row Children
                    //       onPressed: () async {
                    //         UserInfo.shared.g_address1 = "";
                    //         UserInfo.shared.g_postNo = "";

                    //         final result = await Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => FeeHistory()),
                    //         );

                    //         // After the Selection Screen returns a result, hide any previous snackbars
                    //         // and show the new result.
                    //         if (result != null && result != "") {
                    //           _displaySnackBar(context, "$result");
                    //         }
                    //       },
                    //     )),
                    // Row(children: <Widget>[
                    //   Expanded(child: Divider(height: 0)),
                    // ]),
                    Container(
                        height: deviceWidth / 5.5,
                        padding: const EdgeInsets.only(left: 20, right: 5),
                        child: new FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Row(
                            children: <Widget>[
                              Text(
                                Strings.shared.controllers.profile.alarm,
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary),
                                textAlign: TextAlign.left,
                              ),
                              Spacer(),
                              SizedBox(
                                width: 50,
                                child: Image.asset(
                                    'Resources/Icons/Vector 3.2.png',
                                    width: 10,
                                    scale: 4),
                              )
                            ],
                          ), // Row Children

                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new AlarmAgree()));
                          },
                        )),
                    Row(children: <Widget>[
                      Expanded(child: Divider(height: 0)),
                    ]),
                    Container(
                        height: deviceWidth / 5.5,
                        padding: const EdgeInsets.only(left: 20, right: 5),
                        child: new FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Row(
                            children: <Widget>[
                              Text(
                                Strings.shared.controllers.profile.terms,
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary),
                                textAlign: TextAlign.left,
                              ),
                              Spacer(),
                              SizedBox(
                                width: 50,
                                child: Image.asset(
                                    'Resources/Icons/Vector 3.2.png',
                                    width: 10,
                                    scale: 4),
                              )
                            ],
                          ), // Row Children
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new Terms()));
                          },
                        )),
                    Row(children: <Widget>[
                      Expanded(child: Divider(height: 0)),
                    ]),
                    Container(
                        height: deviceWidth / 5.5,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: new FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Row(
                            children: <Widget>[
                              Text(
                                Strings.shared.controllers.profile.appVersion,
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary),
                                textAlign: TextAlign.left,
                              ),
                              Spacer(),
                              Container(
                                  width: deviceWidth / 2.0,
                                  child: FutureBuilder(
                                    future:
                                        getVersion(), // a Future<String> or null
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      //print('project snapshot data is: ${snapshot.data}');
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                          return new Text(
                                              'Press button to start');
                                        case ConnectionState.waiting:
                                          return new Container(
                                            child: FlatButton(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              child: Text(
                                                "",
                                              ),
                                              onPressed: () {},
                                            ),
                                            height: deviceWidth / 6,
                                          );
                                        default:
                                          if (snapshot.hasError)
                                            return new Text(
                                                'Error: ${snapshot.error}');
                                          else {
                                            currentVersion = snapshot.data;
                                            return Text(
                                              snapshot.data ==
                                                      userInformation.appVersion
                                                  ? userInformation.appVersion +
                                                      " (최신버전)"
                                                  : userInformation.appVersion +
                                                      " (이전버전)",
                                              style: TextStyle(
                                                  color: Statics.shared.colors
                                                      .titleTextColor,
                                                  fontSize: Statics.shared
                                                      .fontSizes.supplementary),
                                              textAlign: TextAlign.right,
                                            );
                                          }
                                      }
                                    },
                                  )),
                            ],
                          ), // Row Children
                          onPressed: () async {
                            if (currentVersion != userInformation.appVersion) {
                              var url = "";
                              if (userInformation.userDeviceOS == "i") {
                                url =
                                    "http://apps.apple.com/kr/app/%ED%95%9C%EA%B5%AD%ED%95%B4%EA%B8%B0%EC%82%AC%ED%98%91%ED%9A%8C/id1485498659";
                              } else {
                                url =
                                    "https://play.google.com/store/apps/details?id=com.mariners.heagisa2&hl=ko";
                              }

                              var url2 = Uri.encodeFull(url).toString();
                              if (await canLaunch(url2)) {
                                await launch(url2);
                              } else {
                                throw 'Could not launch $url';
                              }
                            }
                          },
                        )),
                    Row(children: <Widget>[
                      Expanded(child: Divider(height: 0)),
                    ]),
                  ]), // Row
                ),
              ], // Row Children
            ), // Row
            alignment: Alignment(0.0, 0.0),
          ), // Container
        ));
  }

  Widget requestAlert() {
    var height;
    if (userInformation.userDeviceOS == "i") {
      height = MediaQuery.of(context).size.height / 1.2;
    } else {
      height = MediaQuery.of(context).size.height / 1.35;
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
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: SizedBox(
                    height: MediaQuery.of(context).size.height / 14,
                    child: FlatButton(
                      color: Statics.shared.colors.captionColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(0.0),
                      ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(0.0),
                      ),
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

  getVersion() {
    var infomap = new Map<String, dynamic>();
    infomap["mode"] = userInformation.userDeviceOS;

    return http
        .post(Strings.shared.controllers.jsonURL.getVersion, body: infomap)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      //final String responseBody = response.body; //한글 깨짐
      final String responseBody = utf8.decode(response.bodyBytes);
      var responseJSON = json.decode(responseBody);
      var code = responseJSON["code"];
      var data = responseJSON['version'];

      if (statusCode == 200) {
        if (code == 200) {
          // If the call to the server was successful, parse the JSON
          return data;
        } else {
          // If that call was not successful, throw an error.
          throw Exception('Failed to load post');
        }
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }
}
