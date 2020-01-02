import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/Gallery/GalleryListObject.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Gallerylist.dart';

class GallerylistSingle extends StatefulWidget {
  GalleryListObject object;

  GallerylistSingle({GalleryListObject obj}) {
    this.object = obj;
  }

  @override
  _GallerylistSingleState createState() => _GallerylistSingleState();
}

class _GallerylistSingleState extends State<GallerylistSingle> {
  final _scaffold = GlobalKey<ScaffoldState>();

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
    Widget listBtn = Container(
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
              new MaterialPageRoute(builder: (context) => new GalleryList()));
        },
        padding: const EdgeInsets.all(0),
      ),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Statics.shared.colors.mainColor)),
      width: screenWidth,
      height: 60,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20, right: 16, left: 16, bottom: 20),
    );

    Widget files = Container();
    Widget thumb = Container();
    bool isThereAnyFiles = false;
    List<FlatButton> myFilesList = [];
    List<Container> myThumbList = [];

    if (this.widget.object.fileUrl_1.isNotEmpty) {
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
                      this.widget.object.realFileName1.toString(),
                      maxLines: 1,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
          ),
          onPressed: () {
            _launchURL(this.widget.object.fileUrl_1);
          },
        ),
      );
      myThumbList.add(
        Container(
          child: Image.network(
            "http://www.mariners.or.kr/uploads/photoNews/Thumb_" +
                this.widget.object.serverFileName_1.toString(),
            height: screenWidth / 1.7,
          ),
        ),
      );
    }
    if (this.widget.object.fileUrl_2.isNotEmpty) {
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
                    child: Text(this.widget.object.realFileName2.toString(),
                        maxLines: 1,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          onPressed: () {
            _launchURL(this.widget.object.fileUrl_2);
          },
        ),
      );
      myThumbList.add(
        Container(
          child: Image.network(
            "http://www.mariners.or.kr/uploads/photoNews/Thumb_" +
                this.widget.object.serverFileName_2.toString(),
            height: screenWidth / 1.7,
          ),
        ),
      );
    }
    if (this.widget.object.fileUrl_3.isNotEmpty) {
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
                    child: Text(this.widget.object.realFileName3.toString(),
                        maxLines: 1,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          onPressed: () {
            _launchURL(this.widget.object.fileUrl_3);
          },
        ),
      );
      myThumbList.add(
        Container(
          child: Image.network(
            "http://www.mariners.or.kr/uploads/photoNews/Thumb_" +
                this.widget.object.serverFileName_3.toString(),
            height: screenWidth / 1.7,
          ),
        ),
      );
    }
    if (this.widget.object.fileUrl_4.isNotEmpty) {
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
                    child: Text(this.widget.object.realFileName4.toString(),
                        maxLines: 1,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          onPressed: () {
            _launchURL(this.widget.object.fileUrl_4);
          },
        ),
      );
      myThumbList.add(
        Container(
          child: Image.network(
            "http://www.mariners.or.kr/uploads/photoNews/Thumb_" +
                this.widget.object.serverFileName_4.toString(),
            height: screenWidth / 1.7,
          ),
        ),
      );
    }

    if (isThereAnyFiles) {
      files = Container(
        color: Color.fromRGBO(244, 248, 255, 1),
        padding: const EdgeInsets.only(bottom: 16, top: 16, left: 8, right: 8),
        margin: const EdgeInsets.only(left: 32, right: 32, top: 20, bottom: 32),
        child: Column(children: myFilesList),
      );
      thumb = Container(
        padding: const EdgeInsets.only(bottom: 16, top: 16, left: 8, right: 8),
        margin: const EdgeInsets.only(left: 32, right: 32, top: 20, bottom: 32),
        child: Column(children: myThumbList),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Container(
            child: Text("협회활동",
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
          children: [
            blueSplitter,
            Padding(
                child: Text(
                  this.widget.object.subject,
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
                      this.widget.object.writer,
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
                      this.widget.object.regDate,
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
            thumb,
            HtmlView(
              data: this.widget.object.content,
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

  void _moveBack(BuildContext context) => userInformation.userDeviceOS == "i"
      ? true
      : Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new GalleryList()));
}
