import 'package:flutter/material.dart';

class MiddleWare
{
  static MiddleWare shared = MiddleWare();
  _MiddleWare(){}

  double screenWidth = 0;
  Widget topBarWidget;
}