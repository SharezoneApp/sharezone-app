// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider/multi_bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/feedback/unread_messages/has_unread_feedback_messages_provider.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/navigation/analytics/navigation_analytics.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_cache.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_option.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_controller.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

import 'sharezone_plus_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SharezonePlusPageController>(),
  MockSpec<NavigationBloc>(),
  MockSpec<NavigationExperimentCache>(),
  MockSpec<NavigationAnalytics>(),
  MockSpec<SharezoneContext>(),
  MockSpec<SharezoneGateway>(),
  MockSpec<UserGateway>(),
  MockSpec<HasUnreadFeedbackMessagesProvider>(),
])
void main() {
  group(SharezonePlusPage, () {
    late MockSharezonePlusPageController controller;
    late MockNavigationBloc navigationBloc;
    late MockNavigationExperimentCache navigationExperimentCache;
    late MockSharezoneContext sharezoneContext;
    late MockUserGateway userGateway;
    late MockSharezoneGateway sharezoneGateway;
    late MockHasUnreadFeedbackMessagesProvider
        hasUnreadFeedbackMessagesProvider;

    setUp(() {
      controller = MockSharezonePlusPageController();
      navigationBloc = MockNavigationBloc();
      navigationExperimentCache = MockNavigationExperimentCache();
      sharezoneContext = MockSharezoneContext();
      sharezoneGateway = MockSharezoneGateway();
      userGateway = MockUserGateway();
      hasUnreadFeedbackMessagesProvider =
          MockHasUnreadFeedbackMessagesProvider();

      when(sharezoneContext.api).thenAnswer((_) => sharezoneGateway);
      when(sharezoneGateway.user).thenAnswer((_) => userGateway);

      when(navigationExperimentCache.currentNavigation).thenAnswer((_) =>
          BehaviorSubject<NavigationExperimentOption>.seeded(
              NavigationExperimentOption.drawerAndBnb));

      when(navigationBloc.currentItemStream)
          .thenAnswer((_) => Stream.value(NavigationItem.sharezonePlus));
      when(navigationBloc.currentItem)
          .thenAnswer((_) => NavigationItem.sharezonePlus);
      when(navigationBloc.scaffoldKey)
          .thenAnswer((_) => GlobalKey<State<StatefulWidget>>());
      when(hasUnreadFeedbackMessagesProvider.hasUnreadFeedbackMessages)
          .thenAnswer((_) => false);

      when(controller.monthlySubscriptionPrice)
          .thenAnswer((_) => fallbackPlusMonthlyPrice);
    });

    Future<void> pumpPlusPage(
      WidgetTester tester, {
      ThemeData? theme,
    }) async {
      await tester.pumpWidgetBuilder(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SharezonePlusPageController>(
              create: (context) => controller,
            ),
            Provider<TypeOfUser?>.value(value: TypeOfUser.student),
            ChangeNotifierProvider<HasUnreadFeedbackMessagesProvider>.value(
                value: hasUnreadFeedbackMessagesProvider),
          ],
          child: MultiBlocProvider(
            blocProviders: [
              BlocProvider<NavigationBloc>(bloc: navigationBloc),
              BlocProvider<NavigationExperimentCache>(
                  bloc: navigationExperimentCache),
              BlocProvider<NavigationAnalytics>(
                  bloc: MockNavigationAnalytics()),
              BlocProvider<SharezoneContext>(bloc: sharezoneContext),
            ],
            child: (context) => const SharezonePlusPage(),
          ),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    testGoldens('renders page as expected (light theme)', (tester) async {
      await pumpPlusPage(tester, theme: getLightTheme());

      await multiScreenGolden(tester, 'sharezone_plus_page_light_theme');
    });

    testGoldens('renders page as expected (dark theme)', (tester) async {
      await pumpPlusPage(tester, theme: getDarkTheme());

      await multiScreenGolden(tester, 'sharezone_plus_page_dark_theme');
    });

    testGoldens('shows unsubscribe section if user has subscribed',
        (tester) async {
      when(controller.hasPlus).thenAnswer((_) => true);

      await pumpPlusPage(tester, theme: getLightTheme());

      // Ensure visibility
      await tester.dragUntilVisible(
        find.byKey(const ValueKey('unsubscribe-section')),
        find.byType(SingleChildScrollView),
        const Offset(0, 50),
      );

      await multiScreenGolden(
        tester,
        'sharezone_plus_unsubscribe_section',
        // Since we only need to test the unsubscribe section and we have
        // already tested the Sharezone Plus page for all devices, we don't need
        // to test it for all devices.
        devices: [Device.tabletPortrait],
      );
    });
  });
}
