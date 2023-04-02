// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

part 'text_theme.dart';
part 'topic.dart';

class PrivacyPolicy extends StatelessWidget {
  static const tag = "privacy-policy-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Datenschutzerkläung"), centerTitle: true),
      body: PrivacyPolicyContent(),
    );
  }
}

class PrivacyPolicyContent extends StatelessWidget {
  const PrivacyPolicyContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'privacy-policy-content',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SafeArea(
          child: MaxWidthConstraintBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Introduction(),
                _ContactInformation(),
                _ImportantTerms(),
                _WhichInformationAreCollected(),
                _WhoWillGetTheData(),
                _HowLongAreSavedTheData(),
                _WhichRightsDoYouHave(),
                _YouDidIt(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Introduction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _Topic(
      title: _Title("1. Einführung"),
      texts: <Widget>[
        SelectableText(
            "Hey! Das ist unsere Datenschutzerklärung! Bitte nimm dir die Zeit und lies dir die Datenschutzerklärung gründlich durch, damit du genau Bescheid weißt, was mit deinen persönlichen Daten passiert und wer auf diese Daten Zugriff hat.")
      ],
    );
  }
}

class _ContactInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _Topic(
      title: _Title("2. Kontaktinformationen"),
      texts: <Widget>[
        SelectableText("Hier findest du unsere Kontaktdaten:"),
        SizedBox(height: 10),
        SelectableText(
            "Sander, Jonas; Reichardt, Nils u. Weuthen, Felix “Sharezone” GbR\nBlücherstraße 34\n57072 Siegen\nDeutschland"),
        SizedBox(height: 10),
        SelectableText("E-Mail: support@sharezone.net"),
      ],
    );
  }
}

class _ImportantTerms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _Topic(
      title: _Title("3. Wichtige Begriffe, die du kennen solltest"),
      texts: <Widget>[
        SelectableText(
            "Unter diesem Link findest du offizielle Erklärung der Datenschutzerklärung (DSGVO) unter diesem "
            "Link (https://dejure.org/gesetze/DSGVO/4.html). Solltest du einmal ein Wort nicht verstehen, "
            "kannst du es unter diesem Link einfach nachlesen.")
      ],
    );
  }
}

class _WhichInformationAreCollected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _Topic(
      title: _Title("4. Welche Informationen erfassen wir grundsätzlich?"),
      texts: <Widget>[
        SelectableText(
            "Wir erklären dir nun, welche Daten von uns erfasst werden. Solltest du etwas nicht verstehen, dann schreibe einfach eine E-Mail an unseren Support. Wir werden dir schnellstmöglich antworten!\n\n"
            "Um unsere App zu benutzen, musst du dir ein Nutzerkonto anlegen. Dieses Nutzerkonto ist erforderlich, damit die Funktionen in der App, wie z.B. Hausaufgaben verwenden kannst. \n\n"
            "Wenn du ein neues Nutzerkonto erstellst, kannst du dies auf drei verschiedenen Wege machen."),
        SizedBox(height: 15),
        _Subtitle("1) Registrierung per E-Mail"),
        SelectableText(
          "Bei der Registrierung per E-Mail erheben wir folgende Daten:\n"
          "- Name (Der Name kann auch ein Pseudonym sein)\n"
          "- E-Mail\n"
          "- Bundesland (optional - es kann auch der Wert \"anonym bleiben\" ausgewählt haben\n"
          "- Art des Accounts (Schüler, Lehrkraft und Elternteil)",
        ),
        SizedBox(height: 15),
        _Subtitle("2) Registrierung via Google (Google Sign-In)"),
        SelectableText(
            "Bei der Registrierung via Google erheben wir folgende Daten:"),
        _Absatz(),
        SelectableText("""- Name & E-Mail deines Google Profils
- Bundesland (optional - es kann auch der Wert "anonym bleiben" ausgewählt werden)
- Art des Accounts (Schüler, Lehrkraft oder Elternteil"""),
        _Absatz(),
        SelectableText(
            "Bei der Registierung und der Verwendung unserer App muss die IP-Adresse von dir verarbeitet werden, um eine Verbindung zu den Firebase-Servern aufzubauen. Diese wird temporär gespeichert."),
        _Absatz(),
        SelectableText(
            "Weitere Informationen zu Google Sign-In und den Privatsphäre-Einstellungen findest du in den Datenschutzhinweisen (https://policies.google.com/privacy?hl=de&gl=de) und den Nutzungsbedingungen (https://policies.google.com/terms?hl=de&gl=de) der Google LLC."),
        SizedBox(height: 15),
        _Subtitle("3) Registrierung als anonymer User"),
        SelectableText("Bei der Registrierung erheben wir folgende Daten:"),
        _Absatz(),
        SelectableText(
            """- Bundesland (optional - es kann auch der Wert "anonym bleiben" ausgewählt werden)
- Art des Accounts (Schüler, Lehrkraft oder Elternteil)"""),
        _Absatz(),
        _Absatz(),
        SelectableText(
            "Wenn du ein Nutzerkonto erstellt hast, kannst du unsere App kostenlos benutzen. (Wenn du dich für die Rechtsgrundlage dazu interessierst, findest du das in der DSGVO unter Art. 6 Abs. 1 lit. a und Art. 6 Abs. 1 lit. b.)."),
        SizedBox(height: 20),
        _Subtitle("Warum erheben wir diesen Daten?"),
        SelectableText(
            "Nun, dein Name benötigen die anderen Nutzer in deinem Kurs, um dich zu identifizieren. Solltest du dich mit einem Anonymen User anmelden, wird dir ein zufälliger Tiername zugewiesen. Die E-Mail benötigst du, um dein Passwort zurückzusetzen (bei einer anonymen Registrierung nicht möglich). Hast du dies einmal vergessen, schicken wir an diese E-Mail einen Link, mit dem du dir ein neues Passwort setzen kannst."),
      ],
    );
  }
}

