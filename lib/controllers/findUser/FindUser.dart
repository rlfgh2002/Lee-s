import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/findUser/FindUserSearch.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';

class FindUser extends StatefulWidget {
  TextEditingController ctrlTxtSearch;

  @override
  _FindUserState createState() => _FindUserState();
}

class _FindUserState extends State<FindUser> {
  final _scaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    widget.ctrlTxtSearch = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    double screenWidth = MediaQuery.of(context).size.width;
    double paddingRightLeft = (screenWidth * (30 / 100)) / 2;
    double paddingRightLeftSearchBox = (screenWidth * (20 / 100)) / 2;

    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Container(
                child: Text(Strings.shared.controllers.findUser.pageTitle,
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
              child: Column(
                children: <Widget>[
                  Container(
                      child: Text(Strings.shared.controllers.findUser.title1,
                          style: TextStyle(
                              fontSize: Statics.shared.fontSizes.titleInContent,
                              color: Statics.shared.colors.titleTextColor),
                          textAlign: TextAlign.center),
                      padding: EdgeInsets.only(
                          left: paddingRightLeft,
                          right: paddingRightLeft,
                          top: 30),
                      margin: const EdgeInsets.only(bottom: 15)),
                  // Container(
                  //     child: Text(Strings.shared.controllers.findUser.caption1,
                  //         style: TextStyle(
                  //             fontSize: Statics.shared.fontSizes.content,
                  //             color: Statics.shared.colors.captionColor),
                  //         textAlign: TextAlign.center),
                  //     padding: EdgeInsets.only(
                  //         left: paddingRightLeft,
                  //         right: paddingRightLeft,
                  //         top: 0),
                  //     margin: const EdgeInsets.only(bottom: 30)),
                  Container(
                      child: Text(Strings.shared.controllers.findUser.caption2,
                          style: TextStyle(
                              fontSize: Statics.shared.fontSizes.medium,
                              color: Statics.shared.colors.captionColor),
                          textAlign: TextAlign.left),
                      padding: EdgeInsets.only(
                          left: paddingRightLeft,
                          right: paddingRightLeft,
                          top: 0),
                      margin: const EdgeInsets.only(bottom: 30)),
                  Container(
                      child: TextField(
                        autofocus: false,
                        maxLines: 1,
                        minLines: 1,
                        controller: widget.ctrlTxtSearch,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: Strings
                              .shared.controllers.findUser.searchPlaceHolder,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                              left: 32, right: 32, top: 20, bottom: 20),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromRGBO(241, 244, 250, 1)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          hintStyle: TextStyle(
                              fontSize: Statics.shared.fontSizes.content,
                              color: Statics.shared.colors.subTitleTextColor),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                        ),
                        style: TextStyle(
                          fontSize: Statics.shared.fontSizes.content,
                          color: Statics.shared.colors.titleTextColor,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new FindUserSearch()));
                        },
                      ),
                      padding: EdgeInsets.only(
                          left: paddingRightLeftSearchBox,
                          right: paddingRightLeftSearchBox,
                          top: 0)),
                  Expanded(child: Container()),
                  Container(
                      child: Image.asset(
                    "Resources/Images/findUserImageBottom.png",
                    width: screenWidth,
                  ))
                ], // children
              ),
              color: Statics.shared.colors.mainBackgroundVeryLightSilverBlue,
              alignment: Alignment.center), // end body
          key: _scaffold,
        ));
  }
}
