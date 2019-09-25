import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:http/http.dart' as http;

class FeeHistory extends StatefulWidget {
  @override
  _FeeHistoryState createState() => _FeeHistoryState();
}

class _FeeHistoryState extends State<FeeHistory> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("회비납부내역",
            style: TextStyle(
                color: Statics.shared.colors.titleTextColor,
                fontSize: Statics.shared.fontSizes.subTitle,
                fontWeight: FontWeight.bold)),
        titleSpacing: 16.0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
      ),
      body: Column(children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Container(
                height: deviceHeight / 5,
                child: Image.asset(
                  "Resources/Images/feeHistory.png",
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, bottom: 5),
                alignment: Alignment.bottomLeft,
                height: deviceHeight / 12,
                child: Text("납부내역",
                    style: TextStyle(
                        color: Statics.shared.colors.subTitleTextColor,
                        fontSize: Statics.shared.fontSizes.subTitle)),
              ),
              Row(children: <Widget>[
                Expanded(child: Divider(height: 0)),
              ]),
            ],
          ),
        ),
        Expanded(
          child: new FutureBuilder(
            future: getfeeList(), // a Future<String> or null
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
                    height: deviceWidth / 6,
                  );
                default:
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  else
                    return feeListview(context, snapshot);
              }
            },
          ),
        )
      ]),
    );
  }

  getfeeList() async {
    var map = new Map<String, dynamic>();
    map["mode"] = "list";
    map["userId"] = userInformation.userID;

    return await getfeeListJson(
        Strings.shared.controllers.jsonURL.feeHistoryJson,
        body: map);
  }

  Future<List> getfeeListJson(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;
      //final String responseBody = response.body; //한글 깨짐
      final String responseBody = utf8.decode(response.bodyBytes);
      var responseJSON = json.decode(responseBody);
      var code = responseJSON["code"];

      if (statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        if (code == 200) {
          return responseJSON["rows"];
        }
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

  Widget feeListview(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;

    if (values != null) {
      return ListView(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            for (var item in values)
              Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 5,
                  ),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 12,
                  child: Row(children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      child: Text(item["payDate"],
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize:
                                  Statics.shared.fontSizes.supplementary)),
                    ),
                    new Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 1.8,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Text(item["companyName"],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Statics.shared.colors.titleTextColor,
                                fontSize:
                                    Statics.shared.fontSizes.supplementary,
                              )),
                        ],
                      ),
                    ),
                    Spacer(),
                    new Container(
                      child: Text(item["money"],
                          style: TextStyle(
                            color: Statics.shared.colors.titleTextColor,
                            fontSize: Statics.shared.fontSizes.supplementary,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ])),
            Row(children: <Widget>[
              Expanded(child: Divider(height: 0)),
            ]),
          ],
        )
      ]);
    } else {
      return Container(
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 20),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 12,
          child: Container(
            child: Column(children: <Widget>[
              Image.asset(
                "Resources/Icons/none.png",
                scale: 4.0,
              ),
              SizedBox(height: 10),
              Text(
                "최근 1년간 납부내역이 없습니다.",
                style: TextStyle(
                    color: Statics.shared.colors.titleTextColor,
                    fontSize: Statics.shared.fontSizes.subTitleInContent),
              )
            ]),
          ));
    }
  }
}
