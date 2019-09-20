import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/home/Home.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String pushState = "";
  bool _aTeamVisible = false;
  bool _bTeamVisible = false;
  bool _cTeamVisible = false;
  var orgTable = new List();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("협회소개",
              style: TextStyle(
                  color: Statics.shared.colors.titleTextColor,
                  fontSize: Statics.shared.fontSizes.title)),
          titleSpacing: 16.0,
          bottom: TabBar(
            labelColor: Statics.shared.colors.titleTextColor,
            labelStyle: (TextStyle(
              fontSize: Statics.shared.fontSizes.subTitle,
            )),
            tabs: [
              Tab(
                text: "협회정보",
              ),
              Tab(text: "조직도"),
            ],
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          centerTitle: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
        ),
        body: TabBarView(
          children: [
            //tab1
            Column(
              children: <Widget>[
                Container(
                  child: Image.asset("Resources/Images/intro.png"),
                )
              ],
            ),
            //tab2
            Column(children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Image.asset("Resources/Images/organization.png"),
                        Container(
                          padding:
                              const EdgeInsets.only(left: 5.0, right: 10.0),
                          child:
                              Image.asset("Resources/Images/organization2.png"),
                        ),
                        FutureBuilder(
                          future: getOrganization(), // a Future<String> or null
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            //print('project snapshot data is: ${snapshot.data}');
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return new Text('Press button to start');
                              case ConnectionState.waiting:
                                return new Container(
                                  child: FlatButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Text("",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Statics
                                                .shared.colors.titleTextColor,
                                            fontSize: Statics
                                                .shared.fontSizes.subTitle)),
                                    onPressed: () {},
                                  ),
                                  height: deviceWidth / 6,
                                );
                              default:
                                if (snapshot.hasError)
                                  return new Text('Error: ${snapshot.error}');
                                else
                                  return orgList(context, snapshot);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ])
          ],
        ),
      ),
    );
  }

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<List> getOrganization() async {
    var infomap = new Map<String, dynamic>();
    infomap["mode"] = "member";
    //한번도 실행되지 않았을때(최초실행)
    if (orgTable.length == 0) {
      return http
          .post(Strings.shared.controllers.jsonURL.organizationJSon,
              body: infomap)
          .then((http.Response response) {
        final int statusCode = response.statusCode;
        //final String responseBody = response.body; //한글 깨짐
        final String responseBody = utf8.decode(response.bodyBytes);
        var responseJSON = json.decode(responseBody);
        var code = responseJSON["code"];

        if (statusCode == 200) {
          if (code == 200) {
            orgTable = responseJSON["rows"];
            return responseJSON["rows"];
          }
        } else {
          // If that call was not successful, throw an error.
          throw Exception('Failed to load post');
        }
      });
    } else
      return orgTable;
  }

  orgList(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;

    return Container(
        child: Column(
      children: <Widget>[
        Container(
          height: deviceWidth / 8,
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          decoration: new BoxDecoration(
              border: new Border.all(
                  color: Statics.shared.colors.subTitleTextColor)),
          child: FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Row(children: [
              Text(values[0]["department_name"],
                  style: TextStyle(
                      color: Statics.shared.colors.titleTextColor,
                      fontSize: Statics.shared.fontSizes.subTitle,
                      fontWeight: FontWeight.bold)),
              Spacer(),
              // Image.asset(
              //     _aTeamVisible
              //         ? 'Resources/Icons/arrow_up.png'
              //         : 'Resources/Icons/arrow_down.png',
              //     scale: 3.0),
            ]),
            onPressed: () {
              // setState(() {
              //   _aTeamVisible = !_aTeamVisible;
              // });
            },
          ),
        ),
        Visibility(
          // visible: _aTeamVisible ? true : false,
          visible: true,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                width: deviceWidth / 1.5,
                child: Text(
                    "- 예산편성 집행관리\n- 경리,회계업무\n- 각종 문서수발 및 보관관리\n- 소유재산 및 자산관리\n- 회비징수 및 관리업무\n- 직원의 인사관리 및 후생복지\n- 각종 전산관리 업무\n- 서무, 일반행정"),
              ),
              memberList(values[0]["department_member"]),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: deviceWidth / 8,
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          decoration: new BoxDecoration(
              border: new Border.all(
                  color: Statics.shared.colors.subTitleTextColor)),
          child: FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Row(children: [
              Text(values[1]["department_name"],
                  style: TextStyle(
                      color: Statics.shared.colors.titleTextColor,
                      fontSize: Statics.shared.fontSizes.subTitle,
                      fontWeight: FontWeight.bold)),
              Spacer(),

              // Image.asset(
              //     _bTeamVisible
              //         ? 'Resources/Icons/arrow_up.png'
              //         : 'Resources/Icons/arrow_down.png',
              //     scale: 3.0),
            ]),
            onPressed: () {
              // setState(() {
              //   _bTeamVisible = !_bTeamVisible;
              // });
            },
          ),
        ),
        Visibility(
            // visible: _bTeamVisible ? true : false,
            visible: true,
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: deviceWidth / 1.5,
                  child: Text(
                      "- 해기사 관련 대외 정책 및 전략수립\n- 유관기관 및 단체, 업체와의 유대관리\n- 대의원 및 회장선거와 관련된 제반 업무\n- 정관, 제 규정의 제정, 개정 및 폐지\n- 각종 행사 및 세미나 주관\n- 홍보편집"),
                ),
                memberList(values[1]["department_member"]),
              ],
            )),
        SizedBox(
          height: 10,
        ),
        Container(
          height: deviceWidth / 8,
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          decoration: new BoxDecoration(
              border: new Border.all(
                  color: Statics.shared.colors.subTitleTextColor)),
          child: FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Row(children: [
              Text(values[2]["department_name"],
                  style: TextStyle(
                      color: Statics.shared.colors.titleTextColor,
                      fontSize: Statics.shared.fontSizes.subTitle,
                      fontWeight: FontWeight.bold)),
              Spacer(),
              // Image.asset(
              //     _cTeamVisible
              //         ? 'Resources/Icons/arrow_up.png'
              //         : 'Resources/Icons/arrow_down.png',
              //     scale: 3.0),
            ]),
            onPressed: () {
              // setState(() {
              //   _cTeamVisible = !_cTeamVisible;
              // });
            },
          ),
        ),
        Visibility(
            //visible: _cTeamVisible ? true : false,
            visible: true,
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: deviceWidth / 1.5,
                  child: Text(
                      "- 회원조직 관리업무\n- 해기사시험보도 접수 및 관련업무\n- 한국면허갱신접수 대행업무\n- 외국면허 수첩 및 특별 자격증 발급에 관련된 제반업무\n- 회원고충상담 및 처리업무\n- 회원복지 및 친목에 관련된 제반업무\n- 해기 기술의 검토 및 자문"),
                ),
                memberList(values[2]["department_member"]),
              ],
            )),
      ],
    ));
  }

  memberList(List member) {
    return Container(
        child: Column(
      children: <Widget>[
        for (var i = 0; i < member.length; i++)
          Column(
            children: <Widget>[
              Container(
                height: deviceWidth / 8,
                margin: const EdgeInsets.only(left: 40.0, right: 20.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: deviceWidth / 4.5,
                      child: Text(member[i]["position"],
                          style: TextStyle(
                            color: Statics.shared.colors.mainColor,
                            fontSize: Statics.shared.fontSizes.subTitle,
                          )),
                    ),
                    Container(
                      height: deviceWidth / 14,
                      child: VerticalDivider(
                        width: 0,
                        color: Colors.black38,
                      ),
                    ),
                    Container(
                      width: deviceWidth / 4.5,
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Text(member[i]["name"],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Statics.shared.fontSizes.subTitle,
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                    Spacer(),
                    FlatButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Image.asset("Resources/Icons/icon_call.png",
                          scale: 2.0),
                      onPressed: () {
                        launch("tel://" + member[i]["tel"]);
                      },
                    )
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Divider(
                      height: 0,
                      color: Colors.black38,
                    )),
                  ]))
            ],
          )
      ],
    ));
  }
}
