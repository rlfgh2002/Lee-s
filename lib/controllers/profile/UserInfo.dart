import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
import 'package:haegisa2/controllers/MaintabBar/MiddleWare.dart';
import 'package:haegisa2/controllers/profile/Profile.dart';
import 'package:haegisa2/models/profile/SearchAddress.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/views/buttons/AppExpansionTile.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

List<Widget> myList = [];
String addressKeyword;

class UserInfo extends StatefulWidget {
  String g_postNo = "";
  String g_address1 = "";
  static UserInfo shared = UserInfo();
  UserInfo() {}
  @override
  UserInfoState createState() => UserInfoState();
}

class UserInfoState extends State<UserInfo> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var schoolTable = new List();
  List<School> _schoolList = new List();

  TextEditingController _emailController;
  TextEditingController _addressController;
  TextEditingController _gisuController;

  FocusNode focusNode1;
  FocusNode focusNode2;
  FocusNode focusNode3;
  String _selectedValue;

  UserInfoState userinfo;

  bool addrState = false; //주소 변경 했는지 안했는지 체크.

  String hp = userInformation.hp.replaceAll("-", "");
  String email = userInformation.email;
  String school = userInformation.school;
  String gisu = userInformation.gisu;
  String address2 = userInformation.address2;

  String postNo = userInformation.postNo;
  String address1 = userInformation.address1;

  String btnText1 = "변경";
  String btnText2 = "변경";
  String btnText3 = "변경";
  String btnText4 = "변경";

  bool btnModify1 = false;
  bool btnModify2 = false;
  bool btnModify3 = false;
  bool btnModify4 = false;

  @override
  void initState() {
    super.initState();
    _emailController = new TextEditingController(text: email);
    _addressController = new TextEditingController(text: address2);
    _gisuController = new TextEditingController(text: gisu);

    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();
  }

  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));
    String typeAsset = "";
    String userType = "";
    Color typeColor;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    if (userInformation.memberType == "51001") {
      userType = Strings.shared.controllers.profile.memberType1;
      typeColor = Statics.shared.colors.mainColor;
    } else if (userInformation.memberType == "51002") {
      userType = Strings.shared.controllers.profile.memberType2;
      typeColor = Statics.shared.colors.subColor;
    } else {
      userType = Strings.shared.controllers.profile.memberType3;
      typeColor = Statics.shared.colors.captionColor;
    }

    //학교 미등록시 초기값
    if (school == "") {
      school = "14000";
    }

    if (UserInfo.shared.g_address1 != "" && UserInfo.shared.g_postNo != "") {
      postNo = UserInfo.shared.g_postNo;
      address1 = UserInfo.shared.g_address1;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Strings.shared.controllers.profile.userinfoTitle,
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
                      height: deviceWidth / 6,
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
                              color: Statics.shared.colors.titleTextColor,
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
                      height: deviceWidth / 6,
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
                              color: Statics.shared.colors.titleTextColor,
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
                      height: deviceWidth / 6,
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
                          Text(
                            hp,
                            style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
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
                      height: deviceWidth / 6,
                      padding: const EdgeInsets.only(left: 20),
                      child: new Row(
                        children: <Widget>[
                          Container(
                            child: Row(children: <Widget>[
                              Text(
                                "우편번호",
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                    color: Statics.shared.colors.tabColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ]),
                            width: deviceWidth / 5,
                            padding: const EdgeInsets.only(right: 10),
                          ),
                          Container(
                              width: deviceWidth / 2.0,
                              child: postNo == ""
                                  ? Text(
                                      "우편번호",
                                      style: TextStyle(
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary,
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                      ),
                                    )
                                  : Text(
                                      postNo,
                                      style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary,
                                      ),
                                    )),
                          Spacer(),
                          Container(
                              width: deviceWidth / 6.2,
                              child: FlatButton(
                                child: Text("변경",
                                    style: TextStyle(
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary,
                                        color: Statics.shared.colors.mainColor,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  myList = [];
                                  addressKeyword = "";
                                  showDialog(
                                          context: context,
                                          builder: (_) => MyDialog())
                                      .then((_) => setState(() {}));
                                },
                              ))
                        ],
                      ), // Row Children
                    ),
                    Row(children: <Widget>[
                      Expanded(child: Divider(height: 0)),
                    ]),
                    Container(
                      height: deviceWidth / 6,
                      padding: const EdgeInsets.only(left: 20),
                      child: new Row(
                        children: <Widget>[
                          Container(
                            child: Row(children: <Widget>[
                              Text(
                                "주소",
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                    color: Statics.shared.colors.tabColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ]),
                            width: deviceWidth / 5,
                            padding: const EdgeInsets.only(right: 10),
                          ),
                          Container(
                              width: deviceWidth / 1.5,
                              child: address1 == ""
                                  ? Text(
                                      "주소",
                                      style: TextStyle(
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary,
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                      ),
                                    )
                                  : Text(
                                      address1,
                                      style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary,
                                      ),
                                    )),
                        ],
                      ), // Row Children
                    ),
                    Row(children: <Widget>[
                      Expanded(child: Divider(height: 0)),
                    ]),
                    Container(
                      height: deviceWidth / 6,
                      padding: const EdgeInsets.only(left: 20),
                      child: new Row(
                        children: <Widget>[
                          Container(
                            child: Row(children: <Widget>[
                              Text(
                                "상세주소",
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                    color: Statics.shared.colors.tabColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ]),
                            width: deviceWidth / 5,
                            padding: const EdgeInsets.only(right: 10),
                          ),
                          Container(
                            width: deviceWidth / 2.0,
                            child: btnModify1 == false
                                ? Text(
                                    address2,
                                    style: TextStyle(
                                      color:
                                          Statics.shared.colors.titleTextColor,
                                      fontSize: Statics
                                          .shared.fontSizes.supplementary,
                                    ),
                                    textAlign: TextAlign.left,
                                  )
                                : TextField(
                                    controller: _addressController,
                                    focusNode: focusNode1,
                                    autofocus: true,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Statics
                                          .shared.colors.subTitleTextColor,
                                      fontSize: Statics
                                          .shared.fontSizes.supplementary,
                                    ),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontSize: Statics
                                              .shared.fontSizes.supplementary,
                                          color: Statics
                                              .shared.colors.subTitleTextColor,
                                        ),
                                        hintText: "상세주소"),
                                  ),
                          ),
                          Spacer(),
                          Container(
                              width: deviceWidth / 6.2,
                              child: FlatButton(
                                  child: Text(btnText1,
                                      style: TextStyle(
                                          fontSize: Statics
                                              .shared.fontSizes.supplementary,
                                          color:
                                              Statics.shared.colors.mainColor,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    setState(() {
                                      if (btnText1 == "변경") {
                                        btnText1 = "확인";
                                        btnModify1 = true;
                                      } else {
                                        btnText1 = "변경";
                                        btnModify1 = false;
                                        address2 = _addressController.text;
                                        FocusScope.of(context)
                                            .requestFocus(focusNode1);
                                      }
                                    });
                                  }))
                        ],
                      ), // Row Children
                    ),
                    Row(children: <Widget>[
                      Expanded(child: Divider(height: 0)),
                    ]),
                    Container(
                      height: deviceWidth / 6,
                      padding: const EdgeInsets.only(left: 20),
                      child: new Row(
                        children: <Widget>[
                          Container(
                            child: Row(children: <Widget>[
                              Text(
                                "이메일",
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                    color: Statics.shared.colors.tabColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ]),
                            width: deviceWidth / 5,
                            padding: const EdgeInsets.only(right: 10),
                          ),
                          Container(
                              width: deviceWidth / 2.0,
                              child: btnModify2 == false
                                  ? Text(
                                      email,
                                      style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary,
                                      ),
                                      textAlign: TextAlign.left,
                                    )
                                  : TextField(
                                      controller: _emailController,
                                      focusNode: focusNode2,
                                      autofocus: true,
                                      style: TextStyle(
                                        color: Statics
                                            .shared.colors.subTitleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontSize: Statics
                                              .shared.fontSizes.supplementary,
                                          color: Statics
                                              .shared.colors.subTitleTextColor,
                                        ),
                                        hintText: Strings.shared.controllers
                                            .profile.userMail,
                                      ),
                                    )),
                          Spacer(),
                          Container(
                              width: deviceWidth / 6.2,
                              child: FlatButton(
                                child: Text(btnText2,
                                    style: TextStyle(
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary,
                                        color: Statics.shared.colors.mainColor,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  setState(() {
                                    if (btnText2 == "변경") {
                                      btnText2 = "확인";
                                      btnModify2 = true;
                                    } else {
                                      btnText2 = "변경";
                                      btnModify2 = false;
                                      email = _emailController.text;
                                      FocusScope.of(context)
                                          .requestFocus(focusNode2);
                                    }
                                  });
                                },
                              ))
                        ],
                      ), // Row Children
                    ),
                    Row(children: <Widget>[
                      Expanded(child: Divider(height: 0)),
                    ]),
                    Container(
                      height: deviceWidth / 6,
                      padding: const EdgeInsets.only(left: 20),
                      child: new Row(
                        children: <Widget>[
                          Container(
                            child: Row(children: <Widget>[
                              Text(
                                Strings.shared.controllers.profile.userSchool,
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                    color: Statics.shared.colors.tabColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ]),
                            width: deviceWidth / 5,
                            padding: const EdgeInsets.only(right: 10),
                          ),
                          Container(
                              width: deviceWidth / 2.0,
                              child: FutureBuilder(
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
                                      else {
                                        if (btnModify3 == false) {
                                          return getschoolName(
                                              context, snapshot, school);
                                        } else {
                                          return schoolDropbox(
                                              context, snapshot);
                                        }
                                      }
                                  }
                                },
                              )),
                          Spacer(),
                          Container(
                              width: deviceWidth / 6.2,
                              child: FlatButton(
                                child: Text(btnText3,
                                    style: TextStyle(
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary,
                                        color: Statics.shared.colors.mainColor,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  setState(() {
                                    if (btnText3 == "변경") {
                                      btnText3 = "확인";
                                      btnModify3 = true;
                                    } else {
                                      btnText3 = "변경";
                                      btnModify3 = false;
                                    }
                                  });
                                },
                              ))
                        ],
                      ), // Row Children
                    ),
                    Row(children: <Widget>[
                      Expanded(child: Divider(height: 0)),
                    ]),
                    Container(
                      height: deviceWidth / 6,
                      padding: const EdgeInsets.only(left: 20),
                      child: new Row(
                        children: <Widget>[
                          Container(
                            child: Row(children: <Widget>[
                              Text(
                                Strings.shared.controllers.profile.userGisu,
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                    color: Statics.shared.colors.tabColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ]),
                            width: deviceWidth / 5,
                            padding: const EdgeInsets.only(right: 10),
                          ),
                          Container(
                            width: deviceWidth / 2.0,
                            child: btnModify4 == false
                                ? Text(
                                    gisu,
                                    style: TextStyle(
                                      color:
                                          Statics.shared.colors.titleTextColor,
                                      fontSize: Statics
                                          .shared.fontSizes.supplementary,
                                    ),
                                    textAlign: TextAlign.left,
                                  )
                                : new TextField(
                                    controller: _gisuController,
                                    focusNode: focusNode3,
                                    autofocus: true,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Statics
                                          .shared.colors.subTitleTextColor,
                                      fontSize: Statics
                                          .shared.fontSizes.supplementary,
                                    ),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontSize: Statics
                                              .shared.fontSizes.supplementary,
                                          color: Statics
                                              .shared.colors.subTitleTextColor,
                                        ),
                                        hintText: Strings.shared.controllers
                                            .profile.userGisu),
                                  ),
                          ),
                          Spacer(),
                          Container(
                              width: deviceWidth / 6.2,
                              child: FlatButton(
                                child: Text(btnText4,
                                    style: TextStyle(
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary,
                                        color: Statics.shared.colors.mainColor,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  setState(() {
                                    if (btnText4 == "변경") {
                                      btnText4 = "확인";
                                      btnModify4 = true;
                                    } else {
                                      btnText4 = "변경";
                                      btnModify4 = false;
                                      gisu = _gisuController.text;
                                      FocusScope.of(context)
                                          .requestFocus(focusNode3);
                                    }
                                  });
                                },
                              ))
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
                                          MiddleWare.shared.currentIndex = 0;
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            // the new route
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  SplashScreen(),
                                            ),

                                            // this function should return true when we're done removing routes
                                            // but because we want to remove all other screens, we make it
                                            // always return false
                                            (Route route) => false,
                                          );
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
                          print("이메일 : ${_emailController.text}");
                          print("출신학교 : ${school.toString()}");
                          print("기수 : ${userInformation.memberType}");

                          if (btnModify1 == true ||
                              btnModify2 == true ||
                              btnModify3 == true ||
                              btnModify4 == true) {
                            _displaySnackBar(context, "수정내용을 확인 하세요.");
                          } else {
                            var infomap = new Map<String, dynamic>();
                            infomap["type"] =
                                userInformation.haegisa; //0이면 일반회원, 1해기사
                            infomap["id"] = userInformation.userID;
                            infomap["memberIdx"] = userInformation.userIdx;
                            infomap["name"] = userInformation.fullName;
                            infomap["memberType"] = userInformation.memberType;
                            infomap["hp"] = hp;
                            infomap["email"] = _emailController.text;
                            infomap["school"] = school;
                            infomap["gisu"] = _gisuController.text;
                            infomap["address1"] = address1;
                            infomap["address2"] = _addressController.text;
                            infomap["postNo"] = postNo;
                            await infoModify(
                                Strings.shared.controllers.jsonURL
                                    .userinfoModifyJson,
                                body: infomap);

                            //변경된 정보로 userInformation 수정
                            userInformation.hp = hp;
                            userInformation.email = _emailController.text;
                            userInformation.school = school;
                            userInformation.gisu = _gisuController.text;
                            userInformation.address1 = address1;
                            userInformation.address2 = _addressController.text;
                            userInformation.postNo = postNo;

                            UserInfo.shared.g_address1 = "";
                            UserInfo.shared.g_postNo = "";

                            Navigator.pop(context, '수정되었습니다.');
                          }
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
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 1500),
    );
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
      style: TextStyle(
        color: Statics.shared.colors.subTitleTextColor,
        fontSize: Statics.shared.fontSizes.supplementary,
      ),
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
      return http.post(Strings.shared.controllers.jsonURL.schoolJson, body: {
        'mode': 'list',
      }).then((http.Response response) {
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
    } else {
      return schoolTable;
    }
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

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  Color _c = Colors.redAccent;
  bool isLoading = false;
  bool isVisible = false;
  var searchList = [];

  static final _formKey1 = new GlobalKey<FormState>();
  static final _formKey2 = new GlobalKey<FormState>();
  final _emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var map = new Map<String, dynamic>();

    map["confmKey"] = "U01TX0FVVEgyMDE5MTAwMjE3MDEyMDEwOTA2ODY=";
    map["resultType"] = "json";
    map["countPerPage"] = "99";
    map["keyword"] = addressKeyword;

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
                      margin: const EdgeInsets.only(left: 3),
                      width: MediaQuery.of(context).size.width / 2.1,
                      child: TextField(
                        key: _formKey1,
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
                      width: MediaQuery.of(context).size.width / 6.2,
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
                            setState(() {
                              isVisible = true;
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            });
                          })),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: isVisible
                    ? myList.length != 0
                        ? new ListView.builder(
                            key: new Key(DateFormat("yyyyMMddHHmmss")
                                .format(DateTime.now())), //리스트당 고유된 키를 부여
                            itemCount:
                                myList.length, // number of items in your list
                            //here the implementation of itemBuilder. take a look at flutter docs to see details
                            itemBuilder: (BuildContext context, int itemIndex) {
                              return myList[itemIndex];
                              // return your widget
                            })
                        : new FutureBuilder(
                            future: searchAddress(
                                "http://www.juso.go.kr/addrlink/addrLinkApi.do",
                                body: map),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              //print('project snapshot data is: ${snapshot.data}');
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return new Text('Press button to start');
                                case ConnectionState.waiting:
                                  return new Center(
                                      child: CircularProgressIndicator());
                                case ConnectionState.done:
                                  return new ListView.builder(
                                      key: new Key(DateFormat("yyyyMMddHHmmss")
                                          .format(
                                              DateTime.now())), //리스트당 고유된 키를 부여
                                      itemCount: myList
                                          .length, // number of items in your list
                                      //here the implementation of itemBuilder. take a look at flutter docs to see details
                                      itemBuilder: (BuildContext context,
                                          int itemIndex) {
                                        return myList[itemIndex];
                                        // return your widget
                                      });
                                default:
                                  if (snapshot.hasError)
                                    return new Text('Error: ${snapshot.error}');
                              }
                            },
                          )
                    : Container())
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
      searchList = juso;

      if (statusCode == 200) {
        if (errorMessage == "정상") {
          if (juso.length != 0) {
            for (var result in juso) {
              myList.add(addrList(result["roadAddr"], result["zipNo"]));
            }
          } else {
            isVisible = false;
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
          isVisible = false;
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
    FocusNode textSecondFocusNode = new FocusNode();
    // return AppExpansionTile(
    //     title: Row(
    //       children: <Widget>[
    //         Container(
    //           width: MediaQuery.of(context).size.width / 1.9,
    //           child: Text(addr,
    //               style: TextStyle(
    //                   fontSize: Statics.shared.fontSizes.supplementary,
    //                   color: Colors.black)),
    //         ),
    //         Spacer(),
    //         Text(post,
    //             style: TextStyle(
    //                 fontSize: Statics.shared.fontSizes.supplementary,
    //                 color: Statics.shared.colors.subTitleTextColor))
    //       ],
    //     ),
    //     backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
    //     children: <Widget>[
    //       TextField(
    //         key: _formKey2,
    //         decoration: InputDecoration(
    //             border: InputBorder.none,
    //             hintStyle: TextStyle(
    //               fontSize: Statics.shared.fontSizes.subTitle,
    //               color: Statics.shared.colors.subTitleTextColor,
    //             ),
    //             hintText: "주소를 입력하세요."), // decoration
    //         onChanged: (String str) {
    //           addressKeyword = str;
    //         },
    //       )
    //     ]);
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
            UserInfo.shared.g_address1 = addr;
            UserInfo.shared.g_postNo = post;

            Navigator.of(context).pop();
          },
        ));
  }
}

