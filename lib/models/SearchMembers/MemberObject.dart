import 'package:flutter/material.dart';
import 'package:haegisa2/models/statics/statics.dart';

class MemberObject extends StatelessWidget {

  double avatarRadius = 30;

  String title = "";
  String avatarLink = "";
  String shortDescription = "";
  VoidCallback onTapped;
  bool hasBlueBadge = true;

  MemberObject({String title = "", String avatarLink = "", String shortDescription = "", VoidCallback onTapped,bool hasBlueBadge = true}){
    this.title = title;
    this.avatarLink = avatarLink;
    this.shortDescription = shortDescription;
    this.onTapped = onTapped;
    this.hasBlueBadge = hasBlueBadge;
  }

  @override
  Widget build(BuildContext context) {

    Color badgeColor = Statics.shared.colors.mainColor;
    if(this.hasBlueBadge == false){
      badgeColor = Colors.grey;
    }
    //NetworkImage avatar;
    AssetImage avatar;
    if(this.avatarLink != ""){
      //avatar = NetworkImage(this.avatarLink);
      avatar = AssetImage(this.avatarLink);
    }else{
      avatar = AssetImage("Resources/Icons/userChatAvatar.png");
    }

    return Container(height: 100,margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Statics.shared.colors.lineColor, width: 1),bottom: BorderSide(color: Statics.shared.colors.lineColor, width: 1))
      ),
      child: FlatButton(
        child: Container(padding: const EdgeInsets.only(left: 24, right: 24),
          child: Stack(
            children: <Widget>[
              Row(children: [
                Container(child: Stack(
                  children: [
                    CircleAvatar(
                      child: Container(),
                      radius: this.avatarRadius,
                      backgroundImage: avatar,
                      backgroundColor: Statics.shared.colors.mainColor,
                    ),
                    Container(child: Stack(
                      children: [
                        Container(alignment: Alignment(0.9,0.9),child: CircleAvatar(
                      child: Container(),
                      radius: 7,
                      backgroundColor: Colors.white,
                    )),
                        Container(alignment: Alignment(0.85,0.85),child: CircleAvatar(
                          child: Container(),
                          radius: 5.5,
                          backgroundColor: badgeColor,
                        )),
                      ],
                    ),
                    ),
                  ],
                ),width: 60,height: 60),
                SizedBox(width: 10),
                Column(
                  children: [
                    Container(child: Text(this.title,style: TextStyle(fontSize: Statics.shared.fontSizes.titleInContent, color: Statics.shared.colors.titleTextColor)),
                      width: MediaQuery.of(context).size.width - 60 - 10 - 48 - 10 - 16 - 30,
                      height: 25,
                    ),
                    SizedBox(height: 5),
                    Container(child: Text(this.shortDescription,style: TextStyle(fontSize: Statics.shared.fontSizes.subTitleInContent, color: Statics.shared.colors.subTitleTextColor)),
                      width: MediaQuery.of(context).size.width - 60 - 10 - 48 - 10 - 16 - 30,
                      height: 25,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.ltr,
                ),
                Expanded(child: Container()),
                Container(
                  child: Image.asset("Resources/Icons/chatIcon.png",),
                  width: 27,
                  alignment: Alignment.centerRight,
                ),
              ]
              ),
            ],
          ),
        ),
        padding: const EdgeInsets.all(0),
        onPressed: (){
          this.onTapped();
        },
      ),
    );
  }
}
