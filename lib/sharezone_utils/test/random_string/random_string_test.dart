// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone_utils/random_string.dart';

void main() {
  test('randomString()', () {
    for (int i = 0; i < 50; i++) {
      expect(randomString(10), hasLength(10));
    }
  });

  test('randomIDString()', () {
    for (int i = 0; i < 50; i++) {
      expect(randomIDString(10), hasLength(10));
    }
  });
}
