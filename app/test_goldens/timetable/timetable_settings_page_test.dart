// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
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
import 'package:sharezone/settings/src/bloc/user_settings_bloc.dart';
import 'package:sharezone/settings/src/subpages/timetable/bloc/timetable_settings_bloc_factory.dart';
import 'package:sharezone/settings/src/subpages/timetable/time_picker_settings_cache.dart';
import 'package:sharezone/settings/src/subpages/timetable/timetable_settings_page.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length_cache.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

import '../flutter_test_config.dart';
import 'timetable_settings_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LessonLengthCache>(),
  MockSpec<TimePickerSettingsCache>(),
  MockSpec<SubscriptionService>(),
  MockSpec<UserSettingsBloc>(),
])
void main() {
  group(TimetableSettingsPage, () {
    late UserSettingsBloc userSettingsBloc;
    setUp(() {
      userSettingsBloc = MockUserSettingsBloc();

      when(
        userSettingsBloc.streamUserSettings(),
      ).thenAnswer((_) => Stream.value(UserSettings.defaultSettings()));
    });

    Future<void> pumpTimetableSettingsPage(
      WidgetTester tester, {
      ThemeData? themeData,
    }) async {
      await tester.pumpWidgetBuilder(
        Provider<SubscriptionService>(
          create: (context) => MockSubscriptionService(),
          child: MultiBlocProvider(
            blocProviders: [
              BlocProvider<TimetableSettingsBlocFactory>(
                bloc: TimetableSettingsBlocFactory(
                  MockLessonLengthCache(),
                  MockTimePickerSettingsCache(),
                ),
              ),
              BlocProvider<UserSettingsBloc>(bloc: userSettingsBloc),
            ],
            child: (_) => const TimetableSettingsPage(),
          ),
        ),
        wrapper: materialAppWrapper(
          theme: themeData,
          localeOverrides: defaultLocales,
          localizations: SharezoneLocalizations.localizationsDelegates,
        ),
      );
    }

    testGoldens('should render as expected (light mode)', (tester) async {
      await pumpTimetableSettingsPage(tester, themeData: getLightTheme());
      await multiScreenGolden(tester, 'timetable_settings_page_light');
    });

    testGoldens('should render as expected (dark mode)', (tester) async {
      await pumpTimetableSettingsPage(tester, themeData: getDarkTheme());
      await multiScreenGolden(tester, 'timetable_settings_page_dark');
    });
  });
}
