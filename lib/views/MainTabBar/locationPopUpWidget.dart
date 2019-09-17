import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';

class LocationPopUpWidget {
  VoidCallback onPressClose;
  VoidCallback onPress7DaysNoSee;
  double popUpHeight = 0;
  double popUpWidth = 0;

  LocationPopUpWidget({
    VoidCallback onPressClose,
    VoidCallback onPress7DaysNoSee,
    double popUpWidth = 0,
    double popUpHeight = 0,
  }) {
    this.onPressClose = onPressClose;
    this.onPress7DaysNoSee = onPress7DaysNoSee;
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
              child: Image.asset("Resources/Images/popUpLocation.png", height: 380,fit: BoxFit.fitHeight,),
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.only(left: 50, right: 50),
              width: popUpWidth,
              alignment: Alignment.bottomCenter,
              height: 400,
            ),
            //Expanded(child: Container(),),
            Container(
              height: 60,
              width: popUpWidth,
              margin: const EdgeInsets.only(top: 1),
              child: Row(
                children: [
                  Container(color: Colors.transparent,
                    child: FlatButton(
                      child: Text(Strings.shared.dialogs.sevenDaysNoSee,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: Statics
                            .shared.fontSizes.subTitleInContent,
                            color: Statics.shared.colors.subTitleTextColor
                        ),
                      ),
                      onPressed: () {
                        this.onPress7DaysNoSee();
                      },),
                    width: (((popUpWidth/2))),
                  ),
                  SizedBox(width: 8),
                  Container(color: Colors.transparent,
                    child: FlatButton(
                      child: Text(Strings.shared.dialogs.closeBtnTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: Statics
                            .shared.fontSizes.subTitleInContent,
                            color: Statics.shared.colors.subTitleTextColor
                        ),
                      ),
                      onPressed: () {
                        this.onPressClose();
                      },),
                    width: (((popUpWidth/2) - 16)) - 32,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
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
      backgroundColor: Color.fromRGBO(246,249,255,1),
      contentPadding: const EdgeInsets.all(0),
    );
  }
}