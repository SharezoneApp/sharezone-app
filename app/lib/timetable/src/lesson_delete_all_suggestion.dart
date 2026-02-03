// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:clock/clock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/timetable_permissions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

class LessonDeleteAllSuggestion {
  static const Duration _window = Duration(seconds: 90);
  static const Duration _cooldown = Duration(seconds: 90);
  static const int _threshold = 3;

  static final List<DateTime> _recentDeletes = <DateTime>[];
  static DateTime? _lastShownAt;

  static void recordLessonDeletion(BuildContext context) {
    final now = clock.now();
    _recentDeletes.removeWhere((time) => now.difference(time) > _window);
    _recentDeletes.add(now);

    if (_recentDeletes.length <= _threshold) return;
    _maybeShow(context, now);
  }

  static void _maybeShow(BuildContext context, DateTime now) {
    if (_lastShownAt != null && now.difference(_lastShownAt!) < _cooldown) {
      return;
    }

    _lastShownAt = now;
    showOverlayNotification(
      (overlayContext) => OverlayCard(
        title: Text(overlayContext.l10n.timetableDeleteAllSuggestionTitle),
        content: Text(overlayContext.l10n.timetableDeleteAllSuggestionBody),
        actionText: overlayContext.l10n.timetableDeleteAllSuggestionAction,
        onAction: () async {
          OverlaySupportEntry.of(overlayContext)!.dismiss();
          await _confirmDeleteAllLessons(overlayContext);
        },
        onClose: () => OverlaySupportEntry.of(overlayContext)!.dismiss(),
      ),
      duration: const Duration(seconds: 8),
    );
  }

  static Future<void> _confirmDeleteAllLessons(BuildContext context) async {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final lessons = await api.timetable.streamLessons().first;
    final groupInfos = await api.course
        .getGroupInfoStream(api.schoolClassGateway)
        .first;
    final deletableLessons = _filterDeletableLessons(lessons, groupInfos);

    if (deletableLessons.isEmpty) {
      showSnackSec(
        text: context.l10n.timetableSettingsDeleteAllLessonsSubtitleNoAccess,
        context: context,
        seconds: 2,
        behavior: SnackBarBehavior.fixed,
      );
      return;
    }

    final confirmed = await showDeleteAllLessonsConfirmationDialog(
      context,
      deletableLessonsCount: deletableLessons.length,
    );

    if (confirmed == true && context.mounted) {
      await api.timetable.deleteLessons(deletableLessons);
      if (!context.mounted) return;
      showSnackSec(
        text: context.l10n.timetableSettingsDeleteAllLessonsConfirmation,
        context: context,
        seconds: 2,
        behavior: SnackBarBehavior.fixed,
      );
    }
  }

  static List<Lesson> _filterDeletableLessons(
    List<Lesson> lessons,
    Map<String, GroupInfo> groupInfos,
  ) {
    return lessons.where((lesson) {
      final role = groupInfos[lesson.groupID]?.myRole;
      if (role == null) return false;
      return hasPermissionToManageLessons(role);
    }).toList();
  }
}

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
