import 'package:flutter/material.dart';
import 'package:haegisa2/controllers/NoticesList/NoticesListSingle.dart';
import 'package:haegisa2/models/NoticesList/NoticesListObject.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/NoticesListWidget/NoticesListWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoticesList extends StatefulWidget {

  bool isFirstInit = true;
  NoticesList({ Key key }) : super(key: key);
  List<Widget> myList = [];
  List<Widget> noticesList = [];

  @override
  _NoticesListState createState() => _NoticesListState();
}

class _NoticesListState extends State<NoticesList> {

  final _scaffold = GlobalKey<ScaffoldState>();

  void refreshList(int pCurrent,pTotal){
    widget.myList = [];
    double screenWidth = MediaQuery.of(context).size.width;
    Widget topView = Container(child: Stack(
      children: [
        Image.asset("Resources/Images/noticeListHeader.png",width: screenWidth, height: 100,),
      ],
    ), alignment: Alignment.center, height: 100,color: Colors.red,);
    Widget blueSplitter = Container(color: Colors.blue,height: 3,margin: const EdgeInsets.only(left: 16,right: 16, bottom: 10));
    widget.myList.add(topView);
    widget.myList.add(blueSplitter);

    widget.myList.addAll(this.widget.noticesList); // fetch from server

    if(pTotal > pCurrent){
      Widget downloadMoreView = Container(
        child: FlatButton(
          child: Container(
            child: Text(Strings.shared.controllers.magazines.downloadMoreKey,style: TextStyle(color: Statics.shared.colors.mainColor, fontSize: Statics.shared.fontSizes.subTitle, fontWeight: FontWeight.w600)),
            alignment: Alignment.center,
          ),
          onPressed: (){
            // download 5 more magazines ...
            this.download5MoreNotices(page: pCurrent + 1);
          },
          padding: const EdgeInsets.all(0),
        ),
        decoration: BoxDecoration(border: Border.all(width: 2, color: Statics.shared.colors.mainColor)),
        width: screenWidth,
        height: 60,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 20, right: 16, left: 16, bottom: 20),
      );
      widget.myList.add(downloadMoreView);
    }
    setState(() {

    });
  }
  void download5MoreNotices({int page = 1}) async {

    http.get(Statics.shared.urls.noticesList(page: page)
    ).then((val){
      if(val.statusCode == 200){
        print("::::::::::::::::::::: [ Getting NoticesList Start ] :::::::::::::::::::::");
        print("BODY: ${val.body.toString()}");
        var json = jsonDecode(val.body);

        int code = json["code"];
        if(code == 200){
          List<NoticesListObject> myReturnList = [];
          int pTotal = json["totalPageNum"];
          int pCurrent = json["nowPageNum"];
          List<dynamic> rows = json["rows"];

          List<Widget> newList = [];
          rows.forEach((item){

            NoticesListObject object = NoticesListObject(
              subject: item["subject"].toString(),
              no: item["no"],
              content: item["content"].toString(),
              regDate: item["regDate"].toString(),
              writer: item["writer"].toString(),
              fileUrl_1: item["fileUrl_1"].toString(),
              fileUrl_2: item["fileUrl_2"].toString(),
              fileUrl_3: item["fileUrl_3"].toString(),
              fileUrl_4: item["fileUrl_4"].toString(),
              realFileName1: item["realFileName1"].toString(),
              realFileName2: item["realFileName2"].toString(),
              realFileName3: item["realFileName3"].toString(),
              realFileName4: item["realFileName4"].toString(),
              serverFileName_1: item["serverFileName_1"].toString(),
              serverFileName_2: item["serverFileName_2"].toString(),
              serverFileName_3: item["serverFileName_3"].toString(),
              serverFileName_4: item["serverFileName_4"].toString(),
            );
            newList.add(NoticesListWidget(title: item["subject"].toString(),obj: object,onTap: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) => new NoticesListSingle(obj: object)));
            }));
          });
          if(page == 1){
            this.widget.noticesList = newList;
          }else{
            this.widget.noticesList.addAll(newList);
          }
          this.refreshList(pCurrent, pTotal);

        }
        print("::::::::::::::::::::: [ Getting NoticesList End ] :::::::::::::::::::::");
      }else{
        print(":::::::::::::::::: on Getting NoticesList error :: Server Error ::::::::::::::::::");
      }
    }).catchError((error){
      print(":::::::::::::::::: on Getting NoticesList error : ${error.toString()} ::::::::::::::::::");
    });
  }

  @override
  Widget build(BuildContext context) {

    if(widget.isFirstInit){
      download5MoreNotices(page: 1);
      widget.isFirstInit = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(child: Text(Strings.shared.controllers.noticesList.pageTitle, style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.subTitle)),margin: const EdgeInsets.only(left: 8)),
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Color.fromRGBO(0, 0, 0, 1)
        ),
      ),
      body: Container(
        child: ListView(
          children: this.widget.myList,
        ),
        color: Colors.white,
      ), // end Body
      key: _scaffold,
    );
  }
}
