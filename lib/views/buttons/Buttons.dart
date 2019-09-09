import 'package:flutter/material.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:intl/intl.dart';

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

class DateTimePicker extends StatelessWidget {
  const DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(1970, 8),
        lastDate: new DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.body1;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        new Expanded(
          flex: 3,
          child: new _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
