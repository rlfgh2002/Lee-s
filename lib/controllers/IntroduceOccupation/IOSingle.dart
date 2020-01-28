import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
import 'package:haegisa2/models/iO/IOObject.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:http/http.dart' as http;

import 'IntroduceOccupation.dart';

class IOSingle extends StatefulWidget {
  IOObject object;
  String idx;
  String name;
  String company;
  String shortContent;
  String content;
  String listImgUrl;
  String viewImgUrl_1;
  String viewImgUrl_2;

  IOSingle({IOObject obj}) {
    this.object = obj;
    this.idx = obj.idx;
    this.name = obj.name;
    this.company = obj.company;
    this.shortContent = obj.shortContent;
    this.content = obj.content;
    this.listImgUrl = obj.listImgUrl;
    this.viewImgUrl_1 = obj.viewImgUrl_1;
    this.viewImgUrl_2 = obj.viewImgUrl_2;
  }

  @override
  _IOSingle createState() => _IOSingle();
}

class _IOSingle extends State<IOSingle> {
  final _scaffold = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    double screenWidth = MediaQuery.of(context).size.width;
    Widget blueSplitter = Container(
        color: Statics.shared.colors.blueLineColor,
        height: 3,
        margin:
            const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 10));
    Widget greySplitter = Container(
        color: Statics.shared.colors.lineColor,
        height: 1,
        margin:
            const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10));
    Widget listBtn =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Container(
        child: FlatButton(
          child: Container(
            child: Text("< 이전글",
                style: TextStyle(
                    color: Statics.shared.colors.mainColor,
                    fontSize: Statics.shared.fontSizes.supplementary,
                    fontWeight: FontWeight.w200)),
            alignment: Alignment.center,
          ),
          onPressed: () {
            functionArrow(direction: "prev", idx: this.widget.idx);
          },
          padding: const EdgeInsets.all(0),
        ),
        decoration: BoxDecoration(
            border:
                Border.all(width: 1, color: Statics.shared.colors.mainColor)),
        width: screenWidth / 5,
        height: 60,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 20, right: 16, left: 16, bottom: 20),
      ),
      Container(
        child: FlatButton(
          child: Container(
            child: Text(Strings.shared.controllers.noticesList.listKeyword,
                style: TextStyle(
                    color: Statics.shared.colors.mainColor,
                    fontSize: Statics.shared.fontSizes.supplementary,
                    fontWeight: FontWeight.w200)),
            alignment: Alignment.center,
          ),
          onPressed: () {
            Navigator.pop(
                context,
                new MaterialPageRoute(
                    builder: (context) => new IntroduceOccupation()));
          },
          padding: const EdgeInsets.all(0),
        ),
        decoration: BoxDecoration(
            border:
                Border.all(width: 1, color: Statics.shared.colors.mainColor)),
        width: screenWidth / 5,
        height: 60,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 20, right: 16, left: 16, bottom: 20),
      ),
      Container(
        child: FlatButton(
          child: Container(
            child: Text("다음글 >",
                style: TextStyle(
                    color: Statics.shared.colors.mainColor,
                    fontSize: Statics.shared.fontSizes.supplementary,
                    fontWeight: FontWeight.w200)),
            alignment: Alignment.center,
          ),
          onPressed: () {
            functionArrow(direction: "next", idx: this.widget.idx);
          },
          padding: const EdgeInsets.all(0),
        ),
        decoration: BoxDecoration(
            border:
                Border.all(width: 1, color: Statics.shared.colors.mainColor)),
        width: screenWidth / 5,
        height: 60,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 20, right: 16, left: 16, bottom: 20),
      )
    ]);

    List<Widget> myImages = [];
    if (this.widget.viewImgUrl_1.isNotEmpty) {
      myImages.add(Image.network(
        this.widget.viewImgUrl_1.replaceAll("https://", "http://"),
        fit: BoxFit.cover,
        width: screenWidth / 1.5,
      ));
    }
    if (this.widget.viewImgUrl_2.isNotEmpty) {
      myImages.add(Image.network(
        this.widget.viewImgUrl_2.replaceAll("https://", "http://"),
        fit: BoxFit.cover,
        width: screenWidth / 1.5,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Container(
            alignment: Alignment.centerLeft,
            child: Text("직역소개",
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
          controller: _scrollController,
          children: [
            blueSplitter,
            Padding(
                child: Text(
                  this.widget.name,
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.subTitleInContent,
                    color: Statics.shared.colors.titleTextColor,
                    fontWeight: FontWeight.w600,
                  ), // TextStyle
                ),
                padding: const EdgeInsets.only(left: 32, right: 32)),
            SizedBox(height: 10),
            Padding(
                child: Row(
                  children: <Widget>[
                    Text(
                      this.widget.company,
                      style: TextStyle(
                        fontSize: Statics.shared.fontSizes.medium,
                        color: Statics.shared.colors.captionColor,
                        fontWeight: FontWeight.w300,
                      ), // TextStyle
                    ),
                  ], // Children
                ),
                padding: const EdgeInsets.only(left: 32, right: 32)),
            greySplitter,
            Container(
              height: 300,
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Image.network(
                this.widget.viewImgUrl_1.replaceAll("https://", "http://"),
              ),

              // CarouselSlider(
              //   items: myImages,
              //   height: 300,
              // ),
            ),
            HtmlView(
              data: this.widget.content,
              scrollable: false,
              padding: const EdgeInsets.only(left: 32, right: 32),
            ),
            greySplitter,
            listBtn
          ], // Children
        ),
        color: Colors.white,
      ), // end Body
      key: _scaffold,
    );
  }

  void functionArrow({String direction, String idx, int page}) async {
    http
        .get(Statics.shared.urls.iO(page: 1) +
            "&mode2=" +
            direction +
            "&idx=" +
            idx)
        .then((val) {
      if (val.statusCode == 200) {
        print(
            "::::::::::::::::::::: [ Getting NoticesList Start ] :::::::::::::::::::::");
        print("BODY: ${val.body.toString()}");
        var myJson = json.decode(utf8.decode(val.bodyBytes));

        int code = myJson["code"];
        if (code == 200) {
          List<dynamic> rows = myJson["rows"];
          setState(() {
            rows.forEach((item) {
              this.widget.idx = item["idx"];
              this.widget.name = item["name"].toString();
              this.widget.company = item["company"].toString();
              this.widget.shortContent = item["shortContent"].toString();
              this.widget.content = item["content"].toString();
              this.widget.listImgUrl = item["listImgUrl"].toString();
              this.widget.viewImgUrl_1 = item["viewImgUrl_1"].toString();
              this.widget.viewImgUrl_2 = item["viewImgUrl_2"].toString();

              //새로고침 후 스크롤 최상위로 이동
              _scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            });
          });
        } else if (code == 100) {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (_) => AlertDialog(
                      title: new Text("알림"),
                      content: new Text("마지막 글입니다.",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          child: new Text("확인",
                              style: TextStyle(
                                  fontSize:
                                      Statics.shared.fontSizes.supplementary,
                                  color: Colors.black)),
                          onPressed: () {
                            Navigator.of(context).pop(); //팝업닫고
                          },
                        ),
                      ]));
        }
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

  void _moveBack(BuildContext context) => userInformation.userDeviceOS == "i"
      ? true
      : Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new IntroduceOccupation()));
}
