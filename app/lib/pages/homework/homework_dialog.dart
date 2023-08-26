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
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/blocs/homework/homework_dialog_bloc.dart';
import 'package:sharezone/filesharing/dialog/attach_file.dart';
import 'package:sharezone/filesharing/dialog/course_tile.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/markdown/markdown_support.dart';
import 'package:sharezone/timetable/src/edit_time.dart';
import 'package:sharezone/widgets/material/list_tile_with_description.dart';
import 'package:sharezone_common/homework_validators.dart';
import 'package:sharezone_common/validators.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';

class HomeworkDialog extends StatefulWidget {
  const HomeworkDialog({
    Key key,
    this.homework,
    @required this.homeworkDialogApi,
  }) : super(key: key);

  static const tag = "homework-dialog";

  final HomeworkDto homework;
  final HomeworkDialogApi homeworkDialogApi;

  @override
  _HomeworkDialogState createState() => _HomeworkDialogState();
}

class _HomeworkDialogState extends State<HomeworkDialog> {
  HomeworkDialogBloc bloc;

  @override
  void initState() {
    final markdownAnalytics = BlocProvider.of<MarkdownAnalytics>(context);
    bloc = HomeworkDialogBloc(widget.homeworkDialogApi, markdownAnalytics,
        homework: widget.homework);
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

class __HomeworkDialog extends StatefulWidget {
  const __HomeworkDialog({Key key, this.homework, this.bloc}) : super(key: key);

  final HomeworkDto homework;
  final HomeworkDialogBloc bloc;

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
    if (widget.bloc.hasInputChanged()) {
      final confirmedLeave = await warnUserAboutLeavingForm(context);
      if (confirmedLeave) Navigator.pop(context);
    } else
      Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.bloc.hasInputChanged()
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
            ),
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
                        oldDescription: widget.homework?.description ?? ""),
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
  const _MobileDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (PlatformCheck.isDesktopOrWeb) return Container();
    return const Divider(height: 0);
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key key, this.oldHomework, this.editMode = false})
      : super(key: key);

  final HomeworkDto oldHomework;
  final bool editMode;

  Future<void> onPressed(BuildContext context) async {
    final bloc = BlocProvider.of<HomeworkDialogBloc>(context);
    final hasAttachments = bloc.hasAttachments;
    try {
      if (bloc.isValid()) {
        sendDataToFrankfurtSnackBar(context);

        if (editMode) {
          if (hasAttachments) {
            await bloc.submit(oldHomework: oldHomework);
          } else {
            bloc.submit(oldHomework: oldHomework);
          }
          logHomeworkEditEvent(context);
          hideSendDataToFrankfurtSnackBar(context);
          Navigator.pop(context, true);
        } else {
          hasAttachments ? await bloc.submit() : bloc.submit();
          logHomeworkAddEvent(context);
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
    } on Exception catch (e) {
      log("Exception when submitting: $e", error: e);
      showSnackSec(
        text:
            "Es gab einen unbekannten Fehler (${e.toString()} 😖 Bitte kontaktiere den Support!",
        context: context,
        seconds: 5,
      );
    }
  }

  void hideSendDataToFrankfurtSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void logHomeworkEditEvent(BuildContext context) {
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    analytics.log(NamedAnalyticsEvent(name: "homework_edit"));
  }

  void logHomeworkAddEvent(BuildContext context) {
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    analytics.log(NamedAnalyticsEvent(name: "homework_add"));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Text("SPEICHERN",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      tooltip: "Hausaufgabe speichern",
      iconSize: 90,
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
          builder: (context, snapshot) => DatePicker(
            padding: const EdgeInsets.all(12),
            selectedDate: snapshot.data,
            selectDate: bloc.changeTodoUntil,
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key key,
    @required this.oldHomework,
    @required this.editMode,
    @required this.focusNodeTitle,
    @required this.onCloseTap,
  }) : super(key: key);

  final HomeworkDto oldHomework;
  final bool editMode;
  final VoidCallback onCloseTap;

  final FocusNode focusNodeTitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDarkThemeEnabled(context)
          ? Theme.of(context).appBarTheme.backgroundColor
          : Theme.of(context).primaryColor,
      elevation: 1,
      child: SafeArea(
        top: false,
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
                    oldHomework: oldHomework,
                    editMode: editMode,
                  ),
                ],
              ),
            ),
            MaxWidthConstraintBox(
              child: _TitleField(
                title: oldHomework?.title ?? "",
                focusNode: focusNodeTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({Key key, this.title, this.focusNode}) : super(key: key);

  final String title;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final HomeworkDialogBloc bloc =
        BlocProvider.of<HomeworkDialogBloc>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 3,
      ),
      child: SingleChildScrollView(
        child: StreamBuilder<String>(
          stream: bloc.title,
          builder: (context, snapshot) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PrefilledTextField(
                  prefilledText: title,
                  focusNode: focusNode,
                  cursorColor: Colors.white,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                    hintText: "Titel eingeben (z.B. AB Nr. 1 - 3)",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  onChanged: (String title) => bloc.changeTitle(title),
                  textCapitalization: TextCapitalization.sentences,
                ),
                Text(
                  snapshot.error?.toString() ?? "",
                  style: TextStyle(color: Colors.red[700], fontSize: 12),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({Key key, @required this.editMode}) : super(key: key);

  final bool editMode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: CourseTile(
          courseStream: bloc.courseSegment,
          onChanged: bloc.changeCourseSegment,
          editMode: editMode,
        ),
      ),
    );
  }
}

