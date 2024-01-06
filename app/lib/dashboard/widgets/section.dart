// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../dashboard_page.dart';

class _Section extends StatelessWidget {
  const _Section({this.title, this.child});

  final Widget? title;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SafeArea(
          top: false,
          left: true,
          right: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 12, 6),
            child: DefaultTextStyle(
              style: TextStyle(
                color: Theme.of(context).isDarkTheme
                    ? Colors.lightBlue
                    : darkBlueColor,
                fontSize: 18,
                fontFamily: rubik,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              child: title!,
            ),
          ),
        ),
        child!,
      ],
    );
  }
}
