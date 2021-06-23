import 'package:flutter/material.dart';
import 'package:sharezone_website/main.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText(
      {Key key, @required this.text, this.fontSize = 14, this.textStyle})
      : super(key: key);

  final Widget text;
  final double fontSize;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(width: 200),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: const Divider(height: 0),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: fontSize,
                    fontFamily: SharezoneStyle.font,
                  ),
                  child: text,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
