import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/auth/TermsWebview.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/controllers/profile/UserInfo.dart';

class Terms extends StatefulWidget {
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
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

    return Scaffold(
        appBar: AppBar(
          title: Text("이용 약관",
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
        body: Column(
          children: <Widget>[
            Container(
              height: 10,
              color: Statics.shared.colors.lineColor,
              padding: const EdgeInsets.only(top: 20),
            ),
            FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    height: deviceWidth / 5,
                    child: Row(children: <Widget>[
                      Text(
                        Strings.shared.controllers.term.terms_terms_title,
                        style: TextStyle(
                            color: Statics.shared.colors.titleTextColor,
                            fontSize:
                                Statics.shared.fontSizes.subTitleInContent),
                        textAlign: TextAlign.left,
                      ),
                      Spacer(),
                      SizedBox(
                        width: 50,
                        child: Image.asset('Resources/Icons/Vector 3.2.png',
                            width: 10, scale: 4.0),
                      )
                    ])),
                onPressed: () {
                  userInformation.mode = "Terms";
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TermsView()));
                }),
            Row(children: <Widget>[
              Expanded(child: Divider(height: 0)),
            ]),
            FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    height: deviceWidth / 5,
                    child: Row(children: <Widget>[
                      Text(
                        Strings.shared.controllers.term.terms_policy_title,
                        style: TextStyle(
                            color: Statics.shared.colors.titleTextColor,
                            fontSize:
                                Statics.shared.fontSizes.subTitleInContent),
                        textAlign: TextAlign.left,
                      ),
                      Spacer(),
                      SizedBox(
                        width: 50,
                        child: Image.asset('Resources/Icons/Vector 3.2.png',
                            width: 10, scale: 4.0),
                      )
                    ])),
                onPressed: () {
                  userInformation.mode = "Privacy";
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TermsView()));
                }),
            Container(
              height: deviceHeight,
              color: Statics.shared.colors.lineColor,
              padding: const EdgeInsets.only(top: 20),
            ),
          ],
          // Container
        ));
  }
}
