// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:app_functions/app_functions.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:design/design.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/course_validators.dart';
import 'package:helper_functions/helper_functions.dart';

class CourseEditPageBloc extends BlocBase with CourseValidators {
  final _subjectSubject = BehaviorSubject<String>();
  final _abbreviationSubject = BehaviorSubject<String>();
  final _courseNameSubject = BehaviorSubject<String>();
  final _designSubject = BehaviorSubject<Design>();

  final CourseEditBlocGateway _gateway;

  CourseEditPageBloc({
    required CourseEditBlocGateway gateway,
    required String subject,
    required String abbreviation,
    required String courseName,
    required Design design,
  }) : _gateway = gateway {
    _subjectSubject.sink.add(subject);
    _abbreviationSubject.sink.add(abbreviation);
    _courseNameSubject.sink.add(courseName);
    _designSubject.sink.add(design);
  }

  Function(String) get changeSubject => _subjectSubject.sink.add;
  Function(String) get changeAbbreviation => _abbreviationSubject.sink.add;
  Function(String) get changeCourseName => _courseNameSubject.sink.add;
  Function(Design) get changeDesign => _designSubject.sink.add;

  Stream<String> get subject => _subjectSubject;
  Stream<String> get abbreviation => _abbreviationSubject;
  Stream<String> get courseName => _courseNameSubject;
  Stream<Design> get design => _designSubject;

  Future<bool> submit() async {
    final String subject = _getSubject();
    final String abbreviation = _getAbbreviation();
    final String courseName = _getCourseName();
    final Design design = _getDesign();

    if (_isSubmitValid(subject)) {
      final UserInput userInput = UserInput(
        subject: subject,
        abbreviation: abbreviation,
        courseName: courseName,
        design: design,
      );
      final appFunctionsResult = await _gateway.edit(userInput);
      return appFunctionsResult.hasData && appFunctionsResult.data == true;
    }
    return false;
  }

  bool _isSubmitValid(String subject) {
    if (!isEmptyOrNull(subject)) {
      return true;
    } else {
      throw SubjectIsMissingException();
    }
  }

  String _getSubject() {
    return _subjectSubject.value;
  }

  Design _getDesign() {
    return _designSubject.value;
  }

  String _getAbbreviation() {
    final String subject = _getSubject();
    String abbreviation = _abbreviationSubject.value;
    if (isEmptyOrNull(abbreviation)) {
      if (subject.length <= 1) {
        abbreviation = subject;
      } else {
        abbreviation = subject.substring(0, 2);
      }
    }
    return abbreviation;
  }

  String _getCourseName() {
    String courseName = _courseNameSubject.value;
    if (isEmptyOrNull(courseName)) {
      courseName = _getSubject();
    }
    return courseName;
  }

  @override
  void dispose() {
    _subjectSubject.close();
    _abbreviationSubject.close();
    _courseNameSubject.close();
    _designSubject.close();
  }
}

class UserInput {
  final String subject, abbreviation, courseName;
  final Design design;

  const UserInput({
    required this.subject,
    required this.abbreviation,
    required this.courseName,
    required this.design,
  });
}

class CourseEditBlocGateway {
  final CourseGateway _gateway;
  final Course _course;

  CourseEditBlocGateway(this._gateway, this._course);

  Future<AppFunctionsResult<bool>> edit(UserInput userInput) async {
    final Course course = _course.copyWith(
      subject: userInput.subject,
      abbreviation: userInput.abbreviation,
      name: userInput.courseName,
      design: userInput.design,
    );
    return await _gateway.editCourse(course);
  }
}
