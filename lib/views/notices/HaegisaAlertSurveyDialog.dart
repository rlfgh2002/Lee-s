import 'package:flutter/material.dart';
import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:haegisa2/models/DataBase/MyDataBase.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/notices/SurveyWidget.dart';
import 'package:http/http.dart' as http;

class HaegisaAlertSurveyCheckedListObj
{
  String question = "";
  String answer = "";
  String idx = "";
  String cnt = "0";

  HaegisaAlertSurveyCheckedListObj({
  String Q,
  String A,
  String I,
  String cnt,
  }){
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

  VoidCallback onPressClose;
  VoidCallback onPressApply;

  String idx = "";
  bool isFirst = true;
  double popUpHeight = 0;
  double popUpWidth = 0;
  String content = "";
  String votingPeriod = "";
  List<Map<String, dynamic>> surveys = [];
  List<HaegisaAlertSurveyCheckedListObj> surveysChecked = [];

  HaegisaAlertSurveyDialog({String idx,double popUpWidth = 0,double popUpHeight = 0,String content,String votingPeriod,List<Map<String, dynamic>> surveys, VoidCallback onPressClose, VoidCallback onPressApply}){
    this.content = content;
    this.surveys = surveys;
    this.votingPeriod = votingPeriod;
    this.popUpWidth = popUpWidth;
    this.onPressApply = onPressApply;
    this.onPressClose = onPressClose;
    this.popUpHeight = popUpHeight;
    this.idx = idx;
  }

  @override
  _HaegisaAlertSurveyDialogState createState() => _HaegisaAlertSurveyDialogState();
}

class _HaegisaAlertSurveyDialogState extends State<HaegisaAlertSurveyDialog> {

