// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:user/user.dart';

void main() {
  group('Holiday state mapping', () {
    test('holidayStatesByCountry is complete and consistent', () {
      final mappedStates = holidayStatesByCountry.values
          .expand((states) => states)
          .toList();

      expect(mappedStates.toSet().length, mappedStates.length);

      final statesWithCountry = StateEnum.values
          .where((state) => state.country != null)
          .toSet();
      expect(mappedStates.toSet(), statesWithCountry);
    });

    test('non-holiday states do not have a country', () {
      expect(StateEnum.notFromGermany.country, isNull);
      expect(StateEnum.anonymous.country, isNull);
      expect(StateEnum.notSelected.country, isNull);
    });
  });
}
