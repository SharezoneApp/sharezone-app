// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

// Like the VoidCallback, but as a Future
typedef FutureVoidCallback = Future<void> Function();
typedef FutureBoolCallback = Future<bool> Function();
typedef FutureBoolValueChanged<T> = Future<bool> Function(T t);

Future<void> showDeleteDialog(
    {BuildContext? context,
    String? title,
    Widget? description,
    dynamic popTwiceResult,
    VoidCallback? onDelete,
    bool popTwice = true}) async {
  final result = (await showLeftRightAdaptiveDialog<bool>(
    context: context,
    title: title,
    content: description,
    defaultValue: false,
    left: AdaptiveDialogAction.cancel,
    right: AdaptiveDialogAction.delete,
  ))!;

  if (result) {
    onDelete!();
    // ignore: use_build_context_synchronously
    if (popTwice) Navigator.pop(context!, popTwiceResult);
  }
}

class LeaveEditedFormAlert extends StatelessWidget {
  const LeaveEditedFormAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Eingabe verlassen?"),
      content: Text.rich(
        TextSpan(
          text: 'Möchtest du die Eingabe wirklich beenden? Die Daten werden ',
          style: TextStyle(
              color: isDarkThemeEnabled(context) ? Colors.white : Colors.black,
              fontSize: 16.0),
          children: const <TextSpan>[
            TextSpan(
                text: 'nicht', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' gespeichert!'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: const Text('NEIN!'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: const Text('JA, VERLASSEN!'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

class OneTextFieldDialog extends StatefulWidget {
  const OneTextFieldDialog({
    Key? key,
    required this.onTap,
    required this.title,
    required this.hint,
    required this.actionName,
    this.notAllowedChars,
    this.text,
  }) : super(key: key);

  final ValueChanged<String?> onTap;
  final String? title, hint, actionName, notAllowedChars;

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
        decoration:
            InputDecoration(hintText: widget.hint, errorText: errorText),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text("ABBRECHEN"),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: Text(widget.actionName!),
          onPressed: () {
            if (widget.notAllowedChars == null) {
              widget.onTap(name);
            } else {
              if (!containsStringNowAllowChars(name)) {
                widget.onTap(name);
              } else {
                setState(() =>
                    errorText = "Folgende Zeichen sind nicht erlaubt: / ");
              }
            }
          },
        )
      ],
    );
  }
}
