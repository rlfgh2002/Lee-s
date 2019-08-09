import 'package:flutter/material.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/controllers/profile/MiddleWare.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    String typeAsset = "";
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    if (userInformation.memberType == "51001") {
      typeAsset = "Resources/Icons/user_type_01.png";
    } else {
      typeAsset = "Resources/Icons/user_type_02.png";
    }

    return new WillPopScope(
      onWillPop: () async => false,

      // onWillPop: () async {
      //   Future.value(
      //       false); //return a `Future` with false value so this route cant be popped or closed.
      // },

      child: new Scaffold(
        appBar: AppBar(
          title: Text("내 메뉴",
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
              Container(
                child: Row(children: [
                  Image.asset(typeAsset, scale: 3),
                  Text(" 홍길동님은 정회원 입니다.",
                      style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.titleInContent)),
                ]), // Row
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20, bottom: 5),
              ),
              Image.asset('Resources/Icons/Line3.png'),
              Container(
                child: Column(children: [
                  Container(
                      child: IntrinsicHeight(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                            child: FlatButton(
                              child: Row(children: [
                                Image.asset(
                                    'Resources/Icons/btn_feehistory.png',
                                    scale: 2.5),
                                Text("회비납부내역",
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary)),
                              ]),
                              onPressed: () {},
                            ),
                            width: deviceWidth / 2,
                            height: deviceWidth / 6),
                        VerticalDivider(width: 0),
                        SizedBox(
                            child: FlatButton(
                              child: Row(children: [
                                Image.asset('Resources/Icons/btn_inquiry.png',
                                    scale: 2.5),
                                Text("1:1문의",
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary)),
                              ]),
                              onPressed: () {},
                            ),
                            width: deviceWidth / 2,
                            height: deviceWidth / 6)
                      ],
                    ), // Row Children
                  )),
                  Row(children: <Widget>[
                    Expanded(child: Divider(height: 0)),
                  ]),
                  Container(
                      child: IntrinsicHeight(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                            child: FlatButton(
                              child: Row(children: [
                                Image.asset('Resources/Icons/btn_occasion.png',
                                    scale: 2.5),
                                Text("경조사 통보",
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary)),
                              ]),
                              onPressed: () {},
                            ),
                            width: deviceWidth / 2,
                            height: deviceWidth / 6),
                        VerticalDivider(width: 0),
                        SizedBox(
                            child: FlatButton(
                              child: Row(children: [
                                Image.asset('Resources/Icons/btn_advisory.png',
                                    scale: 2.5),
                                Text("해기 자문센터",
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary)),
                              ]),
                              onPressed: () {},
                            ),
                            width: deviceWidth / 2,
                            height: deviceWidth / 6)
                      ],
                    ), // Row Children
                  )),
                ]), // Row
              ),
              Image.asset('Resources/Icons/Line3.png', width: 34),
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: Column(children: [
                  Container(
                    height: deviceWidth / 6,
                    padding: const EdgeInsets.only(left: 20),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(children: [
                          Text(
                            "회비납부내역",
                            style: TextStyle(
                                color: Statics.shared.colors.titleTextColor,
                                fontSize:
                                    Statics.shared.fontSizes.supplementary),
                            textAlign: TextAlign.left,
                          ),
                          FlatButton(
                            child: Image.asset('Resources/Icons/Vector 3.2.png',
                                scale: 2.5),
                            onPressed: () {},
                          ),
                        ]),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(children: [
                          Text(
                            "회비납부내역",
                            style: TextStyle(
                                color: Statics.shared.colors.titleTextColor,
                                fontSize:
                                    Statics.shared.fontSizes.supplementary),
                            textAlign: TextAlign.left,
                          ),
                          FlatButton(
                            child: Image.asset('Resources/Icons/Vector 3.2.png',
                                scale: 2.5),
                            onPressed: () {},
                          ),
                        ]),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(children: [
                          Text(
                            "회비납부내역",
                            style: TextStyle(
                                color: Statics.shared.colors.titleTextColor,
                                fontSize:
                                    Statics.shared.fontSizes.supplementary),
                            textAlign: TextAlign.left,
                          ),
                          FlatButton(
                            child: Image.asset('Resources/Icons/Vector 3.2.png',
                                scale: 2.5),
                            onPressed: () {},
                          ),
                        ]),
                      ],
                    ), // Row Children
                  ),
                ]), // Row
              ),
            ], // Row Children
          ), // Row

          alignment: Alignment(0.0, 0.0),
        ), // Container
      ),
    );
  }
}
