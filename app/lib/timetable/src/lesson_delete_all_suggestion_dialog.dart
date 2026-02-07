// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

Future<bool?> showDeleteAllLessonsConfirmationDialog(
  BuildContext context, {
  required int deletableLessonsCount,
}) async {
  if (ThemePlatform.isCupertino) {
    return showCupertinoDialog<bool>(
      context: context,
      builder:
          (context) => DeleteAllLessonsConfirmationDialog(
            deletableLessonsCount: deletableLessonsCount,
          ),
    );
  }
  return showDialog<bool>(
    context: context,
    builder:
        (context) => DeleteAllLessonsConfirmationDialog(
          deletableLessonsCount: deletableLessonsCount,
        ),
  );
}

class DeleteAllLessonsConfirmationDialog extends StatefulWidget {
  const DeleteAllLessonsConfirmationDialog({
    super.key,
    required this.deletableLessonsCount,
  });

  final int deletableLessonsCount;

  @override
  State<DeleteAllLessonsConfirmationDialog> createState() =>
      _DeleteAllLessonsConfirmationDialogState();
}

class _DeleteAllLessonsConfirmationDialogState
    extends State<DeleteAllLessonsConfirmationDialog> {
  static const int _initialCountdownSeconds = 10;
  int _remainingSeconds = _initialCountdownSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() {
        _remainingSeconds -= 1;
      });
      if (_remainingSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ThemePlatform.isCupertino) {
      return CupertinoAlertDialog(
        title: Text(context.l10n.timetableSettingsDeleteAllLessonsDialogTitle),
        content: Text(
          context.l10n.timetableSettingsDeleteAllLessonsDialogBody(
            widget.deletableLessonsCount,
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonActionsCancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed:
                _remainingSeconds == 0
                    ? () => Navigator.pop(context, true)
                    : null,
            child: Text(_deleteLabel(context)),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(context.l10n.timetableSettingsDeleteAllLessonsDialogTitle),
      content: Text(
        context.l10n.timetableSettingsDeleteAllLessonsDialogBody(
          widget.deletableLessonsCount,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.l10n.commonActionsCancel.toUpperCase()),
        ),
        TextButton(
          onPressed:
              _remainingSeconds == 0
                  ? () => Navigator.pop(context, true)
                  : null,
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(_deleteLabel(context).toUpperCase()),
        ),
      ],
    );
  }

  String _deleteLabel(BuildContext context) {
    if (_remainingSeconds > 0) {
      return context.l10n.timetableDeleteAllDialogDeleteCountdown(
        _remainingSeconds,
      );
    }
    return context.l10n.commonActionsDelete;
  }
}
