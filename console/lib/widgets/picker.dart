// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

Future<T?> selectItem<T>({
  required BuildContext context,
  required List<T> items,
  required Widget Function(BuildContext context, T item) builder,
  List<Widget> Function(BuildContext context)? actions,
}) async {
  return await showSheetBuilder<T>(
    context: context,
    child:
        (context) => Flexible(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder:
                (BuildContext context, int index) =>
                    builder(context, items[index]),
            shrinkWrap: true,
          ),
        ),
    title: null,
    actions: actions,
  );
}

Future<T?> showSheetBuilder<T>({
  required BuildContext context,
  required WidgetBuilder child,
  required String? title,
  List<Widget> Function(BuildContext context)? actions,
}) async {
  return await showModalBottomSheet<T>(
    context: context,
    isScrollControlled: false,
    builder: (context) {
      return Material(
        color: null,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 4,
                width: MediaQuery.of(context).size.width / 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: Colors.grey[400],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (title != null)
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            if (title != null) const SizedBox(height: 12),
            child(context),
            const SizedBox(height: 6),
            actions != null
                ? Row(
                  children: actions(context),
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                )
                : const SizedBox(height: 0),
            const SizedBox(height: 6),
          ],
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    },
  );
}
