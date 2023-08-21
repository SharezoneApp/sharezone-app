// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:golden_toolkit/golden_toolkit.dart';

/// Configurations for the [GoldenToolkit] library.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  const Device phoneLandscape = Device(
    name: 'phone_landscape',
    size: Size(667, 375),
  );

  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      // Due to slight differences in rendering across platforms, mostly around
      // text, the tests will only be run on a macOS machine on GitHub Actions.
      // This means that if you update the tests on a Linux or Windows machine
      // the golden tests will not pass on GitHub Actions. Instead you are
      // recommended to download the goldens directly from the failed GitHub
      // Actions job, and use those inside of your branch.
      //
      // See
      // https://github.com/flutter/flutter/issues/36667#issuecomment-521335243.
      skipGoldenAssertion: () => !Platform.isMacOS,
      defaultDevices: const [
        Device.phone,
        phoneLandscape,
        Device.tabletLandscape,
        Device.tabletPortrait,
        Device.iphone11,
      ],
    ),
  );
}
