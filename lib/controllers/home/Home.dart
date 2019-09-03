import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/Magazines/Magazines.dart';
import 'package:haegisa2/controllers/NoticesList/NoticesList.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/controllers/profile/UserInfo.dart';
import 'package:haegisa2/controllers/profile/MiddleWare.dart';
import 'package:http/http.dart' as http;
import 'package:haegisa2/controllers/surveysTab/SurveysTabs.dart';

double deviceWidth;

class Home extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Home> {
  List noticeList;
  List introList = List();
  bool _isLoading = false;
  String url = Strings.shared.controllers.jsonURL.homeJson + "?mode=main";

  Future<List> getMainJson(String type) async {
    var response = await http.get(Uri.encodeFull(url));
    final String responseBody = utf8.decode(response.bodyBytes);
    var responseJSON = json.decode(responseBody);
    var code = responseJSON["code"];
    noticeList = responseJSON["notice"];

    if (type == "notice") {
      return responseJSON["notice"];
    } else if (type == "introduction") {
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

      // onWillPop: () async {
      //   Future.value(
      //       false); //return a `Future` with false value so this route cant be popped or closed.
      // },

      child: new Scaffold(
        body: Container(
          child: ListView(
            children: [
              Container(
                child: Column(children: [
                  Text(userInformation.fullName + "님, 안녕하세요",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Statics.shared.fontSizes.titleInContent,
                          fontWeight: FontWeight.bold)),
                  Text("오늘도 안전운항 하세요 ^^",
                      style: TextStyle(
                          color: Statics.shared.colors.subTitleTextColor,
                          fontSize: Statics.shared.fontSizes.subTitleInContent))
                ]), // Row
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                    left: 20, bottom: 30, top: 30, right: 15),

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
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new NoticesList()));
                            },
                          ),
                          height: deviceWidth / 6),
                      Row(children: <Widget>[
                        Expanded(child: Divider(height: 0)),
                      ]),
                      new FutureBuilder(
                        future:
                            getMainJson("notice"), // a Future<String> or null
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
                                  child: Text("로딩중..",
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
                                return noticeText(context, snapshot);
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
                            onPressed: () {},
                          ),
                          height: deviceWidth / 6),
                      Row(children: <Widget>[
                        Expanded(child: Divider(height: 0)),
                      ]),
                      new FutureBuilder(
                        future: getMainJson(
                            "introduction"), // a Future<String> or null
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
                                  child: Text("로딩중..",
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
                                return introText(context, snapshot);
                          }
                        },
                      ),
                    ]),
                  )
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
                          offset: new Offset(3.0, 3.0),
                          blurRadius: 0.5,
                          spreadRadius: 0)
                    ]),
                margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(children: <Widget>[
                    Container(
                        child: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Row(children: [
                            Image.asset('Resources/Images/ill_service.png',
                                scale: 4.0),
                          ]),
                          onPressed: () {},
                        ),
                        height: deviceWidth / 4),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Column(children: [
                          Text("한국해기사협회의",
                              style: TextStyle(
                                color: Statics.shared.colors.titleTextColor,
                                fontSize:
                                    Statics.shared.fontSizes.supplementary,
                              ),
                              textAlign: TextAlign.left),
                          Text("종합서비스센터 업무대행 소개",
                              style: TextStyle(
                                  color: Statics.shared.colors.titleTextColor,
                                  fontSize: Statics.shared.fontSizes.subTitle,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left),
                        ]))
                  ]),
                ),
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
                  margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                  child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: Column(children: [
                                FlatButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Row(children: [
                                    Image.asset(
                                        'Resources/Icons/icon_intro.png',
                                        scale: 4.0),
                                  ]),
                                  onPressed: () {},
                                ),
                                Text("협회소개",
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: 13),
                                    textAlign: TextAlign.left),
                              ]),
                              height: deviceWidth / 5),
                          Container(
                              child: Column(children: [
                                FlatButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Row(children: [
                                    Image.asset(
                                        'Resources/Icons/icon_webzine.png',
                                        scale: 4.0),
                                  ]),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new Magazines()));
                                  },
                                ),
                                Text("웹진",
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: 13),
                                    textAlign: TextAlign.left),
                              ]),
                              height: deviceWidth / 5),
                          Container(
                              child: Column(children: [
                                FlatButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Row(children: [
                                    Image.asset(
                                        'Resources/Icons/icon_survey.png',
                                        scale: 4.0),
                                  ]),
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
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: 13),
                                    textAlign: TextAlign.left),
                              ]),
                              height: deviceWidth / 5),
                          Container(
                              child: Column(children: [
                                FlatButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Row(children: [
                                    Image.asset('Resources/Icons/icon_map.png',
                                        scale: 4.0),
                                  ]),
                                  onPressed: () {},
                                ),
                                Text("해운선사지도",
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: 13),
                                    textAlign: TextAlign.left),
                              ]),
                              height: deviceWidth / 5),
                        ]),
                  ),
                  height: deviceWidth / 3),
              Image.asset('Resources/Icons/Line3.png'),
            ], // Row Children
          ), // Row

          alignment: Alignment(0.0, 0.0),
        ), // Container
      ),
    );
  }

  Widget noticeText(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for (var item in values)
          Column(
            children: <Widget>[
              Container(
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text(item["subject"],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.subTitle)),
                  onPressed: () {},
                ),
                height: deviceWidth / 6,
              ),
              Row(children: <Widget>[
                Expanded(child: Divider(height: 0)),
              ]),
            ],
          )
      ],
    );
  }

  Widget introText(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;

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
          onPressed: () {},
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
