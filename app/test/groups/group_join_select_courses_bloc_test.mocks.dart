// Mocks generated by Mockito 5.4.4 from annotations
// in sharezone/test/groups/group_join_select_courses_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;

import 'package:app_functions/app_functions.dart' as _i5;
import 'package:crash_analytics/src/crash_analytics.dart' as _i10;
import 'package:flutter/foundation.dart' as _i11;
import 'package:group_domain_models/group_domain_models.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i7;
import 'package:sharezone/groups/src/pages/school_class/my_school_class_bloc.dart'
    as _i9;
import 'package:sharezone/util/api/connections_gateway.dart' as _i6;
import 'package:sharezone_common/database_foundation.dart' as _i2;
import 'package:sharezone_common/references.dart' as _i3;

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

class _FakeDataCollectionPackage_0<T> extends _i1.SmartFake
    implements _i2.DataCollectionPackage<T> {
  _FakeDataCollectionPackage_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeReferences_1 extends _i1.SmartFake implements _i3.References {
  _FakeReferences_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeConnectionsData_2 extends _i1.SmartFake
    implements _i4.ConnectionsData {
  _FakeConnectionsData_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeAppFunctionsResult_3<T> extends _i1.SmartFake
    implements _i5.AppFunctionsResult<T> {
  _FakeAppFunctionsResult_3(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [ConnectionsGateway].
///
/// See the documentation for Mockito's code generation for more information.
class MockConnectionsGateway extends _i1.Mock
    implements _i6.ConnectionsGateway {
  @override
  _i2.DataCollectionPackage<_i4.Course> get joinedCoursesPackage =>
      (super.noSuchMethod(
            Invocation.getter(#joinedCoursesPackage),
            returnValue: _FakeDataCollectionPackage_0<_i4.Course>(
              this,
              Invocation.getter(#joinedCoursesPackage),
            ),
            returnValueForMissingStub: _FakeDataCollectionPackage_0<_i4.Course>(
              this,
              Invocation.getter(#joinedCoursesPackage),
            ),
          )
          as _i2.DataCollectionPackage<_i4.Course>);

  @override
  set joinedCoursesPackage(
    _i2.DataCollectionPackage<_i4.Course>? _joinedCoursesPackage,
  ) => super.noSuchMethod(
    Invocation.setter(#joinedCoursesPackage, _joinedCoursesPackage),
    returnValueForMissingStub: null,
  );

  @override
  List<_i4.Course> get newJoinedCourses =>
      (super.noSuchMethod(
            Invocation.getter(#newJoinedCourses),
            returnValue: <_i4.Course>[],
            returnValueForMissingStub: <_i4.Course>[],
          )
          as List<_i4.Course>);

  @override
  set newJoinedCourses(List<_i4.Course>? _newJoinedCourses) =>
      super.noSuchMethod(
        Invocation.setter(#newJoinedCourses, _newJoinedCourses),
        returnValueForMissingStub: null,
      );

  @override
  _i3.References get references =>
      (super.noSuchMethod(
            Invocation.getter(#references),
            returnValue: _FakeReferences_1(
              this,
              Invocation.getter(#references),
            ),
            returnValueForMissingStub: _FakeReferences_1(
              this,
              Invocation.getter(#references),
            ),
          )
          as _i3.References);

  @override
  String get memberID =>
      (super.noSuchMethod(
            Invocation.getter(#memberID),
            returnValue: _i7.dummyValue<String>(
              this,
              Invocation.getter(#memberID),
            ),
            returnValueForMissingStub: _i7.dummyValue<String>(
              this,
              Invocation.getter(#memberID),
            ),
          )
          as String);

  @override
  _i8.Stream<_i4.ConnectionsData?> streamConnectionsData() =>
      (super.noSuchMethod(
            Invocation.method(#streamConnectionsData, []),
            returnValue: _i8.Stream<_i4.ConnectionsData?>.empty(),
            returnValueForMissingStub: _i8.Stream<_i4.ConnectionsData?>.empty(),
          )
          as _i8.Stream<_i4.ConnectionsData?>);

  @override
  _i8.Future<_i4.ConnectionsData> get() =>
      (super.noSuchMethod(
            Invocation.method(#get, []),
            returnValue: _i8.Future<_i4.ConnectionsData>.value(
              _FakeConnectionsData_2(this, Invocation.method(#get, [])),
            ),
            returnValueForMissingStub: _i8.Future<_i4.ConnectionsData>.value(
              _FakeConnectionsData_2(this, Invocation.method(#get, [])),
            ),
          )
          as _i8.Future<_i4.ConnectionsData>);

  @override
  _i8.Future<_i5.AppFunctionsResult<dynamic>> joinByKey({
    required String? publicKey,
    List<String>? coursesForSchoolClass,
    int? version = 2,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#joinByKey, [], {
              #publicKey: publicKey,
              #coursesForSchoolClass: coursesForSchoolClass,
              #version: version,
            }),
            returnValue: _i8.Future<_i5.AppFunctionsResult<dynamic>>.value(
              _FakeAppFunctionsResult_3<dynamic>(
                this,
                Invocation.method(#joinByKey, [], {
                  #publicKey: publicKey,
                  #coursesForSchoolClass: coursesForSchoolClass,
                  #version: version,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i8.Future<_i5.AppFunctionsResult<dynamic>>.value(
                  _FakeAppFunctionsResult_3<dynamic>(
                    this,
                    Invocation.method(#joinByKey, [], {
                      #publicKey: publicKey,
                      #coursesForSchoolClass: coursesForSchoolClass,
                      #version: version,
                    }),
                  ),
                ),
          )
          as _i8.Future<_i5.AppFunctionsResult<dynamic>>);

  @override
  _i8.Future<_i5.AppFunctionsResult<dynamic>> joinByJoinLink({
    required String? joinLink,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#joinByJoinLink, [], {#joinLink: joinLink}),
            returnValue: _i8.Future<_i5.AppFunctionsResult<dynamic>>.value(
              _FakeAppFunctionsResult_3<dynamic>(
                this,
                Invocation.method(#joinByJoinLink, [], {#joinLink: joinLink}),
              ),
            ),
            returnValueForMissingStub:
                _i8.Future<_i5.AppFunctionsResult<dynamic>>.value(
                  _FakeAppFunctionsResult_3<dynamic>(
                    this,
                    Invocation.method(#joinByJoinLink, [], {
                      #joinLink: joinLink,
                    }),
                  ),
                ),
          )
          as _i8.Future<_i5.AppFunctionsResult<dynamic>>);

  @override
  _i8.Future<void> addConnectionCreate({
    required String? id,
    required _i4.GroupType? type,
    Map<String, dynamic>? data,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#addConnectionCreate, [], {
              #id: id,
              #type: type,
              #data: data,
            }),
            returnValue: _i8.Future<void>.value(),
            returnValueForMissingStub: _i8.Future<void>.value(),
          )
          as _i8.Future<void>);

  @override
  _i8.Future<void> addCoursePersonalDesign({
    required String? id,
    required dynamic personalDesignData,
    required _i4.Course? course,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#addCoursePersonalDesign, [], {
              #id: id,
              #personalDesignData: personalDesignData,
              #course: course,
            }),
            returnValue: _i8.Future<void>.value(),
            returnValueForMissingStub: _i8.Future<void>.value(),
          )
          as _i8.Future<void>);

  @override
  _i8.Future<void> removeCoursePersonalDesign({
    required String? courseID,
    required _i4.Course? course,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#removeCoursePersonalDesign, [], {
              #courseID: courseID,
              #course: course,
            }),
            returnValue: _i8.Future<void>.value(),
            returnValueForMissingStub: _i8.Future<void>.value(),
          )
          as _i8.Future<void>);

  @override
  _i8.Future<_i5.AppFunctionsResult<bool>> joinWithId({
    required String? id,
    required _i4.GroupType? type,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#joinWithId, [], {#id: id, #type: type}),
            returnValue: _i8.Future<_i5.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_3<bool>(
                this,
                Invocation.method(#joinWithId, [], {#id: id, #type: type}),
              ),
            ),
            returnValueForMissingStub:
                _i8.Future<_i5.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_3<bool>(
                    this,
                    Invocation.method(#joinWithId, [], {#id: id, #type: type}),
                  ),
                ),
          )
          as _i8.Future<_i5.AppFunctionsResult<bool>>);

  @override
  _i8.Future<_i5.AppFunctionsResult<bool>> leave({
    required String? id,
    required _i4.GroupType? type,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#leave, [], {#id: id, #type: type}),
            returnValue: _i8.Future<_i5.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_3<bool>(
                this,
                Invocation.method(#leave, [], {#id: id, #type: type}),
              ),
            ),
            returnValueForMissingStub:
                _i8.Future<_i5.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_3<bool>(
                    this,
                    Invocation.method(#leave, [], {#id: id, #type: type}),
                  ),
                ),
          )
          as _i8.Future<_i5.AppFunctionsResult<bool>>);

  @override
  _i8.Future<_i5.AppFunctionsResult<bool>> delete({
    required String? id,
    required _i4.GroupType? type,
    _i9.SchoolClassDeleteType? schoolClassDeleteType,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#delete, [], {
              #id: id,
              #type: type,
              #schoolClassDeleteType: schoolClassDeleteType,
            }),
            returnValue: _i8.Future<_i5.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_3<bool>(
                this,
                Invocation.method(#delete, [], {
                  #id: id,
                  #type: type,
                  #schoolClassDeleteType: schoolClassDeleteType,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i8.Future<_i5.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_3<bool>(
                    this,
                    Invocation.method(#delete, [], {
                      #id: id,
                      #type: type,
                      #schoolClassDeleteType: schoolClassDeleteType,
                    }),
                  ),
                ),
          )
          as _i8.Future<_i5.AppFunctionsResult<bool>>);

  @override
  _i8.Future<void> dispose() =>
      (super.noSuchMethod(
            Invocation.method(#dispose, []),
            returnValue: _i8.Future<void>.value(),
            returnValueForMissingStub: _i8.Future<void>.value(),
          )
          as _i8.Future<void>);
}

/// A class which mocks [CrashAnalytics].
///
/// See the documentation for Mockito's code generation for more information.
class MockCrashAnalytics extends _i1.Mock implements _i10.CrashAnalytics {
  @override
  set enableInDevMode(bool? _enableInDevMode) => super.noSuchMethod(
    Invocation.setter(#enableInDevMode, _enableInDevMode),
    returnValueForMissingStub: null,
  );

  @override
  void crash() => super.noSuchMethod(
    Invocation.method(#crash, []),
    returnValueForMissingStub: null,
  );

  @override
  _i8.Future<void> recordFlutterError(_i11.FlutterErrorDetails? details) =>
      (super.noSuchMethod(
            Invocation.method(#recordFlutterError, [details]),
            returnValue: _i8.Future<void>.value(),
            returnValueForMissingStub: _i8.Future<void>.value(),
          )
          as _i8.Future<void>);

  @override
  _i8.Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    bool? fatal = false,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #recordError,
              [exception, stack],
              {#fatal: fatal},
            ),
            returnValue: _i8.Future<void>.value(),
            returnValueForMissingStub: _i8.Future<void>.value(),
          )
          as _i8.Future<void>);

  @override
  void log(String? msg) => super.noSuchMethod(
    Invocation.method(#log, [msg]),
    returnValueForMissingStub: null,
  );

  @override
  _i8.Future<void> setCustomKey(String? key, dynamic value) =>
      (super.noSuchMethod(
            Invocation.method(#setCustomKey, [key, value]),
            returnValue: _i8.Future<void>.value(),
            returnValueForMissingStub: _i8.Future<void>.value(),
          )
          as _i8.Future<void>);

  @override
  _i8.Future<void> setUserIdentifier(String? identifier) =>
      (super.noSuchMethod(
            Invocation.method(#setUserIdentifier, [identifier]),
            returnValue: _i8.Future<void>.value(),
            returnValueForMissingStub: _i8.Future<void>.value(),
          )
          as _i8.Future<void>);

  @override
  _i8.Future<void> setCrashAnalyticsEnabled(bool? enabled) =>
      (super.noSuchMethod(
            Invocation.method(#setCrashAnalyticsEnabled, [enabled]),
            returnValue: _i8.Future<void>.value(),
            returnValueForMissingStub: _i8.Future<void>.value(),
          )
          as _i8.Future<void>);
}
