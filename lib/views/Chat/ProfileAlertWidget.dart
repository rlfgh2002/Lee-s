import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';

class ProfileAlertWidget
{
  final double avatarSize = 80;
  static const double avatarTop = 40;

  VoidCallback onPressOk;
  double popUpHeight = 0;
  double popUpWidth = 0;

  String profileName = "";
  String profilePicture = "";
  String profileCaption = "";
  Image avatar;

  ProfileAlertWidget({
    VoidCallback onPressOk,
    double popUpWidth = 0,
    double popUpHeight = 0,

    String profileName = "",
    String profilePicture = "",
    String profileCaption = ""
  }){
    this.onPressOk = onPressOk;
    this.popUpWidth = popUpWidth;
    this.popUpHeight = popUpHeight;
    this.profileName = profileName;
    this.profilePicture = profilePicture;
    this.profileCaption = profileCaption;

    if(this.profilePicture == ""){
      avatar = Image.asset("Resources/Images/userAvatar.png", height: avatarSize, width: avatarSize,);
    }else{
      avatar = Image.network(this.profilePicture,height: avatarSize,width: avatarSize,);
    }
  }

  AlertDialog dialog(){

    String preContent = Strings.shared.dialogs.toVoteKeyword;
    preContent = preContent + " ";
    String content = Strings.shared.dialogs.pleaseJoinUsThankYouKeyword;

    return AlertDialog(
      content: Container(
        child: Column(
          children: [
            Container(
              child: Stack(
                children: [
                  Container(child: Image.asset("Resources/Images/userAlertTop.png"),),
                  Container(
                    child: avatar,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: avatarTop),
                  )
                ],
              ),
            ),
            Container(
              child: Text(this.profileName, style: TextStyle(color: Statics.shared.colors.mainColor,fontWeight: FontWeight.bold, fontSize: Statics.shared.fontSizes.title)),
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.only(left: 50,right: 50),
              width: popUpWidth,
              alignment: Alignment.center,
            ),
            Container(
              child: Text(this.profileCaption,style: TextStyle(color: Statics.shared.colors.subTitleTextColor,fontWeight: FontWeight.normal, fontSize: Statics.shared.fontSizes.subTitleInContent),textAlign: TextAlign.left,),
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(left: 50, right: 50),
              width: popUpWidth,
              alignment: Alignment.center,
            ),
            SizedBox(height: 20),
            Container(
              height: 60,
              width: popUpWidth,
              margin: const EdgeInsets.only(top: 15),
              child: Container(color: Colors.white,
                child: FlatButton(
                  child: Text(Strings.shared.dialogs.closeBtnTitle,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: Statics.shared.fontSizes.subTitleInContent,
                        color: Statics.shared.colors.titleTextColor
                    ),
                  ),
                  onPressed: (){
                    this.onPressOk();
                  },),
                width: (popUpWidth-16) / 2,
              ),
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Statics.shared.colors.lineColor, width: 1))
              ),
            ),
          ], // Column Children
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
        ), // Column
        width: popUpWidth,
        //height: 330,
      ), // Content Container
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

}