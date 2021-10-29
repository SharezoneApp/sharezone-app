import 'package:flutter/material.dart';
import 'package:sharezone_website/home/home_page.dart';

class Subline extends StatelessWidget {
  const Subline(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: TextStyle(
        fontSize: isTablet(context) ? 20 : 24,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
      ),
    );
  }
}
