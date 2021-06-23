import 'package:flutter/material.dart';
import 'package:sharezone/groups/src/pages/course/group_help.dart';
import 'package:sharezone_widgets/wrapper.dart';

class GroupJoinHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16, bottom: 4),
            child: Text(
              "FAQ:",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          CourseHelpInnerPage(),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
