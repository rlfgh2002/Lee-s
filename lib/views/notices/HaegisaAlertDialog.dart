import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/notices/VoteWidget.dart';
import 'package:haegisa2/models/DataBase/MyDataBase.dart';
import 'dart:convert';
import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:http/http.dart' as http;

class HaegisaAlertDialog extends StatefulWidget {
  final db = MyDataBase();

  List<bool> voteGroupItems = [];
  void checkItemManager(int item, bool val) {
    this.voteGroupItems[item] = val;
    if (item != 0) {
      this.voteGroupItems[0] = !val;
    }
    if (item != 1) {
      this.voteGroupItems[1] = !val;
    }
    if (item != 2) {
      this.voteGroupItems[2] = !val;
    }
    if (item != 3) {
      this.voteGroupItems[3] = !val;
    }

    for (int i = 0; i < this.voteGroupItems.length; i++) {
      print("List[${i}]: ${voteGroupItems[i]}");
    }
  }

  bool isFirst = true;
  VoidCallback onPressClose;
  VoidCallback onPressApply;

  String idx = "";
  double popUpHeight = 0;
  double popUpWidth = 0;
  String content = "";
  String votingPeriod = "";
  List<String> votes = [];
  String startDate = "";
  String endDate = "";

  HaegisaAlertDialog(
      {String idx,
      double popUpWidth = 0,
      double popUpHeight = 0,
      String content,
      String votingPeriod,
      String startDate,
      String endDate,
      List<String> votes,
      VoidCallback onPressClose,
      VoidCallback onPressApply}) {
    this.content = content;
    this.votes = votes;
    this.votingPeriod = votingPeriod;
    this.popUpWidth = popUpWidth;
    this.onPressApply = onPressApply;
    this.onPressClose = onPressClose;
    this.popUpHeight = popUpHeight;
    this.idx = idx;
    this.startDate = startDate;
    this.endDate = endDate;

    if (this.isFirst) {
      this.voteGroupItems.add(false);
      this.voteGroupItems.add(false);
      this.voteGroupItems.add(false);
      this.voteGroupItems.add(false);
    }
  }

  @override
  _HaegisaAlertDialogState createState() => _HaegisaAlertDialogState();
}

class _HaegisaAlertDialogState extends State<HaegisaAlertDialog> {

