import 'package:flutter/material.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone/filesharing/dialog/course_tile.dart';
import 'package:sharezone/markdown/markdown_support.dart';
import 'package:sharezone/widgets/material/list_tile_with_description.dart';
import 'package:sharezone/widgets/material/save_button.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

final _titleNode = FocusNode();

class TimetableAddEventDialog extends StatelessWidget {
  const TimetableAddEventDialog({super.key});

  static const tag = "timetable-event-dialog";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        // final hasInputChanged = hasModifiedData();
        const hasInputChanged = false;
        final navigator = Navigator.of(context);
        if (!hasInputChanged) {
          navigator.pop();
          return;
        }

        final shouldPop = await warnUserAboutLeavingForm(context);
        if (shouldPop && context.mounted) {
          navigator.pop();
        }
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _AppBar(
                // editMode: widget.isEditing,
                editMode: false,
                focusNodeTitle: _titleNode,
                // onCloseTap: () => leaveDialog(),
                onCloseTap: () {},
                titleField: _TitleField(
                  focusNode: _titleNode,
                  // state: state,
                )),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    const _CourseTile(),
                    const _MobileDivider(),
                    const _DateAndTimePicker(),
                    const _MobileDivider(),
                    _DescriptionFieldBase(
                      onChanged: (p0) {},
                      prefilledDescription: '',
                    ),
                    const _MobileDivider(),
                    const _SendNotification(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileDivider extends StatelessWidget {
  const _MobileDivider();

  @override
  Widget build(BuildContext context) {
    if (PlatformCheck.isDesktopOrWeb) return const SizedBox(height: 4);
    return const Divider(height: 0);
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.editMode,
    required this.focusNodeTitle,
    required this.onCloseTap,
    required this.titleField,
  });

  final bool editMode;
  final VoidCallback onCloseTap;
  final Widget titleField;

  final FocusNode focusNodeTitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).isDarkTheme
          ? Theme.of(context).appBarTheme.backgroundColor
          : Theme.of(context).primaryColor,
      elevation: 1,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 6, 6, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: onCloseTap,
                    tooltip: "Schließen",
                  ),
                  _SaveButton(
                    editMode: editMode,
                  ),
                ],
              ),
            ),
            titleField,
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({this.editMode = false});

  final bool editMode;

  Future<void> onPressed(BuildContext context) async {
    // final bloc = bloc_lib.BlocProvider.of<HomeworkDialogBloc>(context);
    // try {
    //   bloc.add(const Save());
    // } on Exception catch (e) {
    //   log("Exception when submitting: $e", error: e);
    //   showSnackSec(
    //     text:
    //         "Es gab einen unbekannten Fehler (${e.toString()}) 😖 Bitte kontaktiere den Support!",
    //     context: context,
    //     seconds: 5,
    //   );
    // }
  }

  void hideSendDataToFrankfurtSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    return SaveButton(
      // key: HwDialogKeys.saveButton,
      tooltip: "Termin speichern",
      onPressed: () => onPressed(context),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({
    required this.focusNode,
    // required this.state,
  });

  // final Ready state;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    // final bloc = bloc_lib.BlocProvider.of<HomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: _TitleFieldBase(
        // prefilledTitle: state.title.$1,
        prefilledTitle: null,
        focusNode: focusNode,
        onChanged: (newTitle) {
          // bloc.add(TitleChanged(newTitle));
        },
        // errorText: state.title.error is EmptyTitleException
        //     ? HwDialogErrorStrings.emptyTitle
        //     : state.title.error?.toString(),
      ),
    );
  }
}

class _TitleFieldBase extends StatelessWidget {
  const _TitleFieldBase({
    required this.prefilledTitle,
    required this.onChanged,
    this.errorText,
    this.focusNode,
  });

  final String? prefilledTitle;
  final String? errorText;
  final FocusNode? focusNode;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 3,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20)
              .add(const EdgeInsets.only(top: 8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PrefilledTextField(
                // key: HwDialogKeys.titleTextField,
                prefilledText: prefilledTitle,
                focusNode: focusNode,
                cursorColor: Colors.white,
                maxLines: null,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
                decoration: const InputDecoration(
                  hintText: "Titel eingeben (z.B. Sportfest)",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  fillColor: Colors.transparent,
                ),
                onChanged: onChanged,
                textCapitalization: TextCapitalization.sentences,
              ),
              Text(
                errorText ?? "",
                style: TextStyle(color: Colors.red[700], fontSize: 12),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: CourseTileBase(
          // key: HwDialogKeys.courseTile,
          courseName: null,
          errorText: null,
          onTap: () {},
        ),
      ),
    );
  }
}

class _DateAndTimePicker extends StatelessWidget {
  const _DateAndTimePicker();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle.merge(
              style: const TextStyle(
                color: null,
                // color: state.dueDate.error != null ? Colors.red : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.today),
                    title: const Text('Do. 1 Feb. 2024'),
                    trailing: const Text('11:30'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const SizedBox(),
                    title: const Text('Do. 1 Feb. 2024'),
                    trailing: const Text('12:30'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const SizedBox(),
                    title: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Schulstunde auswählen'),
                    ),
                    trailing: const SizedBox(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DescriptionFieldBase extends StatelessWidget {
  const _DescriptionFieldBase({
    required this.onChanged,
    required this.prefilledDescription,
  });

  final Function(String) onChanged;
  final String? prefilledDescription;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.subject),
                title: PrefilledTextField(
                  // key: HwDialogKeys.descriptionField,
                  prefilledText: prefilledDescription,
                  maxLines: null,
                  scrollPadding: const EdgeInsets.all(16.0),
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: "Zusatzinformationen eingeben",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                  ),
                  onChanged: onChanged,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: MarkdownSupport(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SendNotification extends StatelessWidget {
  const _SendNotification();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: _SendNotificationBase(
          title: "Kursmitglieder benachrichtigen",
          onChanged: (newValue) {},
          sendNotification: true,
          description:
              "Sende eine Benachrichtigung an deine Kursmitglieder, dass du einen neuen Termin erstellt hast.",
        ),
      ),
    );
  }
}

class _SendNotificationBase extends StatelessWidget {
  const _SendNotificationBase({
    required this.title,
    required this.sendNotification,
    required this.onChanged,
    this.description,
  });

  final String title;
  final String? description;
  final bool sendNotification;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTileWithDescription(
      // key: HwDialogKeys.notifyCourseMembersTile,
      leading: const Icon(Icons.notifications_active),
      title: Text(title),
      trailing: Switch.adaptive(
        onChanged: onChanged,
        value: sendNotification,
      ),
      onTap: () => onChanged(!sendNotification),
      description: description != null ? Text(description!) : null,
    );
  }
}
