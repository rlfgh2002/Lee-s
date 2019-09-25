import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/controllers/home/Home.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/UserInfo.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String pushState = "";
  bool _aTeamVisible = false;
  bool _bTeamVisible = false;
  bool _cTeamVisible = false;
  var orgTable = new List();
  int _activeMeterIndex;
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));

    final GlobalKey<_IntroState> expansionTile = new GlobalKey();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          title: Text("협회소개",
              style: TextStyle(
                  color: Statics.shared.colors.titleTextColor,
                  fontSize: Statics.shared.fontSizes.title)),
          titleSpacing: 16.0,
          bottom: TabBar(
            labelColor: Statics.shared.colors.titleTextColor,
            labelStyle: (TextStyle(
              fontSize: Statics.shared.fontSizes.subTitle,
            )),
            tabs: [
              Tab(
                text: "협회정보",
              ),
              Tab(text: "조직도"),
            ],
          ),
          centerTitle: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
        ),
        body: TabBarView(
          children: [
            //tab1
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Image.asset("Resources/Images/intro.png"),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 10.0),
                            child: Image.asset("Resources/Images/intro2.png"),
                          ),
                          SizedBox(height: 30),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Text(
                                "사단법인 한국해기사협회는 선박의 운항, 경영, 관리의 전문직업인 '해기사'들의 권익단체입니다",
                                style: TextStyle(
                                    color: Statics.shared.colors.titleTextColor,
                                    fontSize: Statics
                                        .shared.fontSizes.supplementaryBig,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(height: 30),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Text(
                                " 해기사들의 친목 도모와 권익 신장 그리고 해사 전문 기술의 향상을 위해 존재합니다. \n\n우리 협회는 어플을 회원들과의 쌍방향 소통 창구로 활용하여 정보를 전달하고 의견을 수렴, '회원이 찾는 협회'의 비전을 실현하겠습니다. \n\n감사합니다",
                                style: TextStyle(
                                  color: Statics.shared.colors.titleTextColor,
                                  fontSize:
                                      Statics.shared.fontSizes.supplementary,
                                )),
                          ),
                          SizedBox(height: 30),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            //tab2
            Column(children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Image.asset("Resources/Images/organization.png"),
                        Container(
                          padding:
                              const EdgeInsets.only(left: 5.0, right: 10.0),
                          child:
                              Image.asset("Resources/Images/organization2.png"),
                        ),
                        FutureBuilder(
                          future: getOrganization(), // a Future<String> or null
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            //print('project snapshot data is: ${snapshot.data}');
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return new Text('Press button to start');
                              case ConnectionState.waiting:
                                return new Container(
                                  child: FlatButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Text("",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Statics
                                                .shared.colors.titleTextColor,
                                            fontSize: Statics
                                                .shared.fontSizes.subTitle)),
                                    onPressed: () {},
                                  ),
                                  height: deviceWidth / 6,
                                );
                              default:
                                if (snapshot.hasError)
                                  return new Text('Error: ${snapshot.error}');
                                else
                                  return orgList(context, snapshot);
                            }
                          },
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ],
                ),
              )
            ])
          ],
        ),
      ),
    );
  }

  _displaySnackBar(BuildContext context, String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 1000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<List> getOrganization() async {
    var infomap = new Map<String, dynamic>();
    infomap["mode"] = "member";
    //한번도 실행되지 않았을때(최초실행)
    if (orgTable.length == 0) {
      return http
          .post(Strings.shared.controllers.jsonURL.organizationJSon,
              body: infomap)
          .then((http.Response response) {
        final int statusCode = response.statusCode;
        //final String responseBody = response.body; //한글 깨짐
        final String responseBody = utf8.decode(response.bodyBytes);
        var responseJSON = json.decode(responseBody);
        var code = responseJSON["code"];

        if (statusCode == 200) {
          if (code == 200) {
            orgTable = responseJSON["rows"];
            return responseJSON["rows"];
          }
        } else {
          // If that call was not successful, throw an error.
          throw Exception('Failed to load post');
        }
      });
    } else
      return orgTable;
  }

  orgList(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;

    return Column(children: <Widget>[
      Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        decoration: new BoxDecoration(
            border:
                new Border.all(color: Statics.shared.colors.subTitleTextColor)),
        child: AppExpansionTile(
            title: Text(values[0]["department_name"]),
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
            children: <Widget>[
              new ListTile(
                title: const Text(
                    "- 예산편성 집행관리\n- 경리,회계업무\n- 각종 문서수발 및 보관관리\n- 소유재산 및 자산관리\n- 회비징수 및 관리업무\n- 직원의 인사관리 및 후생복지\n- 각종 전산관리 업무\n- 서무, 일반행정"),
              ),
              for (var i = 0; i < values[0]["department_member"].length; i++)
                memberList(values[0]["department_member"][i])
            ]),
      ),
      SizedBox(height: 10),
      Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        decoration: new BoxDecoration(
            border:
                new Border.all(color: Statics.shared.colors.subTitleTextColor)),
        child: AppExpansionTile(
            title: Text(values[1]["department_name"]),
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
            children: <Widget>[
              new ListTile(
                title: const Text(
                    "- 해기사 관련 대외 정책 및 전략수립\n- 유관기관 및 단체, 업체와의 유대관리\n- 대의원 및 회장선거와 관련된 제반 업무\n- 정관, 제 규정의 제정, 개정 및 폐지\n- 각종 행사 및 세미나 주관\n- 홍보편집"),
              ),
              for (var i = 0; i < values[0]["department_member"].length; i++)
                memberList(values[1]["department_member"][i])
            ]),
      ),
      SizedBox(height: 10),
      Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        decoration: new BoxDecoration(
            border:
                new Border.all(color: Statics.shared.colors.subTitleTextColor)),
        child: AppExpansionTile(
            title: Text(values[2]["department_name"]),
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
            children: <Widget>[
              new ListTile(
                title: const Text(
                    "- 회원조직 관리업무\n- 해기사시험보도 접수 및 관련업무\n- 한국면허갱신접수 대행업무\n- 외국면허 수첩 및 특별 자격증 발급에 관련된 제반업무\n- 회원고충상담 및 처리업무\n- 회원복지 및 친목에 관련된 제반업무\n- 해기 기술의 검토 및 자문"),
              ),
              for (var i = 0; i < values[0]["department_member"].length; i++)
                memberList(values[2]["department_member"][i])
            ]),
      ),
    ]);
  }

  memberList(Map<String, dynamic> member) {
    var a = member;

    return ListTile(
        title: Row(
      children: <Widget>[
        Container(
          width: deviceWidth / 4.5,
          child: Text(member["position"],
              style: TextStyle(
                color: Statics.shared.colors.mainColor,
                fontSize: Statics.shared.fontSizes.subTitle,
              )),
        ),
        Container(
          height: deviceWidth / 14,
          child: VerticalDivider(
            width: 0,
            color: Colors.black38,
          ),
        ),
        Container(
          width: deviceWidth / 4.5,
          margin: const EdgeInsets.only(left: 10.0),
          child: Text(member["name"],
              style: TextStyle(
                color: Colors.black,
                fontSize: Statics.shared.fontSizes.subTitle,
                fontWeight: FontWeight.normal,
              )),
        ),
        Spacer(),
        FlatButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Image.asset("Resources/Icons/icon_call.png", scale: 2.0),
          onPressed: () {
            launch("tel://" + member["tel"]);
          },
        )
      ],
    ));
  }
}

