import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class HomeWebview extends StatefulWidget {
  @override
  _HomeWebviewState createState() => _HomeWebviewState();
}

class _HomeWebviewState extends State<HomeWebview> {
  // Instance of WebView plugin
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  static String selectedUrl = "";
  String title = "";

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _history = [];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    selectedUrl = Strings.shared.controllers.jsonURL.center;
    title = Strings.shared.controllers.home.cnter;

    //MiddleWare.shared.screenSize = MediaQuery.of(context).size.width;
    return WebviewScaffold(
      url: selectedUrl,
      appBar: AppBar(
        title: Text(title,
            style: TextStyle(
                color: Statics.shared.colors.titleTextColor,
                fontSize: Statics.shared.fontSizes.subTitle,
                fontWeight: FontWeight.bold)),
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
    );
  }

  @override
  void initState() {
    super.initState();

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
