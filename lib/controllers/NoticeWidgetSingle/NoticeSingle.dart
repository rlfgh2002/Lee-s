import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

class NoticeSingle extends StatefulWidget {
  Map<String, dynamic> object;

  NoticeSingle({Map<String, dynamic> obj}) {
    this.object = obj;
  }

  @override
  _NoticeSingle createState() => _NoticeSingle();
}

class _NoticeSingle extends State<NoticeSingle> {
  final _scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
        Colors.black // Dark == white status bar -- for IOS.
    ));

    double screenWidth = MediaQuery.of(context).size.width;
    Widget blueSplitter = Container(
        color: Statics.shared.colors.blueLineColor,
        height: 3,
        margin:
        const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 10));
    Widget greySplitter = Container(
        color: Statics.shared.colors.lineColor,
        height: 1,
        margin:
        const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10));

    String strDate = "";
    if(this.widget.object['date'] != null){
      strDate = this.widget.object['date'];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Container(
            alignment: Alignment.centerLeft,
            child: Text("",
                style: TextStyle(
                    color: Statics.shared.colors.titleTextColor,
                    fontSize: Statics.shared.fontSizes.subTitle,
                    fontWeight: FontWeight.bold)),
            margin: const EdgeInsets.only(left: 8)),
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
      ),
      body: Container(
        child: ListView(
          children: [
            blueSplitter,
            Padding(
                child: Text(this.widget.object['subject'], style: TextStyle(
                    fontSize: Statics.shared.fontSizes.subTitleInContent,
                    color: Statics.shared.colors.titleTextColor,
                    fontWeight: FontWeight.w600,
                  ), // TextStyle
                ),
                padding: const EdgeInsets.only(left: 32, right: 32)),
            SizedBox(height: 10),
            Padding(
                child: Row(
                  children: <Widget>[
                    Text(
                      this.widget.object['fromName'],
                      style: TextStyle(
                        fontSize: Statics.shared.fontSizes.medium,
                        color: Statics.shared.colors.captionColor,
                        fontWeight: FontWeight.w300,
                      ), // TextStyle
                    ),
                    SizedBox(width: 5),
                    Text(
                      "|",
                      style: TextStyle(
                        fontSize: Statics.shared.fontSizes.medium,
                        color: Statics.shared.colors.captionColor,
                        fontWeight: FontWeight.w100,
                      ), // TextStyle
                    ),
                    SizedBox(width: 5),
                    Text(
                      strDate,
                      style: TextStyle(
                        fontSize: Statics.shared.fontSizes.medium,
                        color: Statics.shared.colors.captionColor,
                        fontWeight: FontWeight.w300,
                      ), // TextStyle
                    )
                  ], // Children
                ),
                padding: const EdgeInsets.only(left: 32, right: 32)),
            greySplitter,
            HtmlView(
              data: this.widget.object['content'],
              scrollable: false,
              padding: const EdgeInsets.only(left: 32, right: 32),
            )
          ], // Children
        ),
        color: Colors.white,
      ), // end Body
      key: _scaffold,
    );
  }
}