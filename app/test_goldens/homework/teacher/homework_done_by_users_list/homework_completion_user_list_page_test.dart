// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/homework/teacher/homework_done_by_users_list/homework_completion_user_list_bloc.dart';
import 'package:sharezone/homework/teacher/homework_done_by_users_list/homework_completion_user_list_bloc_factory.dart';
import 'package:sharezone/homework/teacher/homework_done_by_users_list/homework_completion_user_list_page.dart';
import 'package:sharezone/homework/teacher/homework_done_by_users_list/user_has_completed_homework_view.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'homework_completion_user_list_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<HomeworkCompletionUserListBlocFactory>(),
  MockSpec<HomeworkCompletionUserListBloc>(),
  MockSpec<SubscriptionService>(),
])
void main() {
  group(HomeworkCompletionUserListPage, () {
    late MockHomeworkCompletionUserListBloc bloc;
    late HomeworkCompletionUserListBlocFactory factory;
    late MockSubscriptionService subscriptionService;
    final homeworkId = HomeworkId('homeworkId');

    void setUserViews() {
      final random = Random(42);
      final dummyUsers = [
        for (var i = 0; i < 10; i++)
          UserHasCompletedHomeworkView(
            uid: "user$i",
            hasDone: random.nextBool(),
            name: 'User $i',
          )
      ];
      when(bloc.userViews).thenAnswer((_) => Stream.value(dummyUsers));
    }

    setUp(() {
      bloc = MockHomeworkCompletionUserListBloc();
      factory = MockHomeworkCompletionUserListBlocFactory();
      subscriptionService = MockSubscriptionService();

      when(factory.create(homeworkId)).thenReturn(bloc);
      setUserViews();
    });

    Future<void> pumpPage(WidgetTester tester, {ThemeData? theme}) async {
      await tester.pumpWidgetBuilder(
        Provider<SubscriptionService>(
          create: (context) => subscriptionService,
          child: BlocProvider<HomeworkCompletionUserListBlocFactory>(
            bloc: factory,
            child: Scaffold(
              body: HomeworkCompletionUserListPage(
                homeworkId: homeworkId,
              ),
            ),
          ),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    group('renders sharezone plus ad as expected', () {
      setUp(() {
        when(subscriptionService.hasFeatureUnlocked(
                SharezonePlusFeature.homeworkDoneByUsersList))
            .thenAnswer((_) => false);
      });

      testGoldens('(light mode)', (tester) async {
        await pumpPage(tester, theme: getLightTheme());

        await multiScreenGolden(
          tester,
          'homework_completion_list_page_sharezone_ad_light',
        );
      });

      testGoldens('(dark mode)', (tester) async {
        await pumpPage(tester, theme: getDarkTheme());

        await multiScreenGolden(
          tester,
          'homework_completion_list_page_sharezone_ad_dark',
        );
      });
    });

    group('renders list as expected', () {
      setUp(() {
        when(subscriptionService.hasFeatureUnlocked(
                SharezonePlusFeature.homeworkDoneByUsersList))
            .thenAnswer((_) => true);
      });

      testGoldens('(light mode)', (tester) async {
        await pumpPage(tester, theme: getLightTheme());

        await multiScreenGolden(
          tester,
          'homework_completion_list_page_light',
        );
      });

      testGoldens('(dark mode)', (tester) async {
        await pumpPage(tester, theme: getDarkTheme());

        await multiScreenGolden(
          tester,
          'homework_completion_list_page_dark',
        );
      });
    });
  });
}
