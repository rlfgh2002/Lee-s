import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';

class VoteWidget extends StatefulWidget {
  double width = 0;
  String vote = "";
  bool isChecked = false;

  String groupName = "";
  int itemIndex = 1;

  VoidCallback onTapped;

  VoteWidget(
      {bool isChecked = false,
      double width = 0,
      String vote = "",
      String groupName = "",
      int itemIndex = 1,
      VoidCallback onTapped}) {
    this.width = width;
    this.vote = vote;
    this.groupName = groupName;
    this.itemIndex = itemIndex;
    this.onTapped = onTapped;
    this.isChecked = isChecked;
  }

  @override
  _VoteWidgetState createState() => _VoteWidgetState();
}

class _VoteWidgetState extends State<VoteWidget> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    if (this.widget.isChecked) {
      return Container(
        child: FlatButton(
          onPressed: () {
            setState(() {
              //this.widget.isChecked = false;
            });
          },
          padding: const EdgeInsets.all(0),
          child: Container(
            width: this.widget.width,
            child: Row(
              children: [
                Text(
                  this.widget.vote,
                  style: TextStyle(
                      color: Statics.shared.colors.mainColor,
                      fontSize: Statics.shared.fontSizes.content,
                      fontWeight: FontWeight.bold),
                ),
                Icon(Icons.check, color: Statics.shared.colors.mainColor)
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border:
                Border.all(color: Statics.shared.colors.mainColor, width: 1)),
        width: this.widget.width,
        padding: const EdgeInsets.only(left: 16, right: 16),
        margin: const EdgeInsets.only(bottom: 10),
      );
    } // checked
    else {
      return Container(
        child: FlatButton(
          onPressed: () {
            setState(() {
              //this.widget.isChecked = true;
              this.widget.onTapped();
            });
          },
          padding: const EdgeInsets.all(0),
          child: Container(
            width: this.widget.width,
            child: Row(
              children: [
                Text(
                  this.widget.vote,
                  style: TextStyle(
                      color: Statics.shared.colors.titleTextColor,
                      fontSize: Statics.shared.fontSizes.content,
                      fontWeight: FontWeight.bold),
                ),
                Icon(Icons.check,
                    color: Statics.shared.colors.subTitleTextColor)
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(
                color: Statics.shared.colors.subTitleTextColor, width: 1)),
        width: this.widget.width,
        padding: const EdgeInsets.only(left: 16, right: 16),
        margin: const EdgeInsets.only(bottom: 10),
      );
    } // not checked
  }
}
