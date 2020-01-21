import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/NoticesList/NoticesListObject.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/NoticesListWidget/NoticesListWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'NoticesList.dart';

class NoticesListSingle extends StatefulWidget {
  NoticesListObject object;
  int no;
  String idx;
  String fileUrl_1;
  String fileUrl_2;
  String fileUrl_3;
  String fileUrl_4;
  String realFileName1;
  String realFileName2;
  String realFileName3;
  String realFileName4;
  String subject;
  String writer;
  String regDate;
  String content;

  NoticesListSingle({NoticesListObject obj}) {
    this.object = obj;
    this.no = obj.no;
    this.idx = obj.idx;
    this.fileUrl_1 = obj.fileUrl_1;
    this.fileUrl_2 = obj.fileUrl_2;
    this.fileUrl_3 = obj.fileUrl_3;
    this.fileUrl_4 = obj.fileUrl_4;
    this.realFileName1 = obj.realFileName1;
    this.realFileName2 = obj.realFileName2;
    this.realFileName3 = obj.realFileName3;
    this.realFileName4 = obj.realFileName4;
    this.subject = obj.subject;
    this.writer = obj.writer;
    this.regDate = obj.regDate;
    this.content = obj.content;
  }

  @override
  _NoticesListSingleState createState() => _NoticesListSingleState();
}

class _NoticesListSingleState extends State<NoticesListSingle> {
  final _scaffold = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();

  _launchURL(String url) async {
    var url2 = Uri.encodeFull(url).toString();
    if (await canLaunch(url2)) {
      await launch(url2);
    } else {
      throw 'Could not launch $url';
    }
  }

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
            Navigator.pop(context,
                new MaterialPageRoute(builder: (context) => new NoticesList()));
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

    Widget files = Container();
    bool isThereAnyFiles = false;
    List<FlatButton> myFilesList = [];

    if (this.widget.fileUrl_1.isNotEmpty) {
      isThereAnyFiles = true;
      myFilesList.add(
        FlatButton(
          child: Container(
            child: Row(
              children: <Widget>[
                Image.asset(
                  "Resources/Icons/icon_file.png",
                  height: 25,
                ),
                SizedBox(width: 10),
                Container(
                    width: screenWidth / 1.7,
                    child: Text(
                      this.widget.realFileName1.toString(),
                      maxLines: 1,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
          ),
          onPressed: () {
            _launchURL(this.widget.fileUrl_1);
          },
        ),
      );
    }
    if (this.widget.fileUrl_2.isNotEmpty) {
      isThereAnyFiles = true;
      myFilesList.add(
        FlatButton(
          child: Container(
            child: Row(
              children: <Widget>[
                Image.asset(
                  "Resources/Icons/icon_file.png",
                  height: 25,
                ),
                SizedBox(width: 10),
                Container(
                    width: screenWidth / 1.7,
                    child: Text(this.widget.realFileName2.toString(),
                        maxLines: 1,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          onPressed: () {
            _launchURL(this.widget.fileUrl_2);
          },
        ),
      );
    }
    if (this.widget.fileUrl_3.isNotEmpty) {
      isThereAnyFiles = true;
      myFilesList.add(
        FlatButton(
          child: Container(
            child: Row(
              children: <Widget>[
                Image.asset(
                  "Resources/Icons/icon_file.png",
                  height: 25,
                ),
                SizedBox(width: 10),
                Container(
                    width: screenWidth / 1.7,
                    child: Text(this.widget.realFileName3.toString(),
                        maxLines: 1,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          onPressed: () {
            _launchURL(this.widget.fileUrl_3);
          },
        ),
      );
    }
    if (this.widget.fileUrl_4.isNotEmpty) {
      isThereAnyFiles = true;
      myFilesList.add(
        FlatButton(
          child: Container(
            child: Row(
              children: <Widget>[
                Image.asset(
                  "Resources/Icons/icon_file.png",
                  height: 25,
                ),
                SizedBox(width: 10),
                Container(
                    width: screenWidth / 1.7,
                    child: Text(this.widget.realFileName4.toString(),
                        maxLines: 1,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          onPressed: () {
            _launchURL(this.widget.fileUrl_4);
          },
        ),
      );
    }

    if (isThereAnyFiles) {
      files = Container(
        color: Color.fromRGBO(244, 248, 255, 1),
        padding: const EdgeInsets.only(bottom: 16, top: 16, left: 8, right: 8),
        margin: const EdgeInsets.only(left: 32, right: 32, top: 20, bottom: 32),
        child: Column(
          children: myFilesList,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Container(
            child: Text("공지사항",
                style: TextStyle(
                    color: Statics.shared.colors.titleTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: Statics.shared.fontSizes.subTitle)),
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
                  this.widget.subject,
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
                      this.widget.writer,
                      style: TextStyle(
                        fontSize: Statics.shared.fontSizes.medium,
                        color: Statics.shared.colors.captionColor,
                        fontWeight: FontWeight.w300,
                      ), // TextStyle
                    ),
                    SizedBox(width: 10),
                    Text(
                      "|",
                      style: TextStyle(
                        fontSize: Statics.shared.fontSizes.medium,
                        color: Statics.shared.colors.captionColor,
                        fontWeight: FontWeight.w300,
                      ), // TextStyle
                    ),
                    SizedBox(width: 10),
                    Text(
                      this.widget.regDate,
                      style: TextStyle(
                        fontSize: Statics.shared.fontSizes.medium,
                        color: Statics.shared.colors.captionColor,
                        fontWeight: FontWeight.w300,
                      ), // TextStyle
                    )
                  ], // Children
                ),
                padding: const EdgeInsets.only(left: 32, right: 32)),
            greySplitter,
            files,
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
        .get(Statics.shared.urls.noticesList(page: 1) +
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
          List<NoticesListObject> myReturnList = [];
          int pTotal = myJson["totalPageNum"];
          int pCurrent = myJson["nowPageNum"];
          List<dynamic> rows = myJson["rows"];

          List<Widget> newList = [];
          setState(() {
            rows.forEach((item) {
              this.widget.subject = item["subject"].toString();
              this.widget.idx = item["idx"];
              this.widget.no = item["no"];
              this.widget.content = item["content"].toString();
              this.widget.regDate = item["regDate"].toString();
              this.widget.writer = item["writer"].toString();
              this.widget.fileUrl_1 = item["fileUrl_1"].toString();
              this.widget.fileUrl_2 = item["fileUrl_2"].toString();
              this.widget.fileUrl_3 = item["fileUrl_3"].toString();
              this.widget.fileUrl_4 = item["fileUrl_4"].toString();
              this.widget.realFileName1 = item["realFileName1"].toString();
              this.widget.realFileName2 = item["realFileName2"].toString();
              this.widget.realFileName3 = item["realFileName3"].toString();
              this.widget.realFileName4 = item["realFileName4"].toString();

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
      : Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new NoticesList()));
}
