import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/Inquiry/InquiryWrite.dart';
import 'package:haegisa2/controllers/NoticesList/NoticesListSingle.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:haegisa2/controllers/mainTabBar/MiddleWare.dart';
import 'package:haegisa2/models/NoticesList/NoticesListObject.dart';
import 'package:haegisa2/models/inquiry/InquiryListObject.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/inquiry/InquiryListWidget.dart';
import 'package:haegisa2/views/null/nullPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'InquiryListSingle.dart';

class InquiryList extends StatefulWidget {
  bool isFirstInit = true;
  InquiryList({Key key}) : super(key: key);
  List<Widget> myList = [];
  List<Widget> inquiryList = [];

  @override
  InquiryListState createState() => InquiryListState();
}

class InquiryListState extends State<InquiryList> {
  final _scaffold = GlobalKey<ScaffoldState>();

  _getRequests() async {
    setState(() {
      widget.isFirstInit = true;
    });
  }

  void refreshList(int pCurrent, pTotal) {
    widget.myList = [];
    double screenWidth = MediaQuery.of(context).size.width;
    Widget topView = Container(
      child: Stack(
        children: [
          Image.asset(
            "Resources/Images/inquiry_banner.png",
            width: screenWidth,
          ),
        ],
      ),
      alignment: Alignment.center,
    );
    Widget blueSplitter = Container(
        color: Statics.shared.colors.blueLineColor,
        height: 3,
        margin: const EdgeInsets.only(
          left: 16,
          right: 16,
        ));
    widget.myList.add(topView);
    widget.myList.add(blueSplitter);

    Widget writeButton = Container(
      child: FlatButton(
        child: Container(
          color: Statics.shared.colors.mainColor,
          child: Text("문의하기",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Statics.shared.fontSizes.supplementary,
                  fontWeight: FontWeight.bold)),
          alignment: Alignment.center,
        ),
        onPressed: () {
          Navigator.of(context)
              .push(
                new MaterialPageRoute(builder: (_) => new InquiryWrite()),
              )
              .then((val) => val
                  ? _getRequests()
                  : null); //pCurrent 가 1인 이유는 게시글에서 뒤로가기 했을 시 처음 페이지를 구성하기 위함
        },
        padding: const EdgeInsets.all(0),
      ),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Statics.shared.colors.mainColor)),
      width: screenWidth,
      height: 60,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 10, right: 16, left: 16),
    );
    widget.myList.add(writeButton);

    widget.myList.addAll(this.widget.inquiryList); // fetch from server

    if (pTotal > pCurrent) {
      Widget downloadMoreView = Container(
        child: FlatButton(
          child: Container(
            child: Text(Strings.shared.controllers.magazines.downloadMoreKey,
                style: TextStyle(
                    color: Statics.shared.colors.mainColor,
                    fontSize: Statics.shared.fontSizes.supplementary,
                    fontWeight: FontWeight.w200)),
            alignment: Alignment.center,
          ),
          onPressed: () {
            // download 5 more magazines ...
            this.download5MoreInquiry(page: pCurrent + 1);
          },
          padding: const EdgeInsets.all(0),
        ),
        decoration: BoxDecoration(
            border:
                Border.all(width: 1, color: Statics.shared.colors.mainColor)),
        width: screenWidth,
        height: 60,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 20, right: 16, left: 16, bottom: 20),
      );
      widget.myList.add(downloadMoreView);
    }
    setState(() {});
  }

  void download5MoreInquiry({int page = 1}) async {
    http
        .get(Statics.shared.urls
            .inquiry(mode: "list", userId: userInformation.userID, page: page))
        .then((val) {
      if (val.statusCode == 200) {
        print(
            "::::::::::::::::::::: [ Getting NoticesList Start ] :::::::::::::::::::::");
        print("BODY: ${val.body.toString()}");
        var myJson = json.decode(utf8.decode(val.bodyBytes));

        int code = myJson["code"];
        if (code == 200) {
          List<InquiryListObject> myReturnList = [];
          int pTotal = myJson["totalPageNum"];
          int pCurrent = myJson["nowPageNum"];
          List<dynamic> rows = myJson["rows"];

          List<Widget> newList = [];
          rows.forEach((item) {
            InquiryListObject object = InquiryListObject(
              no: item["no"],
              subject: item["subject"].toString(),
              contents: item["contents"].toString(),
              regDate: item["regdate"].toString(),
              answer: item["answer"].toString(),
              comment: item["comment"].toString(),
              commentdate: item["commentdate"].toString(),
            );

            newList.add(InquiryListWidget(
                obj: object,
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              new InquiryListSingle(obj: object)));
                }));
          });
          if (page == 1) {
            this.widget.inquiryList = newList;
          } else {
            this.widget.inquiryList.addAll(newList);
          }
          this.refreshList(pCurrent, pTotal);
        }
        List<Widget> newList = [];
        newList.add(NullPage());
        this.widget.inquiryList = newList;
        this.refreshList(0, 0);
        print(
            "::::::::::::::::::::: [ Getting NoticesList End ] :::::::::::::::::::::");
      } else {
        print(
            ":::::::::::::::::: on Getting NoticesList error :: Server Error ::::::::::::::::::");
      }
    }).catchError((error) {
      print(
          ":::::::::::::::::: on Getting NoticesList error : ${error.toString()} ::::::::::::::::::");
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));
    if (widget.isFirstInit) {
      download5MoreInquiry(page: 1);
      widget.isFirstInit = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Container(
            child: Text("1:1문의",
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
        child: ListView(
          children: this.widget.myList,
        ),
        color: Colors.white,
      ), // end Body
      key: _scaffold,
    );
  }
}
