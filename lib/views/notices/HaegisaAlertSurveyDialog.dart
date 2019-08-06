import 'package:flutter/material.dart';
import 'package:haegisa2/models/DataBase/MyDataBase.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/notices/SurveyWidget.dart';

class HaegisaAlertSurveyDialog extends StatefulWidget {

  final db = MyDataBase();


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
  List<String> votes = [];

  HaegisaAlertSurveyDialog({String idx,double popUpWidth = 0,double popUpHeight = 0,String content,String votingPeriod,List<String> votes, VoidCallback onPressClose, VoidCallback onPressApply}){
    this.content = content;
    this.votes = votes;
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
    List<SurveyWidget> mySurveysList = [];
    for(int i = 0; i < widget.votes.length; i++){
      mySurveysList.add(SurveyWidget(width: this.widget.popUpWidth - 64,survey: this.widget.votes[i],groupName: "voteGroup",itemIndex: i,result: 100,isChecked: false,isAfter: false,));
    }
    return Container(
      child: ListView(
        children: mySurveysList,
      ),
      height: 220,padding: const EdgeInsets.only(left: 16, right: 16),
    );
  }
  Container resultList() {

    List<SurveyWidget> mySurveysList = [];
    for(int i = 0; i < widget.votes.length; i++){
      double percent = 5;
      if(i == 0){
        percent = 95;
      }
      mySurveysList.add(SurveyWidget(width: this.widget.popUpWidth - 64,survey: this.widget.votes[i],groupName: "voteGroup",itemIndex: i,result: percent,isChecked: true,isAfter: true));
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
