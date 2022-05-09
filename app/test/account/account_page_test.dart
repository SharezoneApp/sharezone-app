// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:app_functions/src/app_functions_result.dart';
import 'package:authentification_base/authentification.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider/multi_bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/account/account_page.dart';
import 'package:sharezone/account/account_page_bloc.dart';
import 'package:sharezone/account/account_page_bloc_factory.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/overview/views/user_view.dart';
import 'package:sharezone/pages/settings/my_profile/my_profile_page.dart';
import 'package:sharezone/util/API.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_common/src/references.dart';
import 'package:user/src/models/state_enum.dart';
import 'package:user/src/models/tips/user_tip_key.dart';
import 'package:user/src/models/user.dart';
import 'package:user/src/models/user_settings.dart';

void main() {
  group('AccountPage', () {
    NavigatorObserver observer;
    setUp(() {
      observer = MockNavigatorObserver();
    });

    Future<void> _pumpAccountPageBody(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [observer],
          routes: {MyProfilePage.tag: (context) => MyProfilePage()},
          home: MultiBlocProvider(
            blocProviders: [
              BlocProvider<AccountPageBloc>(
                bloc: AccountPageBlocFactory(MockUserGateway()).create(null),
              ),
              BlocProvider<NavigationBloc>(bloc: MockNavigationBloc()),
            ],
            child: (context) => AccountPageBody(user: UserView.empty()),
          ),
        ),
      );
    }

    /// Der Test muss geskippt werden, weil bei der [MyProfilePage] noch zu oft
    /// der SharezoneContext verwendet wird. Sobald der Sharezone Context aus
    /// [MyProfilePage] entfernt wurde, kann dieser Test verwendet werden.
    /// Ticket: https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/1209
    testWidgets(
      'edit profile icon should open the profile settings page',
      (tester) async {
        await _pumpAccountPageBody(tester);

        final editButton = find.byIcon(Icons.edit);
        expect(editButton, findsOneWidget);

        await tester.tap(editButton);
        await tester.pumpAndSettle();

        /// Verify that a push event happened
        verify(observer.didPush(any, any));

        expect(find.byType(MyProfilePage), findsOneWidget);
      },
      skip: true,
    );
  });
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockNavigationBloc extends Mock implements NavigationBloc {}

class MockUserGateway implements UserGateway {
  @override
  AuthUser authUser;

  @override
  Future<void> addNotificationToken(String token) {
    throw UnimplementedError();
  }

  @override
  Future<void> addUser({AppUser user, bool merge = false}) {
    throw UnimplementedError();
  }

  @override
  Stream<AuthUser> get authUserStream => Stream.value(DemoUser());

  @override
  Future<void> changeEmail(String email) {
    throw UnimplementedError();
  }

  @override
  Future<void> changeState(StateEnum state) {
    throw UnimplementedError();
  }

  @override
  AppUser get data => throw UnimplementedError();

  @override
  Future<bool> deleteUser(SharezoneGateway gateway) {
    throw UnimplementedError();
  }

  @override
  void dispose() {}

  @override
  Future<AppUser> get() {
    throw UnimplementedError();
  }

  @override
  String getEmail() {
    throw UnimplementedError();
  }

  @override
  String getName() {
    throw UnimplementedError();
  }

  @override
  bool isAnonymous() {
    throw UnimplementedError();
  }

  @override
  Stream<bool> isAnonymousStream() {
    throw UnimplementedError();
  }

  @override
  Future<User> linkWithCredential(AuthCredential credential) {
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() {
    throw UnimplementedError();
  }

  @override
  Stream<Provider> get providerStream => throw UnimplementedError();

  @override
  References get references => throw UnimplementedError();

  @override
  Future<void> reloadFirebaseUser() {
    throw UnimplementedError();
  }

  @override
  void removeNotificationToken(String token) {}

  @override
  void setBlackboardNotifications(bool enabled) {}

  @override
  void setCommentsNotifications(bool enabled) {}

  @override
  Future<void> setHomeworkReminderTime(TimeOfDay timeOfDay) {
    throw UnimplementedError();
  }

  @override
  String get uID => throw UnimplementedError();

  @override
  Future<void> updateSettings(UserSettings userSettings) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateSettingsSingleFiled(String fieldName, data) {
    throw UnimplementedError();
  }

  @override
  Future<AppFunctionsResult<bool>> updateUser(AppUser userData) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserTip(UserTipKey userTipKey, bool value) {
    throw UnimplementedError();
  }

  @override
  Stream<DocumentSnapshot> get userDocument => throw UnimplementedError();

  @override
  Stream<AppUser> get userStream => Stream.value(AppUser.create());
}
