// Mocks generated by Mockito 5.4.4 from annotations
// in sharezone/test_goldens/settings/settings_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:analytics/analytics.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:shared_preferences/shared_preferences.dart' as _i5;
import 'package:sharezone/main/application_bloc.dart' as _i7;
import 'package:sharezone/util/api.dart' as _i2;
import 'package:sharezone/util/navigation_service.dart' as _i6;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart'
    as _i4;

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

class _FakeSharezoneGateway_0 extends _i1.SmartFake
    implements _i2.SharezoneGateway {
  _FakeSharezoneGateway_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAnalytics_1 extends _i1.SmartFake implements _i3.Analytics {
  _FakeAnalytics_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStreamingSharedPreferences_2 extends _i1.SmartFake
    implements _i4.StreamingSharedPreferences {
  _FakeStreamingSharedPreferences_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSharedPreferences_3 extends _i1.SmartFake
    implements _i5.SharedPreferences {
  _FakeSharedPreferences_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeNavigationService_4 extends _i1.SmartFake
    implements _i6.NavigationService {
  _FakeNavigationService_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SharezoneContext].
///
/// See the documentation for Mockito's code generation for more information.
class MockSharezoneContext extends _i1.Mock implements _i7.SharezoneContext {
  @override
  _i2.SharezoneGateway get api => (super.noSuchMethod(
        Invocation.getter(#api),
        returnValue: _FakeSharezoneGateway_0(
          this,
          Invocation.getter(#api),
        ),
        returnValueForMissingStub: _FakeSharezoneGateway_0(
          this,
          Invocation.getter(#api),
        ),
      ) as _i2.SharezoneGateway);
  @override
  _i3.Analytics get analytics => (super.noSuchMethod(
        Invocation.getter(#analytics),
        returnValue: _FakeAnalytics_1(
          this,
          Invocation.getter(#analytics),
        ),
        returnValueForMissingStub: _FakeAnalytics_1(
          this,
          Invocation.getter(#analytics),
        ),
      ) as _i3.Analytics);
  @override
  _i4.StreamingSharedPreferences get streamingSharedPreferences =>
      (super.noSuchMethod(
        Invocation.getter(#streamingSharedPreferences),
        returnValue: _FakeStreamingSharedPreferences_2(
          this,
          Invocation.getter(#streamingSharedPreferences),
        ),
        returnValueForMissingStub: _FakeStreamingSharedPreferences_2(
          this,
          Invocation.getter(#streamingSharedPreferences),
        ),
      ) as _i4.StreamingSharedPreferences);
  @override
  _i5.SharedPreferences get sharedPreferences => (super.noSuchMethod(
        Invocation.getter(#sharedPreferences),
        returnValue: _FakeSharedPreferences_3(
          this,
          Invocation.getter(#sharedPreferences),
        ),
        returnValueForMissingStub: _FakeSharedPreferences_3(
          this,
          Invocation.getter(#sharedPreferences),
        ),
      ) as _i5.SharedPreferences);
  @override
  _i6.NavigationService get navigationService => (super.noSuchMethod(
        Invocation.getter(#navigationService),
        returnValue: _FakeNavigationService_4(
          this,
          Invocation.getter(#navigationService),
        ),
        returnValueForMissingStub: _FakeNavigationService_4(
          this,
          Invocation.getter(#navigationService),
        ),
      ) as _i6.NavigationService);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
