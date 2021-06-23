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
          builder: (context) => TimetableAddPage()));

  if (result != null && result.isValid) {
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

Future<TimetableResult> showTimetableAddEventPage(BuildContext context,
    {@required bool isExam}) async {
  final result = await Navigator.push<TimetableResult>(
      context,
      IgnoreWillPopScopeWhenIosSwipeBackRoute(
          builder: (context) => TimetableAddEventPage(isExam: isExam),
          settings: RouteSettings(name: TimetableAddEventPage.tag)));
  if (result != null) {
    await waitingForPopAnimation();
    showDataArrivalConfirmedSnackbar(context: context);
  }
  return result;
}

Future<void> openTimetableAddSheet(BuildContext context) async {
  final fabOptionValue = await showModalBottomSheet<_FABAddTimetableOption>(
      context: context, builder: (context) => _TimetableAddSheet());

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
                    color: isDarkThemeEnabled(context)
                        ? Colors.grey[100]
                        : Colors.grey[800],
                    fontSize: 18)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                height: 150,
                child: Stack(
                  children: const <Widget>[
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
