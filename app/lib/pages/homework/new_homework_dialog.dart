// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc_lib show BlocProvider;
import 'package:flutter_bloc/flutter_bloc.dart' hide BlocProvider;
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/blocs/dashbord_widgets_blocs/holiday_bloc.dart';
import 'package:sharezone/blocs/homework/homework_dialog_bloc.dart'
    hide HomeworkDialogBloc;
import 'package:sharezone/blocs/homework/new_homework_dialog_bloc.dart';
import 'package:sharezone/filesharing/dialog/attach_file.dart';
import 'package:sharezone/filesharing/dialog/course_tile.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/markdown/markdown_support.dart';
import 'package:sharezone/timetable/src/edit_time.dart';
import 'package:sharezone/util/next_lesson_calculator/next_lesson_calculator.dart';
import 'package:sharezone/widgets/material/list_tile_with_description.dart';
import 'package:sharezone/widgets/material/save_button.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';

class NewHomeworkDialog extends StatefulWidget {
  const NewHomeworkDialog({
    Key? key,
    required this.id,
    this.homeworkDialogApi,
    this.nextLessonCalculator,
  }) : super(key: key);

  static const tag = "homework-dialog";

  final HomeworkId? id;
  final HomeworkDialogApi? homeworkDialogApi;
  final NextLessonCalculator? nextLessonCalculator;

  @override
  State createState() => _HomeworkDialogState();
}

class _HomeworkDialogState extends State<NewHomeworkDialog> {
  late NewHomeworkDialogBloc bloc;
  late Future<HomeworkDto?> homework;

  @override
  void initState() {
    super.initState();
    final markdownAnalytics = BlocProvider.of<MarkdownAnalytics>(context);
    final szContext = BlocProvider.of<SharezoneContext>(context);
    final analytics = szContext.analytics;

    late NextLessonCalculator nextLessonCalculator;
    if (widget.nextLessonCalculator != null) {
      widget.nextLessonCalculator!;
    } else {
      final holidayManager =
          BlocProvider.of<HolidayBloc>(context).holidayManager;
      nextLessonCalculator = NextLessonCalculator(
          timetableGateway: szContext.api.timetable,
          userGateway: szContext.api.user,
          holidayManager: holidayManager);
    }

    if (widget.id != null) {
      homework = szContext.api.homework
          .singleHomework(widget.id!.id, source: Source.cache)
          .then((value) {
        bloc = NewHomeworkDialogBloc(
          homeworkId: widget.id,
          api: widget.homeworkDialogApi ?? HomeworkDialogApi(szContext.api),
        );
        return value;
      });
    } else {
      homework = Future.value(null);
      bloc = NewHomeworkDialogBloc(
        api: widget.homeworkDialogApi ?? HomeworkDialogApi(szContext.api),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: homework,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error!.toString()));
        }
        return bloc_lib.BlocProvider(
          create: (context) => bloc,
          child: __HomeworkDialog(
            isEditing: snapshot.data != null,
            bloc: bloc,
          ),
        );
      },
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
  const __HomeworkDialog(
      {Key? key, required this.isEditing, required this.bloc})
      : super(key: key);

  final bool isEditing;
  final NewHomeworkDialogBloc bloc;

  @override
  __HomeworkDialogState createState() => __HomeworkDialogState();
}

class __HomeworkDialogState extends State<__HomeworkDialog> {
  final titleNode = FocusNode();

  @override
  void initState() {
    delayKeyboard(context: context, focusNode: titleNode);
    super.initState();
  }

  bool hasModifiedData() {
    final state = widget.bloc.state;
    return state is Ready && state.hasModifiedData;
  }

