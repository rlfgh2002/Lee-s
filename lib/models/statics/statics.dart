import 'other/SpecifiedColors.dart';
import 'other/SpecifiedFontSizes.dart';
import 'other/URLS.dart';

class Statics
{
  static Statics shared = Statics();
  _Statics(){}

  final SpecifiedColors colors = SpecifiedColors();
  final SpecifiedFontSizes fontSizes = SpecifiedFontSizes();
  final URLS urls = URLS();
}