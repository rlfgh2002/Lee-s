import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MiddleWare.dart';
import 'dart:async';
import 'dart:convert';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/controllers/member/find_id.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/views/buttons/Buttons.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  String idValue = "";
  String passValue = "";

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    MiddleWare.shared.screenSize = MediaQuery.of(context).size.width;

    String idValue = "";
    String passValue = "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
                child: Text(
                  Strings.shared.controllers.signIn.title1,
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.title,
                    color: Statics.shared.colors.titleTextColor,
                  ),
                ),
                alignment: Alignment.centerLeft),
            Container(
                child: Text(
                  Strings.shared.controllers.signIn.title2,
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.title,
                    color: Statics.shared.colors.mainColor,
                  ),
                ),
                alignment: Alignment.centerLeft),
            Container(
                child: Text(
                  Strings.shared.controllers.signIn.subTitle,
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.subTitle,
                    color: Statics.shared.colors.subTitleTextColor,
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(right: 64, top: 20)),
            SizedBox(height: 40),

            //아이디 입력
            Container(
                child: TextField(
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: Statics.shared.fontSizes.subTitle,
                        color: Statics.shared.colors.subTitleTextColor,
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.perm_identity),
                      hintText: Strings
                          .shared.controllers.signIn.txtHintUser), // decoration
                  onChanged: (String str) {
                    idValue = str;
                  },
                ),
                alignment: Alignment.centerLeft),
            SizedBox(height: 15),

            //패스워드 입력
            Container(
                child: TextField(
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: Statics.shared.fontSizes.subTitle,
                        color: Statics.shared.colors.subTitleTextColor,
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: Strings.shared.controllers.signIn.txtHintPass),
                  obscureText: true, // decoration
                  onChanged: (String str) {
                    passValue = str;
                  },
                ),
                alignment: Alignment.centerLeft),
            SizedBox(height: 5),
            Container(
                child: Row(
                  children: [
                    FlatButton(
                      child: Text(Strings.shared.controllers.signIn.findIDTitle,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics
                                  .shared.fontSizes.supplementary)), // Text
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new FindID()));
                      },
                      padding: const EdgeInsets.all(0),
                    ), // Flat Button -> FindID
                    Text("  |  ",
                        style: TextStyle(
                            color: Statics.shared.colors.subTitleTextColor)),
                    FlatButton(
                      child: Text(
                          Strings.shared.controllers.signIn.forgetPasswordTitle,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize: Statics
                                  .shared.fontSizes.supplementary)), // Text
                      onPressed: () {},
                      padding: const EdgeInsets.all(0),
                    ), // Flat Button -> ForgetPassword
                  ], // Row Children
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                ), // Row
                alignment: Alignment.centerRight),
          ], //Children
        ), // Column
        padding: const EdgeInsets.only(left: 32, right: 32),
        width: MiddleWare.shared.screenSize,
      ), // Container
      bottomNavigationBar: Container(
        child: Row(
          children: [
            HaegisaButton(
              text: Strings.shared.controllers.signIn.loginBtnTitle,
              iconURL: "Resources/Icons/Vecto_ 3.2.png",
              onPressed: () async {
                if (trim(idValue) == "") {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content:
                            Text(Strings.shared.controllers.signIn.enterID)));
                  return;
                } else if (trim(passValue) == "") {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content:
                            Text(Strings.shared.controllers.signIn.enterPass)));
                  return;
                }
                var map = new Map<String, dynamic>();
                map["id"] = idValue;
                map["pwd"] = passValue;
                Result resultPost = await createPost(
                    Strings.shared.controllers.jsonURL.loginJson,
                    body: map);
                if (resultPost.msg == "ID is Wrong") {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content:
                            Text(Strings.shared.controllers.signIn.wrongID)));
                  return;
                } else if (resultPost.msg == "PASSWORD is Wrong") {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content:
                            Text(Strings.shared.controllers.signIn.wrongPass)));
                  return;
                }
              },
            )
          ],
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        padding: const EdgeInsets.only(bottom: 32, right: 32),
        width: MiddleWare.shared.screenSize,
      ), // Bottom Sheet Container
    );
  }
}

Future<Result> createPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;
    final String responseBody = response.body;
    var responseJSON = json.decode(responseBody);
    var code = responseJSON['code'];

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
  final String msg;
  final String table;

  Result({this.code, this.msg, this.table});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      code: json['code'],
      msg: json['msg'],
      table: json['table'],
    );
  }
}
