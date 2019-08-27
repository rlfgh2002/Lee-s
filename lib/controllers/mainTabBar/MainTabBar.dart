import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haegisa2/controllers/Chat/Chat.dart';
import 'package:haegisa2/controllers/chats/Chats.dart';
import 'package:haegisa2/controllers/notices/Notices.dart';
import 'package:haegisa2/models/Vote/VoteObject.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'MiddleWare.dart';
import 'package:haegisa2/models/DataBase/MyDataBase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:haegisa2/models/Chat/chatObject.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:haegisa2/views/MainTabBar/NoInternetPopUp.dart';
import 'package:geolocator/geolocator.dart';

class MainTabBar extends StatefulWidget {
  final MyDataBase db = MyDataBase();
  FirebaseMessaging mainFirebaseMessaging = FirebaseMessaging();

  Position userLocation;

  StreamSubscription subscription;
  String myUserId = '';
  static MainTabBar mainTabBar;
  static MainTabBarState myChild;
  MiddleWare mdw = MiddleWare.shared;

  @override
  MainTabBarState createState() {
    MainTabBar.mainTabBar = this;
    return MainTabBarState();
  }
}

class MainTabBarState extends State<MainTabBar> with TickerProviderStateMixin {
  static BottomNavigationBar navBar;
  Geolocator geolocator = Geolocator();

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  void getAllSurveys({String uid}) async {
    String url = Statics.shared.urls.searchSurveys(uid);
    await http.get(url).then((val) {
      if (val.statusCode == 200) {
        print("OUTPUT: ${val.body.toString()}");
        Map<String, dynamic> body = json.decode(val.body.trim());
        if (body['code'] == "200") {
          var myList = body['table'];
          for (int i = 0; i < myList.length; i++) {
            widget.db.checkSurveyExist(
                no: myList[i]['no'].toString(),
                onNoResult: () {
                  widget.db.insertSurvey(
                      no: myList[i]['no'].toString(),
                      isDone: 'FALSE',
                      bd_idx: myList[i]['bd_idx'].toString(),
                      start_date: myList[i]['start_date'].toString(),
                      end_date: myList[i]['end_date'].toString(),
                      subject: myList[i]['subject'].toString(),
                      content: myList[i]['contents'].toString(),
                      q_cnt: myList[i]['q_cnt'].toString(),
                      onAdded: () {
                        getSurveysAnswers(
                            uid: uid,
                            idx: myList[i]['bd_idx'].toString(),
                            onSent: (response) {
                              if (response['code'].toString() == "200") {
                                Map<String, dynamic> dataAnswers =
                                    response['table'][0]['q_title'];
                                int qCnt =
                                    int.parse(myList[i]['q_cnt'].toString());

                                for (int j = 0; j < qCnt; j++) {
                                  String qStr = "q${(j + 1).toString()}";
                                  var qItems = dataAnswers['${qStr}_item'];
                                  int qItemsCount = qItems.length;

                                  String ans1 = "";
                                  String ans2 = "";
                                  String ans3 = "";
                                  String ans4 = "";
                                  String ans5 = "";
                                  String ans6 = "";
                                  String ans7 = "";
                                  String ans8 = "";

                                  for (int z = 0; z < qItemsCount; z++) {
                                    if (z == 0) {
                                      ans1 = qItems[
                                          "${qStr.toString()}_${(z + 1).toString()}"];
                                    }
                                    if (z == 1) {
                                      ans2 = qItems[
                                          "${qStr.toString()}_${(z + 1).toString()}"];
                                    }
                                    if (z == 2) {
                                      ans3 = qItems[
                                          "${qStr.toString()}_${(z + 1).toString()}"];
                                    }
                                    if (z == 3) {
                                      ans4 = qItems[
                                          "${qStr.toString()}_${(z + 1).toString()}"];
                                    }
                                    if (z == 4) {
                                      ans5 = qItems[
                                          "${qStr.toString()}_${(z + 1).toString()}"];
                                    }
                                    if (z == 5) {
                                      ans6 = qItems[
                                          "${qStr.toString()}_${(z + 1).toString()}"];
                                    }
                                    if (z == 6) {
                                      ans7 = qItems[
                                          "${qStr.toString()}_${(z + 1).toString()}"];
                                    }
                                    if (z == 7) {
                                      ans8 = qItems[
                                          "${qStr.toString()}_${(z + 1).toString()}"];
                                    }
                                  } // for loop 2

                                  print(
                                      "**************************************************");
                                  print("ANS 1 : ${ans1}");
                                  print("ANS 2 : ${ans2}");
                                  print("ANS 3 : ${ans3}");
                                  print("ANS 4 : ${ans4}");
                                  print("ANS 5 : ${ans5}");
                                  print("ANS 6 : ${ans6}");
                                  print("ANS 7 : ${ans7}");
                                  print("ANS 8 : ${ans8}");
                                  print(
                                      "q Title : ${dataAnswers['q${(j + 1).toString()}'].toString()}");
                                  print("QN : ${(j + 1).toString()}");
                                  print(
                                      "**************************************************");

                                  widget.db.insertSurveyAnswer(
                                      idx: myList[i]['bd_idx'].toString(),
                                      qTitle:
                                          dataAnswers['q${(j + 1).toString()}']
                                              .toString(),
                                      qN: (j + 1).toString(),
                                      answer1: ans1,
                                      answer2: ans2,
                                      answer3: ans3,
                                      answer4: ans4,
                                      answer5: ans5,
                                      answer6: ans6,
                                      answer7: ans7,
                                      answer8: ans8,
                                      cnt: qCnt.toString(),
                                      onAdded: () {
                                        print("ADDDEDDDD TOOO SANS");
                                        if (Notices.staticNoticesPage != null &&
                                            Notices.staticNoticesPage.myChild !=
                                                null) {
                                          Notices.staticNoticesPage.myChild
                                              .refreshNotices();
                                        }
                                      });
                                } // for loop
                              }
                            });
                      });
                },
                onResult: (items) {});
          }
        }
      }
    }).catchError((error) {
      print(
          ":::::::::::::::::: on getting Survey error : ${error.toString()} ::::::::::::::::::");
    });
  }

