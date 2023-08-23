// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/models/subject.dart';
import 'package:hausaufgabenheft_logik/src/views/color.dart';
import 'package:test/test.dart';

void main() {
  group('Subject', () {
    Subject createValidSubjectWith({Color? color}) {
      return Subject('SomeSubjectName', color: color);
    }

    test('A Subject cant be constructed with an empty subject name', () {
      expect(() => Subject(''), throwsArgumentError);
    });
    test(
        'generates an own subject abreviation from the given subject if no abbreviation is specified',
        () {
      expect(Subject('Mathematik').abbreviation, 'Ma');
    });
    test(
        'If the subject name is shorter than two characters it uses the subject name as an abbreviation',
        () {
      expect(Subject('M').abbreviation, 'M');
    });
    test('has no color of not given', () {
      final subject = createValidSubjectWith(color: null);
      expect(subject.color, isNull);
    });
    test('sets the optional color to the given color', () {
      final subject = createValidSubjectWith(color: const Color(1337));
      expect(subject.color, const Color(1337));
    });
  });
}
