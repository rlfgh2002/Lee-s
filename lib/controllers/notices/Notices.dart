import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';

import 'package:haegisa2/views/notices/NoticeWidget.dart';
import 'package:haegisa2/views/notices/HaegisaAlertDialog.dart';
import 'package:haegisa2/views/notices/HaegisaAlertComplete.dart';
import 'package:haegisa2/views/notices/HaegisaAlertSurveyDialog.dart';
import 'MiddleWare.dart';
import 'package:haegisa2/models/DataBase/MyDataBase.dart';

class Notices extends StatefulWidget {
  final db = MyDataBase();
  static Notices staticNoticesPage;
  List<NoticeWidget> notices = [];
  NoticesState myChild;

  @override
  NoticesState createState() {
    return NoticesState();
  }
}

class NoticesState extends State<Notices> {
  final _scaffold = GlobalKey<ScaffoldState>();
  Container noNoticesFoundYet() {
    return Container(
      child: Column(
        children: [
          Image.asset(
            "Resources/Icons/none.png",
            width: 80,
          ),
          SizedBox(height: 10),
          Text(
            Strings.shared.controllers.notices.noPushNotificationYet,
            style: TextStyle(
                fontSize: Statics.shared.fontSizes.titleInContent,
                color: Statics.shared.colors.subTitleTextColor),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      width: MiddleWare.shared.screenWidth,
    );
  }

  showPopUp(
      {String content,
      String idx,
      String votingPeriod,
      List<String> votes,
      VoidCallback onPressApply,
      VoidCallback onPressClose,
      NoticeType nt = NoticeType.Vote,
      List<Map<String, dynamic>> surveys}) {
    double popUpWidth = MiddleWare.shared.screenWidth - 16;
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
    double popUpWidth = MiddleWare.shared.screenWidth - 16;
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
                fontSize: Statics.shared.fontSizes.subTitle,
                fontWeight: FontWeight.bold)),
        margin: const EdgeInsets.only(left: 8));
  }

  @override
  void initState() {
    Notices.staticNoticesPage = this.widget;
    refreshNotices();
    super.initState();
  }

