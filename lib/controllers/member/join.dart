import 'package:flutter/material.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
import 'package:haegisa2/controllers/sign/SignIn.dart';
import 'package:haegisa2/main.dart';
import 'MiddleWare.dart';
import 'dart:async';
import 'dart:convert';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/views/buttons/Buttons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

String jsonMsg = "";

class Join extends StatefulWidget {
  String idValue = "";
  String passValue = "";
  String passValue2 = "";
  String email = "";
  String school = "14000";
  String gisu = "";

  @override
  _JoinInState createState() => _JoinInState();
}

class _JoinInState extends State<Join> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var schoolTable = new List();
  List<School> _schoolList = [
    School(chcode: "14000", ccname: "선택하세요"),
    School(chcode: "14001", ccname: "한국해양대학교"),
    School(chcode: "14002", ccname: "목포해양대학교"),
    School(chcode: "14003", ccname: "해대부설해전"),
    School(chcode: "14004", ccname: "해대부설전수과"),
    School(chcode: "14005", ccname: "부경대학교"),
    School(chcode: "14006", ccname: "전남대학교"),
    School(chcode: "14007", ccname: "군산대학교"),
    School(chcode: "14008", ccname: "부산해양고등학교"),
    School(chcode: "14009", ccname: "부산해사고등학교"),
    School(chcode: "14010", ccname: "원양어업기술훈"),
    School(chcode: "14011", ccname: "인천해사고"),
    School(chcode: "14012", ccname: "포항대학교"),
    School(chcode: "14013", ccname: "경상대학교"),
    School(chcode: "14014", ccname: "대졸"),
    School(chcode: "14015", ccname: "전문졸"),
    School(chcode: "14016", ccname: "고졸"),
    School(chcode: "14017", ccname: "중졸"),
    School(chcode: "14018", ccname: "국졸"),
    School(chcode: "14019", ccname: "기타"),
    School(chcode: "14020", ccname: "해군사관학교"),
    School(chcode: "14021", ccname: "제주대학교"),
    School(chcode: "14022", ccname: "경남해양과학고"),
    School(chcode: "14023", ccname: "성산고등학교"),
    School(chcode: "14024", ccname: "강원도립대"),
    School(chcode: "14025", ccname: "포항해양과학고등학교"),
    School(chcode: "14026", ccname: "오션폴리텍"),
    School(chcode: "14027", ccname: "완도수산고등학교"),
  ];
  String _selectedValue;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    MiddleWare.shared.screenSize = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(Strings.shared.controllers.signIn.forgetPasswordTitle),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          centerTitle: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    child: Text(Strings.shared.controllers.signIn.joinTitle,
                        style: TextStyle(
                            color: Statics.shared.colors.titleTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Statics.shared.fontSizes.title)), // Text
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      bottom: 10,
                    ),
                  ),
                  Container(
                    child: Text(Strings.shared.controllers.signIn.joinContent,
                        style: TextStyle(
                            color: Statics.shared.colors.titleTextColor,
                            fontSize: Statics
                                .shared.fontSizes.titleInContent)), // Text
                    alignment: Alignment.centerLeft,
                  ),
                  SizedBox(height: 10),
                  Container(
                      //아이디 입력
                      height: deviceHeight / 10,
                      child: TextField(
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: Statics.shared.fontSizes.subTitle,
                              color: Statics.shared.colors.subTitleTextColor,
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.perm_identity),
                            hintText: Strings.shared.controllers.signIn
                                .txtHintUser), // decoration
                        onChanged: (String str) {
                          this.widget.idValue = str;
                        },
                      ),
                      alignment: Alignment.centerLeft),
                  Container(
                    child: Text("※ 아이디는 6자리 이상 16자리 이하로 입력",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Statics.shared.fontSizes.small)), // Text
                    alignment: Alignment.centerLeft,
                  ),
                  SizedBox(height: 10),
                  Container(
                      //비밀번호 입력
                      height: deviceHeight / 10,
                      child: TextField(
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: Statics.shared.fontSizes.subTitle,
                              color: Statics.shared.colors.subTitleTextColor,
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText:
                                Strings.shared.controllers.signIn.txtHintPass),
                        obscureText: true, // decoration
                        onChanged: (String str) {
                          this.widget.passValue = str;
                        },
                      ),
                      alignment: Alignment.centerLeft),
                  Container(
                    child: Text("※ 영문+숫자+특수문자 조합 6~16자리 입력",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Statics.shared.fontSizes.small)), // Text
                    alignment: Alignment.centerLeft,
                  ),
                  SizedBox(height: 10),
                  Container(
                      //비밀번호 확인
                      height: deviceHeight / 10,
                      child: TextField(
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: Statics.shared.fontSizes.subTitle,
                              color: Statics.shared.colors.subTitleTextColor,
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText:
                                Strings.shared.controllers.signIn.txtHintPass2),
                        obscureText: true, // decoration
                        onChanged: (String str) {
                          this.widget.passValue2 = str;
                        },
                      ),
                      alignment: Alignment.centerLeft),
                  SizedBox(height: 10),
                  Container(
                      //이메일
                      height: deviceHeight / 10,
                      child: TextField(
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: Statics.shared.fontSizes.subTitle,
                              color: Statics.shared.colors.subTitleTextColor,
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                            hintText: "이메일"),
                        obscureText: false, // decoration
                        onChanged: (String str) {
                          this.widget.email = str;
                        },
                      ),
                      alignment: Alignment.centerLeft),
                  SizedBox(height: 10),
                  Container(child: schoolDropbox2()),
                  // Container(
                  //     //출신학교
                  //     height: deviceHeight / 10,
                  //     child: FutureBuilder(
                  //       future: getSchool(), // a Future<String> or null
                  //       builder:
                  //           (BuildContext context, AsyncSnapshot snapshot) {
                  //         //print('project snapshot data is: ${snapshot.data}');
                  //         switch (snapshot.connectionState) {
                  //           case ConnectionState.none:
                  //             return new Text('Press button to start');
                  //           case ConnectionState.waiting:
                  //             return new Container(
                  //               child: FlatButton(
                  //                 splashColor: Colors.transparent,
                  //                 highlightColor: Colors.transparent,
                  //                 child: Text("",
                  //                     overflow: TextOverflow.ellipsis,
                  //                     style: TextStyle(
                  //                         color: Statics
                  //                             .shared.colors.titleTextColor,
                  //                         fontSize: Statics
                  //                             .shared.fontSizes.subTitle)),
                  //                 onPressed: () {},
                  //               ),
                  //             );
                  //           default:
                  //             if (snapshot.hasError)
                  //               return new Text('Error: ${snapshot.error}');
                  //             else {
                  //               return schoolDropbox(context, snapshot);
                  //             }
                  //         }
                  //       },
                  //     ),
                  //     alignment: Alignment.centerLeft),
                  SizedBox(height: 10),
                  Container(
                      //기수
                      height: deviceHeight / 10,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: Statics.shared.fontSizes.subTitle,
                              color: Statics.shared.colors.subTitleTextColor,
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.school),
                            hintText: "기수"),
                        obscureText: false, // decoration
                        onChanged: (String str) {
                          this.widget.gisu = str;
                        },
                      ),
                      alignment: Alignment.centerLeft),
                  SizedBox(height: 5),
                  Container(
                    child: Row(
                      children: [
                        HaegisaButton(
                          text: Strings.shared.controllers.signIn.submit,
                          iconURL: "Resources/Icons/Vector_3.2.png",
                          onPressed: () async {
                            if (this.widget.idValue == "") {
                              _displaySnackBar(context,
                                  Strings.shared.controllers.signIn.enterID);
                              return;
                            }
                            if (this.widget.idValue.length < 6) {
                              _displaySnackBar(context,
                                  Strings.shared.controllers.signIn.findID3);
                              return;
                            }
                            if (this.widget.idValue.length > 16) {
                              _displaySnackBar(context,
                                  Strings.shared.controllers.signIn.findID3);
                              return;
                            }
                            if (this.widget.passValue == "" ||
                                this.widget.passValue2 == "") {
                              _displaySnackBar(context,
                                  Strings.shared.controllers.signIn.enterPass);
                              return;
                            }
                            if (this.widget.passValue !=
                                this.widget.passValue2) {
                              _displaySnackBar(context,
                                  Strings.shared.controllers.signIn.findPass);
                              return;
                            } else {
                              //※ 영문+숫자+특수문자 조합 6~16자리 입력 정규식
                              RegExp exp = new RegExp(
                                  r"^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,16}$");
                              print(exp.hasMatch(this.widget.passValue));
                              if (exp.hasMatch(this.widget.passValue) ==
                                  false) {
                                _displaySnackBar(
                                    context,
                                    Strings
                                        .shared.controllers.signIn.findPass2);
                              }

                              if (this.widget.email == "") {
                                _displaySnackBar(context, "이메일을 입력하세요.");
                                return;
                              }
                              if (this.widget.school == "14000") {
                                _displaySnackBar(context, "출신학교를 선택하세요.");
                                return;
                              }
                              if (this.widget.gisu == "") {
                                _displaySnackBar(context, "기수를 입력하세요.");
                                return;
                              } else {
                                var map = new Map<String, dynamic>();

                                map = new Map<String, dynamic>();
                                map["mode"] = "insert";
                                map["member_idx"] = userInformation.userIdx;
                                map["user_id"] = this.widget.idValue;
                                map["password"] = this.widget.passValue;
                                map["email"] = this.widget.email;
                                map["gisu"] = this.widget.gisu;
                                map["school"] = this.widget.school;
                                map["member_name"] = userInformation.fullName;
                                map["USER_PHONE"] = userInformation.hp;
                                map["USER_JUMIN"] = userInformation.birth;

                                Result memberJoin = await createPost(
                                    Strings.shared.controllers.jsonURL.joinJson,
                                    body: map);

                                if (memberJoin.code != "200") {
                                  _displaySnackBar(context,
                                      Strings.shared.controllers.signIn.error2);
                                } else {
                                  await deviceinfo();

                                  userInformation.mode = "login";
                                  userInformation.loginCheck = 1;
                                  userInformation.userID = this.widget.idValue;

                                  var map = new Map<String, dynamic>();
                                  map["user_id"] = this.widget.idValue;
                                  map["user_phone"] = userInformation.hp;
                                  map["reg_key"] = userInformation.userToken;
                                  map["os_type"] = userInformation.userDeviceOS;
                                  map["os_version"] = "";
                                  map["app_version"] =
                                      userInformation.appVersion;
                                  map["device_id"] =
                                      userInformation.userDeviceID;
                                  map["push_status"] = "y";
                                  await createPost(
                                      Strings.shared.controllers.jsonURL
                                          .logininfoJson,
                                      body: map);

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.all(0.0),
                                          content: Container(
                                            color:
                                                Statics.shared.colors.lineColor,
                                            height:
                                                userInformation.userDeviceOS ==
                                                        "i"
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        1.75
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        2.0,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            2.55,
                                                    child: Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                            "Resources/Icons/join_ok.png",
                                                            scale: 2.0,
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  deviceWidth,
                                                              height: 20),
                                                          Text(
                                                            "앱 회원가입을",
                                                            style: TextStyle(
                                                                color: Statics
                                                                    .shared
                                                                    .colors
                                                                    .titleTextColor,
                                                                fontSize: Statics
                                                                    .shared
                                                                    .fontSizes
                                                                    .title,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            "환영합니다!",
                                                            style: TextStyle(
                                                                color: Statics
                                                                    .shared
                                                                    .colors
                                                                    .subColor,
                                                                fontSize: Statics
                                                                    .shared
                                                                    .fontSizes
                                                                    .title,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                Spacer(),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, bottom: 10),
                                                  alignment: Alignment.center,
                                                  color: Colors.white,
                                                  child: FlatButton(
                                                    splashColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    child: Text(
                                                      "로그인하기",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: Statics
                                                              .shared
                                                              .fontSizes
                                                              .subTitle,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder: (context) =>
                                                                  new SignIn()));
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }
                            }
                          },
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    padding: const EdgeInsets.only(top: 10),
                  ),
                  SizedBox(height: 40),
                ], //Children
              ), // Column
              padding: const EdgeInsets.only(left: 32, right: 32),

              width: MiddleWare.shared.screenSize,
            ), // Container
          ],
        ));
  } // user is logged in

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 1500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
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

  Widget schoolDropbox2() {
    return _createDropDownMenu();
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
    return _createDropDownMenu();
  }

  Widget _createDropDownMenu() {
    return Container(
        height: MediaQuery.of(context).size.height / 10,
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 2.5, top: 2.5),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            border: new Border.all(color: Colors.grey)),
        child: Row(
          children: <Widget>[
            Container(
              child: Icon(
                Icons.school,
                color: Colors.grey,
              ),
              padding: const EdgeInsets.only(right: 12),
            ),
            DropdownButton<String>(
              hint: Text('선택하세요'), // Not necessary for Option 1
              value: _selectedValue,

              style: TextStyle(
                color: Colors.black,
                fontSize: Statics.shared.fontSizes.subTitle - 2,
              ),
              onChanged: (String newValue) {
                setState(() {
                  _selectedValue = newValue;
                  this.widget.school = newValue;
                });
              },
              items: _schoolList.map((data) {
                return DropdownMenuItem<String>(
                  child: new Text(data.ccname),
                  value: data.chcode,
                );
              }).toList(),
            )
          ],
        ));
  }
}

Future<Result> createPost(String url, {Map body}) async {
  jsonMsg = "";
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;
    //final String responseBody = response.body; //한글 ��짐
    final String responseBody = utf8.decode(response.bodyBytes);
    var responseJSON = json.decode(responseBody);
    var code = responseJSON["code"];
    jsonMsg = responseJSON['msg'];

    if (statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Result.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  });
}

//JSON 데이터
class Result {
  final String code;

  Result({this.code});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      code: json['code'],
    );
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
