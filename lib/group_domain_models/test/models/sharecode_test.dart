// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:test/test.dart';
import 'package:group_domain_models/group_domain_models.dart';

void main() {
  group('sharecode', () {
    void testSharecode(String sharecode, bool expactedValue) {
      expect(Sharecode.isValid(sharecode), expactedValue);
    }

    final validSharecode1 = "000000";
    final validSharecode2 = "AdB23c";
    final validSharecode3 = "123a4v";

    final invalidSharecode1 = null;
    final invalidSharecode2 = "";
    final invalidSharecode3 = "1234567";
    final invalidSharecode4 = "12345_";
    final invalidSharecode5 = "_";
    final invalidSharecode6 = "234_";
    final invalidSharecode7 = "hh";

    test('validation (RegEx)', () {
      testSharecode(validSharecode1, true);
      testSharecode(validSharecode2, true);
      testSharecode(validSharecode3, true);
      testSharecode(invalidSharecode1, false);
      testSharecode(invalidSharecode2, false);
      testSharecode(invalidSharecode3, false);
      testSharecode(invalidSharecode4, false);
      testSharecode(invalidSharecode5, false);
      testSharecode(invalidSharecode6, false);
      testSharecode(invalidSharecode7, false);
    });
  });
}
