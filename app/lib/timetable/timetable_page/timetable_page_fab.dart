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
      builder: (context) => const TimetableAddPage(),
    ),
  );

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

void showTutorialHowToUseSubstitutionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Vertretungsplan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: min(MediaQuery.of(context).size.height * 2, 300),
                  child: const TutorialVideoPlayer(
                    aspectRatio: 4 / 2.9,
                    videoUrl: 'https://sharezone.net/substitutions-demo',
                  ),
                ),
                const SizedBox(height: 8),
                const ListTile(
                  title: Text('1. Navigiere zu der betroffenen Schulstunde.'),
                ),
                const ListTile(title: Text('2. Klicke auf die Schulstunde.')),
                const ListTile(
                  title: Text('3. Wähle die Art der Vertretung aus.'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
  );
}

Future<void> openTimetableAddSheet(BuildContext context) async {
  final fabOptionValue = await showModalBottomSheet<_FABAddTimetableOption>(
    context: context,
    builder: (context) => _TimetableAddSheet(),
  );
  if (!context.mounted || fabOptionValue == null) {
    return;
  }

  switch (fabOptionValue) {
    case _FABAddTimetableOption.lesson:
      showTimetableAddLessonPage(context);
      break;
    case _FABAddTimetableOption.event:
      openEventDialogAndShowConfirmationIfSuccessful(context, isExam: false);
      break;
    case _FABAddTimetableOption.exam:
      openEventDialogAndShowConfirmationIfSuccessful(context, isExam: true);
      break;
    case _FABAddTimetableOption.substitution:
      showTutorialHowToUseSubstitutionDialog(context);
      break;
  }
}

enum _FABAddTimetableOption { lesson, event, exam, substitution }

class _TimetableAddSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.5);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              ListTile(
                title: Text("Stundenplan", style: TextStyle(color: titleColor)),
                visualDensity: VisualDensity.compact,
              ),
              ListTile(
                title: const Text("Schulstunde"),
                leading: const Icon(Icons.access_time),
                onTap:
                    () => Navigator.pop(context, _FABAddTimetableOption.lesson),
              ),
              ListTile(
                title: const Text("Vertretungsplan"),
                leading: const Icon(Icons.cancel),
                onTap:
                    () => Navigator.pop(
                      context,
                      _FABAddTimetableOption.substitution,
                    ),
              ),
              const Divider(),
              ListTile(
                title: Text("Kalender", style: TextStyle(color: titleColor)),
                visualDensity: VisualDensity.compact,
              ),
              ListTile(
                title: const Text("Termin"),
                leading: const Icon(Icons.event),
                onTap:
                    () => Navigator.pop(context, _FABAddTimetableOption.event),
              ),
              ListTile(
                title: const Text("Prüfung"),
                leading: const Icon(Icons.school),
                onTap:
                    () => Navigator.pop(context, _FABAddTimetableOption.exam),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

abstract class TimetableResult {}
