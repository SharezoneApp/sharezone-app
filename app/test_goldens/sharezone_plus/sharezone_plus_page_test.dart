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
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/navigation/analytics/navigation_analytics.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_cache.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_option.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_bloc.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_view.dart';
import 'package:sharezone/sharezone_plus/sharezone_plus_page.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_flag.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'sharezone_plus_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SharezonePlusPageBloc>(),
  MockSpec<NavigationBloc>(),
  MockSpec<NavigationExperimentCache>(),
  MockSpec<NavigationAnalytics>(),
  MockSpec<SharezoneContext>(),
  MockSpec<SharezoneGateway>(),
  MockSpec<UserGateway>()
])
void main() {
  group(SharezonePlusPage, () {
    late MockSharezonePlusPageBloc bloc;
    late MockNavigationBloc navigationBloc;
    late MockNavigationExperimentCache navigationExperimentCache;
    late MockSharezoneContext sharezoneContext;
    late MockUserGateway userGateway;
    late MockSharezoneGateway sharezoneGateway;

    setUp(() {
      bloc = MockSharezonePlusPageBloc();
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

      when(navigationBloc.navigationItems)
          .thenAnswer((_) => Stream.value(NavigationItem.sharezonePlus));
      when(navigationBloc.currentItem)
          .thenAnswer((_) => NavigationItem.sharezonePlus);
      when(navigationBloc.scaffoldKey)
          .thenAnswer((_) => GlobalKey<State<StatefulWidget>>());
    });

    Future<void> _pumpPlusPage(
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
          ],
          child: MultiBlocProvider(
            blocProviders: [
              BlocProvider<NavigationBloc>(
                bloc: navigationBloc,
              ),
              BlocProvider<NavigationExperimentCache>(
                bloc: navigationExperimentCache,
              ),
              BlocProvider<SharezonePlusPageBloc>(
                bloc: bloc,
              ),
              BlocProvider<NavigationAnalytics>(
                bloc: MockNavigationAnalytics(),
              ),
              BlocProvider<SharezoneContext>(
                bloc: sharezoneContext,
              ),
            ],
            child: (context) => SharezonePlusPage(),
          ),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    Future<void> _tapEveryExpansionCard(WidgetTester tester) async {
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
      await _pumpPlusPage(tester, theme: lightTheme);

      await multiScreenGolden(tester, 'sharezone_plus_page_light_theme');
    });

    testGoldens('renders page as expected (dark theme)', (tester) async {
      await _pumpPlusPage(tester, theme: darkTheme);

      await multiScreenGolden(tester, 'sharezone_plus_page_dark_theme');
    });

    testGoldens('shows unsubscribe section if user has subscribed',
        (tester) async {
      final view = SharezonePlusPageView.empty().copyWith(hasPlus: true);
      when(bloc.view).thenAnswer((_) => Stream.value(view));

      await _pumpPlusPage(tester, theme: lightTheme);

      // Ensure visibility
      await tester.dragUntilVisible(
        find.byKey(ValueKey('unsubscribe-section')),
        find.byType(SingleChildScrollView),
        const Offset(0, 50),
      );

      await multiScreenGolden(
        tester,
        'sharezone_plus_unsubscribe_section',
        devices: [Device.tabletPortrait],
      );
    });

    // ignore: invalid_use_of_visible_for_testing_member
    group(PlusAdvantages, () {
      testGoldens('renders advantages as expected (dark theme)',
          (tester) async {
        await tester.pumpWidgetBuilder(
          SingleChildScrollView(child: PlusAdvantages()),
          wrapper: materialAppWrapper(theme: darkTheme),
        );

        await _tapEveryExpansionCard(tester);

        await multiScreenGolden(
          tester,
          'sharezone_plus_advantages_dark_theme',
          devices: [Device.tabletPortrait],
        );
      });

      testGoldens('renders advantages as expected (light theme)',
          (tester) async {
        await tester.pumpWidgetBuilder(
          SingleChildScrollView(child: PlusAdvantages()),
          wrapper: materialAppWrapper(theme: lightTheme),
        );

        await _tapEveryExpansionCard(tester);

        await multiScreenGolden(
          tester,
          'sharezone_plus_advantages_light_theme',
          devices: [Device.tabletPortrait],
        );
      });
    });

    // ignore: invalid_use_of_visible_for_testing_member
    group(PlusFaqSection, () {
      testGoldens('renders faq section as expected (dark theme)',
          (tester) async {
        await tester.pumpWidgetBuilder(
          SingleChildScrollView(child: PlusFaqSection()),
          wrapper: materialAppWrapper(theme: darkTheme),
        );

        await _tapEveryExpansionCard(tester);

        await multiScreenGolden(
          tester,
          'sharezone_plus_faq_section_dark_theme',
          devices: [Device.tabletPortrait],
        );
      });

      testGoldens('renders faq section as expected (light theme)',
          (tester) async {
        await tester.pumpWidgetBuilder(
          SingleChildScrollView(child: PlusFaqSection()),
          wrapper: materialAppWrapper(theme: lightTheme),
        );

        await _tapEveryExpansionCard(tester);

        await multiScreenGolden(
          tester,
          'sharezone_plus_faq_section_light_theme',
          devices: [Device.tabletPortrait],
        );
      });
    });
  });
}
