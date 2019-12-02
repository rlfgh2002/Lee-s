import 'dart:convert';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/home/Home.dart';
import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import 'Profile.dart';

class Occasion extends StatefulWidget {
  @override
  _OccasionState createState() => _OccasionState();
}

class _OccasionState extends State<Occasion> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int holidayType = 0;

  TextEditingController _nameController;
  TextEditingController _birthController;
  TextEditingController _companyController;
  TextEditingController _phoneController;
  TextEditingController _dateController;
  TextEditingController _positionController;

  String _moneySelectedValue;
  String _weddingSelectedValue;
  String _deathTypeSelectedValue;

  bool _nameChecked = false;
  bool _birthChecked = false;
  bool _companyChecked = false;
  bool _positionChecked = false;
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
  String position;
  String phone;
  String bankUser;
  String bankName;
  String bankNumber;
  String address;
  String date;
  String etc;
  String filePath;
  int radioType;

  String _value = '';

  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _fileController = new TextEditingController();

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
    _fileController.addListener(() => _extension = _fileController.text);
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension);
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(
              type: _pickingType, fileExtension: _extension);
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        if (path.extension(nullCheck(_path).toLowerCase()) != ".jpeg" &&
            path.extension(nullCheck(_path).toLowerCase()) != ".jpg" &&
            path.extension(nullCheck(_path).toLowerCase()) != ".png" &&
            path.extension(nullCheck(_path).toLowerCase()) != ".gif") {
          _loadingPath = false;
          _fileName = "";
          _path = "";
          return _displaySnackBar(context, "이미지 파일만 업로드 할 수 있습니다.");
        } else {
          File imageFile = new File(_path);
          // get file length
          var length = imageFile.lengthSync();

          if (length > 10485760) {
            _loadingPath = false;
            _fileName = "";
            _path = "";
            return _displaySnackBar(context, "용량을 초과하였습니다. (10M이하)");
          } else {
            _loadingPath = false;
            _fileName = _path != null
                ? _path.split('/').last
                : _paths != null ? _paths.keys.toString() : _fileName;
          }
        }
      });
    }
    _fileController = new TextEditingController(text: _fileName);

    print(_path);
    print(_paths);
    filePath = _path;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    setSelectedRadio(int val) {
      setState(() {
        holidayType = val;
      });
    }
    //we omitted the brackets '{}' and are using fat arrow '=>' instead, this is dart syntax

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("경조사 통보",
            style: TextStyle(
                color: Statics.shared.colors.titleTextColor,
                fontSize: Statics.shared.fontSizes.subTitle,
                fontWeight: FontWeight.bold)),
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
                        height: MediaQuery.of(context).size.height / 11,
                        child: txtField("name", _nameController,
                            TextInputType.text, 10, "이름", name, _nameChecked)),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 2.5, top: 2.5),
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 11,
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 11,
                        child: DateTimeField(
                          readOnly: true,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: Statics.shared.fontSizes.subTitle,
                                color: Statics.shared.colors.subTitleTextColor,
                              ),
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(
                                color: Statics.shared.colors.subTitleTextColor,
                              ),
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
                                lastDate: DateTime(2100),
                                locale: const Locale('ko', 'KR'));
                          },
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 2.5, top: 2.5),
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 11,
                        child: txtField(
                            "company",
                            _companyController,
                            TextInputType.text,
                            20,
                            "회사명",
                            company,
                            _companyChecked)),
                    Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 2.5, top: 2.5),
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 11,
                        child: txtField(
                            "position",
                            _positionController,
                            TextInputType.text,
                            20,
                            "직책",
                            position,
                            _positionChecked)),
                    Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 2.5, top: 2.5),
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 11,
                        child: txtField(
                            "phone",
                            _phoneController,
                            TextInputType.number,
                            11,
                            "휴대폰번호",
                            phone,
                            _phoneChecked)),
                    SizedBox(height: 30),
                    Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 10,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text("경조사 구분",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Statics.shared.colors.titleTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: Statics.shared.fontSizes.subTitle))),
                    new Container(
                        child: Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                              value: 1,
                              groupValue: holidayType,
                              activeColor: Colors.blue,
                              onChanged: (val) {
                                print("Radio $val");
                                setSelectedRadio(val);
                              },
                            ),
                            Text("결혼",
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.subTitle)),
                            SizedBox(width: 40),
                            Radio(
                              value: 2,
                              groupValue: holidayType,
                              activeColor: Colors.blue,
                              onChanged: (val) {
                                print("Radio $val");
                                setSelectedRadio(val);
                              },
                            ),
                            Text("별세(부고)",
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize:
                                        Statics.shared.fontSizes.subTitle)),
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
                  ])
            ],
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: EdgeInsets.all(20),
                color: Statics.shared.colors.mainColor,
                child: Text("보내기",
                    style: TextStyle(
                        fontSize: Statics.shared.fontSizes.titleInContent,
                        color: Colors.white)),
                onPressed: () async {
                  //print(File(filePath));
                  if (filePath == null) {
                    filePath = "";
                  }
                  if (name == null || name.length == 0) {
                    _displaySnackBar(context, "이름을 입력하세요.");
                    return;
                  }

                  if (birth == null || birth.length == 0) {
                    _displaySnackBar(context, "생년월일을 입력하세요.");
                    return;
                  }

                  if (phone == null || phone.length == 0) {
                    _displaySnackBar(context, "휴대폰 번호를 입력하세요.");
                    return;
                  }

                  if (holidayType == 0 || holidayType == null) {
                    _displaySnackBar(context, "경조사 구분을 선택하세요.");
                    return;
                  }

                  if (holidayType == 1 || holidayType == 2) {
                    if (date == null || date.length == 0) {
                      if (holidayType == 1) {
                        _displaySnackBar(context, "결혼식 일시를 입력하세요.");
                        return;
                      } else if (holidayType == 2) {
                        _displaySnackBar(context, "발인 일시를 입력하세요.");
                        return;
                      }
                    }

                    if (address == null || address.length == 0) {
                      if (holidayType == 1) {
                        _displaySnackBar(context, "결혼식장명 및 주소를 입력하세요.");
                        return;
                      } else if (holidayType == 2) {
                        _displaySnackBar(context, "장례식장명 및 주소를 입력하세요.");
                        return;
                      }
                    }
                  }

                  var postMap = new Map<String, dynamic>();
                  postMap["mode"] = "submit";
                  postMap["upfile01"] = filePath;
                  postMap["user_id"] = userInformation.userID;
                  postMap["email"] = userInformation.email;
                  postMap["user_name"] = userInformation.fullName;
                  postMap["user_idx"] = userInformation.userIdx;
                  postMap["member_type"] = userInformation.memberType;
                  postMap["member_name"] = name;
                  postMap["birth"] = birth;
                  postMap["company"] = company;
                  postMap["position"] = position;
                  postMap["phone"] = phone;
                  postMap["holiday_type"] = holidayType.toString();
                  if (holidayType == 1) {
                    postMap["holiday_type2"] = _weddingSelectedValue;
                  } else if (holidayType == 2) {
                    postMap["holiday_type2"] = _deathTypeSelectedValue;
                  }
                  postMap["money_type"] = _moneySelectedValue;
                  if (_moneySelectedValue == "2") {
                    postMap["bank_user"] = bankUser;
                    postMap["bank_name"] = bankName;
                    postMap["bank_num"] = bankNumber;
                  } else {
                    postMap["bank_user"] = "";
                    postMap["bank_name"] = "";
                    postMap["bank_num"] = "";
                  }
                  postMap["addr"] = address;
                  postMap["holiday_date"] = date;
                  postMap["etc"] = etc;

                  String title = "";
                  String content = "";
                  if (await submit(
                          Strings.shared.controllers.jsonURL.occasionJson,
                          body: postMap) ==
                      200) {
                    title = "전송 완료";
                    content = "전송이 완료되었습니다.";
                  } else {
                    title = "전송 실패";
                    content = "전송이 실패했습니다. \n관리자에게 연락바랍니다.";
                  }

                  print(title);

                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) => AlertDialog(
                            title: new Text(title),
                            content: new Text(content,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            actions: <Widget>[
                              // usually buttons at the bottom of the dialog
                              new FlatButton(
                                child: new Text(
                                  "확인",
                                  style: TextStyle(
                                      fontSize: Statics
                                          .shared.fontSizes.supplementary,
                                      color: Colors.black),
                                ),
                                onPressed: () {
                                  if (title == "전송 완료") {
                                    Navigator.of(context).pop(); //팝업닫고
                                    Navigator.of(context).pop(); //이전페이지로
                                  } else {
                                    Navigator.of(context).pop(); //팝업만 닫기
                                  }
                                },
                              ),
                            ],
                          ));
                }))
      ]),
    );
  }

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 1500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
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
  Widget txtField(type, controller, inputType, size, hint, content, checked) {
    return TextField(
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.left,
      keyboardType: inputType,
      inputFormatters: [
        LengthLimitingTextInputFormatter(size),
      ],

      decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: Statics.shared.fontSizes.subTitle,
            color: Statics.shared.colors.subTitleTextColor,
          ),
          border: OutlineInputBorder(),
          labelStyle: TextStyle(
            color: Statics.shared.colors.subTitleTextColor,
          ),
          hintText: hint),
      obscureText: false, // decoration
      onChanged: (String str) {
        switch (type) {
          case "name":
            name = str;
            break;
          case "company":
            company = str;
            break;
          case "position":
            position = str;
            break;
          case "phone":
            phone = str;
            break;
          case "bankUser":
            bankUser = str;
            break;
          case "bankName":
            bankName = str;
            break;
          case "bankNumber":
            bankNumber = str;
            break;
          case "address":
            address = str;
            break;
        }
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
    print(holidayType);
    if (holidayType == 1) {
      return weddingForm();
    } else if (holidayType == 2) {
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
      KeyValueModel(key: "본인/자녀 대상자 선택", value: "0"),
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
                        height: MediaQuery.of(context).size.height / 11,
                        child: txtField("bankUser", null, TextInputType.text,
                            20, "예금주명", bankUser, _bankUserChecked)),
                    SizedBox(height: 5),
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 11,
                        child: txtField("bankName", null, TextInputType.text,
                            20, "은행명", bankName, _bankNameChecked)),
                    SizedBox(height: 5),
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 11,
                        child: txtField("bankNumber", null, TextInputType.text,
                            24, "계좌번호", bankNumber, _bankNumberChecked)),
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
          hint: Text('본인/자녀 대상자 선택'),
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
          height: MediaQuery.of(context).size.height / 11,
          child: txtField("address", null, TextInputType.text, null,
              "결혼식장명 및 주소", address, _addressChecked)),
      SizedBox(height: 5),
      Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height / 11,
        child: DateTimeField(
          readOnly: true,
          controller: _dateController,
          decoration: InputDecoration(
              hintStyle: TextStyle(
                fontSize: Statics.shared.fontSizes.subTitle,
                color: Statics.shared.colors.subTitleTextColor,
              ),
              border: OutlineInputBorder(),
              labelStyle: TextStyle(
                color: Statics.shared.colors.subTitleTextColor,
              ),
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
                lastDate: DateTime(2100),
                locale: const Locale('ko', 'KR'));
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
          onChanged: (String str) {
            etc = str;
          },
        ),
      ),
      SizedBox(height: 5),
      Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 11,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 80,
                child: TextField(
                  controller: _fileController,
                  readOnly: true,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: Statics.shared.fontSizes.subTitle,
                        color: Statics.shared.colors.subTitleTextColor,
                      ),
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: Statics.shared.colors.subTitleTextColor,
                      ),
                      hintText: "첨부파일"),
                  obscureText: false, // decoration
                ),
              ),
              Spacer(),
              Container(
                  width: 60,
                  child: nullCheck(_fileController.text) == ""
                      ? FlatButton(
                          child: Image.asset(
                            "Resources/Icons/btn_more.png",
                            scale: 2.0,
                          ),
                          onPressed: () {
                            setState(() {
                              _pickingType = FileType.IMAGE;
                              if (_pickingType != FileType.IMAGE) {
                                _fileController.text = _extension = '';
                              }
                              _openFileExplorer();
                            });
                          },
                        )
                      : FlatButton(
                          child: Image.asset("Resources/Icons/btn_delete.png"),
                          onPressed: () {
                            setState(() {
                              _loadingPath = false;
                              _fileName = "";
                              _path = "";
                              filePath = "";
                              _fileController.text = "";
                            });
                          },
                        ))
            ],
          )),
    ]);
  }

  Widget deathForm() {
    List<KeyValueModel> _money = [
      KeyValueModel(key: "경조비 지급방식 선택", value: "0"),
      KeyValueModel(key: "화환", value: "1"),
      KeyValueModel(key: "축의금[계좌이체]", value: "2"),
    ];

    List<KeyValueModel> _deathType = [
      KeyValueModel(key: "경조 대상자 선택", value: "0"),
      KeyValueModel(key: "본인사망", value: "1"),
      KeyValueModel(key: "배우자상", value: "2"),
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
                        height: MediaQuery.of(context).size.height / 11,
                        child: txtField("bankUser", null, TextInputType.text,
                            20, "���금주명", bankUser, _bankUserChecked)),
                    SizedBox(height: 5),
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 11,
                        child: txtField("bankName", null, TextInputType.text,
                            20, "��행명", bankName, _bankNameChecked)),
                    SizedBox(height: 5),
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 11,
                        child: txtField("bankNumber", null, TextInputType.text,
                            24, "계좌번호", bankNumber, _bankNumberChecked)),
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
          hint: Text('경조 대상자 선택'),
          style: TextStyle(
            fontSize: Statics.shared.fontSizes.subTitle,
            color: Statics.shared.colors.titleTextColor,
          ), // Not necessary for Option 1
          value: _deathTypeSelectedValue,
          onChanged: (String newValue) {
            setState(() {
              _deathTypeSelectedValue = newValue;
            });
          },
          items: _deathType.map((data) {
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
          height: MediaQuery.of(context).size.height / 11,
          child: txtField("address", null, TextInputType.text, null,
              "장례식장명 및 주소", address, _addressChecked)),
      SizedBox(height: 5),
      Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height / 11,
        child: DateTimeField(
          readOnly: true,
          decoration: InputDecoration(
              hintStyle: TextStyle(
                fontSize: Statics.shared.fontSizes.subTitle,
                color: Statics.shared.colors.subTitleTextColor,
              ),
              border: OutlineInputBorder(),
              labelStyle: TextStyle(
                color: Statics.shared.colors.subTitleTextColor,
              ),
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
                lastDate: DateTime(2100),
                locale: const Locale('ko', 'KR'));
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
          onChanged: (String str) {
            etc = str;
          },
        ),
      ),
      SizedBox(height: 5),
      Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 11,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 80,
                child: TextField(
                  controller: _fileController,
                  readOnly: true,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: Statics.shared.fontSizes.subTitle,
                        color: Statics.shared.colors.subTitleTextColor,
                      ),
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: Statics.shared.colors.subTitleTextColor,
                      ),
                      hintText: "첨부파일"),
                  obscureText: false, // decoration
                ),
              ),
              Spacer(),
              Container(
                  width: 60,
                  child: nullCheck(_fileController.text) == ""
                      ? FlatButton(
                          child: Image.asset(
                            "Resources/Icons/btn_more.png",
                            scale: 2.0,
                          ),
                          onPressed: () {
                            setState(() {
                              _pickingType = FileType.IMAGE;
                              if (_pickingType != FileType.IMAGE) {
                                _fileController.text = _extension = '';
                              }
                              _openFileExplorer();
                            });
                          },
                        )
                      : FlatButton(
                          child: Image.asset("Resources/Icons/btn_delete.png"),
                          onPressed: () {
                            setState(() {
                              _loadingPath = false;
                              _fileName = "";
                              _path = "";
                              filePath = "";
                              _fileController.text = "";
                            });
                          },
                        ))
            ],
          )),
    ]);
  }

  submit(String url, {Map body}) async {
    print(body['upfile01']);

    if (body['upfile01'] != "" && body['upfile01'] != null) {
      File imageFile = new File(body['upfile01']);
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      var length = await imageFile.length();

      // string to uri
      var uri = Uri.parse(url);

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = new http.MultipartFile('upfile01', stream, length,
          filename: path.basename(imageFile.path));

      // add file to multipart
      request.files.add(multipartFile);
      request.fields['mode'] = nullCheck(body['mode']);
      request.fields['user_id'] = nullCheck(body['user_id']);
      request.fields['email'] = nullCheck(body['email']);
      request.fields['user_name'] = nullCheck(body['user_name']);
      request.fields['user_idx'] = nullCheck(body['user_idx']);
      request.fields['member_type'] = nullCheck(body['member_type']);
      request.fields['member_name'] = nullCheck(body['member_name']);
      request.fields['birth'] = nullCheck(body['birth']);
      request.fields['company'] = nullCheck(body['company']);
      request.fields['position'] = nullCheck(body['position']);
      request.fields['phone'] = nullCheck(body['phone']);
      request.fields['holiday_type'] = nullCheck(body['holiday_type']);
      request.fields['holiday_type2'] = nullCheck(body['holiday_type2']);
      request.fields['money_type'] = nullCheck(body['money_type']);
      request.fields['bank_user'] = nullCheck(body['bank_user']);
      request.fields['bank_name'] = nullCheck(body['bank_name']);
      request.fields['bank_num'] = nullCheck(body['bank_num']);
      request.fields['addr'] = nullCheck(body['addr']);
      request.fields['holiday_date'] = nullCheck(body['holiday_date']);
      request.fields['etc'] = nullCheck(body['etc']);

      // send
      request
          .send()
          .then((result) async {
            http.Response.fromStream(result).then((response) {
              final String responseBody = utf8.decode(response.bodyBytes);
              var responseJSON = json.decode(responseBody);
              var code = responseJSON["code"];
              if (response.statusCode == 200) {
                print("Uploaded! ");
                print('response.body ' + response.body);

                return code;
              } else {
                return "error";
              }
            });
          })
          .catchError((err) => throw Exception('error : ' + err.toString()))
          .whenComplete(() {});
    } else {
      return http.post(url, body: body).then((http.Response response) {
        final int statusCode = response.statusCode;
        //final String responseBody = response.body; //한글 깨짐
        final String responseBody = utf8.decode(response.bodyBytes);
        var responseJSON = json.decode(responseBody);
        var code = responseJSON["code"];

        if (statusCode == 200) {
          if (code == 200) {
            // If the call to the server was successful, parse the JSON
          }
          return code;
        } else {
          // If that call was not successful, throw an error.
          return "error";
        }
      });
    }
  }
}

class KeyValueModel {
  String key;
  String value;

  KeyValueModel({this.key, this.value});
}

nullCheck(String str) {
  if (str == null) {
    return str = "";
  }
  return str;
}
