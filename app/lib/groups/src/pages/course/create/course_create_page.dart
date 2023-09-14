// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/groups/src/pages/course/create/src/bloc/course_create_bloc.dart';
import 'package:sharezone/groups/src/pages/course/create/src/bloc/course_create_bloc_factory.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

Future<Course?> openCourseCreatePage(
  BuildContext context, {
  Course? course,
  String? schoolClassId,
}) async {
  final createdCourse = await Navigator.push<dynamic>(
    context,
    IgnoreWillPopScopeWhenIosSwipeBackRoute(
      builder: (context) => _CourseCreatePage(
        course: course,
        schoolClassId: schoolClassId,
      ),
      settings: const RouteSettings(name: _CourseCreatePage.tag),
    ),
  );
  await waitingForPopAnimation();
  if (createdCourse != null && context.mounted) {
    final name = createdCourse is Course ? ' "${createdCourse.name}"' : '';
    showSnackSec(
      context: context,
      text: 'Kurs$name wurde erstellt.',
      seconds: 2,
    );
  }
  return createdCourse as Course;
}

Future<void> submit(BuildContext context) async {
  final bloc = BlocProvider.of<CourseCreateBloc>(context);
  Course createdCourse;

  try {
    if (bloc.hasSchoolClassId) {
      sendDataToFrankfurtSnackBar(context, behavior: SnackBarBehavior.fixed);
      final successful = await bloc.submitSchoolClassCourse();
      if (context.mounted) {
        Navigator.pop(context, successful);
      }
    } else {
      createdCourse = bloc.submitCourse();
      Navigator.pop(context, createdCourse);
    }
  } catch (e, s) {
    if (context.mounted) {
      showSnackSec(
        context: context,
        text: handleErrorMessage(e.toString(), s),
      );
    }
  }
}

class _CourseCreatePage extends StatefulWidget {
  const _CourseCreatePage({
    Key? key,
    this.course,
    this.schoolClassId,
  }) : super(key: key);

  static const tag = "course-create-page";
  final Course? course;
  final String? schoolClassId;

  @override
  _CourseCreatePageState createState() => _CourseCreatePageState();
}

class _CourseCreatePageState extends State<_CourseCreatePage> {
  late CourseCreateBloc bloc;

  final abbreviationNode = FocusNode();
  final nameNode = FocusNode();

  @override
  void initState() {
    bloc = BlocProvider.of<CourseCreateBlocFactory>(context).create(
      schoolClassId: widget.schoolClassId,
    );
    if (widget.course != null) {
      bloc.setInitialCourse(widget.course!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: WillPopScope(
        onWillPop: () async => bloc.hasUserEditInput()
            ? warnUserAboutLeavingForm(context)
            : Future.value(true),
        child: Scaffold(
          appBar:
              AppBar(title: const Text("Kurs erstellen"), centerTitle: true),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: <Widget>[
                _Subject(
                    subject: widget.course?.subject,
                    nextFocusNode: abbreviationNode),
                _Abbreviation(
                    abbreviation: widget.course?.abbreviation,
                    focusNode: abbreviationNode,
                    nextFocusNode: nameNode),
                _CourseName(focusNode: nameNode),
              ],
            ),
          ),
          floatingActionButton: _CreateCourseFAB(),
        ),
      ),
    );
  }
}

class _CreateCourseFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => submit(context),
      tooltip: 'Erstellen',
      child: const Icon(Icons.check),
    );
  }
}

class _Subject extends StatelessWidget {
  const _Subject({
    Key? key,
    this.subject,
    required this.nextFocusNode,
  }) : super(key: key);

  final String? subject;
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseCreateBloc>(context);
    return StreamBuilder<Object>(
      stream: bloc.subject,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: PrefilledTextField(
            prefilledText: subject,
            decoration: InputDecoration(
              labelText: "Fach des Kurses (erforderlich)",
              hintText: "z.B. Mathematik",
              errorText: snapshot.error?.toString(),
            ),
            autofocus: true,
            textInputAction: TextInputAction.next,
            onChanged: bloc.changeSubject,
            onEditingComplete: () =>
                FocusManager.instance.primaryFocus?.unfocus(),
            textCapitalization: TextCapitalization.sentences,
          ),
        );
      },
    );
  }
}

class _Abbreviation extends StatelessWidget {
  const _Abbreviation({
    Key? key,
    this.abbreviation,
    required this.focusNode,
    required this.nextFocusNode,
  }) : super(key: key);

  final String? abbreviation;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseCreateBloc>(context);
    return PrefilledTextField(
      prefilledText: abbreviation,
      focusNode: focusNode,
      onEditingComplete: () => FocusManager.instance.primaryFocus?.unfocus(),
      textInputAction: TextInputAction.next,
      onChanged: bloc.changeAbbreviation,
      decoration: const InputDecoration(
        labelText: "Kürzel des Kurses",
        hintText: "z.B. M",
      ),
      maxLength: 3,
      textCapitalization: TextCapitalization.characters,
    );
  }
}

class _CourseName extends StatelessWidget {
  const _CourseName({
    Key? key,
    required this.focusNode,
  }) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseCreateBloc>(context);
    return TextFieldWithDescription(
      textField: TextField(
        focusNode: focusNode,
        onChanged: bloc.changeName,
        onEditingComplete: () => submit(context),
        decoration: const InputDecoration(
          labelText: "Name des Kurses",
          hintText: "z.B. Mathematik GK Q2",
        ),
        textCapitalization: TextCapitalization.sentences,
      ),
      description:
          "Der Kursname dient hauptsächlich für die Lehrkraft zur Unterscheidung der einzelnen Kurse. Denn würden bei der Lehrkraft alle Kurse Mathematik heißen, könnte diese nicht mehr Kurse unterscheiden.",
    );
  }
}
