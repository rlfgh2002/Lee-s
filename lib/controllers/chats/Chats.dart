import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:haegisa2/controllers/mainTabBar/MiddleWare.dart';
import 'package:haegisa2/models/SearchMembers/SearchMemberObject.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/chats/ConversationWidget.dart';
import 'package:haegisa2/controllers/Chat/Chat.dart';
import 'package:haegisa2/models/User.dart';
import 'package:haegisa2/models/DataBase/MyDataBase.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Chats extends StatefulWidget {
  static Chats staticChatsPage;

  final db = MyDataBase();
  _ChatsState myChild;

  void refresh() {
    Future.delayed(Duration(seconds: 1)).whenComplete(() {
      print("REFRESH :::::)))))");
      myChild.refreshList();
    });
  }

  @override
  _ChatsState createState() {
    return _ChatsState();
  }
}

class _ChatsState extends State<Chats> {
  BuildContext myCurrentContext;

  bool isSearched = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController txtSearchCtrl = TextEditingController();
  final TextEditingController _textFieldAddUserIdController =
      TextEditingController();

//  _displayAddUserDialog() async {
//    return showDialog(
//        context: _scaffoldKey.currentContext,
//        builder: (context) {
//          return AlertDialog(
//            title: Text('Start a Conversation'),
//            content: TextField(
//              controller: _textFieldAddUserIdController,
//              decoration: InputDecoration(hintText: "Enter a user id"),
//            ),
//            actions: <Widget>[
//              new FlatButton(
//                child: new Text('CANCEL'),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
//              new FlatButton(
//                child: new Text('CREATE'),
//                onPressed: () {
//                  addConversation(context);
//                },
//              )
//            ],
//          );
//        });
//  }

