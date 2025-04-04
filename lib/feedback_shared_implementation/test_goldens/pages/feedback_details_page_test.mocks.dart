// Mocks generated by Mockito 5.4.5 from annotations
// in feedback_shared_implementation/test_goldens/pages/feedback_details_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i7;

import 'package:common_domain_models/common_domain_models.dart' as _i3;
import 'package:feedback_shared_implementation/src/api/feedback_api.dart'
    as _i2;
import 'package:feedback_shared_implementation/src/models/feedback_id.dart'
    as _i4;
import 'package:feedback_shared_implementation/src/pages/feedback_details_page_controller.dart'
    as _i5;
import 'package:feedback_shared_implementation/src/pages/feedback_details_page_controller_factory.dart'
    as _i8;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;

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

class _FakeFeedbackApi_0 extends _i1.SmartFake implements _i2.FeedbackApi {
  _FakeFeedbackApi_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeUserId_1 extends _i1.SmartFake implements _i3.UserId {
  _FakeUserId_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeFeedbackId_2 extends _i1.SmartFake implements _i4.FeedbackId {
  _FakeFeedbackId_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeFeedbackDetailsPageController_3 extends _i1.SmartFake
    implements _i5.FeedbackDetailsPageController {
  _FakeFeedbackDetailsPageController_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(parent, parentInvocation);
}

/// A class which mocks [FeedbackDetailsPageController].
///
/// See the documentation for Mockito's code generation for more information.
class MockFeedbackDetailsPageController extends _i1.Mock
    implements _i5.FeedbackDetailsPageController {
  @override
  _i2.FeedbackApi get feedbackApi =>
      (super.noSuchMethod(
            Invocation.getter(#feedbackApi),
            returnValue: _FakeFeedbackApi_0(
              this,
              Invocation.getter(#feedbackApi),
            ),
            returnValueForMissingStub: _FakeFeedbackApi_0(
              this,
              Invocation.getter(#feedbackApi),
            ),
          )
          as _i2.FeedbackApi);

  @override
  _i3.UserId get userId =>
      (super.noSuchMethod(
            Invocation.getter(#userId),
            returnValue: _FakeUserId_1(this, Invocation.getter(#userId)),
            returnValueForMissingStub: _FakeUserId_1(
              this,
              Invocation.getter(#userId),
            ),
          )
          as _i3.UserId);

  @override
  _i4.FeedbackId get feedbackId =>
      (super.noSuchMethod(
            Invocation.getter(#feedbackId),
            returnValue: _FakeFeedbackId_2(
              this,
              Invocation.getter(#feedbackId),
            ),
            returnValueForMissingStub: _FakeFeedbackId_2(
              this,
              Invocation.getter(#feedbackId),
            ),
          )
          as _i4.FeedbackId);

  @override
  _i5.FeedbackDetailsPageState get state =>
      (super.noSuchMethod(
            Invocation.getter(#state),
            returnValue: _i6.dummyValue<_i5.FeedbackDetailsPageState>(
              this,
              Invocation.getter(#state),
            ),
            returnValueForMissingStub: _i6
                .dummyValue<_i5.FeedbackDetailsPageState>(
                  this,
                  Invocation.getter(#state),
                ),
          )
          as _i5.FeedbackDetailsPageState);

  @override
  set state(_i5.FeedbackDetailsPageState? _state) => super.noSuchMethod(
    Invocation.setter(#state, _state),
    returnValueForMissingStub: null,
  );

  @override
  bool get hasListeners =>
      (super.noSuchMethod(
            Invocation.getter(#hasListeners),
            returnValue: false,
            returnValueForMissingStub: false,
          )
          as bool);

  @override
  void init() => super.noSuchMethod(
    Invocation.method(#init, []),
    returnValueForMissingStub: null,
  );

  @override
  void sendResponse(String? message) => super.noSuchMethod(
    Invocation.method(#sendResponse, [message]),
    returnValueForMissingStub: null,
  );

  @override
  void dispose() => super.noSuchMethod(
    Invocation.method(#dispose, []),
    returnValueForMissingStub: null,
  );

  @override
  void addListener(_i7.VoidCallback? listener) => super.noSuchMethod(
    Invocation.method(#addListener, [listener]),
    returnValueForMissingStub: null,
  );

  @override
  void removeListener(_i7.VoidCallback? listener) => super.noSuchMethod(
    Invocation.method(#removeListener, [listener]),
    returnValueForMissingStub: null,
  );

  @override
  void notifyListeners() => super.noSuchMethod(
    Invocation.method(#notifyListeners, []),
    returnValueForMissingStub: null,
  );
}

/// A class which mocks [FeedbackDetailsPageControllerFactory].
///
/// See the documentation for Mockito's code generation for more information.
class MockFeedbackDetailsPageControllerFactory extends _i1.Mock
    implements _i8.FeedbackDetailsPageControllerFactory {
  @override
  _i2.FeedbackApi get feedbackApi =>
      (super.noSuchMethod(
            Invocation.getter(#feedbackApi),
            returnValue: _FakeFeedbackApi_0(
              this,
              Invocation.getter(#feedbackApi),
            ),
            returnValueForMissingStub: _FakeFeedbackApi_0(
              this,
              Invocation.getter(#feedbackApi),
            ),
          )
          as _i2.FeedbackApi);

  @override
  _i3.UserId get userId =>
      (super.noSuchMethod(
            Invocation.getter(#userId),
            returnValue: _FakeUserId_1(this, Invocation.getter(#userId)),
            returnValueForMissingStub: _FakeUserId_1(
              this,
              Invocation.getter(#userId),
            ),
          )
          as _i3.UserId);

  @override
  _i5.FeedbackDetailsPageController create(_i4.FeedbackId? feedbackId) =>
      (super.noSuchMethod(
            Invocation.method(#create, [feedbackId]),
            returnValue: _FakeFeedbackDetailsPageController_3(
              this,
              Invocation.method(#create, [feedbackId]),
            ),
            returnValueForMissingStub: _FakeFeedbackDetailsPageController_3(
              this,
              Invocation.method(#create, [feedbackId]),
            ),
          )
          as _i5.FeedbackDetailsPageController);
}
