import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:sharezone/groups/src/pages/course/create/src/analytics/course_create_analytics.dart';
import 'package:sharezone/groups/src/pages/course/create/src/analytics/events/course_create_event.dart';
import 'package:sharezone/groups/src/pages/course/create/src/models/course_template.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone/util/string_utils.dart';
import 'package:sharezone_common/course_validators.dart';
import 'package:sharezone_common/validators.dart';

import '../gateway/course_create_gateway.dart';
import 'user_input.dart';

// @formatter:off
class CourseCreateBloc extends BlocBase with CourseValidators {
  final CourseCreateAnalytics _analytics;
  final CourseCreateGateway _gateway;
  final String schoolClassId;

  bool get hasSchoolClassId => isNotEmptyOrNull(schoolClassId);

  final _nameSubject = BehaviorSubject<String>();
  final _subjectSubject = BehaviorSubject<String>();
  final _abbreviationSubject = BehaviorSubject<String>();

  Course initalCourse;

  CourseCreateBloc(this._gateway, this._analytics, {this.schoolClassId});

  void setInitalCourse(Course course) {
    if (course != null) _addInitalValuesToStream(course);
  }

  void _addInitalValuesToStream(Course course) {
    _nameSubject.sink.add(course.name);
    _subjectSubject.sink.add(course.subject);
    _abbreviationSubject.sink.add(course.abbreviation);
  }

  bool hasUserEditInput() {
    final name = _nameSubject.value;
    final subject = _subjectSubject.value;
    final abbreviation = _abbreviationSubject.value;

    if (initalCourse == null) {
      return isNotEmptyOrNull(name) ||
          isNotEmptyOrNull(subject) ||
          isNotEmptyOrNull(abbreviation);
    } else {
      return !(name == initalCourse.name ||
          subject == initalCourse.subject ||
          abbreviation == initalCourse.abbreviation);
    }
  }

  Stream<String> get subject =>
      _subjectSubject.stream.transform(validateSubject);

  // Change data
  Function(String) get changeName => _nameSubject.sink.add;
  Function(String) get changeSubject => _subjectSubject.sink.add;
  Function(String) get changeAbbreviation => _abbreviationSubject.sink.add;

  Course submitCourse() {
    final validator = NotEmptyOrNullValidator(_subjectSubject.value);
    if (!validator.isValid()) {
      _subjectSubject.addError(
          TextValidationException(CourseValidators.emptySubjectUserMessage));
      throw InvalidInputException();
    }

    final subject = _subjectSubject.value;
    final name = _ifNotGivenGenerateName(_nameSubject.value, subject);
    final abbreviation =
        _ifNotGivenGenerateAbbreviation(_abbreviationSubject.value, subject);

    _analytics.logCourseCreateFromOwn(subject, groupPage);

    final userInput = UserInput(name, subject, abbreviation);
    return _gateway.createCourse(userInput);
  }

  Future<bool> submitSchoolClassCourse() async {
    final validator = NotEmptyOrNullValidator(_subjectSubject.value);
    if (!validator.isValid()) {
      _subjectSubject.addError(
          TextValidationException(CourseValidators.emptySubjectUserMessage));
      throw InvalidInputException();
    }

    final subject = _subjectSubject.value;
    final name = _ifNotGivenGenerateName(_nameSubject.value, subject);
    final abbreviation =
        _ifNotGivenGenerateAbbreviation(_abbreviationSubject.value, subject);

    _analytics.logCourseCreateFromOwn(subject, groupPage);

    final userInput = UserInput(name, subject, abbreviation);
    final result =
        await _gateway.createSchoolClassCourse(userInput, schoolClassId);
    return result.hasData && result.data == true;
  }

  Course submitWithCourseTemplate(CourseTemplate courseTemplate) {
    _analytics.logCourseCreateFromTemplate(courseTemplate, groupPage);

    // With the course template the course name is equel to the course subject
    final userInput = UserInput(courseTemplate.subject, courseTemplate.subject,
        courseTemplate.abbreviation);
    return _gateway.createCourse(userInput);
  }

  String _ifNotGivenGenerateName(String name, String subject) {
    if (NotEmptyOrNullValidator(name).isValid()) return name;
    return subject;
  }

  String _ifNotGivenGenerateAbbreviation(String abbreviation, String subject) {
    if (NotEmptyOrNullValidator(abbreviation).isValid()) return abbreviation;
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
    _nameSubject.close();
    _subjectSubject.close();
    _abbreviationSubject.close();
  }
}
