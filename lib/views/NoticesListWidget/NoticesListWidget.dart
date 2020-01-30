import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/NoticesList/NoticesListObject.dart';
import 'package:haegisa2/models/statics/statics.dart';

class NoticesListWidget extends StatelessWidget {
  String title = "";
  VoidCallback onTap;
  NoticesListObject obj;

  NoticesListWidget({String title, VoidCallback onTap, NoticesListObject obj}) {
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
            Container(
              width: buttonSize,
              child: Text("공지",
                  style: TextStyle(
                      color: Statics.shared.colors.mainColor,
                      fontWeight: FontWeight.w700,
                      fontSize: Statics.shared.fontSizes.content)),
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 2),
            ),
            Column(
              children: <Widget>[
                Container(
                  child: Text(this.title,
                      style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.content)),
                  width: (screenWidth - (paddingSize * 2)) - buttonSize,
                ),
                Row(
                  children: <Widget>[
                    Container(
                        child: Text(this.obj.regDate,
                            style: TextStyle(
                                color: Statics.shared.colors.captionColor,
                                fontSize: Statics.shared.fontSizes.small)),
                        width: (screenWidth - (paddingSize * 2)) - buttonSize,
                        margin: const EdgeInsets.only(top: 10)),
                  ],
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Statics.shared.colors.lineColor)),
        ),
        //height: 80,
        margin: const EdgeInsets.only(left: 16, right: 16),
        padding: const EdgeInsets.only(bottom: 20, top: 20),
        alignment: Alignment.center,
      ),
      padding: const EdgeInsets.all(0),
      onPressed: () {
        onTap();
      },
    );
  }
}
