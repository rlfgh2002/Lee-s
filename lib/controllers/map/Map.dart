import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:haegisa2/controllers/home/Home.dart';
import 'package:haegisa2/models/Magazines/Magazine.dart';
import 'package:haegisa2/models/Map/Map.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
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
  String keyword = "";

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
            this.download5MoreMagazines(page: pCurrent + 1, keyword: keyword);
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

  void searchList(int pCurrent, pTotal) {
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
            this.download5MoreMagazines(page: pCurrent + 1, keyword: keyword);
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

  void download5MoreMagazines({int page = 1, String keyword}) async {
    http.get(Statics.shared.urls.map(page: page, keyword: keyword)).then((val) {
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
      download5MoreMagazines(page: 1, keyword: keyword);
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
                          onPressed: () async {
                            final myFile =
                                File(_localPath + "/haegisa_map.pdf");
                            var fileURL =
                                "https://mariners.or.kr/uploads/haegisa_map.pdf";

                            if (myFile.existsSync()) {
                              isDownload = false;
                            } else {
                              isDownload = true;
                            }

                            if (isDownload == true) {
                              print(fileURL);
                              var changeURL;
                              if (userInformation.userDeviceOS != "i") {
                                changeURL = fileURL.replaceAll(
                                    new RegExp("https://"), "http://");
                              } else {
                                changeURL = fileURL;
                              }

                              final taskId = await FlutterDownloader.enqueue(
                                url: changeURL,
                                savedDir: _localPath,
                                showNotification:
                                    true, // show download progress in status bar (for Android)
                                openFileFromNotification:
                                    true, // click on notification to open downloaded file (for Android)
                              );

                              FlutterDownloader.registerCallback(
                                  (id, status, progress) {
                                // code to update your UI
                                if (status == DownloadTaskStatus.complete) {
                                  FlutterDownloader.open(taskId: taskId);
                                  print("다운완료");
                                  _displaySnackBar(context, "다운로드 완료");
                                  OpenFile.open(
                                      _localPath + "/haegisa_map.pdf");
                                  return;
                                } else if (status ==
                                    DownloadTaskStatus.failed) {
                                  print("다운실패");
                                  _displaySnackBar(context, "다운로드 실패");
                                  return;
                                }
                              });

                              var file = Directory(_localPath).listSync();
                              print(file);
                            } else {
                              print("파일 오픈");
                              //launch(fileURL);

                              OpenFile.open(_localPath + "/haegisa_map.pdf");
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => FullPdfViewerScreen(
                              //           _localPath + "/haegisa_map.pdf")),
                              // );

                              // final ByteData bytes = await DefaultAssetBundle.of(context)
                              //     .load(_localPath + "/" + serverFileName);
                              // final Uint8List list = bytes.buffer.asUint8List();

                              // final file = await File(_localPath + "/" + serverFileName)
                              //     .create(recursive: true);
                              // file.writeAsBytesSync(list);
                            }
                          },
                        ))
                  ],
                )
                //color: Colors.red,
                ),
            Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Statics.shared.colors.mainColor,
                  width: 2,
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                    width: deviceWidth / 1.5,
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: Statics.shared.fontSizes.subTitle,
                            color: Statics.shared.colors.subTitleTextColor,
                          ),
                          hintText: "검색어를 입력하세요."), // decoration
                      onChanged: (String str) {
                        keyword = str.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
                      },
                    ),
                  ),
                  Spacer(),
                  Container(
                      width: 70,
                      color: Statics.shared.colors.mainColor,
                      child: FlatButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Text("검색",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Statics.shared.fontSizes.supplementary,
                            )),
                        onPressed: () {
                          widget.isFirstInit = true;
                          download5MoreMagazines(page: 1, keyword: keyword);
                          widget.isFirstInit = false;
                        },
                      ))
                ],
              ),
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
      duration: Duration(milliseconds: 1500),
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
                          fontSize: Statics.shared.fontSizes.supplementaryBig,
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
                          fontSize: Statics.shared.fontSizes.supplementary)),
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
