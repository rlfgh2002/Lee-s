import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SearchAddress extends StatefulWidget {
  SearchAddress() {}

  @override
  _SearchAddressState createState() {
    return _SearchAddressState();
  }
}

class _UserAddress {
  static _UserAddress shared = _UserAddress();
  _UserAddress() {}

  String address1 = "";
  String postNo = "";

  // Other User Information will Store Here...
}

final _UserAddress userAddress = _UserAddress.shared;

class _SearchAddressState extends State<SearchAddress> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> myList = [];
  String addressKeyword;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    return AlertDialog(
      content: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 30),
              child: Image.asset(
                "Resources/Images/requestMember.png",
                scale: 3.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Statics.shared.colors.mainColor,
                  width: 2,
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width / 1.9,
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: Statics.shared.fontSizes.subTitle,
                              color: Statics.shared.colors.subTitleTextColor,
                            ),
                            hintText: "주소를 입력하세요."), // decoration
                        onChanged: (String str) {
                          addressKeyword = str;
                        },
                      )),
                  Spacer(),
                  Container(
                      width: MediaQuery.of(context).size.width / 6.8,
                      alignment: Alignment.centerRight,
                      color: Statics.shared.colors.mainColor,
                      child: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Text("검색",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    Statics.shared.fontSizes.supplementary,
                              )),
                          onPressed: () async {
                            myList = [];
                            var map = new Map<String, dynamic>();

                            map["confmKey"] =
                                "U01TX0FVVEgyMDE5MTAwMjE3MDEyMDEwOTA2ODY=";
                            map["resultType"] = "json";
                            map["countPerPage"] = "99";
                            map["keyword"] = addressKeyword;

                            await searchAddress(
                                "http://www.juso.go.kr/addrlink/addrLinkApi.do",
                                body: map);
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            setState(() {});
                          })),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: new ListView.builder(
                  key: new Key(DateFormat("yyyyMMddHHmmss")
                      .format(DateTime.now())), //리스트당 고유된 키를 부여
                  itemCount: this.myList.length, // number of items in your list
                  //here the implementation of itemBuilder. take a look at flutter docs to see details
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return this.myList[itemIndex]; // return your widget
                  }),
            )
          ],
        ),
      ),
    );
  }

  Future searchAddress(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;
      //final String responseBody = response.body; //한글 깨짐
      final String responseBody = utf8.decode(response.bodyBytes);
      var responseJSON = json.decode(responseBody);
      var errorMessage = responseJSON["results"]["common"]["errorMessage"];
      var juso = responseJSON["results"]["juso"];

      if (statusCode == 200) {
        if (errorMessage == "정상") {
          if (juso.length != 0) {
            for (var result in juso) {
              myList.add(addrList(result["roadAddr"], result["zipNo"]));
            }
          } else {
            return showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => AlertDialog(
                      title: new Text("오류"),
                      content: new Text("검색결과가 없습니다.",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          child: new Text("확인",
                              style: TextStyle(
                                  fontSize:
                                      Statics.shared.fontSizes.supplementary,
                                  color: Colors.black)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
          }
        } else {
          return showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => AlertDialog(
                    title: new Text("오류"),
                    content: new Text(errorMessage,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      new FlatButton(
                        child: new Text("확인",
                            style: TextStyle(
                                fontSize:
                                    Statics.shared.fontSizes.supplementary,
                                color: Colors.black)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));
        }
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

  addrList(
    String addr,
    String post,
  ) {
    return Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: GestureDetector(
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 1.9,
                child: Text(addr,
                    style: TextStyle(
                        fontSize: Statics.shared.fontSizes.supplementary,
                        color: Colors.black)),
              ),
              Spacer(),
              Text(post,
                  style: TextStyle(
                      fontSize: Statics.shared.fontSizes.supplementary,
                      color: Statics.shared.colors.subTitleTextColor))
            ],
          ),
          onTap: () {
            setState(() {
              userAddress.address1 = addr;
              userAddress.postNo = post;
            });

            Navigator.of(context).pop();
          },
        ));
  }
}
