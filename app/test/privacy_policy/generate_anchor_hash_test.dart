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
  test('Generates correct anchor hashes', () {
    final sections = [
      '1. Einführung',
      '2. Kontaktinformationen',
      '3. Wichtige Begriffe, die du kennen solltest',
      '4. Welche Informationen erfassen wir grundsätzlich?',
      '5. An wen geben wir deine Daten weiter?',
      '6. Wie lange speichern wir deine Daten?',
      '7. Welche Rechte hast du?',
      'Glückwunsch, du hast es geschafft'
    ];

    final anchorHashes = sections.map(generateAnchorHash).toList();

    expect(anchorHashes, [
      '1-einfhrung',
      '2-kontaktinformationen',
      '3-wichtige-begriffe-die-du-kennen-solltest',
      '4-welche-informationen-erfassen-wir-grundstzlich',
      '5-an-wen-geben-wir-deine-daten-weiter',
      '6-wie-lange-speichern-wir-deine-daten',
      '7-welche-rechte-hast-du',
      'glckwunsch-du-hast-es-geschafft',
    ]);
  });
}
