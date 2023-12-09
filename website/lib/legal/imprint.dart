// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

class Imprint {
  /// Impressum wird als Markdown-String übergeben. Beispiel:
  ///
  /// **Angaben gemäß § 5 TMG:**
  ///
  /// Sander, Jonas; Reichardt, Nils u. Weuthen, Felix “Sharezone” GbR
  /// Blücherstraße 34
  /// 57072 Siegen
  ///
  /// **Vertreten durch:**
  /// Nils Reichardt
  ///
  /// **Kontakt:**
  /// Telefon: +49 15678 612205
  /// E-Mail: support@sharezone.net
  final String asMarkdown;

  const Imprint._(this.asMarkdown);

  factory Imprint.offline() {
    return const Imprint._("""## Informationen nach § 5 TMG

Sharezone UG (haftungsbeschränkt)
Speditionstr. 15A
40221 Düsseldorf

### Geschäftsführer and redaktionell Verantwortlicher:
Nils Reichardt & Jonas Sander

### Handelsregister
Registergericht: Amtsgericht Düsseldorf
Registernummer: HRB 91086

### Kontakt:
Mobil: +49 1522 9504121
E-Mail: support@sharezone.net

### Umsatzsteuer-ID:

Umsatzsteuer-Identifikationsnummer gemäß §27a Umsatzsteuergesetz: DE338063943
""");
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Imprint && other.asMarkdown == asMarkdown;
  }

  @override
  int get hashCode => asMarkdown.hashCode;

  @override
  String toString() => 'Imprint(asMarkdown: $asMarkdown)';
}