  void checkItemManager(int item, bool val,int gId){

    for(int i=0;i<this.widget.voteGroupItems[gId].length;i++){
      this.widget.voteGroupItems[gId][i] = !val;
    }

    this.widget.voteGroupItems[gId][item] = val;
  }
  void submitSurvey({String bdxId}) async{

    String q1 = "";String q2 = "";String q3 = "";
    String q4 = "";String q5 = "";String q6 = "";
    String q7 = "";String q8 = "";String q9 = "";
    String q10 = "";

    String qCnt = "";

    this.widget.surveysChecked.forEach((item){
      qCnt = item.cnt;
      String itemX = "q${item.question}_${item.answer}";
      switch(int.parse(item.question)){
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

    MainTabBar.myChild.getUserId(onGetUserId: (uid){
      http.post(Statics.shared.urls.submitSurvey(),
          body: {
            'mode':'submit',
            'userId':uid,
            'bd_idx':bdxId,
            'q_cnt':qCnt,
            'q1':q1,
            'q2':q2,
            'q3':q3,
            'q4':q4,
            'q5':q5,
            'q6':q6,
            'q7':q7,
            'q8':q8,
            'q9':q9,
            'q10':q10,
          }
      ).then((val){
        print(":::::::::::::::::: Submitting survey was Successful. : ${val.body.toString()} ::::::::::::::::::");
      }).catchError((error){
        print(":::::::::::::::::: error on sending Survey to Server : ${error.toString()} ::::::::::::::::::");
      });
    });
  }

  Container beforeSurvey(){
    return Container(
      height: 60,
      width: this.widget.popUpWidth,
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Container(color: Statics.shared.colors.subTitleTextColor, child: FlatButton(child: Text(Strings.shared.dialogs.closeBtnTitle, style: TextStyle(fontWeight: FontWeight.bold,fontSize: Statics.shared.fontSizes.subTitleInContent, color: Colors.white),),onPressed: (){
            this.widget.onPressClose();
          },),width: (this.widget.popUpWidth-16) / 2,),
          Container(color: Statics.shared.colors.mainColor, child: FlatButton(child: Text(Strings.shared.dialogs.submitBtnTitle, style: TextStyle(fontWeight: FontWeight.bold,fontSize: Statics.shared.fontSizes.subTitleInContent, color: Colors.white),),onPressed: (){
            // submit Survey
            // Submit this Survey to Server ...
            print("Connect To Server ........");
            this.submitSurvey(bdxId: this.widget.surveysChecked.first.idx);
            setState(() {
              this.widget.bottomButton = afterSurvey();
              this.widget.surveyList = resultList();
            });
          },),width: (this.widget.popUpWidth-16) / 2),
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
      child: Container(color: Statics.shared.colors.mainColor, child: FlatButton(child: Text(Strings.shared.dialogs.closeBtnTitle, style: TextStyle(fontWeight: FontWeight.bold,fontSize: Statics.shared.fontSizes.subTitleInContent, color: Colors.white),),onPressed: (){
        Navigator.pop(context);
      },),width: (this.widget.popUpWidth-16) / 2),
    );
  }

  Container surveyList(){
    List<Widget> mySurveysList = [];
    for(int i = 0; i < widget.surveys.length; i++){
      mySurveysList.add(Padding(child: Text("${this.widget.surveys[i]['title']}"),padding: const EdgeInsets.only(bottom: 8),));
      for(int j = 0; j < 8; j++){
        if(this.widget.surveys[i]['q${j+1}'] != ""){
          mySurveysList.add(SurveyWidget(width: this.widget.popUpWidth - 64,survey: this.widget.surveys[i]['q${j+1}'],groupName: "voteGroup",itemIndex: i,result: 100,isChecked: false,isAfter: false,surveyIdx: this.widget.surveys[i]['surveyIdx'],qNum: this.widget.surveys[i]['qNumber']
          ,
            onTappedTrue: (){
            this.widget.surveysChecked.add(
                HaegisaAlertSurveyCheckedListObj(
                    Q: this.widget.surveys[i]['qNumber'],
                    A: (j+1).toString(),
                    I: this.widget.surveys[i]['surveyIdx'],
                    cnt: this.widget.surveys[i]['qNumber'],
                )
                );
            },
            onTappedFalse: (){
              int delIndex = 0;
              this.widget.surveysChecked.forEach((item){
                if(item.question == this.widget.surveys[i]['qNumber'] && item.answer == (j+1).toString() && item.idx == this.widget.surveys[i]['surveyIdx'])
                {
                  this.widget.surveysChecked.removeAt(delIndex);
                }
                delIndex++;
              });
            },
          ));
        }
      }//loop2
    }//loop1
    return Container(
      child: ListView(
        children: mySurveysList,
      ),
      height: 220,padding: const EdgeInsets.only(left: 16, right: 16),
    );
  }
  Container resultList() {

    List<Widget> mySurveysList = [];
    for(int i = 0; i < widget.surveys.length; i++){
      double percent = 5;
      if(i == 0){
        percent = 95;
      }

      mySurveysList.add(Padding(child: Text("${this.widget.surveys[i]['title']}"),padding: const EdgeInsets.only(bottom: 8),));
      for(int j = 0; j < 8; j++){
        if(this.widget.surveys[i]['q${j+1}'] != ""){
          mySurveysList.add(SurveyWidget(width: this.widget.popUpWidth - 64,survey: this.widget.surveys[i]['q${j+1}'],groupName: "voteGroup",itemIndex: i,result: percent,isChecked: true,isAfter: true));
        }
      }//loop2
    }
    return Container(
      child: ListView(
        children: mySurveysList,
      ),
      height: 220,padding: const EdgeInsets.only(left: 16, right: 16),
    );
  }

  @override
  Widget build(BuildContext context) {

    if(this.widget.isFirst){
      this.widget.bottomButton = beforeSurvey();
      this.widget.surveyList = surveyList();
      this.widget.isFirst = false;
    }

    return AlertDialog(
      content: Container(
        child: Column(
          children: [
            Container(width: this.widget.popUpWidth,color: Statics.shared.colors.mainColor,height: 5,),
            Container(child: Stack(
              children: [
                Container(
                  child: Text(Strings.shared.dialogs.survey, style: TextStyle(fontSize: Statics.shared.fontSizes.title, color: Statics.shared.colors.titleTextColor, fontWeight: FontWeight.bold),),
                  padding: const EdgeInsets.only(left: 32),
                  alignment: Alignment.centerLeft,
                  height: 100,
                  color: Color.fromRGBO(244, 248, 255, 1),
                ),
                Container(
                  child: Image.asset("Resources/Images/ill_survey.png", width: this.widget.popUpWidth/2.6,),alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.only(right: 32),
                  margin: const EdgeInsets.only(top: 20),
                  height: 100,
                )
              ],
            ),),
            SizedBox(height: 30),
            Container(padding: const EdgeInsets.only(left: 32, right: 32),
              child: Row(
                children: [
                  Image.asset("Resources/Icons/icon_date.png",height: 16,width: 16,),
                  SizedBox(width: 5),
                  Text(Strings.shared.dialogs.surveyingPeriod,style: TextStyle(color: Statics.shared.colors.mainColor, fontSize: Statics.shared.fontSizes.supplementary, fontWeight: FontWeight.bold),),
                  SizedBox(width: 5),
                  Text(this.widget.votingPeriod,style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.supplementary),),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            ),
            Container(child: Text(this.widget.content,style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.content),),padding: const EdgeInsets.only(left: 32, right: 32, top: 20, bottom: 10),),
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
