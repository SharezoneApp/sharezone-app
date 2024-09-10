// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/files_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:sharezone/filesharing/file_sharing_view_home.dart';

void main() {
  group('$FileStorageUsageIndicator', () {
    testGoldens(
      'displays the right indicator for normal usage',
      (tester) async {
        await tester.pumpWidgetBuilder(
            const FileStorageUsageIndicator(
              usedStorage: KiloByteSize(megabytes: 2350),
              totalStorage: KiloByteSize(gigabytes: 10),
              plusStorage: KiloByteSize(gigabytes: 30),
            ),
            wrapper: materialAppWrapper());

        await screenMatchesGolden(
            tester, 'file_storage_usage_indicator_normal_usage');
      },
    );
    testGoldens(
      'displays the right indicator for high usage',
      (tester) async {
        await tester.pumpWidgetBuilder(
            const FileStorageUsageIndicator(
              usedStorage: KiloByteSize(megabytes: 7823),
              totalStorage: KiloByteSize(gigabytes: 10),
              plusStorage: KiloByteSize(gigabytes: 30),
            ),
            wrapper: materialAppWrapper());

        await screenMatchesGolden(
            tester, 'file_storage_usage_indicator_high_usage');
      },
    );
    testGoldens(
      'displays the right indicator for very high usage',
      (tester) async {
        await tester.pumpWidgetBuilder(
            const FileStorageUsageIndicator(
              usedStorage: KiloByteSize(megabytes: 9752),
              totalStorage: KiloByteSize(gigabytes: 10),
              plusStorage: KiloByteSize(gigabytes: 30),
            ),
            wrapper: materialAppWrapper());

        await screenMatchesGolden(
            tester, 'file_storage_usage_indicator_very_high_usage');
      },
    );
  });
}
