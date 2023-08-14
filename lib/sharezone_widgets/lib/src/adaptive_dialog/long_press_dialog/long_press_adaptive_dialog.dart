// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

Future<T?> showLongPressAdaptiveDialog<T>({
  required BuildContext context,
  required List<LongPress<T>> longPressList,
  String? title,
  String? subtile,
}) async {
  return (PlatformCheck.isIOS
      ? await showCupertinoModalPopup<T>(
          context: context,
          builder: (context) => _LongPressDialogCupertino<T>(
            longPressList: longPressList,
            title: title,
            subtitle: subtile,
          ),
        )
      : showDialog<T>(
          context: context,
          builder: (context) =>
              _LongPressDialogMaterial<T>(longPressList: longPressList),
        )) as Future<T?>;
}

class _LongPressDialogMaterial<T> extends StatelessWidget {
  const _LongPressDialogMaterial({Key? key, required this.longPressList})
      : super(key: key);

  final List<LongPress<T>> longPressList;

  @override
  Widget build(BuildContext context) {
    return RoundedSimpleDialog(
      contentPadding: const EdgeInsets.all(0),
      children: [
        for (final longPress in longPressList)
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            leading: longPress.icon,
            title: Text(longPress.title),
            onTap: () => Navigator.pop(context, longPress.popResult),
          ),
      ],
    );
  }
}

class _LongPressDialogCupertino<T> extends StatelessWidget {
  const _LongPressDialogCupertino(
      {Key? key, this.title, this.subtitle, required this.longPressList})
      : super(key: key);

  final String? title, subtitle;
  final List<LongPress<T>> longPressList;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: isNotEmptyOrNull(title!) ? Text(title!) : null,
      message: isNotEmptyOrNull(subtitle!) ? Text(subtitle!) : null,
      actions: longPressList
          .map((longPress) => CupertinoActionSheetAction(
              child: Text(longPress.title),
              onPressed: () => Navigator.pop(context, longPress.popResult)))
          .toList(),
      cancelButton: CupertinoActionSheetAction(
        child: const Text("Abbrechen"),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
