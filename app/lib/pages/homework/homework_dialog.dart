// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';

import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/blocs/homework/homework_dialog_bloc.dart';
import 'package:sharezone/filesharing/dialog/attach_file.dart';
import 'package:sharezone/filesharing/dialog/course_tile.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/markdown/markdown_support.dart';
import 'package:sharezone/timetable/src/edit_time.dart';
import 'package:sharezone/util/next_lesson_calculator/next_lesson_calculator.dart';
import 'package:sharezone/widgets/material/list_tile_with_description.dart';
import 'package:sharezone/widgets/material/save_button.dart';
import 'package:sharezone_common/homework_validators.dart';
import 'package:sharezone_common/validators.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';

class HomeworkDialog extends StatefulWidget {
  const HomeworkDialog({
    Key? key,
    this.homework,
    required this.homeworkDialogApi,
    required this.nextLessonCalculator,
  }) : super(key: key);

  static const tag = "homework-dialog";

  final HomeworkDto? homework;
  final HomeworkDialogApi homeworkDialogApi;
  final NextLessonCalculator nextLessonCalculator;

  @override
  State createState() => _HomeworkDialogState();
}

class _HomeworkDialogState extends State<HomeworkDialog> {
  late HomeworkDialogBloc bloc;

  @override
  void initState() {
    final markdownAnalytics = BlocProvider.of<MarkdownAnalytics>(context);
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    bloc = HomeworkDialogBloc(
      widget.homeworkDialogApi,
      widget.nextLessonCalculator,
      markdownAnalytics,
      homework: widget.homework,
      analytics,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: __HomeworkDialog(
        homework: widget.homework,
        bloc: bloc,
      ),
    );
  }
}

class HwDialogKeys {
  static const Key titleTextField = Key("title-field");
  static const Key courseTile = Key("course-tile");
  static const Key todoUntilTile = Key("todo-until-tile");
  static const Key submissionTile = Key("submission-tile");
  static const Key submissionTimeTile = Key("submission-time-tile");
  static const Key descriptionField = Key("description-field");
  static const Key addAttachmentTile = Key("add-attachment-tile");
  static const Key attachmentOverflowMenuIcon = Key("attachment-overflow-menu");
  static const Key notifyCourseMembersTile = Key("notify-course-members-tile");
  static const Key isPrivateTile = Key("is-private-tile");
  static const Key saveButton = Key("save-button");
}

class __HomeworkDialog extends StatefulWidget {
  const __HomeworkDialog({Key? key, this.homework, this.bloc})
      : super(key: key);

  final HomeworkDto? homework;
  final HomeworkDialogBloc? bloc;

  @override
  __HomeworkDialogState createState() => __HomeworkDialogState();
}

class __HomeworkDialogState extends State<__HomeworkDialog> {
  final titleNode = FocusNode();
  bool editMode = false;

  @override
  void initState() {
    if (widget.homework != null) editMode = true;
    delayKeyboard(context: context, focusNode: titleNode);
    super.initState();
  }

  Future<void> leaveDialog() async {
    if (widget.bloc!.hasInputChanged()) {
      final confirmedLeave = await warnUserAboutLeavingForm(context);
      if (confirmedLeave && context.mounted) Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.bloc!.hasInputChanged()
          ? warnUserAboutLeavingForm(context)
          : Future.value(true),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _AppBar(
                oldHomework: widget.homework,
                editMode: editMode,
                focusNodeTitle: titleNode,
                onCloseTap: () => leaveDialog(),
                titleField: _TitleField(
                  focusNode: titleNode,
                  prefilledTitle: widget.homework?.title,
                )),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    _CourseTile(editMode: editMode),
                    const _MobileDivider(),
                    _TodoUntilPicker(),
                    const _MobileDivider(),
                    _SubmissionsSwitch(),
                    const _MobileDivider(),
                    _DescriptionField(
                        prefilledDescription: widget.homework?.description),
                    const _MobileDivider(),
                    _AttachFile(),
                    const _MobileDivider(),
                    _SendNotification(editMode: editMode),
                    const _MobileDivider(),
                    _PrivateHomeworkSwitch(editMode: editMode),
                    const _MobileDivider(),
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
  const _MobileDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (PlatformCheck.isDesktopOrWeb) return Container();
    return const Divider(height: 0);
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key, this.editMode = false}) : super(key: key);

  final bool editMode;

