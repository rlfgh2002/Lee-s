import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:http/http.dart' as http;

class HumanRights extends StatefulWidget {
  @override
  _HumanRightsState createState() => _HumanRightsState();
}

class _HumanRightsState extends State<HumanRights> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _subjectController;
  TextEditingController _contentController;
  bool _subjectChecked = false;
  bool _contentChecked = false;
  String subject;
  String content;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("인권상담",
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
      body: Column(children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "Resources/Images/humanRights.png",
                      scale: 2.0,
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 5),
                      child: TextField(
                        controller: _subjectController,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: Statics.shared.fontSizes.subTitle,
                              color: Statics.shared.colors.subTitleTextColor,
                            ),
                            border: OutlineInputBorder(),
                            hintText: "제목"),
                        obscureText: false, // decoration
                        onChanged: (String str) {
                          subject = str;
                          if (str.length > 0) {
                            _subjectChecked = true;
                          } else {
                            _subjectChecked = false;
                          }
                        },
                      ),
                    ),
                    Container(
                      height: deviceHeight / 1.6,
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: TextField(
                        controller: _contentController,
                        maxLines: 200,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: Statics.shared.fontSizes.subTitle,
                              color: Statics.shared.colors.subTitleTextColor,
                            ),
                            border: OutlineInputBorder(),
                            hintText: "협회에 문의해주시면 빠른 시일안에 답변을 드리도록 하겠습니다."),
                        obscureText: false, // decoration
                        onChanged: (String str) {
                          content = str;
                          if (str.length > 0) {
                            _contentChecked = true;
                          } else {
                            _contentChecked = false;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
            height: deviceHeight / 8,
            width: deviceWidth,
            alignment: FractionalOffset.bottomCenter,
            child: new SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.all(20),
                  color: _subjectChecked && _contentChecked
                      ? Statics.shared.colors.mainColor
                      : Statics.shared.colors.subTitleTextColor,
                  child: Text("보내기",
                      style: TextStyle(
                          fontSize: Statics.shared.fontSizes.titleInContent,
                          color: Colors.white)),
                  onPressed: () async {
                    if (subject.length == 0) {
                      _displaySnackBar(context, "제목을 입력하세요.");
                      return;
                    }
                    if (content.length == 0) {
                      _displaySnackBar(context, "내용을 입력하세요.");
                      return;
                    }
                    if (content.length < 10) {
                      _displaySnackBar(context, "내용은 10자 이상 입력하세요.");
                      return;
                    }
                    if (_subjectChecked == true && _contentChecked == true) {
                      var infomap = new Map<String, dynamic>();
                      infomap["mode"] = "submit";
                      infomap["userId"] = userInformation.userID;
                      infomap["subject"] = subject;
                      infomap["content"] = content;

                      await submit(Strings.shared.controllers.jsonURL.humanJson,
                          body: infomap);

                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => AlertDialog(
                                title: new Text("접수 완료"),
                                content: new Text(
                                    "작성하신 내용은 전송되었습니다 \n빠른시간내 회원님의 이메일로 답변을 보내드리겠습니다.",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("확인",
                                        style: TextStyle(
                                            fontSize: Statics
                                                .shared.fontSizes.supplementary,
                                            color: Colors.black)),
                                    onPressed: () {
                                      Navigator.of(context).pop(); //팝업닫고
                                      Navigator.of(context).pop(); //이전페이지로
                                    },
                                  ),
                                ],
                              ));

                      setState(() {
                        _subjectController =
                            new TextEditingController(text: "");
                        _contentController =
                            new TextEditingController(text: "");

                        _subjectChecked = false;
                        _contentChecked = false;

                        subject = "";
                        content = "";
                      });
                    }
                  }),
            )),
      ]),
    );
  }

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 1500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  submit(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;
      //final String responseBody = response.body; //한글 깨짐
      final String responseBody = utf8.decode(response.bodyBytes);
      var responseJSON = json.decode(responseBody);
      var code = responseJSON["code"];

      if (code == 200) {
        // If the call to the server was successful, parse the JSON
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }
}

class RefreshController {}
