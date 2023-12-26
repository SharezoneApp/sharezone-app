// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone_widgets/src/dialog_wrapper.dart';

import '../adaptive_dialog_action.dart';

Future<T?> showColumnActionsAdaptiveDialog<T>({
  required BuildContext context,
  required List<AdaptiveDialogAction<T>> actions,
  String? title,
  String? messsage,
}) async {
  return PlatformCheck.isIOS
      ? await showCupertinoDialog<T>(
          context: context,
          builder: (context) => _ColumnActionsDialogCupertino<T>(
            actions: actions,
            title: title,
            message: messsage,
          ),
        )
      : await showDialog(
          context: context,
          builder: (context) => _ColumnActionsDialogMaterial<T>(
            actions: actions,
            title: title,
            message: messsage,
          ),
        );
}

class _ColumnActionsDialogMaterial<T> extends StatelessWidget {
  const _ColumnActionsDialogMaterial({
    super.key,
    this.actions,
    this.title,
    this.message,
  });

  final List<AdaptiveDialogAction<T>>? actions;
  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title!),
      content: DialogWrapper(child: Text(message!)),
      actions: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: actions!
              .map((action) => TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          action.textColor ?? Theme.of(context).primaryColor,
                    ),
                    onPressed: () => Navigator.pop(context, action.popResult),
                    child: Text(action.title!.toUpperCase()),
                  ))
              .toList(),
        )
      ],
      contentPadding: const EdgeInsets.symmetric(horizontal: 24)
          .add(const EdgeInsets.only(top: 20)),
    );
  }
}

class _ColumnActionsDialogCupertino<T> extends StatelessWidget {
  const _ColumnActionsDialogCupertino(
      {super.key, this.actions, this.title, this.message});

  final List<AdaptiveDialogAction<T>>? actions;
  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: isNotEmptyOrNull(title) ? Text(title!) : null,
      content: isNotEmptyOrNull(message) ? Text(message!) : null,
      actions: <Widget>[
        ...actions!
            .map((action) => CupertinoDialogAction(
                  isDefaultAction: action.isDefaultAction,
                  isDestructiveAction: action.isDestructiveAction,
                  onPressed: () => Navigator.pop(context, action.popResult),
                  child: Text(action.title!),
                ))
            ,
        CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text("Abbrechen"))
      ],
    );
  }
}
