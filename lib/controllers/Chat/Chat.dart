import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/chats/Chats.dart';
import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:haegisa2/models/User.dart';
import 'package:haegisa2/models/myFuncs.dart';
import 'package:haegisa2/views/Chat/ChatWidget.dart';
import 'MiddleWare.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/Chat/BlockReportChatWidget.dart';
import 'package:haegisa2/views/Chat/BlockAlertWidget.dart';
import 'package:haegisa2/views/Chat/ProfileAlertWidget.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:haegisa2/models/DataBase/MyDataBase.dart';
import 'package:shared_preferences/shared_preferences.dart';

String chatCurrentConvId = "";

class Chat extends StatefulWidget {
  static Chat staticChatPage;
  bool isInThisPage;
  bool isFirstInit = true;
  String userId = "";
  final db = MyDataBase();
  //FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String title = "";
  ChatState myChild;

  Chat({String title = "", String conversationId = "", User user}) {
    this.title = title;
    MiddleWare.shared.conversationID = conversationId;
    MiddleWare.shared.user = user;
    if (conversationId != "xxx") {
      chatCurrentConvId = conversationId;
    }
  }

  void refresh() {
    Future.delayed(Duration(seconds: 1)).whenComplete(() {
      print("REFRESH :::::)))))");
      myChild.refreshChats();
    });
  }

  @override
  ChatState createState() {
    return ChatState();
  }
}