  void getSurveysAnswers(
      {onSent(Map<String, dynamic> jj), String uid, String idx}) async {
    var url = Statics.shared.urls.searchSurveysAnswers(uid, idx);
    await http.get(url).then((val) {
      if (val.statusCode == 200) {
        print("OUTPUT: ${val.body.toString()}");
        var j = jsonDecode(val.body);
        print("OUTPUT JSON: ${j.toString()}");
        onSent(j);
      }
    }).catchError((error) {
      print(
          ":::::::::::::::::: on getting Surevey Answers error : ${error.toString()} ::::::::::::::::::");
    }).whenComplete(() {
      print(
          "::::::::::::::::::::: [ SEND URL SURVEY ANSWERS ] :::::::::::::::::::::");
      print("URL: ${url.toString()}");
      print(
          "::::::::::::::::::::: [ SEND URL SURVEY ANSWERS ] :::::::::::::::::::::");
    });
  }

  void getVoteAnswers({String url, onSent(Map<String, dynamic> jj)}) async {
    await http.get(url).then((val) {
      if (val.statusCode == 200) {
        print("OUTPUT: ${val.body.toString()}");
        var j = jsonDecode(val.body);
        print("OUTPUT JSON: ${j.toString()}");
        onSent(j);
      }
    }).catchError((error) {
      print(
          ":::::::::::::::::: on getting Vote Answers error : ${error.toString()} ::::::::::::::::::");
    }).whenComplete(() {
      print("::::::::::::::::::::: [ SEND URL VOTE ] :::::::::::::::::::::");
      print("URL: ${url.toString()}");
      print("::::::::::::::::::::: [ SEND URL VOTE ] :::::::::::::::::::::");
    });
  }

