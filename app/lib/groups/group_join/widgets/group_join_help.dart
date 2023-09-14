// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/groups/src/pages/course/group_help.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class GroupJoinHelp extends StatelessWidget {
  const GroupJoinHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 4),
            child: Text(
              "FAQ:",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          const CourseHelpInnerPage(),
        ],
      ),
    );
  }
}
