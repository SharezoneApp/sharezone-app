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
import 'package:platform_check/platform_check.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

Future<T?> showLeftRightAdaptiveDialog<T>({
  required BuildContext context,
  String? title,
  Widget? content,
  AdaptiveDialogAction? left = AdaptiveDialogAction.cancel,
  AdaptiveDialogAction? right,
  bool withCancelButtonOnIOS = false,
  T? defaultValue,
}) async {
  final T? result;
  if (PlatformCheck.isIOS) {
    result = await showCupertinoDialog<T>(
      context: context,
      builder: (context) => _ActionAndCancelDialogCupertino(
        title: title,
        content: content,
        left: left,
        right: right,
        withCancelButtonOnIOS: withCancelButtonOnIOS,
      ),
    );
  } else {
    result = await showDialog<T>(
      context: context,
      builder: (context) => _ActionAndCancelDialogMaterial(
        title: title,
        content: content,
        left: left,
        right: right,
      ),
    );
  }
  return result ?? defaultValue;
}

class LeftAndRightAdaptiveDialog<T> extends StatelessWidget {
  final AdaptiveDialogAction? left;
  final AdaptiveDialogAction? right;
  final String? title;
  final Widget? content;
  final bool withCancelButtonOnIOS;

  const LeftAndRightAdaptiveDialog({
    Key? key,
    this.left = AdaptiveDialogAction.cancel,
    this.right,
    this.title,
    this.content,
    this.withCancelButtonOnIOS = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ThemePlatform.isCupertino) {
      return _ActionAndCancelDialogCupertino(
        left: left,
        right: right,
        content: content,
        title: title,
        withCancelButtonOnIOS: withCancelButtonOnIOS,
      );
    }
    return _ActionAndCancelDialogMaterial<T>(
      content: content,
      title: title,
      left: left as AdaptiveDialogAction<T>?,
      right: right as AdaptiveDialogAction<T>?,
    );
  }
}

class _ActionAndCancelDialogMaterial<T> extends StatelessWidget {
  final AdaptiveDialogAction<T>? left;
  final AdaptiveDialogAction<T>? right;
  final String? title;
  final Widget? content;

  const _ActionAndCancelDialogMaterial({
    Key? key,
    this.right,
    this.title,
    this.content,
    this.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: isNotEmptyOrNull(title) ? Text(title!) : null,
      content: DialogWrapper(child: content),
      actions: <Widget>[
        if (left != null)
          TextButton(
            key: left!.key,
            style: TextButton.styleFrom(
              foregroundColor:
                  left!.textColor ?? Theme.of(context).primaryColor,
            ),
            onPressed: left!.onPressed ??
                (() => Navigator.pop(context, left!.popResult ?? false)),
            child: Text(left!.title!.toUpperCase()),
          ),
        if (right != null)
          TextButton(
            key: right!.key,
            style: TextButton.styleFrom(
              foregroundColor:
                  right!.textColor ?? Theme.of(context).primaryColor,
            ),
            onPressed: right!.onPressed ??
                (() => Navigator.pop(context, right!.popResult ?? true)),
            child: Text(right!.title!.toUpperCase()),
          )
      ],
    );
  }
}

class _ActionAndCancelDialogCupertino extends StatelessWidget {
  final AdaptiveDialogAction? right;
  final AdaptiveDialogAction? left;
  final String? title;
  final Widget? content;
  final bool? withCancelButtonOnIOS;

  const _ActionAndCancelDialogCupertino({
    Key? key,
    this.right,
    this.title,
    this.content,
    this.left,
    this.withCancelButtonOnIOS,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: isNotEmptyOrNull(title) ? Text(title!) : const Text(""),
      content: content,
      actions: <Widget>[
        if (left != null)
          CupertinoDialogAction(
            key: left!.key,
            isDefaultAction: left!.isDefaultAction,
            isDestructiveAction: left!.isDestructiveAction,
            onPressed: left!.onPressed ??
                (() => Navigator.pop(context, left!.popResult)),
            child: Text(left!.title!),
          ),
        if (right != null)
          CupertinoDialogAction(
            key: right!.key,
            isDefaultAction: right!.isDefaultAction,
            isDestructiveAction: right!.isDestructiveAction,
            onPressed: right!.onPressed ??
                (() => Navigator.pop(context, right!.popResult)),
            child: Text(right!.title!),
          ),
        if (ThemePlatform.isCupertino && withCancelButtonOnIOS!)
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            isDestructiveAction: true,
            child: const Text("Abbrechen"),
          )
      ],
    );
  }
}
