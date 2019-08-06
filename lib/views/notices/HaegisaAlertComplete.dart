import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'NoticeWidget.dart';

class HaegisaAlertCompleteDialog
{
  VoidCallback onPressOk;
  double popUpHeight = 0;
  double popUpWidth = 0;
  NoticeType noticeType = NoticeType.Vote;

  HaegisaAlertCompleteDialog({
    VoidCallback onPressOk,
    double popUpWidth = 0,
    double popUpHeight = 0,
    NoticeType noticeType = NoticeType.Vote
  }){
    this.onPressOk = onPressOk;
    this.popUpWidth = popUpWidth;
    this.popUpHeight = popUpHeight;
    this.noticeType = noticeType;
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
              child: RichText(text: TextSpan(children: [
                TextSpan(text: preContent, style: TextStyle(color: Statics.shared.colors.mainColor,fontWeight: FontWeight.bold, fontSize: Statics.shared.fontSizes.titleInContent),),
                TextSpan(text: content, style: TextStyle(color: Statics.shared.colors.titleTextColor,fontWeight: FontWeight.bold, fontSize: Statics.shared.fontSizes.titleInContent)),
              ]),),
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.only(left: 50,right: 50),
              width: popUpWidth,
            ),
            Container(
              child: Text(Strings.shared.dialogs.descriptionUnderCompleteDialog,style: TextStyle(color: Statics.shared.colors.subTitleTextColor,fontWeight: FontWeight.normal, fontSize: Statics.shared.fontSizes.subTitleInContent),textAlign: TextAlign.left,),
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(left: 50, right: 50),
              width: popUpWidth,
            ),
            Container(
              child: Image.asset("Resources/Icons/elections.png",height: 50,),
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
              width: popUpWidth,
              alignment: Alignment.centerRight,
            ),
            //Expanded(child: Container(),),
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