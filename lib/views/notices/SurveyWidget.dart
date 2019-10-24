import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:haegisa2/models/statics/statics.dart';

class SurveyWidget extends StatefulWidget {

  int myIndex = 0;
  double width = 0;
  String survey = "";
  bool isChecked = false;
  bool isAfter = false;
  String groupName = "";
  int itemIndex = 1;
  String surveyIdx = "";
  String qNum = "";
  VoidCallback onTappedFalse;
  VoidCallback onTappedTrue;
  Map<String, dynamic> surveyObj;

  SurveyWidget({Map<String, dynamic> surveyObj,int myIndex,bool isChecked = false,double width = 0,String survey = "", String groupName = "", int itemIndex = 1, bool isAfter = false, String surveyIdx, String qNum, VoidCallback onTappedTrue}){
    this.myIndex = myIndex;
    this.width = width;
    this.survey = survey;
    this.groupName = groupName;
    this.itemIndex = itemIndex;
    this.isChecked = isChecked;
    this.isAfter = isAfter;
    this.surveyIdx = surveyIdx;
    this.qNum = qNum;
    this.onTappedTrue = onTappedTrue;
    this.surveyObj = surveyObj;
  }

  @override
  _SurveyWidgetState createState() => _SurveyWidgetState();
}

class _SurveyWidgetState extends State<SurveyWidget> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    Color progressColor = Color.fromRGBO(232, 240, 254, 1);
    double percent = (0 * (this.widget.width + 16) / 100);
    double p = 0;
    if(this.widget.surveyObj != null){
      if(this.widget.surveyObj['result${this.widget.myIndex + 1}'] != null){
        p = double.parse(this.widget.surveyObj['result${this.widget.myIndex + 1}']);
      }
      percent = (p * (this.widget.width + 16) / 100);
    }

    print("RESRES: ${percent} - ${p} - ${this.widget.survey}");

    if(this.widget.isAfter){
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: progressColor,
            ),
            width: percent,
            height: 50,
            padding: const EdgeInsets.only(left: 16,right: 16),
            margin: const EdgeInsets.only(bottom: 10),
          ),
          Container(
            child: FlatButton(
              onPressed: (){
                setState(() {
                  this.widget.isChecked = true;
                });
                this.widget.onTappedTrue();
              },
              padding: const EdgeInsets.all(0),
              child: Container(
                width: this.widget.width,
                child: Row(
                  children: [
                    Text(this.widget.survey,style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.content, fontWeight: FontWeight.normal),),
                    Text("${p.toString()}%",style: TextStyle(color: Statics.shared.colors.mainColor, fontSize: Statics.shared.fontSizes.supplementary, fontWeight: FontWeight.normal),),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Statics.shared.colors.subTitleTextColor,width: 1),
            ),
            //width: this.widget.width,
            padding: const EdgeInsets.only(left: 16,right: 16),
            margin: const EdgeInsets.only(bottom: 10),
          ),
        ],
      );
    }// after Survey
    else{
      if(this.widget.isChecked){
        return Container(
          child: FlatButton(
            onPressed: (){
              this.widget.onTappedTrue();
            },
            padding: const EdgeInsets.all(0),
            child: Container(
              width: this.widget.width,
              child: Row(
                children: [
                  Text(this.widget.survey,style: TextStyle(color: Statics.shared.colors.mainColor, fontSize: Statics.shared.fontSizes.content, fontWeight: FontWeight.normal),),
                  Icon(Icons.check, color: Statics.shared.colors.mainColor)
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Statics.shared.colors.mainColor,width: 1),
          ),
          width: this.widget.width,
          padding: const EdgeInsets.only(left: 16,right: 16),
          margin: const EdgeInsets.only(bottom: 10),
        );
      }// checked
      else{
        return Container(
          child: FlatButton(
            onPressed: (){
              this.widget.onTappedTrue();
            },
            padding: const EdgeInsets.all(0),
            child: Container(
              width: this.widget.width,
              child: Row(
                children: [
                  Text(this.widget.survey,style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.content, fontWeight: FontWeight.normal),),
                  Icon(Icons.check, color: Statics.shared.colors.subTitleTextColor)
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Statics.shared.colors.subTitleTextColor,width: 1),
          ),
          width: this.widget.width,
          padding: const EdgeInsets.only(left: 16,right: 16),
          margin: const EdgeInsets.only(bottom: 10),
        );
      }// not checked
    }// before Survey
  }
}
