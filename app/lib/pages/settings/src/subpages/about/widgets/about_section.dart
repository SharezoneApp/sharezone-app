import 'package:flutter/material.dart';
import 'package:sharezone_widgets/theme.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    Key key,
    @required this.title,
    this.child,
  }) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Headline(title),
        child,
      ],
    );
  }
}
