// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/holidays/holiday_bloc.dart';
import 'package:user/user.dart';

void main() {
  group('toStateOrThrow', () {
    test('supports every state that maps to a country', () {
      final supportedStates = StateEnum.values
          .where((state) => state.country != null)
          .toList();

      for (final state in supportedStates) {
        expect(
          () => toStateOrThrow(state),
          returnsNormally,
          reason: 'Expected $state to be supported',
        );
      }
    });

    test('throws for unsupported states', () {
      expect(
        () => toStateOrThrow(StateEnum.notFromGermany),
        throwsA(isA<UnsupportedStateException>()),
      );
      expect(
        () => toStateOrThrow(StateEnum.anonymous),
        throwsA(isA<UnsupportedStateException>()),
      );
      expect(
        () => toStateOrThrow(StateEnum.notSelected),
        throwsA(isA<UnsupportedStateException>()),
      );
    });
  });
}