  Future<void> onPressed(BuildContext context) async {
    final bloc = BlocProvider.of<HomeworkDialogBloc>(context);
    final hasAttachments = bloc.hasAttachments;
    try {
      if (bloc.isValid()) {
        sendDataToFrankfurtSnackBar(context);

        if (editMode) {
          if (hasAttachments) {
            await bloc.submit();
            if (!context.mounted) return;
          } else {
            bloc.submit();
          }
          hideSendDataToFrankfurtSnackBar(context);
          Navigator.pop(context, true);
        } else {
          hasAttachments ? await bloc.submit() : bloc.submit();
          if (!context.mounted) return;
          hideSendDataToFrankfurtSnackBar(context);
          Navigator.pop(context, true);
        }
      }
    } on InvalidTitleException {
      showSnackSec(
        text: TextValidationException(HomeworkValidators.emptyTitleUserMessage)
            .toString(),
        context: context,
      );
    } on InvalidCourseException {
      showSnackSec(
        text: TextValidationException(HomeworkValidators.emptyCourseUserMessage)
            .toString(),
        context: context,
      );
    } on InvalidTodoUntilException {
      showSnackSec(
        text:
            TextValidationException(HomeworkValidators.emptyDueDateUserMessage)
                .toString(),
        context: context,
      );
    } on Exception catch (e) {
      log("Exception when submitting: $e", error: e);
      showSnackSec(
        text:
            "Es gab einen unbekannten Fehler (${e.toString()}) 😖 Bitte kontaktiere den Support!",
        context: context,
        seconds: 5,
      );
    }
  }

  void hideSendDataToFrankfurtSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    return SaveButton(
      tooltip: "Hausaufgabe speichern",
      onPressed: () => onPressed(context),
    );
  }
}

class _TodoUntilPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: StreamBuilder<DateTime>(
          stream: bloc.todoUntil,
          builder: (context, snapshot) => DefaultTextStyle.merge(
            style: TextStyle(
              color: snapshot.hasError ? Colors.red : null,
            ),
            child: DatePicker(
              key: HwDialogKeys.todoUntilTile,
              padding: const EdgeInsets.all(12),
              selectedDate: snapshot.data,
              selectDate: bloc.changeTodoUntil,
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key? key,
    required this.oldHomework,
    required this.editMode,
    required this.focusNodeTitle,
    required this.onCloseTap,
    required this.titleField,
  }) : super(key: key);

  final HomeworkDto? oldHomework;
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
                    key: HwDialogKeys.saveButton,
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

class _TitleField extends StatelessWidget {
  const _TitleField({
    required this.focusNode,
    this.prefilledTitle,
  });

  final String? prefilledTitle;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: StreamBuilder<String>(
          stream: bloc.title,
          builder: (context, snapshot) {
            return _TitleFieldBase(
              prefilledTitle: prefilledTitle,
              focusNode: focusNode,
              onChanged: bloc.changeTitle,
              errorText: snapshot.error?.toString(),
            );
          }),
    );
  }
}

class _TitleFieldBase extends StatelessWidget {
  const _TitleFieldBase({
    Key? key,
    required this.prefilledTitle,
    required this.onChanged,
    this.errorText,
    this.focusNode,
  }) : super(key: key);

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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PrefilledTextField(
                key: HwDialogKeys.titleTextField,
                prefilledText: prefilledTitle,
                focusNode: focusNode,
                cursorColor: Colors.white,
                maxLines: null,
                style: const TextStyle(color: Colors.white, fontSize: 22),
                decoration: const InputDecoration(
                  hintText: "Titel eingeben (z.B. AB Nr. 1 - 3)",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
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
  const _CourseTile({Key? key, required this.editMode}) : super(key: key);

  final bool editMode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: CourseTile(
          key: HwDialogKeys.courseTile,
          courseStream: bloc.courseSegment,
          onChanged: bloc.changeCourseSegment,
          editMode: editMode,
        ),
      ),
    );
  }
}

class _SendNotification extends StatelessWidget {
  const _SendNotification({Key? key, this.editMode = true}) : super(key: key);

  final bool editMode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: StreamBuilder<bool>(
          stream: bloc.sendNotification,
          builder: (context, snapshot) {
            final sendNotification = snapshot.data ?? false;
            return _SendNotificationBase(
              title:
                  "Kursmitglieder ${editMode ? "über die Änderungen " : ""}benachrichtigen",
              onChanged: bloc.changeSendNotification,
              sendNotification: sendNotification,
              description: editMode
                  ? null
                  : "Sende eine Benachrichtigung an deine Kursmitglieder, dass du eine neue Hausaufgabe erstellt hast.",
            );
          },
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
      key: HwDialogKeys.notifyCourseMembersTile,
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

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.prefilledDescription});

  final String? prefilledDescription;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkDialogBloc>(context);
    return _DescriptionFieldBase(
      onChanged: bloc.changeDescription,
      prefilledDescription: prefilledDescription,
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
                  key: HwDialogKeys.descriptionField,
                  prefilledText: prefilledDescription,
                  maxLines: null,
                  scrollPadding: const EdgeInsets.all(16.0),
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: "Zusatzinformationen eingeben",
                    border: InputBorder.none,
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

class _AttachFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: AttachFile(
          key: HwDialogKeys.addAttachmentTile,
          addLocalFileToBlocMethod: (localFile) => bloc.addLocalFile(localFile),
          removeLocalFileFromBlocMethod: (localFile) =>
              bloc.removeLocalFile(localFile),
          removeCloudFileFromBlocMethod: (cloudFile) =>
              bloc.removeCloudFile(cloudFile),
          localFilesStream: bloc.localFiles,
          cloudFilesStream: bloc.cloudFiles,
        ),
      ),
    );
  }
}

