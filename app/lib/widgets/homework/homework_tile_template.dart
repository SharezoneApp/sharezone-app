// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class HomeworkTileTemplate extends StatelessWidget {
  final String title;
  final String courseName;
  final String todoDate;
  final Color todoDateColor;
  final Color courseColor;
  final String courseAbbreviation;
  final Widget trailing;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final String heroTag;

  const HomeworkTileTemplate({
    Key key,
    @required this.title,
    @required this.courseName,
    @required this.todoDate,
    @required this.todoDateColor,
    @required this.courseColor,
    @required this.courseAbbreviation,
    @required this.trailing,
    @required this.onTap,
    @required this.onLongPress,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4.0),
      child: CustomCard(
        child: ListTile(
          dense: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  .apply(fontSizeFactor: 1.1),
            ),
          ),
          isThreeLine: true,
          subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text.rich(
              TextSpan(children: <TextSpan>[
                TextSpan(text: "$courseName\n"),
                TextSpan(
                    text: todoDate, style: TextStyle(color: todoDateColor)),
              ], style: TextStyle(color: Colors.grey[600])),
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: courseColor.withOpacity(0.2),
            child: Text(
              courseAbbreviation ?? "-",
              style: TextStyle(color: courseColor),
            ),
          ),
          trailing: trailing,
          onTap: onTap,
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}
