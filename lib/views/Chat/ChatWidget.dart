import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:intl/intl.dart';

class ChatWidget extends StatelessWidget {
  String content = "";
  String time = "";
  String senderName = "";
  bool isYours = false;

  ChatWidget({
    String content = "",
    String time = "",
    String senderName = "",
    bool isYours = false,
  }) {
    this.content = content;
    this.time = time;
    this.senderName = senderName;
    this.isYours = isYours;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    double screenWidth = MediaQuery.of(context).size.width;
    double chatMaxSize = screenWidth;

    var dt = DateTime.now();
    String clearDateTime = "";

    if (this.time.contains("/")) {
      var splited = this.time.split(" ");
      var dateSpt = splited[0].split("/");
      var timeSpt = splited[1].split(":");

      if (DateTime.now().year == int.parse(dateSpt[0]) &&
          DateTime.now().month == int.parse(dateSpt[1]) &&
          DateTime.now().day == int.parse(dateSpt[2])) {
        clearDateTime = "오전 ${timeSpt[0]}:${timeSpt[1]}";
      } else if (DateTime.now().year == int.parse(dateSpt[0]) &&
          DateTime.now().month == int.parse(dateSpt[1]) &&
          DateTime.now().day == int.parse(dateSpt[2]) + 1) {
        clearDateTime = "어제 ${timeSpt[0]}:${timeSpt[1]}";
      } else if (DateTime.now().year == int.parse(dateSpt[0]) &&
          DateTime.now().month == int.parse(dateSpt[1]) &&
          DateTime.now().day > int.parse(dateSpt[2]) + 1) {
        clearDateTime = "${dateSpt[1]}월 ${dateSpt[2]}일";
      } else {
        clearDateTime = "${dateSpt[0]}.${dateSpt[1]}.${dateSpt[2]}";
      }

      //clearDateTime = "${dateSpt[0].toString()}-${dateSpt[1].toString()}-${dateSpt[2].toString()} at ${timeSpt[0].toString()}:${timeSpt[1].toString()}";
    } else {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      dt = DateTime.parse(this.time);
      if (DateTime.now().year == dt.year &&
          DateTime.now().month.toString().padLeft(2, '0') ==
              dt.month.toString().padLeft(2, '0') &&
          DateTime.now().day.toString().padLeft(2, '0') ==
              dt.day.toString().padLeft(2, '0')) {
        if (dt.hour > 12) {
          clearDateTime =
              "오후 ${(dt.hour - 12).toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
        } else {
          clearDateTime =
              "오전 ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
        }
      } else if (DateTime.now().year == dt.year &&
          DateTime.now().month.toString().padLeft(2, '0') ==
              dt.month.toString().padLeft(2, '0') &&
          DateTime.now().day.toString().padLeft(2, '0') ==
              (dt.day + 1).toString().padLeft(2, '0')) {
        if (dt.hour > 12) {
          clearDateTime =
              "어제 오후 ${(dt.hour - 12).toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
        } else {
          clearDateTime =
              "어제 오전 ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
        }
      } else if (DateTime.now().year == dt.year &&
          DateTime.now().month.toString().padLeft(2, '0') ==
              dt.month.toString().padLeft(2, '0') &&
          int.parse(DateTime.now().day.toString().padLeft(2, '0')) >
              int.parse((dt.day + 1).toString().padLeft(2, '0'))) {
        clearDateTime = "${dt.month}월 ${dt.day}일";
      } else {
        clearDateTime = "${dt.year}.${dt.month}.${dt.day}";
      }
      //clearDateTime = "${dt.year.toString()}-${dt.month.toString()}-${dt.day.toString()} at ${dt.hour.toString()}:${dt.minute.toString()}";
    }

    if (!this.isYours) {
      return Padding(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 64, top: 10, left: 32),
                alignment: Alignment.centerLeft,
                constraints:
                    BoxConstraints(minWidth: 20, maxWidth: chatMaxSize),
                child: Row(
                  children: [
                    Text(
                      this.senderName,
                      style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.medium,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 5),
                    Text(
                      clearDateTime,
                      style: TextStyle(
                          color: Statics.shared.colors.subTitleTextColor,
                          fontSize: Statics.shared.fontSizes.verySmall,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
              ),
              Stack(
                children: [
                  Container(
                      child: Text(
                        this.content,
                        style: TextStyle(
                            color: Statics.shared.colors.titleTextColor,
                            fontSize: Statics.shared.fontSizes.medium,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.start,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      margin:
                          const EdgeInsets.only(right: 64, top: 5, left: 32),
                      padding: const EdgeInsets.all(10),
                      constraints:
                          BoxConstraints(minWidth: 20, maxWidth: chatMaxSize)),
                  Container(
                    child: Image.asset(
                      "Resources/Images/leftEdge.png",
                      height: 15,
                    ),
                    margin: const EdgeInsets.only(left: 15),
                  )
                ],
                alignment: Alignment.bottomLeft,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          padding: const EdgeInsets.only(top: 20));
    } // this is not yours
    else {
      return Padding(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 32, top: 10, left: 64),
                alignment: Alignment.centerRight,
                constraints:
                    BoxConstraints(minWidth: 20, maxWidth: chatMaxSize),
                child: Row(
                  children: [
                    Text(
                      this.senderName,
                      style: TextStyle(
                          color: Statics.shared.colors.titleTextColor,
                          fontSize: Statics.shared.fontSizes.medium,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      clearDateTime,
                      style: TextStyle(
                          color: Statics.shared.colors.subTitleTextColor,
                          fontSize: Statics.shared.fontSizes.verySmall,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),
              Stack(
                children: [
                  Container(
                    child: Text(
                      this.content,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Statics.shared.fontSizes.medium,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.end,
                    ),
                    decoration: BoxDecoration(
                      color: Statics.shared.colors.mainColor,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    margin: const EdgeInsets.only(right: 32, top: 5, left: 64),
                    padding: const EdgeInsets.all(10),
                    //width: screenWidth / 1.5,
                    constraints:
                        BoxConstraints(minWidth: 20, maxWidth: chatMaxSize),
                  ),
                  Container(
                    child: Image.asset(
                      "Resources/Images/rightEdge.png",
                      height: 15,
                      color: Statics.shared.colors.mainColor,
                    ),
                    margin: const EdgeInsets.only(right: 15),
                  )
                ],
                alignment: Alignment.bottomRight,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
          padding: const EdgeInsets.only(top: 20));
    } // this is yours
  }
}
