import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:haegisa2/controllers/notices/Notices.dart';
import 'package:haegisa2/models/DataBase/MyDataBase.dart';
import 'package:haegisa2/models/Survey/SurveyResultPercentageObject.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/notices/HaegisaAlertComplete.dart';
import 'package:haegisa2/views/notices/SurveyWidget.dart';
import 'package:http/http.dart' as http;
import 'package:haegisa2/views/notices/NoticeWidget.dart';

class HaegisaAlertSurveyCheckedListObj {
  String question = "";
  String answer = "";
  String idx = "";
  String cnt = "0";

  HaegisaAlertSurveyCheckedListObj({
    String Q,
    String A,
    String I,
    String cnt,
  }) {
    this.question = Q;
    this.answer = A;
    this.idx = I;
    this.cnt = cnt;
  }
}

class HaegisaAlertSurveyDialog extends StatefulWidget {
  final db = MyDataBase();

  Map<int, List<bool>> voteGroupItems;

  Widget bottomButton = Container();
  Widget surveyList = Container();
  var surveySelect;

  VoidCallback onPressClose;
  VoidCallback onPressApply;
  VoidCallback afterSubmit;

  String idx = "";
  bool isFirst = true;
  double popUpHeight = 0;
  double popUpWidth = 0;
  bool isDone = false;
  String content = "";
  String votingPeriod = "";
  String endDate = "";
  String startDate = "";
  List<Map<String, dynamic>> surveys = [];
  List<HaegisaAlertSurveyCheckedListObj> surveysChecked = [];

  HaegisaAlertSurveyDialog(
      {String endDate,
      String startDate,
      bool isDone,
      String idx,
      double popUpWidth = 0,
      double popUpHeight = 0,
      String content,
      String votingPeriod,
      List<Map<String, dynamic>> surveys,
      VoidCallback onPressClose,
      VoidCallback onPressApply,
      VoidCallback afterSubmit}) {
    this.content = content;
    this.isDone = isDone;
    this.surveys = surveys;
    this.votingPeriod = votingPeriod;
    this.popUpWidth = popUpWidth;
    this.onPressApply = onPressApply;
    this.onPressClose = onPressClose;
    this.popUpHeight = popUpHeight;
    this.idx = idx;
    this.startDate = startDate;
    this.endDate = endDate;
    this.afterSubmit = afterSubmit;
  }

  @override
  _HaegisaAlertSurveyDialogState createState() =>
      _HaegisaAlertSurveyDialogState();
}

class _HaegisaAlertSurveyDialogState extends State<HaegisaAlertSurveyDialog> {
  void checkItemManager(int item, bool val, int gId) {
    for (int i = 0; i < this.widget.voteGroupItems[gId].length; i++) {
      this.widget.voteGroupItems[gId][i] = !val;
    }

    this.widget.voteGroupItems[gId][item] = val;
  }

