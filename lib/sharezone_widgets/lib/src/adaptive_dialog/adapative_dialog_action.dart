import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdaptiveDialogAction<T> {
  final Key key;
  final String title;
  final Color textColor;
  final T popResult;
  final VoidCallback onPressed;

  /// Set to true if button is the default choice in the dialog.
  ///
  /// Default buttons have bold text. Similar to
  /// [UIAlertController.preferredAction](https://developer.apple.com/documentation/uikit/uialertcontroller/1620102-preferredaction),
  /// but more than one action can have this attribute set to true in the same
  /// [CupertinoAlertDialog].
  ///
  /// This parameters defaults to false and cannot be null.
  final bool isDefaultAction;

  /// Whether this action destroys an object.
  ///
  /// For example, an action that deletes an email is destructive.
  ///
  /// Defaults to false and cannot be null.
  final bool isDestructiveAction;

  const AdaptiveDialogAction({
    this.title,
    this.popResult,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    this.textColor,
    this.onPressed,
    this.key,
  });

  static const AdaptiveDialogAction<bool> delete = AdaptiveDialogAction(
    title: "Löschen",
    popResult: true,
    isDefaultAction: true,
    isDestructiveAction: true,
    textColor: Colors.red,
  );

  static const AdaptiveDialogAction<bool> cancle = AdaptiveDialogAction(
    title: "Abbrechen",
    popResult: false,
  );

  static const AdaptiveDialogAction<bool> leave = AdaptiveDialogAction(
    title: "Verlassen",
    textColor: Colors.red,
    isDefaultAction: true,
    isDestructiveAction: true,
    popResult: true,
  );

  static const AdaptiveDialogAction<bool> continue_ = AdaptiveDialogAction(
    title: "Weiter",
    textColor: Colors.red,
    isDefaultAction: true,
    isDestructiveAction: false,
    popResult: true,
  );

  static const AdaptiveDialogAction<bool> ok = AdaptiveDialogAction(
    title: "Ok",
    isDefaultAction: true,
    popResult: false,
  );
}
