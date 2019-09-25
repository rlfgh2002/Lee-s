import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/sign/SignIn.dart';
import 'package:haegisa2/controllers/auth/auth.dart';
import 'package:haegisa2/main.dart';
import 'MiddleWare.dart';
import 'dart:async';
import 'dart:convert';
import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/views/buttons/Buttons.dart';
import 'package:http/http.dart' as http;

String idValue = "";
String passValue = "";
String jsonMsg = "";

class FindID extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    MiddleWare.shared.screenSize = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          body: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                    child: Text(
                      Strings.shared.controllers.signIn.findID1,
                      style: TextStyle(
                        fontSize: Statics.shared.fontSizes.subTitle,
                        color: Statics.shared.colors.titleTextColor,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 70)),
                Container(
                    child: Text(
                      userInformation.userID,
                      style: TextStyle(
                        fontSize: Statics.shared.fontSizes.title,
                        fontWeight: FontWeight.bold,
                        color: Statics.shared.colors.mainColor,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(right: 64, top: 20)),
                Container(
                    child: Text(
                      Strings.shared.controllers.signIn.findID2,
                      style: TextStyle(
                        fontSize: Statics.shared.fontSizes.subTitle,
                        color: Statics.shared.colors.titleTextColor,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(right: 64, top: 20)),
                Container(
                    child: Row(
                      children: [
                        FlatButton(
                          child: Row(children: [
                            Text(Strings.shared.controllers.signSelect.button1,
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize: Statics
                                        .shared.fontSizes.supplementary)),
                            Image.asset('Resources/Icons/btn_next_blue.png',
                                width: 28, height: 28),
                          ]),
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new SignIn()));
                          },
                        ),
                      ], // Row Children
                      mainAxisAlignment: MainAxisAlignment.center,
                    ), // Row
                    alignment: Alignment.center),
                SizedBox(height: 40),
              ], //Children
            ), // Column
            padding: const EdgeInsets.only(left: 32, right: 32),

            width: MiddleWare.shared.screenSize,
          ), // Container
        ));
  } // user is logged in

}

Future<Result> createPost(String url, {Map body}) async {
  jsonMsg = "";
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;
    //final String responseBody = response.body; //한글 깨짐
    final String responseBody = utf8.decode(response.bodyBytes);
    var responseJSON = json.decode(responseBody);
    var code = responseJSON["code"];
    jsonMsg = responseJSON['msg'];

    if (statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var table = responseJSON["table"];
      if (code == "200") {
        for (var result in table) {
          return Result.fromJson(result);
        }
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  });
}

//JSON 데이터
class Result {
  final String idx;
  final String member_idx;
  final String id;
  final String member_name;

  Result({this.idx, this.member_idx, this.id, this.member_name});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      idx: json['idx'],
      member_idx: json['member_idx'],
      id: json['id'],
      member_name: json['member_name'],
    );
  }
}
