// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../dashboard_page.dart';

enum _DashboardFabResult { homework, exam, event, lesson, blackboard }

class _DashboardPageFAB extends StatelessWidget {
  const _DashboardPageFAB();

  Future<void> openDashboardFabSheet(BuildContext context) async {
    final analytics = DashboardAnalytics(context.read<Analytics>());
    analytics.logOpenFabSheet();

    final fabResult = await showModalBottomSheet<_DashboardFabResult>(
      isDismissible: true,
      context: context,
      builder: (context) => _DashboardFabSheet(),
    );

    if (!context.mounted) return;

    switch (fabResult) {
      case _DashboardFabResult.lesson:
        analytics.logLessonAdd();
        showTimetableAddLessonPage(context);
        break;
      case _DashboardFabResult.event:
        analytics.logEventAdd();
        openEventDialogAndShowConfirmationIfSuccessful(context, isExam: false);
        break;
      case _DashboardFabResult.exam:
        analytics.logExamAdd();
        openEventDialogAndShowConfirmationIfSuccessful(context, isExam: true);
        break;
      case _DashboardFabResult.homework:
        analytics.logHomeworkAdd();
        openHomeworkDialogAndShowConfirmationIfSuccessful(context);
        break;
      case _DashboardFabResult.blackboard:
        analytics.logBlackboardAdd();
        openBlackboardDialogAndShowConfirmationIfSuccessful(context);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MatchingTypeOfUserBuilder(
      expectedTypeOfUser: TypeOfUser.parent,
      matchesTypeOfUserWidget: Container(),
      notMatchingWidget: ModalFloatingActionButton(
        heroTag: 'sharezone-fab',
        tooltip: context.l10n.dashboardFabTooltip,
        label: context.l10n.commonActionsAdd,
        icon: const Icon(Icons.add),
        onPressed: () => openDashboardFabSheet(context),
      ),
    );
  }
}

class _DashboardFabSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              context.l10n.calendricalEventsCreateNew,
              style: TextStyle(
                color:
                    Theme.of(context).isDarkTheme
                        ? Colors.grey[100]
                        : Colors.grey[800],
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 275,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 195, bottom: 120),
                    child: ModalBottomSheetBigIconButton<_DashboardFabResult>(
                      title: context.l10n.calendricalEventsAddEvent,
                      iconData: themeIconData(
                        Icons.event,
                        cupertinoIcon: CupertinoIcons.clock,
                      ),
                      popValue: _DashboardFabResult.event,
                      tooltip: context.l10n.calendricalEventsCreateEventTooltip,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: ModalBottomSheetBigIconButton<_DashboardFabResult>(
                      title: context.l10n.calendricalEventsAddExam,
                      iconData: themeIconData(
                        Icons.school,
                        cupertinoIcon: CupertinoIcons.bookmark,
                      ),
                      popValue: _DashboardFabResult.exam,
                      tooltip: context.l10n.calendricalEventsCreateExamTooltip,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 195, bottom: 120),
                    child: ModalBottomSheetBigIconButton<_DashboardFabResult>(
                      title: context.l10n.timetableAddLessonTitle,
                      iconData: themeIconData(
                        Icons.access_time,
                        cupertinoIcon: CupertinoIcons.time,
                      ),
                      popValue: _DashboardFabResult.lesson,
                      tooltip: context.l10n.dashboardFabCreateLessonTooltip,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 110, top: 100),
                    child: ModalBottomSheetBigIconButton<_DashboardFabResult>(
                      title: context.l10n.dashboardFabAddHomeworkTitle,
                      iconData: themeIconData(
                        Icons.book,
                        cupertinoIcon: CupertinoIcons.book,
                      ),
                      popValue: _DashboardFabResult.homework,
                      tooltip: context.l10n.dashboardFabCreateHomeworkTooltip,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 110, top: 100),
                    child: ModalBottomSheetBigIconButton<_DashboardFabResult>(
                      title: context.l10n.dashboardFabAddBlackboardTitle,
                      iconData: themeIconData(
                        Icons.new_releases,
                        cupertinoIcon: CupertinoIcons.info,
                      ),
                      popValue: _DashboardFabResult.blackboard,
                      tooltip: context.l10n.blackboardPageFabTooltip,
                    ),
                  ),
                  if (kDebugMode)
                    Padding(
                      padding: const EdgeInsets.only(top: 250),
                      child: Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(
                                  context,
                                ).colorScheme.error, // foreground
                          ),
                          child: Text(context.l10n.dashboardDebugClearCache),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final cache = FlutterKeyValueStore(prefs);
                            cache.clear();
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
