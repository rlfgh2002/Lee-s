import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haegisa2/controllers/mainTabBar/MainTabBar.dart';
import 'package:haegisa2/controllers/sign/SignSelect.dart';


class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void checkUserIsLogin(onComplete(bool res)) async {
    await SharedPreferences.getInstance().then((val){
      bool status = val.getBool("app_user_login_info_islogin");
      if(status == false || status == null){
        onComplete(false);
      }else{
        onComplete(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    this.checkUserIsLogin((st){
      if(st){
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new MainTabBar()));
      }// user is logged in
      else{
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new SignSelect()));
      }// user is Not logged in
    });

    return Scaffold(
      body: Container(color: Colors.white),
    );
  }
}
