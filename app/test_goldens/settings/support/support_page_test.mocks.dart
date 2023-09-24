// Mocks generated by Mockito 5.4.2 from annotations
// in sharezone/test_goldens/settings/support/support_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i5;

import 'package:common_domain_models/common_domain_models.dart' as _i4;
import 'package:key_value_store/key_value_store.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:sharezone/sharezone_plus/subscription_service/subscription_flag.dart'
    as _i6;
import 'package:sharezone/support/support_page_controller.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeKeyValueStore_0 extends _i1.SmartFake implements _i2.KeyValueStore {
  _FakeKeyValueStore_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SupportPageController].
///
/// See the documentation for Mockito's code generation for more information.
class MockSupportPageController extends _i1.Mock
    implements _i3.SupportPageController {
  @override
  bool get hasPlusSupportUnlocked => (super.noSuchMethod(
        Invocation.getter(#hasPlusSupportUnlocked),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  set hasPlusSupportUnlocked(bool? _hasPlusSupportUnlocked) =>
      super.noSuchMethod(
        Invocation.setter(
          #hasPlusSupportUnlocked,
          _hasPlusSupportUnlocked,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get isUserInGroupOnboarding => (super.noSuchMethod(
        Invocation.getter(#isUserInGroupOnboarding),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  set isUserInGroupOnboarding(bool? _isUserInGroupOnboarding) =>
      super.noSuchMethod(
        Invocation.setter(
          #isUserInGroupOnboarding,
          _isUserInGroupOnboarding,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set userId(_i4.UserId? _userId) => super.noSuchMethod(
        Invocation.setter(
          #userId,
          _userId,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set userEmail(String? _userEmail) => super.noSuchMethod(
        Invocation.setter(
          #userEmail,
          _userEmail,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set userName(String? _userName) => super.noSuchMethod(
        Invocation.setter(
          #userName,
          _userName,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get isUserSignedIn => (super.noSuchMethod(
        Invocation.getter(#isUserSignedIn),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  String getVideoCallAppointmentsUrlWithPrefills() => (super.noSuchMethod(
        Invocation.method(
          #getVideoCallAppointmentsUrlWithPrefills,
          [],
        ),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void addListener(_i5.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i5.VoidCallback? listener) => super.noSuchMethod(
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

/// A class which mocks [SubscriptionEnabledFlag].
///
/// See the documentation for Mockito's code generation for more information.
class MockSubscriptionEnabledFlag extends _i1.Mock
    implements _i6.SubscriptionEnabledFlag {
  @override
  _i2.KeyValueStore get keyValueStore => (super.noSuchMethod(
        Invocation.getter(#keyValueStore),
        returnValue: _FakeKeyValueStore_0(
          this,
          Invocation.getter(#keyValueStore),
        ),
        returnValueForMissingStub: _FakeKeyValueStore_0(
          this,
          Invocation.getter(#keyValueStore),
        ),
      ) as _i2.KeyValueStore);
  @override
  bool get isEnabled => (super.noSuchMethod(
        Invocation.getter(#isEnabled),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  void toggle() => super.noSuchMethod(
        Invocation.method(
          #toggle,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void addListener(_i5.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i5.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
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
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
