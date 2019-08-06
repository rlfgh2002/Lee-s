import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haegisa2/main.dart';
import 'dart:async';
import 'package:haegisa2/controllers/sign/SignIn.dart';
import 'package:haegisa2/controllers/sign/SignSelect.dart';
import 'package:haegisa2/controllers/member/find_id.dart';
import 'package:haegisa2/controllers/member/find_pw.dart';
import 'package:haegisa2/controllers/member/join.dart';
import 'dart:convert';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/views/sign/authWidget.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  // Instance of WebView plugin
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  static String selectedUrl = Strings.shared.controllers.jsonURL.authJson +
      '?mode=' +
      userInformation.mode;

  String idValue = "";
  String passValue = "";
  String jsonMsg = "";

  // On destroy stream
  StreamSubscription _onDestroy;
  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;
  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  StreamSubscription<double> _onScrollYChanged;
  StreamSubscription<double> _onScrollXChanged;
  String currentURL = '';

  final _urlCtrl = TextEditingController(text: selectedUrl);
  final _codeCtrl = TextEditingController(text: 'window.navigator.userAgent');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _history = [];

  @override
  Widget build(BuildContext context) {
    //MiddleWare.shared.screenSize = MediaQuery.of(context).size.width;
    return WebviewScaffold(
      url: selectedUrl,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      withJavascript: true,
      initialChild: Container(
        //color: Colors.redAccent,
        child: const Center(
          child: Text('잠시만 기다려주세요..'),
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     children: <Widget>[
      //       IconButton(s
      //         icon: const Icon(Icons.arrow_back_ios),
      //         onPressed: () {
      //           FlutterWebviewPlugin().goBack();
      //         },
      //       ),
      //       IconButton(
      //         icon: const Icon(Icons.arrow_forward_ios),
      //         onPressed: () {
      //           FlutterWebviewPlugin().goForward();
      //         },
      //       ),
      //       IconButton(
      //         icon: const Icon(Icons.autorenew),
      //         onPressed: () {
      //           FlutterWebviewPlugin().reload();
      //           //FlutterWebviewPlugin().close();
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  @override
  void initState() {
    super.initState();

    //String d = "\u0024;";
    flutterWebviewPlugin.onStateChanged.listen((state) async {
      await deviceinfo();

      if (userInformation.mode == "join") {
        if (currentURL ==
            'http://www.mariners.or.kr/member/mobile_checkplus_success.php') {
          if (state.type == WebViewState.finishLoad) {
            currentURL = ''; //아이폰이 다시 이전 페이지로 돌아오는 경우때문에 url을 초기화 시킴
            //flutterWebviewPlugin.evalJavascript("console.log(myFunction());");
            String script = 'statusMsg("' + userInformation.userDeviceOS + '")';
            //res = '1' already, '0' = new member7
            var res = await flutterWebviewPlugin.evalJavascript(script);
            Map valueMap = json.decode(res);

            if (valueMap['status'] == 0) {
              flutterWebviewPlugin.close();
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    authAlert();
                  });
            } else if (valueMap['status'] == 1) {
              //res가 //0 : 해기사 회원이 아님, 1 : 신규회원, 2 : 이미 존재하는 회원(홈페이지) 4 : 오류
              flutterWebviewPlugin.close();
              userInformation.fullName = valueMap['name'];
              userInformation.hp = valueMap['hp'];
              userInformation.userIdx = valueMap['member_idx'];
              userInformation.gender = valueMap['gender'];
              userInformation.birth = valueMap['bitrh'];
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Join()));
            } else if (valueMap['status'] == 2) {
              //회원가입 페이지로
            } else if (valueMap['status'] == 3) {
              //회원가입 페이지로
            } else if (valueMap['status'] == 4) {
              //회원가입 페이지로
            }
          }
        }
      } else if (userInformation.mode == "find_id") {
        if (currentURL ==
            'http://www.mariners.or.kr/member/mobile_checkplus_checkid_success.php') {
          if (state.type == WebViewState.finishLoad) {
            currentURL = ''; //아이폰이 다시 이전 페이지로 돌아오는 경우때문에 url을 초기화 시킴
            String script = 'statusMsg("' + userInformation.userDeviceOS + '")';
            //res = '1' already, '0' = new member7
            var res = await flutterWebviewPlugin.evalJavascript(script);
            Map valueMap = json.decode(res);
            if (valueMap["status"] == 0) {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new SignIn()));
            } else if (valueMap["status"] == 1) {
              userInformation.userID = valueMap['id'];
              flutterWebviewPlugin.close();
              flutterWebviewPlugin.onDestroy;
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new FindID()));
            } else if (valueMap["status"] == 2) {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new SignIn()));
            }
          }
        }
      } else if (userInformation.mode == "find_pw") {
        if (currentURL ==
            'http://www.mariners.or.kr/member/mobile_checkplus_checkpw_success.php') {
          if (state.type == WebViewState.finishLoad) {
            currentURL = ''; //아이폰이 다시 이전 페이지로 돌아오는 경우때문에 url을 초기화 시킴
            String script = 'statusMsg("' + userInformation.userDeviceOS + '")';
            //res = '1' already, '0' = new member7
            var res = await flutterWebviewPlugin.evalJavascript(script);
            Map valueMap = json.decode(res);
            if (valueMap["status"] == 0) {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new SignIn()));
            } else if (valueMap["status"] == 1) {
              currentURL = '';
              userInformation.userID = valueMap['id'];
              flutterWebviewPlugin.close();
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new FindPW()));
            } else if (valueMap["status"] == 2) {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new SignIn()));
            }
          }
        }
      } else if (currentURL ==
          'http://www.mariners.or.kr/member/mobile_checkplus_fail.php') {}
    });

    flutterWebviewPlugin.close();

    _urlCtrl.addListener(() {
      selectedUrl = _urlCtrl.text;
    });

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: const Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
          currentURL = url;
        });
      }
    });

    _onScrollYChanged =
        flutterWebviewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in Y Direction: $y');
        });
      }
    });

    _onScrollXChanged =
        flutterWebviewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in X Direction: $x');
        });
      }
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          _history.add('onStateChanged: ${state.type} ${state.url}');
        });
      }
    });

    _onHttpError =
        flutterWebviewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _history.add('onHttpError: ${error.code} ${error.url}');
        });
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebviewPlugin.dispose();

    super.dispose();
  }

  Widget authAlert() {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
        height: MediaQuery.of(context).size.height / 1.5,
        child: Column(
          children: <Widget>[
            Container(
              child: Image.asset(
                "Resources/Images/no_member.png",
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40, bottom: 10),
              child: Text(
                Strings.shared.controllers.signSelect.title3,
                style: TextStyle(
                    color: Statics.shared.colors.titleTextColor,
                    fontSize: Statics.shared.fontSizes.supplementary),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Text(
                    Strings.shared.controllers.signSelect.title3_1
                        .substring(0, 13),
                    style: TextStyle(
                        color: Statics.shared.colors.titleTextColor,
                        fontSize: Statics.shared.fontSizes.subTitle,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    Strings.shared.controllers.signSelect.title3_1
                        .substring(13, 14),
                    style: TextStyle(
                        color: Statics.shared.colors.titleTextColor,
                        fontSize: Statics.shared.fontSizes.content),
                    textAlign: TextAlign.center,
                  ),
                ])),
            Expanded(
              child: Text(
                Strings.shared.controllers.signSelect.title3_1
                    .substring(14, 28),
                style: TextStyle(
                    color: Statics.shared.colors.titleTextColor,
                    fontSize: Statics.shared.fontSizes.content),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                // This align moves the children to the bottom
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    // This container holds all the children that will be aligned
                    // on the bottom and should not scroll with the above ListView
                    child: Container(
                        child: Column(
                      children: <Widget>[
                        Image.asset(
                          'Resources/Icons/Line2.png',
                        ),
                        FlatButton(
                          padding: const EdgeInsets.only(top: 30, bottom: 30),
                          child: Text(
                            Strings.shared.controllers.signSelect.confirm,
                            style: TextStyle(
                                color: Statics.shared.colors.titleTextColor,
                                fontSize: Statics.shared.fontSizes.content),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            flutterWebviewPlugin.close();
                            userInformation.lognCheck = 0;
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new MyApp()));
                          },
                        ),
                      ],
                    ))))
          ],
        ),
      ),
    );
  }
}
