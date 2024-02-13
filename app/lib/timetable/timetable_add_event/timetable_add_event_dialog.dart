// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:clock/clock.dart';
import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:platform_check/platform_check.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/filesharing/dialog/course_tile.dart';
import 'package:sharezone/markdown/markdown_support.dart';
import 'package:sharezone/widgets/material/list_tile_with_description.dart';
import 'package:sharezone/widgets/material/save_button.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';

final _titleNode = FocusNode();

@visibleForTesting
class EventDialogKeys {
  static const Key titleTextField = Key("title-field");
}

class AddEventDialogController extends ChangeNotifier {
  String _title = '';

  String get title => _title;

  set title(String value) {
    _title = value;
    notifyListeners();
  }
}

class TimetableAddEventDialog extends StatelessWidget {
  const TimetableAddEventDialog({super.key, required this.isExam});

  final bool isExam;

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

        // final shouldPop = await warnUserAboutLeavingForm(context);
        // if (shouldPop && context.mounted) {
        //   navigator.pop();
        // }
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _AppBar(
                // editMode: widget.isEditing,
                editMode: false,
                focusNodeTitle: _titleNode,
                // onCloseTap: () => leaveDialog(),
                onCloseTap: () {
                  Navigator.pop(context);
                },
                isExam: isExam,
                titleField: _TitleField(
                  key: EventDialogKeys.titleTextField,
                  focusNode: _titleNode,
                  isExam: isExam,

                  // state: state,
                )),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const _CourseTile(),
                    const _MobileDivider(),
                    const _DateAndTimePicker(),
                    const _MobileDivider(),
                    _DescriptionFieldBase(
                      hintText:
                          isExam ? 'Themen der Prüfung' : 'Zusatzinformationen',
                      onChanged: (p0) {},
                      prefilledDescription: '',
                    ),
                    const _MobileDivider(),
                    const _Location(),
                    const _MobileDivider(),
                    _SendNotification(isExam: isExam),
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
    required this.isExam,
  });

  final bool editMode;
  final VoidCallback onCloseTap;
  final Widget titleField;
  final bool isExam;

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
                    isExam: isExam,
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
  const _SaveButton({this.editMode = false, required this.isExam});

  final bool editMode;
  final bool isExam;

  Future<void> onPressed(BuildContext context) async {
    Navigator.pop(context);
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
      tooltip: isExam ? "Klausur speichern" : "Termin speichern",
      onPressed: () => onPressed(context),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({
    super.key,
    required this.focusNode,
    required this.isExam,
    // required this.state,
  });

  // final Ready state;
  final FocusNode focusNode;
  final bool isExam;

  @override
  Widget build(BuildContext context) {
    // final bloc = bloc_lib.BlocProvider.of<HomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: _TitleFieldBase(
        // prefilledTitle: state.title.$1,
        prefilledTitle: null,
        focusNode: focusNode,
        onChanged: (newTitle) {
          Provider.of<AddEventDialogController>(context, listen: false).title =
              newTitle;
          // bloc.add(TitleChanged(newTitle));
        },
        hintText: isExam
            ? 'Titel (z.B. Statistik-Klausur)'
            : 'Titel eingeben (z.B. Sportfest)',
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
    this.focusNode,
    required this.hintText,
  });

  final String? prefilledTitle;
  final FocusNode? focusNode;
  final String hintText;
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
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.white),
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
                // errorText ?? "",
                "",
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
                  _DateAndTimeTile(
                    leading: const Icon(Icons.today),
                    date: Date('2024-02-03'),
                    time: Time(hour: 11, minute: 00),
                  ),
                  _DateAndTimeTile(
                    date: Date('2024-02-03'),
                    time: Time(hour: 12, minute: 30),
                    isDatePickingEnabled: false,
                  ),
                  // ignore: dead_code
                  if (false) ...[
                    Row(
                      children: [
                        const SizedBox(width: 34),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const _LessonPickerPage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14))),
                          child: const Text('Schulstunde auswählen'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonPickerPage extends StatelessWidget {
  const _LessonPickerPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Hier soll die Stunde ausgewählt werden...')),
    );
  }
}

class _DateAndTimeTile extends StatelessWidget {
  const _DateAndTimeTile({
    this.leading,
    this.date,
    this.time,
    this.isDatePickingEnabled = true,
  });

  final Widget? leading;
  final Date? date;
  final Time? time;
  final bool isDatePickingEnabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading ?? const SizedBox(),
      title: Text(
        date?.parser.toYMMMEd ?? 'Datum auswählen...',
        style: TextStyle(
          color: isDatePickingEnabled
              ? Theme.of(context).textTheme.bodyMedium!.color
              : Theme.of(context).disabledColor,
        ),
      ),
      // trailing: const Text('11:30'),
      trailing: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).textTheme.bodyMedium!.color,
          textStyle: const TextStyle(fontSize: 15),
        ),
        onPressed: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(clock.now()),
          );
          log('picked: $picked');
        },
        child: Text(time?.toString() ?? ''),
      ),
      onTap: isDatePickingEnabled
          ? () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: clock.now(),
                firstDate: DateTime(2015, 8),
                lastDate: DateTime(2101),
              );
              log('picked: $picked');
            }
          : null,
    );
  }
}

class _DescriptionFieldBase extends StatelessWidget {
  const _DescriptionFieldBase({
    required this.onChanged,
    required this.prefilledDescription,
    required this.hintText,
  });

  final Function(String) onChanged;
  final String? prefilledDescription;
  final String hintText;

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
                  decoration: InputDecoration(
                    hintText: hintText,
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

class _Location extends StatelessWidget {
  const _Location();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.location_pin),
              title: PrefilledTextField(
                // key: ,
                prefilledText: '',
                maxLines: null,
                scrollPadding: const EdgeInsets.all(16.0),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: "Ort/Raum",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                ),
                onChanged: (_) {},
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SendNotification extends StatelessWidget {
  const _SendNotification({required this.isExam});

  final bool isExam;

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
              "Sende eine Benachrichtigung an deine Kursmitglieder, dass du ${isExam ? 'eine neue Klausur' : 'einen neuen Termin'} erstellt hast.",
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
