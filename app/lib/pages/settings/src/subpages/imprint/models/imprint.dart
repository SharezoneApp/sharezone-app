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

  factory Imprint.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final markdownData = snapshot.data()['markdownData'];
    return Imprint._(markdownData);
  }

  factory Imprint.offline() {
    return Imprint._("""### **Angaben gemäß § 5 TMG:**

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
