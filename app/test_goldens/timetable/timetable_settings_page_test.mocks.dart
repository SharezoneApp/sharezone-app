// Mocks generated by Mockito 5.4.4 from annotations
// in sharezone/test_goldens/timetable/timetable_settings_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:cloud_functions/cloud_functions.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:sharezone/settings/src/bloc/user_settings_bloc.dart' as _i10;
import 'package:sharezone/settings/src/subpages/timetable/time_picker_settings_cache.dart'
    as _i7;
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart'
    as _i8;
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length.dart'
    as _i5;
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length_cache.dart'
    as _i4;
import 'package:sharezone/util/cache/streaming_key_value_store.dart' as _i2;
import 'package:time/time.dart' as _i11;
import 'package:user/user.dart' as _i9;

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

class _FakeStreamingKeyValueStore_0 extends _i1.SmartFake
    implements _i2.StreamingKeyValueStore {
  _FakeStreamingKeyValueStore_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeFirebaseFunctions_1 extends _i1.SmartFake
    implements _i3.FirebaseFunctions {
  _FakeFirebaseFunctions_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [LessonLengthCache].
///
/// See the documentation for Mockito's code generation for more information.
class MockLessonLengthCache extends _i1.Mock implements _i4.LessonLengthCache {
  @override
  _i2.StreamingKeyValueStore get streamingCache =>
      (super.noSuchMethod(
            Invocation.getter(#streamingCache),
            returnValue: _FakeStreamingKeyValueStore_0(
              this,
              Invocation.getter(#streamingCache),
            ),
            returnValueForMissingStub: _FakeStreamingKeyValueStore_0(
              this,
              Invocation.getter(#streamingCache),
            ),
          )
          as _i2.StreamingKeyValueStore);

  @override
  void setLessonLength(_i5.LessonLength? lessonLength) => super.noSuchMethod(
    Invocation.method(#setLessonLength, [lessonLength]),
    returnValueForMissingStub: null,
  );

  @override
  _i6.Stream<_i5.LessonLength> streamLessonLength() =>
      (super.noSuchMethod(
            Invocation.method(#streamLessonLength, []),
            returnValue: _i6.Stream<_i5.LessonLength>.empty(),
            returnValueForMissingStub: _i6.Stream<_i5.LessonLength>.empty(),
          )
          as _i6.Stream<_i5.LessonLength>);

  @override
  _i6.Future<bool> hasUserSavedLessonLengthInCache() =>
      (super.noSuchMethod(
            Invocation.method(#hasUserSavedLessonLengthInCache, []),
            returnValue: _i6.Future<bool>.value(false),
            returnValueForMissingStub: _i6.Future<bool>.value(false),
          )
          as _i6.Future<bool>);

  @override
  void dispose() => super.noSuchMethod(
    Invocation.method(#dispose, []),
    returnValueForMissingStub: null,
  );
}

/// A class which mocks [TimePickerSettingsCache].
///
/// See the documentation for Mockito's code generation for more information.
class MockTimePickerSettingsCache extends _i1.Mock
    implements _i7.TimePickerSettingsCache {
  @override
  _i2.StreamingKeyValueStore get streamingCache =>
      (super.noSuchMethod(
            Invocation.getter(#streamingCache),
            returnValue: _FakeStreamingKeyValueStore_0(
              this,
              Invocation.getter(#streamingCache),
            ),
            returnValueForMissingStub: _FakeStreamingKeyValueStore_0(
              this,
              Invocation.getter(#streamingCache),
            ),
          )
          as _i2.StreamingKeyValueStore);

  @override
  void setTimePickerWithFifeMinutesInterval(bool? newValue) =>
      super.noSuchMethod(
        Invocation.method(#setTimePickerWithFifeMinutesInterval, [newValue]),
        returnValueForMissingStub: null,
      );

  @override
  _i6.Stream<bool> isTimePickerWithFifeMinutesIntervalActiveStream() =>
      (super.noSuchMethod(
            Invocation.method(
              #isTimePickerWithFifeMinutesIntervalActiveStream,
              [],
            ),
            returnValue: _i6.Stream<bool>.empty(),
            returnValueForMissingStub: _i6.Stream<bool>.empty(),
          )
          as _i6.Stream<bool>);

  @override
  void dispose() => super.noSuchMethod(
    Invocation.method(#dispose, []),
    returnValueForMissingStub: null,
  );
}

/// A class which mocks [SubscriptionService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSubscriptionService extends _i1.Mock
    implements _i8.SubscriptionService {
  @override
  _i6.Stream<_i9.AppUser?> get user =>
      (super.noSuchMethod(
            Invocation.getter(#user),
            returnValue: _i6.Stream<_i9.AppUser?>.empty(),
            returnValueForMissingStub: _i6.Stream<_i9.AppUser?>.empty(),
          )
          as _i6.Stream<_i9.AppUser?>);

  @override
  _i3.FirebaseFunctions get functions =>
      (super.noSuchMethod(
            Invocation.getter(#functions),
            returnValue: _FakeFirebaseFunctions_1(
              this,
              Invocation.getter(#functions),
            ),
            returnValueForMissingStub: _FakeFirebaseFunctions_1(
              this,
              Invocation.getter(#functions),
            ),
          )
          as _i3.FirebaseFunctions);

  @override
  _i6.Stream<_i9.SharezonePlusStatus?> get sharezonePlusStatusStream =>
      (super.noSuchMethod(
            Invocation.getter(#sharezonePlusStatusStream),
            returnValue: _i6.Stream<_i9.SharezonePlusStatus?>.empty(),
            returnValueForMissingStub:
                _i6.Stream<_i9.SharezonePlusStatus?>.empty(),
          )
          as _i6.Stream<_i9.SharezonePlusStatus?>);

  @override
  set sharezonePlusStatusStream(
    _i6.Stream<_i9.SharezonePlusStatus?>? _sharezonePlusStatusStream,
  ) => super.noSuchMethod(
    Invocation.setter(#sharezonePlusStatusStream, _sharezonePlusStatusStream),
    returnValueForMissingStub: null,
  );

  @override
  bool isSubscriptionActive([_i9.AppUser? appUser]) =>
      (super.noSuchMethod(
            Invocation.method(#isSubscriptionActive, [appUser]),
            returnValue: false,
            returnValueForMissingStub: false,
          )
          as bool);

  @override
  _i6.Stream<bool> isSubscriptionActiveStream() =>
      (super.noSuchMethod(
            Invocation.method(#isSubscriptionActiveStream, []),
            returnValue: _i6.Stream<bool>.empty(),
            returnValueForMissingStub: _i6.Stream<bool>.empty(),
          )
          as _i6.Stream<bool>);

  @override
  bool hasFeatureUnlocked(_i8.SharezonePlusFeature? feature) =>
      (super.noSuchMethod(
            Invocation.method(#hasFeatureUnlocked, [feature]),
            returnValue: false,
            returnValueForMissingStub: false,
          )
          as bool);

  @override
  _i6.Stream<bool> hasFeatureUnlockedStream(
    _i8.SharezonePlusFeature? feature,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#hasFeatureUnlockedStream, [feature]),
            returnValue: _i6.Stream<bool>.empty(),
            returnValueForMissingStub: _i6.Stream<bool>.empty(),
          )
          as _i6.Stream<bool>);

  @override
  _i6.Future<void> cancelStripeSubscription() =>
      (super.noSuchMethod(
            Invocation.method(#cancelStripeSubscription, []),
            returnValue: _i6.Future<void>.value(),
            returnValueForMissingStub: _i6.Future<void>.value(),
          )
          as _i6.Future<void>);

  @override
  _i6.Future<bool> showLetParentsBuyButton() =>
      (super.noSuchMethod(
            Invocation.method(#showLetParentsBuyButton, []),
            returnValue: _i6.Future<bool>.value(false),
            returnValueForMissingStub: _i6.Future<bool>.value(false),
          )
          as _i6.Future<bool>);

  @override
  _i6.Future<String?> getPlusWebsiteBuyToken() =>
      (super.noSuchMethod(
            Invocation.method(#getPlusWebsiteBuyToken, []),
            returnValue: _i6.Future<String?>.value(),
            returnValueForMissingStub: _i6.Future<String?>.value(),
          )
          as _i6.Future<String?>);

  @override
  void dispose() => super.noSuchMethod(
    Invocation.method(#dispose, []),
    returnValueForMissingStub: null,
  );
}

/// A class which mocks [UserSettingsBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserSettingsBloc extends _i1.Mock implements _i10.UserSettingsBloc {
  @override
  _i6.Stream<_i9.UserSettings> streamUserSettings() =>
      (super.noSuchMethod(
            Invocation.method(#streamUserSettings, []),
            returnValue: _i6.Stream<_i9.UserSettings>.empty(),
            returnValueForMissingStub: _i6.Stream<_i9.UserSettings>.empty(),
          )
          as _i6.Stream<_i9.UserSettings>);

  @override
  void updateSettings(_i9.UserSettings? newUserSettings) => super.noSuchMethod(
    Invocation.method(#updateSettings, [newUserSettings]),
    returnValueForMissingStub: null,
  );

  @override
  void updatePeriods(_i9.Periods? periods) => super.noSuchMethod(
    Invocation.method(#updatePeriods, [periods]),
    returnValueForMissingStub: null,
  );

  @override
  void updateEnabledWeekDays(_i9.EnabledWeekDays? enabledWeekDays) =>
      super.noSuchMethod(
        Invocation.method(#updateEnabledWeekDays, [enabledWeekDays]),
        returnValueForMissingStub: null,
      );

  @override
  void updateTimetableStartTime(_i11.Time? time) => super.noSuchMethod(
    Invocation.method(#updateTimetableStartTime, [time]),
    returnValueForMissingStub: null,
  );

  @override
  void dispose() => super.noSuchMethod(
    Invocation.method(#dispose, []),
    returnValueForMissingStub: null,
  );
}
