import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:haegisa2/models/Magazines/Magazine.dart';
import 'package:haegisa2/models/Map/Map.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/Magazines/Magazines.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

bool isDownload = true; //다운로드 할수 있는지 이미 다운된것은 false

var _localPath = userInformation.dirPath.path + "/Magazines";

//magazinesList를 myList에 넣는다.
//myList는 0행,1행,마지막행은 Container가 들어가고 그 가운데 magazineList가 들어간다.
//리스트 값을 변경할 때에는 해당 두 리스트의 값을 다 변경해야한다.
class MapPage extends StatefulWidget {
  bool isFirstInit = true;

  MapPage({Key key}) : super(key: key);
  List<Widget> myList = [];
  List<Widget> magazinesList = [];

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int magazineNum = 0;

  void refreshList(int pCurrent, pTotal) {
    widget.myList = [];
    double screenWidth = MediaQuery.of(context).size.width;
    widget.myList.addAll(this.widget.magazinesList); // fetch from server

    if (pTotal > pCurrent) {
      Widget downloadMoreView = Container(
        child: FlatButton(
          child: Container(
            child: Text(Strings.shared.controllers.magazines.downloadMoreKey,
                style: TextStyle(
                    color: Statics.shared.colors.mainColor,
                    fontSize: Statics.shared.fontSizes.subTitle,
                    fontWeight: FontWeight.w600)),
            alignment: Alignment.center,
          ),
          onPressed: () {
            // download 5 more magazines ...
            this.download5MoreMagazines(page: pCurrent + 1);
          },
          padding: const EdgeInsets.all(0),
        ),
        decoration: BoxDecoration(
            border:
                Border.all(width: 2, color: Statics.shared.colors.mainColor)),
        width: screenWidth,
        height: 60,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 20, right: 16, left: 16, bottom: 20),
      );
      widget.myList.add(downloadMoreView);
    }
    setState(() {});
  }

  void download5MoreMagazines({int page = 1}) async {
    http.get(Statics.shared.urls.map(page: page)).then((val) {
      if (val.statusCode == 200) {
        print(
            "::::::::::::::::::::: [ Getting Map Start ] :::::::::::::::::::::");
        print("BODY: ${val.body.toString()}");
        var myJson = json.decode(utf8.decode(val.bodyBytes));

        int code = myJson["code"];
        if (code == 200) {
          List<MapObject> myReturnList = [];
          int pTotal = myJson["totalPageNum"];
          int pCurrent = myJson["nowPageNum"];
          List<dynamic> rows = myJson["rows"];

          List<Widget> newList = [];
          rows.forEach((item) async {
            MapObject object = MapObject(
              companyCode: item["companyCode"].toString(),
              companyName: item["companyName"].toString(),
              companyTel: item["companyTel"].toString(),
              companyAddress: item["companyAddress"].toString(),
            );
            newList.add(buttonList(
                item["companyCode"].toString(),
                item["companyName"],
                item["companyTel"],
                item["companyAddress"],
                object));
          });
          if (page == 1) {
            this.widget.magazinesList = newList;
          } else {
            this.widget.magazinesList.addAll(newList);
          }
          print(widget.myList);
          this.refreshList(pCurrent, pTotal);
        }
        print(
            "::::::::::::::::::::: [ Getting Map End ] :::::::::::::::::::::");
      } else {
        print(
            ":::::::::::::::::: on Getting Map error :: Server Error ::::::::::::::::::");
      }
    }).catchError((error) {
      print(
          ":::::::::::::::::: on Getting Map error : ${error.toString()} ::::::::::::::::::");
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
      download5MoreMagazines(page: 1);
      widget.isFirstInit = false;
    }

    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          title: Container(
              child: Text(Strings.shared.controllers.map.pageTitle,
                  style: TextStyle(
                      color: Statics.shared.colors.titleTextColor,
                      fontSize: Statics.shared.fontSizes.subTitle,
                      fontWeight: FontWeight.bold)),
              margin: const EdgeInsets.only(left: 8)),
          centerTitle: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
        ),
        body: new Column(
          children: <Widget>[
            Container(
                color: Statics.shared.colors.mainBackgroundVeryLightSilverBlue,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "Resources/Images/map.png",
                      scale: 3.0,
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Image.asset(
                            "Resources/Icons/mapDownload.png",
                            scale: 3.0,
                          ),
                          onPressed: () {},
                        ))
                  ],
                )
                //color: Colors.red,
                ),
            Container(
              color: Colors.blue,
              height: 3,
              //margin: const EdgeInsets.only(left: 16, right: 16)
            ),
            Expanded(
              child: new ListView.builder(
                  itemCount:
                      this.widget.myList.length, // number of items in your list

                  //here the implementation of itemBuilder. take a look at flutter docs to see details
                  itemBuilder: (BuildContext context, int Itemindex) {
                    return this.widget.myList[Itemindex]; // return your widget
                  }),
            )
          ],
        ));
  }

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 1000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  buttonList(String companyCode, String companyName, String companyTel,
      String companyAddress, MapObject obj) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(companyName,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.contentBig,
                          fontWeight: FontWeight.bold)),
                  width: screenWidth / 1.6),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(companyAddress,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: Statics.shared.colors.subTitleTextColor,
                          fontSize: Statics.shared.fontSizes.content)),
                  width: screenWidth / 1.6),
            ],
          ),
          Spacer(),
          Container(
              width: screenWidth / 7,
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Image.asset("Resources/Icons/icon_call.png", scale: 2.0),
                onPressed: () {
                  if (companyTel != "") {
                    launch("tel://" + companyTel);
                  } else {
                    _displaySnackBar(context, "전화번호 정보가 없습니다.");
                  }
                },
              )),
          Container(
              width: screenWidth / 7,
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Image.asset("Resources/Icons/icon_location.png",
                    scale: 2.0),
                onPressed: () async {
                  String googleUrl = Uri.encodeFull(
                      'https://www.google.com/maps/search/?api=1&query=$companyAddress');
                  if (await canLaunch(googleUrl)) {
                    await launch(googleUrl);
                  } else {
                    _displaySnackBar(context, "주소 정보가 없습니다.");
                  }
                },
              )),
        ],
      ),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Statics.shared.colors.lineColor)),
      ),
      height: 90,
      margin: const EdgeInsets.only(left: 16, top: 10),
    );
  }
}

Future<void> openUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
