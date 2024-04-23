// Mocks generated by Mockito 5.4.4 from annotations
// in sharezone/test/timetable/timetable_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:cloud_functions/cloud_functions.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart'
    as _i3;
import 'package:user/user.dart' as _i5;

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

class _FakeFirebaseFunctions_0 extends _i1.SmartFake
    implements _i2.FirebaseFunctions {
  _FakeFirebaseFunctions_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SubscriptionService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSubscriptionService extends _i1.Mock
    implements _i3.SubscriptionService {
  @override
  _i4.Stream<_i5.AppUser?> get user => (super.noSuchMethod(
        Invocation.getter(#user),
        returnValue: _i4.Stream<_i5.AppUser?>.empty(),
        returnValueForMissingStub: _i4.Stream<_i5.AppUser?>.empty(),
      ) as _i4.Stream<_i5.AppUser?>);
  @override
  _i2.FirebaseFunctions get functions => (super.noSuchMethod(
        Invocation.getter(#functions),
        returnValue: _FakeFirebaseFunctions_0(
          this,
          Invocation.getter(#functions),
        ),
        returnValueForMissingStub: _FakeFirebaseFunctions_0(
          this,
          Invocation.getter(#functions),
        ),
      ) as _i2.FirebaseFunctions);
  @override
  _i4.Stream<_i5.SharezonePlusStatus?> get sharezonePlusStatusStream =>
      (super.noSuchMethod(
        Invocation.getter(#sharezonePlusStatusStream),
        returnValue: _i4.Stream<_i5.SharezonePlusStatus?>.empty(),
        returnValueForMissingStub: _i4.Stream<_i5.SharezonePlusStatus?>.empty(),
      ) as _i4.Stream<_i5.SharezonePlusStatus?>);
  @override
  set sharezonePlusStatusStream(
          _i4.Stream<_i5.SharezonePlusStatus?>? _sharezonePlusStatusStream) =>
      super.noSuchMethod(
        Invocation.setter(
          #sharezonePlusStatusStream,
          _sharezonePlusStatusStream,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool isSubscriptionActive([_i5.AppUser? appUser]) => (super.noSuchMethod(
        Invocation.method(
          #isSubscriptionActive,
          [appUser],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i4.Stream<bool> isSubscriptionActiveStream() => (super.noSuchMethod(
        Invocation.method(
          #isSubscriptionActiveStream,
          [],
        ),
        returnValue: _i4.Stream<bool>.empty(),
        returnValueForMissingStub: _i4.Stream<bool>.empty(),
      ) as _i4.Stream<bool>);
  @override
  bool hasFeatureUnlocked(_i3.SharezonePlusFeature? feature) =>
      (super.noSuchMethod(
        Invocation.method(
          #hasFeatureUnlocked,
          [feature],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i4.Stream<bool> hasFeatureUnlockedStream(
          _i3.SharezonePlusFeature? feature) =>
      (super.noSuchMethod(
        Invocation.method(
          #hasFeatureUnlockedStream,
          [feature],
        ),
        returnValue: _i4.Stream<bool>.empty(),
        returnValueForMissingStub: _i4.Stream<bool>.empty(),
      ) as _i4.Stream<bool>);
  @override
  _i4.Future<void> cancelStripeSubscription() => (super.noSuchMethod(
        Invocation.method(
          #cancelStripeSubscription,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<bool> showLetParentsBuyButton() => (super.noSuchMethod(
        Invocation.method(
          #showLetParentsBuyButton,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<String?> getPlusWebsiteBuyToken() => (super.noSuchMethod(
        Invocation.method(
          #getPlusWebsiteBuyToken,
          [],
        ),
        returnValue: _i4.Future<String?>.value(),
        returnValueForMissingStub: _i4.Future<String?>.value(),
      ) as _i4.Future<String?>);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
