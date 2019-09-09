import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:haegisa2/controllers/home/Home.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Occasion extends StatefulWidget {
  @override
  _OccasionState createState() => _OccasionState();
}

class _OccasionState extends State<Occasion> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedRadio = 0;

  TextEditingController _nameController;
  TextEditingController _birthController;
  TextEditingController _companyController;
  TextEditingController _phoneController;
  TextEditingController _dateController;

  String _moneySelectedValue;
  String _weddingSelectedValue;
  String _deatTypeSelectedValue;

  bool _nameChecked = false;
  bool _birthChecked = false;
  bool _companyChecked = false;
  bool _phoneChecked = false;
  bool _bankUserChecked = false;
  bool _bankNameChecked = false;
  bool _bankNumberChecked = false;
  bool _addressChecked = false;
  bool _dateChecked = false;
  bool _etcChecked = false;

  String name;
  String birth;
  String company;
  String phone;
  String bankUser;
  String bankName;
  String bankNumber;
  String address;
  String date;
  String etc;

  int radioType;

  String _value = '';
  void _setDate() {
    Navigator.of(context).pop();
  }

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  void initState() {
    super.initState();
    _nameController = new TextEditingController(text: name);
    _birthController = new TextEditingController(text: birth);
    _companyController = new TextEditingController(text: company);
    _phoneController = new TextEditingController(text: phone);
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    setSelectedRadio(int val) {
      setState(() {
        selectedRadio = val;
      });
    }
    //we omitted the brackets '{}' and are using fat arrow '=>' instead, this is dart syntax

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("경조사 통보",
            style: TextStyle(
                color: Statics.shared.colors.titleTextColor,
                fontSize: Statics.shared.fontSizes.title)),
        titleSpacing: 16.0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
      ),
      body: Column(children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Container(
                height: deviceHeight / 5,
                child: Image.asset(
                  "Resources/Images/occasion.png",
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 2.5, top: 2.5),
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 12,
                        child: txtField("Y", _nameController,
                            TextInputType.text, "이름", name, _nameChecked)),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 2.5, top: 2.5),
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 12,
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 12,
                        child: DateTimeField(
                          readOnly: true,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: Statics.shared.fontSizes.subTitle,
                                color: Statics.shared.colors.subTitleTextColor,
                              ),
                              border: OutlineInputBorder(),
                              hintText: "생년월일"),
                          format: DateFormat("yyyy-MM-dd"),
                          onChanged: (DateTime value) {
                            birth = DateFormat("yyyy-MM-dd").format(value);
                            print(birth);
                          },
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                          },
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 2.5, top: 2.5),
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 12,
                        child: txtField(
                            "Y",
                            _companyController,
                            TextInputType.text,
                            "회사명",
                            company,
                            _companyChecked)),
                    Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 2.5, top: 2.5),
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 12,
                        child: txtField(
                            "Y",
                            _phoneController,
                            TextInputType.number,
                            "휴대폰번호",
                            phone,
                            _phoneChecked)),
                    Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 10,
                          top: 5,
                          bottom: 5,
                        ),
                        alignment: Alignment.centerLeft,
                        height: MediaQuery.of(context).size.height / 12,
                        child: Text("경조사 구분",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Statics.shared.colors.titleTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    Statics.shared.fontSizes.supplementary))),
                    new Container(
                        child: Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                              value: 1,
                              groupValue: selectedRadio,
                              activeColor: Colors.blue,
                              onChanged: (val) {
                                print("Radio $val");
                                setSelectedRadio(val);
                              },
                            ),
                            Text("결혼"),
                            SizedBox(width: 40),
                            Radio(
                              value: 2,
                              groupValue: selectedRadio,
                              activeColor: Colors.blue,
                              onChanged: (val) {
                                print("Radio $val");
                                setSelectedRadio(val);
                              },
                            ),
                            Text("별세(부고)"),
                          ],
                        ),
                      ],
                    )),
                    Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 5,
                        ),
                        alignment: Alignment.centerLeft,
                        child: selectForm()),
                    SizedBox(height: 40),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            padding: EdgeInsets.all(20),
                            color: Statics.shared.colors.mainColor,
                            child: Text("보내기",
                                style: TextStyle(
                                    fontSize:
                                        Statics.shared.fontSizes.titleInContent,
                                    color: Colors.white)),
                            onPressed: () async {
                              var infomap = new Map<String, dynamic>();
                              infomap["id"] = userInformation.userID;
                              infomap["memberIdx"] = userInformation.userIdx;
                              infomap["name"] = name;
                              infomap["birth"] = birth;

                              return;
                            }))
                  ])
            ],
          ),
        )
      ]),
    );
  }

  getfeeList() async {
    var map = new Map<String, dynamic>();
    map["mode"] = "list";
    map["userId"] = userInformation.userID;

    return await getfeeListJson(
        Strings.shared.controllers.jsonURL.feeHistoryJson,
        body: map);
  }

  Future<List> getfeeListJson(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;
      //final String responseBody = response.body; //한글 깨짐
      final String responseBody = utf8.decode(response.bodyBytes);
      var responseJSON = json.decode(responseBody);
      var code = responseJSON["code"];

      if (statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        if (code == 200) {
          return responseJSON["rows"];
        }
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

//Common = "Y" //초기화되지 않는 값
  Widget txtField(common, controller, inputType, hint, content, checked) {
    return TextField(
      controller: common == "Y" ? controller : null,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.left,
      keyboardType: inputType,
      decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: Statics.shared.fontSizes.subTitle,
            color: Statics.shared.colors.subTitleTextColor,
          ),
          border: OutlineInputBorder(),
          hintText: hint),
      obscureText: false, // decoration
      onChanged: (String str) {
        content = str;
        if (str.length > 0) {
          checked = true;
        } else {
          checked = false;
        }
      },
    );
  }

  selectForm() {
    print(selectedRadio);
    if (selectedRadio == 1) {
      return weddingForm();
    } else if (selectedRadio == 2) {
      return deathForm();
    }
  }

  Widget weddingForm() {
    List<KeyValueModel> _money = [
      KeyValueModel(key: "경조비 지급방식 선택", value: "0"),
      KeyValueModel(key: "화환", value: "1"),
      KeyValueModel(key: "축의금[계좌이체]", value: "2")
    ];

    List<KeyValueModel> _wedding = [
      KeyValueModel(key: "선택", value: "0"),
      KeyValueModel(key: "본인결혼", value: "1"),
      KeyValueModel(key: "자녀결혼", value: "2")
    ];

    return Column(children: <Widget>[
      Container(
        width: deviceWidth,
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 2.5, top: 2.5),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            border:
                new Border.all(color: Statics.shared.colors.subTitleTextColor)),
        child: DropdownButton<String>(
          hint: Text('경조비 지급방식 선택'),
          style: TextStyle(
            fontSize: Statics.shared.fontSizes.subTitle,
            color: Statics.shared.colors.titleTextColor,
          ), // Not necessary for Option 1
          value: _moneySelectedValue,
          onChanged: (String newValue) {
            setState(() {
              _moneySelectedValue = newValue;
            });
          },
          items: _money.map((data) {
            return DropdownMenuItem<String>(
              child: new Text(data.key),
              value: data.value,
            );
          }).toList(),
        ),
      ),
      Container(
          child: _moneySelectedValue == "2"
              ? Column(
                  children: <Widget>[
                    SizedBox(height: 5),
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 12,
                        child: txtField("N", null, TextInputType.text, "예금주명",
                            bankUser, _bankUserChecked)),
                    SizedBox(height: 5),
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 12,
                        child: txtField("N", null, TextInputType.text, "은행명",
                            bankName, _bankNameChecked)),
                    SizedBox(height: 5),
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 12,
                        child: txtField("N", null, TextInputType.text, "계좌번호",
                            bankNumber, _bankNumberChecked)),
                  ],
                )
              : null),
      SizedBox(height: 5),
      Container(
        width: deviceWidth,
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 2.5, top: 2.5),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            border:
                new Border.all(color: Statics.shared.colors.subTitleTextColor)),
        child: DropdownButton<String>(
          hint: Text('선택'),
          style: TextStyle(
            fontSize: Statics.shared.fontSizes.subTitle,
            color: Statics.shared.colors.titleTextColor,
          ), // Not necessary for Option 1
          value: _weddingSelectedValue,
          onChanged: (String newValue) {
            setState(() {
              _weddingSelectedValue = newValue;
            });
          },
          items: _wedding.map((data) {
            return DropdownMenuItem<String>(
              child: new Text(data.key),
              value: data.value,
            );
          }).toList(),
        ),
      ),
      SizedBox(height: 5),
      Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 12,
          child: txtField("N", null, TextInputType.text, "결혼식장명 및 주소", address,
              _addressChecked)),
      SizedBox(height: 5),
      Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height / 12,
        child: DateTimeField(
          readOnly: true,
          controller: _dateController,
          decoration: InputDecoration(
              hintStyle: TextStyle(
                fontSize: Statics.shared.fontSizes.subTitle,
                color: Statics.shared.colors.subTitleTextColor,
              ),
              border: OutlineInputBorder(),
              hintText: "결혼식 일시"),
          format: DateFormat("yyyy-MM-dd"),
          onChanged: (DateTime value) {
            date = DateFormat("yyyy-MM-dd").format(value);
            print(date);
          },
          onShowPicker: (context, currentValue) {
            return showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));
          },
        ),
      ),
      SizedBox(height: 5),
      Container(
        height: MediaQuery.of(context).size.height / 6,
        child: TextField(
          maxLines: 200,
          decoration: InputDecoration(
              hintStyle: TextStyle(
                fontSize: Statics.shared.fontSizes.subTitle,
                color: Statics.shared.colors.subTitleTextColor,
              ),
              border: OutlineInputBorder(),
              hintText: "비고"),
          obscureText: false, // decoration
          onChanged: (String str) {},
        ),
      ),
    ]);
  }

  Widget deathForm() {
    List<KeyValueModel> _money = [
      KeyValueModel(key: "경조비 지급방식 선택", value: "0"),
      KeyValueModel(key: "화환", value: "1"),
      KeyValueModel(key: "축의금[계좌이체]", value: "2"),
    ];

    List<KeyValueModel> _deatType = [
      KeyValueModel(key: "선택", value: "0"),
      KeyValueModel(key: "본인사망", value: "1"),
      KeyValueModel(key: "배우자���", value: "2"),
      KeyValueModel(key: "부친상", value: "3"),
      KeyValueModel(key: "모친상", value: "4"),
      KeyValueModel(key: "빙부상", value: "5"),
      KeyValueModel(key: "빙모상", value: "6")
    ];

    return Column(children: <Widget>[
      Container(
        width: deviceWidth,
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 2.5, top: 2.5),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            border:
                new Border.all(color: Statics.shared.colors.subTitleTextColor)),
        child: DropdownButton<String>(
          hint: Text('경조비 지급방식 선택'),
          style: TextStyle(
            fontSize: Statics.shared.fontSizes.subTitle,
            color: Statics.shared.colors.titleTextColor,
          ), // Not necessary for Option 1
          value: _moneySelectedValue,
          onChanged: (String newValue) {
            setState(() {
              _moneySelectedValue = newValue;
            });
          },
          items: _money.map((data) {
            return DropdownMenuItem<String>(
              child: new Text(data.key),
              value: data.value,
            );
          }).toList(),
        ),
      ),
      Container(
          child: _moneySelectedValue == "2"
              ? Column(
                  children: <Widget>[
                    SizedBox(height: 5),
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 12,
                        child: txtField("N", null, TextInputType.text, "예금주명",
                            bankUser, _bankUserChecked)),
                    SizedBox(height: 5),
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 12,
                        child: txtField("N", null, TextInputType.text, "은행명",
                            bankName, _bankNameChecked)),
                    SizedBox(height: 5),
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 12,
                        child: txtField("N", null, TextInputType.text, "계좌번호",
                            bankNumber, _bankNumberChecked)),
                  ],
                )
              : null),
      SizedBox(height: 5),
      Container(
        width: deviceWidth,
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 2.5, top: 2.5),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            border:
                new Border.all(color: Statics.shared.colors.subTitleTextColor)),
        child: DropdownButton<String>(
          hint: Text('선택'),
          style: TextStyle(
            fontSize: Statics.shared.fontSizes.subTitle,
            color: Statics.shared.colors.titleTextColor,
          ), // Not necessary for Option 1
          value: _deatTypeSelectedValue,
          onChanged: (String newValue) {
            setState(() {
              _deatTypeSelectedValue = newValue;
            });
          },
          items: _deatType.map((data) {
            return DropdownMenuItem<String>(
              child: new Text(data.key),
              value: data.value,
            );
          }).toList(),
        ),
      ),
      SizedBox(height: 5),
      Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 12,
          child: txtField("N", null, TextInputType.text, "장례식장명 및 주소", address,
              _addressChecked)),
      SizedBox(height: 5),
      Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height / 12,
        child: DateTimeField(
          readOnly: true,
          decoration: InputDecoration(
              hintStyle: TextStyle(
                fontSize: Statics.shared.fontSizes.subTitle,
                color: Statics.shared.colors.subTitleTextColor,
              ),
              border: OutlineInputBorder(),
              hintText: "발인 일시"),
          format: DateFormat("yyyy-MM-dd"),
          onChanged: (DateTime value) {
            date = DateFormat("yyyy-MM-dd").format(value);
            print(date);
          },
          onShowPicker: (context, currentValue) {
            return showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));
          },
        ),
      ),
      SizedBox(height: 5),
      Container(
        height: MediaQuery.of(context).size.height / 6,
        child: TextField(
          maxLines: 200,
          decoration: InputDecoration(
              hintStyle: TextStyle(
                fontSize: Statics.shared.fontSizes.subTitle,
                color: Statics.shared.colors.subTitleTextColor,
              ),
              border: OutlineInputBorder(),
              hintText: "비고"),
          obscureText: false, // decoration
          onChanged: (String str) {},
        ),
      ),
    ]);
  }

  Widget feeListview(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;

    if (values != null) {
      return ListView(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            for (var item in values)
              Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 5,
                  ),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 12,
                  child: Row(children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      child: Text(item["payDate"],
                          style: TextStyle(
                              color: Statics.shared.colors.titleTextColor,
                              fontSize:
                                  Statics.shared.fontSizes.supplementary)),
                    ),
                    new Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 1.8,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Text(item["companyName"],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Statics.shared.colors.titleTextColor,
                                fontSize:
                                    Statics.shared.fontSizes.supplementary,
                              )),
                        ],
                      ),
                    ),
                    Spacer(),
                    new Container(
                      child: Text(item["money"],
                          style: TextStyle(
                            color: Statics.shared.colors.titleTextColor,
                            fontSize: Statics.shared.fontSizes.supplementary,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ])),
            Row(children: <Widget>[
              Expanded(child: Divider(height: 0)),
            ]),
          ],
        )
      ]);
    } else {
      return Container(
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 20),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 12,
          child: Container(
            child: Column(children: <Widget>[
              Image.asset(
                "Resources/Icons/none.png",
                scale: 4.0,
              ),
              SizedBox(height: 10),
              Text(
                "최근 1년간 납부내역이 없습니다.",
                style: TextStyle(
                    color: Statics.shared.colors.titleTextColor,
                    fontSize: Statics.shared.fontSizes.subTitleInContent),
              )
            ]),
          ));
    }
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2019));
    if (picked != null) setState(() => _value = picked.toString());
  }
}

class KeyValueModel {
  String key;
  String value;

  KeyValueModel({this.key, this.value});
}
