// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:legal/legal.dart';
import 'package:legal/src/privacy_policy/src/privacy_policy_src.dart';

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
    test('toc real life example', () {
      final sections = [
        'Vorbemerkungen / Geltungsbereich',
        'Nutzungsvoraussetzungen',
        'Angebotene Funktionen',
        'Registrierung / Zustandekommen des Nutzungsvertrags',
        'Sharezone Plus',
        'Nutzungsrechte',
        'Veröffentlichen von Inhalten',
        'Verfügbarkeit der Plattform',
        'Pflichten der Nutzer / Nutzerverhalten',
        'Verantwortlichkeit für Inhalte der Nutzer',
        'Haftung / Freistellungsanspruch',
        'Beendigung des Nutzungsvertrags / Kündigung',
        'Änderungen der Allgemeinen Nutzungsbedingungen',
        'Datenschutz',
        'Schlussbestimmungen',
      ];

      final anchorHashes = sections.map(generateAnchorHash).toList();

      expect(anchorHashes, [
        'vorbemerkungen--geltungsbereich',
        'nutzungsvoraussetzungen',
        'angebotene-funktionen',
        'registrierung--zustandekommen-des-nutzungsvertrags',
        'sharezone-plus',
        'nutzungsrechte',
        'veroeffentlichen-von-inhalten',
        'verfuegbarkeit-der-plattform',
        'pflichten-der-nutzer--nutzerverhalten',
        'verantwortlichkeit-fuer-inhalte-der-nutzer',
        'haftung--freistellungsanspruch',
        'beendigung-des-nutzungsvertrags--kuendigung',
        'aenderungen-der-allgemeinen-nutzungsbedingungen',
        'datenschutz',
        'schlussbestimmungen'
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

    void expectCorrectAnchorHashes(PrivacyPolicy privacyPolicy) {
      expect(
          privacyPolicy.tableOfContentSections.where((section) => section
              .subsections
              .where((subsubsection) => subsubsection.subsections.isNotEmpty)
              .isNotEmpty),
          isEmpty,
          reason:
              'Table of contents subscections must not have subscections. E.g. Section "foo" can have subsection "bar" but "bar" must not have subsections.');

      final actualAnchorHashes = privacyPolicy.tableOfContentSections
          .expand((section) => [
                section.id.id,
                ...section.subsections.map((subsection) => subsection.id.id)
              ])
          .toList();
      final expectedAnchorHashes = privacyPolicy.tableOfContentSections
          .expand((section) => [
                generateAnchorHash(section.sectionName),
                ...section.subsections.map(
                    (subsection) => generateAnchorHash(subsection.sectionName))
              ])
          .toList();

      expect(actualAnchorHashes, expectedAnchorHashes);
    }

    test('privacy policy v1 anchors are correct', () {
      expectCorrectAnchorHashes(v1PrivacyPolicy);
    });
    test('privacy policy v2 anchors are correct', () {
      expectCorrectAnchorHashes(v2PrivacyPolicy);
    });

    test('terms of service v1 anchor hashes are correct', () {
      expectCorrectAnchorHashes(termsOfServicePolicy);
    });
  });
}
