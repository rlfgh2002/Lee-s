import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';

class NoticeWidget extends StatelessWidget {
  String title = "";
  String shortDescription = "";
  String time = "";
  double avatarRadius = 24;
  String avatarLink = "Resources/Icons/img_notice.png";
  String proceedingBackground = "Resources/Icons/proceedingBackground.png";
  String proceedingBackgroundDark = "Resources/Icons/proceedingBackgroundDark.png";
  String iconDate = "Resources/Icons/icon_date.png";
  NoticeType type = NoticeType.Notice;
  VoidCallback onTapped;
  bool isOnSurveysTabs = false;
  String idx = "";
  bool isDone = false;
  DateTime date;

  NoticeWidget({
    bool isDone = false,
    bool isOnSurveysTabs = false,
    String title = "",
    String shortDescription = "",
    String time = "",
    NoticeType type = NoticeType.Notice,
    VoidCallback onTapped,
    String idx = "",
    DateTime date
  }) {
    this.isDone = isDone;
    this.idx = idx;
    this.title = title;
    this.shortDescription = shortDescription;
    this.time = time;
    this.type = type;
    this.onTapped = onTapped;
    this.isOnSurveysTabs = isOnSurveysTabs;
    this.date = date;

    switch (type) {
      case NoticeType.Notice:
        this.avatarLink = "Resources/Icons/img_notice.png";
        break;
      case NoticeType.Survey:
        this.avatarLink = "Resources/Icons/img_survey.png";
        break;
      case NoticeType.Vote:
        this.avatarLink = "Resources/Icons/img_vote.png";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    double screenSize = MediaQuery.of(context).size.width;
    if (!this.isOnSurveysTabs) {
      return Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: FlatButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            this.onTapped();
          },
          child: Container(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(children: [
              CircleAvatar(
                radius: this.avatarRadius,
                backgroundImage: new AssetImage(this.avatarLink),
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 10),
              Column(
                children: [
                  Container(
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              this.title,
                              style: TextStyle(
                                  fontSize: Statics.shared.fontSizes.content,
                                  color: Statics.shared.colors.titleTextColor),
                              overflow: TextOverflow.fade,
                            ),
                            width: screenSize - 100,
                          ),
//                      Container(child: Text(this.time, style: TextStyle(color: Statics.shared.colors.subTitleTextColor, fontSize: Statics.shared.fontSizes.supplementary),overflow: TextOverflow.fade,),
//                        width: 100,),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      width: screenSize - 100),
                  SizedBox(height: 5),
                  Container(
                    child: Text(
                      this.time,
                      style: TextStyle(
                          fontSize: Statics.shared.fontSizes.content,
                          color: Statics.shared.colors.subTitleTextColor,
                          fontWeight: FontWeight.normal),
                      overflow: TextOverflow.fade,
                    ),
                    width: screenSize - 100,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.ltr,
              ),
              SizedBox(width: 10),
            ]),
          ),
          highlightColor: Color.fromRGBO(244, 248, 255, 1),
        ),
      );
    } else {

      String pbck = this.proceedingBackground;
      if(this.isDone){
        pbck = this.proceedingBackgroundDark;
      }

      return Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: FlatButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            this.onTapped();
          },
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Container(
                  child: Text(
                    Strings.shared.dialogs.proceedingWord,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Statics.shared.fontSizes.medium,
                        fontWeight: FontWeight.w700),
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(pbck)),
                  ),
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 5, right: 15),
                  margin: const EdgeInsets.only(top: 5),
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Container(
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                this.title,
                                style: TextStyle(
                                    fontSize: Statics.shared.fontSizes.content,
                                    color:
                                        Statics.shared.colors.titleTextColor),
                                overflow: TextOverflow.fade,
                              ),
                              width: screenSize - 116,
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        width: screenSize - 116),
                    SizedBox(height: 10),
                    Container(
                      child: Row(
                        children: [
                          Image.asset(this.iconDate, width: 15),
                          SizedBox(width: 5),
                          Text(
                            this.time,
                            style: TextStyle(
                                fontSize: Statics.shared.fontSizes.medium,
                                fontWeight: FontWeight.w400,
                                color: Statics.shared.colors.titleTextColor),
                            overflow: TextOverflow.fade,
                          )
                        ],
                      ),
                      width: screenSize - 116,
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.ltr,
                ),
                SizedBox(width: 10),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          highlightColor: Color.fromRGBO(244, 248, 255, 1),
        ),
      );
    }
  }
}

enum NoticeType { Notice, Vote, Survey }
