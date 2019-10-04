import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/LicenseTestQuestions/LicenseTestQuestionObject.dart';
import 'package:haegisa2/models/NoticesList/NoticesListObject.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';

class LicenseTestQuestionWidget extends StatelessWidget {
  String title = "";
  VoidCallback onTap;
  LicenseTestQuestionObject obj;

  LicenseTestQuestionWidget(
      {String title, VoidCallback onTap, LicenseTestQuestionObject obj}) {
    this.title = title;
    this.obj = obj;
    this.onTap = onTap;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    double paddingSize = 16;
    double buttonSize = 70;
    double screenWidth = MediaQuery.of(context).size.width;

    return FlatButton(
      child: Container(
        child: Row(
          children: [
            // Container(
            //   width: buttonSize,
            //   child: Text("공지",
            //       style: TextStyle(
            //           color: Statics.shared.colors.mainColor,
            //           fontWeight: FontWeight.w700,
            //           fontSize: Statics.shared.fontSizes.content)),
            //   alignment: Alignment.center,
            // ),
            Column(
              children: <Widget>[
                Container(
                    child: Text(this.title,
                        style: TextStyle(
                            color: Statics.shared.colors.titleTextColor,
                            fontSize: Statics.shared.fontSizes.content)),
                    width: (screenWidth - (paddingSize * 2)),
                    constraints: BoxConstraints(maxHeight: 45)),
                Container(
                    child: Text(this.obj.writer,
                        style: TextStyle(
                            color: Statics.shared.colors.captionColor,
                            fontSize: Statics.shared.fontSizes.small)),
                    width: (screenWidth - (paddingSize * 2)),
                    padding: const EdgeInsets.only(top: 5)),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Statics.shared.colors.lineColor)),
        ),
        height: 70,
        margin: const EdgeInsets.only(left: 16, right: 16),
      ),
      padding: const EdgeInsets.all(0),
      onPressed: () {
        onTap();
      },
    );
  }
}
