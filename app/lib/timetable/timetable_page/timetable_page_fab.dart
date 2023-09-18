// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'timetable_page.dart';

class _TimetablePageFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModalFloatingActionButton(
      icon: const Icon(Icons.add),
      tooltip: 'Stunde/Termin hinzufügen',
      heroTag: 'sharezone-fab',
      onPressed: () => openTimetableAddSheet(context),
    );
  }
}

Future<void> showTimetableAddLessonPage(BuildContext context) async {
  final result = await Navigator.push<TimetableLessonAdded>(
      context,
      IgnoreWillPopScopeWhenIosSwipeBackRoute(
          builder: (context) => const TimetableAddPage()));

  if (result?.isValid == true && context.mounted) {
    _showLessonAddConfirmation(context);
  }
}

void _showLessonAddConfirmation(BuildContext context) {
  showSnackSec(
    seconds: 2,
    context: context,
    text: 'Die Schulstunde wurde erfolgreich hinzugefügt',
  );
}

Future<TimetableResult?> showTimetableAddEventPage(
  BuildContext context, {
  required bool isExam,
}) async {
  final result = await Navigator.push<TimetableResult>(
      context,
      IgnoreWillPopScopeWhenIosSwipeBackRoute(
          builder: (context) => TimetableAddEventPage(isExam: isExam),
          settings: const RouteSettings(name: TimetableAddEventPage.tag)));
  if (result != null) {
    await waitingForPopAnimation();
    if (!context.mounted) return null;

    showDataArrivalConfirmedSnackbar(context: context);
  }
  return result;
}

Future<void> openTimetableAddSheet(BuildContext context) async {
  final fabOptionValue = await showModalBottomSheet<_FABAddTimetableOption>(
      context: context, builder: (context) => _TimetableAddSheet());
  if (!context.mounted) return;

  switch (fabOptionValue) {
    case _FABAddTimetableOption.lesson:
      showTimetableAddLessonPage(context);
      break;
    case _FABAddTimetableOption.event:
      showTimetableAddEventPage(context, isExam: false);
      break;
    case _FABAddTimetableOption.exam:
      showTimetableAddEventPage(context, isExam: true);
      break;
    case null:
      break;
  }
}

enum _FABAddTimetableOption { lesson, event, exam }

class _TimetableAddSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 20),
            Text("Neu erstellen",
                style: TextStyle(
                    color: Theme.of(context).isDarkTheme
                        ? Colors.grey[100]
                        : Colors.grey[800],
                    fontSize: 18)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                height: 150,
                child: Stack(
                  children: <Widget>[
                    ModalBottomSheetBigIconButton<_FABAddTimetableOption>(
                      title: "Schulstunde",
                      alignment: Alignment.centerLeft,
                      iconData: Icons.access_time,
                      popValue: _FABAddTimetableOption.lesson,
                      tooltip: "Neue Schulstunde erstellen",
                    ),
                    ModalBottomSheetBigIconButton<_FABAddTimetableOption>(
                      title: "Termin",
                      alignment: Alignment.center,
                      iconData: Icons.event,
                      popValue: _FABAddTimetableOption.event,
                      tooltip: "Neuen Termin erstellen",
                    ),
                    ModalBottomSheetBigIconButton<_FABAddTimetableOption>(
                      alignment: Alignment.centerRight,
                      title: "Prüfung",
                      iconData: Icons.school,
                      popValue: _FABAddTimetableOption.exam,
                      tooltip: "Neue Prüfung erstellen",
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

abstract class TimetableResult {}
