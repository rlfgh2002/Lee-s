import 'package:flutter/material.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
import 'package:haegisa2/controllers/auth/TermsView.dart';
import 'package:haegisa2/controllers/auth/TermsWebView.dart';
import 'package:haegisa2/main.dart';
import 'package:haegisa2/controllers/auth/shared.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';

///[TermsPage] state class to handle UI and logic of page
class TermsState extends State<TermsPage> {
  bool _isTermsAccepted = false;
  bool _isPrivacyAccepted = false;
  bool _isNotificationAccepted = false;

  ///Toggles terms and conditions agreement
  void _toggleTerms() {
    setState(() {
      _isTermsAccepted = !_isTermsAccepted;
    });
  }

  ///Toggles privacy policy agreement
  void _togglePrivacy() {
    setState(() {
      _isPrivacyAccepted = !_isPrivacyAccepted;
    });
  }

  ///Toggles notification agreement
  void _toggleNotification() {
    setState(() {
      _isNotificationAccepted = !_isNotificationAccepted;
    });
  }

  ///Toggles terms and conditions and privacy policy agreement
  void _toggleTermsAndPrivacy() {
    setState(() {
      bool currentState = _termsAndPrivacyAccepted();
      _isTermsAccepted = !currentState;
      _isPrivacyAccepted = !currentState;
      _isNotificationAccepted = !currentState;
    });
  }

