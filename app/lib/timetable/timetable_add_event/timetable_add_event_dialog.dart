// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:build_context/build_context.dart';
import 'package:clock/clock.dart';
import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:platform_check/platform_check.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/filesharing/dialog/course_tile.dart';
import 'package:sharezone/homework/homework_dialog/homework_dialog.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/widgets/material/list_tile_with_description.dart';
import 'package:sharezone/widgets/material/save_button.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';

import 'src/timetable_add_event_dialog_src.dart';

TimeOfDay Function()? _timePickerOverride;

Future<void> openEventDialogAndShowConfirmationIfSuccessful(
    BuildContext context,
    {required bool isExam}) async {
  final successful = await Navigator.push<bool>(
    context,
    IgnoreWillPopScopeWhenIosSwipeBackRoute(
      builder: (context) => TimetableAddEventDialog(isExam: isExam),
      settings: const RouteSettings(name: TimetableAddEventDialog.tag),
    ),
  );

  if (successful == true && context.mounted) {
    await _showUserConfirmationOfEventArrival(context: context);
  }
}

Future<void> _showUserConfirmationOfEventArrival({
  required BuildContext context,
}) async {
  await waitingForPopAnimation();
  if (!context.mounted) return;
  showDataArrivalConfirmedSnackbar(context: context);
}

/// [TimetableAddEventDialog.controller] can't be final because then using `??=`
/// in the build method (to assign the controller if not null) will throw this
/// error:
/// ```
/// LateInitializationError: Field 'controller' has already been initialized
/// ```
/// Not using final will cause the linter to complain about the lint below, so
/// we have to ignore it.
// ignore: must_be_immutable
class TimetableAddEventDialog extends StatelessWidget {
  TimetableAddEventDialog({
    super.key,
    required this.isExam,
    @visibleForTesting this.controller,
    @visibleForTesting TimeOfDay Function()? showTimePickerTestOverride,
    @visibleForTesting FocusNode? titleFocusNode,
  }) {
    this.titleFocusNode = titleFocusNode ?? FocusNode();
    _timePickerOverride = showTimePickerTestOverride;
  }

  final bool isExam;
  late AddEventDialogController? controller;
  late final FocusNode titleFocusNode;
  bool _hasRequestedTitleFocus = false;

  static const tag = "timetable-event-dialog";

  bool hasModifiedData() {
    return controller!.title.isNotEmpty || controller!.description.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasRequestedTitleFocus) {
      _hasRequestedTitleFocus = true;
      delayKeyboard(context: context, focusNode: titleFocusNode);
    }
    controller ??= AddEventDialogController(
      isExam: isExam,
      api: EventDialogApi(BlocProvider.of<SharezoneContext>(context).api),
      markdownAnalytics: BlocProvider.of<MarkdownAnalytics>(context),
    );
    return ChangeNotifierProvider(
      create: (context) => controller,
      builder: (context, __) => PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return;

            final hasInputChanged = hasModifiedData();
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
                    editMode: false,
                    isExam: isExam,
                    titleField: _TitleField(
                      key: EventDialogKeys.titleTextField,
                      focusNode: titleFocusNode,
                      isExam: isExam,
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
                          textFieldKey: EventDialogKeys.descriptionTextField,
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
          )),
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
    required this.titleField,
    required this.isExam,
  });

  final bool editMode;
  final Widget titleField;
  final bool isExam;

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
                  CloseButton(
                    color: context.isDarkThemeEnabled
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).colorScheme.onPrimary,
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
    try {
      final success = await controller.createEvent();
      if (success && context.mounted) {
        Navigator.pop<bool>(context, true);
      }
    } catch (e) {
      log("Exception when submitting: $e", error: e);
      if (context.mounted) {
        showSnackSec(
          text:
              "Es gab einen unbekannten Fehler (${e.toString()}) 😖 Bitte kontaktiere den Support!",
          context: context,
          seconds: 5,
        );
        return;
      }
    }
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
  });

  final FocusNode focusNode;
  final bool isExam;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AddEventDialogController>(context);
    return MaxWidthConstraintBox(
      child: _TitleFieldBase(
          prefilledTitle: controller.title,
          focusNode: focusNode,
          onChanged: (newTitle) {
            Provider.of<AddEventDialogController>(context, listen: false)
                .title = newTitle;
          },
          hintText: isExam
              ? 'Titel (z.B. Statistik-Klausur)'
              : 'Titel eingeben (z.B. Sportfest)',
          errorText: controller.showEmptyTitleError
              ? EventDialogErrorStrings.emptyTitle
              : null),
    );
  }
}

class _TitleFieldBase extends StatelessWidget {
  const _TitleFieldBase({
    required this.prefilledTitle,
    required this.onChanged,
    this.focusNode,
    required this.hintText,
    this.errorText,
  });

