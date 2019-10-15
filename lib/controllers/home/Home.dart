import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/IntroduceOccupation/IntroduceOccupation.dart';
import 'package:haegisa2/controllers/LicenseTestQuestions/LicenseTestQuestions.dart';
import 'package:haegisa2/controllers/Magazines/Magazines.dart';
import 'package:haegisa2/controllers/NoticesList/NoticesList.dart';
import 'package:haegisa2/controllers/barcode/Barcode.dart';
import 'package:haegisa2/controllers/intro/Intro.dart';
import 'package:haegisa2/controllers/map/Map.dart';
import 'package:haegisa2/controllers/profile/Advisory.dart';
import 'package:haegisa2/controllers/profile/FeeHistory.dart';
import 'package:haegisa2/controllers/profile/Inquiry.dart';
import 'package:haegisa2/controllers/profile/Occasion.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:http/http.dart' as http;
import 'package:haegisa2/controllers/surveysTab/SurveysTabs.dart';

import '../../models/NoticesList/NoticesListObject.dart';
import '../../models/iO/IOObject.dart';
import '../IntroduceOccupation/IOSingle.dart';
import '../NoticesList/NoticesListSingle.dart';
import 'HomeWebview.dart';

double deviceWidth;
var noticeList = [];
var introList = [];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime backButtonPressTime;

  String url = Strings.shared.controllers.jsonURL.homeJson + "?mode=main";

  Future<List> getMainJson(String type) async {
    var response = await http.get(Uri.encodeFull(url));
    final String responseBody = utf8.decode(response.bodyBytes);
    var responseJSON = json.decode(responseBody);
    var code = responseJSON["code"];

    if (type == "notice") {
      noticeList = responseJSON["notice"];
      return responseJSON["notice"];
    } else if (type == "introduction") {
      introList = responseJSON["introduction"];
      return responseJSON["introduction"];
    }
    // if (code == 200) {
    //   for (var result in responseJSON["notice"]) {
    //     return Result.fromJson(result, "notce");
    //   }
    // }
  }

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
    deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    if (userInformation.memberType == "51001") {
      typeAsset = "Resources/Icons/user_type_01.png";
      typeTitle = Strings.shared.controllers.profile.memberType1;
      typeColor = Statics.shared.colors.mainColor;
    } else {
      typeAsset = "Resources/Icons/user_type_02.png";
      typeTitle = Strings.shared.controllers.profile.memberType2;
      typeColor = Statics.shared.colors.subColor;
    }

    return new WillPopScope(
      onWillPop: () async => false,
      //onWillPop: () async => false,
      // onWillPop: () async {
      //   Future.value(
      //       false); //return a `Future` with false value so this route cant be popped or closed.
      // },

      child: new Scaffold(
        body: Container(
          child: ListView(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(userInformation.fullName + "님, 안녕하세요",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      Statics.shared.fontSizes.titleInContent,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("오늘도 안전운항 하세요 ^^",
                                style: TextStyle(
                                    color: Color(0xffb2ccf5),
                                    fontSize: Statics
                                        .shared.fontSizes.subTitleInContent)),
                          )
                        ],
                      ),
                      Spacer(),
                      FlatButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Image.asset("Resources/Icons/icon_barcode.png",
                            scale: 2.0),
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new Barcode()));
                        },
                      )
                    ]), // Row

                padding: const EdgeInsets.only(left: 20, bottom: 30, top: 30),

                decoration: new BoxDecoration(
                    color: Statics.shared.colors.mainColor,
                    border: new Border.all(
                      color: Statics.shared.colors.mainColor,
                    ),
                    boxShadow: [
                      new BoxShadow(
                          color: Statics.shared.colors.mainColor,
                          offset: new Offset((deviceWidth / 6) * (1 / 3),
                              (deviceWidth / 6) * (1 / 3)),
                          spreadRadius: (deviceWidth / 6) * (1 / 3))
                    ]),
              ),
              Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    border: new Border.all(
                      color: Color.fromRGBO(235, 239, 245, 1),
                    ),
                    boxShadow: [
                      new BoxShadow(
                          color: Color.fromRGBO(235, 239, 245, 1),
                          offset: new Offset(0.0, 0.0),
                          spreadRadius: 2.0)
                    ]),
                margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),

                child: Column(children: [
                  Container(
                    width: deviceWidth / 1.1,
                    child: Column(children: <Widget>[
                      Container(
                          child: FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Row(children: [
                              Text("공지사항",
                                  style: TextStyle(
                                      color:
                                          Statics.shared.colors.titleTextColor,
                                      fontSize:
                                          Statics.shared.fontSizes.subTitle,
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                              Image.asset('Resources/Icons/btn_more.png',
                                  scale: 3.0),
                            ]),
                            onPressed: () {
                              // NoticesList()
                              // LicenseTestQuestions()
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new NoticesList()));
                            },
                          ),
                          height: deviceWidth / 8),
                      Row(children: <Widget>[
                        Expanded(child: Divider(height: 0)),
                      ]),
                      noticeList.length != 0
                          ? noticeText(context, noticeList)
                          : new FutureBuilder(
                              future: getMainJson(
                                  "notice"), // a Future<String> or null
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
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
                                                color: Statics.shared.colors
                                                    .titleTextColor,
                                                fontSize: Statics.shared
                                                    .fontSizes.subTitle)),
                                        onPressed: () {},
                                      ),
                                      height: deviceWidth / 6,
                                    );
                                  default:
                                    if (snapshot.hasError)
                                      return new Text(
                                          'Error: ${snapshot.error}');
                                    else
                                      return noticeText(context, snapshot.data);
                                }
                              },
                            ),
                    ]),
                  ),
                ]), // Row
              ),
              Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    border: new Border.all(
                      color: Color.fromRGBO(235, 239, 245, 1),
                    ),
                    boxShadow: [
                      new BoxShadow(
                          color: Color.fromRGBO(235, 239, 245, 1),
                          offset: new Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 2.0)
                    ]),
                margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                child: Column(children: [
                  Container(
                    child: Column(children: <Widget>[
                      Container(
                          width: deviceWidth / 1.1,
                          child: FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Row(children: [
                              Text("직역소개",
                                  style: TextStyle(
                                      color:
                                          Statics.shared.colors.titleTextColor,
                                      fontSize:
                                          Statics.shared.fontSizes.subTitle,
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                              Image.asset('Resources/Icons/btn_more.png',
                                  scale: 3.0)
                            ]),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          new IntroduceOccupation()));
                            },
                          ),
                          height: deviceWidth / 8),
                      Row(children: <Widget>[
                        Expanded(child: Divider(height: 0)),
                      ]),
                      introList.length != 0
                          ? introText(context, introList)
                          : new FutureBuilder(
                              future: getMainJson(
                                  "introduction"), // a Future<String> or null
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
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
                                                color: Statics.shared.colors
                                                    .titleTextColor,
                                                fontSize: Statics.shared
                                                    .fontSizes.subTitle)),
                                        onPressed: () {},
                                      ),
                                      height: deviceWidth / 6,
                                    );
                                  default:
                                    if (snapshot.hasError)
                                      return new Text(
                                          'Error: ${snapshot.error}');
                                    else
                                      return introText(context, snapshot.data);
                                }
                              },
                            ),
                    ]),
                  )
                ]), // Row
              ),
              Container(
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      border: new Border.all(
                        color: Color.fromRGBO(235, 239, 245, 1),
                      ),
                      boxShadow: [
                        new BoxShadow(
                            color: Color.fromRGBO(235, 239, 245, 1),
                            offset: new Offset(3.0, 3.0),
                            blurRadius: 0.5,
                            spreadRadius: 0)
                      ]),
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FlatButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Image.asset(
                                            'Resources/Icons/icon_intro.png',
                                            scale: 4.0,
                                            alignment: Alignment.center,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new Intro()));
                                          },
                                        ),
                                        Text("협회소개",
                                            style: TextStyle(
                                                color: Statics.shared.colors
                                                    .titleTextColor,
                                                fontSize: 13),
                                            textAlign: TextAlign.center),
                                      ]),
                                  height: deviceWidth / 5,
                                  width: deviceWidth / 4.5),
                              Container(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FlatButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Image.asset(
                                              'Resources/Icons/icon_webzine.png',
                                              scale: 4.0),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new Magazines()));
                                          },
                                        ),
                                        Text("해바라기",
                                            style: TextStyle(
                                                color: Statics.shared.colors
                                                    .titleTextColor,
                                                fontSize: 13),
                                            textAlign: TextAlign.left),
                                      ]),
                                  height: deviceWidth / 5,
                                  width: deviceWidth / 4.5),
                              Container(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FlatButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Image.asset(
                                              'Resources/Icons/icon_survey.png',
                                              scale: 4.0),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new SurveysTabs()));
                                          },
                                        ),
                                        Text("설문조사",
                                            style: TextStyle(
                                                color: Statics.shared.colors
                                                    .titleTextColor,
                                                fontSize: 13),
                                            textAlign: TextAlign.left),
                                      ]),
                                  height: deviceWidth / 5,
                                  width: deviceWidth / 4.5),
                              Container(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FlatButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Image.asset(
                                              'Resources/Icons/icon_map.png',
                                              scale: 4.0),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new MapPage()));
                                          },
                                        ),
                                        Text("선사지도",
                                            style: TextStyle(
                                                color: Statics.shared.colors
                                                    .titleTextColor,
                                                fontSize: 13),
                                            textAlign: TextAlign.left),
                                      ]),
                                  height: deviceWidth / 5,
                                  width: deviceWidth / 4.5),
                            ]),
                      ),
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FlatButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Image.asset(
                                              'Resources/Icons/btn_occasion.png',
                                              scale: 3.0),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new Occasion()));
                                          },
                                        ),
                                        Text("경조사통보",
                                            style: TextStyle(
                                                color: Statics.shared.colors
                                                    .titleTextColor,
                                                fontSize: 13),
                                            textAlign: TextAlign.left),
                                      ]),
                                  height: deviceWidth / 5,
                                  width: deviceWidth / 4.5),
                              Container(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FlatButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Image.asset(
                                              'Resources/Icons/btn_inquiry.png',
                                              scale: 3.0),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new Inquiry()));
                                          },
                                        ),
                                        Text("1:1문의",
                                            style: TextStyle(
                                                color: Statics.shared.colors
                                                    .titleTextColor,
                                                fontSize: 13),
                                            textAlign: TextAlign.left),
                                      ]),
                                  height: deviceWidth / 5,
                                  width: deviceWidth / 4.5),
                              Container(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FlatButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Image.asset(
                                              'Resources/Icons/btn_advisory.png',
                                              scale: 3.0),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new Advisory()));
                                          },
                                        ),
                                        Text("해기자문",
                                            style: TextStyle(
                                                color: Statics.shared.colors
                                                    .titleTextColor,
                                                fontSize: 13),
                                            textAlign: TextAlign.left),
                                      ]),
                                  height: deviceWidth / 5,
                                  width: deviceWidth / 4.5),
                              Container(
                                  height: deviceWidth / 5,
                                  width: deviceWidth / 4.5),
                            ]),
                      ),
                    ],
                  ),
                  height: deviceWidth / 2.2),
              Image.asset('Resources/Icons/Line3.png'),
              Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    border: new Border.all(
                      color: Color.fromRGBO(235, 239, 245, 1),
                    ),
                    boxShadow: [
                      new BoxShadow(
                          color: Color.fromRGBO(235, 239, 245, 1),
                          offset: new Offset(3.0, 3.0),
                          blurRadius: 0.5,
                          spreadRadius: 0)
                    ]),
                margin: EdgeInsets.only(left: 10, right: 10),
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Image.asset('Resources/Images/totalWork.png',
                      width: deviceWidth / 1.2),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeWebview()));
                  },
                ),
              ),
              Image.asset('Resources/Icons/Line3.png'),
              Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    border: new Border.all(
                      color: Color.fromRGBO(235, 239, 245, 1),
                    ),
                    boxShadow: [
                      new BoxShadow(
                          color: Color.fromRGBO(235, 239, 245, 1),
                          offset: new Offset(3.0, 3.0),
                          blurRadius: 0.5,
                          spreadRadius: 0)
                    ]),
                margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Image.asset('Resources/Images/gichul.png',
                      width: deviceWidth / 1.2),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new LicenseTestQuestions()));
                  },
                ),
              ),
            ], // Row Children
          ), // Row

          alignment: Alignment(0.0, 0.0),
        ), // Container
      ),
    );
  }

  Widget noticeText(BuildContext context, List snapshot) {
    var values = snapshot;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for (var item in values)
          Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text(item["subject"],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.subTitle)),
                  onPressed: () {
                    NoticesListObject object = NoticesListObject(
                      subject: item["subject"].toString(),
                      no: 0,
                      content: item["content"].toString(),
                      regDate: item["regDate"].toString(),
                      writer: item["writer"].toString(),
                      fileUrl_1: item["fileUrl_1"].toString(),
                      fileUrl_2: item["fileUrl_2"].toString(),
                      fileUrl_3: item["fileUrl_3"].toString(),
                      fileUrl_4: item["fileUrl_4"].toString(),
                      realFileName1: item["realFileName1"].toString(),
                      realFileName2: item["realFileName2"].toString(),
                      realFileName3: item["realFileName3"].toString(),
                      realFileName4: item["realFileName4"].toString(),
                      serverFileName_1: item["serverFileName_1"].toString(),
                      serverFileName_2: item["serverFileName_2"].toString(),
                      serverFileName_3: item["serverFileName_3"].toString(),
                      serverFileName_4: item["serverFileName_4"].toString(),
                    );

                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new NoticesList()));

                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new NoticesListSingle(obj: object)));
                  },
                ),
                height: deviceWidth / 8,
              ),
              Row(children: <Widget>[
                Expanded(child: Divider(height: 0)),
              ]),
            ],
          )
      ],
    );
  }

  Widget introText(BuildContext context, List snapshot) {
    var values = snapshot;

    return Container(
        child: FlatButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            height: deviceWidth / 3,
            child: Row(children: [
              Image.network(
                values[0]["viewImgUrl_1"].replaceAll("https://", "http://"),
                scale: 2,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      width: deviceWidth / 1.5 - 10,
                      child: Text(values[0]["company"],
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.subTitle,
                              fontWeight: FontWeight.bold))),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: new Column(
                      children: <Widget>[
                        new Text(values[0]["shortContent"],
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.subTitle,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ]),
          ),
          onPressed: () {
            IOObject object = IOObject(
              name: values[0]["name"].toString(),
              content: values[0]["content"].toString(),
              company: values[0]["company"].toString(),
              shortContent: values[0]["shortContent"].toString(),
              listImgUrl: values[0]["listImgUrl"].toString(),
              viewImgUrl_1: values[0]["viewImgUrl_1"].toString(),
              viewImgUrl_2: values[0]["viewImgUrl_2"].toString(),
            );

            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new IntroduceOccupation()));

            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new IOSingle(obj: object)));
          },
        ),
        height: deviceWidth / 3);
  }
}

