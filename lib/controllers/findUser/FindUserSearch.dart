import 'package:flutter/material.dart';
import 'package:haegisa2/models/SearchMembers/MemberObject.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';

class FindUserSearch extends StatefulWidget {
  FindUserSearch({ Key key }) : super(key: key);
  TextEditingController ctrlTxtSearch = TextEditingController();
  @override
  _FindUserSearchState createState() => _FindUserSearchState();
}

class _FindUserSearchState extends State<FindUserSearch> {

  final _scaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    widget.ctrlTxtSearch = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    Color iconSearchColor = Statics.shared.colors.mainColor;//Color.fromRGBO(241,244,250, 1);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(child: Text(Strings.shared.controllers.findUser.pageTitle, style: TextStyle(color: Statics.shared.colors.titleTextColor, fontSize: Statics.shared.fontSizes.subTitle)),margin: const EdgeInsets.only(left: 8)),
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Color.fromRGBO(0, 0, 0, 1)
        ),
      ),
      body: Container(child: Column(
        children: <Widget>[
          Container(child:
            TextField(
              autofocus: true,
              maxLines: 1,
              minLines: 1,
              controller: widget.ctrlTxtSearch,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: Strings.shared.controllers.findUser.searchPlaceHolder,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.only(left: 32, right: 32, top: 20, bottom: 20),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Color.fromRGBO(241,244,250, 1)), borderRadius: BorderRadius.all(Radius.circular(100))),
                hintStyle: TextStyle(
                    fontSize: Statics.shared.fontSizes.content,
                    color: Statics.shared.colors.subTitleTextColor
                ),
                suffixIcon: IconButton(
                  padding: const EdgeInsets.only(right: 8),
                  icon: Image.asset("Resources/Icons/icon_search.png", height: 22,alignment: Alignment.bottomRight,color: iconSearchColor),
                  onPressed: (){
                    if(widget.ctrlTxtSearch.text.isNotEmpty){

                    }// is Not Empty
                  },
                ),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
              ),
              style: TextStyle(
                fontSize: Statics.shared.fontSizes.content,
                color: Statics.shared.colors.titleTextColor,
              ),
            ),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
              height: 61,
              color: Colors.white,
          ),
          Container(child: ListView(
            children: [
              MemberObject(
                title: "±è½Â¿Ï",
                shortDescription: "ÇÑ*´ë 60±â",
                hasBlueBadge: true,
                onTapped: (){},
              ),
              MemberObject(
                title: "±è½Â¿Ï",
                shortDescription: "ÇÑ*´ë 60±â",
                hasBlueBadge: false,
                onTapped: (){},
              ),
            ],
            padding: const EdgeInsets.only(top: 20, bottom: 20),
          ), height: height - 141, color: Colors.white,),
        ],
      ),// Column
      ), // end Body
      key: _scaffold,
    );
  }
}