  void firebaseCloudMessaging_Listeners() async {
    print(
        "::::::::::::::::::::::::: [ Firebase Listening ] :::::::::::::::::::::::::");

    if (Platform.isIOS) iOS_Permission();

    widget.mainFirebaseMessaging.getToken().then((token) {
      print(token);
    });

    widget.mainFirebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message Main $message');
        analiseMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        analiseMessage(message);

        if (message['data']['notificationType'].toString() == "chat") {
          setState(() {
            MiddleWare.shared.tabc.animateTo(2);
            Chats.staticChatsPage.myChild.openChat(
                message['data']['conversationId'],
                message['data']['fromId'],
                message['data']['fromName']);
          });
        } else {
          setState(() {
            MiddleWare.shared.tabc.animateTo(3);
            Notices.staticNoticesPage.myChild
                .openNotice(message['data']['idx']);
          });
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        analiseMessage(message);

        if (message['data']['notificationType'].toString() == "chat") {
          setState(() {
            MiddleWare.shared.tabc.animateTo(2);
            Chats.staticChatsPage.myChild.openChat(
                message['data']['conversationId'],
                message['data']['fromId'],
                message['data']['fromName']);
          });
        } else {
          setState(() {
            MiddleWare.shared.tabc.animateTo(3);
            Notices.staticNoticesPage.myChild
                .openNotice(message['data']['idx']);
          });
        }
      },
    );
  }

  void iOS_Permission() {
    widget.mainFirebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    widget.mainFirebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void analiseMessage(Map<String, dynamic> message) {
    ChatObject chatItem = ChatObject.fromJson(message);
    if (message['data']['notificationType'].toString() == "chat") {
      widget.db.checkConversationExist(
          userId: chatItem.notificationFromId,
          convId: chatItem.notificationConversationId,
          onResult: (res) {
            widget.db.insertChat(
                convId: chatItem.notificationConversationId,
                userId: chatItem.notificationFromId,
                content: chatItem.notificationContent,
                date: chatItem.notificationRegDate,
                isYours: "FALSE",
                onAdded: () {
                  if (Chats.staticChatsPage != null) {
                    Chats.staticChatsPage.refresh();
                  }

                  if (Chat.staticChatPage != null) {
                    if (Chat.staticChatPage.isInThisPage == true) {
                      Chat.staticChatPage.myChild.addMessageToList(
                          msg: chatItem.notificationContent,
                          isYours: false,
                          date: chatItem.notificationRegDate,
                          senderName: chatItem.notificationFromName);
                    }
                  }
                });
          },
          onNoResult: () {
            widget.db.insertConversation(
                userId: chatItem.notificationFromId,
                convId: chatItem.notificationConversationId,
                createDate: chatItem.notificationRegDate,
                fromName: chatItem.notificationFromName,
                onInserted: () {
                  print(
                      ":::::::::::::::::: [new conversation added] ::::::::::::::::::");
                  widget.db.insertChat(
                      convId: chatItem.notificationConversationId,
                      userId: chatItem.notificationFromId,
                      content: chatItem.notificationContent,
                      date: chatItem.notificationRegDate,
                      isYours: "FALSE",
                      onAdded: () {
                        if (Chats.staticChatsPage != null) {
                          Chats.staticChatsPage.refresh();
                        }
                        if (Chat.staticChatPage != null) {
                          if (Chat.staticChatPage.isInThisPage == true) {
                            Chat.staticChatPage.myChild.addMessageToList(
                                msg: chatItem.notificationContent,
                                isYours: false,
                                date: chatItem.notificationRegDate,
                                senderName: chatItem.notificationFromName);
                          }
                        }
                      });
                },
                onNoInerted: () {
                  print(
                      ":::::::::::::::::: [new conversation not added !] ::::::::::::::::::");
                });
          });
      // chat notification
    } else {
      if (message['data']['notificationType'].toString() == "vote") {
        // vote notification
        VoteObject voteItem = VoteObject.fromJson(message);

        widget.db.checkVoteExist(
            bd_idx: voteItem.idx,
            onRes: () {
              print(
                  ":::::::::: DB INSERT(vote) Error Because this Vote ALready Exist ::::::::::");
            },
            onNoResult: () {
              widget.db.insertVote(
                  voteItem: voteItem,
                  onAdded: () {
                    String url =
                        "${voteItem.httpPath.toString()}&userId=${this.widget.myUserId}&mode=view";
                    url = url.replaceAll("https://", "http://");
                    getVoteAnswers(
                        url: url,
                        onSent: (response) {
                          widget.db.insertAnswer(
                            onAdded: () {
                              if (Notices.staticNoticesPage != null) {
                                Notices.staticNoticesPage.myChild
                                    .refreshNotices();
                              }
                            },
                            idx: voteItem.idx,
                            status: response['data']['status'].toString(),
                            answer1: response['data']['a1'].toString(),
                            answer2: response['data']['a2'].toString(),
                            answer3: response['data']['a3'].toString(),
                            answer4: response['data']['a4'].toString(),
                            answer5: response['data']['a5'].toString(),
                            answer6: response['data']['a6'].toString(),
                          );
                        });
                  });
            });
      } // Vote Notification
    }
  }

  void getUserId({onGetUserId(String userId)}) async {
    await SharedPreferences.getInstance().then((val) {
      String uid = val.getString("app_user_login_info_userid");
      this.widget.myUserId = uid;
      onGetUserId(uid);
    });
  }

  @override
  void initState() {
    MainTabBar.myChild = this;
    MiddleWare.shared.tabc = TabController(
        length: MiddleWare.shared.myTabBarList.length, vsync: this);

    getUserId(onGetUserId: (uid) {
      getAllSurveys(uid: uid);
    });
    firebaseCloudMessaging_Listeners();
    print("Main TabBar New...");

    widget.subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result.index != 0) {
        // no internet connected
        showNoInternet(context);
      }
    });

    this.updateUserLocation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    widget.subscription.cancel();
  }

  void updateUserLocation() async {
    print("...::: updating user location... :::...");
    geolocator.isLocationServiceEnabled().then((val) {
      if (val) {
        geolocator.checkGeolocationPermissionStatus().then((val) {
          if (val.value == 2) {
            geolocator
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
                .then((val) {
              this.widget.userLocation = val;
              if ((val.longitude >= 125.758758 &&
                      val.longitude <= 129.691407) &&
                  (val.latitude >= 34.385830 && val.latitude <= 38.627163)) {
                print("...::: the user is inside of korea. :-) :::...");
              } else {
                print("... ::: the user is not inside of korea! :-( :::...");
              }
            }).catchError((error) {
              print(
                  "...::: updating user location was failed => ${error.toString()} :::...");
            });
          } else {
            print(
                "...::: updating user location was failed => (access to GPS failed) :::...");
          }
        });
      } else {
        print(
            "...::: updating user location was failed => (GPS Service was disabled) :::...");
      }
    });
  }

  void clickToChangeMenu(index) {
    setState(() {
      MiddleWare.shared.currentIndex = index;
      MiddleWare.shared.tabc.animateTo(index);
    });
  }

  void checkInternet(BuildContext ctx) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      showNoInternet(ctx);
    }
  }

  void showNoInternet(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return NoInternetAlertWidget(
            popUpWidth: MiddleWare.shared.screenWidth,
            onPressClose: () {
              Navigator.pop(context);
            },
          ).dialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    MainTabBarState.navBar = BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: new Image.asset("Resources/Icons/btn_main.png", width: 25),
            activeIcon:
                new Image.asset("Resources/Icons/btn_main_ac.png", width: 25),
            title: Text("")),
        BottomNavigationBarItem(
            icon:
                new Image.asset("Resources/Icons/btn_finduser.png", width: 50),
            activeIcon: new Image.asset("Resources/Icons/btn_finduser_ac.png",
                width: 50),
            title: Text("")),
        BottomNavigationBarItem(
            icon: new Image.asset("Resources/Icons/btn_chat.png", width: 25),
            activeIcon:
                new Image.asset("Resources/Icons/btn_chat_ac.png", width: 25),
            title: Text("")),
        BottomNavigationBarItem(
            icon: new Image.asset("Resources/Icons/btn_notice.png", width: 25),
            activeIcon:
                new Image.asset("Resources/Icons/btn_notice_ac.png", width: 25),
            title: Text("")),
        BottomNavigationBarItem(
            icon: new Image.asset("Resources/Icons/btn_mymenu.png", width: 40),
            activeIcon:
                new Image.asset("Resources/Icons/btn_mymenu_ac.png", width: 40),
            title: Text("")),
      ],
      backgroundColor: Color.fromRGBO(252, 252, 252, 1),
      fixedColor: Colors.black,
      unselectedItemColor: Colors.grey,
      currentIndex: MiddleWare.shared.currentIndex,
      showSelectedLabels: false,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      onTap: (index) {
        clickToChangeMenu(index);
      },
    );
    MiddleWare.shared.screenWidth = MediaQuery.of(context).size.width;

    checkInternet(context);

    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(
          children: MiddleWare.shared.myTabBarList,
          controller: MiddleWare.shared.tabc,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: MainTabBarState.navBar,
      ),
    );
  }
}
