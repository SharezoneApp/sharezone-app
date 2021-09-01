import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/src/dialog_wrapper.dart';

import '../adapative_dialog_action.dart';

Future<T> showColumnActionsAdaptiveDialog<T>({
  @required BuildContext context,
  @required List<AdaptiveDialogAction<T>> actions,
  String title,
  String messsage,
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
    Key key,
    this.actions,
    this.title,
    this.message,
  }) : super(key: key);

  final List<AdaptiveDialogAction<T>> actions;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: DialogWrapper(child: Text(message)),
      actions: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: actions
              .map((action) => TextButton(
                    child: Text(action.title.toUpperCase()),
                    style: TextButton.styleFrom(
                      primary:
                          action.textColor ?? Theme.of(context).primaryColor,
                    ),
                    onPressed: () => Navigator.pop(context, action.popResult),
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
      {Key key, this.actions, this.title, this.message})
      : super(key: key);

  final List<AdaptiveDialogAction<T>> actions;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: isNotEmptyOrNull(title) ? Text(title) : null,
      content: isNotEmptyOrNull(message) ? Text(message) : null,
      actions: <Widget>[
        ...actions
            .map((action) => CupertinoDialogAction(
                  child: Text(action.title),
                  isDefaultAction: action.isDefaultAction,
                  isDestructiveAction: action.isDestructiveAction,
                  onPressed: () => Navigator.pop(context, action.popResult),
                ))
            .toList(),
        CupertinoDialogAction(
            child: const Text("Abbrechen"),
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context))
      ],
    );
  }
}