  showPopUpVotingComplete({VoidCallback onPressOk, BuildContext context}) {
    double height = MediaQuery.of(context).size.height / 1.5;
    double width = MediaQuery.of(context).size.width - 16;

    if (MediaQuery.of(context).size.height < 750) {
      height = MediaQuery.of(context).size.height - 10;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return HaegisaAlertCompleteDialog(
                  popUpWidth: width,
                  onPressOk: () {
                    onPressOk();
                  },
                  popUpHeight: height)
              .dialog();
        });
  }

  void submitSurvey({String bdxId}) async {
    DateTime now = DateTime.now();
    DateTime strDate = DateTime.parse(this.widget.startDate);
    DateTime endDate = DateTime.parse(this.widget.endDate);
    bool isContinue = false;
    if (strDate.difference(now).inDays <= 0) {
      if (endDate.difference(now).inDays >= 0) {
        isContinue = true;
      }
    }

    if (!isContinue) {
      showPopUpVotingComplete(
        onPressOk: () {
          Navigator.pop(this.myContext);
          Navigator.pop(this.myContext);
        },
        context: this.myContext,
      );

      return;
    }

    String q1 = "";
    String q2 = "";
    String q3 = "";
    String q4 = "";
    String q5 = "";
    String q6 = "";
    String q7 = "";
    String q8 = "";
    String q9 = "";
    String q10 = "";

    String qCnt = "";

    this.widget.surveysChecked.forEach((item) {
      qCnt = item.cnt;
      String itemX = "q${item.question}_${item.answer}";
      switch (int.parse(item.question)) {
        case 1:
          q1 = itemX;
          break;
        case 2:
          q2 = itemX;
          break;
        case 3:
          q3 = itemX;
          break;
        case 4:
          q4 = itemX;
          break;
        case 5:
          q5 = itemX;
          break;
        case 6:
          q6 = itemX;
          break;
        case 7:
          q7 = itemX;
          break;
        case 8:
          q8 = itemX;
          break;
        case 9:
          q9 = itemX;
          break;
        case 10:
          q10 = itemX;
          break;
      }
    });

    MainTabBar.myChild.getUserId(onGetUserId: (uid) {
      http.post(Statics.shared.urls.submitSurvey(), body: {
        'mode': 'submit',
        'userId': uid,
        'bd_idx': bdxId,
        'q_cnt': qCnt,
        'q1': q1,
        'q2': q2,
        'q3': q3,
        'q4': q4,
        'q5': q5,
        'q6': q6,
        'q7': q7,
        'q8': q8,
        'q9': q9,
        'q10': q10,
      }).then((val) {
        print(
            ":::::::::::::::::: Submitting survey was Successful. : ${val.body.toString()} ::::::::::::::::::");

        final String responseBody = utf8.decode(val.bodyBytes);
        Map<String, dynamic> body = json.decode(responseBody.trim());
        print("BODY SUMIT: ${body.toString()}");

        if (body['code'].toString() == "204") {
          this.widget.db.updateSurveyisDone(
              idx: bdxId,
              surveyDone: "TRUE",
              onUpdated: () {
                print(
                    ".....::::::::: SURVAY UPDAING DONE IN DATABASE :::::::::.....");
                if (Notices.staticNoticesPage != null &&
                    Notices.staticNoticesPage.myChild != null) {
                  Notices.staticNoticesPage.myChild.refreshNotices();
                }

                for (int i = 0; i < 8; i++) {
                  this.widget.db.selectSurveyAnswer(
                      idx: bdxId,
                      qNumber: "${i + 1}",
                      onResult: (results) {
                        results.forEach((item) {
                          if (item['result1'] != null) {
                            MainTabBar.mainTabBar.mdw.lastSurveyPercentages.add(
                                SurveyResultPercentageObject(
                                    qn: i + 1,
                                    res:
                                        int.parse(item['result1'].toString())));
                          }
                          if (item['result2'] != null) {
                            MainTabBar.mainTabBar.mdw.lastSurveyPercentages.add(
                                SurveyResultPercentageObject(
                                    qn: i + 1,
                                    res:
                                        int.parse(item['result2'].toString())));
                          }
                          if (item['result3'] != null) {
                            MainTabBar.mainTabBar.mdw.lastSurveyPercentages.add(
                                SurveyResultPercentageObject(
                                    qn: i + 1,
                                    res:
                                        int.parse(item['result3'].toString())));
                          }
                          if (item['result4'] != null) {
                            MainTabBar.mainTabBar.mdw.lastSurveyPercentages.add(
                                SurveyResultPercentageObject(
                                    qn: i + 1,
                                    res:
                                        int.parse(item['result4'].toString())));
                          }
                        });
                      });
                } // for loop

                this.widget.afterSubmit();
                setState(() {
                  this.widget.bottomButton = afterSurvey();
                  this.widget.surveyList = resultList();
                });
              });
          // already submitted
        } else if (body['code'].toString() == "200") {
          int qCnt = int.parse(body['table'][0]['q_cnt'].toString());
          for (int i = 0; i < qCnt; i++) {
            for (int j = 0; j < 4; j++) {
              String strPercent = body['table'][0]['q_title']['q${i + 1}_item']
                      ['q${i + 1}_${j + 1}_result_percent']
                  .toString();
              strPercent = strPercent.replaceAll("%", "");
              print(
                  "=====>>>> ${strPercent.toString()}  - q${i + 1}_${j + 1}_result_percent");

              int newNum = j + 1;
              int newNum2 = i + 1;
              this.widget.db.updateSurveyResult(
                  idx: body['table'][0]['bd_idx'].toString(),
                  resNum: "${newNum.toString()}",
                  qNumber: "${newNum2.toString()}",
                  result: strPercent,
                  onUpdated: () {
                    print(
                        ".....::::::::: SURVAY UPDAING (result${j + 1})={${strPercent.toString()}} RESULT IN DATABASE :::::::::.....");
                  });

              this.widget.db.updateSurveyisDone(
                  idx: body['table'][0]['bd_idx'].toString(),
                  surveyDone: "TRUE",
                  onUpdated: () {
                    print(
                        ".....::::::::: SURVAY UPDAING DONE IN DATABASE :::::::::.....");
                  });

              int percent = int.parse(strPercent);
              MainTabBar.mainTabBar.mdw.lastSurveyPercentages
                  .add(SurveyResultPercentageObject(qn: i + 1, res: percent));
            }
          }

          this.widget.afterSubmit();

          this.widget.db.selectSurveyAnswer(
              idx: this.widget.idx,
              onResult: (res) {
                this.widget.surveys = res;

                setState(() {
                  this.widget.bottomButton = afterSurvey();
                  this.widget.surveyList = resultList();
                });
              });

          // submit survey
        }
      }).catchError((error) {
        print(
            ":::::::::::::::::: error on sending Survey to Server : ${error.toString()} ::::::::::::::::::");
      });
    });
  }

  Container beforeSurvey() {
    return Container(
      height: 60,
      width: this.widget.popUpWidth,
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Expanded(
              child: Container(
            color: Statics.shared.colors.subTitleTextColor,
            alignment: Alignment.center,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0),
              ),
              child: Text(
                Strings.shared.dialogs.closeBtnTitle,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Statics.shared.fontSizes.content,
                    color: Colors.white),
              ),
              onPressed: () {
                this.widget.onPressClose();
              },
            ),
            width: (this.widget.popUpWidth - 16) / 2,
          )),
          Expanded(
              child: Container(
                  color: Statics.shared.colors.mainColor,
                  alignment: Alignment.center,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(0.0),
                    ),
                    child: Text(
                      Strings.shared.dialogs.submitBtnTitle,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Statics.shared.fontSizes.content,
                          color: Colors.white),
                    ),
                    onPressed: () {
                      // submit Survey
                      // Submit this Survey to Server ...
                      print("Connect To Server ........");

                      if (this.widget.surveysChecked.length == 0) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: new Text("알림"),
                                  content: new Text("항목을 선택하세요.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog

                                    new FlatButton(
                                      child: new Text(
                                        "확인",
                                        style: TextStyle(
                                            fontSize: Statics
                                                .shared.fontSizes.supplementary,
                                            color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ));
                      } else if (this.widget.surveys.length !=
                          this.widget.surveysChecked.length) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: new Text("알림"),
                                  content: new Text("항목을 선택하세요.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog

                                    new FlatButton(
                                      child: new Text(
                                        "확인",
                                        style: TextStyle(
                                            fontSize: Statics
                                                .shared.fontSizes.supplementary,
                                            color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ));
                      } else {
                        this.submitSurvey(
                            bdxId: this.widget.surveysChecked.first.idx);
                      }
                    },
                  ),
                  width: (this.widget.popUpWidth - 16) / 2)),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  Container afterSurvey() {
    return Container(
      height: 60,
      width: this.widget.popUpWidth,
      margin: const EdgeInsets.only(top: 15),
      child: Container(
          color: Statics.shared.colors.mainColor,
          alignment: Alignment.center,
          child: FlatButton(
            child: Text(
              Strings.shared.dialogs.closeBtnTitle,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Statics.shared.fontSizes.content,
                  color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          width: (this.widget.popUpWidth - 16) / 2),
    );
  }

  Container surveyList() {
    List<Widget> mySurveysList = [];
    for (int i = 0; i < widget.surveys.length; i++) {
      String number = (i + 1).toString();
      var selectItem =
          this.widget.surveySelect[0]["q_title"]["q" + (number) + "_item"];
      print(selectItem["q" + number]);
      mySurveysList.add(Padding(
        child: Text("${selectItem["q" + number]}"),
        padding: const EdgeInsets.only(bottom: 8),
      ));

      for (int j = 0; j < 4; j++) {
        if (this.widget.surveys[i]['q${j + 1}'] != null) {
          if (this.widget.surveys[i]['q${j + 1}'] != "") {
            // if 2

            int oldJ = j + 1;
            bool isChecked = false;
            this.widget.surveysChecked.forEach((val) {
              if (val.idx == this.widget.surveys[i]['surveyIdx'].toString() &&
                  val.cnt == this.widget.surveys[i]['qNumber'].toString()) {
                if (oldJ.toString() == val.answer) {
                  isChecked = true;
                }
              }
            });

            SurveyWidget sv = SurveyWidget(
              myIndex: j,
              width: this.widget.popUpWidth - 64,
              survey: this.widget.surveys[i]['q${j + 1}'],
              groupName: "voteGroup",
              itemIndex: i,
              isChecked: isChecked,
              isAfter: false,
              surveyIdx: this.widget.surveys[i]['surveyIdx'],
              qNum: this.widget.surveys[i]['qNumber'],
              onTappedTrue: () {
                int newJ = j + 1;
                this.widget.surveysChecked.removeWhere((item) =>
                    item.idx ==
                        this.widget.surveys[i]['surveyIdx'].toString() &&
                    item.cnt == this.widget.surveys[i]['qNumber'].toString());

                this.widget.surveysChecked.add(HaegisaAlertSurveyCheckedListObj(
                      Q: this.widget.surveys[i]['qNumber'],
                      A: newJ.toString(),
                      I: this.widget.surveys[i]['surveyIdx'],
                      cnt: this.widget.surveys[i]['qNumber'],
                    ));

                print(
                    "::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
                this.widget.surveysChecked.forEach((val) {
                  print(
                      "VALLLLLUUUU : ${val.question.toString()} -> ${val.answer}");
                });
                print(
                    "::::::::::::::::::::::::::::::::::::::::::::::::::::::::");

                setState(() {
                  this.widget.surveyList = surveyList();
                });
              },
            );
            mySurveysList.add(sv);
          } // if 2
        }
      } //loop2
    } //loop1

    return Container(
      child: ListView(
        children: mySurveysList,
      ),
      height: 220,
      padding: const EdgeInsets.only(left: 16, right: 16),
    );
  }

  Container resultList() {
    List<Widget> mySurveysList = [];

    for (int i = 0; i < widget.surveys.length; i++) {
      String number = (i + 1).toString();
      var selectItem =
          this.widget.surveySelect[0]["q_title"]["q" + (number) + "_item"];
      print(selectItem["q" + number]);
      mySurveysList.add(Padding(
        child: Text("${selectItem["q" + number]}"),
        padding: const EdgeInsets.only(bottom: 8),
      ));

      print(this.widget.surveys[i]['title']);
      print(this.widget.surveySelect[0]);

      for (int j = 0; j < 4; j++) {
        if (selectItem["q" + number + "_" + (j + 1).toString()] != null) {
          print("RESRES: ${this.widget.surveys[i]}");
          print(selectItem["q" + number + "_" + (j + 1).toString()]);
          mySurveysList.add(SurveyWidget(
              myIndex: j,
              p: double.parse(selectItem["q" +
                      number +
                      "_" +
                      (j + 1).toString() +
                      "_result_percent"]
                  .replaceAll("%", "")),
              surveyObj: selectItem,
              qNum: this.widget.surveys[i]['qNumber'].toString(),
              surveyIdx: this.widget.surveys[i]['surveyIdx'].toString(),
              width: this.widget.popUpWidth - 64,
              survey: selectItem["q" + number + "_" + (j + 1).toString()],
              groupName: "voteGroup",
              itemIndex: i,
              isChecked: true,
              isAfter: true));
        }
      } //loop2
    }
    return Container(
      child: ListView(
        children: mySurveysList,
      ),
      height: 220,
      padding: const EdgeInsets.only(left: 16, right: 16),
    );
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    super.initState();
  }

  void getSurveys({String uid, String idx}) async {
    String url = Statics.shared.urls.searchSurveys(uid, "view", idx);

    await http.get(url).then((val) {
      if (val.statusCode == 200) {
        print("OUTPUT: ${val.body.toString()}");
        final String responseBody = utf8.decode(val.bodyBytes);
        Map<String, dynamic> body = json.decode(responseBody.trim());
        if (body['code'] == "200") {
          setState(() {
            this.widget.surveySelect = body['table'];
          });
        }
      }
    }).catchError((error) {
      print(
          ":::::::::::::::::: on getting Survey error : ${error.toString()} ::::::::::::::::::");
    });
  }

  BuildContext myContext;

  @override
  Widget build(BuildContext context) {
    this.myContext = context;

    if (this.widget.surveySelect == null) {
      getSurveys(uid: userInformation.userID, idx: this.widget.idx);
    } else {
      print(this.widget.surveySelect);
      print(this.widget.surveySelect[0]["status"]);
      print(this.widget.surveySelect[0]["q_title"]["q1_item"]);
      if (this.widget.isFirst) {
        if (this.widget.surveySelect[0]["status"] == "N") {
          if (!DateTime.parse(this.widget.surveySelect[0]["end_date"])
              .isBefore(DateTime.now())) {
            this.widget.bottomButton = beforeSurvey();
            this.widget.surveyList = surveyList();
          } else {
            this.widget.bottomButton = afterSurvey();
            this.widget.surveyList = resultList();
          }
        } else {
          this.widget.bottomButton = afterSurvey();
          this.widget.surveyList = resultList();
        }
        this.widget.isFirst = false;
      }
    }

    return AlertDialog(
      content: Container(
        child: Column(
          children: [
            Container(
              child: Stack(
                children: [
                  Container(
                    child: Text(
                      Strings.shared.dialogs.survey,
                      style: TextStyle(
                          fontSize: Statics.shared.fontSizes.titleInContent,
                          color: Statics.shared.colors.titleTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                    padding: const EdgeInsets.only(left: 32),
                    alignment: Alignment.centerLeft,
                    height: this.widget.popUpWidth / 4,
                    color: Color.fromRGBO(244, 248, 255, 1),
                  ),
                  Container(
                    child: Image.asset(
                      "Resources/Images/ill_survey.png",
                      width: this.widget.popUpWidth / 4,
                    ),
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.only(right: 32),
                    height: this.widget.popUpWidth / 3.4,
                  )
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "Resources/Icons/icon_date.png",
                        height: 16,
                        width: 16,
                      ),
                      Text(
                        Strings.shared.dialogs.surveyingPeriod,
                        style: TextStyle(
                            color: Statics.shared.colors.mainColor,
                            fontSize: Statics.shared.fontSizes.supplementary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    this.widget.votingPeriod,
                    style: TextStyle(
                        color: Statics.shared.colors.titleTextColor,
                        fontSize: Statics.shared.fontSizes.supplementary),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
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
            SizedBox(height: 10),
            this.widget.surveyList, // survey List
            SizedBox(height: 30),
            this.widget.bottomButton,
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
