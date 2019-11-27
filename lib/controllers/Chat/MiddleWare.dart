import 'package:flutter/material.dart';
import 'package:haegisa2/models/User.dart';

class MiddleWare {
  static MiddleWare shared = MiddleWare();
  _MiddleWare() {}

  List<Widget> messages = [];
  User user = User();
  String conversationID = '';

  bool isFirst = true;
  TextEditingController txtChat;
  double screenWidth = 0;
  Widget topBarWidget = Container();
}
