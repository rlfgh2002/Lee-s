import 'package:flutter/material.dart';
import 'MiddleWare.dart';
import 'dart:async';
import 'dart:convert';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/controllers/sign/SignSelect.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class Nullpage extends StatefulWidget {
  String alertMessage;

  @override
  _NullInState createState() => _NullInState();
}

class _NullInState extends State<Nullpage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
