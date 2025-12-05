// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/l10n/feature_flag_l10n.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/settings/settings_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'settings_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharezoneContext>(), MockSpec<FeatureFlagl10n>()])
void main() {
  group(SettingsPageBody, () {
    Future<void> pushSettingsPage(WidgetTester tester, ThemeData theme) async {
      await tester.pumpWidgetBuilder(
        BlocProvider<SharezoneContext>(
          bloc: MockSharezoneContext(),
          child: ChangeNotifierProvider<FeatureFlagl10n>(
            create: (context) => MockFeatureFlagl10n(),
            child: const SettingsPageBody(),
          ),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    testGoldens('renders as expected (light mode)', (tester) async {
      await pushSettingsPage(tester, getLightTheme());

      await multiScreenGolden(tester, 'settings_page_body_light');
    });

    testGoldens('renders as expected (dark mode)', (tester) async {
      await pushSettingsPage(tester, getDarkTheme());

      await multiScreenGolden(tester, 'settings_page_body_dark');
    });
  });
}
