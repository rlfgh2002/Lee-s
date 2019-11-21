import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/Auth/nullpage.dart';
import 'package:haegisa2/controllers/SplashScreen/SplashScreen.dart';
import 'package:haegisa2/controllers/sign/SignError.dart';
import 'dart:async';
import 'package:haegisa2/controllers/member/find_id.dart';
import 'package:haegisa2/controllers/member/find_pw.dart';
import 'package:haegisa2/controllers/member/join.dart';
import 'package:haegisa2/controllers/sign/SignIn.dart';
import 'dart:convert';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    return WebviewScaffold(
      url: selectedUrl,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
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
            await new Future.delayed(const Duration(
                seconds: 1)); //아이폰 바로 진행하면 res값이 null넘어와서 딜레이주고 실행
            //flutterWebviewPlugin.evalJavascript("console.log(myFunction());");
            String script = 'statusMsg("' + userInformation.userDeviceOS + '")';
            //res = '1' already, '0' = new member
            var res = await flutterWebviewPlugin.evalJavascript(script);
            Map valueMap = json.decode(res);

            if (valueMap['status'] == 0) {
              flutterWebviewPlugin.close();

              String url =
                  "http://www.mariners.or.kr/member/joinStep1.php?USER_NAME=${valueMap['name']}&USER_JUMIN=${valueMap['bitrh']}&USER_PHONE=${valueMap['hp']}";

              url = Uri.encodeFull(url);

              if (await canLaunch(url)) {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new SplashScreen()));
                Future.delayed(const Duration(milliseconds: 200), () {
                  launch(url);
                });
              } else {
                throw 'Could not launch $url';
              }
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
              flutterWebviewPlugin.close();

              if (userInformation.userDeviceOS == "i") {
                userInformation.mode =
                    Strings.shared.controllers.signIn.already;
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new Nullpage()));
              } else {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new SplashScreen()));
              }
            } else if (valueMap['status'] == 3) {
              flutterWebviewPlugin.close();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new SplashScreen()));
            } else if (valueMap['status'] == 4) {
              if (userInformation.userDeviceOS == "i") {
                flutterWebviewPlugin.close();
                userInformation.mode = "인증 에러";
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new Nullpage()));
              } else {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new SplashScreen()));
              }
            } else {
              flutterWebviewPlugin.close();
              userInformation.mode = "인증 에러";
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Nullpage()));
            }
          }
        }
      } else if (userInformation.mode == "find_id") {
        if (currentURL ==
            'http://www.mariners.or.kr/member/mobile_checkplus_checkid_success.php') {
          if (state.type == WebViewState.finishLoad) {
            currentURL = ''; //아이폰이 다시 이전 페이지로 돌아오는 경우때문에 url을 초기화 시킴
            await new Future.delayed(const Duration(
                seconds: 1)); //아이폰 바로 진행하면 res값이 null넘어���서 딜레이주고 실행
            String script = 'statusMsg("' + userInformation.userDeviceOS + '")';
            //res = '1' already, '0' = new member7
            var res = await flutterWebviewPlugin.evalJavascript(script);
            Map valueMap = json.decode(res);
            if (valueMap["status"] == 0) {
              flutterWebviewPlugin.close();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new SplashScreen()));
            } else if (valueMap["status"] == 1) {
              flutterWebviewPlugin.close();
              userInformation.userID = valueMap['id'];

              flutterWebviewPlugin.close();
              flutterWebviewPlugin.onDestroy;
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new FindID()));
            } else if (valueMap["status"] == 2) {
              flutterWebviewPlugin.close();
              if (userInformation.userDeviceOS == "i") {
                userInformation.mode =
                    Strings.shared.controllers.signIn.nomember;
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new Nullpage()));
              } else {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new SplashScreen()));
              }
            } else {
              flutterWebviewPlugin.close();

              userInformation.mode = "인증 에러";
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Nullpage()));
            }
          }
        }
      } else if (userInformation.mode == "find_pw") {
        if (currentURL ==
            'http://www.mariners.or.kr/member/mobile_checkplus_checkpw_success.php') {
          if (state.type == WebViewState.finishLoad) {
            currentURL = ''; //아이폰이 다시 이전 페이지로 돌아오는 경우때문에 url을 초기화 시킴
            await new Future.delayed(const Duration(
                seconds: 1)); //아이폰 바로 진행하면 res값이 null넘어와서 딜레이주고 실행
            String script = 'statusMsg("' + userInformation.userDeviceOS + '")';
            //res = '1' already, '0' = new member7
            var res = await flutterWebviewPlugin.evalJavascript(script);
            Map valueMap = json.decode(res);
            if (valueMap["status"] == 0) {
              flutterWebviewPlugin.close();

              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new SplashScreen()));
            } else if (valueMap["status"] == 1) {
              flutterWebviewPlugin.close();

              currentURL = '';
              userInformation.userID = valueMap['id'];
              flutterWebviewPlugin.close();
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new FindPW()));
            } else if (valueMap["status"] == 2) {
              flutterWebviewPlugin.close();

              if (userInformation.userDeviceOS == "i") {
                userInformation.mode =
                    Strings.shared.controllers.signIn.nomember;
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new Nullpage()));
              } else {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new SplashScreen()));
              }
            } else {
              flutterWebviewPlugin.close();

              userInformation.mode = "인증 에러";
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Nullpage()));
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
}
