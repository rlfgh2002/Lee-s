import 'package:flutter/material.dart';
import 'package:haegisa2/models/NoticesList/NoticesListObject.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/views/NoticesListWidget/NoticesListWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html_view/flutter_html_view.dart';

class NoticesListSingle extends StatefulWidget {

  NoticesListObject object;

  NoticesListSingle({NoticesListObject obj})
  {
    this.object = obj;
  }

  @override
  _NoticesListSingleState createState() => _NoticesListSingleState();
}

class _NoticesListSingleState extends State<NoticesListSingle> {

  final _scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    Widget blueSplitter = Container(color: Statics.shared.colors.blueLineColor,height: 3,margin: const EdgeInsets.only(left: 16,right: 16, bottom: 20, top: 10));
    Widget greySplitter = Container(color: Statics.shared.colors.lineColor,height: 1,margin: const EdgeInsets.only(left: 16,right: 16, bottom: 10, top: 10));
    Widget listBtn = Container(
      child: FlatButton(
        child: Container(
          child: Text(Strings.shared.controllers.noticesList.listKeyword,style: TextStyle(color: Statics.shared.colors.mainColor, fontSize: Statics.shared.fontSizes.supplementary, fontWeight: FontWeight.w200)),
          alignment: Alignment.center,
        ),
        onPressed: (){

        },
        padding: const EdgeInsets.all(0),
      ),
      decoration: BoxDecoration(border: Border.all(width: 1, color: Statics.shared.colors.mainColor)),
      width: screenWidth,
      height: 60,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20, right: 16, left: 16, bottom: 20),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(child: Text("", style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.subTitle)),margin: const EdgeInsets.only(left: 8)),
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Color.fromRGBO(0, 0, 0, 1)
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            blueSplitter,
            Padding(child: Text(this.widget.object.subject,
              style: TextStyle(
                fontSize: Statics.shared.fontSizes.subTitleInContent,
                color: Statics.shared.colors.titleTextColor,
                fontWeight: FontWeight.w600,
              ), // TextStyle
            ),padding: const EdgeInsets.only(left: 32, right: 32)),
            SizedBox(height: 10),
            Padding(child: Row(
              children: <Widget>[
                Text(this.widget.object.writer,
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.medium,
                    color: Statics.shared.colors.captionColor,
                    fontWeight: FontWeight.w300,
                  ), // TextStyle
                ),
                SizedBox(width: 10),
                Text("|",
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.medium,
                    color: Statics.shared.colors.captionColor,
                    fontWeight: FontWeight.w300,
                  ), // TextStyle
                ),
                SizedBox(width: 10),
                Text(this.widget.object.regDate,
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.medium,
                    color: Statics.shared.colors.captionColor,
                    fontWeight: FontWeight.w300,
                  ), // TextStyle
                )
              ], // Children
            ),padding: const EdgeInsets.only(left: 32, right: 32)),
            greySplitter,
            HtmlView(
              data: this.widget.object.content,
              scrollable: false,
              padding: const EdgeInsets.only(left: 32, right: 32),
            )
            ,
            greySplitter,
            listBtn
          ],// Children
        ),
        color: Colors.white,
      ), // end Body
      key: _scaffold,
    );
  }
}
