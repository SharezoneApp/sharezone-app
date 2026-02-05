// Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:date/date.dart';
import 'package:test/test.dart';

void main() {
  group(Date, () {
    test('compareTo', () {
      final date = Date('2025-10-11');
      final sameDate = Date('2025-10-11');
      final nextDate = date.addDays(1);

      expect(date.compareTo(nextDate), isNegative);
      expect(nextDate.compareTo(date), isPositive);
      expect(date.compareTo(sameDate), isZero);
    });
  });
}
