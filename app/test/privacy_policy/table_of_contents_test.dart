import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/onboarding/sign_up/pages/new_privacy_policy_page.dart';

void main() {
  group('the table of contents', () {
    test(
        'doesnt mark ayn section as active if none are or have been visible on the page',
        () {
      final sections = [
        DocumentSection('inhaltsverzeichnis', 'Inhaltsverzeichnis', []),
        DocumentSection('1-wichtige-begriffe', '1. Wichtige Begriffe', []),
        DocumentSection('2-geltungsbereich', '2. Geltungsbereich', []),
      ];

      final visibleSections = ValueNotifier<List<DocumentSectionPosition>>([]);

      final controller = ActiveSectionController(sections, visibleSections);

      expect(controller.currentActiveSectionOrNull.value, null);
    });

    test('marks the first section as active when it is visible', () {
      final sections = [
        DocumentSection('inhaltsverzeichnis', 'Inhaltsverzeichnis', []),
        DocumentSection('1-wichtige-begriffe', '1. Wichtige Begriffe', []),
        DocumentSection('2-geltungsbereich', '2. Geltungsbereich', []),
      ];

      final visibleSections = ValueNotifier<List<DocumentSectionPosition>>([]);

      final controller = ActiveSectionController(sections, visibleSections);

      visibleSections.value = [
        DocumentSectionPosition(
          DocumentSection('inhaltsverzeichnis', 'Inhaltsverzeichnis', []),
          itemLeadingEdge: 0.1,
          itemTrailingEdge: 0.15,
        ),
      ];

      expect(controller.currentActiveSectionOrNull.value,
          DocumentSectionId('inhaltsverzeichnis'));
    });

    test(
        'if currently visible sections go from some to none then it returns the section that comes before the current position inside the document',
        () {
      // TODO: Edge case: Scroll up from first section so that the first
      // section is not visible anymore
      // Scroll down from the last section so that the last section is not visible
      // anymore
      final sections = [
        DocumentSection('inhaltsverzeichnis', 'Inhaltsverzeichnis', []),
        DocumentSection('1-wichtige-begriffe', '1. Wichtige Begriffe', []),
        DocumentSection('2-geltungsbereich', '2. Geltungsbereich', []),
      ];

      final visibleSections = ValueNotifier<List<DocumentSectionPosition>>([]);

      final controller = ActiveSectionController(sections, visibleSections);

      visibleSections.value = [
        DocumentSectionPosition(
          DocumentSection('inhaltsverzeichnis', 'Inhaltsverzeichnis', []),
          itemLeadingEdge: 0.1,
          itemTrailingEdge: 0.15,
        ),
      ];

      visibleSections.value = [];

      expect(controller.currentActiveSectionOrNull.value,
          DocumentSectionId('inhaltsverzeichnis'));
    });
  });
}

final tocDocumentSections = [
  DocumentSection('inhaltsverzeichnis', 'Inhaltsverzeichnis', []),
  DocumentSection('1-wichtige-begriffe', '1. Wichtige Begriffe', []),
  DocumentSection('2-geltungsbereich', '2. Geltungsbereich', []),
  DocumentSection('3-verantwortlichkeit-und-kontakt',
      '3. Verantwortlichkeit und Kontakt', []),
  DocumentSection(
      '4-hosting-backend-infrastruktur-und-speicherort-fr-eure-daten',
      '4. Hosting, Backend-Infrastruktur und Speicherort für eure Daten', []),
  DocumentSection('5-deine-rechte', '5. Deine Rechte', [
    DocumentSection('a-recht-auf-auskunft', 'a. Recht auf Auskunft', []),
    DocumentSection(
        'b-recht-auf-berichtigung', 'b. Recht auf Berichtigung', []),
    DocumentSection('c-recht-auf-lschung', 'c. Recht auf Löschung', []),
    DocumentSection('d-recht-auf-einschrnkung-der-verarbeitung',
        'd. Recht auf Einschränkung der Verarbeitung', []),
    DocumentSection('e-recht-auf-widerspruch', 'e. Recht auf Widerspruch', []),
    DocumentSection('f-recht-auf-widerruf', 'f. Recht auf Widerruf', []),
    DocumentSection('g-recht-auf-datenbertragbarkeit',
        'g. Recht auf Datenübertragbarkeit', []),
    DocumentSection('h-recht-auf-beschwerde', 'h. Recht auf Beschwerde', []),
  ]),
  DocumentSection('6-eure-kontaktaufnahme', '6. Eure Kontaktaufnahme', []),
  DocumentSection(
      '7-unser-umgang-mit-euren-daten', '7. Unser Umgang mit euren Daten', []),
  DocumentSection(
      '8-account-nickname-und-passwort', '8. Account, Nickname und Passwort', [
    DocumentSection('a-registrierung-mittels-anonymen-accounts',
        'a. Registrierung mittels anonymen Accounts', []),
    DocumentSection(
        'b-registrierung-mit-e-mail-adresse--passwort-oder-googleapple-sign-in-ab-einem-alter-von-16-jahren-und-lter',
        'b. Registrierung mit E-Mail-Adresse & Passwort oder Google/Apple Sign In ab einem Alter von 16 Jahren und älter',
        []),
  ]),
  DocumentSection(
      '9-verarbeitung-der-ip-adresse', '9. Verarbeitung der IP-Adresse', []),
  DocumentSection('10-speicherdauer-und-speicherfristen',
      '10. Speicherdauer und Speicherfristen', []),
  DocumentSection(
      '11-verarbeitung-des-gewhlten-account-typs-und-des-bundeslandes',
      '11. Verarbeitung des gewählten Account-Typs und des Bundeslandes', []),
  DocumentSection('12-anonyme-statistische-auswertung-der-app-nutzung',
      '12. Anonyme statistische Auswertung der App-Nutzung', []),
  DocumentSection('13-push-nachrichten', '13. Push-Nachrichten', []),
  DocumentSection('14-instance-id', '14. Instance ID', [
    DocumentSection('firebase-cloud-messaging', 'Firebase Cloud Messaging', []),
    DocumentSection('firebase-crashlytics', 'Firebase Crashlytics', []),
    DocumentSection('firebase-performance-monitoring',
        'Firebase Performance Monitoring', []),
    DocumentSection('firebase-predictions', 'Firebase Predictions', []),
    DocumentSection('firebase-remote-config', 'Firebase Remote Config', []),
    DocumentSection(
        'googlefirebase-analytics', 'Google/Firebase Analytics', []),
  ]),
  DocumentSection('15-empfnger-oder-kategorien-von-empfngern',
      '15. Empfänger oder Kategorien von Empfängern', []),
  DocumentSection(
      '16-ssltls-verschlsselung', '16. SSL/TLS-Verschlüsselung', []),
  DocumentSection('17-videokonferenzen', '17. Videokonferenzen', []),
  DocumentSection('18-datenbertragung-in-drittlnder-auerhalb-der-eu',
      '18. Datenübertragung in Drittländer außerhalb der EU', [
    DocumentSection(
        'a-firebase-authentication', 'a. Firebase Authentication', []),
    DocumentSection('b-firebase-hosting', 'b. Firebase Hosting', []),
  ]),
  DocumentSection(
      '19-datenschutzbeauftragter', '19. Datenschutzbeauftragter', []),
  DocumentSection('20-vorbehalt-der-nderung-dieser-informationen',
      '20. Vorbehalt der Änderung dieser Informationen', []),
];
