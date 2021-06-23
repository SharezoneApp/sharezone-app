import 'package:flutter/material.dart';
import 'package:sharezone_widgets/theme.dart';

class SettingsSubpageSection extends StatelessWidget {
  const SettingsSubpageSection({
    Key key,
    this.title,
    this.children,
  }) : super(key: key);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Headline(title),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          )
        ],
      ),
    );
  }
}