  void refreshNotices() {
    widget.notices = [];
    List<NoticeWidget> myList = [];
    List<NoticeWidget> myList2 = [];

    widget.db.selectSurvey(onResult: (res) {
      for (int i = 0; i < res.length; i++) {
        NoticeWidget item = NoticeWidget(
          title: res[i]['subject'].toString(),
          shortDescription: res[i]['contents'].toString(),
          time: res[i]['start_date'].toString(),
          type: NoticeType.Survey,
          idx: "",
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
        myList.add(item);
      }
    });

    setState(() {
      widget.notices = myList;
    });

    this.widget.db.selectVotes(onResult: (results) {
      if (results.length > 0) {
        for (int i = 0; i < results.length; i++) {
          NoticeWidget item = NoticeWidget(
            title: results[i].subject.toString(),
            shortDescription: results[i].content,
            time: results[i].regDate,
            type: NoticeType.Vote,
            idx: results[i].idx,
            onTapped: () {
              widget.db.selectAnswer(
                  idx: results[i].idx,
                  onResult: (items) {
                    if (items.length > 0) {
                      var answer = items.first;
                      if (answer["voteDone"] == "FALSE") {
                        List<String> answers = [];
                        if (answer['answ1'] != "" && answer['answ1'] != null) {
                          answers.add(answer['answ1']);
                        }
                        if (answer['answ2'] != "" && answer['answ2'] != null) {
                          answers.add(answer['answ2']);
                        }
                        if (answer['answ3'] != "" && answer['answ3'] != null) {
                          answers.add(answer['answ3']);
                        }
                        if (answer['answ4'] != "" && answer['answ4'] != null) {
                          answers.add(answer['answ4']);
                        }
                        if (answer['answ5'] != "" && answer['answ5'] != null) {
                          answers.add(answer['answ5']);
                        }
                        if (answer['answ6'] != "" && answer['answ6'] != null) {
                          answers.add(answer['answ6']);
                        }

                        showPopUp(
                            content: results[i].content,
                            votingPeriod: " ~ ${results[i].endDate}",
                            votes: answers,
                            surveys: [],
                            idx: answer['voteIdx'],
                            onPressClose: () {
                              Navigator.pop(_scaffold.currentContext);
                            },
                            onPressApply: () {
                              // voting was Successful
                              Navigator.pop(_scaffold.currentContext);
                              showPopUpVotingComplete(
                                  onPressOk: () {
                                    Navigator.pop(_scaffold.currentContext);
                                  },
                                  noticeType: NoticeType.Vote);
                            });
                      } else {
                        showSnackBar("이미 투표에 참여하셨습니다");
                      }
                    } else {
                      MainTabBar.myChild.getUserId(onGetUserId: (uid) {
                        String url =
                            "${results[i].httpPath.toString()}&userId=${uid}&mode=view";
                        url = url.replaceAll("https://", "http://");
                        MainTabBar.myChild.getVoteAnswers(
                            url: url,
                            onSent: (response) {
                              widget.db.insertAnswer(
                                onAdded: () {
                                  showSnackBar(
                                      "Answers have been catched successfully.");
                                  if (Notices.staticNoticesPage != null) {
                                    refreshNotices();
                                  }
                                },
                                idx: results[i].idx.toString(),
                                status: response['data']['status'].toString(),
                                answer1: response['data']['a1'].toString(),
                                answer2: response['data']['a2'].toString(),
                                answer3: response['data']['a3'].toString(),
                                answer4: response['data']['a4'].toString(),
                                answer5: response['data']['a5'].toString(),
                                answer6: response['data']['a6'].toString(),
                              );
                            });
                      });
                      showSnackBar("Catching Answers From Server ...");
                      print("No Answers Found!");
                    }
                  });
            },
          );
          myList2.add(item);
        } // for loop

        setState(() {
          widget.notices = myList2 + myList;
        });
      } else {
        setState(() {
          widget.notices = myList;
        });
      }
    });
  }

  void openNotice(String noticeId) {
    Future.delayed(Duration(seconds: 1)).then((val) {
      int i = 0;
      widget.notices.forEach((item) {
        if (item.idx == noticeId) {
          widget.notices[i].onTapped();
          print("Clicked On Notice(${noticeId.toString()}) ....");
        }
        i++;
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

    this.widget.myChild = this;
    MiddleWare.shared.screenWidth = MediaQuery.of(context).size.width;
    MiddleWare.shared.topBarWidget = this.showTopBarTitle();

    Widget bodyWd = Container(
      color: Color.fromRGBO(244, 248, 255, 1),
      child: noNoticesFoundYet(),
    );
    if (this.widget.notices.length > 0) {
      this.widget.notices.sort((item1, item2) =>
          DateTime.parse(item2.time).compareTo(DateTime.parse(item1.time)));
      bodyWd = Container(
        color: Color.fromRGBO(244, 248, 255, 1),
        child: ListView(
          children: this.widget.notices,
        ),
      );
    }

    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: MiddleWare.shared.topBarWidget,
            centerTitle: false,
            elevation: 0,
            iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
          ),
          body: bodyWd,
          key: _scaffold,
        ));
  }
}

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//////////////////////////////// SAMPLES ///////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//
//notices.add(NoticeWidget(title: "2019년도해기사 명예의 전당..",shortDescription: "지금 투표에 참여해주세요",time: "3월 16일",type: NoticeType.Vote,
//onTapped: (){
//this.myChild.showPopUp(
//content: "2019년도 해기사 명예의 전당 인물선정에 추천할 할 분을 투표해주세요.",
//votingPeriod: " ~ 2019년 6월 5일까지",
//votes: ["유재석","김종국","이광수","지석진"],
//onPressClose: (){
//Navigator.pop(this.mainContext);
//}
//,
//onPressApply: (){
//// Send Vote Result To Server From Here ...
//Navigator.pop(this.mainContext);
//this.myChild.showPopUpVotingComplete(onPressOk: (){Navigator.pop(this.mainContext);},noticeType: NoticeType.Vote);
//}
//);
//},
//));
//notices.add(NoticeWidget(title: "2019년 제 1차 정기이사회",shortDescription: "2월 19일 11시 협회 회의실에서 2019년 제.",time: "3월 24일",type: NoticeType.Notice,
//onTapped: (){
//this.myChild.showSnackBar(Strings.shared.controllers.notices.snackBar.votingPeriodIsOver);
//},
//));
//notices.add(NoticeWidget(title: "한국해기사협회 제65차 정기..",shortDescription: "지금 설문에 참여해주세요",time: "3월 16일",type: NoticeType.Survey,
//onTapped: (){
//this.myChild.showPopUp(
//content: "한국해기사협회 제65차 정기총회 개최를 하고자 합니다. 참석가능한 시간대를 선택해주세요.",
//votingPeriod: "2019.05.24 - 05.31",
//votes: ["3월 13일(수)","3월 20일(수)","3월 27일(수)","4월 4일(수)"],
//onPressClose: (){
//Navigator.pop(this.mainContext);
//}
//,
//nt: NoticeType.Survey,
//onPressApply: (){
//// Send Vote Result To Server From Here ...
//Navigator.pop(this.mainContext);
//this.myChild.showPopUpVotingComplete(onPressOk: (){Navigator.pop(this.mainContext);},noticeType: NoticeType.Vote);
//}
//);
//},
//));
//
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//////////////////////////////// SAMPLES ///////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
