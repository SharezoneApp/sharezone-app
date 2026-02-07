// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/timetable/src/lesson_delete_all_suggestion_dialog.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/timetable_permissions.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

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
    final groupInfos =
        await api.course.getGroupInfoStream(api.schoolClassGateway).first;
    final deletableLessons = _filterDeletableLessons(lessons, groupInfos);

    if (!context.mounted) return;

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
      api.timetable.deleteLessons(deletableLessons);
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
