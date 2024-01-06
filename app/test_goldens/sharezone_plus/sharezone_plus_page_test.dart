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
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/navigation/analytics/navigation_analytics.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_cache.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_option.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_controller.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_flag.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_plus_page_ui/sharezone_plus_page_ui.dart';
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
  MockSpec<UserGateway>()
])
void main() {
  group(SharezonePlusPage, () {
    late MockSharezonePlusPageController controller;
    late MockNavigationBloc navigationBloc;
    late MockNavigationExperimentCache navigationExperimentCache;
    late MockSharezoneContext sharezoneContext;
    late MockUserGateway userGateway;
    late MockSharezoneGateway sharezoneGateway;

    setUp(() {
      controller = MockSharezonePlusPageController();
      navigationBloc = MockNavigationBloc();
      navigationExperimentCache = MockNavigationExperimentCache();
      sharezoneContext = MockSharezoneContext();
      sharezoneGateway = MockSharezoneGateway();
      userGateway = MockUserGateway();

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

      when(controller.price).thenAnswer((_) => fallbackPlusPrice);
    });

    Future<void> pumpPlusPage(
      WidgetTester tester, {
      ThemeData? theme,
    }) async {
      await tester.pumpWidgetBuilder(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SubscriptionEnabledFlag>(
              create: (context) => SubscriptionEnabledFlag(
                InMemoryKeyValueStore({
                  SubscriptionEnabledFlag.cacheKey: true,
                }),
              ),
            ),
            ChangeNotifierProvider<SharezonePlusPageController>(
              create: (context) => controller,
            ),
            Provider<TypeOfUser?>.value(value: TypeOfUser.student),
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

    Future<void> tapEveryExpansionCard(WidgetTester tester) async {
      for (final element in find.byType(ExpansionCard).evaluate()) {
        // We need to scroll the element into view before we can tap it.
        await tester.dragUntilVisible(
          find.byWidget(element.widget),
          find.byType(SingleChildScrollView),
          const Offset(0, 50),
        );

        await tester.tap(find.byWidget(element.widget));
      }
      await tester.pumpAndSettle();
    }

    testGoldens('renders page as expected (light theme)', (tester) async {
      await pumpPlusPage(tester, theme: lightTheme);

      await multiScreenGolden(tester, 'sharezone_plus_page_light_theme');
    });

    testGoldens('renders page as expected (dark theme)', (tester) async {
      await pumpPlusPage(tester, theme: darkTheme);

      await multiScreenGolden(tester, 'sharezone_plus_page_dark_theme');
    });

    testGoldens('shows unsubscribe section if user has subscribed',
        (tester) async {
      when(controller.hasPlus).thenAnswer((_) => true);

      await pumpPlusPage(tester, theme: lightTheme);

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

    // ignore: invalid_use_of_visible_for_testing_member
    group(SharezonePlusAdvantages, () {
      for (final typeOfUser in [
        TypeOfUser.parent,
        TypeOfUser.teacher,
        TypeOfUser.student
      ]) {
        Future<void> pumpPlusAdvantages(
          WidgetTester tester, {
          required ThemeData theme,
          required TypeOfUser typeOfUser,
        }) async {
          await tester.pumpWidgetBuilder(
            SingleChildScrollView(
              child: SharezonePlusAdvantages(
                typeOfUser: typeOfUser,
              ),
            ),
            wrapper: materialAppWrapper(theme: theme),
          );
        }

        testGoldens(
            'renders advantages for ${typeOfUser.name} as expected (dark theme)',
            (tester) async {
          await pumpPlusAdvantages(
            tester,
            theme: darkTheme,
            typeOfUser: typeOfUser,
          );

          await tapEveryExpansionCard(tester);

          await multiScreenGolden(
            tester,
            'sharezone_plus_advantages_${typeOfUser.name}_dark_theme',
            // Since we only need to test the expanded advantages and we have
            // already tested the Sharezone Plus page for all devices, we don't
            // need to test it for all devices. Using a tablet portrait is
            // sufficient.
            devices: [Device.tabletPortrait],
          );
        });

        testGoldens(
            'renders advantages for ${typeOfUser.name} as expected (light theme)',
            (tester) async {
          await pumpPlusAdvantages(
            tester,
            theme: lightTheme,
            typeOfUser: typeOfUser,
          );

          await tapEveryExpansionCard(tester);

          await multiScreenGolden(
            tester,
            'sharezone_plus_advantages_${typeOfUser.name}_light_theme',
            // See comment above.
            devices: [Device.tabletPortrait],
          );
        });
      }
    });

    // ignore: invalid_use_of_visible_for_testing_member
    group(SharezonePlusFaq, () {
      testGoldens('renders faq section as expected (dark theme)',
          (tester) async {
        await tester.pumpWidgetBuilder(
          const SingleChildScrollView(child: SharezonePlusFaq()),
          wrapper: materialAppWrapper(theme: darkTheme),
        );

        await tapEveryExpansionCard(tester);

        await multiScreenGolden(
          tester,
          'sharezone_plus_faq_section_dark_theme',
          // See comment above.
          devices: [Device.tabletPortrait],
        );
      });

      testGoldens('renders faq section as expected (light theme)',
          (tester) async {
        await tester.pumpWidgetBuilder(
          const SingleChildScrollView(child: SharezonePlusFaq()),
          wrapper: materialAppWrapper(theme: lightTheme),
        );

        await tapEveryExpansionCard(tester);

        await multiScreenGolden(
          tester,
          'sharezone_plus_faq_section_light_theme',
          // See comment above.
          devices: [Device.tabletPortrait],
        );
      });
    });
  });
}
