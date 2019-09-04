import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haegisa2/models/Magazines/Magazine.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/Magazines/Magazines.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Magazines extends StatefulWidget {
  bool isFirstInit = true;
  Magazines({Key key}) : super(key: key);
  List<Widget> myList = [];
  List<Widget> magazinesList = [];

  @override
  _MagazinesState createState() => _MagazinesState();
}

class _MagazinesState extends State<Magazines> {
  final _scaffold = GlobalKey<ScaffoldState>();

  void refreshList(int pCurrent, pTotal) {
    widget.myList = [];
    double screenWidth = MediaQuery.of(context).size.width;
    Widget topView = Container(
      child: Stack(
        children: [
          Image.asset(
            "Resources/Images/bgMagazine.png",
            width: screenWidth,
            height: 100,
          ),
          Row(
            children: [
              Padding(
                  child: Column(
                    children: [
                      Container(
                        child: Text(Strings.shared.controllers.magazines.title1,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Statics.shared.colors.mainColor,
                                fontSize: Statics.shared.fontSizes.subTitle,
                                fontWeight: FontWeight.w800)),
                        width: (screenWidth - 64) - 40,
                      ),
                      SizedBox(height: 5),
                      Container(
                        child: Text(
                            Strings.shared.controllers.magazines.caption1,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Statics.shared.colors.captionColor,
                                fontSize: Statics.shared.fontSizes.medium)),
                        width: (screenWidth - 64) - 40,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  padding: const EdgeInsets.only(left: 32)),
              Padding(
                child:
                    Image.asset("Resources/Icons/magazineIcon.png", width: 40),
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
      color: Colors.red,
    );
    Widget blueSplitter = Container(
        color: Colors.blue,
        height: 3,
        margin: const EdgeInsets.only(left: 16, right: 16));
    widget.myList.add(topView);
    widget.myList.add(blueSplitter);

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
        var json = jsonDecode(val.body);

        int code = json["code"];
        if (code == 200) {
          List<MagazineObject> myReturnList = [];
          int pTotal = json["totalPageNum"];
          int pCurrent = json["nowPageNum"];
          List<dynamic> rows = json["rows"];

          List<Widget> newList = [];
          rows.forEach((item) {
            MagazineObject object = MagazineObject(
              subject: item["subject"].toString(),
              fileUrl: item["subject"].toString(),
              realFileName: item["subject"].toString(),
              serverFileName: item["subject"].toString(),
            );
            if (item["fileUrl"].toString().isEmpty) {
              newList.add(MagazineWidget(
                  title: item["subject"].toString(),
                  isDownload: false,
                  obj: object));
            } else {
              newList.add(MagazineWidget(
                  title: item["subject"].toString(),
                  isDownload: true,
                  obj: object));
            }
          });
          if (page == 1) {
            this.widget.magazinesList = newList;
          } else {
            this.widget.magazinesList.addAll(newList);
          }
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
    if (widget.isFirstInit) {
      download5MoreMagazines(page: 1);
      widget.isFirstInit = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
            child: Text(Strings.shared.controllers.magazines.pageTitle,
                style: TextStyle(
                    color: Statics.shared.colors.titleTextColor,
                    fontSize: Statics.shared.fontSizes.subTitle)),
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
