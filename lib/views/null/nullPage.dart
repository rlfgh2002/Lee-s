import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/statics.dart';

class NullPage extends StatelessWidget {
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
              child: Text("게시글이 없습니다.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Statics.shared.colors.titleTextColor,
                      fontSize: Statics.shared.fontSizes.content)),
              width: (screenWidth - (paddingSize * 2)) - buttonSize,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
      onPressed: () {},
    );
  }
}
