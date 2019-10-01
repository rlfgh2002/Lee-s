import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MiddleWare.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';

class Agree extends StatefulWidget {
  @override
  _AgreeInState createState() => _AgreeInState();
}

class _AgreeInState extends State<Agree> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _termsChecked = true;

  String btnStatus = "";
  String btnOff = "Resources/Icons/radio_inactive.png";
  String btnOn = "Resources/Icons/radio_active.png";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    MiddleWare.shared.screenSize = MediaQuery.of(context).size.width;

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
                  Strings.shared.controllers.term.terms_title,
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.title,
                    fontWeight: FontWeight.bold,
                    color: Statics.shared.colors.titleTextColor,
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 70)),
            Container(
                child: Text(
                  Strings.shared.controllers.term.terms_title_detial,
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.subTitle,
                    color: Statics.shared.colors.subTitleTextColor,
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(right: 64, top: 20)),
            SizedBox(height: 40),
            Container(
                child: FlatButton(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListView(children: getFormWidget()),
                        Text(
                          " " +
                              Strings.shared.controllers.term
                                  .terms_accept_all_title,
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: Statics.shared.fontSizes.supplementary),
                          textAlign: TextAlign.left,
                        ),
                      ]),
                  onPressed: () {
                    if (btnStatus == btnOff) {
                      btnStatus = btnOn;
                    } else {
                      btnStatus = btnOff;
                    }
                  },
                  padding: const EdgeInsets.only(right: 64),
                ),
                padding: const EdgeInsets.only(bottom: 20)),
            Container(
                child: Column(children: [
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "Resources/Icons/radio_inactive.png",
                                scale: 4.0,
                              ),
                              Text(
                                " " +
                                    Strings.shared.controllers.term
                                        .terms_terms_title
                                        .substring(0, 12),
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                Strings
                                    .shared.controllers.term.terms_terms_title
                                    .substring(12, 17),
                                style: TextStyle(
                                    color: Statics.shared.colors.mainColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary),
                                textAlign: TextAlign.left,
                              ),
                              FlatButton(
                                  child: Text(
                                    Strings.shared.controllers.term.terms_view,
                                    style: TextStyle(
                                        color: Statics
                                            .shared.colors.subTitleTextColor,
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary,
                                        decoration: TextDecoration.underline),
                                    textAlign: TextAlign.left,
                                  ),
                                  onPressed: () {},
                                  padding: const EdgeInsets.only(right: 64))
                            ]),
                        onPressed: () {},
                        padding: const EdgeInsets.only(right: 64),
                      ),
                    ]),
              ),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "Resources/Icons/radio_inactive.png",
                                scale: 4.0,
                              ),
                              Text(
                                " " +
                                    Strings.shared.controllers.term
                                        .terms_policy_title
                                        .substring(0, 15),
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                Strings
                                    .shared.controllers.term.terms_policy_title
                                    .substring(15, 20),
                                style: TextStyle(
                                    color: Statics.shared.colors.mainColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary),
                                textAlign: TextAlign.left,
                              ),
                              FlatButton(
                                child: Text(
                                  Strings.shared.controllers.term.terms_view,
                                  style: TextStyle(
                                      color: Statics
                                          .shared.colors.subTitleTextColor,
                                      fontSize: Statics
                                          .shared.fontSizes.supplementary,
                                      decoration: TextDecoration.underline),
                                  textAlign: TextAlign.left,
                                ),
                                onPressed: () {},
                                padding: const EdgeInsets.only(right: 64),
                              )
                            ]),
                        onPressed: () {},
                        padding: const EdgeInsets.only(right: 10),
                      ),
                    ]),
              ),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "Resources/Icons/radio_inactive.png",
                                scale: 4.0,
                              ),
                              Text(
                                " " +
                                    Strings.shared.controllers.term
                                        .terms_notification_title,
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.supplementary),
                                textAlign: TextAlign.left,
                              ),
                            ]),
                        onPressed: () {},
                        padding: const EdgeInsets.only(right: 10),
                      ),
                    ]),
              )
            ])),
            SizedBox(height: 40),
          ], //Children
        ), // Column
        padding: const EdgeInsets.only(left: 32, right: 32),

        width: MiddleWare.shared.screenSize,
      ), // Container
    );
  } // user is logged in

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 1500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(CheckboxListTile(
      value: _termsChecked,
      onChanged: (value) {
        setState(() {
          _termsChecked = value;
        });
      },
      subtitle: !_termsChecked
          ? Text(
              'Required',
              style: TextStyle(color: Colors.red, fontSize: 12.0),
            )
          : null,
      title: new Text(
        'I agree to the terms and condition',
      ),
      controlAffinity: ListTileControlAffinity.leading,
    ));

    return formWidget;
  }
}
