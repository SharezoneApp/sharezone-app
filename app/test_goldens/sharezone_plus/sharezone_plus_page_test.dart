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

      when(navigationBloc.currentItem)
          .thenAnswer((_) => NavigationItem.sharezonePlus);
      when(navigationBloc.scaffoldKey)
          .thenAnswer((_) => GlobalKey<State<StatefulWidget>>());
    });

    Future<void> _pumpPlusPage(
      WidgetTester tester, {
      required ThemeData theme,
    }) async {
      await tester.pumpWidgetBuilder(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SubscriptionEnabledFlag>(
              create: (context) => SubscriptionEnabledFlag(
                InMemoryKeyValueStore(),
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

    group('everything collapsed', () {
      testGoldens('renders as expected (light theme)', (tester) async {
        await _pumpPlusPage(tester, theme: lightTheme);

        await multiScreenGolden(
            tester, 'sharezone_plus_page_collapsed_light_theme');
      });

      testGoldens('renders as expected (dark theme)', (tester) async {
        await _pumpPlusPage(tester, theme: darkTheme);

        await multiScreenGolden(
            tester, 'sharezone_plus_page_collapsed_dark_theme');
      });
    });
  });
}
