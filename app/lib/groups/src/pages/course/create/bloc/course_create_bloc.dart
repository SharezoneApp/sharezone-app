// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:bloc_base/bloc_base.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/groups/group_permission.dart';
import 'package:sharezone/groups/src/pages/course/create/analytics/course_create_analytics.dart';
import 'package:sharezone/groups/src/pages/course/create/analytics/events/course_create_event.dart';
import 'package:sharezone/groups/src/pages/course/create/models/course_template.dart';
import 'package:sharezone/util/string_utils.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/course_validators.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:sharezone_common/validators.dart';

import '../gateway/course_create_gateway.dart';
import '../models/user_input.dart';

class CourseCreateBloc extends BlocBase with CourseValidators {
  final CourseCreateAnalytics _analytics;
  final CourseCreateGateway _gateway;

  SchoolClassId? schoolClassId;
  bool get hasSchoolClassId => schoolClassId != null;
  StreamSubscription<List<SchoolClass>?>? _schoolClassesSubscription;

  final _nameSubject = BehaviorSubject<String>();
  final _subjectSubject = BehaviorSubject<String>();
  final _abbreviationSubject = BehaviorSubject<String>();
  final _myAdminSchoolClassesSubject =
      BehaviorSubject<List<(SchoolClassId, SchoolClassName)>?>();

  Course? initialCourse;

  CourseCreateBloc(
    this._gateway,
    this._analytics, {
    this.schoolClassId,
  });

  void loadAdminSchoolClasses() {
    final initialData = _gateway.getCurrentSchoolClasses();
    _setAdminSchoolClasses(initialData);

    _schoolClassesSubscription = _gateway.streamSchoolClasses().listen((data) {
      _setAdminSchoolClasses(data);
    });
  }

  void _setAdminSchoolClasses(List<SchoolClass>? allSchoolClasses) {
    _myAdminSchoolClassesSubject.sink.add([]);
    if (allSchoolClasses == null) {
      return;
    }

    final adminList = allSchoolClasses
        .where((schoolClass) =>
            schoolClass.myRole.hasPermission(GroupPermission.administration))
        .map((s) => (SchoolClassId(s.id), s.name))
        .toList();
    _myAdminSchoolClassesSubject.sink.add(adminList);
  }

  void setInitialTemplate(CourseTemplate template) {
    _subjectSubject.sink.add(template.subject);
    _abbreviationSubject.sink.add(template.abbreviation);
    _nameSubject.sink.add('');
  }

  void setSchoolClassId(SchoolClassId? schoolClassId) {
    this.schoolClassId = schoolClassId;
  }

  bool hasUserEditInput() {
    final name = _nameSubject.valueOrNull;
    final subject = _subjectSubject.valueOrNull;
    final abbreviation = _abbreviationSubject.valueOrNull;

    if (initialCourse == null) {
      return isNotEmptyOrNull(name) ||
          isNotEmptyOrNull(subject) ||
          isNotEmptyOrNull(abbreviation);
    } else {
      return !(name == initialCourse!.name ||
          subject == initialCourse!.subject ||
          abbreviation == initialCourse!.abbreviation);
    }
  }

  Stream<String> get subject =>
      _subjectSubject.stream.transform(validateSubject);
  Stream<List<(SchoolClassId, SchoolClassName)>?> get myAdminSchoolClasses =>
      _myAdminSchoolClassesSubject.stream;

  // Change data
  Function(String) get changeName => _nameSubject.sink.add;
  Function(String) get changeSubject => _subjectSubject.sink.add;
  Function(String) get changeAbbreviation => _abbreviationSubject.sink.add;

  Future<(CourseId, CourseName)> submitCourse() async {
    final validator = NotEmptyOrNullValidator(_subjectSubject.valueOrNull);
    if (!validator.isValid()) {
      _subjectSubject.addError(
          TextValidationException(CourseValidators.emptySubjectUserMessage));
      throw InvalidInputException();
    }

    final subject = _subjectSubject.valueOrNull!;
    final name = _ifNotGivenGenerateName(_nameSubject.valueOrNull, subject);
    final abbreviation = _ifNotGivenGenerateAbbreviation(
        _abbreviationSubject.valueOrNull, subject);

    _analytics.logCourseCreateFromOwn(subject, groupPage);

    final userInput = UserInput(name, subject, abbreviation);
    if (hasSchoolClassId) {
      return _gateway.createSchoolClassCourse(userInput, schoolClassId!);
    } else {
      return _gateway.createCourse(userInput);
    }
  }

  Future<(CourseId, CourseName)> submitWithCourseTemplate(
      CourseTemplate courseTemplate) async {
    _analytics.logCourseCreateFromTemplate(courseTemplate, groupPage);

    // With the course template the course name is equal to the course subject
    final userInput = UserInput(courseTemplate.subject, courseTemplate.subject,
        courseTemplate.abbreviation);

    if (hasSchoolClassId) {
      return _gateway.createSchoolClassCourse(userInput, schoolClassId!);
    } else {
      return _gateway.createCourse(userInput);
    }
  }

  Future<void> deleteCourse(CourseId courseId) async {
    await _gateway.deleteCourse(courseId);
  }

  String _ifNotGivenGenerateName(String? name, String subject) {
    if (NotEmptyOrNullValidator(name).isValid()) return name!;
    return subject;
  }

  String _ifNotGivenGenerateAbbreviation(String? abbreviation, String subject) {
    if (NotEmptyOrNullValidator(abbreviation).isValid()) return abbreviation!;
    return subject.length >= 2
        ? subject.substring(0, 2).toUpperCase()
        : subject;
  }

  bool isCourseTemplateAlreadyAdded(CourseTemplate courseTemplate) {
    final courses = _gateway.currentCourses;
    final highest = StringUtils.getHighestSimilarity(
        courses.map((course) => course.subject.toLowerCase()).toList(),
        courseTemplate.subject.toLowerCase());
    return highest >= 0.7;
  }

  @override
  void dispose() {
    _schoolClassesSubscription?.cancel();
    _myAdminSchoolClassesSubject.close();
    _nameSubject.close();
    _subjectSubject.close();
    _abbreviationSubject.close();
  }
}
