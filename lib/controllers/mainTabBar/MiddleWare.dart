import 'package:flutter/material.dart';
// Imports Every Menu Controllers
import 'package:haegisa2/controllers/home/Home.dart';
import 'package:haegisa2/controllers/chats/Chats.dart';
import 'package:haegisa2/controllers/notices/Notices.dart';
import 'package:haegisa2/controllers/profile/Profile.dart';
import 'package:haegisa2/controllers/findUser/FindUser.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/chats/ConversationWidget.dart';

class MiddleWare {
  static MiddleWare shared = MiddleWare();
  _MiddleWare() {}

  double screenWidth = 0;
  int currentIndex = 0;
  TabController tabc;
  bool loadStatus = false; //true면 void들 로드하고 false일땐 작업안함
  List<Widget> myTabBarList = [
    Home(),
    FindUser(),
    Chats(),
    Notices(),
    Profile()
  ];

  Widget topBarWidget = Container();
  List<ConversationWidget> conversations = [];
  List<ConversationWidget> searchedConversations = [];
  bool firstInitialize = true;
}
