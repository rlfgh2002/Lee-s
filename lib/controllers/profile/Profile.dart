import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/profile/AlarmAgree.dart';
import 'package:haegisa2/controllers/profile/FeeHistory.dart';
import 'package:haegisa2/controllers/profile/Inquiry.dart';
import 'package:haegisa2/controllers/profile/Occasion.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/controllers/profile/UserInfo.dart';
import 'package:http/http.dart' as http;

import 'Advisory.dart';
import 'Terms.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));
    String typeAsset = "";
    String typeTitle = "";
    Color typeColor;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    bool _isMember = false;

    if (userInformation.memberType == "51001") {
      typeAsset = "Resources/Icons/user_type_01.png";
      typeTitle = Strings.shared.controllers.profile.memberType1;
      typeColor = Statics.shared.colors.mainColor;
      _isMember = false;
    } else {
      typeAsset = "Resources/Icons/user_type_02.png";
      typeTitle = Strings.shared.controllers.profile.memberType2;
      typeColor = Statics.shared.colors.subColor;
      _isMember = true;
    }

    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(Strings.shared.controllers.profile.appTitle,
              style: TextStyle(
                  color: Statics.shared.colors.titleTextColor,
                  fontSize: Statics.shared.fontSizes.title)),
          titleSpacing: 16.0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          centerTitle: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(typeAsset, scale: 3),
                      Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                      userInformation.fullName +
                                          typeTitle.substring(0, 3),
                                      style: TextStyle(
                                          color: Statics
                                              .shared.colors.titleTextColor,
                                          fontSize: Statics.shared.fontSizes
                                              .titleInContent)),
                                  Text(typeTitle.substring(3, 6),
                                      style: TextStyle(
                                          color: typeColor,
                                          fontSize: Statics.shared.fontSizes
                                              .titleInContent)),
                                  Text(typeTitle.substring(6, 10),
                                      style: TextStyle(
                                          color: Statics
                                              .shared.colors.titleTextColor,
                                          fontSize: Statics.shared.fontSizes
                                              .titleInContent)),
                                ],
                              ),
                              Visibility(
                                visible: true,
                                child: new InkWell(
                                  onTap: () {
                                    print("requestMembership");
                                    typeSubmit();
                                  },
                                  child: Text(Strings
                                      .shared.controllers.profile.submitType),
                                ),
                              )
                            ],
                          ))
                    ]), //Row
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20, bottom: 15, top: 15),
              ),
              Image.asset('Resources/Icons/Line3.png'),
              Container(
                child: Column(children: [
                  Container(
                      child: IntrinsicHeight(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                            child: FlatButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Row(children: [
                                Image.asset(
                                    'Resources/Icons/btn_feehistory.png',
                                    scale: 2.5),
                                Text(
                                    " " +
                                        Strings.shared.controllers.profile
                                            .feehistory,
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary)),
                              ]),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            new FeeHistory()));
                              },
                            ),
                            width: deviceWidth / 2,
                            height: deviceWidth / 5),
                        VerticalDivider(width: 0),
                        SizedBox(
                            child: FlatButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Row(children: [
                                Image.asset('Resources/Icons/btn_inquiry.png',
                                    scale: 2.5),
                                Text(
                                    " " +
                                        Strings
                                            .shared.controllers.profile.inquiry,
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary)),
                              ]),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new Inquiry()));
                              },
                            ),
                            width: deviceWidth / 2,
                            height: deviceWidth / 5)
                      ],
                    ), // Row Children
                  )),
                  Row(children: <Widget>[
                    Expanded(child: Divider(height: 0)),
                  ]),
                  Container(
                      child: IntrinsicHeight(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                            child: FlatButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Row(children: [
                                Image.asset('Resources/Icons/btn_occasion.png',
                                    scale: 2.5),
                                Text(
                                    " " +
                                        Strings.shared.controllers.profile
                                            .occasion,
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary)),
                              ]),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new Occasion()));
                              },
                            ),
                            width: deviceWidth / 2,
                            height: deviceWidth / 5),
                        VerticalDivider(width: 0),
                        SizedBox(
                            child: FlatButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Row(children: [
                                Image.asset('Resources/Icons/btn_advisory.png',
                                    scale: 2.5),
                                Text(
                                    " " +
                                        Strings.shared.controllers.profile
                                            .advisory,
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary)),
                              ]),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new Advisory()));
                              },
                            ),
                            width: deviceWidth / 2,
                            height: deviceWidth / 5)
                      ],
                    ), // Row Children
                  )),
                ]), // Row
              ),
              Image.asset('Resources/Icons/Line3.png', width: 34),
              Container(
                child: Column(children: [
                  Container(
                    height: deviceWidth / 5,
                    padding: const EdgeInsets.only(left: 20, right: 5),
                    child: new Row(
                      children: <Widget>[
                        Text(
                          Strings.shared.controllers.profile.infoModify,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.supplementary),
                          textAlign: TextAlign.left,
                        ),
                        Spacer(),
                        SizedBox(
                          width: 50,
                          child: FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Image.asset('Resources/Icons/Vector 3.2.png',
                                width: 10, scale: 2.5),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new UserInfo()));
                            },
                          ),
                        )
                      ],
                    ), // Row Children
                  ),
                  Row(children: <Widget>[
                    Expanded(child: Divider(height: 0)),
                  ]),
                  Container(
                    height: deviceWidth / 5,
                    padding: const EdgeInsets.only(left: 20, right: 5),
                    child: new Row(
                      children: <Widget>[
                        Text(
                          Strings.shared.controllers.profile.alarm,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.supplementary),
                          textAlign: TextAlign.left,
                        ),
                        Spacer(),
                        SizedBox(
                          width: 50,
                          child: FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Image.asset('Resources/Icons/Vector 3.2.png',
                                width: 10, scale: 2.5),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new AlarmAgree()));
                            },
                          ),
                        )
                      ],
                    ), // Row Children
                  ),
                  Row(children: <Widget>[
                    Expanded(child: Divider(height: 0)),
                  ]),
                  Container(
                    height: deviceWidth / 5,
                    padding: const EdgeInsets.only(left: 20, right: 5),
                    child: new Row(
                      children: <Widget>[
                        Text(
                          Strings.shared.controllers.profile.terms,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.supplementary),
                          textAlign: TextAlign.left,
                        ),
                        Spacer(),
                        SizedBox(
                          width: 50,
                          child: FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Image.asset('Resources/Icons/Vector 3.2.png',
                                width: 10, scale: 2.5),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new Terms()));
                            },
                          ),
                        )
                      ],
                    ), // Row Children
                  ),
                  Row(children: <Widget>[
                    Expanded(child: Divider(height: 0)),
                  ]),
                  Container(
                    height: deviceWidth / 5,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: new Row(
                      children: <Widget>[
                        Text(
                          Strings.shared.controllers.profile.appVersion,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.supplementary),
                          textAlign: TextAlign.left,
                        ),
                        Spacer(),
                        Text(
                          "1.0.0 (최신)",
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.supplementary),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ), // Row Children
                  ),
                  Row(children: <Widget>[
                    Expanded(child: Divider(height: 0)),
                  ]),
                ]), // Row
              ),
            ], // Row Children
          ), // Row
          alignment: Alignment(0.0, 0.0),
        ), // Container
      ),
    );
  }

  typeSubmit() {
    var infomap = new Map<String, dynamic>();
    infomap["mode"] = "submit";
    infomap["userId"] = userInformation.userID;

    return http
        .post(Strings.shared.controllers.jsonURL.requestMemberJson,
            body: infomap)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      //final String responseBody = response.body; //한글 깨짐
      final String responseBody = utf8.decode(response.bodyBytes);
      var responseJSON = json.decode(responseBody);
      var code = responseJSON["code"];

      if (statusCode == 200) {
        if (code == 200) {
          // If the call to the server was successful, parse the JSON
        } else {
          // If that call was not successful, throw an error.
          throw Exception('Failed to load post');
        }
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }
}
