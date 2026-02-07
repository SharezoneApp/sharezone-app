// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

// Like the VoidCallback, but as a Future
typedef FutureVoidCallback = Future<void> Function();
typedef FutureBoolCallback = Future<bool> Function();
typedef FutureBoolValueChanged<T> = Future<bool> Function(T t);

Future<void> showDeleteDialog({
  required BuildContext context,
  String? title,
  Widget? description,
  dynamic popTwiceResult,
  VoidCallback? onDelete,
  bool popTwice = true,
}) async {
  final result =
      (await showLeftRightAdaptiveDialog<bool>(
        context: context,
        title: title,
        content: description,
        defaultValue: false,
        left: AdaptiveDialogAction.cancel(context),
        right: AdaptiveDialogAction.delete(context),
      ))!;

  if (result) {
    onDelete!();
    // ignore: use_build_context_synchronously
    if (popTwice) Navigator.pop(context, popTwiceResult);
  }
}

class LeaveEditedFormAlert extends StatelessWidget {
  const LeaveEditedFormAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.sharezoneWidgetsLeaveFormTitle),
      content: Text.rich(
        TextSpan(
          text: context.l10n.sharezoneWidgetsLeaveFormPromptPrefix,
          style: TextStyle(
            color: Theme.of(context).isDarkTheme ? Colors.white : Colors.black,
            fontSize: 16.0,
          ),
          children: <TextSpan>[
            TextSpan(
              text: context.l10n.sharezoneWidgetsLeaveFormPromptNot,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: context.l10n.sharezoneWidgetsLeaveFormPromptSuffix),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: Text(context.l10n.sharezoneWidgetsLeaveFormStay),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: Text(context.l10n.sharezoneWidgetsLeaveFormConfirm),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

class OneTextFieldDialog extends StatefulWidget {
  const OneTextFieldDialog({
    super.key,
    required this.onTap,
    required this.title,
    required this.hint,
    required this.actionName,
    this.isEmptyAllowed = false,
    this.notAllowedChars,
    this.text,
  });

  final ValueChanged<String?> onTap;
  final String? title, hint, actionName, notAllowedChars;

  /// Defines if the user is allowed to submit `null` or empty text.
  ///
  /// If [isEmptyAllowed] is `false` and the user submits `null` or an
  /// empty text, then the dialog will not be closed and the [onTap] callback
  /// will not be called. Instead an error message will be shown.
  final bool isEmptyAllowed;

  /// The text, which will be set at the beginning
  final String? text;

  @override
  State createState() => _OneTextFieldDialogState();
}

class _OneTextFieldDialogState extends State<OneTextFieldDialog> {
  String? name, errorText;
  TextEditingController? controller;

  final FocusNode focusNode = FocusNode();

  Future<void> delayKeyboard(BuildContext context) async {
    Future.delayed(const Duration(milliseconds: 150));
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void initState() {
    if (widget.text != null) {
      controller = TextEditingController(text: widget.text);
      name = widget.text;
    }
    super.initState();
  }

  bool containsStringNowAllowChars(String? inputText) {
    for (String char in widget.notAllowedChars!.split("")) {
      if (inputText!.contains(char)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // delayKeyboard(context);
    return AlertDialog(
      title: Text(widget.title!),
      content: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: (changed) => name = changed,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => widget.onTap(name),
        decoration: InputDecoration(
          hintText: widget.hint,
          errorText: errorText,
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.commonActionsCancelUppercase),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: Text(widget.actionName!),
          onPressed: () {
            final isNullOrEmpty = name == null || name!.isEmpty;
            if (!widget.isEmptyAllowed && isNullOrEmpty) {
              setState(() {
                errorText =
                    context.l10n.sharezoneWidgetsTextFieldCannotBeEmptyError;
              });
              return;
            }

            if (widget.notAllowedChars == null) {
              widget.onTap(name);
            } else {
              if (!containsStringNowAllowChars(name)) {
                widget.onTap(name);
              } else {
                setState(
                  () =>
                      errorText = context.l10n
                          .sharezoneWidgetsNotAllowedCharactersError(
                            widget.notAllowedChars!,
                          ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
