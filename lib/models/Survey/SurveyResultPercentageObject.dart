import 'package:flutter/material.dart';

class SurveyResultPercentageObject
{
  int qNumber = 0;
  int result = 0;

  SurveyResultPercentageObject({int qn = 0,int res = 0}){
    this.qNumber = qn;
    this.result = res;
  }
}