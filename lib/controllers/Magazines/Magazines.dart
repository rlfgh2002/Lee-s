import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:haegisa2/models/Magazines/Magazine.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/Magazines/Magazines.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

bool isDownload = true; //다운로드 할수 있는지 이미 다운된것은 false

var _localPath = userInformation.dirPath.path + "/Magazines";

//magazinesList를 myList에 넣는다.
//myList는 0행,1행,마지막행은 Container가 들어가고 그 가운데 magazineList가 들어간다.
//리스트 값을 변경할 때에는 해당 두 리스트의 값을 다 변경해야한다.
class Magazines extends StatefulWidget {
  bool isFirstInit = true;

  Magazines({Key key}) : super(key: key);
  List<Widget> myList = [];
  List<Widget> magazinesList = [];

  @override
  _MagazinesState createState() => _MagazinesState();
}

class _MagazinesState extends State<Magazines> {
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
    http.get(Statics.shared.urls.magazines(page: page)).then((val) {
      if (val.statusCode == 200) {
        print(
            "::::::::::::::::::::: [ Getting Magazines Start ] :::::::::::::::::::::");
        print("BODY: ${val.body.toString()}");
        var myJson = json.decode(utf8.decode(val.bodyBytes));

        int code = myJson["code"];
        if (code == 200) {
          List<MagazineObject> myReturnList = [];
          int pTotal = myJson["totalPageNum"];
          int pCurrent = myJson["nowPageNum"];
          List<dynamic> rows = myJson["rows"];

          List<Widget> newList = [];
          rows.forEach((item) async {
            MagazineObject object = MagazineObject(
              subject: item["subject"].toString(),
              fileUrl: item["subject"].toString(),
              realFileName: item["subject"].toString(),
              serverFileName: item["subject"].toString(),
            );

            final myFile = File(_localPath + "/" + item["serverFileName"]);

            if (myFile.existsSync()) {
              isDownload = false;
            } else {
              isDownload = true;
            }

            if (item["fileUrl"].toString().isEmpty) {
              newList.add(buttonList(
                  item["subject"].toString(),
                  item["fileUrl"],
                  item["serverFileName"],
                  magazineNum - 1,
                  false,
                  object));
            } else {
              newList.add(buttonList(
                  item["subject"].toString(),
                  item["fileUrl"],
                  item["serverFileName"],
                  magazineNum - 1,
                  isDownload,
                  object));
            }
            magazineNum++;
            print(magazineNum - 1);
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
            "::::::::::::::::::::: [ Getting Magazines End ] :::::::::::::::::::::");
      } else {
        print(
            ":::::::::::::::::: on Getting Magazines error :: Server Error ::::::::::::::::::");
      }
    }).catchError((error) {
      print(
          ":::::::::::::::::: on Getting Magazines error : ${error.toString()} ::::::::::::::::::");
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
              child: Text(Strings.shared.controllers.magazines.pageTitle,
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
              child: Stack(
                children: [
                  Image.asset(
                    "Resources/Images/bgMagazine.png",
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                  ),
                  Row(
                    children: [
                      Padding(
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                    Strings.shared.controllers.magazines.title1,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Statics.shared.colors.mainColor,
                                        fontSize:
                                            Statics.shared.fontSizes.subTitle,
                                        fontWeight: FontWeight.w800)),
                                width:
                                    (MediaQuery.of(context).size.width - 64) -
                                        40,
                              ),
                              SizedBox(height: 5),
                              Container(
                                child: Text(
                                    Strings
                                        .shared.controllers.magazines.caption1,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color:
                                            Statics.shared.colors.captionColor,
                                        fontSize:
                                            Statics.shared.fontSizes.medium)),
                                width:
                                    (MediaQuery.of(context).size.width - 64) -
                                        40,
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                          padding: const EdgeInsets.only(left: 32)),
                      Padding(
                        child: Image.asset("Resources/Icons/magazineIcon.png",
                            width: 40),
                        padding: const EdgeInsets.only(right: 32),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ), // Row
                ],
              ),
              alignment: Alignment.center,
              height: 100,
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
      duration: Duration(milliseconds: 1500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  buttonList(String title, String fileURL, String serverFileName,
      int magazineNum, bool isDownload, MagazineObject obj) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingSize = 16;
    double buttonSize = 100;
    double buttonRealSize = buttonSize - 10;
    double buttonHeight = 40;
    Widget downloadButton = Container(
      child: Text(Strings.shared.controllers.magazines.downloadKeyword,
          style: TextStyle(
              color: Colors.white, fontSize: Statics.shared.fontSizes.content)),
      decoration: BoxDecoration(
          border:
              Border.all(width: 1.5, color: Statics.shared.colors.mainColor),
          color: Statics.shared.colors.mainColor),
      width: buttonRealSize,
      height: buttonHeight,
      alignment: Alignment.center,
    );
    Widget exampleButton = Container(
      child: Text(Strings.shared.controllers.magazines.exampleKeyword,
          style: TextStyle(
              color: Statics.shared.colors.mainColor,
              fontSize: Statics.shared.fontSizes.content)),
      decoration: BoxDecoration(
          border:
              Border.all(width: 1.5, color: Statics.shared.colors.mainColor)),
      width: buttonRealSize,
      height: buttonHeight,
      alignment: Alignment.center,
    );

    Widget selectedButton;
    if (isDownload) {
      selectedButton = downloadButton;
    } else {
      selectedButton = exampleButton;
    }
    return FlatButton(
      child: Container(
        child: Row(
          children: [
            Container(
              child: Text(title,
                  style: TextStyle(
                      color: Statics.shared.colors.titleTextColor,
                      fontSize: Statics.shared.fontSizes.content)),
              width: (screenWidth - (paddingSize * 2)) - buttonSize,
            ),
            Container(
              width: buttonSize,
              child: selectedButton,
              alignment: Alignment.center,
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Statics.shared.colors.lineColor)),
        ),
        height: 70,
        margin: const EdgeInsets.only(left: 16, right: 16),
      ),
      padding: const EdgeInsets.all(0),
      onPressed: () async {
        if (isDownload == true) {
          print(fileURL);
          var changeURL;
          if (userInformation.userDeviceOS != "i") {
            changeURL = fileURL.replaceAll(new RegExp("https://"), "http://");
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

          FlutterDownloader.registerCallback((id, status, progress) {
            // code to update your UI
            if (status == DownloadTaskStatus.complete) {
              FlutterDownloader.open(taskId: taskId);
              print("다운완료");
              setState(() {
                widget.magazinesList[magazineNum + 1] = buttonList(
                    title, fileURL, serverFileName, magazineNum, false, obj);
                widget.myList[magazineNum + 1] = buttonList(
                    title, fileURL, serverFileName, magazineNum, false, obj);

                _displaySnackBar(context, "다운로드 완료");
                return;
              });
            } else if (status == DownloadTaskStatus.failed) {
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

          OpenFile.open(_localPath + "/" + serverFileName);

          // final ByteData bytes = await DefaultAssetBundle.of(context)
          //     .load(_localPath + "/" + serverFileName);
          // final Uint8List list = bytes.buffer.asUint8List();

          // final file = await File(_localPath + "/" + serverFileName)
          //     .create(recursive: true);
          // file.writeAsBytesSync(list);
        }
      },
    );
  }
}
