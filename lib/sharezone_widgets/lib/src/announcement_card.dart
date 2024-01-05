// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:build_context/build_context.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    Key? key,
    this.title,
    this.actions,
    this.content,
    this.onTap,
    this.color = Colors.amber,
    this.titleColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.padding = const EdgeInsets.only(bottom: 16),
  }) : super(key: key);

  final String? title;

  /// Default is Colors.black (Dark Mode) Colors.white (Dark Mode).
  final Color? titleColor;

  final Widget? content;
  final List<Widget>? actions;
  final VoidCallback? onTap;

  /// Default is Colors.amber.
  final Color color;

  /// Default is BorderRadius.all(Radius.circular(10)).
  final BorderRadius borderRadius;

  /// Default is EdgeInsets.only(bottom: 16).
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final hasTitle = isNotEmptyOrNull(title);
    final hasContent = content != null;
    final hasActions = actions != null;

    return Padding(
      padding: padding,
      child: CustomCard(
        borderRadius: borderRadius,
        color: color,
        withBorder: false,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: SizedBox(
                width: context.mediaQuerySize.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (hasTitle) _Title(title!, color: titleColor),
                    if (hasContent) ...[const SizedBox(height: 8), content!],
                  ],
                ),
              ),
            ),
            if (hasActions) _ActionsAligment(actions: actions!),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.title, {Key? key, this.color}) : super(key: key);

  final String title;

  /// Default is Colors.black (Dark Mode) Colors.white (Dark Mode).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        "» $title",
        style: TextStyle(
          color: color ??
              (context.isDarkThemeEnabled ? Colors.white : Colors.black),
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ActionsAligment extends StatelessWidget {
  const _ActionsAligment({
    Key? key,
    required this.actions,
  }) : super(key: key);

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: actions,
        ),
      ),
    );
  }
}
