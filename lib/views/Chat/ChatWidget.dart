import 'package:flutter/material.dart';
import 'package:haegisa2/models/statics/statics.dart';

class ChatWidget extends StatelessWidget {

  String content = "";
  String time = "";
  String senderName = "";
  bool isYours = false;

  ChatWidget({
  String content = "",
  String time = "",
  String senderName = "",
  bool isYours = false,
  }){
    this.content = content;
    this.time = time;
    this.senderName = senderName;
    this.isYours = isYours;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double chatMaxSize = screenWidth;
    if(!this.isYours){
      return Padding(child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 64, top: 10, left: 32),
            alignment: Alignment.centerLeft,
            constraints: BoxConstraints(minWidth: 20, maxWidth: chatMaxSize),
            child: Row(
              children: [
                Text(this.senderName, style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.subTitleInContent, fontWeight: FontWeight.bold),),
                SizedBox(width: 5),
                Text(this.time, style: TextStyle(color: Statics.shared.colors.subTitleTextColor, fontSize: Statics.shared.fontSizes.small, fontWeight: FontWeight.normal),)
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
          Stack(
            children: [
              Container(
                child: Text(this.content, style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.content),textAlign: TextAlign.start,),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                margin: const EdgeInsets.only(right: 64, top: 5, left: 32),
                padding: const EdgeInsets.all(10),
                constraints: BoxConstraints(minWidth: 20,maxWidth: chatMaxSize)
              ),
              Container(
                child: Image.asset("Resources/Images/leftEdge.png", height: 15,),
                margin: const EdgeInsets.only(left: 15),
              )
            ],
            alignment: Alignment.bottomLeft,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),padding: const EdgeInsets.only(top: 20));
    }// this is not yours
    else{
      return Padding(child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 32, top: 10, left: 64),
            alignment: Alignment.centerRight,
            constraints: BoxConstraints(minWidth: 20, maxWidth: chatMaxSize),
            child: Row(
              children: [
                Text(this.senderName, style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.subTitleInContent, fontWeight: FontWeight.bold),),
                SizedBox(width: 5),
                Text(this.time, style: TextStyle(color: Statics.shared.colors.subTitleTextColor, fontSize: Statics.shared.fontSizes.small, fontWeight: FontWeight.normal),)
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ),
          Stack(
            children: [
              Container(
                child: Text(this.content, style: TextStyle(color: Colors.white, fontSize: Statics.shared.fontSizes.content), textAlign: TextAlign.end,),
                decoration: BoxDecoration(
                  color: Statics.shared.colors.mainColor,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                margin: const EdgeInsets.only(right: 32, top: 5, left: 64),
                padding: const EdgeInsets.all(10),
                //width: screenWidth / 1.5,
                constraints: BoxConstraints(minWidth: 20,maxWidth: chatMaxSize),
              ),
              Container(
                child: Image.asset("Resources/Images/rightEdge.png", height: 15, color: Statics.shared.colors.mainColor,),
                margin: const EdgeInsets.only(right: 15),
              )
            ],
            alignment: Alignment.bottomRight,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
      ),padding: const EdgeInsets.only(top: 20));
    }// this is yours
  }
}
