// Mocks generated by Mockito 5.4.4 from annotations
// in sharezone/test_goldens/feedback/history/feedback_history_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;
import 'dart:ui' as _i9;

import 'package:common_domain_models/common_domain_models.dart' as _i3;
import 'package:crash_analytics/crash_analytics.dart' as _i4;
import 'package:feedback_shared_implementation/feedback_shared_implementation.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i7;
import 'package:sharezone/feedback/history/feedback_history_page_analytics.dart'
    as _i5;
import 'package:sharezone/feedback/history/feedback_history_page_controller.dart'
    as _i6;

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

class _FakeFeedbackApi_0 extends _i1.SmartFake implements _i2.FeedbackApi {
  _FakeFeedbackApi_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserId_1 extends _i1.SmartFake implements _i3.UserId {
  _FakeUserId_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCrashAnalytics_2 extends _i1.SmartFake
    implements _i4.CrashAnalytics {
  _FakeCrashAnalytics_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFeedbackHistoryPageAnalytics_3 extends _i1.SmartFake
    implements _i5.FeedbackHistoryPageAnalytics {
  _FakeFeedbackHistoryPageAnalytics_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [FeedbackHistoryPageController].
///
/// See the documentation for Mockito's code generation for more information.
class MockFeedbackHistoryPageController extends _i1.Mock
    implements _i6.FeedbackHistoryPageController {
  @override
  _i2.FeedbackApi get api => (super.noSuchMethod(
        Invocation.getter(#api),
        returnValue: _FakeFeedbackApi_0(
          this,
          Invocation.getter(#api),
        ),
        returnValueForMissingStub: _FakeFeedbackApi_0(
          this,
          Invocation.getter(#api),
        ),
      ) as _i2.FeedbackApi);
  @override
  _i3.UserId get userId => (super.noSuchMethod(
        Invocation.getter(#userId),
        returnValue: _FakeUserId_1(
          this,
          Invocation.getter(#userId),
        ),
        returnValueForMissingStub: _FakeUserId_1(
          this,
          Invocation.getter(#userId),
        ),
      ) as _i3.UserId);
  @override
  _i4.CrashAnalytics get crashAnalytics => (super.noSuchMethod(
        Invocation.getter(#crashAnalytics),
        returnValue: _FakeCrashAnalytics_2(
          this,
          Invocation.getter(#crashAnalytics),
        ),
        returnValueForMissingStub: _FakeCrashAnalytics_2(
          this,
          Invocation.getter(#crashAnalytics),
        ),
      ) as _i4.CrashAnalytics);
  @override
  _i5.FeedbackHistoryPageAnalytics get analytics => (super.noSuchMethod(
        Invocation.getter(#analytics),
        returnValue: _FakeFeedbackHistoryPageAnalytics_3(
          this,
          Invocation.getter(#analytics),
        ),
        returnValueForMissingStub: _FakeFeedbackHistoryPageAnalytics_3(
          this,
          Invocation.getter(#analytics),
        ),
      ) as _i5.FeedbackHistoryPageAnalytics);
  @override
  _i6.FeedbackHistoryPageState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i7.dummyValue<_i6.FeedbackHistoryPageState>(
          this,
          Invocation.getter(#state),
        ),
        returnValueForMissingStub: _i7.dummyValue<_i6.FeedbackHistoryPageState>(
          this,
          Invocation.getter(#state),
        ),
      ) as _i6.FeedbackHistoryPageState);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i8.Future<void> startStreaming() => (super.noSuchMethod(
        Invocation.method(
          #startStreaming,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  void logOpenedPage() => super.noSuchMethod(
        Invocation.method(
          #logOpenedPage,
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
  void addListener(_i9.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i9.VoidCallback? listener) => super.noSuchMethod(
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
