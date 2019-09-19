import 'package:flutter/material.dart';
import 'package:haegisa2/models/iO/IOObject.dart';
import 'package:haegisa2/models/statics/statics.dart';

class IOWidget extends StatelessWidget {

  VoidCallback onTap;
  IOObject obj;

  IOWidget({VoidCallback onTap, IOObject obj}){
    this.obj = obj;
    this.onTap = onTap;
  }

  @override
  Widget build(BuildContext context) {

    double paddingSize = 16;
    double buttonSize = 120;
    double screenWidth = MediaQuery.of(context).size.width;

    return FlatButton(
      child: Container(child: Row(
        children: [
          Container(height: buttonSize,child: Image.network(this.obj.listImgUrl.replaceAll("https://", "http://")),
            alignment: Alignment.center,
          ),
          Padding(
            child: Column(
              children: <Widget>[
                Container(child: Text(this.obj.name, style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.content, fontWeight: FontWeight.w800)),width: (screenWidth - (paddingSize * 2)) - buttonSize,constraints: BoxConstraints(maxHeight: 45),height: 25,),
                Container(child: Text(this.obj.company, style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.medium, fontWeight: FontWeight.w100)),width: (screenWidth - (paddingSize * 2)) - buttonSize,padding: const EdgeInsets.only(top: 5),height: 25,),
                SizedBox(height: 5),
                Container(child: Text(this.obj.shortContent, style: TextStyle(color: Statics.shared.colors.captionColor, fontSize: Statics.shared.fontSizes.medium, fontWeight: FontWeight.w100)),width: (screenWidth - (paddingSize * 2)) - buttonSize,padding: const EdgeInsets.only(top: 5),height: 70,),
              ],
            ),
            padding: const EdgeInsets.only(top: 25, left: 16),
          ),
        ],
      ),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Statics.shared.colors.lineColor)),
        ),
        height: 170,
        margin: const EdgeInsets.only(left: 16,right: 16),
      ),
      padding: const EdgeInsets.all(0),
      onPressed: (){onTap();},
    );
  }
}
