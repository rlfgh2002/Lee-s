import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/home/Home.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_flutter/barcode_flutter.dart';

class Barcode extends StatefulWidget {
  @override
  _BarcodeState createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return new WillPopScope(
        onWillPop: () async => false,

        // onWillPop: () async {
        //   Future.value(
        //       false); //return a `Future` with false value so this route cant be popped or closed.
        // },

        child: new Scaffold(
            body: Container(
                color: Statics.shared.colors.mainBackgroundVeryLightSilverBlue,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 20.0, bottom: 20),
                      alignment: Alignment.topRight,
                      child: FlatButton(
                        child: Image.asset("Resources/Icons/Vector.png",
                            scale: 3.0),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new MainTabBar()));
                        },
                      ),
                    ),
                    userInformation.memberType == "51001" ? type1() : type2()
                  ],
                ))));
  }

  Widget type1() {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        Image.asset(
          "Resources/Images/barcodeType1.png",
          width: deviceWidth / 1.12,
        ),
        Container(
            padding: new EdgeInsets.only(left: 20.0, right: 20.0),
            constraints: new BoxConstraints.expand(
                height: deviceHeight / 1.5, width: deviceWidth / 1.1),
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('Resources/Images/bgBarcode.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: new EdgeInsets.only(
                      top: deviceHeight / 10, bottom: deviceHeight / 20),
                  child: Text("출 입 증",
                      style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.title,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                    height: deviceHeight / 8,
                    child: new BarCodeImage(
                      data: userInformation.userIdx, // Code string. (required)
                      codeType: BarCodeType.Code39, // Code type (required)
                      lineWidth:
                          1.8, // width for a single black/white bar (default: 2.0)
                      barHeight: deviceHeight /
                          8, // height for the entire widget (default: 100.0)
                      hasText:
                          false, // Render with text label or not (default: false)
                      onError: (error) {
                        // Error handler
                        print('error = $error');
                      },
                    )),
                Container(
                  alignment: Alignment.center,
                  padding: new EdgeInsets.only(
                      top: deviceHeight / 10, bottom: deviceHeight / 20),
                  child: Text(
                      "회원님은 해기사들의 복합 문화 공간인 라운지M(한국해기사협회 빌딩 1층)을 자유롭게 이용 가능하십니다",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Statics.shared.colors.titleTextColor,
                        fontSize: Statics.shared.fontSizes.supplementary,
                      )),
                ),
              ],
            ))
      ],
    );
  }

  Widget type2() {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Image.asset(
          "Resources/Images/barcodeType2.png",
          width: deviceWidth / 1.12,
        ),
        Container(
            padding: new EdgeInsets.only(left: 20.0, right: 20.0),
            constraints: new BoxConstraints.expand(
                height: deviceHeight / 1.5, width: deviceWidth / 1.1),
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('Resources/Images/bgBarcode.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: new EdgeInsets.only(
                      top: deviceHeight / 10, bottom: deviceHeight / 20),
                  child: Text("출 입 증",
                      style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.title,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                    height: deviceHeight / 8,
                    child: new BarCodeImage(
                      data: "51002", // Code string. (required)
                      codeType: BarCodeType.Code39, // Code type (required)
                      lineWidth:
                          1.8, // width for a single black/white bar (default: 2.0)
                      barHeight: deviceHeight /
                          8, // height for the entire widget (default: 100.0)
                      hasText:
                          false, // Render with text label or not (default: false)
                      onError: (error) {
                        // Error handler
                        print('error = $error');
                      },
                    )),
                Container(
                  alignment: Alignment.center,
                  padding: new EdgeInsets.only(
                    top: deviceHeight / 20,
                  ),
                  child: Text(
                      "정회원이 되시면 해기사들의 복합 문화 공간인 라운지M(한국해기사협회 빌딩 1층)을 자유롭게 이용 가능하십니다.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Statics.shared.colors.titleTextColor,
                        fontSize: Statics.shared.fontSizes.supplementary,
                      )),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: new EdgeInsets.only(
                    top: deviceHeight / 20,
                  ),
                  child: Text("정회원으로 전환하기 >",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Statics.shared.colors.mainColor,
                          fontSize: Statics.shared.fontSizes.subTitleInContent,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            )),
      ],
    );
  }
}
