import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:http/http.dart' as http;

var schoolTable = new List();

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  List<String> _schoolList = [];
  String _selectedLocation;

  String hp = userInformation.hp.replaceAll("-", "");
  String email = userInformation.email;
  String school = userInformation.school;
  String gisu = userInformation.gisu;

  @override
  Widget build(BuildContext context) {
    String typeAsset = "";
    String userType = "";
    Color typeColor;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    getSchool();

    if (userInformation.memberType == "51001") {
      typeAsset = "Resources/Icons/user_type_01.png";
      userType = "정회원";
      typeColor = Statics.shared.colors.mainColor;
    } else {
      userType = "준회원";
      typeColor = Statics.shared.colors.subColor;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.shared.controllers.profile.userinfoTitle,
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
        color: Colors.white,
        child: ListView(
          children: [
            Image.asset('Resources/Icons/Line3.png', width: 34),
            Container(
              child: Column(children: [
                Container(
                  height: deviceWidth / 5,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: new Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          Strings.shared.controllers.profile.userName,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.supplementary,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        width: deviceWidth / 5,
                        padding: const EdgeInsets.only(right: 10),
                      ),
                      Text(
                        userInformation.fullName,
                        style: TextStyle(
                          color: Statics.shared.colors.subTitleTextColor,
                          fontSize: Statics.shared.fontSizes.supplementary,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Spacer(),
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
                      Container(
                        child: Text(
                          Strings.shared.controllers.profile.userType,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.supplementary,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        width: deviceWidth / 5,
                        padding: const EdgeInsets.only(right: 10),
                      ),
                      Text(
                        userType,
                        style: TextStyle(
                          color: Statics.shared.colors.subTitleTextColor,
                          fontSize: Statics.shared.fontSizes.supplementary,
                        ),
                        textAlign: TextAlign.left,
                      ),
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
                      Container(
                        child: Text(
                          Strings.shared.controllers.profile.userPhone,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.supplementary,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        width: deviceWidth / 5,
                        padding: const EdgeInsets.only(right: 10),
                      ),
                      Expanded(
                          child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: Statics.shared.fontSizes.supplementary,
                              color: Statics.shared.colors.titleTextColor,
                            ),
                            hintText: hp),
                        onChanged: (String str) {
                          hp = str;
                        },
                      )),
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
                      Container(
                        child: Text(
                          Strings.shared.controllers.profile.userMail,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.supplementary,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        width: deviceWidth / 5,
                        padding: const EdgeInsets.only(right: 10),
                      ),
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: Statics.shared.fontSizes.supplementary,
                            color: Statics.shared.colors.titleTextColor,
                          ),
                          hintText: email,
                        ),
                        onChanged: (String str) {
                          email = str;
                        },
                      )),
                      SizedBox(
                        width: deviceWidth / 5,
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
                      Container(
                        child: Text(
                          Strings.shared.controllers.profile.userSchool,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.supplementary,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        width: deviceWidth / 5,
                        padding: const EdgeInsets.only(right: 10),
                      ),
                      Expanded(
                        child: new FutureBuilder(
                          future: getSchool(), // a Future<String> or null
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            //print('project snapshot data is: ${snapshot.data}');
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return new Text('Press button to start');
                              case ConnectionState.waiting:
                                return new Container(
                                  child: FlatButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Text("로딩중..",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Statics
                                                .shared.colors.titleTextColor,
                                            fontSize: Statics
                                                .shared.fontSizes.subTitle)),
                                    onPressed: () {},
                                  ),
                                  height: deviceWidth / 6,
                                );
                              default:
                                if (snapshot.hasError)
                                  return new Text('Error: ${snapshot.error}');
                                else
                                  return schoolDropbox(context, snapshot);
                            }
                          },
                        ),
                      ),
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
                      Container(
                        child: Text(
                          Strings.shared.controllers.profile.userGisu,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics.shared.fontSizes.supplementary,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        width: deviceWidth / 5,
                        padding: const EdgeInsets.only(right: 10),
                      ),
                      Expanded(
                          child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: Statics.shared.fontSizes.supplementary,
                              color: Statics.shared.colors.titleTextColor,
                            ),
                            hintText: gisu),
                        onChanged: (String str) {
                          gisu = str;
                        },
                      )),
                    ],
                  ), // Row Children
                ),
              ]), // Row
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: EdgeInsets.all(20),
                color: Statics.shared.colors.mainColor,
                child: Text("수정",
                    style: TextStyle(
                        fontSize: Statics.shared.fontSizes.titleInContent,
                        color: Colors.white)),
                onPressed: () {})
          ], // Row Children
        ), // Row
        alignment: Alignment(0.0, 0.0),
      ), // Container
    );
  }

  Widget schoolDropbox(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;

    var list = [];

    if (_schoolList.length == 0) {
      for (var i = 0; i < values.length; i++) {
        // here we are creating the drop down menu items, you can customize the item right here
        // but I'll just use a simple text for this

        _schoolList.add(values[i]["CCNAME"]);
      }
    }

    return _createDropDownMenu();
  }

  Widget _createDropDownMenu() {
    return DropdownButton<String>(
      hint: Text('선택하세요'), // Not necessary for Option 1
      value: _selectedLocation,
      onChanged: (newValue) {
        setState(() {
          _selectedLocation = newValue;
        });
      },
      items: _schoolList.map((data) {
        return DropdownMenuItem<String>(
          child: new Text(data),
          value: data,
        );
      }).toList(),
    );
  }
}

Future<List> getSchool() async {
  if (schoolTable.length == 0) {
    return http
        .post(Strings.shared.controllers.jsonURL.schoolJson)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      //final String responseBody = response.body; //한글 깨짐
      final String responseBody = utf8.decode(response.bodyBytes);
      var responseJSON = json.decode(responseBody);
      var code = responseJSON["code"];

      if (statusCode == 200) {
        if (code == 200) {
          schoolTable = responseJSON["table"];
          return responseJSON["table"];
        }
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  } else
    return schoolTable;
}

//JSON 데이터
class Result {
  final String chcode;
  final String ccname;

  Result({
    this.chcode,
    this.ccname,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(chcode: json['CHCODE'], ccname: json['CCNAME']);
  }
}
