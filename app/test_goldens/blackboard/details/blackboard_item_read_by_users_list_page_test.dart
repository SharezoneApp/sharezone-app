// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/blackboard/details/blackboard_item_read_by_users_list/blackboard_item_read_by_users_list_bloc.dart';
import 'package:sharezone/blackboard/details/blackboard_item_read_by_users_list/blackboard_item_read_by_users_list_page.dart';
import 'package:sharezone/blackboard/details/blackboard_item_read_by_users_list/user_view.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

import 'blackboard_item_read_by_users_list_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<BlackboardItemReadByUsersListBloc>(),
  MockSpec<SubscriptionService>(),
])
void main() {
  // We use the body instead of entire page to avoid mocking `SharezoneContext`.
  //
  // ignore: invalid_use_of_visible_for_testing_member
  group(BlackboardItemReadByUsersListPageBody, () {
    late MockBlackboardItemReadByUsersListBloc bloc;
    late MockSubscriptionService subscriptionService;

    void setUserViews() {
      final random = Random(42);
      final dummyUsers = [
        for (var i = 0; i < 10; i++)
          UserView(
            uid: "user$i",
            hasRead: random.nextBool(),
            typeOfUser: TypeOfUser.student.toReadableString(),
            name: 'User $i',
          )
      ];
      when(bloc.userViews).thenAnswer((_) => Stream.value(dummyUsers));
    }

    setUp(() {
      bloc = MockBlackboardItemReadByUsersListBloc();
      subscriptionService = MockSubscriptionService();

      setUserViews();
    });

    Future<void> pumpPage(WidgetTester tester, {ThemeData? theme}) async {
      await tester.pumpWidgetBuilder(
        Provider<SubscriptionService>(
          create: (context) => subscriptionService,
          child: BlocProvider<BlackboardItemReadByUsersListBloc>(
            bloc: bloc,
            child: const Scaffold(
              body: BlackboardItemReadByUsersListPageBody(),
            ),
          ),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    group('renders sharezone plus ad as expected', () {
      setUp(() {
        when(subscriptionService.hasFeatureUnlocked(
                SharezonePlusFeature.infoSheetReadByUsersList))
            .thenAnswer((_) => false);
      });

      testGoldens('(light mode)', (tester) async {
        await pumpPage(tester, theme: lightTheme);

        await multiScreenGolden(
          tester,
          'blackboard_item_read_by_users_list_page_sharezone_ad_light',
        );
      });

      testGoldens('(dark mode)', (tester) async {
        await pumpPage(tester, theme: darkTheme);

        await multiScreenGolden(
          tester,
          'blackboard_item_read_by_users_list_page_sharezone_ad_dark',
        );
      });
    });

    group('renders list as expected', () {
      setUp(() {
        when(subscriptionService.hasFeatureUnlocked(
                SharezonePlusFeature.infoSheetReadByUsersList))
            .thenAnswer((_) => true);
      });

      testGoldens('(light mode)', (tester) async {
        await pumpPage(tester, theme: lightTheme);

        await multiScreenGolden(
          tester,
          'blackboard_item_read_by_users_list_page_light',
        );
      });

      testGoldens('(dark mode)', (tester) async {
        await pumpPage(tester, theme: darkTheme);

        await multiScreenGolden(
          tester,
          'blackboard_item_read_by_users_list_page_dark',
        );
      });
    });
  });
}