  _confirmDisMissDialog(context, String convId, onDeleted()) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Dismiss Conversation'),
            content: Text("Are you sure to dismiss this conversation ?"),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Yes'),
                onPressed: () {
                  removeConversation(context, convId, onDeleted);
                },
              )
            ],
          );
        });
  }

  Row showTopBarTitle() {
    return Row(
      children: [
        Container(
            child: Text(Strings.shared.controllers.chats.pageTitle,
                style: TextStyle(
                    color: Statics.shared.colors.titleTextColor,
                    fontSize: Statics.shared.fontSizes.title)),
            margin: const EdgeInsets.only(left: 8)),
        Row(
          children: <Widget>[
            IconButton(
                icon: new Image.asset("Resources/Icons/icon_search.png",
                    width: 25),
                onPressed: () {
                  setState(() {
                    this.isSearched = true;
                    MiddleWare.shared.topBarWidget = this.showTopSearchBar();
                  });
                }),
//            IconButton(
//                icon: Icon(
//                  Icons.add,
//                  size: 30,
//                  color: Colors.grey,
//                ),
//                onPressed: () {
//                  setState(() {
//                    _displayAddUserDialog();
//                  });
//                })
          ],
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  Row showTopSearchBar() {
    return Row(
      children: [
        Container(
            width: MiddleWare.shared.screenWidth - 32 - 32 - 25,
            child: TextField(
              decoration: InputDecoration.collapsed(
                hintText: "채팅방, 대화내용 검색",
                hintStyle: TextStyle(
                    color: Statics.shared.colors.subTitleTextColor,
                    fontSize: Statics.shared.fontSizes.content),
              ),
              style: TextStyle(
                  color: Statics.shared.colors.titleTextColor,
                  fontSize: Statics.shared.fontSizes.content),
              controller: txtSearchCtrl,
              onSubmitted: (String search) {
                if (search.isNotEmpty) {
                  setState(() {
                    searchMembers(search);
                    MiddleWare.shared.searchedConversations = MiddleWare
                        .shared.conversations
                        .where((item) => item.title.contains(search))
                        .toList();
                  });
                } else {
                  setState(() {
                    MiddleWare.shared.searchedConversations =
                        MiddleWare.shared.conversations;
                  });
                }
              },
            )),
        IconButton(
            icon: new Image.asset("Resources/Icons/x-mark.png", width: 25),
            onPressed: () {
              setState(() {
                this.isSearched = false;
                MiddleWare.shared.topBarWidget = this.showTopBarTitle();
              });
              refreshList();
            })
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  void addConversation(context) {
    if (_textFieldAddUserIdController.text != "") {
      widget.db.insertConversation(
          convId: widget.db.generateRandomNumber(6),
          createDate: DateTime.now().toString(),
          userId: _textFieldAddUserIdController.text,
          fromName: _textFieldAddUserIdController.text,
          schoolName: "",
          onNoInerted: () {
            print("NOT INSERTED !!!");
          },
          onInserted: () {
            Navigator.of(context).pop();
            refreshList();
          });
    }
  }

  void removeConversation(context, String myConvId, onDelete()) {
    widget.db.deleteConversation(
        convId: myConvId,
        onDeleted: (st) {
          Navigator.of(context).pop();
          refreshList();
          onDelete();
        });
  }

  void refreshList() async {
    await SharedPreferences.getInstance().then((val) {
      if (val.get("HAD_FIRST_WELCOME_MSG") != true) {
        // welcome message
        widget.db.firstWelcomeMessage(whenComplete: () {
          val.setBool("HAD_FIRST_WELCOME_MSG", true).then((val) {
            this.refreshList();
          });
        });
      } else {
        // else 2
        print("REFRESHING MY LIST CONVERSATIONS.....");
        MiddleWare.shared.conversations = [];
        widget.db.selectConversations(onResult: (items) {
          for (int i = 0; i < items.length; i++) {
            widget.db.checkUsersBlock(
                userId: "${items[i]['otherSideUserId']}",
                isBlocked: (st) {
                  if (st == false) {
                    widget.db.selectLastChatContent(
                        onResult: (itemContent) {
                          bool hasBadge = false;
                          String contentX = "";
                          DateTime lastChatDate = DateTime.now();
                          String chosenTime = "오전 9:30";

                          if (itemContent != null) {
                            if (itemContent["chatDate2"].contains("-")) {
                              var splited = itemContent["chatDate2"].split(" ");
                              var dateSpt = splited[0].split("-");
                              var timeSpt = splited[1].split(":");
                              lastChatDate = new DateTime(
                                  int.parse(dateSpt[0]),
                                  int.parse(dateSpt[1]),
                                  int.parse(dateSpt[2]),
                                  int.parse(timeSpt[0]),
                                  int.parse(timeSpt[1]));
                            }

                            hasBadge = false;
                            if (itemContent["seen"] == "0") {
                              hasBadge = true;
                            } else {
                              hasBadge = false;
                            }

                            if (itemContent != null) {
                              contentX = itemContent["content"].toString();

                              if (itemContent['chatDate2'] != null) {
                                if (itemContent['chatDate2'].toString() != "") {
                                  chosenTime =
                                      itemContent['chatDate2'].toString();
                                }
                              }
                            }

                            //itemContent != null
                          } else {
                            hasBadge = false;
                            contentX = "";
                            //itemContent is null
                          }

                          String avatarLink = "";
                          String avatarName = "";
                          if (items[i]['convId'] == "x0x0" &&
                              items[i]['otherSideUserId'] == "0") {
                            avatarLink = "";
                            avatarName = "협회";
                          } else {
                            avatarLink = "Resources/Icons/userChatAvatar.png";
                            avatarName = "";
                          }

                          MiddleWare.shared.conversations
                              .add(ConversationWidget(
                            hasBadge: hasBadge,
                            title: items[i]['otherSideUserName'],
                            convId: items[i]['convId'],
                            avatarName: avatarName,
                            badges: 0,
                            avatarLink: avatarLink,
                            shortDescription: "${contentX.toString()}", //반갑습니다.
                            time: chosenTime,
                            lastChatDate: lastChatDate,
                            onTapped: () {
                              this.openChat(
                                  convId: items[i]['convId'],
                                  uId: "${items[i]['otherSideUserId']}",
                                  uName: items[i]['otherSideUserName'],
                                  withDuration: false);
                            },
                          ) // conversation widget
                                  );

                          setState(() {
                            MiddleWare.shared.searchedConversations =
                                MiddleWare.shared.conversations;
                          });
                        },
                        convId: items[i]['convId']);
                  } // ! blocked
                });
          } // loop

          setState(() {
            MiddleWare.shared.searchedConversations =
                MiddleWare.shared.conversations;
          });
        });
      } // else 2
    });
  }

  searchMembers(String name) async {
    print(
        "::::::::::::::::::::: [ START SEARCHING MEMBERS ] :::::::::::::::::::::");
    final response = await http.post(Statics.shared.urls.searchMembers, body: {
      'mode': 'search',
      'searchName': name,
      'pageNum': '1',
    });

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print("JSON OUTPUT:${response.body.toString()}");
      final String responseBody = utf8.decode(response.bodyBytes);
      var parsedJson = json.decode(responseBody.toString());
      if (parsedJson['code'] == 200) {
        List<SearchMemberObject> searchedItems = [];
        if (parsedJson['rowsCnt'] > 0) {
          List<dynamic> rows = parsedJson['rows'];
          for (int i = 0; i < rows.length; i++) {
            searchedItems.add(SearchMemberObject.fromJson(rows[i]));
          } // for loop

          setState(() {
            MiddleWare.shared.searchedConversations = [];
            for (int i = 0; i < searchedItems.length; i++) {
              this.widget.db.checkConversationExistByUser(
                  userId: searchedItems[i].userId,
                  onResult: (res) {
                    String chosenTime = "오전 9:30";

                    ConversationWidget obj = ConversationWidget(
                      title: searchedItems[i].userName,
                      convId: res["convId"],
                      avatarName: "협회",
                      badges: 0,
                      avatarLink: "",
                      shortDescription: searchedItems[i].userName,
                      time: chosenTime,
                      onTapped: () {
                        String cID = res['convId']; // Conversation ID
                        User usr = User(
                            UID: "${searchedItems[i].userId}",
                            fullName: "${searchedItems[i].userName}",
                            avatar: "",
                            caption: "${searchedItems[i].schoolName}");
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new Chat(
                                      title: "${searchedItems[i].userName}",
                                      conversationId: cID,
                                      user: usr,
                                    )));
                      },
                    );
                    MiddleWare.shared.searchedConversations.add(obj);
                  },
                  onNoResult: () {
                    ConversationWidget obj = ConversationWidget(
                      title: searchedItems[i].userName,
                      convId: 'xxx',
                      avatarName: "협회",
                      badges: 0,
                      avatarLink: "",
                      shortDescription: searchedItems[i].userName,
                      time: "오전 9:30",
                      onTapped: () {
                        String cID = 'xxx'; // Conversation ID
                        User usr = User(
                            UID: "${searchedItems[i].userId}",
                            fullName: "${searchedItems[i].userName}",
                            avatar: "",
                            caption: "${searchedItems[i].schoolName}");
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new Chat(
                                      title: "${searchedItems[i].userName}",
                                      conversationId: cID,
                                      user: usr,
                                    )));
                      },
                    );
                    MiddleWare.shared.searchedConversations.add(obj);
                  });
            } // for loop
          });
        } else {
          print("There Are Nothing!");
        }
      } // results
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post Server Error');
    }
  }

  @override
  void initState() {
    Chats.staticChatsPage = this.widget;
    this.widget.myChild = this;
    refreshList();
    super.initState();
  }

  void openChat(
      {String convId, String uId, String uName, bool withDuration = false}) {
    if (withDuration == true) {
      Future.delayed(Duration(seconds: 1)).then((val) {
        String cID = convId; // Conversation ID
        User usr =
            User(UID: uId, fullName: uName, avatar: "", caption: "해양대학교 . 60기");
        Navigator.push(
            _scaffoldKey.currentContext,
            new MaterialPageRoute(
                builder: (context) => new Chat(
                      title: uName,
                      conversationId: cID,
                      user: usr,
                    )));
      });
    } else {
      String cID = convId; // Conversation ID
      User usr =
          User(UID: uId, fullName: uName, avatar: "", caption: "해양대학교 . 60기");
      Navigator.push(
          _scaffoldKey.currentContext,
          new MaterialPageRoute(
              builder: (context) => new Chat(
                    title: uName,
                    conversationId: cID,
                    user: usr,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    this.myCurrentContext = context;
    this.widget.myChild = this;
    MiddleWare.shared.screenWidth = MediaQuery.of(context).size.width;
    if (MiddleWare.shared.firstInitialize) {
      MiddleWare.shared.firstInitialize = false;
      MiddleWare.shared.conversations.sort((item1, item2) =>
          DateTime.parse(item2.time).compareTo(DateTime.parse(item1.time)));
      MiddleWare.shared.searchedConversations = MiddleWare.shared.conversations;
    }
    if (isSearched) {
      MiddleWare.shared.topBarWidget = this.showTopSearchBar();
    } else {
      MiddleWare.shared.topBarWidget = this.showTopBarTitle();
    }

    MiddleWare.shared.searchedConversations
        .sort((a, b) => b.lastChatDate.compareTo(a.lastChatDate));

    Widget notFoundView = Container(
      child: Column(
        children: <Widget>[
          Image.asset("Resources/Icons/wondeIconr.png", width: 60),
          SizedBox(height: 20),
          Text(Strings.shared.controllers.findUser.notFound,
              style: TextStyle(
                  fontSize: Statics.shared.fontSizes.content,
                  color: Statics.shared.colors.captionColor)),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 120),
    );

    Widget dataShow = ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: MiddleWare.shared.searchedConversations.length,
      itemBuilder: (context, index) {
        var result = MiddleWare.shared.searchedConversations[index];
        return Dismissible(
          key: Key(index.toString()),
          child: ListTile(
            key: Key(index.toString()),
            title: result,
            contentPadding: const EdgeInsets.all(0),
          ),
          onDismissed: (direction) {},
          confirmDismiss: (bl) {
            setState(() {
              _confirmDisMissDialog(context, result.convId, () {
                MiddleWare.shared.searchedConversations.removeAt(index);
              });
            });
          },
        );
      },
    );
    if (MiddleWare.shared.searchedConversations.length <= 0) {
      dataShow = notFoundView;
    }

    return new Builder(builder: (context) {
      return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          title: MiddleWare.shared.topBarWidget,
          centerTitle: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 20, right: 0, left: 0),
          margin: const EdgeInsets.all(0),
          child: dataShow,
        ),
      );
    });
  }
}

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//////////////////////////////// SAMPLES ///////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//
//ConversationWidget(
//title: "한국해기사협회",
//avatarName: "협회",
//badges: 0,
//avatarLink: "",
//shortDescription: "반갑습니다.",
//time: "오전 9:30",
//onTapped: (){
//String cID = "123456789"; // Conversation ID
//User usr = User(UID: "1",fullName: "강승완",avatar: "",caption: "해양대학교 . 60기");
//Navigator.push(context, new MaterialPageRoute(builder: (context) => new Chat(title: "한국해기사협회",conversationId: cID,user: usr,)));
//},
//)// conversation widget
//
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//////////////////////////////// SAMPLES ///////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
