import 'dart:convert';

import 'package:flutter/material.dart';
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
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("회비납부내역",
            style: TextStyle(
                color: Statics.shared.colors.titleTextColor,
                fontSize: Statics.shared.fontSizes.title)),
        titleSpacing: 16.0,
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              Container(
                  child: Text(Strings.shared.controllers.findUser.title1,
                      style: TextStyle(
                          fontSize: Statics.shared.fontSizes.titleInContent,
                          color: Statics.shared.colors.titleTextColor),
                      textAlign: TextAlign.center),
                  margin: const EdgeInsets.only(bottom: 15)),
              Container(
                  child: Text(Strings.shared.controllers.findUser.caption1,
                      style: TextStyle(
                          fontSize: Statics.shared.fontSizes.content,
                          color: Statics.shared.colors.captionColor),
                      textAlign: TextAlign.center),
                  margin: const EdgeInsets.only(bottom: 30)),
              Container(
                child: TextField(
                  autofocus: false,
                  maxLines: 1,
                  minLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText:
                        Strings.shared.controllers.findUser.searchPlaceHolder,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.only(
                        left: 32, right: 32, top: 20, bottom: 20),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: Color.fromRGBO(241, 244, 250, 1)),
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    hintStyle: TextStyle(
                        fontSize: Statics.shared.fontSizes.content,
                        color: Statics.shared.colors.subTitleTextColor),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                  ),
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.content,
                    color: Statics.shared.colors.titleTextColor,
                  ),
                  onTap: () {},
                ),
              )
            ], // children
          ),
          color: Statics.shared.colors.mainBackgroundVeryLightSilverBlue,
          alignment: Alignment.center), // end body
    );
  }
}
