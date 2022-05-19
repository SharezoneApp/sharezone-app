import 'package:flutter/material.dart';
import 'package:sharezone_website/home/home_page.dart';

class Headline extends StatelessWidget {
  const Headline(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: TextStyle(
        fontSize: isTablet(context) ? 40 : 65,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }
}
