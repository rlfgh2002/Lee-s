import 'package:flutter/material.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';

class MagazineWidget extends StatelessWidget {

  String title = "";
  bool isDownload = false;
  VoidCallback onTap;

  MagazineWidget({String title,bool isDownload = false, VoidCallback onTap}){
    this.title = title;
    this.isDownload = isDownload;
    this.onTap = onTap;
  }

  @override
  Widget build(BuildContext context) {

    double paddingSize = 16;
    double buttonSize = 100;
    double buttonRealSize = buttonSize - 10;
    double buttonHeight = 40;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget downloadButton = Container(
      child: Text(Strings.shared.controllers.magazines.downloadKeyword,style: TextStyle(color: Colors.white, fontSize: Statics.shared.fontSizes.content)),
      decoration: BoxDecoration(border: Border.all(width: 1.5, color: Statics.shared.colors.mainColor),color: Statics.shared.colors.mainColor),
      width: buttonRealSize,
      height: buttonHeight,
      alignment: Alignment.center,
    );
    Widget exampleButton = Container(
      child: Text(Strings.shared.controllers.magazines.exampleKeyword,style: TextStyle(color: Statics.shared.colors.mainColor, fontSize: Statics.shared.fontSizes.content)),
      decoration: BoxDecoration(border: Border.all(width: 1.5, color: Statics.shared.colors.mainColor)),
      width: buttonRealSize,
      height: buttonHeight,
      alignment: Alignment.center,
    );
    Widget selectedButton;
    if(this.isDownload){
      selectedButton = downloadButton;
    }else{
      selectedButton = exampleButton;
    }

    return FlatButton(
      child: Container(child: Row(
        children: [
          Container(child: Text(this.title, style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.content)),width: (screenWidth - (paddingSize * 2)) - buttonSize,),
          Container(width: buttonSize,child: selectedButton,
            alignment: Alignment.center,
          ),
        ],
      ),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Statics.shared.colors.lineColor)),
        ),
        height: 70,
        margin: const EdgeInsets.only(left: 16,right: 16),
      ),
      padding: const EdgeInsets.all(0),
      onPressed: (){onTap();},
    );
  }
}