typedef _SubmissionsData = ({
  bool isSubmissionEnableable,
  Time submissionTime,
  bool withSubmissions
});

class _SubmissionsSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkDialogBloc>(context);

    final combined =
        CombineLatestStream.combine3<bool, Time, bool, _SubmissionsData>(
      bloc.isSubmissionEnableable,
      bloc.submissionTime,
      bloc.withSubmissions,
      (a, b, c) {
        return (
          isSubmissionEnableable: a,
          submissionTime: b,
          withSubmissions: c,
        );
      },
    );

    return MaxWidthConstraintBox(
      child: StreamBuilder(
        stream: combined,
        builder: (context, snapshot) {
          final isEnabled = snapshot.data?.isSubmissionEnableable ?? true;
          final withSubmissions = snapshot.data?.withSubmissions ?? false;
          final time = snapshot.data?.submissionTime;

          return _SubmissionsSwitchBase(
            key: HwDialogKeys.submissionTile,
            isWidgetEnabled: isEnabled,
            submissionsEnabled: withSubmissions,
            onChanged: (newVal) => bloc.changeWithSubmissions(newVal),
            onTimeChanged: (newTime) => bloc.changeSubmissionTime(newTime),
            time: time,
          );
        },
      ),
    );
  }
}

class _SubmissionsSwitchBase extends StatelessWidget {
  const _SubmissionsSwitchBase({
    Key? key,
    required this.isWidgetEnabled,
    required this.submissionsEnabled,
    required this.onChanged,
    required this.onTimeChanged,
    required this.time,
  }) : super(key: key);

  final bool isWidgetEnabled;
  final bool submissionsEnabled;
  final Function(bool) onChanged;
  final Function(Time) onTimeChanged;
  final Time? time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.folder_open),
          title: const Text("Mit Abgabe"),
          onTap: isWidgetEnabled ? () => onChanged(!submissionsEnabled) : null,
          trailing: Switch.adaptive(
            value: submissionsEnabled,
            onChanged: isWidgetEnabled ? onChanged : null,
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: submissionsEnabled
              ? ListTile(
                  key: HwDialogKeys.submissionTimeTile,
                  title: const Text("Abgabe-Uhrzeit"),
                  onTap: () async {
                    await hideKeyboardWithDelay(context: context);
                    if (!context.mounted) return;

                    final initialTime = time == Time(hour: 23, minute: 59)
                        ? Time(hour: 18, minute: 0)
                        : time;
                    final newTime =
                        await selectTime(context, initialTime: initialTime);
                    if (newTime != null) {
                      onTimeChanged(newTime);
                    }
                  },
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(time.toString()),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}

class _PrivateHomeworkSwitch extends StatelessWidget {
  const _PrivateHomeworkSwitch({
    Key? key,
    required this.editMode,
  }) : super(key: key);

  final bool editMode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: StreamBuilder<bool>(
          stream: bloc.private,
          builder: (context, snapshot) {
            return _PrivateHomeworkSwitchBase(
              key: HwDialogKeys.isPrivateTile,
              isPrivate: snapshot.data ?? false,
              onChanged: editMode ? null : bloc.changePrivate,
            );
          },
        ),
      ),
    );
  }
}

class _PrivateHomeworkSwitchBase extends StatelessWidget {
  const _PrivateHomeworkSwitchBase({
    required this.isPrivate,
    this.onChanged,
    super.key,
  });

  final bool isPrivate;

  /// Called when the user changes if the homework is private.
  ///
  /// Passing `null` disables the tile.
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onChanged != null;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: const Icon(Icons.security),
      title: const Text("Privat"),
      subtitle: const Text("Hausaufgabe nicht mit dem Kurs teilen."),
      enabled: isEnabled,
      trailing: Switch.adaptive(
        value: isPrivate,
        onChanged: isEnabled ? onChanged! : null,
      ),
      onTap: isEnabled ? () => onChanged!(!isPrivate) : null,
    );
  }
}