class _WhoWillGetTheData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _Topic(
      title: _Title("5. An wen geben wir deine Daten weiter?"),
      texts: <Widget>[
        SelectableText(
            "Wir geben deine Daten nur an einen einzigen externen Dienstleister (Google Firebase) weiter, den wir zur Speicherung der Daten brauchen. Google Firebase ermöglicht es uns sichere und einfache Anmeldevorgänge und Datenspeicherung vorzunehmen."),
        _Absatz(),
        SelectableText(
            "Bei Google Firebase verwenden wir folgende Dienste (+ Zertifizierung):"),
        SelectableText("""- Firebase Authentication (ISO 27001)
- Cloud Firestore (ISO 27018)
- Cloud Functions (ISO 27018)
- Firebase Cloud Messaging (ISO 27001)"""),
        _Absatz(),
        _Subtitle("Firebase Authentication:"),
        SelectableText(
            "Benötigt deine E-Mail Adresse, dein Passwort und deine IP-Adresse (für mehr Sicherheit). Die IP-Adresse bleibt für ein paar Wochen gespeichert. Speicherort: USA (Firebase ist nach dem EU-US Privacy Shield zertifiziert)"),
        _Absatz(),
        _Subtitle("Cloud Firestore:"),
        SelectableText(
            "Firestore ist unsere Datenbank, in der wir z.B. deinen Namen, deine Kurse und deine Hausaufgaben abspeichern. Der Speicherort von Firestore ist Frankfurt/Main (Deutschland)."),
        _Absatz(),
        _Subtitle("Cloud Functions:"),
        SelectableText(
            "Mit Cloud Funtioncs können wir Skripte auf dem Server ablaufen lassen. Dabei wird temporär deine IP-Adresse gespeichert. Der Speicherort der Cloud Functions ist ebenfalls Frankfurt/Main (Deutschland)."),
        _Absatz(),
        _Subtitle("Firebase Cloud Messaging"),
        SelectableText(
            "Damit wir dich über wichtige Neuigkeiten und offene Hausaufgaben erinnern können, verwenden wir von Firebase den Dienst Firebase Messaging. Dabei wird temporär die Instance ID (https://developers.google.com/instance-id/) verarbeitet. Die Instance ID wird dazu verwendet, um einen speziellen Gerät eine Push-Notification zu schicken. So werden nur an deine Geräte auch deine Notifications geschickt."),
        _Absatz(),
        _Absatz(),
        SelectableText(
            "Weitere Informationen findest du in der Datenschutzerklärung von Google Firebase: https://firebase.google.com/support/privacy/"),
      ],
    );
  }
}

class _HowLongAreSavedTheData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Topic(
      title: _Title("6. Wie lange speichern wir deine Daten?"),
      texts: const <Widget>[
        SelectableText(
            "Die Dauer der Speicherung von personenbezogenen Daten bemisst sich anhand der gesetzlichen Aufbewahrungsrechte und -Pflichten (z.B. aus dem Handels- oder Steuerrecht). Läuft die Frist ab, werden die Daten bis zum Ende des Monats gelöscht, sofern sie nicht für die Anbahnung, Durchführung und Beendigung eines Vertrags erforderlich sind und/oder kein berechtigtes Interesse unsererseits an der Verarbeitung besteht."),
      ],
    );
  }
}