  Future<void> leaveDialog() async {
    if (hasModifiedData()) {
      final confirmedLeave = await warnUserAboutLeavingForm(context);
      if (confirmedLeave && context.mounted) Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewHomeworkDialogBloc, HomeworkDialogState>(
      builder: (context, state) {
        return switch (state) {
          LoadingHomework() => const Center(child: CircularProgressIndicator()),
          // TODO
          SavedSucessfully() => Container(),
          Ready() => WillPopScope(
              onWillPop: () async => hasModifiedData()
                  ? warnUserAboutLeavingForm(context)
                  : Future.value(true),
              child: Scaffold(
                body: Column(
                  children: <Widget>[
                    _AppBar(
                        editMode: widget.isEditing,
                        focusNodeTitle: titleNode,
                        onCloseTap: () => leaveDialog(),
                        titleField: _TitleField(
                          focusNode: titleNode,
                          state: state,
                        )),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 8),
                            _CourseTile(state: state),
                            const _MobileDivider(),
                            _TodoUntilPicker(state: state),
                            const _MobileDivider(),
                            _SubmissionsSwitch(state: state),
                            const _MobileDivider(),
                            _DescriptionField(state: state),
                            const _MobileDivider(),
                            _AttachFile(state: state),
                            const _MobileDivider(),
                            _SendNotification(state: state),
                            const _MobileDivider(),
                            _PrivateHomeworkSwitch(state: state),
                            const _MobileDivider(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        };
      },
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

class _ErrorStrings {
  static const String emptyTitle =
      "Bitte gib einen Titel für die Hausaufgabe an!";
  static const String emptyCourse =
      "Bitte gib einen Kurs für die Hausaufgabe an!";
  static const String emptyTodoUntil =
      "Bitte gib ein Fälligkeitsdatum für die Hausaufgabe an!";
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key, this.editMode = false}) : super(key: key);

  final bool editMode;

  Future<void> onPressed(BuildContext context) async {
    final bloc = bloc_lib.BlocProvider.of<NewHomeworkDialogBloc>(context);
    try {
      // bloc.validateInputOrThrow();
      sendDataToFrankfurtSnackBar(context);
      // TODO: How can we handle errors that might occure when submitting?
      bloc.add(const Submit());

      if (!context.mounted) return;
      hideSendDataToFrankfurtSnackBar(context);
      Navigator.pop(context, true);
    } on InvalidHomeworkInputException catch (e) {
      showSnackSec(
        text: switch (e) {
          EmptyTitleException() => _ErrorStrings.emptyTitle,
          EmptyCourseException() => _ErrorStrings.emptyCourse,
          EmptyTodoUntilException() => _ErrorStrings.emptyTodoUntil
        },
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
  final Ready state;

  const _TodoUntilPicker({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = bloc_lib.BlocProvider.of<NewHomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: DefaultTextStyle.merge(
          style: const TextStyle(
            color: null,
            // TODO:
            // color: snapshot.hasError ? Colors.red : null,
          ),
          child: DatePicker(
            key: HwDialogKeys.todoUntilTile,
            padding: const EdgeInsets.all(12),
            selectedDate: state.dueDate?.toDateTime,
            selectDate: (newDate) {
              bloc.add(DueDateChanged(Date.fromDateTime(newDate)));
            },
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key? key,
    required this.editMode,
    required this.focusNodeTitle,
    required this.onCloseTap,
    required this.titleField,
  }) : super(key: key);

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
    required this.state,
  });

  final Ready state;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = bloc_lib.BlocProvider.of<NewHomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: _TitleFieldBase(
        // TODO: Will always rebuild with state change, fix.
        prefilledTitle: state.title,
        focusNode: focusNode,
        onChanged: (newTitle) {
          bloc.add(TitleChanged(newTitle));
        },
        // TODO
        errorText: null,
      ),
    );
    // return MaxWidthConstraintBox(
    //   child: StreamBuilder<String>(
    //       stream: bloc.title,
    //       builder: (context, snapshot) {
    //         final errorText = switch (snapshot.error) {
    //           EmptyTitleException => _ErrorStrings.emptyTitle,
    //           _ => snapshot.error?.toString(),
    //         };

    //         return _TitleFieldBase(
    //           prefilledTitle: prefilledTitle,
    //           focusNode: focusNode,
    //           onChanged: bloc.changeTitle,
    //           errorText: errorText,
    //         );
    //       }),
    // );
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
  const _CourseTile({Key? key, required this.state}) : super(key: key);

  final Ready state;

  @override
  Widget build(BuildContext context) {
    final bloc = bloc_lib.BlocProvider.of<NewHomeworkDialogBloc>(context);
    final courseState = state.course;
    final isDisabled = courseState is CourseChosen && !courseState.isChangeable;
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: CourseTileBase(
          key: HwDialogKeys.courseTile,
          courseName:
              courseState is CourseChosen ? courseState.courseName : null,
          // TODO:
          errorText: null,
          onTap: isDisabled
              ? null
              : () => CourseTile.onTap(context, onChangedId: (course) {
                    bloc.add(CourseChanged(course));
                  }),
        ),
      ),
    );
  }
}

class _SendNotification extends StatelessWidget {
  const _SendNotification({Key? key, required this.state}) : super(key: key);

  final Ready state;

  @override
  Widget build(BuildContext context) {
    final bloc = bloc_lib.BlocProvider.of<NewHomeworkDialogBloc>(context);

    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: _SendNotificationBase(
          title:
              "Kursmitglieder ${state.isEditing ? "über die Änderungen " : ""}benachrichtigen",
          onChanged: (newValue) =>
              bloc.add(NotifyCourseMembersChanged(newValue)),
          sendNotification: state.notifyCourseMembers,
          description: state.isEditing
              ? null
              : "Sende eine Benachrichtigung an deine Kursmitglieder, dass du eine neue Hausaufgabe erstellt hast.",
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
  const _DescriptionField({required this.state});

  final Ready state;

  @override
  Widget build(BuildContext context) {
    final bloc = bloc_lib.BlocProvider.of<NewHomeworkDialogBloc>(context);
    return _DescriptionFieldBase(
      onChanged: (newDescription) =>
          bloc.add(DescriptionChanged(newDescription)),
      // TODO: Will update with each state change, fix.
      prefilledDescription: state.description,
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
  const _AttachFile({required this.state});

  final Ready state;

  @override
  Widget build(BuildContext context) {
    final bloc = bloc_lib.BlocProvider.of<NewHomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: AttachFileBase(
          key: HwDialogKeys.addAttachmentTile,
          onLocalFilesAdded: (localFiles) =>
              bloc.add(AttachmentsAdded(localFiles.toIList())),
          onLocalFileRemoved: (localFile) =>
              bloc.add(AttachmentRemoved(localFile.fileId)),
          onCloudFileRemoved: (cloudFile) =>
              bloc.add(AttachmentRemoved(FileId(cloudFile.id!))),
          cloudFiles: state.attachments
              .where((file) => file.cloudFile != null)
              .map((file) => file.cloudFile!)
              .toList(),
          localFiles: state.attachments
              .where((file) => file.localFile != null)
              .map((file) => file.localFile!)
              .toList(),
        ),
      ),
    );
  }
}

class _SubmissionsSwitch extends StatelessWidget {
  final Ready state;

  const _SubmissionsSwitch({required this.state});

  @override
  Widget build(BuildContext context) {
    final submissionsState = state.submissions;
    final bloc = bloc_lib.BlocProvider.of<NewHomeworkDialogBloc>(context);
    final submissionTime = submissionsState is SubmissionsEnabled
        ? submissionsState.deadline
        : null;

    return MaxWidthConstraintBox(
      child: _SubmissionsSwitchBase(
        key: HwDialogKeys.submissionTile,
        isWidgetEnabled: state.submissions.isChangeable,
        submissionsEnabled: state.submissions.isEnabled,
        onChanged: (newIsEnabled) => bloc.add(SubmissionsChanged((
          enabled: newIsEnabled,
          submissionTime: newIsEnabled ? submissionTime : null
        ))),
        onTimeChanged: (newTime) => bloc
            .add(SubmissionsChanged((enabled: true, submissionTime: newTime))),
        time: submissionTime,
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
    required this.state,
  }) : super(key: key);

  final Ready state;

  @override
  Widget build(BuildContext context) {
    final bloc = bloc_lib.BlocProvider.of<NewHomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: _PrivateHomeworkSwitchBase(
          key: HwDialogKeys.isPrivateTile,
          isPrivate: state.isPrivate.$1,
          onChanged: state.isPrivate.isChangeable
              ? (newVal) => bloc.add(IsPrivateChanged(newVal))
              : null,
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
