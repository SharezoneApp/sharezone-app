// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:file/local.dart';
import 'package:sz_repo_cli/src/common/common.dart';
import 'package:sz_repo_cli/src/common/src/build_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Build Utils', () {
    group('getBuildNameWithStage()', () {
      Package createEmptyPackage({required String? version}) {
        return Package(
          location: const LocalFileSystem().directory(''),
          name: 'test_package',
          type: PackageType.flutter,
          hasTestDirectory: false,
          hasGoldenTestsDirectory: false,
          version: version,
          hasBuildRunnerDependency: false,
        );
      }

      test('returns build name with stage', () {
        final package = createEmptyPackage(version: '1.0.0+42');

        final buildName = getBuildNameWithStage(package, 'beta');

        expect(buildName, '1.0.0-beta');
      });

      test('throws if package has no version', () {
        final package = createEmptyPackage(version: null);

        expect(
          () => getBuildNameWithStage(package, 'beta'),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
