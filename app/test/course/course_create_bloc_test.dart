// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:async/async.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/groups/src/pages/course/create/src/analytics/course_create_analytics.dart';
import 'package:sharezone/groups/src/pages/course/create/src/bloc/course_create_bloc.dart';
import 'package:sharezone/groups/src/pages/course/create/src/bloc/user_input.dart';
import 'package:sharezone/groups/src/pages/course/create/src/gateway/course_create_gateway.dart';
import 'package:sharezone/util/API.dart';
import 'package:sharezone_common/course_validators.dart';
import 'package:sharezone_common/validators.dart';
import 'package:test/test.dart';

import '../analytics/analytics_test.dart';

class MockApi extends Mock implements SharezoneGateway {}

class MockCourseCreateApi extends Mock implements CourseCreateGateway {}

void main() {
  CourseCreateBloc bloc;
  CourseCreateAnalytics analytics;
  CourseCreateGateway gateway;

  setUp(() {
    analytics = CourseCreateAnalytics(Analytics(LocalAnalyticsBackend()));
    gateway = MockCourseCreateApi();
    bloc = CourseCreateBloc(gateway, analytics);
  });

  test(
      "If a course subject is given then the same value should be emitted with no error",
      () {
    bloc.changeSubject("Mathematik");
    expect(bloc.subject, emits("Mathematik"));
    bloc.dispose();
    expect(bloc.subject, neverEmits(TypeMatcher<TextValidationException>()));
  });

  test("If submit is called then the CourseCreateApi is used", () async {
    final bloc = CourseCreateBloc(gateway, analytics);
    _createValidInput(bloc);
    bloc.submitCourse();

    verify(gateway.createCourse(any)).called(1);
  });

  test("When no subject is initially given then no Exception is emitted", () {
    bloc.dispose();
    expect(bloc.subject, neverEmits(TypeMatcher<TextValidationException>()));
  });

  test(
      "If a user specifies and then deletes the course subject an validation error should be emitted",
      () async {
    bloc.changeSubject("Some value");
    bloc.changeSubject("");
    final queue = StreamQueue<String>(bloc.subject);
    TextValidationException validationException;
    try {
      await queue.next;
    } on TextValidationException catch (e) {
      validationException = e;
    }
    expect(
        validationException.message, CourseValidators.emptySubjectUserMessage);
  });

  test("If the user gives a course name then it will be used", () async {
    final bloc = CourseCreateBloc(gateway, analytics);
    _createValidInput(bloc);
    bloc.changeName("Mathematik LK Q1");
    bloc.submitCourse();
    List gatewayArguments = verify(gateway.createCourse(captureAny)).captured;
    final userInput = gatewayArguments.first as UserInput;
    expect(userInput.name, "Mathematik LK Q1");
  });

  test(
      "If the user doesn't give a course name then the subjec will be used as course name ",
      () async {
    final bloc = CourseCreateBloc(gateway, analytics);
    bloc.changeSubject("Subject");
    bloc.submitCourse();
    List apiArguments = verify(gateway.createCourse(captureAny)).captured;
    final userInput = apiArguments.first as UserInput;
    expect(userInput.name, "Subject");
  });

  test("Input isValid == true if every validator is valid", () {
    final validator = _TestValidator(true);
    final input = _TestInput([validator, validator, validator]);
    expect(input.isValid(), true);
  });

  test("Input isValid == false if one validator isn't valid", () {
    final validatorFalse = _TestValidator(false);
    final validatorTrue = _TestValidator(true);
    final input = _TestInput([validatorTrue, validatorTrue, validatorFalse]);
    expect(input.isValid(), false);
  });
}

void _createValidInput(CourseCreateBloc bloc) {
  bloc.changeName("coursename");
  bloc.changeSubject("Subject");
  bloc.changeAbbreviation("ab");
}

class _TestValidator implements Validator {
  final bool valid;

  _TestValidator(this.valid);

  @override
  bool isValid() => valid;
}

class _TestInput extends Input {
  _TestInput(List<Validator> validators) : super(validators);
}