//JSON 데이터
class Result {
  final String subject;
  final String cwriter;
  final String content;
  final String regDate;
  final String serverFileName_1;
  final String realFileName1;
  final String fileUrl_1;
  final String serverFileName_2;
  final String realFileName2;
  final String fileUrl_2;
  final String serverFileName_3;
  final String realFileName3;
  final String fileUrl_3;
  final String serverFileName_4;
  final String realFileName4;
  final String fileUrl_4;

  final String name;
  final String company;
  final String shortContent;
  final String listImgUrl;
  final String viewImgUrl_1;
  final String viewImgUrl_2;

  Result(
      {this.subject,
      this.cwriter,
      this.content,
      this.regDate,
      this.serverFileName_1,
      this.realFileName1,
      this.fileUrl_1,
      this.serverFileName_2,
      this.realFileName2,
      this.fileUrl_2,
      this.serverFileName_3,
      this.realFileName3,
      this.fileUrl_3,
      this.serverFileName_4,
      this.realFileName4,
      this.fileUrl_4,
      this.name,
      this.company,
      this.shortContent,
      this.listImgUrl,
      this.viewImgUrl_1,
      this.viewImgUrl_2});

  factory Result.fromJson(Map<String, dynamic> json, String table) {
    if (table == "notice") {
      return Result(
        subject: json['subject'],
        cwriter: json['cwriter'],
        content: json['content'],
        regDate: json['regDate'],
        serverFileName_1: json['serverFileName_1'],
        realFileName1: json['realFileName1'],
        fileUrl_1: json['fileUrl_1'],
        serverFileName_2: json['serverFileName_2'],
        realFileName2: json['realFileName2'],
        fileUrl_2: json['fileUrl_2'],
        serverFileName_3: json['serverFileName_3'],
        realFileName3: json['realFileName3'],
        fileUrl_3: json['fileUrl_3'],
        serverFileName_4: json['serverFileName_4'],
        realFileName4: json['realFileName4'],
        fileUrl_4: json['fileUrl_4'],
      );
    } else if (table == "introduction") {
      return Result(
          content: json['content'],
          name: json['name'],
          company: json['company'],
          shortContent: json['shortContent'],
          listImgUrl: json['listImgUrl'],
          viewImgUrl_1: json['viewImgUrl_1'],
          viewImgUrl_2: json['viewImgUrl_2'],
          regDate: json['subject']);
    }
  }
}
