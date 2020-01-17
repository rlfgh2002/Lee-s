import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'dart:async';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  List<Map<String, String>> installedApps;
  List<Map<String, String>> iOSApps = [
    {"app_name": "Calendar", "package_name": "calshow://"},
    {"app_name": "Facebook", "package_name": "fb://"},
    {"app_name": "기출문제", "package_name": "com.mariners.haegisa2"}
  ];

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getApps() async {
    List<Map<String, String>> _installedApps;

    if (Platform.isAndroid) {
      _installedApps = await AppAvailability.getInstalledApps();

      print(await AppAvailability.checkAvailability("com.android.chrome"));
      // Returns: Map<String, String>{app_name: Chrome, package_name: com.android.chrome, versionCode: null, version_name: 55.0.2883.91}

      print(await AppAvailability.isAppEnabled("com.android.chrome"));
      // Returns: true

    } else if (Platform.isIOS) {
      // iOS doesn't allow to get installed apps.
      _installedApps = iOSApps;

      print(await AppAvailability.checkAvailability("calshow://"));
      // Returns: Map<String, String>{app_name: , package_name: calshow://, versionCode: , version_name: }

    }

    setState(() {
      installedApps = _installedApps;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (installedApps == null) getApps();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          centerTitle: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
        ),
        body: ListView.builder(
          itemCount: installedApps == null ? 0 : installedApps.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(installedApps[index]["app_name"]),
              trailing: IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () {
                    Scaffold.of(context).hideCurrentSnackBar();
                    AppAvailability.launchApp(
                            installedApps[index]["package_name"])
                        .then((_) {
                      print(
                          "App ${installedApps[index]["app_name"]} launched!");
                    }).catchError((err) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "App ${installedApps[index]["app_name"]} not found!")));
                      print(err);
                    });
                  }),
            );
          },
        ),
      ),
    );
  }
}
