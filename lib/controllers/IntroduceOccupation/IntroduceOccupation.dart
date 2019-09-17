import 'package:flutter/material.dart';
import 'package:haegisa2/controllers/IntroduceOccupation/IOSingle.dart';
//import 'package:haegisa2/controllers/NoticesList/NoticesListSingle.dart';
import 'package:haegisa2/models/iO/IOObject.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/iO/IOWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IntroduceOccupation extends StatefulWidget {

  bool isFirstInit = true;
  IntroduceOccupation({ Key key }) : super(key: key);
  List<Widget> myList = [];
  List<Widget> introducedList = [];

  @override
  _IntroduceOccupationState createState() => _IntroduceOccupationState();
}

class _IntroduceOccupationState extends State<IntroduceOccupation> {

  final _scaffold = GlobalKey<ScaffoldState>();

  void refreshList(int pCurrent,pTotal){
    widget.myList = [];
    double screenWidth = MediaQuery.of(context).size.width;
    Widget topView = Container(child: Stack(
      children: [
        Image.asset("Resources/Images/bgMagazine.png",width: screenWidth, height: 100,),
        Row(
          children: [
            Padding(child: Column(
              children: [
                Container(child: Text(Strings.shared.controllers.iO.title1,textAlign: TextAlign.left,style: TextStyle(color: Statics.shared.colors.mainColor, fontSize: Statics.shared.fontSizes.subTitle,fontWeight: FontWeight.w800)),width:(screenWidth-64)-80,),
                SizedBox(height: 5),
                Container(child: Text(Strings.shared.controllers.iO.caption1,textAlign: TextAlign.left,style: TextStyle(color: Statics.shared.colors.captionColor, fontSize: Statics.shared.fontSizes.medium)),width: (screenWidth-64)-80,),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
                padding: const EdgeInsets.only(left: 32)
            ),
            Padding(
              child: Image.asset("Resources/Icons/sailorIcon.png", width: 80,),
              padding: const EdgeInsets.only(right: 16, top: 20),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),// Row
      ],
    ), alignment: Alignment.center, height: 100,color: Colors.red,);
    Widget blueSplitter = Container(color: Colors.blue,height: 3,margin: const EdgeInsets.only(left: 16,right: 16, bottom: 10));
    widget.myList.add(topView);
    widget.myList.add(blueSplitter);

    widget.myList.addAll(this.widget.introducedList); // fetch from server

    if(pTotal > pCurrent){
      Widget downloadMoreView = Container(
        child: FlatButton(
          child: Container(
            child: Text(Strings.shared.controllers.magazines.downloadMoreKey,style: TextStyle(color: Statics.shared.colors.mainColor, fontSize: Statics.shared.fontSizes.subTitle, fontWeight: FontWeight.w600)),
            alignment: Alignment.center,
          ),
          onPressed: (){
            // download 5 more magazines ...
            this.download5MoreIO(page: pCurrent + 1);
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
  void download5MoreIO({int page = 1}) async {

    http.get(Statics.shared.urls.iO(page: page)
    ).then((val){
      if(val.statusCode == 200){
        print("::::::::::::::::::::: [ Getting iO Start ] :::::::::::::::::::::");
        print("BODY: ${val.body.toString()}");
        var myJson = json.decode(utf8.decode(val.bodyBytes));

        int code = myJson["code"];
        if(code == 200){
          List<IOObject> myReturnList = [];
          int pTotal = myJson["totalPageNum"];
          int pCurrent = myJson["nowPageNum"];
          List<dynamic> rows = myJson["rows"];

          List<Widget> newList = [];
          rows.forEach((item){

            IOObject object = IOObject(
              name: item["name"].toString(),
              content: item["content"].toString(),
              company: item["company"].toString(),
              shortContent: item["shortContent"].toString(),
              listImgUrl: item["listImgUrl"].toString(),
              viewImgUrl_1: item["viewImgUrl_1"].toString(),
              viewImgUrl_2: item["viewImgUrl_2"].toString(),
            );
            newList.add(IOWidget(obj: object,onTap: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) => new IOSingle(obj: object)));
            }));
          });
          if(page == 1){
            this.widget.introducedList = newList;
          }else{
            this.widget.introducedList.addAll(newList);
          }
          this.refreshList(pCurrent, pTotal);

        }
        print("::::::::::::::::::::: [ Getting iO End ] :::::::::::::::::::::");
      }else{
        print(":::::::::::::::::: on Getting iO error :: Server Error ::::::::::::::::::");
      }
    }).catchError((error){
      print(":::::::::::::::::: on Getting iO error : ${error.toString()} ::::::::::::::::::");
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isFirstInit){
      download5MoreIO(page: 1);
      widget.isFirstInit = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(child: Text(Strings.shared.controllers.iO.pageTitle, style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.subTitle)),margin: const EdgeInsets.only(left: 8)),
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
