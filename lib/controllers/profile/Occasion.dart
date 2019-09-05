import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:http/http.dart' as http;

class Occasion extends StatefulWidget {
  @override
  _OccasionState createState() => _OccasionState();
}

class _OccasionState extends State<Occasion> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    TextEditingController _nameController;
    TextEditingController _birthController;
    bool _nameChecked = false;
    bool _birthChecked = false;
    String name;
    String birth;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("경조사 통보",
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
      body: Column(children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Container(
                height: deviceHeight / 5,
                child: Image.asset(
                  "Resources/Images/occasion.png",
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 5,
                        ),
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 12,
                        child: txtField(_nameController, TextInputType.text,
                            "이름", name, _nameChecked)),
                    Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 5,
                        ),
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 12,
                        child: txtField(_birthController, TextInputType.number,
                            "생년월일", birth, _birthChecked)),
                    Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 5,
                        ),
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 12,
                        child: txtField(_nameController, TextInputType.text,
                            "회사명", name, _nameChecked)),
                    Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 5,
                        ),
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 12,
                        child: txtField(_nameController, TextInputType.number,
                            "휴대폰번호", name, _nameChecked)),
                  ])
            ],
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

  Widget txtField(controller, inputType, hint, content, checked) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: Statics.shared.fontSizes.subTitle,
            color: Statics.shared.colors.subTitleTextColor,
          ),
          border: OutlineInputBorder(),
          hintText: hint),
      obscureText: false, // decoration
      onChanged: (String str) {
        content = str;
        if (str.length > 0) {
          checked = true;
        } else {
          checked = false;
        }
      },
    );
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