  final String? prefilledTitle;
  final FocusNode? focusNode;
  final String hintText;
  final String? errorText;
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
                key: HwDialogKeys.titleTextField,
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
    final controller = Provider.of<AddEventDialogController>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: CourseTileBase(
          key: EventDialogKeys.courseTile,
          courseName:
              controller.course?.name ?? HwDialogErrorStrings.emptyCourse,
          errorText: controller.showEmptyCourseError
              ? EventDialogErrorStrings.emptyCourse
              : null,
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
                    key: EventDialogKeys.endDateField,
                    date: controller.date,
                    timeFieldKey: EventDialogKeys.endTimeField,
                    time: controller.endTime,
                    showEndNotAfterBeginningError:
                        controller.showEndTimeNotAfterStartTimeError,
                    isDatePickingEnabled: false,
                    onTimeChanged: (newTime) {
                      controller.endTime = newTime;
                    },
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

class _DateAndTimeTile extends StatelessWidget {
  const _DateAndTimeTile({
    super.key,
    this.leading,
    required this.date,
    required this.time,
    this.timeFieldKey,
    this.isDatePickingEnabled = true,
    required this.onTimeChanged,
    this.showEndNotAfterBeginningError = false,
  });

  final Date date;
  final Time time;
  final void Function(Time newTime) onTimeChanged;
  final Widget? leading;
  final Key? timeFieldKey;
  final bool showEndNotAfterBeginningError;
  final bool isDatePickingEnabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading ?? const SizedBox(),
      subtitle: showEndNotAfterBeginningError
          ? Text(
              EventDialogErrorStrings.endTimeMustBeAfterStartTime,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            )
          : null,
      title: GestureDetector(
        onTap: isDatePickingEnabled
            ? null
            : () {
                showLeftRightAdaptiveDialog(
                  key: EventDialogKeys.dateCantBeChangedDialog,
                  context: context,
                  title: 'Auswahl nicht möglich',
                  content: const Text(
                      'Aktuell ist nicht möglich, einen Termin oder eine Klausur über mehrere Tage hinweg zu haben.'),
                );
              },
        child: Text(
          date.parser.toYMMMEd,
          style: TextStyle(
            color: isDatePickingEnabled
                ? Theme.of(context).textTheme.bodyMedium!.color
                : Theme.of(context).disabledColor,
          ),
        ),
      ),
      trailing: TextButton(
        key: timeFieldKey,
        style: TextButton.styleFrom(
          foregroundColor: showEndNotAfterBeginningError
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).textTheme.bodyMedium!.color,
          textStyle: const TextStyle(fontSize: 15),
        ),
        onPressed: () async {
          TimeOfDay? picked;
          if (_timePickerOverride != null) {
            picked = _timePickerOverride!();
          } else {
            picked = await showTimePicker(
              context: context,
              initialTime: time.toTimeOfDay(),
            );
          }
          if (picked != null) {
            onTimeChanged(Time(hour: picked.hour, minute: picked.minute));
          }
        },
        child: Text(time.toString()),
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
    this.textFieldKey,
  });

  final Function(String) onChanged;
  final String? prefilledDescription;
  final String hintText;

  /// Key for the [PrefilledTextField] (used for testing).
  ///
  /// If the key is assigned to [_DescriptionFieldBase] from the outside via
  /// this field to the [PrefilledTextField] then calling
  /// `tester.enterText(Key('description'))` will fail because of "too many
  /// elements" for the key. I don't really understand why this happens, but
  /// assigning the key to the [PrefilledTextField] fixes the problem.
  final Key? textFieldKey;

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
                  key: textFieldKey,
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
    final controller = Provider.of<AddEventDialogController>(context);
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
                key: EventDialogKeys.locationField,
                prefilledText: controller.location,
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
                onChanged: (newLocation) {
                  controller.location = newLocation;
                },
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

class EventDialogKeys {
  static const Key saveButton = Key("save-button");
  static const Key titleTextField = Key("title-field");
  static const Key courseTile = Key("course-tile");
  static const Key descriptionTextField = Key("description-field");
  static const Key startDateField = Key("start-date-field");
  static const Key endDateField = Key("end-date-field");
  static const Key dateCantBeChangedDialog = Key("date-cant-be-changed-dialog");
  static const Key startTimeField = Key("start-time-field");
  static const Key endTimeField = Key("end-time-field");
  static const Key locationField = Key("location-field");
  static const Key notifyCourseMembersSwitch =
      Key("notify-course-members-switch");
}

class EventDialogErrorStrings {
  static const emptyTitle = "Bitte gib einen Titel ein.";
  static const emptyCourse = "Bitte wähle einen Kurs aus.";
  static const endTimeMustBeAfterStartTime =
      "Die Endzeit muss nach der Startzeit liegen.";
}
