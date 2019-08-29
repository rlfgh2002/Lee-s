import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';

class NoInternetAlertWidget {
  VoidCallback onPressClose;
  double popUpHeight = 0;
  double popUpWidth = 0;

  NoInternetAlertWidget({
    VoidCallback onPressClose,
    double popUpWidth = 0,
    double popUpHeight = 0,
  }) {
    this.onPressClose = onPressClose;
    this.popUpWidth = popUpWidth;
    this.popUpHeight = popUpHeight;
  }

  AlertDialog dialog() {
    String title = Strings.shared.dialogs.internetPopUpTitle;
    String content = Strings.shared.dialogs.internetPopUpBody;

    return AlertDialog(
      content: Container(
        child: Column(
          children: [
            Container(
              child: Text(title, style: TextStyle(
                  color: Statics.shared.colors.titleTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: Statics.shared.fontSizes.titleInContent)),
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.only(left: 50, right: 50),
              width: popUpWidth,
            ),
            Container(
              child: Text(content, style: TextStyle(
                  color: Statics.shared.colors.subTitleTextColor,
                  fontWeight: FontWeight.normal,
                  fontSize: Statics.shared.fontSizes.subTitleInContent),
                textAlign: TextAlign.left,),
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(left: 50, right: 50),
              width: popUpWidth,
            ),
            Container(
              child: Image.asset("Resources/Icons/wifi.png", height: 50,),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: Statics
                            .shared.fontSizes.subTitleInContent,
                            color: Statics.shared.colors.titleTextColor
                        ),
                      ),
                      onPressed: () {
                        this.onPressClose();
                      },),
                    width: ((popUpWidth - 16)) - 32,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(
                      color: Statics.shared.colors.lineColor, width: 1))
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