class ChatState extends State<Chat> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldKeyBody = GlobalKey<ScaffoldState>();
  var mainContext;
  ScrollController _scrollController;

  void getUserInfo({onComplete(String result)}) async {
    await SharedPreferences.getInstance().then((val) {
      String value = val.getString("app_user_login_info_userid");
      onComplete(value);
    });
  }

  void addMessageToList(
      {String msg, String date, String senderName, bool isYours = false}) {
    setState(() {
      MiddleWare.shared.messages.add(ChatWidget(
        content: msg,
        time: date,
        senderName: senderName,
        isYours: isYours,
      ));
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  void sendChat({String message,String toId = "", onSent(), onNotSent()}) async {
    MainTabBar.myChild.getUserId(onGetUserId: (uid) {
      String y = DateTime.now().year.toString();
      String m = DateTime.now().month.toString();
      String d = DateTime.now().day.toString();

      String h = DateTime.now().hour.toString();
      String i = DateTime.now().minute.toString();
      String s = DateTime.now().second.toString();

      String date =
          "${y.toString()}/${m.toString()}/${d.toString()} ${h.toString()}:${i.toString()}:${s.toString()}";
      String msg = MiddleWare.shared.txtChat.text;

      String usId = MiddleWare.shared.user.UID;
      if(toId != ""){
        usId = toId;
      }
      String chatIdRandom = randomChatId();
      this.widget.db.insertChat(
          convId: chatCurrentConvId,
          userId: MiddleWare.shared.user.UID,
          chatId: chatIdRandom,
          content: msg,
          isYours: "TRUE",
          date: date,
          onAdded: () {
            Chats.staticChatsPage.refresh();
            addMessageToList(
                date: date, isYours: true, msg: msg, senderName: "");
          });
      setState(() {
        MiddleWare.shared.txtChat.text = "";
      });

      http
          .post(Statics.shared.urls.sendChatServer, body: {
            'conversationId': chatCurrentConvId,
            'fromId': uid,
            'toId': usId,
            'message': message,
          })
          .then((val) {})
          .catchError((error) {
            print(
                ":::::::::::::::::: on sending chat error : ${error.toString()} ::::::::::::::::::");
          })
          .whenComplete(() {
            print("::::::::::::::::::::: [ SEND DATA ] :::::::::::::::::::::");
            print("userId: ${uid}");
            print("convId: ${chatCurrentConvId}");
            print("toId: ${usId}");
            print("message: ${message}");
            print("::::::::::::::::::::: [ SEND DATA ] :::::::::::::::::::::");
          });
    });
  }

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 1500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Container bottomChat() {

    String toId = "";
    if (chatCurrentConvId != 'x0x0' && MiddleWare.shared.user.UID != '0') {
      toId = "";
    } else {
      toId = "mariners123";
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 3)
        ],
      ),
      child: TextField(
        autofocus: false,
        maxLines: 4,
        minLines: 1,
        controller: MiddleWare.shared.txtChat,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: Strings.shared.controllers.chat.hintChatTextField,
          fillColor: Color.fromRGBO(244, 248, 255, 1),
          contentPadding:
          const EdgeInsets.only(left: 32, right: 32, top: 15, bottom: 15),
          suffixIcon: IconButton(
            icon: Image.asset(
              "Resources/Icons/icon_send.png",
              height: 20,
              alignment: Alignment.bottomRight,
            ),
            onPressed: () {
              // Send Message ...
              if (MiddleWare.shared.txtChat.text.isNotEmpty) {
                sendChat(
                    message: MiddleWare.shared.txtChat.text,
                    toId:toId,
                    onSent: () {
                      setState(() {
                        MiddleWare.shared.messages.add(ChatWidget(
                          content: MiddleWare.shared.txtChat.text,
                          time: "오후 11:30",
                          senderName: "",
                          isYours: true,
                        ));
                        MiddleWare.shared.txtChat.text = "";
                      });
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    onNotSent: () {
                      _displaySnackBar(
                          mainContext,
                          Strings.shared.controllers.chat
                              .errorWhileSendingChatMessage);
                    }); // send chat Restful API
              } // is Not Empty
            },
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1, color: Color.fromRGBO(241, 244, 250, 1)),
              borderRadius: BorderRadius.all(Radius.circular(100))),
          hintStyle: TextStyle(
              fontSize: Statics.shared.fontSizes.content,
              color: Statics.shared.colors.subTitleTextColor),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100))),
        ),
        style: TextStyle(
          fontSize: Statics.shared.fontSizes.content,
          color: Statics.shared.colors.titleTextColor,
        ),
      ), // chat textfield
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      alignment: Alignment.bottomCenter,
    );
  }

  Container showTopBarTitle() {
    return Container(
      child: Text(this.widget.title,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: Statics.shared.fontSizes.subTitleInContent)),
      margin: const EdgeInsets.only(left: 0),
      padding: const EdgeInsets.only(left: 0),
    );
  }

  void showBlockPopUp() {
    showDialog(
        context: this.mainContext,
        builder: (BuildContext context) {
          return BlockAlertWidget(
              popUpWidth: MiddleWare.shared.screenWidth,
              fullName:
                  "${MiddleWare.shared.user.fullName}\n", // Your User Name
              onPressNo: () {
                Navigator.pop(context);
              },
              onPressYes: () {
                Navigator.pop(context);
                print("USER:))) : ${MiddleWare.shared.user.UID}");
                widget.db.insertBlockUsers(
                    userId: MiddleWare.shared.user.UID,
                    onBlock: (st) {
                      // refresh chats
                      print(
                          "USER ${MiddleWare.shared.user.UID.toString()} BLOCK (${st.toString()})");
                      Chats.staticChatsPage.refresh();
                      Future.delayed(Duration(seconds: 2)).then((val) {
                        Navigator.pop(_scaffoldKey.currentContext);
                      });
                    });
              }).dialog();
        });
  }

  void showProfilePopUp() {
    showDialog(
        context: this.mainContext,
        builder: (BuildContext context) {
          return ProfileAlertWidget(
              popUpWidth: MiddleWare.shared.screenWidth,
              profileCaption: MiddleWare.shared.user.caption,
              profileName: MiddleWare.shared.user.fullName,
              profilePicture: MiddleWare.shared.user.avatar,
              onPressOk: () {
                Navigator.pop(context);
              }).dialog();
        });
  }

  void iOS_Permission() {
    MainTabBar.mainTabBar.mainFirebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    MainTabBar.mainTabBar.mainFirebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    this.widget.isInThisPage = true;
    Chat.staticChatPage = this.widget;
    print("INIT LISTENERS");
    this.getUserInfo(onComplete: (res) {
      print(":::::::::::: [ USERID IS ${res} ] ::::::::::::");
      this.widget.userId = res;
    });

    _scrollController =
        new ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    this.refreshChats();

    if (MiddleWare.shared.conversationID == 'xxx') {
      chatCurrentConvId = this.widget.db.generateRandomNumber(6).toString();
      this.widget.db.checkConversationExist(
          onResult: (result) {
            MiddleWare.shared.conversationID = result["convId"].toString();
            chatCurrentConvId = result["convId"].toString();
          },
          userId: MiddleWare.shared.user.UID,
          onNoResult: () {
            MiddleWare.shared.conversationID = chatCurrentConvId;
            this.widget.db.insertConversation(
                  userId: MiddleWare.shared.user.UID,
                  convId: chatCurrentConvId,
                  createDate: DateTime.now().toString(),
                  fromName: MiddleWare.shared.user.fullName,
                  schoolName: MiddleWare.shared.user.caption,
                  schoolGisu: MiddleWare.shared.user.gisu,
                  onInserted: () {
                    print(
                        ":::::::::: NEW Conversation GENERATED Succesfully ${chatCurrentConvId.toString()} ::::::::::");
                  },
                  onNoInerted: () {
                    print(
                        ":::::::::: NEW Conversation GENERATING FAILURE. ::::::::::");
                  },
                );
          });
    } // new Conversation Id Must be Generate
    else {
      chatCurrentConvId = MiddleWare.shared.conversationID;
    }

    if (chatCurrentConvId != 'x0x0' && MiddleWare.shared.user.UID != '0') {
      SharedPreferences.getInstance().then((prefs) {
        if (prefs.getBool("USER_${chatCurrentConvId}_CHAT_PERMISSION") !=
            true) {
          MiddleWare.shared.messages
              .add(BlockReportChatWidget(onPressBlock: () {
            this.showBlockPopUp();
          }, onPressPermission: () {
            this.hideBlockCell();
          }));
        }
      });
    }

    MiddleWare.shared.txtChat = TextEditingController();

    if (Platform.isIOS) iOS_Permission();
    widget.db.updateSeenChats(convId: chatCurrentConvId);
    if (Chats.staticChatsPage != null) {
      Chats.staticChatsPage.refresh();
    }
    super.initState();
  }

  void hideBlockCell() async {
    await SharedPreferences.getInstance().then((prefs) {
      print("CONVIDD:${chatCurrentConvId.toString()}");
      prefs.setBool("USER_${chatCurrentConvId}_CHAT_PERMISSION", true);
      setState(() {
        MiddleWare.shared.messages.removeAt(0);
      });
    });
  }

  void refreshChats() async {
    setState(() {
      MiddleWare.shared.messages = [];
    });
    this.widget.db.selectChats(
        onResult: (items) {
          for (int i = 0; i < items.length; i++) {
            if (items[i]['isYours'] == 'TRUE') {
              setState(() {
                MiddleWare.shared.messages.add(ChatWidget(
                  content: items[i]['content'],
                  time: items[i]['chatDate'],
                  senderName: "",
                  isYours: true,
                ));
              });
            } else {
              setState(() {
                MiddleWare.shared.messages.add(ChatWidget(
                  content: items[i]['content'],
                  time: items[i]['chatDate'],
                  senderName: MiddleWare.shared.user.fullName,
                  isYours: false,
                ));
              });
            }
          } // loop
          Future.delayed(Duration(milliseconds: 1000)).whenComplete(() {
            _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut);
          });
        },
        convId: chatCurrentConvId);
  }

  @override
  void dispose() {
    MiddleWare.shared.isFirst = true;
    print("CCCCCCC: ${chatCurrentConvId.toString()}");

    print("DISPOSSSSSSSS CHAT PAGE");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));
    this.widget.myChild = this;
    this.mainContext = context;
    if (widget.isFirstInit) {
      MiddleWare.shared.screenWidth = MediaQuery.of(context).size.width;
      MiddleWare.shared.topBarWidget = showTopBarTitle();
      widget.isFirstInit = false;
    }

    List<Widget> myActions = [];
    if (chatCurrentConvId != 'x0x0' && MiddleWare.shared.user.UID != '0') {
      myActions = [
        Padding(
          padding: const EdgeInsets.only(right: 0),
          child: IconButton(
              icon: new Image.asset("Resources/Icons/profile.png", width: 20),
              onPressed: () {
                setState(() {
                  this.showProfilePopUp();
                });
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
              icon: new Image.asset(
                "Resources/Icons/icon_refusal.png",
                width: 20,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  this.showBlockPopUp();
                });
              }),
        )
      ];
    } else {
      myActions = [
        Padding(
          padding: const EdgeInsets.only(right: 0),
          child: IconButton(
              icon: new Image.asset("Resources/Icons/profile.png", width: 22),
              onPressed: () {
                setState(() {
                  this.showProfilePopUp();
                });
              }),
        ),
      ];
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Statics.shared.colors.mainColor,
        brightness: Brightness.light,
        title: MiddleWare.shared.topBarWidget,
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        leading: FlatButton(
          child: Image.asset(
            "Resources/Icons/left-arrow.png",
            height: 22,
            color: Colors.white,
          ),
          onPressed: () {
            this.widget.isInThisPage = false;
            Chat.staticChatPage = null;
            Navigator.pop(context);
          },
          padding: const EdgeInsets.all(0),
        ),
        actions: myActions,
      ),
      body: Container(
        color: Color.fromRGBO(232, 240, 254, 1),
        child: Column(
          children: [
            new Flexible(
              child: Container(
                child: ListView.builder(
                  //reverse: true,
                  itemBuilder: (_, int index) =>
                      MiddleWare.shared.messages[index],
                  itemCount: MiddleWare.shared.messages.length,
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 10, bottom: 40),
                ),
              ), // Child
            ), // Flexible
            bottomChat()
          ],
        ),
      ), // body Container
    );
  }
}
