// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/privacy_policy/src/privacy_policy_src.dart';

void main() {
  /// We are testing this since changing the anchor hash generation algorithm
  /// might break stuff. See comments in [generateAnchorHash] file.
  group('Generates correct anchor hashes', () {
    test('real life examples', () {
      final sections = [
        '1. Einführung',
        '2. Kontaktinformationen',
        '3. Wichtige Begriffe, die du kennen solltest',
        '4. Welche Informationen erfassen wir grundsätzlich?',
        '5. An wen geben wir deine Daten weiter?',
        '6. Wie lange speichern wir deine Daten?',
        '7. Welche Rechte hast du?',
        'Glückwunsch, du hast es geschafft',
      ];

      final anchorHashes = sections.map(generateAnchorHash).toList();

      expect(anchorHashes, [
        '1-einfuehrung',
        '2-kontaktinformationen',
        '3-wichtige-begriffe-die-du-kennen-solltest',
        '4-welche-informationen-erfassen-wir-grundsaetzlich',
        '5-an-wen-geben-wir-deine-daten-weiter',
        '6-wie-lange-speichern-wir-deine-daten',
        '7-welche-rechte-hast-du',
        'glueckwunsch-du-hast-es-geschafft',
      ]);
    });
    test('replaces special chars', () {
      final sections = [
        r'1-?!=""§$pokémon~+',
        'Ist das eine Frage???',
        'Wort-mit-Bindestrichen'
      ];

      final anchorHashes = sections.map(generateAnchorHash).toList();

      expect(anchorHashes, [
        '1-pokemon',
        'ist-das-eine-frage',
        'wort-mit-bindestrichen',
      ]);
    });

    test('replaces umlaute', () {
      final umlaute = [
        'ä',
        'Ä',
        'ö',
        'Ö',
        'ü',
        'Ü',
        'ß',
      ];

      final anchorHashes = umlaute.map(generateAnchorHash).toList();

      expect(anchorHashes, [
        'ae',
        'ae',
        'oe',
        'oe',
        'ue',
        'ue',
        'ss',
      ]);
    });
  });
}
