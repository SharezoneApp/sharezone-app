// Mocks generated by Mockito 5.4.5 from annotations
// in sharezone/test_goldens/grades/pages/grades_dialog/grades_dialog_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:analytics/analytics.dart' as _i4;
import 'package:crash_analytics/crash_analytics.dart' as _i2;
import 'package:group_domain_models/group_domain_models.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;
import 'package:sharezone/grades/grades_service/grades_service.dart' as _i3;
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller.dart'
    as _i5;
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller_factory.dart'
    as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeCrashAnalytics_0 extends _i1.SmartFake
    implements _i2.CrashAnalytics {
  _FakeCrashAnalytics_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeGradesService_1 extends _i1.SmartFake implements _i3.GradesService {
  _FakeGradesService_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeAnalytics_2 extends _i1.SmartFake implements _i4.Analytics {
  _FakeAnalytics_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeGradesDialogController_3 extends _i1.SmartFake
    implements _i5.GradesDialogController {
  _FakeGradesDialogController_3(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [GradesDialogControllerFactory].
///
/// See the documentation for Mockito's code generation for more information.
class MockGradesDialogControllerFactory extends _i1.Mock
    implements _i6.GradesDialogControllerFactory {
  @override
  _i2.CrashAnalytics get crashAnalytics =>
      (super.noSuchMethod(
            Invocation.getter(#crashAnalytics),
            returnValue: _FakeCrashAnalytics_0(
              this,
              Invocation.getter(#crashAnalytics),
            ),
            returnValueForMissingStub: _FakeCrashAnalytics_0(
              this,
              Invocation.getter(#crashAnalytics),
            ),
          )
          as _i2.CrashAnalytics);

  @override
  _i3.GradesService get gradesService =>
      (super.noSuchMethod(
            Invocation.getter(#gradesService),
            returnValue: _FakeGradesService_1(
              this,
              Invocation.getter(#gradesService),
            ),
            returnValueForMissingStub: _FakeGradesService_1(
              this,
              Invocation.getter(#gradesService),
            ),
          )
          as _i3.GradesService);

  @override
  _i4.Analytics get analytics =>
      (super.noSuchMethod(
            Invocation.getter(#analytics),
            returnValue: _FakeAnalytics_2(this, Invocation.getter(#analytics)),
            returnValueForMissingStub: _FakeAnalytics_2(
              this,
              Invocation.getter(#analytics),
            ),
          )
          as _i4.Analytics);

  @override
  _i7.Stream<List<_i8.Course>> Function() get coursesStream =>
      (super.noSuchMethod(
            Invocation.getter(#coursesStream),
            returnValue: () => _i7.Stream<List<_i8.Course>>.empty(),
            returnValueForMissingStub:
                () => _i7.Stream<List<_i8.Course>>.empty(),
          )
          as _i7.Stream<List<_i8.Course>> Function());

  @override
  _i5.GradesDialogController create(_i3.GradeId? gradeId) =>
      (super.noSuchMethod(
            Invocation.method(#create, [gradeId]),
            returnValue: _FakeGradesDialogController_3(
              this,
              Invocation.method(#create, [gradeId]),
            ),
            returnValueForMissingStub: _FakeGradesDialogController_3(
              this,
              Invocation.method(#create, [gradeId]),
            ),
          )
          as _i5.GradesDialogController);
}
