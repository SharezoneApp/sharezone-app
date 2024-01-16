// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/groups/src/pages/course/course_edit/course_edit_bloc.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

Future<void> openCourseEditPage(BuildContext context, Course course) async {
  final successful = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (context) => CourseEditPage(course: course),
      settings: const RouteSettings(name: CourseEditPage.tag),
    ),
  );
  if (successful != null && successful == true && context.mounted) {
    _logCourseEdit(context);
    await _showCourseEditConformationSnackbarWithDelay(context);
  }
}

Future _showCourseEditConformationSnackbarWithDelay(
    BuildContext context) async {
  await waitingForPopAnimation();
  if (!context.mounted) return;
  showSnackSec(
    context: context,
    text: "Der Kurs wurde erfolgreich bearbeitet!",
    seconds: 2,
  );
}

void _logCourseEdit(BuildContext context) {
  final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
  analytics.log(NamedAnalyticsEvent(name: 'course_edit'));
}

Future<void> submit(BuildContext context) async {
  final bloc = BlocProvider.of<CourseEditPageBloc>(context);
  sendDataToFrankfurtSnackBar(context);
  try {
    Navigator.pop(context, await bloc.submit());
  } on Exception catch (e, s) {
    log('$e', error: e, stackTrace: s);
    if (!context.mounted) return;
    showSnackSec(
      text: handleErrorMessage(e.toString(), s),
      context: context,
    );
  }
}

class CourseEditPage extends StatefulWidget {
  const CourseEditPage({
    super.key,
    required this.course,
  });

  static const String tag = "course-edit-page";
  final Course course;

  @override
  State createState() => _CourseEditPageState();
}

class _CourseEditPageState extends State<CourseEditPage> {
  late CourseEditPageBloc bloc;

  @override
  void initState() {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    bloc = CourseEditPageBloc(
        subject: widget.course.subject,
        abbreviation: widget.course.abbreviation,
        courseName: widget.course.name,
        design: widget.course.design!,
        gateway: CourseEditBlocGateway(api.course, widget.course));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CourseEditPageBloc>(
      bloc: bloc,
      child: _CourseEditPage(course: widget.course),
    );
  }
}

class _CourseEditPage extends StatelessWidget {
  const _CourseEditPage({
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    final abbreviationNode = FocusNode();
    final courseNameNode = FocusNode();
    return Scaffold(
      appBar: AppBar(title: const Text("Kurs bearbeiten")),
      backgroundColor: Theme.of(context).isDarkTheme ? null : Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8)
            .add(const EdgeInsets.symmetric(horizontal: 4)),
        child: MaxWidthConstraintBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _SubjectField(
                  initialSubject: course.subject, nextNode: abbreviationNode),
              const SizedBox(height: 28),
              _AbbreviationField(
                  initialAbbreviation: course.abbreviation,
                  nextNode: courseNameNode),
              const SizedBox(height: 12),
              _CourseNameField(initialCourseName: course.name),
            ],
          ),
        ),
      ),
      floatingActionButton: _CourseEditPageFAB(),
    );
  }
}

class _SubjectField extends StatelessWidget {
  const _SubjectField({
    required this.nextNode,
    required this.initialSubject,
  });

  final FocusNode nextNode;
  final String initialSubject;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseEditPageBloc>(context);
    return StreamBuilder<Object>(
      stream: bloc.courseName,
      builder: (context, snapshot) {
        return PrefilledTextField(
          autofocus: true,
          onEditingComplete: () =>
              FocusManager.instance.primaryFocus?.unfocus(),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: "Fach",
            errorText: snapshot.error?.toString(),
          ),
          prefilledText: initialSubject,
          onChanged: bloc.changeSubject,
        );
      },
    );
  }
}

class _AbbreviationField extends StatelessWidget {
  const _AbbreviationField({
    required this.nextNode,
    required this.initialAbbreviation,
  });

  final FocusNode nextNode;
  final String initialAbbreviation;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseEditPageBloc>(context);
    return PrefilledTextField(
      prefilledText: initialAbbreviation,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(labelText: "Kürzel des Fachs"),
      onEditingComplete: () => FocusManager.instance.primaryFocus?.unfocus(),
      onChanged: bloc.changeAbbreviation,
      maxLength: 3,
    );
  }
}

class _CourseNameField extends StatelessWidget {
  const _CourseNameField({required this.initialCourseName});

  final String initialCourseName;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseEditPageBloc>(context);
    return PrefilledTextField(
      prefilledText: initialCourseName,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(labelText: "Name des Kurses"),
      onEditingComplete: () => submit(context),
      onChanged: bloc.changeCourseName,
    );
  }
}

class _CourseEditPageFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: "Speichern",
      onPressed: () => submit(context),
      child: const Icon(Icons.check),
    );
  }
}
