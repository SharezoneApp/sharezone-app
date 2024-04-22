// Mocks generated by Mockito 5.4.4 from annotations
// in sharezone/test/timetable/timetable_dialog_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:group_domain_models/group_domain_models.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:sharezone/timetable/timetable_add_event/src/timetable_add_event_event_dialog_api.dart'
    as _i3;

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

class _FakeCourse_0 extends _i1.SmartFake implements _i2.Course {
  _FakeCourse_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [EventDialogApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockEventDialogApi extends _i1.Mock implements _i3.EventDialogApi {
  @override
  _i4.Future<_i2.Course> loadCourse(dynamic courseId) => (super.noSuchMethod(
        Invocation.method(
          #loadCourse,
          [courseId],
        ),
        returnValue: _i4.Future<_i2.Course>.value(_FakeCourse_0(
          this,
          Invocation.method(
            #loadCourse,
            [courseId],
          ),
        )),
        returnValueForMissingStub: _i4.Future<_i2.Course>.value(_FakeCourse_0(
          this,
          Invocation.method(
            #loadCourse,
            [courseId],
          ),
        )),
      ) as _i4.Future<_i2.Course>);
  @override
  _i4.Future<void> createEvent(_i3.CreateEventCommand? command) =>
      (super.noSuchMethod(
        Invocation.method(
          #createEvent,
          [command],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
