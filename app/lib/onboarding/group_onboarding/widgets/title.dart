import 'package:flutter/material.dart';
import 'package:sharezone_common/helper_functions.dart';

class GroupOnboardingTitle extends StatelessWidget {
  GroupOnboardingTitle(this.title, {Key key})
      : assert(isNotEmptyOrNull(title)),
        super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 22),
    );
  }
}
