import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/controllers/sign/SignSelect.dart';

class Nullpage extends StatefulWidget {
  String alertMessage;

  @override
  _NullInState createState() => _NullInState();
}

class _NullInState extends State<Nullpage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));
    return Scaffold(
      body: Center(
          child: AlertDialog(
        backgroundColor: Colors.white,
        title: Center(child: Text(userInformation.mode)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new SignSelect()));
                })
          ],
        ),
      )),
    );
  }
}
