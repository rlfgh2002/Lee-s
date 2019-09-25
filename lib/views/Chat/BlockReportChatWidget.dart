import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';

class BlockReportChatWidget extends StatelessWidget {
  VoidCallback onPressPermission;
  VoidCallback onPressBlock;

  BlockReportChatWidget(
      {VoidCallback onPressPermission, VoidCallback onPressBlock}) {
    this.onPressBlock = onPressBlock;
    this.onPressPermission = onPressPermission;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    double screenWidth = MediaQuery.of(context).size.width;
    double newW = (screenWidth - 32) / 2;
    newW = newW - 2;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 4)
          ],
          color: Colors.white),
      height: 65,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            width: newW,
            color: Colors.transparent,
            height: 50,
            child: FlatButton(
              color: Colors.transparent,
              child: Row(
                children: [
                  Image.asset(
                    "Resources/Icons/icon_Permission.png",
                    height: 18,
                  ),
                  SizedBox(width: 10),
                  Text(
                    Strings.shared.controllers.chat.conversationPermission,
                    style:
                        TextStyle(fontSize: Statics.shared.fontSizes.content),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              onPressed: () {
                this.onPressPermission();
              },
              padding: const EdgeInsets.all(0),
            ),
          ),
          Image.asset("Resources/Icons/Line.png",
              color: Statics.shared.colors.lineColor, height: 30, width: 2),
          Container(
            width: newW,
            color: Colors.transparent,
            height: 30,
            child: FlatButton(
              color: Colors.transparent,
              child: Row(
                children: [
                  Image.asset("Resources/Icons/icon_refusal.png",
                      height: 18, color: Colors.red),
                  SizedBox(width: 10),
                  Text(
                    Strings.shared.controllers.chat.conversationBlock,
                    style: TextStyle(
                        fontSize: Statics.shared.fontSizes.content,
                        color: Colors.red),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              onPressed: () {
                this.onPressBlock();
              },
              padding: const EdgeInsets.all(0),
            ),
          )
        ],
      ),
    );
  }
}
