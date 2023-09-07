import 'dart:io';

import 'package:sz_repo_cli/src/common/common.dart';
import 'package:sz_repo_cli/src/common/src/build_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Build Utils', () {
    group('getBuildNameWithStage()', () {
      Package createEmptyPackage() {
        return Package(
          location: Directory(''),
          name: 'test_package',
          type: PackageType.flutter,
          hasTestDirectory: false,
          hasGoldenTestsDirectory: false,
          version: '1.0.0+42',
        );
      }

      test('returns build name with stage', () {
        final package = createEmptyPackage();

        final buildName = getBuildNameWithStage(package, 'beta');

        expect(buildName, '1.0.0-beta');
      });
    });
  });
}
