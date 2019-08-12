import 'package:flutter/material.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/controllers/profile/MiddleWare.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    String typeAsset = "";
    String userType = "";
    Color typeColor;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

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
                              fontSize: Statics.shared.fontSizes.supplementary),
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
                              fontSize: Statics.shared.fontSizes.supplementary),
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
                              fontSize: Statics.shared.fontSizes.supplementary),
                          textAlign: TextAlign.left,
                        ),
                        width: deviceWidth / 5,
                        padding: const EdgeInsets.only(right: 10),
                      ),
                      Text(
                        userInformation.hp,
                        style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.supplementary,
                        ),
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
                              fontSize: Statics.shared.fontSizes.supplementary),
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
                              fontSize: Statics.shared.fontSizes.supplementary),
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
                              fontSize: Statics.shared.fontSizes.supplementary),
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
              ]), // Row
            ),
            Row(children: <Widget>[
              Expanded(child: Divider(height: 0)),
            ]),
          ], // Row Children
        ), // Row

        alignment: Alignment(0.0, 0.0),
      ), // Container
    );
  }
}
