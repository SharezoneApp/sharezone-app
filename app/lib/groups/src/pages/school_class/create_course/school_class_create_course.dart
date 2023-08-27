// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'school_class_create_course_bloc.dart';

Future<void> openSchoolClassCourseCreatePage(
  BuildContext context,
  String schoolClassID, {
  Course? course,
}) async {
  final createdCourse = await pushWithDefault(
    context,
    _CourseCreatePage(course: course, schoolClassId: schoolClassID),
    defaultValue: false,
    name: _CourseCreatePage.tag,
  );
  await waitingForPopAnimation();
  if (createdCourse) {
    showSnackSec(
      context: context,
      text: 'Kurs wurde erstellt.',
      seconds: 2,
    );
  }
}

Future<void> submit(BuildContext context) async {
  sendDataToFrankfurtSnackBar(context);

  final bloc = BlocProvider.of<SchoolClassCourseCreateBloc>(context);
  bool result;

  try {
    result = await bloc.submit();
    Navigator.pop(context, result);
  } catch (e, s) {
    showSnackSec(
      context: context,
      text: handleErrorMessage(e.toString(), s),
    );
  }
}

class _CourseCreatePage extends StatefulWidget {
  const _CourseCreatePage({
    Key? key,
    this.course,
    required this.schoolClassId,
  }) : super(key: key);

  static const tag = "school-class-course-create-page";

  final Course? course;
  final String schoolClassId;

  @override
  _CourseCreatePageState createState() => _CourseCreatePageState();
}

class _CourseCreatePageState extends State<_CourseCreatePage> {
  late SchoolClassCourseCreateBloc bloc;

  final abbreviationNode = FocusNode();
  final nameNode = FocusNode();

  @override
  void initState() {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    bloc = SchoolClassCourseCreateBloc(
      schoolClassID: widget.schoolClassId,
      gateway: api,
    );
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
      child: const Icon(Icons.check),
      tooltip: 'Erstellen',
    );
  }
}

class _Subject extends StatelessWidget {
  const _Subject({
    Key? key,
    this.subject,
    this.nextFocusNode,
  }) : super(key: key);

  final String? subject;
  final FocusNode? nextFocusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SchoolClassCourseCreateBloc>(context);
    return StreamBuilder<Object>(
      stream: bloc.subject,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: PrefilledTextField(
            prefilledText: subject,
            decoration: InputDecoration(
              labelText: "Fach des Kurses",
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
    this.focusNode,
    this.nextFocusNode,
  }) : super(key: key);

  final String? abbreviation;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SchoolClassCourseCreateBloc>(context);
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
    this.focusNode,
  }) : super(key: key);

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SchoolClassCourseCreateBloc>(context);
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
