// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:test/test.dart';

void main() {
  group('tryGet', () {
    test('Int works', () {
      expect(
          InMemoryKeyValueStore({'foo': 'Not an int'}).tryGetInt('foo'), null);
    });
  });
}
