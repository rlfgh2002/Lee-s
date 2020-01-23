import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/notices/Notices.dart';
import 'package:haegisa2/models/DataBase/MyDataBase.dart';
import 'package:haegisa2/models/inquiry/InquiryListObject.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'InquiryList.dart';

class InquirySingle extends StatefulWidget {
  Map<String, dynamic> object;
  final db = MyDataBase();

  InquirySingle({Map<String, dynamic> obj}) {
    this.object = obj;
  }

  @override
  _InquirySingleState createState() => _InquirySingleState();
}

class _InquirySingleState extends State<InquirySingle> {
  final _scaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    widget.db.updateSeenQna(
      idx: this.widget.object['idx'].toString(),
    );
    if (Notices.staticNoticesPage != null) {
      Notices.staticNoticesPage.refresh();
    }
    super.initState();
  }

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
              new MaterialPageRoute(builder: (context) => new InquiryList()));
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

    bool isAnswer = false;
    Widget answer = Container();

    List<Container> answerList = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Container(
            child: Text("푸시알림",
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
        child: FutureBuilder(
          future: searchInquiry(), // a Future<String> or null
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                            color: Statics.shared.colors.titleTextColor,
                            fontSize: Statics.shared.fontSizes.subTitle)),
                    onPressed: () {},
                  ),
                  height: screenWidth / 6,
                );
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return Container(
                    child: ListView(
                      children: [
                        blueSplitter,
                        Padding(
                            child: Text(
                              "[답변완료] " + snapshot.data["subject"].toString(),
                              //this.widget.object.subject,
                              style: TextStyle(
                                fontSize:
                                    Statics.shared.fontSizes.subTitleInContent,
                                color: Statics.shared.colors.titleTextColor,
                                fontWeight: FontWeight.w600,
                              ), // TextStyle
                            ),
                            padding:
                                const EdgeInsets.only(left: 32, right: 32)),
                        SizedBox(height: 10),
                        Padding(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  userInformation.fullName,
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
                                  snapshot.data["regdate"].toString(),
                                  //this.widget.object.regDate,
                                  style: TextStyle(
                                    fontSize: Statics.shared.fontSizes.medium,
                                    color: Statics.shared.colors.captionColor,
                                    fontWeight: FontWeight.w300,
                                  ), // TextStyle
                                )
                              ], // Children
                            ),
                            padding:
                                const EdgeInsets.only(left: 32, right: 32)),
                        greySplitter,
                        HtmlView(
                          data: snapshot.data["contents"].toString(),
                          scrollable: false,
                          padding: const EdgeInsets.only(left: 40, right: 40),
                        ),
                        Container(
                          color: Color.fromRGBO(244, 248, 255, 1),
                          padding: const EdgeInsets.only(
                              bottom: 16, top: 16, left: 20, right: 20),
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                snapshot.data["comment"].toString(),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                snapshot.data["commentdate"].toString(),
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: Statics.shared.fontSizes.small,
                                    fontWeight: FontWeight.w200),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                        greySplitter,
                        listBtn
                      ], // Children
                    ),
                    color: Colors.white,
                  );
            }
          },
        ),
        color: Colors.white,
      ), // end Body
      key: _scaffold,
    );
  }

  searchInquiry() async {
    var response = await http.get(Uri.encodeFull(
        Strings.shared.controllers.jsonURL.inquiryJson +
            "?mode=search&idx=" +
            this.widget.object['idx'].toString() +
            "&userId=" +
            userInformation.userID));
    final String responseBody = utf8.decode(response.bodyBytes);
    var responseJSON = json.decode(responseBody);
    var code = responseJSON["code"];

    if (code == 200) {
      return responseJSON["rows"];
    }
  }

  void _moveBack(BuildContext context) => userInformation.userDeviceOS == "i"
      ? true
      : Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new InquiryList()));
}
