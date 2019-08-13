import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/controllers/profile/UserInfo.dart';
import 'package:haegisa2/controllers/profile/MiddleWare.dart';

class Home extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Home> {
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

    if (userInformation.memberType == "51001") {
      typeAsset = "Resources/Icons/user_type_01.png";
      typeTitle = Strings.shared.controllers.profile.memberType1;
      typeColor = Statics.shared.colors.mainColor;
    } else {
      typeAsset = "Resources/Icons/user_type_02.png";
      typeTitle = Strings.shared.controllers.profile.memberType2;
      typeColor = Statics.shared.colors.subColor;
    }

    return new WillPopScope(
      onWillPop: () async => false,

      // onWillPop: () async {
      //   Future.value(
      //       false); //return a `Future` with false value so this route cant be popped or closed.
      // },

      child: new Scaffold(
        body: Container(
          color: Color.fromRGBO(244, 248, 255, 1),
          child: ListView(
            children: [
              Container(
                child: Column(children: [
                  Text("이길호님, 안녕하세요",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Statics.shared.fontSizes.titleInContent,
                          fontWeight: FontWeight.bold)),
                  Text("오늘도 안전운항 하세요 ^^",
                      style: TextStyle(
                          color: Statics.shared.colors.subTitleTextColor,
                          fontSize: Statics.shared.fontSizes.subTitleInContent))
                ]), // Row
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                    left: 20, bottom: 30, top: 30, right: 15),
                color: Statics.shared.colors.mainColor,
              ),
              Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    border: new Border.all(
                      color: Color.fromRGBO(235, 239, 245, 1),
                    ),
                    boxShadow: [
                      new BoxShadow(
                          color: Color.fromRGBO(235, 239, 245, 1),
                          offset: new Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 2.0)
                    ]),
                margin:
                    EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
                child: Column(children: [
                  Container(
                    child: Column(children: <Widget>[
                      SizedBox(
                          child: FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Row(children: [
                              Text("공지사항",
                                  style: TextStyle(
                                      color:
                                          Statics.shared.colors.titleTextColor,
                                      fontSize:
                                          Statics.shared.fontSizes.subTitle,
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                              Text("+",
                                  style: TextStyle(
                                      color:
                                          Statics.shared.colors.titleTextColor,
                                      fontSize:
                                          Statics.shared.fontSizes.subTitle,
                                      fontWeight: FontWeight.bold))
                            ]),
                            onPressed: () {},
                          ),
                          height: deviceWidth / 6),
                      Row(children: <Widget>[
                        Expanded(child: Divider(height: 0)),
                      ]),
                      SizedBox(
                          child: FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Row(children: [
                              Text("공지사항",
                                  style: TextStyle(
                                      color:
                                          Statics.shared.colors.titleTextColor,
                                      fontSize:
                                          Statics.shared.fontSizes.subTitle)),
                            ]),
                            onPressed: () {},
                          ),
                          height: deviceWidth / 6),
                      Row(children: <Widget>[
                        Expanded(child: Divider(height: 0)),
                      ]),
                      SizedBox(
                          child: FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Row(children: [
                              Text("공지사항",
                                  style: TextStyle(
                                      color:
                                          Statics.shared.colors.titleTextColor,
                                      fontSize:
                                          Statics.shared.fontSizes.subTitle)),
                            ]),
                            onPressed: () {},
                          ),
                          height: deviceWidth / 6),
                    ]),
                  ),
                ]), // Row
              ),
              Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    border: new Border.all(
                      color: Color.fromRGBO(235, 239, 245, 1),
                    ),
                    boxShadow: [
                      new BoxShadow(
                          color: Color.fromRGBO(235, 239, 245, 1),
                          offset: new Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 2.0)
                    ]),
                margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                child: Column(children: [
                  Container(
                    child: Column(children: <Widget>[
                      SizedBox(
                          child: FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Row(children: [
                              Text("직역소개",
                                  style: TextStyle(
                                      color:
                                          Statics.shared.colors.titleTextColor,
                                      fontSize:
                                          Statics.shared.fontSizes.subTitle,
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                              Text("+",
                                  style: TextStyle(
                                      color:
                                          Statics.shared.colors.titleTextColor,
                                      fontSize:
                                          Statics.shared.fontSizes.subTitle,
                                      fontWeight: FontWeight.bold))
                            ]),
                            onPressed: () {},
                          ),
                          height: deviceWidth / 6),
                      Row(children: <Widget>[
                        Expanded(child: Divider(height: 0)),
                      ]),
                      SizedBox(
                          child: FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Row(children: [
                              Text("공지사항",
                                  style: TextStyle(
                                      color:
                                          Statics.shared.colors.titleTextColor,
                                      fontSize:
                                          Statics.shared.fontSizes.subTitle)),
                            ]),
                            onPressed: () {},
                          ),
                          height: deviceWidth / 6),
                    ]),
                  )
                ]), // Row
              ),
              Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    border: new Border.all(
                      color: Color.fromRGBO(235, 239, 245, 1),
                    ),
                    boxShadow: [
                      new BoxShadow(
                          color: Color.fromRGBO(235, 239, 245, 1),
                          offset: new Offset(3.0, 3.0),
                          blurRadius: 0.5,
                          spreadRadius: 0)
                    ]),
                margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(children: <Widget>[
                    Container(
                        child: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Row(children: [
                            Image.asset('Resources/Images/ill_service.png',
                                scale: 4.0),
                          ]),
                          onPressed: () {},
                        ),
                        height: deviceWidth / 4),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Column(children: [
                          Text("한국해기사협회의",
                              style: TextStyle(
                                color: Statics.shared.colors.titleTextColor,
                                fontSize:
                                    Statics.shared.fontSizes.supplementary,
                              ),
                              textAlign: TextAlign.left),
                          Text("종합서비스센터 업무대행 소개",
                              style: TextStyle(
                                  color: Statics.shared.colors.titleTextColor,
                                  fontSize: Statics.shared.fontSizes.subTitle,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left),
                        ]))
                  ]),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      border: new Border.all(
                        color: Color.fromRGBO(235, 239, 245, 1),
                      ),
                      boxShadow: [
                        new BoxShadow(
                            color: Color.fromRGBO(235, 239, 245, 1),
                            offset: new Offset(3.0, 3.0),
                            blurRadius: 0.5,
                            spreadRadius: 0)
                      ]),
                  margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                  child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: Column(children: [
                                FlatButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Row(children: [
                                    Image.asset(
                                        'Resources/Icons/icon_intro.png',
                                        scale: 4.0),
                                  ]),
                                  onPressed: () {},
                                ),
                                Text("협회소개",
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: 13),
                                    textAlign: TextAlign.left),
                              ]),
                              height: deviceWidth / 5),
                          Container(
                              child: Column(children: [
                                FlatButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Row(children: [
                                    Image.asset(
                                        'Resources/Icons/icon_webzine.png',
                                        scale: 4.0),
                                  ]),
                                  onPressed: () {},
                                ),
                                Text("웹진",
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: 13),
                                    textAlign: TextAlign.left),
                              ]),
                              height: deviceWidth / 5),
                          Container(
                              child: Column(children: [
                                FlatButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Row(children: [
                                    Image.asset(
                                        'Resources/Icons/icon_survey.png',
                                        scale: 4.0),
                                  ]),
                                  onPressed: () {},
                                ),
                                Text("설문조사",
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: 13),
                                    textAlign: TextAlign.left),
                              ]),
                              height: deviceWidth / 5),
                          Container(
                              child: Column(children: [
                                FlatButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Row(children: [
                                    Image.asset('Resources/Icons/icon_map.png',
                                        scale: 4.0),
                                  ]),
                                  onPressed: () {},
                                ),
                                Text("해운선사지도",
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: 13),
                                    textAlign: TextAlign.left),
                              ]),
                              height: deviceWidth / 5),
                        ]),
                  ),
                  height: deviceWidth / 3),
              Image.asset('Resources/Icons/Line3.png'),
            ], // Row Children
          ), // Row

          alignment: Alignment(0.0, 0.0),
        ), // Container
      ),
    );
  }
}
