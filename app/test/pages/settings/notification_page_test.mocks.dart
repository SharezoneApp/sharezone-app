// Mocks generated by Mockito 5.4.2 from annotations
// in sharezone/test/pages/settings/notification_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:clock/clock.dart' as _i4;
import 'package:flutter/material.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;
import 'package:sharezone/blocs/settings/notifications_bloc.dart' as _i3;
import 'package:sharezone/blocs/settings/notifications_bloc_factory.dart'
    as _i7;
import 'package:sharezone/sharezone_plus/subscription_service/subscription_flag.dart'
    as _i5;
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart'
    as _i8;
import 'package:user/user.dart' as _i9;

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

class _FakeStreamSubscription_0<T> extends _i1.SmartFake
    implements _i2.StreamSubscription<T> {
  _FakeStreamSubscription_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeNotificationsBloc_1 extends _i1.SmartFake
    implements _i3.NotificationsBloc {
  _FakeNotificationsBloc_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeClock_2 extends _i1.SmartFake implements _i4.Clock {
  _FakeClock_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSubscriptionEnabledFlag_3 extends _i1.SmartFake
    implements _i5.SubscriptionEnabledFlag {
  _FakeSubscriptionEnabledFlag_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [NotificationsBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockNotificationsBloc extends _i1.Mock implements _i3.NotificationsBloc {
  @override
  _i2.StreamSubscription<dynamic> get subscription => (super.noSuchMethod(
        Invocation.getter(#subscription),
        returnValue: _FakeStreamSubscription_0<dynamic>(
          this,
          Invocation.getter(#subscription),
        ),
        returnValueForMissingStub: _FakeStreamSubscription_0<dynamic>(
          this,
          Invocation.getter(#subscription),
        ),
      ) as _i2.StreamSubscription<dynamic>);
  @override
  set subscription(_i2.StreamSubscription<dynamic>? _subscription) =>
      super.noSuchMethod(
        Invocation.setter(
          #subscription,
          _subscription,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i2.Stream<bool> get notificationsForHomeworks => (super.noSuchMethod(
        Invocation.getter(#notificationsForHomeworks),
        returnValue: _i2.Stream<bool>.empty(),
        returnValueForMissingStub: _i2.Stream<bool>.empty(),
      ) as _i2.Stream<bool>);
  @override
  _i2.Stream<bool> get notificationsForBlackboard => (super.noSuchMethod(
        Invocation.getter(#notificationsForBlackboard),
        returnValue: _i2.Stream<bool>.empty(),
        returnValueForMissingStub: _i2.Stream<bool>.empty(),
      ) as _i2.Stream<bool>);
  @override
  _i2.Stream<bool> get notificationsForComments => (super.noSuchMethod(
        Invocation.getter(#notificationsForComments),
        returnValue: _i2.Stream<bool>.empty(),
        returnValueForMissingStub: _i2.Stream<bool>.empty(),
      ) as _i2.Stream<bool>);
  @override
  dynamic Function(bool) get changeNotificationsForHomeworks =>
      (super.noSuchMethod(
        Invocation.getter(#changeNotificationsForHomeworks),
        returnValue: (bool __p0) => null,
        returnValueForMissingStub: (bool __p0) => null,
      ) as dynamic Function(bool));
  @override
  dynamic Function(bool) get changeNotificationsForBlackboard =>
      (super.noSuchMethod(
        Invocation.getter(#changeNotificationsForBlackboard),
        returnValue: (bool __p0) => null,
        returnValueForMissingStub: (bool __p0) => null,
      ) as dynamic Function(bool));
  @override
  dynamic Function(bool) get changeNotificationsForComments =>
      (super.noSuchMethod(
        Invocation.getter(#changeNotificationsForComments),
        returnValue: (bool __p0) => null,
        returnValueForMissingStub: (bool __p0) => null,
      ) as dynamic Function(bool));
  @override
  _i2.Stream<_i6.TimeOfDay?> get notificationsTimeForHomeworks =>
      (super.noSuchMethod(
        Invocation.getter(#notificationsTimeForHomeworks),
        returnValue: _i2.Stream<_i6.TimeOfDay?>.empty(),
        returnValueForMissingStub: _i2.Stream<_i6.TimeOfDay?>.empty(),
      ) as _i2.Stream<_i6.TimeOfDay?>);
  @override
  dynamic Function(_i6.TimeOfDay) get changeNotificationsTimeForHomeworks =>
      (super.noSuchMethod(
        Invocation.getter(#changeNotificationsTimeForHomeworks),
        returnValue: (_i6.TimeOfDay __p0) => null,
        returnValueForMissingStub: (_i6.TimeOfDay __p0) => null,
      ) as dynamic Function(_i6.TimeOfDay));
  @override
  List<_i6.TimeOfDay> getTimeForHomeworkNotifications() => (super.noSuchMethod(
        Invocation.method(
          #getTimeForHomeworkNotifications,
          [],
        ),
        returnValue: <_i6.TimeOfDay>[],
        returnValueForMissingStub: <_i6.TimeOfDay>[],
      ) as List<_i6.TimeOfDay>);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [NotificationsBlocFactory].
///
/// See the documentation for Mockito's code generation for more information.
class MockNotificationsBlocFactory extends _i1.Mock
    implements _i7.NotificationsBlocFactory {
  @override
  _i3.NotificationsBloc create() => (super.noSuchMethod(
        Invocation.method(
          #create,
          [],
        ),
        returnValue: _FakeNotificationsBloc_1(
          this,
          Invocation.method(
            #create,
            [],
          ),
        ),
        returnValueForMissingStub: _FakeNotificationsBloc_1(
          this,
          Invocation.method(
            #create,
            [],
          ),
        ),
      ) as _i3.NotificationsBloc);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [SubscriptionService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSubscriptionService extends _i1.Mock
    implements _i8.SubscriptionService {
  @override
  _i2.Stream<_i9.AppUser?> get user => (super.noSuchMethod(
        Invocation.getter(#user),
        returnValue: _i2.Stream<_i9.AppUser?>.empty(),
        returnValueForMissingStub: _i2.Stream<_i9.AppUser?>.empty(),
      ) as _i2.Stream<_i9.AppUser?>);
  @override
  _i4.Clock get clock => (super.noSuchMethod(
        Invocation.getter(#clock),
        returnValue: _FakeClock_2(
          this,
          Invocation.getter(#clock),
        ),
        returnValueForMissingStub: _FakeClock_2(
          this,
          Invocation.getter(#clock),
        ),
      ) as _i4.Clock);
  @override
  _i5.SubscriptionEnabledFlag get isSubscriptionEnabledFlag =>
      (super.noSuchMethod(
        Invocation.getter(#isSubscriptionEnabledFlag),
        returnValue: _FakeSubscriptionEnabledFlag_3(
          this,
          Invocation.getter(#isSubscriptionEnabledFlag),
        ),
        returnValueForMissingStub: _FakeSubscriptionEnabledFlag_3(
          this,
          Invocation.getter(#isSubscriptionEnabledFlag),
        ),
      ) as _i5.SubscriptionEnabledFlag);
  @override
  bool isSubscriptionActive([_i9.AppUser? appUser]) => (super.noSuchMethod(
        Invocation.method(
          #isSubscriptionActive,
          [appUser],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i2.Stream<bool> isSubscriptionActiveStream() => (super.noSuchMethod(
        Invocation.method(
          #isSubscriptionActiveStream,
          [],
        ),
        returnValue: _i2.Stream<bool>.empty(),
        returnValueForMissingStub: _i2.Stream<bool>.empty(),
      ) as _i2.Stream<bool>);
  @override
  bool hasFeatureUnlocked(_i8.SharezonePlusFeature? feature) =>
      (super.noSuchMethod(
        Invocation.method(
          #hasFeatureUnlocked,
          [feature],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
}
