import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';

class BlockAlertWidget
{
  VoidCallback onPressYes;
  VoidCallback onPressNo;
  double popUpHeight = 0;
  double popUpWidth = 0;
  String fullName = "";

  BlockAlertWidget({
    VoidCallback onPressYes,
    VoidCallback onPressNo,
    double popUpWidth = 0,
    double popUpHeight = 0,
    String fullName = "",
  }){
    this.onPressNo = onPressNo;
    this.onPressYes = onPressYes;
    this.popUpWidth = popUpWidth;
    this.popUpHeight = popUpHeight;
    this.fullName = fullName;
  }

  AlertDialog dialog(){

    String preContent = Strings.shared.dialogs.wouldYouLikeToBlockPart1Red;
    String content = Strings.shared.dialogs.wouldYouLikeToBlockPart2;

    return AlertDialog(
      content: Container(
        child: Column(
          children: [
            Container(
              child: RichText(text: TextSpan(children: [
                TextSpan(text: this.fullName, style: TextStyle(color: Statics.shared.colors.titleTextColor,fontWeight: FontWeight.bold, fontSize: Statics.shared.fontSizes.titleInContent)),
                TextSpan(text: preContent, style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold, fontSize: Statics.shared.fontSizes.titleInContent),),
                TextSpan(text: content, style: TextStyle(color: Statics.shared.colors.titleTextColor,fontWeight: FontWeight.bold, fontSize: Statics.shared.fontSizes.titleInContent)),
              ]),),
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.only(left: 50,right: 50),
              width: popUpWidth,
            ),
            Container(
              child: Text(Strings.shared.dialogs.blockPopUpCaption,style: TextStyle(color: Statics.shared.colors.subTitleTextColor,fontWeight: FontWeight.normal, fontSize: Statics.shared.fontSizes.subTitleInContent),textAlign: TextAlign.left,),
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(left: 50, right: 50),
              width: popUpWidth,
            ),
            Container(
              child: Image.asset("Resources/Icons/icon_refusal.png",height: 50,),
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
              child: Row(
                children: [
                  Container(color: Colors.white,
                    child: FlatButton(
                      child: Text(Strings.shared.dialogs.closeBtnTitle,
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: Statics.shared.fontSizes.subTitleInContent,
                            color: Statics.shared.colors.titleTextColor
                        ),
                      ),
                      onPressed: (){
                        this.onPressNo();
                      },),
                    width: ((popUpWidth-16) / 2) - 32,
                  ),
                  Container(color: Colors.white,
                    child: FlatButton(
                      child: Text(Strings.shared.dialogs.btnBlockTitle,
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: Statics.shared.fontSizes.subTitleInContent,
                            color: Statics.shared.colors.titleTextColor
                        ),
                      ),
                      onPressed: (){
                        this.onPressYes();
                      },),
                    width: ((popUpWidth-16) / 2) - 32,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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