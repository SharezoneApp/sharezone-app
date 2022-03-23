import 'dart:async';
import 'dart:io';

import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      // Due to slight differences in rendering across platforms, mostly around
      // text, the tests will only be run on a macOS machine on Github Actions.
      // This means that if you update the tests on a Linux or Windows machine
      // the golden tests will not pass on Github Actions. Instead you are
      // recommended to download the goldens directly from the failed Github
      // Actions job, and use those inside of your branch.
      //
      // See
      // https://github.com/flutter/flutter/issues/36667#issuecomment-521335243.
      skipGoldenAssertion: () => !Platform.isMacOS,
      defaultDevices: const [
        Device.phone,
        Device.tabletLandscape,
        Device.tabletPortrait,
        Device.iphone11,
      ],
    ),
  );
}
