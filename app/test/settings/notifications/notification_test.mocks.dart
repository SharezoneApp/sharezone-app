// Mocks generated by Mockito 5.4.2 from annotations
// in sharezone/test/settings/notifications/notification_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:app_functions/app_functions.dart' as _i4;
import 'package:authentification_base/authentification.dart' as _i7;
import 'package:cloud_firestore/cloud_firestore.dart' as _i8;
import 'package:firebase_auth/firebase_auth.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:mockito/mockito.dart' as _i1;
import 'package:sharezone/util/api.dart' as _i11;
import 'package:sharezone/util/api/user_api.dart' as _i5;
import 'package:sharezone_common/references.dart' as _i2;
import 'package:user/user.dart' as _i3;

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

class _FakeReferences_0 extends _i1.SmartFake implements _i2.References {
  _FakeReferences_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAppUser_1 extends _i1.SmartFake implements _i3.AppUser {
  _FakeAppUser_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAppFunctionsResult_2<T> extends _i1.SmartFake
    implements _i4.AppFunctionsResult<T> {
  _FakeAppFunctionsResult_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserSettings_3 extends _i1.SmartFake implements _i3.UserSettings {
  _FakeUserSettings_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserTipData_4 extends _i1.SmartFake implements _i3.UserTipData {
  _FakeUserTipData_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [UserGateway].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserGateway extends _i1.Mock implements _i5.UserGateway {
  @override
  _i2.References get references => (super.noSuchMethod(
        Invocation.getter(#references),
        returnValue: _FakeReferences_0(
          this,
          Invocation.getter(#references),
        ),
        returnValueForMissingStub: _FakeReferences_0(
          this,
          Invocation.getter(#references),
        ),
      ) as _i2.References);
  @override
  String get uID => (super.noSuchMethod(
        Invocation.getter(#uID),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  _i6.Stream<_i3.AppUser?> get userStream => (super.noSuchMethod(
        Invocation.getter(#userStream),
        returnValue: _i6.Stream<_i3.AppUser?>.empty(),
        returnValueForMissingStub: _i6.Stream<_i3.AppUser?>.empty(),
      ) as _i6.Stream<_i3.AppUser?>);
  @override
  _i6.Stream<_i7.AuthUser?> get authUserStream => (super.noSuchMethod(
        Invocation.getter(#authUserStream),
        returnValue: _i6.Stream<_i7.AuthUser?>.empty(),
        returnValueForMissingStub: _i6.Stream<_i7.AuthUser?>.empty(),
      ) as _i6.Stream<_i7.AuthUser?>);
  @override
  _i6.Stream<bool> get isSignedInStream => (super.noSuchMethod(
        Invocation.getter(#isSignedInStream),
        returnValue: _i6.Stream<bool>.empty(),
        returnValueForMissingStub: _i6.Stream<bool>.empty(),
      ) as _i6.Stream<bool>);
  @override
  _i6.Stream<_i8.DocumentSnapshot<Object?>> get userDocument =>
      (super.noSuchMethod(
        Invocation.getter(#userDocument),
        returnValue: _i6.Stream<_i8.DocumentSnapshot<Object?>>.empty(),
        returnValueForMissingStub:
            _i6.Stream<_i8.DocumentSnapshot<Object?>>.empty(),
      ) as _i6.Stream<_i8.DocumentSnapshot<Object?>>);
  @override
  _i6.Stream<_i7.Provider?> get providerStream => (super.noSuchMethod(
        Invocation.getter(#providerStream),
        returnValue: _i6.Stream<_i7.Provider?>.empty(),
        returnValueForMissingStub: _i6.Stream<_i7.Provider?>.empty(),
      ) as _i6.Stream<_i7.Provider?>);
  @override
  _i6.Future<_i3.AppUser> get() => (super.noSuchMethod(
        Invocation.method(
          #get,
          [],
        ),
        returnValue: _i6.Future<_i3.AppUser>.value(_FakeAppUser_1(
          this,
          Invocation.method(
            #get,
            [],
          ),
        )),
        returnValueForMissingStub: _i6.Future<_i3.AppUser>.value(_FakeAppUser_1(
          this,
          Invocation.method(
            #get,
            [],
          ),
        )),
      ) as _i6.Future<_i3.AppUser>);
  @override
  _i6.Future<void> logOut() => (super.noSuchMethod(
        Invocation.method(
          #logOut,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  bool isAnonymous() => (super.noSuchMethod(
        Invocation.method(
          #isAnonymous,
          [],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i6.Stream<bool?> isAnonymousStream() => (super.noSuchMethod(
        Invocation.method(
          #isAnonymousStream,
          [],
        ),
        returnValue: _i6.Stream<bool?>.empty(),
        returnValueForMissingStub: _i6.Stream<bool?>.empty(),
      ) as _i6.Stream<bool?>);
  @override
  _i6.Future<void> linkWithCredential(_i9.AuthCredential? credential) =>
      (super.noSuchMethod(
        Invocation.method(
          #linkWithCredential,
          [credential],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> changeState(_i3.StateEnum? state) => (super.noSuchMethod(
        Invocation.method(
          #changeState,
          [state],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> addNotificationToken(String? token) => (super.noSuchMethod(
        Invocation.method(
          #addNotificationToken,
          [token],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  void removeNotificationToken(String? token) => super.noSuchMethod(
        Invocation.method(
          #removeNotificationToken,
          [token],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i6.Future<void> setHomeworkReminderTime(_i10.TimeOfDay? timeOfDay) =>
      (super.noSuchMethod(
        Invocation.method(
          #setHomeworkReminderTime,
          [timeOfDay],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> updateSettings(_i3.UserSettings? userSettings) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateSettings,
          [userSettings],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> updateSettingsSingleFiled(
    String? fieldName,
    dynamic data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateSettingsSingleFiled,
          [
            fieldName,
            data,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> updateUserTip(
    _i3.UserTipKey? userTipKey,
    bool? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserTip,
          [
            userTipKey,
            value,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  void setBlackboardNotifications(bool? enabled) => super.noSuchMethod(
        Invocation.method(
          #setBlackboardNotifications,
          [enabled],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void setCommentsNotifications(bool? enabled) => super.noSuchMethod(
        Invocation.method(
          #setCommentsNotifications,
          [enabled],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i6.Future<void> changeEmail(String? email) => (super.noSuchMethod(
        Invocation.method(
          #changeEmail,
          [email],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> addUser({
    required _i3.AppUser? user,
    bool? merge = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addUser,
          [],
          {
            #user: user,
            #merge: merge,
          },
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<bool> deleteUser(_i11.SharezoneGateway? gateway) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteUser,
          [gateway],
        ),
        returnValue: _i6.Future<bool>.value(false),
        returnValueForMissingStub: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<_i4.AppFunctionsResult<bool>> updateUser(_i3.AppUser? userData) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUser,
          [userData],
        ),
        returnValue: _i6.Future<_i4.AppFunctionsResult<bool>>.value(
            _FakeAppFunctionsResult_2<bool>(
          this,
          Invocation.method(
            #updateUser,
            [userData],
          ),
        )),
        returnValueForMissingStub:
            _i6.Future<_i4.AppFunctionsResult<bool>>.value(
                _FakeAppFunctionsResult_2<bool>(
          this,
          Invocation.method(
            #updateUser,
            [userData],
          ),
        )),
      ) as _i6.Future<_i4.AppFunctionsResult<bool>>);
  @override
  _i6.Future<void> dispose() => (super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}

/// A class which mocks [AppUser].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppUser extends _i1.Mock implements _i3.AppUser {
  @override
  String get id => (super.noSuchMethod(
        Invocation.getter(#id),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  String get name => (super.noSuchMethod(
        Invocation.getter(#name),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  String get abbreviation => (super.noSuchMethod(
        Invocation.getter(#abbreviation),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  _i3.TypeOfUser get typeOfUser => (super.noSuchMethod(
        Invocation.getter(#typeOfUser),
        returnValue: _i3.TypeOfUser.student,
        returnValueForMissingStub: _i3.TypeOfUser.student,
      ) as _i3.TypeOfUser);
  @override
  int get referralScore => (super.noSuchMethod(
        Invocation.getter(#referralScore),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);
  @override
  _i3.StateEnum get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i3.StateEnum.badenWuerttemberg,
        returnValueForMissingStub: _i3.StateEnum.badenWuerttemberg,
      ) as _i3.StateEnum);
  @override
  List<String?> get notificationTokens => (super.noSuchMethod(
        Invocation.getter(#notificationTokens),
        returnValue: <String?>[],
        returnValueForMissingStub: <String?>[],
      ) as List<String?>);
  @override
  _i3.UserSettings get userSettings => (super.noSuchMethod(
        Invocation.getter(#userSettings),
        returnValue: _FakeUserSettings_3(
          this,
          Invocation.getter(#userSettings),
        ),
        returnValueForMissingStub: _FakeUserSettings_3(
          this,
          Invocation.getter(#userSettings),
        ),
      ) as _i3.UserSettings);
  @override
  _i3.UserTipData get userTipData => (super.noSuchMethod(
        Invocation.getter(#userTipData),
        returnValue: _FakeUserTipData_4(
          this,
          Invocation.getter(#userTipData),
        ),
        returnValueForMissingStub: _FakeUserTipData_4(
          this,
          Invocation.getter(#userTipData),
        ),
      ) as _i3.UserTipData);
  @override
  Map<String, dynamic> toCreateJson() => (super.noSuchMethod(
        Invocation.method(
          #toCreateJson,
          [],
        ),
        returnValue: <String, dynamic>{},
        returnValueForMissingStub: <String, dynamic>{},
      ) as Map<String, dynamic>);
  @override
  Map<String, dynamic> toEditJson() => (super.noSuchMethod(
        Invocation.method(
          #toEditJson,
          [],
        ),
        returnValue: <String, dynamic>{},
        returnValueForMissingStub: <String, dynamic>{},
      ) as Map<String, dynamic>);
  @override
  _i3.AppUser copyWith({
    String? id,
    String? name,
    String? abbreviation,
    _i3.TypeOfUser? typeOfUser,
    String? reminderTime,
    int? referralScore,
    List<String>? notificationTokens,
    _i3.StateEnum? state,
    bool? blackboardNotifications,
    bool? commentsNotifications,
    _i3.UserSettings? userSettings,
    _i3.UserTipData? userTipData,
    _i3.Subscription? subscription,
    _i3.Features? features,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #copyWith,
          [],
          {
            #id: id,
            #name: name,
            #abbreviation: abbreviation,
            #typeOfUser: typeOfUser,
            #reminderTime: reminderTime,
            #referralScore: referralScore,
            #notificationTokens: notificationTokens,
            #state: state,
            #blackboardNotifications: blackboardNotifications,
            #commentsNotifications: commentsNotifications,
            #userSettings: userSettings,
            #userTipData: userTipData,
            #subscription: subscription,
            #features: features,
          },
        ),
        returnValue: _FakeAppUser_1(
          this,
          Invocation.method(
            #copyWith,
            [],
            {
              #id: id,
              #name: name,
              #abbreviation: abbreviation,
              #typeOfUser: typeOfUser,
              #reminderTime: reminderTime,
              #referralScore: referralScore,
              #notificationTokens: notificationTokens,
              #state: state,
              #blackboardNotifications: blackboardNotifications,
              #commentsNotifications: commentsNotifications,
              #userSettings: userSettings,
              #userTipData: userTipData,
              #subscription: subscription,
              #features: features,
            },
          ),
        ),
        returnValueForMissingStub: _FakeAppUser_1(
          this,
          Invocation.method(
            #copyWith,
            [],
            {
              #id: id,
              #name: name,
              #abbreviation: abbreviation,
              #typeOfUser: typeOfUser,
              #reminderTime: reminderTime,
              #referralScore: referralScore,
              #notificationTokens: notificationTokens,
              #state: state,
              #blackboardNotifications: blackboardNotifications,
              #commentsNotifications: commentsNotifications,
              #userSettings: userSettings,
              #userTipData: userTipData,
              #subscription: subscription,
              #features: features,
            },
          ),
        ),
      ) as _i3.AppUser);
}
