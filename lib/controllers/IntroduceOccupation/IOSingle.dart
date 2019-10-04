import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
import 'package:haegisa2/models/iO/IOObject.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

import 'IntroduceOccupation.dart';

class IOSingle extends StatefulWidget {
  IOObject object;

  IOSingle({IOObject obj}) {
    this.object = obj;
  }

  @override
  _IOSingle createState() => _IOSingle();
}

class _IOSingle extends State<IOSingle> {
  final _scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    double screenWidth = MediaQuery.of(context).size.width;
    Widget blueSplitter = Container(
        color: Statics.shared.colors.blueLineColor,
        height: 3,
        margin:
            const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 10));
    Widget greySplitter = Container(
        color: Statics.shared.colors.lineColor,
        height: 1,
        margin:
            const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10));
    Widget listBtn = Container(
      child: FlatButton(
        child: Container(
          child: Text(Strings.shared.controllers.noticesList.listKeyword,
              style: TextStyle(
                  color: Statics.shared.colors.mainColor,
                  fontSize: Statics.shared.fontSizes.supplementary,
                  fontWeight: FontWeight.w200)),
          alignment: Alignment.center,
        ),
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new IntroduceOccupation()));
        },
        padding: const EdgeInsets.all(0),
      ),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Statics.shared.colors.mainColor)),
      width: screenWidth,
      height: 60,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20, right: 16, left: 16, bottom: 20),
    );

    List<Widget> myImages = [];
    if (this.widget.object.viewImgUrl_1.isNotEmpty) {
      myImages.add(Image.network(
        this.widget.object.viewImgUrl_1.replaceAll("https://", "http://"),
        fit: BoxFit.cover,
        width: screenWidth / 1.5,
      ));
    }
    if (this.widget.object.viewImgUrl_2.isNotEmpty) {
      myImages.add(Image.network(
        this.widget.object.viewImgUrl_2.replaceAll("https://", "http://"),
        fit: BoxFit.cover,
        width: screenWidth / 1.5,
      ));
    }

    return WillPopScope(
        onWillPop: () async {
          _moveBack(context);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            leading: new IconButton(
              icon: userInformation.userDeviceOS == "i"
                  ? new Icon(Icons.arrow_back_ios, color: Colors.black)
                  : new Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IntroduceOccupation())),
            ),
            title: Container(
                alignment: Alignment.centerLeft,
                child: Text("직역소개",
                    style: TextStyle(
                        color: Statics.shared.colors.titleTextColor,
                        fontSize: Statics.shared.fontSizes.subTitle,
                        fontWeight: FontWeight.bold)),
                margin: const EdgeInsets.only(left: 8)),
            centerTitle: false,
            elevation: 0,
            iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
          ),
          body: Container(
            child: ListView(
              children: [
                blueSplitter,
                Padding(
                    child: Text(
                      this.widget.object.name,
                      style: TextStyle(
                        fontSize: Statics.shared.fontSizes.subTitleInContent,
                        color: Statics.shared.colors.titleTextColor,
                        fontWeight: FontWeight.w600,
                      ), // TextStyle
                    ),
                    padding: const EdgeInsets.only(left: 32, right: 32)),
                SizedBox(height: 10),
                Padding(
                    child: Row(
                      children: <Widget>[
                        Text(
                          this.widget.object.company,
                          style: TextStyle(
                            fontSize: Statics.shared.fontSizes.medium,
                            color: Statics.shared.colors.captionColor,
                            fontWeight: FontWeight.w300,
                          ), // TextStyle
                        ),
                      ], // Children
                    ),
                    padding: const EdgeInsets.only(left: 32, right: 32)),
                greySplitter,
                Container(
                  height: 300,
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Image.network(
                    this
                        .widget
                        .object
                        .viewImgUrl_1
                        .replaceAll("https://", "http://"),
                  ),

                  // CarouselSlider(
                  //   items: myImages,
                  //   height: 300,
                  // ),
                ),
                HtmlView(
                  data: this.widget.object.content,
                  scrollable: false,
                  padding: const EdgeInsets.only(left: 32, right: 32),
                ),
                greySplitter,
                listBtn
              ], // Children
            ),
            color: Colors.white,
          ), // end Body
          key: _scaffold,
        ));
  }

  void _moveBack(BuildContext context) => userInformation.userDeviceOS == "i"
      ? true
      : Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new IntroduceOccupation()));
}