class _SendNotification extends StatelessWidget {
  const _SendNotification({Key key, this.editMode = true}) : super(key: key);

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
            return ListTileWithDescription(
              leading: const Icon(Icons.notifications_active),
              title: Text(
                  "Kursmitglieder ${editMode ? "über die Änderungen " : ""}benachrichtigen"),
              trailing: Switch.adaptive(
                onChanged: bloc.changeSendNotification,
                value: sendNotification,
              ),
              onTap: () => bloc.changeSendNotification(!sendNotification),
              description: editMode
                  ? null
                  : Text(
                      "Sende eine Benachrichtigung an deine Kursmitglieder, dass du eine neue Hausaufgabe erstellt hast."),
            );
          },
        ),
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({@required this.oldDescription});

  final String oldDescription;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkDialogBloc>(context);
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
                leading: Icon(Icons.subject),
                title: PrefilledTextField(
                  prefilledText: oldDescription,
                  maxLines: null,
                  scrollPadding: const EdgeInsets.all(16.0),
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Zusatzinformationen eingeben",
                    border: InputBorder.none,
                  ),
                  onChanged: bloc.changeDescription,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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

class _SubmissionsSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeworkDialogBloc>(context);
    return MaxWidthConstraintBox(
      child: StreamBuilder<bool>(
        stream: bloc.isSubmissionEnableable,
        initialData: true,
        builder: (context, snapshot) {
          final isSubmissionEnableable = snapshot.data;
          return StreamBuilder<bool>(
            stream: bloc.withSubmissions,
            initialData: false,
            builder: (context, snapshot) {
              final withSubmissions = snapshot.data;
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.folder_open),
                    title: Text("Mit Abgabe"),
                    onTap: () {
                      bloc.changeWithSubmissions(!withSubmissions);
                      FeatureDiscovery.completeCurrentStep(context);
                    },
                    trailing: Switch.adaptive(
                        value: withSubmissions,
                        onChanged: isSubmissionEnableable
                            ? (newValue) {
                                bloc.changeWithSubmissions(newValue);
                                FeatureDiscovery.completeCurrentStep(context);
                              }
                            : null),
                  ),
                  StreamBuilder<Time>(
                    stream: bloc.submissionTime,
                    builder: (context, snapshot) {
                      final time = snapshot.data;
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: withSubmissions
                            ? ListTile(
                                title: const Text("Abgabe-Uhrzeit"),
                                onTap: () async {
                                  await hideKeyboardWithDelay(context: context);
                                  final initalTime =
                                      time == Time(hour: 23, minute: 59)
                                          ? Time(hour: 18, minute: 0)
                                          : time;
                                  final newTime = await selectTime(context,
                                      initialTime: initalTime);
                                  if (newTime != null) {
                                    bloc.changeSubmissionTime(newTime);
                                  }
                                },
                                trailing: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(time.toString()),
                                ),
                              )
                            : Container(),
                      );
                    },
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _PrivateHomeworkSwitch extends StatelessWidget {
  const _PrivateHomeworkSwitch({Key key, this.editMode}) : super(key: key);

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
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const Icon(Icons.security),
              title: const Text("Privat"),
              subtitle: const Text("Hausaufgabe nicht mit dem Kurs teilen."),
              enabled: !editMode,
              trailing: Switch.adaptive(
                value: snapshot.data ?? false,
                onChanged: !editMode ? bloc.changePrivate : null,
              ),
              onTap: () => bloc.changePrivate(!snapshot.data),
            );
          },
        ),
      ),
    );
  }
}
