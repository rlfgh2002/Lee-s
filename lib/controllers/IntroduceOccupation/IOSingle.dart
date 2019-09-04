import 'package:flutter/material.dart';
import 'package:haegisa2/models/iO/IOObject.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:carousel_slider/carousel_slider.dart';

class IOSingle extends StatefulWidget {

  IOObject object;

  IOSingle({IOObject obj})
  {
    this.object = obj;
  }

  @override
  _IOSingle createState() => _IOSingle();
}

class _IOSingle extends State<IOSingle> {

  final _scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    Widget blueSplitter = Container(color: Colors.blue,height: 3,margin: const EdgeInsets.only(left: 16,right: 16, bottom: 20, top: 10));
    Widget greySplitter = Container(color: Statics.shared.colors.lineColor,height: 1,margin: const EdgeInsets.only(left: 16,right: 16, bottom: 10, top: 10));
    Widget listBtn = Container(
      child: FlatButton(
        child: Container(
          child: Text(Strings.shared.controllers.noticesList.listKeyword,style: TextStyle(color: Statics.shared.colors.mainColor, fontSize: Statics.shared.fontSizes.subTitle, fontWeight: FontWeight.w600)),
          alignment: Alignment.center,
        ),
        onPressed: (){

        },
        padding: const EdgeInsets.all(0),
      ),
      decoration: BoxDecoration(border: Border.all(width: 2, color: Statics.shared.colors.mainColor)),
      width: screenWidth,
      height: 60,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20, right: 16, left: 16, bottom: 20),
    );

    List<Widget> myImages = [];
    if(this.widget.object.listImgUrl.isNotEmpty){
      myImages.add(Image.network(this.widget.object.listImgUrl.replaceAll("https://", "http://")));
    }
    if(this.widget.object.viewImgUrl_1.isNotEmpty){
      myImages.add(Image.network(this.widget.object.viewImgUrl_1.replaceAll("https://", "http://")));
    }
    if(this.widget.object.viewImgUrl_2.isNotEmpty){
      myImages.add(Image.network(this.widget.object.viewImgUrl_2.replaceAll("https://", "http://")));
    }

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
            Padding(child: Text(this.widget.object.name,
              style: TextStyle(
                fontSize: Statics.shared.fontSizes.subTitleInContent,
                color: Statics.shared.colors.titleTextColor,
                fontWeight: FontWeight.w600,
              ), // TextStyle
            ),padding: const EdgeInsets.only(left: 32, right: 32)),
            SizedBox(height: 5),
            Padding(child: Row(
              children: <Widget>[
                Text(this.widget.object.company,
                  style: TextStyle(
                    fontSize: Statics.shared.fontSizes.medium,
                    color: Statics.shared.colors.captionColor,
                    fontWeight: FontWeight.w300,
                  ), // TextStyle
                ),
              ], // Children
            ),padding: const EdgeInsets.only(left: 32, right: 32)),
            greySplitter,
            Container(
              height: 300,
              margin: const EdgeInsets.only(left: 32, right: 32, bottom: 20),
              child: CarouselSlider(
                items: myImages,
                height: 300,
              ),
            ),
            Padding(child: Text(this.widget.object.content,
              style: TextStyle(
                fontSize: Statics.shared.fontSizes.content,
                color: Statics.shared.colors.titleTextColor,
                fontWeight: FontWeight.w300,
              ), // TextStyle
            ),padding: const EdgeInsets.only(left: 32, right: 32)),
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
