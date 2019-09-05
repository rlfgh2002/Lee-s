import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<School> _schoolList = new List();
  TextEditingController _emailController;
  TextEditingController _hpController;
  TextEditingController _gisuController;
  String _selectedValue;

  String hp = userInformation.hp.replaceAll("-", "");
  String email = userInformation.email;
  String school = userInformation.school;
  String gisu = userInformation.gisu;

  @override
  void initState() {
    super.initState();
    _hpController = new TextEditingController(text: hp);
    _emailController = new TextEditingController(text: email);
    _gisuController = new TextEditingController(text: gisu);
  }

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

    //학교 미등록시 초기값
    if (school == "") {
      school = "14000";
    }

    return Scaffold(
      key: _scaffoldKey,
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
        color: Statics.shared.colors.lineColor,
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
                child: ListView(
              children: <Widget>[
                Container(
                  color: Colors.white,
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
                                  fontSize:
                                      Statics.shared.fontSizes.supplementary,
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
                                  fontSize:
                                      Statics.shared.fontSizes.supplementary,
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
                                  fontSize:
                                      Statics.shared.fontSizes.supplementary,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            width: deviceWidth / 5,
                            padding: const EdgeInsets.only(right: 10),
                          ),
                          Expanded(
                              child: TextField(
                            controller: _hpController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize:
                                      Statics.shared.fontSizes.supplementary,
                                  color:
                                      Statics.shared.colors.subTitleTextColor,
                                ),
                                hintText: Strings
                                    .shared.controllers.profile.userPhone),
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
                                  fontSize:
                                      Statics.shared.fontSizes.supplementary,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            width: deviceWidth / 5,
                            padding: const EdgeInsets.only(right: 10),
                          ),
                          Expanded(
                              child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize:
                                    Statics.shared.fontSizes.supplementary,
                                color: Statics.shared.colors.subTitleTextColor,
                              ),
                              hintText:
                                  Strings.shared.controllers.profile.userMail,
                            ),
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
                                  fontSize:
                                      Statics.shared.fontSizes.supplementary,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            width: deviceWidth / 5,
                            padding: const EdgeInsets.only(right: 10),
                          ),
                          Expanded(
                            child: new FutureBuilder(
                              future: getSchool(), // a Future<String> or null
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
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
                                                color: Statics.shared.colors
                                                    .titleTextColor,
                                                fontSize: Statics.shared
                                                    .fontSizes.subTitle)),
                                        onPressed: () {},
                                      ),
                                      height: deviceWidth / 6,
                                    );
                                  default:
                                    if (snapshot.hasError)
                                      return new Text(
                                          'Error: ${snapshot.error}');
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
                                  fontSize:
                                      Statics.shared.fontSizes.supplementary,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            width: deviceWidth / 5,
                            padding: const EdgeInsets.only(right: 10),
                          ),
                          Expanded(
                              child: TextField(
                            controller: _gisuController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize:
                                      Statics.shared.fontSizes.supplementary,
                                  color:
                                      Statics.shared.colors.subTitleTextColor,
                                ),
                                hintText: Strings
                                    .shared.controllers.profile.userGisu),
                          )),
                        ],
                      ), // Row Children
                    ),
                  ]), // Row
                ),
              ],
            )),
            SizedBox(
              height: 10,
            ),
            Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.all(20),
                        child: Image.asset(
                          "Resources/Icons/logout.png",
                          scale: 3.0,
                        ),
                        onPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: new Text("로그아웃"),
                                    content: new Text("로그아웃 하시겠어요?",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    actions: <Widget>[
                                      // usually buttons at the bottom of the dialog
                                      new FlatButton(
                                        child: new Text("취소",
                                            style: TextStyle(
                                                fontSize: Statics.shared
                                                    .fontSizes.supplementary,
                                                color: Colors.black)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      new FlatButton(
                                        child: new Text(
                                          "로그아웃",
                                          style: TextStyle(
                                              fontSize: Statics.shared.fontSizes
                                                  .supplementary,
                                              color: Colors.red),
                                        ),
                                        onPressed: () {
                                          userInformation.logout();
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new SplashScreen()));
                                        },
                                      ),
                                    ],
                                  ));
                        })),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.all(20),
                        color: Statics.shared.colors.mainColor,
                        child: Text("정보수정",
                            style: TextStyle(
                                fontSize:
                                    Statics.shared.fontSizes.titleInContent,
                                color: Colors.white)),
                        onPressed: () async {
                          print("전화번호 : ${_hpController.text}");
                          print("이메일 : ${_emailController.text}");
                          print("출신학교 : ${school.toString()}");
                          print("기수 : ${userInformation.memberType}");

                          var infomap = new Map<String, dynamic>();
                          infomap["id"] = userInformation.userID;
                          infomap["memberIdx"] = userInformation.userIdx;
                          infomap["name"] = userInformation.fullName;
                          infomap["memberType"] = userInformation.memberType;
                          infomap["hp"] = _hpController.text;
                          infomap["email"] = _emailController.text;
                          infomap["school"] = school;
                          infomap["gisu"] = _gisuController.text;
                          await infoModify(
                              Strings.shared.controllers.jsonURL
                                  .userinfoModifyJson,
                              body: infomap);

                          userInformation.hp = _hpController.text;
                          userInformation.email = _emailController.text;
                          userInformation.school = school;
                          userInformation.gisu = _gisuController.text;

                          _displaySnackBar(context, "수정되었습니다.");
                          return;
                        }))
              ],
            )
          ], // Row Children
        ), // Row
        alignment: Alignment(0.0, 0.0),
      ), // Container
    );
  }

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(content: Text(str));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget schoolDropbox(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;
    print("SCHOOL LENGTH : ${_schoolList.length}");
    if (_schoolList.length == 0) {
      for (var i = 0; i < values.length; i++) {
        // here we are creating the drop down menu items, you can customize the item right here
        // but I'll just use a simple text for this

        _schoolList.add(
            School(chcode: values[i]["CHCODE"], ccname: values[i]["CCNAME"]));
      }
    }
    _selectedValue = school;
    return _createDropDownMenu();
  }

  Widget _createDropDownMenu() {
    return DropdownButton<String>(
      hint: Text('선택하세요'), // Not necessary for Option 1
      value: _selectedValue,
      onChanged: (String newValue) {
        setState(() {
          _selectedValue = newValue;
          school = newValue;
        });
      },
      items: _schoolList.map((data) {
        return DropdownMenuItem<String>(
          child: new Text(data.ccname),
          value: data.chcode,
        );
      }).toList(),
    );
  }

  Future<List> getSchool() async {
    //한번도 실행되지 않았을때(최초실행)
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

  infoModify(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;
      //final String responseBody = response.body; //한글 깨짐
      final String responseBody = utf8.decode(response.bodyBytes);
      var responseJSON = json.decode(responseBody);
      var code = responseJSON["code"];

      if (code == 200) {
        // If the call to the server was successful, parse the JSON
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }
}

//JSON 데이터
class School {
  School({
    this.chcode,
    this.ccname,
  });

  final String chcode;
  final String ccname;
}
