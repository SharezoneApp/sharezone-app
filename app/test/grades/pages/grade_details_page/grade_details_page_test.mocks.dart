// Mocks generated by Mockito 5.4.5 from annotations
// in sharezone/test/grades/pages/grade_details_page/grade_details_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i7;

import 'package:analytics/analytics.dart' as _i4;
import 'package:crash_analytics/crash_analytics.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;
import 'package:sharezone/grades/grades_service/grades_service.dart' as _i2;
import 'package:sharezone/grades/pages/grades_details_page/grade_details_page_controller.dart'
    as _i5;
import 'package:sharezone/grades/pages/grades_details_page/grade_details_page_controller_factory.dart'
    as _i8;

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

class _FakeGradeRef_0 extends _i1.SmartFake implements _i2.GradeRef {
  _FakeGradeRef_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGradesService_1 extends _i1.SmartFake implements _i2.GradesService {
  _FakeGradesService_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCrashAnalytics_2 extends _i1.SmartFake
    implements _i3.CrashAnalytics {
  _FakeCrashAnalytics_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAnalytics_3 extends _i1.SmartFake implements _i4.Analytics {
  _FakeAnalytics_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGradeId_4 extends _i1.SmartFake implements _i2.GradeId {
  _FakeGradeId_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGradeDetailsPageController_5 extends _i1.SmartFake
    implements _i5.GradeDetailsPageController {
  _FakeGradeDetailsPageController_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GradeDetailsPageController].
///
/// See the documentation for Mockito's code generation for more information.
class MockGradeDetailsPageController extends _i1.Mock
    implements _i5.GradeDetailsPageController {
  @override
  _i2.GradeRef get gradeRef => (super.noSuchMethod(
        Invocation.getter(#gradeRef),
        returnValue: _FakeGradeRef_0(
          this,
          Invocation.getter(#gradeRef),
        ),
        returnValueForMissingStub: _FakeGradeRef_0(
          this,
          Invocation.getter(#gradeRef),
        ),
      ) as _i2.GradeRef);

  @override
  _i2.GradesService get gradesService => (super.noSuchMethod(
        Invocation.getter(#gradesService),
        returnValue: _FakeGradesService_1(
          this,
          Invocation.getter(#gradesService),
        ),
        returnValueForMissingStub: _FakeGradesService_1(
          this,
          Invocation.getter(#gradesService),
        ),
      ) as _i2.GradesService);

  @override
  _i3.CrashAnalytics get crashAnalytics => (super.noSuchMethod(
        Invocation.getter(#crashAnalytics),
        returnValue: _FakeCrashAnalytics_2(
          this,
          Invocation.getter(#crashAnalytics),
        ),
        returnValueForMissingStub: _FakeCrashAnalytics_2(
          this,
          Invocation.getter(#crashAnalytics),
        ),
      ) as _i3.CrashAnalytics);

  @override
  _i4.Analytics get analytics => (super.noSuchMethod(
        Invocation.getter(#analytics),
        returnValue: _FakeAnalytics_3(
          this,
          Invocation.getter(#analytics),
        ),
        returnValueForMissingStub: _FakeAnalytics_3(
          this,
          Invocation.getter(#analytics),
        ),
      ) as _i4.Analytics);

  @override
  _i5.GradeDetailsPageState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i6.dummyValue<_i5.GradeDetailsPageState>(
          this,
          Invocation.getter(#state),
        ),
        returnValueForMissingStub: _i6.dummyValue<_i5.GradeDetailsPageState>(
          this,
          Invocation.getter(#state),
        ),
      ) as _i5.GradeDetailsPageState);

  @override
  set state(_i5.GradeDetailsPageState? _state) => super.noSuchMethod(
        Invocation.setter(
          #state,
          _state,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.GradeId get id => (super.noSuchMethod(
        Invocation.getter(#id),
        returnValue: _FakeGradeId_4(
          this,
          Invocation.getter(#id),
        ),
        returnValueForMissingStub: _FakeGradeId_4(
          this,
          Invocation.getter(#id),
        ),
      ) as _i2.GradeId);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  void deleteGrade() => super.noSuchMethod(
        Invocation.method(
          #deleteGrade,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void addListener(_i7.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i7.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [GradeDetailsPageControllerFactory].
///
/// See the documentation for Mockito's code generation for more information.
class MockGradeDetailsPageControllerFactory extends _i1.Mock
    implements _i8.GradeDetailsPageControllerFactory {
  @override
  _i2.GradesService get gradesService => (super.noSuchMethod(
        Invocation.getter(#gradesService),
        returnValue: _FakeGradesService_1(
          this,
          Invocation.getter(#gradesService),
        ),
        returnValueForMissingStub: _FakeGradesService_1(
          this,
          Invocation.getter(#gradesService),
        ),
      ) as _i2.GradesService);

  @override
  _i3.CrashAnalytics get crashAnalytics => (super.noSuchMethod(
        Invocation.getter(#crashAnalytics),
        returnValue: _FakeCrashAnalytics_2(
          this,
          Invocation.getter(#crashAnalytics),
        ),
        returnValueForMissingStub: _FakeCrashAnalytics_2(
          this,
          Invocation.getter(#crashAnalytics),
        ),
      ) as _i3.CrashAnalytics);

  @override
  _i4.Analytics get analytics => (super.noSuchMethod(
        Invocation.getter(#analytics),
        returnValue: _FakeAnalytics_3(
          this,
          Invocation.getter(#analytics),
        ),
        returnValueForMissingStub: _FakeAnalytics_3(
          this,
          Invocation.getter(#analytics),
        ),
      ) as _i4.Analytics);

  @override
  _i5.GradeDetailsPageController create(_i2.GradeId? id) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [id],
        ),
        returnValue: _FakeGradeDetailsPageController_5(
          this,
          Invocation.method(
            #create,
            [id],
          ),
        ),
        returnValueForMissingStub: _FakeGradeDetailsPageController_5(
          this,
          Invocation.method(
            #create,
            [id],
          ),
        ),
      ) as _i5.GradeDetailsPageController);
}