class _WhichRightsDoYouHave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _Topic(
      title: _Title("7. Welche Rechte hast du?"),
      texts: <Widget>[
        SelectableText(
            "Die Dauer der Speicherung von personenbezogenen Daten bemisst sich anhand der gesetzlichen Aufbewahrungsrechte und -Pflichten (z.B. aus dem Handels- oder Steuerrecht). Läuft die Frist ab, werden die Daten bis zum Ende des Monats gelöscht, sofern sie nicht für die Anbahnung, Durchführung und Beendigung eines Vertrags erforderlich sind und/oder kein berechtigtes Interesse unsererseits an der Verarbeitung besteht."),
        _Absatz(),
        SelectableText(
            """1) Das Recht, gemäß Art. 15 DSGVO Auskunft über deine von uns verarbeiteten personenbezogenen Daten zu verlangen. Insbesondere kannst du Auskunft über die Verarbeitungszwecke, die Kategorie der personenbezogenen Daten, die Kategorien von Empfängern, gegenüber denen deine Daten offengelegt wurden oder werden, die geplante Speicherdauer, das Bestehen eines Rechts auf Berichtigung, Löschung, Einschränkung der Verarbeitung oder Widerspruch, das Bestehen eines Beschwerderechts, die Herkunft deiner Daten, sofern diese nicht bei uns erhoben wurden, sowie über das Bestehen einer automatisierten Entscheidungsfindung einschließlich Profiling und ggf. aussagekräftigen Informationen zu deren Einzelheiten verlangen.
2) Das Recht, gemäß Art. 16 DSGVO unverzüglich die Berichtigung unrichtiger oder Vervollständigung deiner bei uns gespeicherten personenbezogenen Daten zu verlangen.
3) Das Recht, gemäß Art. 17 DSGVO die Löschung deiner bei uns gespeicherten personenbezogenen Daten zu verlangen, soweit nicht die Verarbeitung zur Ausübung des Rechts auf freie Meinungsäußerung und Information, zur Erfüllung einer rechtlichen Verpflichtung, aus Gründen des öffentlichen Interesses oder zur Geltendmachung, Ausübung oder Verteidigung von Rechtsansprüchen erforderlich ist.
4) Das Recht, gemäß Art. 18 DSGVO die Einschränkung der Verarbeitung deiner personenbezogenen Daten zu verlangen, soweit die Richtigkeit der Daten von dir bestritten wird, die Verarbeitung unrechtmäßig ist, du aber deren Löschung ablehnst und wir die Daten nicht mehr benötigen, du jedoch diese zur Geltendmachung, Ausübung oder Verteidigung von Rechtsansprüchen benötigst oder du gemäß Art. 21 DSGVO Widerspruch gegen die Verarbeitung eingelegt hast.
5) Das Recht, gemäß Art. 20 DSGVO deine personenbezogenen Daten, die du uns bereitgestellt hast, in einem strukturierten, gängigen und maschinenlesebaren Format zu erhalten oder die Übermittlung an einen anderen Verantwortlichen zu verlangen.
6) Das Recht, sich gemäß Art. 77 DSGVO bei einer Aufsichtsbehörde zu beschweren. In der Regel kannst du dich hierfür an die Aufsichtsbehörde des Bundeslandes unseres oben angegebenen Sitzes oder ggf. die deines üblichen Aufenthaltsortes oder Arbeitsplatzes wenden.""")
      ],
    );
  }
}

class _YouDidIt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _Topic(
      title: _Title("Glückwunsch, du hast es geschafft"),
      texts: <Widget>[
        SelectableText(
            "Sehr gut! Du hast unsere Datenschutzerklärung nun durchgelesen, wodurch du bestens informiert bist, wie wir deine Daten speichern, an wen wir diese weitergeben, wie lange wir deine Daten speichern und vieles mehr."),
        _Absatz(),
        SelectableText(
            "Sollten immer noch irgendwelche Fragen aufkommen, dann schreib uns einfach eine E-Mail an: support@sharezone.net"),
        _Absatz(),
        SelectableText("Beste Grüße,\nDein Sharezone-Team"),
      ],
    );
  }
}

class _Absatz extends StatelessWidget {
  const _Absatz();
  @override
  Widget build(BuildContext context) => const SizedBox(height: 6);
}
