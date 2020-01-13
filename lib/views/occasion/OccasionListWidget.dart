import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/occasion/OccasionListObject.dart';

class OccasionListWidget extends StatelessWidget {
  VoidCallback onTap;
  OccasionListObject obj;

  OccasionListWidget({VoidCallback onTap, OccasionListObject obj}) {
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
            Column(
              children: <Widget>[
                Container(
                  child: Text(this.obj.subject,
                      style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.content)),
                  width: (screenWidth - (paddingSize * 2)) - buttonSize,
                ),
                Container(
                    child: Text(this.obj.regdate,
                        style: TextStyle(
                            color: Statics.shared.colors.captionColor,
                            fontSize: Statics.shared.fontSizes.small)),
                    width: (screenWidth - (paddingSize * 2)) - buttonSize,
                    margin: const EdgeInsets.only(top: 10)),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ],
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Statics.shared.colors.lineColor)),
        ),
        //height: 80,
        margin: const EdgeInsets.only(left: 32, right: 32),
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
