import 'package:flutter/material.dart';
import 'package:haegisa2/models/statics/statics.dart';

class ConversationWidget extends StatelessWidget {

  double avatarRadius = 30;

  String convId = "";
  String title = "";
  int badges = 0;
  String avatarLink = "";
  String avatarName = "";
  String shortDescription = "";
  String time = "";
  VoidCallback onTapped;
  bool hasBadge = false;
  DateTime lastChatDate = DateTime.now();

  ConversationWidget({DateTime lastChatDate,bool hasBadge = false,String title = "", int badges = 0, String avatarLink = "", String avatarName = "", String shortDescription = "",String time = "", VoidCallback onTapped, String convId = ""}){
    this.lastChatDate = lastChatDate;
    this.title = title;
    this.hasBadge = hasBadge;
    this.badges = badges;
    this.avatarLink = avatarLink;
    this.avatarName = avatarName;
    this.shortDescription = shortDescription;
    this.time = time;
    this.onTapped = onTapped;
    this.convId = convId;
  }

  @override
  Widget build(BuildContext context) {

    double topPadding = 5;
    Widget badge = Container();
    if(this.hasBadge){
      badge = Container(width: 5,height: 5,decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),color: Colors.red),margin: const EdgeInsets.only(top: 20),);
    }else{
      topPadding = 0;
    }

    Color badgeColor = Statics.shared.colors.mainColor;
    badgeColor = Colors.grey;

    var widgetBadge = Container(
      child: Stack(
        children: [
          Container(
              alignment: Alignment(0.9, 0.9),
              child: CircleAvatar(
                child: Container(),
                radius: 7,
                backgroundColor: Colors.white,
              )),
          Container(
              alignment: Alignment(0.85, 0.85),
              child: CircleAvatar(
                child: Container(),
                radius: 5.5,
                backgroundColor: badgeColor,
              )),
        ],
      ),
    );

    //NetworkImage avatar;
    AssetImage avatar;
    if(convId != 'x0x0'){
      if(this.avatarLink != ""){
        //avatar = NetworkImage(this.avatarLink);
        avatar = AssetImage(this.avatarLink);
        this.avatarName = "";
      }else{
        avatar = AssetImage("Resources/Icons/userChatAvatar.png");
        this.avatarName = "";
      }
    }else{
      this.avatarName = "협회";
      this.title = "한국해기사협회";
      badgeColor = Colors.transparent;
      widgetBadge = Container();
    }

//    if (this.hasBlueBadge == false) {
//      badgeColor = Colors.grey;
//    }

    return Container(
      constraints: BoxConstraints(minHeight: 70),
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.only(bottom: 20, top: 20, right: 24, left: 24),
      alignment: Alignment.center,
      child: FlatButton(
        child:
          Container(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Stack(
            children: <Widget>[
              Row(children: [
                Container(child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      child: Center(child: Text(this.avatarName, style: TextStyle(color: Colors.white, fontSize: Statics.shared.fontSizes.subTitleInContent))),
                      radius: this.avatarRadius,
                      backgroundImage: avatar,
                      backgroundColor: Statics.shared.colors.mainColor,
                    ),
                    widgetBadge,
                  ],
                ),width: 55,height: 55),
                SizedBox(width: 10),
                Column(
                  children: [
                    Container(child: Text(this.title,style: TextStyle(fontSize: Statics.shared.fontSizes.content,fontWeight: FontWeight.w600, color: Statics.shared.colors.titleTextColor)),
                      width: MediaQuery.of(context).size.width - 60 - 10 - 48 - 10 - 16 - 45,
                      height: 25,
                    ),
                    SizedBox(height: 5),
                    Container(child: Text(this.shortDescription,overflow: TextOverflow.fade,style: TextStyle(fontSize: Statics.shared.fontSizes.supplementary,fontWeight: FontWeight.w200, color: Statics.shared.colors.subTitleTextColor)),
                      width: MediaQuery.of(context).size.width - 60 - 10 - 120,
                      constraints: BoxConstraints(maxHeight: 40),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.ltr,
                ),
                SizedBox(width: 10),
//            Expanded(child: Container()),
//            Container(child: Column(
//              children: [
//                Text(this.time, style: TextStyle(color: Statics.shared.colors.subTitleTextColor, fontSize: Statics.shared.fontSizes.supplementary),),
//                badge
//              ],
//              crossAxisAlignment: CrossAxisAlignment.end,
//            ), alignment: Alignment.topRight, padding: const EdgeInsets.only(top: 24),)
              ]
              ),
              Container(child: Column(
                children: [
                  Container(child: Text(this.time, style: TextStyle(color: Statics.shared.colors.subTitleTextColor, fontSize: Statics.shared.fontSizes.medium, fontWeight: FontWeight.w300),),
                  padding: const EdgeInsets.only(top: 0),
                  ),
                  badge
                ],
                crossAxisAlignment: CrossAxisAlignment.end,
              ), alignment: Alignment.topRight, padding: EdgeInsets.only(top: topPadding),
              )
            ],
          ),
        ),
        padding: const EdgeInsets.all(0),
        onPressed: (){
          this.onTapped();
        },
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 1,color: Statics.shared.colors.lineColor))
      ),
    );
  }
}
