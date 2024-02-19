// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:clock/clock.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:platform_check/platform_check.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/filesharing/dialog/course_tile.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/markdown/markdown_support.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone/widgets/material/list_tile_with_description.dart';
import 'package:sharezone/widgets/material/save_button.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';

final _titleNode = FocusNode();

@visibleForTesting
class EventDialogKeys {
  static const Key titleTextField = Key("title-field");
  static const Key courseTile = Key("course-tile");
  static const Key descriptionTextField = Key("description-field");
  static const Key startDateField = Key("start-date-field");
  static const Key startTimeField = Key("start-time-field");
  static const Key endTimeField = Key("end-time-field");
  static const Key saveButton = Key("save-button");
  static const Key notifyCourseMembersSwitch =
      Key("notify-course-members-switch");
}

class EventDialogApi {
  final SharezoneGateway _api;

  EventDialogApi(this._api);

  Future<Course> loadCourse(CourseId courseId) async {
    return (await _api.course.streamCourse(courseId.id).first)!;
  }

  Future<void> createEvent(
    CreateEventCommand command,
  ) async {
    //
    print('Event created: ${command.title}');
  }
}

class CreateEventCommand {
  final String title;
  final String description;
  final CourseId courseId;
  final Date date;
  final Time startTime;
  final Time endTime;

  CreateEventCommand({
    required this.title,
    required this.description,
    required this.courseId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
}

class AddEventDialogController extends ChangeNotifier {
  AddEventDialogController({required this.api});
  final EventDialogApi api;

  String _title = '';

  String get title => _title;

  set title(String value) {
    _title = value;
    notifyListeners();
  }

  String _description = '';

  String get description => _description;

  set description(String value) {
    _description = value;
    notifyListeners();
  }

  CourseView? _course;

  CourseView? get course => _course;

  Future<void> selectCourse(CourseId courseId) async {
    final c = await api.loadCourse(courseId);
    _course = CourseView(id: courseId, name: c.name);
    notifyListeners();
  }

  Date _date = Date.fromDateTime(clock.now());

  Date get date => _date;

  set date(Date value) {
    _date = value;
    notifyListeners();
  }

  Time _startTime = Time(hour: 11, minute: 00);

  Time get startTime => _startTime;

  set startTime(Time value) {
    _startTime = value;
    notifyListeners();
  }

  Time _endTime = Time(hour: 12, minute: 00);

  Time get endTime => _endTime;

  set endTime(Time value) {
    _endTime = value;
    notifyListeners();
  }

  Future<void> createEvent() async {
    return api.createEvent(CreateEventCommand(
      title: title,
      description: description,
      courseId: course!.id,
      date: date,
      startTime: startTime,
      endTime: endTime,
    ));
  }

  bool _notifyCourseMembers = true;

  bool get notifyCourseMembers => _notifyCourseMembers;

  set notifyCourseMembers(bool value) {
    _notifyCourseMembers = value;
    notifyListeners();
  }
}

class CourseView {
  final CourseId id;
  final String name;

  CourseView({required this.id, required this.name});
}

TimeOfDay Function()? _timePickerOverride;

class TimetableAddEventDialog extends StatelessWidget {
  TimetableAddEventDialog({
    super.key,
    required this.isExam,
    @visibleForTesting this.controller,
    @visibleForTesting TimeOfDay Function()? showTimePickerTestOverride,
  }) {
    _timePickerOverride = showTimePickerTestOverride;
  }

  final bool isExam;
  late AddEventDialogController? controller;

  static const tag = "timetable-event-dialog";

  @override
  Widget build(BuildContext context) {
    controller ??= AddEventDialogController(
      api: EventDialogApi(BlocProvider.of<SharezoneContext>(context).api),
    );
    return ChangeNotifierProvider(
      create: (context) => controller,
      builder: (context, __) => PopScope(
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
                        hintText: isExam
                            ? 'Themen der Prüfung'
                            : 'Zusatzinformationen',
                        onChanged: (newDescription) {
                          Provider.of<AddEventDialogController>(context,
                                  listen: false)
                              .description = newDescription;
                        },
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
    final controller =
        Provider.of<AddEventDialogController>(context, listen: false);
    controller.createEvent();
    Navigator.pop(context);
    // TODO: Error handling?
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
      key: EventDialogKeys.saveButton,
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
    final controller = Provider.of<AddEventDialogController>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: CourseTileBase(
          key: EventDialogKeys.courseTile,
          courseName: controller.course?.name ?? '',
          errorText: null,
          onTap: () {
            CourseTile.onTap(context, onChangedId: (courseId) {
              controller.selectCourse(courseId);
            });
          },
        ),
      ),
    );
  }
}

class _DateAndTimePicker extends StatelessWidget {
  const _DateAndTimePicker();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AddEventDialogController>(context);

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
                    key: EventDialogKeys.startDateField,
                    timeFieldKey: EventDialogKeys.startTimeField,
                    leading: const Icon(Icons.today),
                    date: controller.date,
                    time: controller.startTime,
                    onTimeChanged: (newTime) {
                      controller.startTime = newTime;
                    },
                  ),
                  _DateAndTimeTile(
                    date: Date('2024-02-03'),
                    timeFieldKey: EventDialogKeys.endTimeField,
                    time: Time(hour: 12, minute: 30),
                    isDatePickingEnabled: false,
                    onTimeChanged: (newTime) {
                      controller.endTime = newTime;
                    },
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
    super.key,
    this.leading,
    this.date,
    this.time,
    this.timeFieldKey,
    this.isDatePickingEnabled = true,
    required this.onTimeChanged,
  });

  final Widget? leading;
  final Date? date;
  final Time? time;
  final void Function(Time newTime) onTimeChanged;
  final Key? timeFieldKey;
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
        key: timeFieldKey,
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).textTheme.bodyMedium!.color,
          textStyle: const TextStyle(fontSize: 15),
        ),
        onPressed: () async {
          TimeOfDay? picked;
          if (_timePickerOverride != null) {
            picked = _timePickerOverride!();
          } else {
            picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(clock.now()),
            );
          }
          if (picked != null) {
            onTimeChanged(Time(hour: picked.hour, minute: picked.minute));
          }
        },
        child: Text(time?.toString() ?? ''),
      ),
      onTap: isDatePickingEnabled
          ? () async {
              final controller =
                  Provider.of<AddEventDialogController>(context, listen: false);

              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: clock.now(),
                firstDate: DateTime(2015, 8),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                controller.date = Date.fromDateTime(picked);
              }
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
                  // TODO: If this is assigned to _DescriptionFieldBase, not
                  // PrefilledTextField, the test fails because of too many
                  // elements instead of one (for the key) when calling
                  // tester.enterText.
                  key: EventDialogKeys.descriptionTextField,
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
    final controller = Provider.of<AddEventDialogController>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: _SendNotificationBase(
          title: "Kursmitglieder benachrichtigen",
          onChanged: (newValue) {
            controller.notifyCourseMembers = newValue;
          },
          sendNotification: controller.notifyCourseMembers,
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
      leading: const Icon(Icons.notifications_active),
      title: Text(title),
      trailing: Switch.adaptive(
        key: EventDialogKeys.notifyCourseMembersSwitch,
        onChanged: onChanged,
        value: sendNotification,
      ),
      onTap: () => onChanged(!sendNotification),
      description: description != null ? Text(description!) : null,
    );
  }
}
