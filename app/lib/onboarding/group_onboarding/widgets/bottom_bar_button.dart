import 'package:flutter/material.dart';

class BottomBarButton extends StatelessWidget {
  const BottomBarButton({Key key, this.onTap, @required this.text})
      : super(key: key);

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
      ),
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        child: Text(text.toUpperCase(), style: TextStyle(fontSize: 20)),
        onPressed: onTap,
      ),
    );
  }
}
