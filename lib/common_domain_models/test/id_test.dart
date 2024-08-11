// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group(Id, () {
    group('.generate()', () {
      test('should generate a new id', () {
        final random = Random(42);

        // Generating multiple ids to make sure we don't get a 'Index out of
        // range' error.
        for (var i = 0; i < 100; i++) {
          final id = Id.generate(random: random);
          expect(id.value.length, 20);
        }
      });
    });
  });
}