class AppExpansionTile extends StatefulWidget {
  static AppExpansionTileState of(BuildContext context) {
    return context
        .ancestorStateOfType(const TypeMatcher<AppExpansionTileState>());
  }

  const AppExpansionTile({
    Key key,
    this.leading,
    @required this.title,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children: const <Widget>[],
    this.trailing,
    this.initiallyExpanded: false,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  final Widget leading;
  final Widget title;
  final ValueChanged<bool> onExpansionChanged;
  final List<Widget> children;
  final Color backgroundColor;
  final Widget trailing;
  final bool initiallyExpanded;

  @override
  AppExpansionTileState createState() => new AppExpansionTileState();
}

const Duration _kExpand = const Duration(milliseconds: 200);

class AppExpansionTileState extends State<AppExpansionTile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _easeOutAnimation;
  CurvedAnimation _easeInAnimation;
  ColorTween _borderColor;
  ColorTween _headerColor;
  ColorTween _iconColor;
  ColorTween _backgroundColor;
  Animation<double> _iconTurns;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(duration: _kExpand, vsync: this);
    _easeOutAnimation =
        new CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _easeInAnimation =
        new CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _borderColor = new ColorTween();
    _headerColor = new ColorTween();
    _iconColor = new ColorTween();
    _iconTurns =
        new Tween<double>(begin: 0.0, end: 0.5).animate(_easeInAnimation);
    _backgroundColor = new ColorTween();

    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void expand() {
    _setExpanded(true);
  }

  void collapse() {
    _setExpanded(false);
  }

  void toggle() {
    _setExpanded(!_isExpanded);
  }

  void _setExpanded(bool isExpanded) {
    if (_isExpanded != isExpanded) {
      setState(() {
        _isExpanded = isExpanded;
        if (_isExpanded)
          _controller.forward();
        else
          _controller.reverse().then<void>((void value) {
            setState(() {
              // Rebuild without widget.children.
            });
          });
        PageStorage.of(context)?.writeState(context, _isExpanded);
      });
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged(_isExpanded);
      }
    }
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color borderSideColor =
        _borderColor.evaluate(_easeOutAnimation) ?? Colors.transparent;
    final Color titleColor = _headerColor.evaluate(_easeInAnimation);

    return new Container(
      decoration: new BoxDecoration(
          color: _backgroundColor.evaluate(_easeOutAnimation) ??
              Colors.transparent,
          border: new Border(
            top: new BorderSide(color: borderSideColor),
            bottom: new BorderSide(color: borderSideColor),
          )),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data:
                new IconThemeData(color: _iconColor.evaluate(_easeInAnimation)),
            child: new ListTile(
              onTap: toggle,
              leading: widget.leading,
              title: new DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: titleColor),
                child: widget.title,
              ),
              trailing: widget.trailing ??
                  new RotationTransition(
                    turns: _iconTurns,
                    child: const Icon(Icons.expand_more),
                  ),
            ),
          ),
          new ClipRect(
            child: new Align(
              heightFactor: _easeInAnimation.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    _borderColor.end = theme.dividerColor;
    _headerColor
      ..begin = theme.textTheme.subhead.color
      ..end = theme.accentColor;
    _iconColor
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _backgroundColor.end = widget.backgroundColor;

    final bool closed = !_isExpanded && _controller.isDismissed;
    return new AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : new Column(children: widget.children),
    );
  }
}
