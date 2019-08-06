import 'package:flutter/material.dart';
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

class Chats extends StatefulWidget {

  static Chats staticChatsPage;

  final db = MyDataBase();
  _ChatsState myChild;

  void refresh(){
    Future.delayed(Duration(seconds: 1)).whenComplete((){
      print("REFRESH :::::)))))");
      myChild.refreshList();
    });
  }

  @override
  _ChatsState createState(){
    return _ChatsState();
  }
}

class _ChatsState extends State<Chats> {

  final TextEditingController txtSearchCtrl = TextEditingController();
  final TextEditingController _textFieldAddUserIdController = TextEditingController();

  _displayAddUserDialog(context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Start a Conversation'),
            content: TextField(
              controller: _textFieldAddUserIdController,
              decoration: InputDecoration(hintText: "Enter a user id"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('CREATE'),
                onPressed: () {
                  addConversation(context);
                },
              )
            ],
          );
        });
  }
  _confirmDisMissDialog(context,String convId, onDeleted()) async {
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
                  removeConversation(context,convId,onDeleted);
                },
              )
            ],
          );
        });
  }

  Row showTopBarTitle(BuildContext context){
    return Row(
      children: [
        Container(child: Text(Strings.shared.controllers.chats.pageTitle, style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.title)),margin: const EdgeInsets.only(left: 8)),
        Row(
          children: <Widget>[
            IconButton(icon: new Image.asset("Resources/Icons/icon_search.png", width: 25),onPressed: (){
              setState(() {
                MiddleWare.shared.topBarWidget = this.showTopSearchBar(context);
              });
            }),
            IconButton(icon: Icon(Icons.add, size: 30,color: Colors.grey,),onPressed: (){
              setState(() {
                _displayAddUserDialog(context);
              });
            })
          ],
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
  Row showTopSearchBar(BuildContext context){
    return Row(
      children: [
        Container(width: MiddleWare.shared.screenWidth - 32 - 32 - 25,
            child:
            TextField(
                decoration: InputDecoration.collapsed(
                    hintText: "Search",
                    hintStyle: TextStyle(color: Statics.shared.colors.subTitleTextColor, fontSize: Statics.shared.fontSizes.content),
                ),
                style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.content),
                controller: txtSearchCtrl,
                onChanged: (String search){
                  if(search.isNotEmpty){
                    setState(() {
                      searchMembers(search);
                      MiddleWare.shared.searchedConversations = MiddleWare.shared.conversations.where((item) => item.title.contains(search)).toList();
                    });
                  }else{
                    setState(() {
                      MiddleWare.shared.searchedConversations = MiddleWare.shared.conversations;
                    });
                  }
                },
            )
        ),
        IconButton(icon: new Image.asset("Resources/Icons/x-mark.png", width: 25),onPressed: (){
          setState(() {
            MiddleWare.shared.topBarWidget = this.showTopBarTitle(context);
          });
        })
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  void addConversation(context){
    if(_textFieldAddUserIdController.text != ""){
      widget.db.insertConversation(convId: widget.db.generateRandomNumber(6),createDate: DateTime.now().toString(),userId: _textFieldAddUserIdController.text,onInserted: (){
        Navigator.of(context).pop();
        refreshList();
      });
    }
  }
  void removeConversation(context,String myConvId,onDelete()){
    widget.db.deleteConversation(convId: myConvId, onDeleted: (st){
      Navigator.of(context).pop();
      refreshList();
      onDelete();
    });
  }
  void refreshList(){
    MiddleWare.shared.conversations = [];
    widget.db.selectConversations(onResult: (items){
      for(int i=0;i<items.length;i++){
        MiddleWare.shared.conversations.add(
            ConversationWidget(
              title: items[i]['otherSideUserName'],
              convId: items[i]['convId'],
              avatarName: "협회",
              badges: 0,
              avatarLink: "",
              shortDescription: items[i]['otherSideUserId'], //반갑습니다.
              time: "오전 9:30",
              onTapped: (){
                String cID = items[i]['convId']; // Conversation ID
                User usr = User(UID: "${items[i]['otherSideUserId']}",fullName: items[i]['otherSideUserName'],avatar: "",caption: "해양대학교 . 60기");
                Navigator.push
                  (context,
                    new MaterialPageRoute(builder: (context) => new Chat(title: items[i]['otherSideUserName'],conversationId: cID,user: usr,))
                );
              },
            )// conversation widget
        );
      }// loop
      setState(() {
        MiddleWare.shared.searchedConversations = MiddleWare.shared.conversations;
      });
    });
  }

  searchMembers(String name) async {
    print("::::::::::::::::::::: [ START SEARCHIG MEMBERS ] :::::::::::::::::::::");
    final response = await http.post(Statics.shared.urls.searchMembers,
        body: {
          'mode':'search',
          'searchName':name,
          'pageNum':'1',
        }
    );

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print("JSON OUTPUT:${response.body.toString()}");
      var parsedJson = json.decode(response.body.toString());
      if(parsedJson['code'] == 200){

        List<SearchMemberObject> searchedItems = [];
        if(parsedJson['rowsCnt'] > 0){
          List<dynamic> rows = parsedJson['rows'];
          for(int i = 0; i < rows.length; i++){
            searchedItems.add(SearchMemberObject.fromJson(rows[i]));
          }// for loop

          setState(() {
            MiddleWare.shared.searchedConversations = [];
            for(int i = 0 ;i < searchedItems.length; i++){
              ConversationWidget obj = ConversationWidget(
                title: searchedItems[i].userName,
                convId: 'xxx',
                avatarName: "협회",
                badges: 0,
                avatarLink: "",
                shortDescription: searchedItems[i].userName,
                time: "오전 9:30",
                onTapped: (){
                  String cID = 'xxx'; // Conversation ID
                  User usr = User(UID: "${searchedItems[i].userId}",fullName: "${searchedItems[i].userName}",avatar: "",caption: "${searchedItems[i].schoolName}");
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new Chat(title: "${searchedItems[i].userName}",conversationId: cID,user: usr,)));
                },
              );
              MiddleWare.shared.searchedConversations.add(obj);
            }// for loop
          });

        }else{
          print("There Are Nothing!");
        }

      }// results
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post Server Error');
    }
  }

  @override
  void initState() {
    Chats.staticChatsPage = this.widget;
    refreshList();
    MainTabBar.myChild.firebaseCloudMessaging_Listeners();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    this.widget.myChild = this;
    MiddleWare.shared.screenWidth = MediaQuery.of(context).size.width;
    if(MiddleWare.shared.firstInitialize){
      MiddleWare.shared.firstInitialize = false;
      MiddleWare.shared.topBarWidget = this.showTopBarTitle(context);
      MiddleWare.shared.searchedConversations = MiddleWare.shared.conversations;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: MiddleWare.shared.topBarWidget,
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Color.fromRGBO(0, 0, 0, 1)
        ),
      ),
      body: Container(color: Color.fromRGBO(244, 248, 255, 1),
        child: ListView.builder(
        itemCount: MiddleWare.shared.searchedConversations.length,
        itemBuilder: (context, index) {
          var result = MiddleWare.shared.searchedConversations[index];
          return Dismissible(
            key: Key(index.toString()),
            child: ListTile(key: Key(index.toString()),title: result),
            onDismissed: (direction){
            },
            confirmDismiss: (bl){
              setState(() {
                _confirmDisMissDialog(context,result.convId,(){
                  MiddleWare.shared.searchedConversations.removeAt(index);
                });
              });
            },

          );
        },
      ),
    ));
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
