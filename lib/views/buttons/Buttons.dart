import 'package:flutter/material.dart';
import 'package:haegisa2/models/statics/statics.dart';

class HaegisaButton extends StatefulWidget {
  String iconURL;
  String text = "";
  VoidCallback onPressed;

  HaegisaButton({String text, String iconURL, VoidCallback onPressed}) {
    this.text = text;
    this.iconURL = iconURL;
    this.onPressed = onPressed;
  }

  @override
  _HaegisaButtonState createState() {
    return _HaegisaButtonState();
  }
}

class _HaegisaButtonState extends State<HaegisaButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonTheme(
        child: FlatButton(
          onPressed: () {
            this.widget.onPressed();
          },
          child: Row(
            children: [
              Text(
                this.widget.text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Statics.shared.fontSizes.titleInContent),
              ), // Text
              SizedBox(width: 10),
              Image.asset(
                this.widget.iconURL,
                width: 10,
                color: Colors.white,
                alignment: Alignment.center,
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        ), // Next Button
        height: 60,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        color: Statics.shared.colors.subTitleTextColor,
      ),
    );
  }
}