getschoolName(BuildContext context, AsyncSnapshot snapshot, String chcode) {
  var values = snapshot.data;

  for (var res in values) {
    if (res["CHCODE"] == chcode) {
      return Text(
        res["CCNAME"],
        style: TextStyle(
          color: Statics.shared.colors.titleTextColor,
          fontSize: Statics.shared.fontSizes.supplementary,
        ),
        textAlign: TextAlign.left,
      );
    }
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

class MyTextField extends StatefulWidget {
  MyTextField({
    this.text,
    this.hintText = "",
    this.onChanged,
    this.onSubmitted,
    this.textAlign = TextAlign.left,
    this.focusNode,
    this.autofocus = false,
    this.obscureText = false,
    this.padding = const EdgeInsets.all(0.0),
    this.keyboardType = TextInputType.text,
    this.canEdit = true,
    this.isDarkMode = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.key,
  });

  final String text;
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final bool autofocus;
  final bool obscureText;
  final EdgeInsets padding;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final Key key;

  final bool canEdit;

  final isDarkMode;

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  static const double textFieldPadding = 12.0;
  TextEditingController editingController;

  @override
  void initState() {
    super.initState();
    editingController = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.canEdit,
      child: Column(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(
                top: textFieldPadding + widget.padding.top,
                bottom: textFieldPadding + widget.padding.bottom,
                left: widget.padding.left,
                right: widget.padding.right),
            child: new TextField(
              key: widget.key,
              maxLines: null,
              textCapitalization: widget.textCapitalization,
              keyboardType: widget.keyboardType,
              keyboardAppearance:
                  widget.isDarkMode ? Brightness.dark : Brightness.light,
              controller: editingController,
              onSubmitted: widget.onSubmitted,
              onChanged: widget.onChanged,
              style: new TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.blue,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500),
              autofocus: widget.autofocus,
              focusNode: widget.focusNode,
              textAlign: widget.textAlign,
              obscureText: widget.obscureText,
              decoration: new InputDecoration(
                hintText: widget.hintText,
                hintStyle: new TextStyle(
                    color: widget.isDarkMode ? Colors.black : Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
                border: InputBorder.none,
              ),
            ),
          ),
          Divider(
            color: widget.isDarkMode ? Colors.black : Colors.grey[150],
            height: 1.0,
          ),
        ],
      ),
    );
  }
}