  ///Replace login page if agreements was accepted
  void _handleGetStart(BuildContext context) async {
    await Shared.load();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool("user_pushStatus", _isNotificationAccepted);
    sharedPreferences.setBool("user_agree", true);
    sharedPreferences.commit();

    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SplashScreen()));
  }

  ///Show detail of terms
  void _showTermDetails() {
    userInformation.mode = "Terms";
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TermsView()));
  }

  // void _showTermDetails() => Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => TermsDetailPage(
  //               term: Term(Strings.shared.controllers.term.terms_accept_no,
  //                   Strings.shared.controllers.term.terms_accept_no),
  //             )));

  ///Show detail of privacy policy
  void _showPrivacyDetails() {
    userInformation.mode = "Privacy";
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TermsView()));
  }
  // void _showPrivacyDetails() => Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => TermsDetailPage(
  //               term: Term("11", "22"),
  //             )));

  ///Show detail of notification
  void _showNotificationDetails() {} //Nothing show

  ///Indicates that agreements are accepted or not
  bool _termsAndPrivacyAccepted() =>
      _isTermsAccepted && _isPrivacyAccepted && _isNotificationAccepted;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 36, right: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 90,
                  ),
                  Text(
                    Strings.shared.controllers.term.terms_title,
                    style: TextStyle(
                      fontSize: Statics.shared.fontSizes.title,
                      color: Statics.shared.colors.titleTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    Strings.shared.controllers.term.terms_title_detial,
                    style: TextStyle(
                      fontSize: Statics.shared.fontSizes.subTitle,
                      color: Statics.shared.colors.titleTextColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 100),
                      alignment: Alignment.topLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          _CheckBox(
                            _termsAndPrivacyAccepted(),
                            onTap: _toggleTermsAndPrivacy,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  onTap: _toggleTermsAndPrivacy,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 9),
                                    child: Text(
                                      Strings.shared.controllers.term
                                          .terms_accept_all_title,
                                      style: TextStyle(
                                        color: Statics
                                            .shared.colors.titleTextColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 32),
                                  height: 1,
                                  color:
                                      Statics.shared.colors.subTitleTextColor,
                                ),
                                agreementRow(
                                    Strings.shared.controllers.term
                                        .terms_terms_title,
                                    _isTermsAccepted,
                                    _toggleTerms,
                                    _showTermDetails),
                                agreementRow(
                                    Strings.shared.controllers.term
                                        .terms_policy_title,
                                    _isPrivacyAccepted,
                                    _togglePrivacy,
                                    _showPrivacyDetails),
                                agreementRow2(
                                    Strings.shared.controllers.term
                                        .terms_notification_title,
                                    _isNotificationAccepted,
                                    _toggleNotification,
                                    _showNotificationDetails)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          FlatButton(
            padding: EdgeInsets.all(20),
            color: Statics.shared.colors.mainColor,
            disabledColor: Statics.shared.colors.subTitleTextColor,
            child: Text(Strings.shared.controllers.term.terms_next,
                style: TextStyle(
                    fontSize: Statics.shared.fontSizes.titleInContent,
                    color: Colors.white)),
            onPressed: _isTermsAccepted && _isPrivacyAccepted
                ? () => _handleGetStart(context)
                : null,
          )
        ],
      ),
    );
  }

  Function agreementRow = (String text, bool isChecked,
      Function checkTapHandler, Function tapHandler) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _CheckBox(
              isChecked,
              onTap: checkTapHandler,
              size: 17,
            ),
            Expanded(
              child: InkWell(
                onTap: checkTapHandler,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(text,
                      style: TextStyle(
                        color: Statics.shared.colors.subTitleTextColor,
                        fontSize: 14,
                      )),
                ),
              ),
            ),
            InkWell(
              onTap: tapHandler,
              child: Padding(
                padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
                child: Container(
                    width: 9,
                    height: 19,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('Resources/Icons/Vector 3.2.png')),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  };

  Function agreementRow2 = (String text, bool isChecked,
      Function checkTapHandler, Function tapHandler) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _CheckBox(
              isChecked,
              onTap: checkTapHandler,
              size: 17,
            ),
            Expanded(
              child: InkWell(
                onTap: checkTapHandler,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(text,
                      style: TextStyle(
                        color: Statics.shared.colors.subTitleTextColor,
                        fontSize: 14,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  };
}

class TermsPage extends StatefulWidget {
  @override
  TermsState createState() => TermsState();
}

///Detail page to show detail of Terms and Conditions and privacy policy
///
///Also see [TermsPage]
class TermsDetailPage extends StatelessWidget {
  ///term object to show its data
  final Term term;

  const TermsDetailPage({this.term});

  @override
  Widget build(BuildContext context) {
    setStatusBar(backgroundColor: Colors.white, isForegroundWhite: false);
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 32, left: 36, right: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              term.title,
              style: TextStyle(
                fontSize: 34,
                color: Statics.shared.colors.subTitleTextColor,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            Container(
              color: Statics.shared.colors.subTitleTextColor,
              height: 2,
            ),
            SizedBox(height: 30),
            Expanded(
                child: SingleChildScrollView(
              child: Text(
                term.detail,
                style: TextStyle(
                  fontSize: 14,
                  color: Statics.shared.colors.subTitleTextColor,
                ),
                textAlign: TextAlign.left,
              ),
            )),
          ],
        ),
      ),
    );
  }
}

void setStatusBar({backgroundColor: Color, isForegroundWhite = false}) {}

void showSimpleDialog(BuildContext context, String title, String message,
    {String actionText = '', bool cancelable = true, Function actionHandler}) {
  showDialog(
      context: context,
      barrierDismissible: cancelable,
      builder: (BuildContext context) => AlertDialog(
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Statics.shared.colors.subTitleTextColor,
              ),
            ),
            content: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Statics.shared.colors.subTitleTextColor,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                padding: EdgeInsets.all(10),
                child: Text(
                  actionText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Statics.shared.colors.subTitleTextColor,
                  ),
                ),
                onPressed: actionHandler ?? () => Navigator.of(context).pop(),
              )
            ],
          ));
}

class UnGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

///Custom circle check box widget
class _CheckBox extends StatelessWidget {
  ///indicates that check box is checked or not
  final bool _isChecked;

  ///handle check tap
  final Function onTap;

  ///change size of check box if needed
  final double size;

  const _CheckBox(this._isChecked, {this.onTap, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isChecked
              ? Statics.shared.colors.mainColor
              : Statics.shared.colors.subTitleTextColor),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          Icons.check,
          size: size,
          color: Colors.white,
        ),
      ),
    );
  }
}