  void submitVote(
      {onSent(Map<String, dynamic> jj),
      onNotSent(),
      String idx,
      String check = "a1"}) async {

    String votePeriod = "";
    this.widget.votingPeriod = this.widget.votingPeriod.trim().replaceAll("~", "").replaceAll(" ", "");
    String year = this.widget.votingPeriod.substring(0,4);
    String month = this.widget.votingPeriod.substring(5,7);
    String day = this.widget.votingPeriod.substring(6,8);

    String hours = this.widget.votingPeriod.substring(8,10);
    String minutes = this.widget.votingPeriod.substring(10,12);
    votePeriod = "${year.toString()}-${month.toString()}-${day.toString()} ${hours.toString()}:${minutes.toString()}";
    DateTime votePeriodDate = DateTime.parse(votePeriod);

    if(votePeriodDate.isAfter(DateTime.now())){
      this.widget.onPressApply();
      return;
    }

    MainTabBar.myChild.getUserId(onGetUserId: (uid) {
      http.get(Statics.shared.urls.submitVote(uid,idx,check)).then((val) {
        if (val.statusCode == 200) {
          print("OUTPUT: ${val.body.toString()}");
          var j = jsonDecode(val.body);
          print("OUTPUT JSON: ${j.toString()}");
          onSent(j);
        } else {
          onNotSent();
        }
      }).catchError((error) {
        print(
            ":::::::::::::::::: on getting Vote Answers error : ${error.toString()} ::::::::::::::::::");
        onNotSent();
      }).whenComplete(() {
        print(
            "::::::::::::::::::::: [ SUBMIT VOTE DATA ] :::::::::::::::::::::");
        print("userId:${uid.toString()}");
        print("mode:submit");
        print("idx:${idx.toString()}");
        print("check:${check.toString()}");
        print(
            "::::::::::::::::::::: [ SUBMIT VOTE DATA ] :::::::::::::::::::::");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    List<VoteWidget> myVoteList = [];

    for (int i = 0; i < widget.votes.length; i++) {
      myVoteList.add(
        VoteWidget(
          width: this.widget.popUpWidth - 64,
          vote: this.widget.votes[i],
          groupName: "voteGroup",
          itemIndex: i,
          onTapped: () {
            setState(() {
              this.widget.checkItemManager(i, true);
            });
          },
          isChecked: this.widget.voteGroupItems[i],
        ),
      );
    }

    String votePeriod = "";
    this.widget.votingPeriod = this.widget.votingPeriod.trim().replaceAll("~", "").replaceAll(" ", "");
    String year = this.widget.votingPeriod.substring(0,4);
    String month = this.widget.votingPeriod.substring(5,7);
    String day = this.widget.votingPeriod.substring(6,8);

    String hours = this.widget.votingPeriod.substring(8,10);
    String minutes = this.widget.votingPeriod.substring(10,12);
    votePeriod = "~ ${year.toString()}.${month.toString()}.${day.toString()} ${hours.toString()}:${minutes.toString()}";

    return AlertDialog(
      content: Container(
        child: Column(
          children: [
            Container(
              width: this.widget.popUpWidth,
              color: Statics.shared.colors.mainColor,
              height: 5,
            ),
            Stack(
              children: [
                Container(
                  child: Text(
                    Strings.shared.dialogs.vote,
                    style: TextStyle(
                        fontSize: Statics.shared.fontSizes.titleInContent,
                        color: Statics.shared.colors.titleTextColor,
                        fontWeight: FontWeight.bold),
                  ),
                  padding: const EdgeInsets.only(top: 70, left: 32),
                ),
                Container(
                  child: Image.asset(
                    "Resources/Images/ill_vote.png",
                    width: this.widget.popUpWidth / 3.2,
                  ),
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 32),
                )
              ],
            ),
            Container(
              child: Text(
                this.widget.content,
                style: TextStyle(
                    color: Statics.shared.colors.titleTextColor,
                    fontSize: Statics.shared.fontSizes.content),
              ),
              padding: const EdgeInsets.only(
                  left: 32, right: 32, top: 20, bottom: 10),
            ),
            Container(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: Row(
                children: [
                  Image.asset(
                    "Resources/Icons/icon_date.png",
                    height: 16,
                    width: 16,
                  ),
                  SizedBox(width: 5),
                  Text(
                    Strings.shared.dialogs.votingPeriod,
                    style: TextStyle(
                        color: Statics.shared.colors.mainColor,
                        fontSize: Statics.shared.fontSizes.supplementary,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Text(
                    votePeriod,
                    style: TextStyle(
                        color: Statics.shared.colors.titleTextColor,
                        fontSize: Statics.shared.fontSizes.supplementary),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            ),
            SizedBox(height: 30),
            Container(
              child: Container(
                child: ListView(children: myVoteList),
                height: 220,
                padding: const EdgeInsets.only(left: 16, right: 16),
              ),
            ), // vote List
            SizedBox(height: 30),
            Container(
              child: Text(
                Strings.shared.dialogs.bottomLableVoteDialog,
                style: TextStyle(
                    color: Statics.shared.colors.subTitleTextColor,
                    fontSize: Statics.shared.fontSizes.supplementary),
              ),
              alignment: Alignment.center,
            ),
            Container(
              height: 60,
              width: this.widget.popUpWidth,
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Container(
                    color: Statics.shared.colors.subTitleTextColor,
                    child: FlatButton(
                      child: Text(
                        Strings.shared.dialogs.closeBtnTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                Statics.shared.fontSizes.subTitleInContent,
                            color: Colors.white),
                      ),
                      onPressed: () {
                        this.widget.onPressClose();
                      },
                    ),
                    width: (this.widget.popUpWidth - 16) / 2,
                  ),
                  Container(
                      color: Statics.shared.colors.mainColor,
                      child: FlatButton(
                        child: Text(
                          Strings.shared.dialogs.applyVoteBtn,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  Statics.shared.fontSizes.subTitleInContent,
                              color: Colors.white),
                        ),
                        onPressed: () {
                          // Send Vote Result To Server From Here ...
                          var trueInt = 0;
                          for (int i = 0;
                              i < widget.voteGroupItems.length;
                              i++) {
                            if (widget.voteGroupItems[i]) {
                              trueInt = i;
                            }
                          }
                          submitVote(
                              idx: widget.idx,
                              check: "a${(trueInt + 1).toString()}",
                              onSent: (res) {
                                if (res['code'].toString() == "0") {
                                  print("You have Already Voted.");
                                  // you have already voted.
                                } else {
                                  print("Voting was Successful.");
                                  widget.db.updateAnswer(
                                      idx: widget.idx,
                                      voteDone: "TRUE",
                                      onUpdated: () {
                                        this.widget.onPressApply();
                                      });
                                }
                              });
                        },
                      ),
                      width: (this.widget.popUpWidth - 16) / 2),
                ],
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              color: Colors.red,
            ),
          ], // Column Children
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
        ), // Column
        width: this.widget.popUpWidth,
        //height: popUpHeight,
      ), // Content Container
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }
}
