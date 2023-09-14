// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';

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
  /// Telefon: +49 1516 7754541
  /// E-Mail: support@sharezone.net
  final String asMarkdown;

  const Imprint._(this.asMarkdown);

  factory Imprint.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final markdownData = snapshot.data()?['markdownData'] as String;
    return Imprint._(markdownData);
  }

  factory Imprint.offline() {
    return const Imprint._("""### **Angaben gemäß § 5 TMG:**

Sander, Jonas; Reichardt, Nils u. Weuthen, Felix “Sharezone” GbR
Blücherstraße 34
57072 Siegen

### **Vertreten durch:**

Nils Reichardt

### **Kontakt:**

Telefon: +49 1516 7754541
E-Mail: support@sharezone.net""");
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
