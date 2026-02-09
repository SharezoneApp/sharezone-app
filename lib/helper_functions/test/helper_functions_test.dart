// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:helper_functions/helper_functions.dart';
import 'package:test/test.dart';

enum TestEnum { value1, value2, value3 }

void main() {
  group('String helper functions', () {
    test('isEmptyOrNull returns true for null', () {
      expect(isEmptyOrNull(null), isTrue);
    });

    test('isEmptyOrNull returns true for empty string', () {
      expect(isEmptyOrNull(''), isTrue);
    });

    test('isEmptyOrNull returns false for non-empty string', () {
      expect(isEmptyOrNull('hello'), isFalse);
    });

    test('isNotEmptyOrNull returns false for null', () {
      expect(isNotEmptyOrNull(null), isFalse);
    });

    test('isNotEmptyOrNull returns false for empty string', () {
      expect(isNotEmptyOrNull(''), isFalse);
    });

    test('isNotEmptyOrNull returns true for non-empty string', () {
      expect(isNotEmptyOrNull('hello'), isTrue);
    });
  });

  group('EnumByNameWithDefault extension', () {
    test('tryByName returns enum value when name matches', () {
      expect(TestEnum.values.tryByName('value1'), equals(TestEnum.value1));
      expect(TestEnum.values.tryByName('value2'), equals(TestEnum.value2));
    });

    test('tryByName returns default value when name does not match', () {
      expect(
        TestEnum.values.tryByName('invalid', defaultValue: TestEnum.value3),
        equals(TestEnum.value3),
      );
    });

    test(
      'tryByName throws ArgumentError when name does not match and no default value provided',
      () {
        expect(() => TestEnum.values.tryByName('invalid'), throwsArgumentError);
      },
    );

    test(
      'tryByName throws ArgumentError when name is null and no default value provided',
      () {
        expect(() => TestEnum.values.tryByName(null), throwsArgumentError);
      },
    );

    test('byNameOrNull returns enum value when name matches', () {
      expect(TestEnum.values.byNameOrNull('value1'), equals(TestEnum.value1));
    });

    test('byNameOrNull returns null when name does not match', () {
      expect(TestEnum.values.byNameOrNull('invalid'), isNull);
    });

    test('byNameOrNull returns null when name is null', () {
      expect(TestEnum.values.byNameOrNull(null), isNull);
    });
  });
}
