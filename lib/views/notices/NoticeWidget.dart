import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/notices/Notices.dart';
import 'package:haegisa2/models/DataBase/MyDataBase.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';

class NoticeWidget extends StatelessWidget {
  int id;
  String title = "";
  String shortDescription = "";
  String time = "";
  String endDate = "";
  double avatarRadius = 24;
  String avatarLink = "Resources/Icons/img_notice.png";
  String proceedingBackground = "Resources/Icons/proceedingBackground.png";
  String proceedingBackgroundDark =
      "Resources/Icons/proceedingBackgroundDark.png";
  String iconDate = "Resources/Icons/icon_date.png";
  NoticeType type = NoticeType.Notice;
  VoidCallback onTapped;
  bool isOnSurveysTabs = false;
  String idx = "";
  bool isDone = false;
  DateTime date;
  bool hasBadge = false;

  NoticeWidget(
      {int id,
      bool isDone = false,
      bool isOnSurveysTabs = false,
      bool hasBadge = false,
      String title = "",
      String shortDescription = "",
      String time = "",
      String endDate = "",
      NoticeType type = NoticeType.Notice,
      VoidCallback onTapped,
      String idx = "",
      DateTime date}) {
    this.id = id;
    this.isDone = isDone;
    this.idx = idx;
    this.title = title;
    this.shortDescription = shortDescription;
    this.time = time;
    this.endDate = endDate;
    this.type = type;
    this.onTapped = onTapped;
    this.isOnSurveysTabs = isOnSurveysTabs;
    this.hasBadge = hasBadge;
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
      case NoticeType.Qna:
        this.avatarLink = "Resources/Icons/btn_inquiry.png";
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
    final db = MyDataBase();
    double screenSize = MediaQuery.of(context).size.width;

    Widget badge = Container();

    if (this.hasBadge) {
      badge = Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.red),
        margin: const EdgeInsets.only(top: 20),
      );
    }
    if (!this.isOnSurveysTabs) {
      //공지사항
      return Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: this.type == NoticeType.Notice || this.type == NoticeType.Qna
            ? Dismissible(
                key: Key(this.id.toString()),
                child: GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      children: [
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
                                            fontSize: Statics
                                                .shared.fontSizes.content,
                                            color: Statics
                                                .shared.colors.titleTextColor),
                                        overflow: TextOverflow.fade,
                                      ),
                                      width: screenSize - 100,
                                    ),
//                      Container(child: Text(this.time, style: TextStyle(color: Statics.shared.colors.subTitleTextColor, fontSize: Statics.shared.fontSizes.supplementary),overflow: TextOverflow.fade,),
//                        width: 100,),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                                width: screenSize - 100),
                            SizedBox(height: 5),
                            Container(
                              child: Text(
                                this.time,
                                style: TextStyle(
                                    fontSize: Statics.shared.fontSizes.content,
                                    color:
                                        Statics.shared.colors.subTitleTextColor,
                                    fontWeight: FontWeight.normal),
                                overflow: TextOverflow.fade,
                              ),
                              width: screenSize - 100,
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textDirection: TextDirection.ltr,
                        ),
                        badge
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  onTap: () {
                    this.onTapped();
                  },
                  onLongPress: () {
                    if (this.type == NoticeType.Notice ||
                        this.type == NoticeType.Qna) {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => AlertDialog(
                                title: new Text("삭제"),
                                content: new Text("삭제 하시겠어요?",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("취소",
                                        style: TextStyle(
                                            fontSize: Statics
                                                .shared.fontSizes.supplementary,
                                            color: Colors.black)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  new FlatButton(
                                    child: new Text(
                                      "확인",
                                      style: TextStyle(
                                          fontSize: Statics
                                              .shared.fontSizes.supplementary,
                                          color: Colors.red),
                                    ),
                                    onPressed: () {
                                      if (this.type == NoticeType.Notice) {
                                        db.deleteNotices(id: this.id);
                                        Navigator.of(context).pop();
                                        NoticesState.setStateStatic(context);
                                      } else {
                                        db.deleteQna(idx: this.idx);
                                        Navigator.of(context).pop();
                                        NoticesState.setStateStatic(context);
                                      }
                                    },
                                  ),
                                ],
                              ));
                    }
                  },
                ),
                onDismissed: (direction) {},
                confirmDismiss: (bl) {
                  if (this.type == NoticeType.Notice ||
                      this.type == NoticeType.Qna) {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => AlertDialog(
                              title: new Text("삭제"),
                              content: new Text("삭제 하시겠어요?",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new FlatButton(
                                  child: new Text("취소",
                                      style: TextStyle(
                                          fontSize: Statics
                                              .shared.fontSizes.supplementary,
                                          color: Colors.black)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                new FlatButton(
                                  child: new Text(
                                    "확인",
                                    style: TextStyle(
                                        fontSize: Statics
                                            .shared.fontSizes.supplementary,
                                        color: Colors.red),
                                  ),
                                  onPressed: () {
                                    if (this.type == NoticeType.Notice) {
                                      db.deleteNotices(id: this.id);
                                      Navigator.of(context).pop();
                                      NoticesState.setStateStatic(context);
                                    } else {
                                      db.deleteQna(idx: this.idx);
                                      Navigator.of(context).pop();
                                      NoticesState.setStateStatic(context);
                                    }
                                  },
                                ),
                              ],
                            ));
                  }
                },
              )
            : //알림 페이지 설문조사
            GestureDetector(
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
                                        fontSize:
                                            Statics.shared.fontSizes.content,
                                        color: Statics
                                            .shared.colors.titleTextColor),
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
                            this.time + " ~ " + this.endDate,
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
                onTap: () {
                  this.onTapped();
                },
              ),
      );
    } else {
      //설문조사 페이지
      String pbck = this.proceedingBackground;
      String prcdw = Strings.shared.dialogs.proceedingWord;

      if (DateTime.parse(this.endDate).isBefore(DateTime.now())) {
        pbck = this.proceedingBackgroundDark;
        prcdw = Strings.shared.dialogs.proceedingWord2;
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
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        prcdw,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Statics.shared.fontSizes.medium,
                            fontWeight: FontWeight.w700),
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(pbck), fit: BoxFit.fill),
                      ),
                      padding: const EdgeInsets.only(
                          top: 7, bottom: 7, left: 7, right: 15),
                      margin: EdgeInsets.only(left: 12),
                    ),
                    this.isDone
                        ? Container(
                            child: Text(
                              "투표완료",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Statics.shared.fontSizes.medium,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        : Container()
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Container(
                        child: Text(
                          this.title,
                          style: TextStyle(
                              fontSize: Statics.shared.fontSizes.content,
                              color: Statics.shared.colors.titleTextColor),
                          overflow: TextOverflow.fade,
                        ),
                        width: screenSize - 116),
                    Container(
                      child: Row(
                        children: [
                          Image.asset(this.iconDate, width: 15),
                          SizedBox(width: 5),
                          Text(
                            this.time + " ~ " + this.endDate,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textDirection: TextDirection.ltr,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          highlightColor: Color.fromRGBO(244, 248, 255, 1),
        ),
      );
    }
  }
}

enum NoticeType { Notice, Vote, Survey, Qna }
