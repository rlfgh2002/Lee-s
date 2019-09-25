import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/notices/NoticeWidget.dart';
import 'package:haegisa2/models/DataBase/MyDataBase.dart';

import 'package:haegisa2/views/notices/HaegisaAlertDialog.dart';
import 'package:haegisa2/views/notices/HaegisaAlertComplete.dart';
import 'package:haegisa2/views/notices/HaegisaAlertSurveyDialog.dart';
import 'package:loading/indicator/ball_scale_multiple_indicator.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/indicator/line_scale_indicator.dart';

import 'package:loading/loading.dart';

class SurveysTabs extends StatefulWidget {
  double screenWidth = 0;
  final db = MyDataBase();
  int selectedTab = 0;
  List<NoticeWidget> onGoingSurveys = [];
  List<NoticeWidget> doneSurveys = [];

  Widget List1 = Container();
  Widget List2 = Container();

  @override
  _SurveysTabsState createState() => _SurveysTabsState();
}

class _SurveysTabsState extends State<SurveysTabs>
    with TickerProviderStateMixin {
  final _scaffold = GlobalKey<ScaffoldState>();

  showPopUp(
      {String content,
      String idx,
      String votingPeriod,
      List<String> votes,
      VoidCallback onPressApply,
      VoidCallback onPressClose,
      NoticeType nt = NoticeType.Vote,
      List<Map<String, dynamic>> surveys}) {
    double popUpWidth = widget.screenWidth - 16;
    double height = MediaQuery.of(context).size.height / 1.5;

    if (MediaQuery.of(context).size.height < 750) {
      height = MediaQuery.of(context).size.height - 10;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (nt == NoticeType.Vote) {
            return HaegisaAlertDialog(
                votes: votes,
                votingPeriod: votingPeriod,
                popUpWidth: popUpWidth,
                popUpHeight: height,
                idx: idx,
                content: content,
                onPressApply: () {
                  onPressApply();
                },
                onPressClose: () {
                  onPressClose();
                });
          } // Vote
          else {
            return HaegisaAlertSurveyDialog(
                surveys: surveys,
                votingPeriod: votingPeriod,
                popUpWidth: popUpWidth,
                popUpHeight: height,
                idx: idx,
                content: content,
                onPressApply: () {
                  onPressApply();
                },
                onPressClose: () {
                  onPressClose();
                });
          } // Survey
        });
  }

  showPopUpVotingComplete(
      {VoidCallback onPressOk, NoticeType noticeType = NoticeType.Vote}) {
    double popUpWidth = widget.screenWidth - 16;
    double height = MediaQuery.of(context).size.height / 1.5;

    if (MediaQuery.of(context).size.height < 750) {
      height = MediaQuery.of(context).size.height - 10;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (noticeType == NoticeType.Vote) {
            return HaegisaAlertCompleteDialog(
                    popUpWidth: popUpWidth,
                    noticeType: noticeType,
                    onPressOk: () {
                      onPressOk();
                    },
                    popUpHeight: height)
                .dialog();
          } // vote
        });
  }

  showSnackBar(String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontSize: Statics.shared.fontSizes.content),
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 3),
    ));
  }

  Container showTopBarTitle() {
    return Container(
        child: Text(Strings.shared.controllers.notices.pageTitle,
            style: TextStyle(
                color: Statics.shared.colors.titleTextColor,
                fontSize: Statics.shared.fontSizes.title)),
        margin: const EdgeInsets.only(left: 8));
  }

  void refreshNotices() {
    widget.List1 = Container(
      color: Colors.white,
      child: Center(
        child: Loading(indicator: LineScaleIndicator(), size: 50.0),
      ),
    );
    widget.List2 = widget.List1;

    widget.onGoingSurveys = [];
    widget.doneSurveys = [];

    widget.db.selectSurvey(onResult: (res) {
      List<NoticeWidget> myList = [];
      List<NoticeWidget> myList2 = [];

      for (int i = 0; i < res.length; i++) {
        NoticeWidget item = NoticeWidget(
          isOnSurveysTabs: true,
          title: res[i]['subject'].toString(),
          shortDescription: res[i]['contents'].toString(),
          time: res[i]['start_date'].toString(),
          type: NoticeType.Survey,
          onTapped: () {
            widget.db.selectSurveyAnswer(
                idx: res[i]['bd_idx'],
                onResult: (surveys) {
                  if (surveys.length > 0) {
                    showPopUp(
                        content: res[i]['contents'].toString(),
                        nt: NoticeType.Survey,
                        votingPeriod: " ~ ${res[i]['end_date'].toString()}",
                        votes: [],
                        surveys: surveys,
                        idx: res[i]['bd_idx'].toString(),
                        onPressClose: () {
                          Navigator.pop(_scaffold.currentContext);
                        },
                        onPressApply: () {
                          // Survey was Successful
                          Navigator.pop(_scaffold.currentContext);
                          showPopUpVotingComplete(
                              onPressOk: () {
                                Navigator.pop(_scaffold.currentContext);
                              },
                              noticeType: NoticeType.Survey);
                        });
                  } else {
                    showPopUp(
                        content: res[i]['contents'].toString(),
                        votingPeriod: " ~ ${res[i]['end_date'].toString()}",
                        votes: ["a1", "a2", "a3"],
                        idx: res[i]['bd_idx'].toString(),
                        onPressClose: () {
                          Navigator.pop(_scaffold.currentContext);
                        },
                        onPressApply: () {
                          // Survey was Successful
                          Navigator.pop(_scaffold.currentContext);
                          showPopUpVotingComplete(
                              onPressOk: () {
                                Navigator.pop(_scaffold.currentContext);
                              },
                              noticeType: NoticeType.Survey);
                        });
                  }
                });
          },
        );
        if (res[i]['isDone'] == "FALSE") {
          myList.add(item);
        } else {
          myList2.add(item);
        }
      }

      widget.onGoingSurveys = myList;
      widget.doneSurveys = myList2;

      widget.List1 = ListView(children: widget.onGoingSurveys);
      widget.List2 = ListView(children: widget.doneSurveys);
    });
  }

  @override
  void initState() {
    refreshNotices();
    Future.delayed(Duration(seconds: 2)).then((val) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    Tab tab1;
    Tab tab2;
    Color normalTabColor = Statics.shared.colors.titleTextColor;
    Color selectedTabColor = Statics.shared.colors.mainColor;
    if (widget.selectedTab == 0) {
      tab1 = Tab(
          child: Text("진행중인 설문",
              style: TextStyle(
                  color: selectedTabColor,
                  fontSize: Statics.shared.fontSizes.content)));
      tab2 = Tab(
          child: Text("종료된 설문",
              style: TextStyle(
                  color: normalTabColor,
                  fontSize: Statics.shared.fontSizes.content)));
    } else {
      tab1 = Tab(
          child: Text("진행중인 설문",
              style: TextStyle(
                  color: normalTabColor,
                  fontSize: Statics.shared.fontSizes.content)));
      tab2 = Tab(
          child: Text("종료된 설문",
              style: TextStyle(
                  color: selectedTabColor,
                  fontSize: Statics.shared.fontSizes.content)));
    }

    widget.screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [tab1, tab2],
            onTap: (val) {
              setState(() {
                widget.selectedTab = val;
              });
            },
          ),
          iconTheme: IconThemeData(
            color: Color.fromRGBO(0, 0, 0, 1),
          ),
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          title: Container(
              child: Text(Strings.shared.controllers.SurveysTabs.pageTitle,
                  style: TextStyle(
                      color: Statics.shared.colors.titleTextColor,
                      fontSize: Statics.shared.fontSizes.titleInContent,
                      fontWeight: FontWeight.w100)),
              margin: const EdgeInsets.only(left: 0)),
        ),
        body: TabBarView(
          children: [
            widget.List1,
            widget.List2,
          ],
          physics: NeverScrollableScrollPhysics(),
        ),
        key: _scaffold,
      ),
    );
  }
}
