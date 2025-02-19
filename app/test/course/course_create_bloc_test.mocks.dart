// Mocks generated by Mockito 5.4.4 from annotations
// in sharezone/test/course/course_create_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i9;

import 'package:common_domain_models/common_domain_models.dart' as _i6;
import 'package:group_domain_models/group_domain_models.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i11;
import 'package:sharezone/groups/src/pages/course/create/gateway/course_create_gateway.dart'
    as _i7;
import 'package:sharezone/groups/src/pages/course/create/models/user_input.dart'
    as _i10;
import 'package:sharezone/util/api/connections_gateway.dart' as _i5;
import 'package:sharezone/util/api/course_gateway.dart' as _i2;
import 'package:sharezone/util/api/school_class_gateway.dart' as _i3;
import 'package:sharezone/util/api/user_api.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeCourseGateway_0 extends _i1.SmartFake implements _i2.CourseGateway {
  _FakeCourseGateway_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeSchoolClassGateway_1 extends _i1.SmartFake
    implements _i3.SchoolClassGateway {
  _FakeSchoolClassGateway_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeUserGateway_2 extends _i1.SmartFake implements _i4.UserGateway {
  _FakeUserGateway_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeConnectionsGateway_3 extends _i1.SmartFake
    implements _i5.ConnectionsGateway {
  _FakeConnectionsGateway_3(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeCourseId_4 extends _i1.SmartFake implements _i6.CourseId {
  _FakeCourseId_4(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [CourseCreateGateway].
///
/// See the documentation for Mockito's code generation for more information.
class MockCourseCreateGateway extends _i1.Mock
    implements _i7.CourseCreateGateway {
  @override
  _i2.CourseGateway get courseGateway =>
      (super.noSuchMethod(
            Invocation.getter(#courseGateway),
            returnValue: _FakeCourseGateway_0(
              this,
              Invocation.getter(#courseGateway),
            ),
            returnValueForMissingStub: _FakeCourseGateway_0(
              this,
              Invocation.getter(#courseGateway),
            ),
          )
          as _i2.CourseGateway);

  @override
  _i3.SchoolClassGateway get schoolClassGateway =>
      (super.noSuchMethod(
            Invocation.getter(#schoolClassGateway),
            returnValue: _FakeSchoolClassGateway_1(
              this,
              Invocation.getter(#schoolClassGateway),
            ),
            returnValueForMissingStub: _FakeSchoolClassGateway_1(
              this,
              Invocation.getter(#schoolClassGateway),
            ),
          )
          as _i3.SchoolClassGateway);

  @override
  _i4.UserGateway get userGateway =>
      (super.noSuchMethod(
            Invocation.getter(#userGateway),
            returnValue: _FakeUserGateway_2(
              this,
              Invocation.getter(#userGateway),
            ),
            returnValueForMissingStub: _FakeUserGateway_2(
              this,
              Invocation.getter(#userGateway),
            ),
          )
          as _i4.UserGateway);

  @override
  _i5.ConnectionsGateway get connectionsGateway =>
      (super.noSuchMethod(
            Invocation.getter(#connectionsGateway),
            returnValue: _FakeConnectionsGateway_3(
              this,
              Invocation.getter(#connectionsGateway),
            ),
            returnValueForMissingStub: _FakeConnectionsGateway_3(
              this,
              Invocation.getter(#connectionsGateway),
            ),
          )
          as _i5.ConnectionsGateway);

  @override
  List<_i8.Course> get currentCourses =>
      (super.noSuchMethod(
            Invocation.getter(#currentCourses),
            returnValue: <_i8.Course>[],
            returnValueForMissingStub: <_i8.Course>[],
          )
          as List<_i8.Course>);

  @override
  _i9.Stream<List<_i8.SchoolClass>?> streamSchoolClasses() =>
      (super.noSuchMethod(
            Invocation.method(#streamSchoolClasses, []),
            returnValue: _i9.Stream<List<_i8.SchoolClass>?>.empty(),
            returnValueForMissingStub:
                _i9.Stream<List<_i8.SchoolClass>?>.empty(),
          )
          as _i9.Stream<List<_i8.SchoolClass>?>);

  @override
  (_i6.CourseId, String) createCourse(_i10.UserInput? userInput) =>
      (super.noSuchMethod(
            Invocation.method(#createCourse, [userInput]),
            returnValue: (
              _FakeCourseId_4(
                this,
                Invocation.method(#createCourse, [userInput]),
              ),
              _i11.dummyValue<String>(
                this,
                Invocation.method(#createCourse, [userInput]),
              ),
            ),
            returnValueForMissingStub: (
              _FakeCourseId_4(
                this,
                Invocation.method(#createCourse, [userInput]),
              ),
              _i11.dummyValue<String>(
                this,
                Invocation.method(#createCourse, [userInput]),
              ),
            ),
          )
          as (_i6.CourseId, String));

  @override
  _i9.Future<(_i6.CourseId, String)> createSchoolClassCourse(
    _i10.UserInput? userInput,
    _i6.SchoolClassId? schoolClassId,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#createSchoolClassCourse, [
              userInput,
              schoolClassId,
            ]),
            returnValue: _i9.Future<(_i6.CourseId, String)>.value((
              _FakeCourseId_4(
                this,
                Invocation.method(#createSchoolClassCourse, [
                  userInput,
                  schoolClassId,
                ]),
              ),
              _i11.dummyValue<String>(
                this,
                Invocation.method(#createSchoolClassCourse, [
                  userInput,
                  schoolClassId,
                ]),
              ),
            )),
            returnValueForMissingStub:
                _i9.Future<(_i6.CourseId, String)>.value((
                  _FakeCourseId_4(
                    this,
                    Invocation.method(#createSchoolClassCourse, [
                      userInput,
                      schoolClassId,
                    ]),
                  ),
                  _i11.dummyValue<String>(
                    this,
                    Invocation.method(#createSchoolClassCourse, [
                      userInput,
                      schoolClassId,
                    ]),
                  ),
                )),
          )
          as _i9.Future<(_i6.CourseId, String)>);

  @override
  _i9.Future<void> deleteCourse(_i6.CourseId? courseId) =>
      (super.noSuchMethod(
            Invocation.method(#deleteCourse, [courseId]),
            returnValue: _i9.Future<void>.value(),
            returnValueForMissingStub: _i9.Future<void>.value(),
          )
          as _i9.Future<void>);
}
