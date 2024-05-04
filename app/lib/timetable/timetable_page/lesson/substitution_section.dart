part of 'timetable_lesson_sheet.dart';

class _SubstitutionSection extends StatelessWidget {
  const _SubstitutionSection({
    required this.date,
    required this.hasPermissionsToManageLessons,
    required this.lesson,
  });

  final Date date;
  final bool hasPermissionsToManageLessons;
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final isDropped = lesson.getSubstitutionFor(date) is SubstitutionCanceled;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vertretungsplan',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Für ${DateFormat('dd.MM.yyyy').format(date.toDateTime)}',
                style: TextStyle(
                  fontSize: 12,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        if (isDropped)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red.withOpacity(0.1),
              child: ListTile(
                iconColor: Colors.red,
                textColor: Colors.red,
                leading: const Icon(Icons.cancel),
                title: const Text("Stunde entfällt"),
                subtitle: Text(
                  "Eingetragen von: Nils",
                  style: TextStyle(color: Colors.red.withOpacity(0.8)),
                ),
                trailing: IconButton(
                  tooltip: 'Rückgängig machen',
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                  onPressed: () {
                    final controller = context.read<SubstitutionController>();
                    controller.removeSubstitution(
                      lesson: lesson,
                      substitutionId: lesson.getSubstitutionFor(date)!.id,
                    );
                  },
                ),
              ),
            ),
          )
        else if (hasPermissionsToManageLessons) ...[
          ListTile(
            leading: const Icon(Icons.cancel),
            title: const Text("Stunde entfallen lassen"),
            onTap: () =>
                Navigator.pop(context, _LessonModelSheetAction.cancelLesson),
          ),
          ListTile(
            leading: const Icon(Icons.place_outlined),
            title: const Text("Raumänderung"),
            onTap: () =>
                Navigator.pop(context, _LessonModelSheetAction.changeRoom),
          ),
        ],
      ],
    );
  }
}

Future<void> cancelLesson(
  BuildContext context,
  Lesson lesson,
  Date date,
) async {
  final shouldNotifyMembers = await showDialog<bool>(
    context: context,
    builder: (context) => _CancelLessonDialog(),
  );
  if (shouldNotifyMembers == null) {
    // User canceled the dialog
    return;
  }

  if (!context.mounted) {
    return;
  }

  final controller = context.read<SubstitutionController>();
  controller.addCancelSubstitution(
    lesson: lesson,
    date: date,
    notifyGroupMembers: shouldNotifyMembers,
  );
  showSnackSec(
    text: 'Stunde als "Entfällt" markiert',
    context: context,
  );
}

class _CancelLessonDialog extends StatefulWidget {
  @override
  _CancelLessonDialogState createState() => _CancelLessonDialogState();
}

class _CancelLessonDialogState extends State<_CancelLessonDialog> {
  bool shouldNotifyMembers = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Stunde entfallen lassen"),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Text(
              "Möchtest du wirklich die Schulstunde für den gesamten Kurs entfallen lassen?",
            ),
          ),
          SwitchListTile.adaptive(
            title: const Text(
              'Informiere deine Kursmitglieder, dass die Stunde entfällt.',
              style: TextStyle(fontSize: 14),
            ),
            secondary: const Icon(Icons.notifications),
            value: shouldNotifyMembers,
            onChanged: (value) {
              setState(() => shouldNotifyMembers = value);
            },
          ),
        ],
      ),
      actions: <Widget>[
        const CancelButton(),
        TextButton(
          onPressed: () => Navigator.pop(context, shouldNotifyMembers),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text("ENTFALLEN LASSEN"),
        ),
      ],
    );
  }
}
