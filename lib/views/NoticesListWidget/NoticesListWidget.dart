import 'package:flutter/material.dart';
import 'package:haegisa2/models/NoticesList/NoticesListObject.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';

class NoticesListWidget extends StatelessWidget {

  String title = "";
  VoidCallback onTap;
  NoticesListObject obj;

  NoticesListWidget({String title, VoidCallback onTap, NoticesListObject obj}){
    this.title = title;
    this.obj = obj;
    this.onTap = onTap;
  }

  @override
  Widget build(BuildContext context) {

    double paddingSize = 16;
    double buttonSize = 70;
    double screenWidth = MediaQuery.of(context).size.width;


    return FlatButton(
      child: Container(child: Row(
        children: [
          Container(width: buttonSize,child: Text("°øÁö", style: TextStyle(color: Statics.shared.colors.mainColor, fontWeight: FontWeight.w700, fontSize: Statics.shared.fontSizes.content)),
            alignment: Alignment.center,
          ),
          Column(
            children: <Widget>[
              Container(child: Text(this.title, style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.content)),width: (screenWidth - (paddingSize * 2)) - buttonSize,constraints: BoxConstraints(maxHeight: 45)),
              Container(child: Text(this.obj.writer, style: TextStyle(color: Statics.shared.colors.captionColor, fontSize: Statics.shared.fontSizes.small)),width: (screenWidth - (paddingSize * 2)) - buttonSize,padding: const EdgeInsets.only(top: 5)),
            ],
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
