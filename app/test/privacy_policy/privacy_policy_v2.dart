// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:sharezone/legal/privacy_policy/src/privacy_policy_src.dart';

final v2PrivacyPolicy = PrivacyPolicy(
  markdownText: markdownPrivacyPolicy,
  tableOfContentSections: tocDocumentSections.toIList(),
  version: '2.0.0',
  downloadUrl: Uri.parse('https://sharezone.net/dse-v2-0-0-pdf'),
  lastChanged: DateTime(2022, 11, 10),
  entersIntoForceOnOrNull: DateTime(2023, 01, 20),
);

final tocDocumentSections = [
  _section('inhaltsverzeichnis', 'Inhaltsverzeichnis'),
  _section('1-wichtige-begriffe', '1. Wichtige Begriffe'),
  _section('2-geltungsbereich', '2. Geltungsbereich'),
  _section(
      '3-verantwortlichkeit-und-kontakt', '3. Verantwortlichkeit und Kontakt'),
  _section('4-hosting-backend-infrastruktur-und-speicherort-fr-eure-daten',
      '4. Hosting, Backend-Infrastruktur und Speicherort für eure Daten'),
  _section(
    '5-deine-rechte',
    '5. Deine Rechte',
    [
      _section('a-recht-auf-auskunft', 'a. Recht auf Auskunft'),
      _section('b-recht-auf-berichtigung', 'b. Recht auf Berichtigung'),
      _section('c-recht-auf-lschung', 'c. Recht auf Löschung'),
      _section('d-recht-auf-einschrnkung-der-verarbeitung',
          'd. Recht auf Einschränkung der Verarbeitung'),
      _section('e-recht-auf-widerspruch', 'e. Recht auf Widerspruch'),
      _section('f-recht-auf-widerruf', 'f. Recht auf Widerruf'),
      _section('g-recht-auf-datenbertragbarkeit',
          'g. Recht auf Datenübertragbarkeit'),
      _section('h-recht-auf-beschwerde', 'h. Recht auf Beschwerde'),
    ],
  ),
  _section('6-eure-kontaktaufnahme', '6. Eure Kontaktaufnahme'),
  _section('7-unser-umgang-mit-euren-daten', '7. Unser Umgang mit euren Daten'),
  _section(
    '8-account-nickname-und-passwort',
    '8. Account, Nickname und Passwort',
    [
      _section('a-registrierung-mittels-anonymen-accounts',
          'a. Registrierung mittels anonymen Accounts'),
      _section(
          'b-registrierung-mit-e-mail-adresse--passwort-oder-googleapple-sign-in-ab-einem-alter-von-16-jahren-und-lter',
          'b. Registrierung mit E-Mail-Adresse & Passwort oder Google/Apple Sign In ab einem Alter von 16 Jahren und älter'),
    ],
  ),
  _section('9-verarbeitung-der-ip-adresse', '9. Verarbeitung der IP-Adresse'),
  _section('10-speicherdauer-und-speicherfristen',
      '10. Speicherdauer und Speicherfristen'),
  _section('11-verarbeitung-des-gewhlten-account-typs-und-des-bundeslandes',
      '11. Verarbeitung des gewählten Account-Typs und des Bundeslandes'),
  _section('12-anonyme-statistische-auswertung-der-app-nutzung',
      '12. Anonyme statistische Auswertung der App-Nutzung'),
  _section('13-push-nachrichten', '13. Push-Nachrichten'),
  _section(
    '14-instance-id',
    '14. Instance ID',
    [
      _section('firebase-cloud-messaging', 'Firebase Cloud Messaging'),
      _section('firebase-crashlytics', 'Firebase Crashlytics'),
      _section(
          'firebase-performance-monitoring', 'Firebase Performance Monitoring'),
      _section('firebase-predictions', 'Firebase Predictions'),
      _section('firebase-remote-config', 'Firebase Remote Config'),
      _section('googlefirebase-analytics', 'Google/Firebase Analytics'),
    ],
  ),
  _section('15-empfnger-oder-kategorien-von-empfngern',
      '15. Empfänger oder Kategorien von Empfängern'),
  _section('16-ssltls-verschlsselung', '16. SSL/TLS-Verschlüsselung'),
  _section('17-videokonferenzen', '17. Videokonferenzen'),
  _section(
    '18-datenbertragung-in-drittlnder-auerhalb-der-eu',
    '18. Datenübertragung in Drittländer außerhalb der EU',
    [
      _section('a-firebase-authentication', 'a. Firebase Authentication'),
      _section('b-firebase-hosting', 'b. Firebase Hosting'),
    ],
  ),
  _section('19-datenschutzbeauftragter', '19. Datenschutzbeauftragter'),
  _section('20-vorbehalt-der-nderung-dieser-informationen',
      '20. Vorbehalt der Änderung dieser Informationen'),
];

DocumentSection _section(
  String id,
  String name, [
  List<DocumentSection> subsections = const [],
]) =>
    DocumentSection(DocumentSectionId(id), name, subsections.toIList());

const tableOfContentStrings = [
  "Einführung",
  "1. Wichtige Begriffe",
  "2. Geltungsbereich",
  "3. Verantwortlichkeit und Kontakt",
  "4. Hosting, Backend-Infrastruktur und Speicherort für eure Daten",
  "5. Deine Rechte",
  "6. Eure Kontaktaufnahme",
  "7. Unser Umgang mit euren Daten",
  "8. Account, Nickname und Passwort",
  "9. Verarbeitung der IP-Adresse",
  "10. Speicherdauer und Speicherfristen",
  "11. Verarbeitung des gewählten Account-Typs und des Bundeslandes",
  "12. Anonyme statistische Auswertung der App-Nutzung",
  "13. Push-Nachrichten",
  "14. Instance ID",
  "15. Empfänger oder Kategorien von Empfängern",
  "16. SSL/TLS-Verschlüsselung",
  "17. Videokonferenzen",
  "18. Datenübertragung in Drittländer außerhalb der EU",
  "19. Datenschutzbeauftragter",
  "20. Vorbehalt der Änderung dieser Informationen",
];

const markdownPrivacyPolicy = """
# Information über die Verarbeitung personenbezogener Daten

Hey, du bzw. ihr! Das ist die Datenschutzerklärung unserer App „Sharezone“ (kurz: „App“). Im Folgenden informieren wir, die Sharezone UG (haftungsbeschränkt), Speditionstraße 15A, 40221 Düsseldorf, Deutschland (kurz: „Sharezone“, „wir“ oder „uns“), über die Erhebung personenbezogener Daten bei der Nutzung der App.

> Um diese Informationen über die Datenverarbeitung verständlicher zu gestalten, bieten wir euch an einigen komplizierten Stellen in den hervorgehobenen Textfeldern vereinfachte Zusammenfassungen (kurz: „Einfach gesagt:“) des jeweiligen Abschnitts an.
Auch wenn wir euch die Zusammenfassung anbieten, ist es wichtig und erforderlich, dass ihr die allein maßgeblich geltenden „Informationen über die Verarbeitung personenbezogener Daten“ gänzlich lest.

Nachfolgend findet ihr eine Übersicht des Inhalts. Durch einen Klick auf eine bestimmte Überschrift landet ihr direkt bei der betreffenden Stelle.

## Inhaltsverzeichnis

* [Inhaltsverzeichnis](#inhaltsverzeichnis)
* [1. Wichtige Begriffe](#1-wichtige-begriffe)
* [2. Geltungsbereich](#2-geltungsbereich)
* [3. Verantwortlichkeit und Kontakt](#3-verantwortlichkeit-und-kontakt)
* [4. Hosting, Backend-Infrastruktur und Speicherort für eure Daten](#4-hosting-backend-infrastruktur-und-speicherort-fr-eure-daten)
* [5. Deine Rechte](#5-deine-rechte)
* [6. Eure Kontaktaufnahme](#6-eure-kontaktaufnahme)
* [7. Unser Umgang mit euren Daten](#7-unser-umgang-mit-euren-daten)
* [8. Account, Nickname und Passwort](#8-account-nickname-und-passwort)
* [9. Verarbeitung der IP-Adresse](#9-verarbeitung-der-ip-adresse)
* [10. Speicherdauer und Speicherfristen](#10-speicherdauer-und-speicherfristen)
* [11. Verarbeitung des gewählten Account-Typs und des Bundeslandes](#11-verarbeitung-des-gewhlten-account-typs-und-des-bundeslandes)
* [12. Anonyme statistische Auswertung der App-Nutzung](#12-anonyme-statistische-auswertung-der-app-nutzung)
* [13. Push-Nachrichten](#13-push-nachrichten)
* [14. Instance ID](#14-instance-id)
* [15. Empfänger oder Kategorien von Empfängern](#15-empfnger-oder-kategorien-von-empfngern)
* [16. SSL/TLS-Verschlüsselung](#16-ssltls-verschlsselung)
* [17. Videokonferenzen](#17-videokonferenzen)
* [18. Datenübertragung in Drittländer außerhalb der EU](#18-datenbertragung-in-drittlnder-auerhalb-der-eu)
* [19. Datenschutzbeauftragter](#19-datenschutzbeauftragter)
* [20. Vorbehalt der Änderung dieser Informationen](#20-vorbehalt-der-nderung-dieser-informationen)

## 1. Wichtige Begriffe

Unter dem nachfolgenden Link findest du die offizielle Erläuterung von wichtigen Begriffen aus der Datenschutz-Grundverordnung (kurz: „DSGVO“), von denen wir auch einige in dieser Information verwenden. Bitte klickt diesen und etwa weiter angegebene Links in dieser Information nur an, wenn ihr mit dem Öffnen dieser fremden Seiten von dritten Anbietern und deren Datenverarbeitung und Datenschutzerklärung einverstanden seid:

[DSGVO Art. 4 "Begriffsbestimmungen" (dejure.org)](https://dejure.org/gesetze/DSGVO/4.html)

Solltest du einmal ein Wort (z.B. “verarbeiten“, “personenbezogenen Daten“ etc.) nicht verstehen, ist es gegebenenfalls unter dem genannten Link erläutert.

## 2. Geltungsbereich

Diese Datenschutzerklärung gilt für diese App „Sharezone“ und für die über diese App verarbeiteten personenbezogenen Daten.

Für Anwendungen und Internetseiten anderer Anbieter, auf die gegebenenfalls z.B. - wie in Ziffer 1. dieser Erklärung - über Links verwiesen wird, gelten allein die dortigen Datenschutzhinweise und /–erklärungen. Bitte öffnet diese Inhalte von anderen dritten Anbietern nur, wenn ihr mit dem Öffnen dieser fremden Inhalte von Dritten und deren Datenverarbeitung und Datenschutzerklärung einverstanden seid.

## 3. Verantwortlichkeit und Kontakt

Verantwortlicher für die Verarbeitung personenbezogener Daten dieser App im Sinne der DSGVO ist:

Sharezone UG (haftungsbeschränkt)
Speditionstraße 15A
40221 Düsseldorf

nachfolgend kurz: „wir“, „uns“ oder „Sharezone“

Geschäftsführer: Jonas Sander und Nils Reichardt

E-Mail: support@sharezone.net

## 4. Hosting, Backend-Infrastruktur und Speicherort für eure Daten

Unsere App wird in der Google Cloud Plattform (mit der Region des Rechenzentrums Frankfurt am Main und Belgien) von Google LLC (nachfolgend: “Google“), 1600 Amphitheatre Parkway, Mountain View, California 94043 USA, in unserem Auftrag und nach unseren Vorgaben technisch vorgehalten und technisch notwendig über die Backend-Infrastruktur und Softwaredienste von Google Cloud / Google Firebase betrieben, wenn und soweit nachfolgend nicht anders beschrieben sein sollte.

Eure Daten: Die von euch in der App hinzugefügten Daten, Posts, Dateien (z. B. Bilder, Dokumente, Angaben etc.) und weitere sonstige Informationen (**nachfolgend: „Inhalte“**) werden von Google gespeichert, damit diese euch und euren Klassen- oder Gruppenmitgliedern zur Verfügung stehen.

Diese Daten könnt ihr selbst jederzeit löschen. Löscht ihr euren Account, ohne zuvor eure Inhalte zu löschen, so wird euer Nickname bei den Inhalten bei der Angabe „Erstellt von“ anonymisiert. Die Inhalte bleiben für die anderen Gruppenmitglieder weiterhin verfügbar. Kommentare bei Inhalten oder Nachrichten im Messenger von dir werden gelöscht.

Einzig der Dienst Firebase Authentication (zur Authentifizierung der Nutzer erforderlich) und Firebase Hosting (Web-Hosting der Web-App) läuft über die Rechenzentren von Google in den USA. Diesbezüglich haben wir mit Google die [EU Standardvertragsklauseln](https://cloud.google.com/terms/eu-model-contract-clause) der EU Kommission abgeschlossen.

Diese Maßnahme gewährleistet, dass im Rahmen der Datenverarbeitung in der USA die Vorgaben der DSGVO strengstens beachtet werden.

Des Weiteren haben wir mit Google einen sog. „Auftragsverarbeitungsvertrag“ geschlossen, der sicherstellt, dass Google nur nach unseren Anweisungen handelt und sich im Übrigen auch nach diesem Vertrag an die Vorgaben der europäischen Datenschutzgesetze, insbesondere an die der DSGVO hält.

Weitere Informationen zur Google Cloud Plattform und deren IT-Sicherheit & Datenschutz findet ihr hier:

* https://cloud.google.com/security/?hl=de
* https://privacy.google.com/businesses/?hl=de
* https://privacy.google.com/businesses/compliance/#!?modal_active=none
* https://privacy.google.com/businesses/security/#!?modal_active=none
* https://cloud.google.com/terms/data-processing-terms
* https://cloud.google.com/terms/data-processing-terms/partner/
* https://cloud.google.com/terms/eu-model-contract-clause
* https://firebase.google.com/support/privacy

Die technisch notwendige Nutzung von Diensten von Google und Speicherung eurer freiwillig mitgeteilten Inhalte erfolgt aus eurem und unserem berechtigten Interesse (Art. 6 Abs. 1 S. 1 lit. f. DSGVO) zu einer sicheren, dauerhaft verfügbaren sowie performanten Darbietung, Aufrechterhaltung und Betrieb dieser App, damit ihr euren Schulalltag schnell und einfach digital mit unserer App organisieren könnt, um euch auf das Wesentliche in der Schule konzentrieren zu können.

Backups (=Sicherungskopien) werden sowohl innerhalb als auch außerhalb der Google Cloud bei einem anderen Hosting-Anbieter innerhalb von Deutschland gespeichert.

Wenn ihr älter als 16 Jahre alt seid, erfolgt die Verarbeitung der vorgenannten Daten auf der Rechtsgrundlage euer Einwilligung gemäß Art. 6 Abs. 1 S. 1 lit. a DSGVO).  

## 5. Deine Rechte

> **Einfach gesagt**
>
> Ihr könnt alle eure Rechte aus der DSGVO geltend machen:
>
> * Eine Auskunft über eure Daten verlangen, die bei uns liegen
> * Die Daten berichtigen oder löschen lassen
> * Die Verarbeitung der Daten einschränken
> * Widerspruch gegen die Verarbeitung einlegen
> * Eure Einwilligung zur Verarbeitung widerrufen
> * Datenübertragung zu euch und ggf. zu einem anderen Unternehmen verlangen
> * Beschwerde bei der Datenschutzaufsichtsbehörde einlegen
>  
> Bitte meldet euch an die folgende Adresse:
>  
> E-Mail: support@sharezone.net
>
> Bitte beachtet, dass bei der Löschung oder Beschränkung von den zwingend erforderlichen Daten die App nicht genutzt werden kann.
>  
> Wenn du anonym angemeldet bist und die App deinstallierst, verlierst du Zugriff auf dein Konto und verlierst somit alle Daten, die mit dem Konto verbunden waren.

Als Nutzer unserer App habt ihr nach der DSGVO verschiedene Rechte, die sich insbesondere, aber nicht abschließend aus den Art. 15 bis 18, 20, 21, 77 etc. DSGVO ergeben:

### a. Recht auf Auskunft

Ihr könnt Auskunft über eure von uns verarbeiteten personenbezogenen Daten verlangen. In eurem Auskunftsantrag solltet ihr euer Anliegen präzisieren, um uns das Zusammenstellen der erforderlichen Daten zu erleichtern.

### b. Recht auf Berichtigung

Sollten die euch betreffenden Angaben nicht (mehr) zutreffend sein, könnt ihr eine Berichtigung verlangen. Sollten eure Daten unvollständig sein, könnt ihr eine Vervollständigung verlangen.

### c. Recht auf Löschung

Ihr könnt unter den Bedingungen des Art. 17 DSGVO die Löschung eurer personenbezogenen Daten verlangen. Euer Anspruch auf Löschung hängt u. a. davon ab, ob die euch betreffenden Daten von einem Aufbewahrungsrecht gedeckt sind oder von uns zur Erfüllung unserer gesetzlichen Rechte und Pflichten noch benötigt werden.

### d. Recht auf Einschränkung der Verarbeitung

Ihr habt im Rahmen der Vorgaben des Art. 18 DSGVO das Recht, eine Einschränkung der Verarbeitung der euch betreffenden Daten zu verlangen.

### e. Recht auf Widerspruch

Ihr habt das Recht, aus Gründen, die sich aus eurer besonderen Situation ergeben, jederzeit der Verarbeitung der euch betreffenden Daten zu widersprechen. Dies gilt insbesondere, wenn wir aus einem berechtigten Interesse eure Daten verarbeiten. Allerdings können wir dem nicht immer nachkommen, z. B. wenn wir verpflichtet sind, die Daten nach den Vorschriften des Steuerrechts zu Prüfungszwecken archivieren zu  müssen. In diesem Fall werden die Daten jedoch für die weitere Nutzung gesperrt und nach Ende der gesetzlichen Aufbewahrungspflichtzeit gelöscht.

### f. Recht auf Widerruf

Sofern ihr uns eine Einwilligung in die Verarbeitung eurer Daten erteilt habt, habt ihr das Recht, die Einwilligung jederzeit zu widerrufen. Hierdurch wird die Rechtmäßigkeit, der aufgrund der Einwilligung bis zum Widerruf der erfolgten Verarbeitung nicht berührt.

### g. Recht auf Datenübertragbarkeit

Ihr haben das Recht, die euch betreffenden Daten, die ihr uns bereitgestellt habt, in einem strukturierten, gängigen und maschinenlesbaren Format zu erhalten. Sofern ihr die Daten aufgrund einer Einwilligung oder aufgrund eines Vertrages bereitgestellt habt, habt ihr das Recht, dass wir die Daten zu einem von euch benannten Verantwortlichen übertragen.

### h. Recht auf Beschwerde

Wenn ihr der Auffassung seid, dass wir bei der Verarbeitung eurer Daten datenschutzrechtliche Vorschriften nicht beachtet haben, könnt ihr euch mit einer Beschwerde an eine Datenschutzaufsichtsbehörde wenden, die eure Beschwerde prüfen wird.

Eine Liste der Anschriften der Datenschutz-Aufsichtsbehörden findest du unter:

[BFDI - Anschriften und Links](https://www.bfdi.bund.de/DE/Infothek/Anschriften_Links/anschriften_links-node.html)

Wir haben jedoch auch ein offenes Ohr und beseitigen etwaig vorhandene Probleme, wenn ihr uns einen Hinweis an support@sharezone.net erteilt.

## 6. Eure Kontaktaufnahme

> **Zusammenfassung**
>
> Wenn ihr mit uns von euch aus Kontakt aufnehmt, speichern wir eure Daten nur zur Erledigung eurer Anfrage. Anschließend werden die Daten in regelmäßigen Abständen gelöscht oder der Personenbezug endgültig anonymisiert, wenn uns ein Gesetz nicht zur Aufbewahrung verpflichtet.

Bei eurer freiwilligen Kontaktaufnahme mit uns (etwa per E-Mail oder über unsere Kontaktformulare in der App (Feedback-Box) oder auf der Webseite) werden nur die von euch mitgeteilten Daten und Nachrichten (etwa eure E-Mail-Adresse, euer Nickname und eure ggf. weiteren freiwillig erteilten Angaben) von uns gespeichert, um euer Anliegen (etwa Kontaktanfrage, Beratungswunsch, Verbesserungsvorschläge) zu bearbeiten.

Die im Zusammenhang mit der Kontaktaufnahme anfallenden Daten löschen wir oder wir anonymisieren den Personenbezug endgültig, nachdem die Speicherung nicht mehr erforderlich ist oder schränken die Verarbeitung ein, falls gesetzliche Aufbewahrungspflichten bestehen.

Die Übermittlung eurer Daten in Folge einer solchen Anfrage erfolgt freiwillig durch euch, sodass ihr damit gleichzeitig eure Einwilligung erteilt (Rechtsgrundlage ist Art. 6 Abs. 1 S. 1 lit. a DSGVO). Darüber hinaus haben wir bezüglich der Verarbeitung der Daten ein berechtigtes Interesse gem. Art. 6 Abs.1 S.1 lit. f DSGVO, da wir eure Anfrage beantworten bzw. bearbeiten möchten. Sollte eure Anfrage auf den Abschluss eines Vertrages hinzielen, so ist zusätzlich die Rechtsgrundlage gem. Art. 6 Abs. 1 S.1 lit. b DSGVO zur Verarbeitung der Daten gegeben.

## 7. Unser Umgang mit euren Daten

> **Zusammenfassung**
>
> Wir verarbeiten Daten von euch, wenn ihr:
>
> * unsere App nutzt
> * mit uns kommuniziert

Bei der bloß informatorischen Nutzung dieser App, also wenn ihr euch etwa nicht mit euren persönlichen Daten (Nickname, E-Mail etc.) registriert oder uns anderweitig Informationen übermittelt, erheben wir nur die Zugriffsdaten, die euer Gerät an unseren Server übermittelt.

Bei jeder Nutzung unserer App werden folgende nicht personenbeziehbare Zugriffsdaten gespeichert:

der Name der aufgerufenen Datei und/oder Inhalte in der App,
das Datum und die Uhrzeit der Anforderung,
die übertragene Datenmenge,
der Zugriffsstatus (Datei übertragen, Datei nicht gefunden etc.),
die Zugriffsart (GET, POST),
das verwendete Gerät und Betriebssystem,
Cookies

Aus Gründen der Datensicherheit, also um unerlaubte Zugriffe aufklären oder Missbrauch der App verhindern zu können und um gegebenenfalls daraus resultierende Rechtspflichten und Rechtsansprüche verfolgen zu können, wird die vollständige IP-Adresse des anfordernden Endgerätes erfasst, gespeichert und 6 Monate nach dem Ende des Zugriffs automatisch gelöscht.

Wenn ihr unsere App nutzen möchtet, erheben wir die vorgenannten Daten, die für uns unabdingbar technisch erforderlich sind, um euch unsere App überhaupt anbieten zu können und um die Verbesserung der Stabilität, Funktionalität und Sicherheit für beide Seiten zu gewährleisten, sodass die Erhebung dieser Daten aufgrund eines berechtigten Interesses auf beiden Seiten erfolgt (Rechtsgrundlage ist daher Art. 6 Abs. 1 S. 1 lit. f DSGVO).

Wenn ihr älter als 16 Jahre alt seid, erfolgt die Verarbeitung der vorgenannten Daten auf der Rechtsgrundlage euer Einwilligung gemäß Art. 6 Abs. 1 S. 1 lit. a DSGVO).

## 8. Account, Nickname und Passwort

Für die Nutzung der App ist es erforderlich, einen Account (Kundenkonto) zu erstellen oder sich mit einem bestehenden Account und Passwort anzumelden und einen Nickname zu haben, soweit dies nachfolgend als möglich genannt wird.

### a. Registrierung mittels anonymen Accounts

Die App kann ohne Angabe von personenbezogenen Daten genutzt werden, da es für die Nutzung der App nicht erforderlich bzw. für unter 16-Jährige nicht erlaubt ist, etwaige personenbezogene Daten in der App freiwillig anzugeben.

Wenn ihr unter 16 Jahre alt seid, dürft ihr lediglich diesen anonymen Account nutzen, um ein Nutzungsrecht für die App zu haben.

Jeder Nutzer, der die App verwendet, bekommt stets automatisch ein anonymes Konto zugewiesen. Dieses Konto erhält ein Pseudonym als Nickname (etwa „Anonymer Tiger“). Dieser Nickname kann in den Einstellungen auch nach eurem Belieben abschließend in entweder euren Spitznamen oder Fantasienamen umbenannt werden (etwa “Matze“ für “Matthias Mustermann“, “Jen“ für “Jennifer Musterfrau“ oder einfach “Schlauer Fuchs“).

Der Fantasie- oder euer freiwillig angegebene Nickname in der App ist erforderlich, damit die anderen Teilnehmer*innen aus euren Kursen, Klassen oder Schule (**nachfolgend zusammengefasst als „Gruppe“ bezeichnet**) euch in den Anwendungsmöglichkeiten der App von anderen Schüler*innen unterscheiden können (Zweck der Verarbeitung).

Soweit ihr unter 16 Jahren alt seid, verbieten wir für die Erlangung eines Nutzungsrechts an der App ausdrücklich, dass ihr dabei euren echten Namen verwendet, damit eure Privatsphäre so weit wie möglich gewahrt bleibt.

Bei dieser Registrierungsart wird lediglich die IP-Adresse temporär nach Maßgabe der Ziffer 9 [("9. Verarbeitung der IP-Adresse")](#9-verarbeitung-der-ip-adresse) verarbeitet.

Die Verarbeitung der IP-Adresse ist technisch zwingend erforderlich, damit euer Gerät ein Verbindungsaufbau zu unseren Servern erzeugen kann und ihr so die Möglichkeit habt, die Informationen aus euren Gruppenräumen bzw. die weiteren Anwendungsmöglichkeiten der App abzurufen und zu nutzen (Zweck der Verarbeitung).

Rechtsgrundlage für die Verarbeitung der zuvor genannten Daten ist unser berechtigtes Interesse (Art. 6 Abs. 1 S. 1 lit. f DSGVO), euch die App und dessen Anwendungsmöglichkeiten dauerhaft verfügbar zu machen sowie die App performant darzubieten, aufrecht zu halten und zu betreiben, um euer berechtigtes Interesse (Art. 6 Abs. 1 S. 1 lit. f DSGVO) an der Nutzung der App zu erfüllen, dass ihr euren Schulalltag schnell, einfach und digital mit unserer App organisieren könnt.

**Der Nachteil dieser Anmeldung** ist, dass wir technisch nicht nachvollziehen können, wem ein bestimmter Account zuzuordnen ist. Daher ist der anonyme Account aus technisch zwingenden Gründen an dem Gerät gebunden, mit welchem die Registrierung erfolgt ist. Solltet ihr euch abmelden, die App deinstallieren oder euer Gerät verlieren, verliert ihr euren Zugriff zu eurem Account.

### b. Registrierung mit E-Mail-Adresse & Passwort oder Google/Apple Sign In ab einem Alter von 16 Jahren und älter

Wenn ihr mindestens 16 Jahre alt seid, könnt ihr euch auf eigenem Wunsch, d.h. völlig freiwillig neben der anonymen Registrierung auch mittels E-Mail-Adresse und Passworts oder über Google bzw. Apple Sign In (nachfolgend: “Registrierungsdaten“) für die Nutzung der App registrieren. Es steht euch frei, welche Registrierungsdaten ihr dafür verwendet. Es kann also auch eure Fantasie-Adresse wie etwa "schlauerfuchs[at]xyz.de" sein. Im Anschluss wählt ihr einen frei wählbaren Nickname (etwa “Matze“ oder “schlauer Fuchs“).

Die Registrierung mittels der Registrierungsdaten erfolgt auf eurem Wunsch, d.h. freiwillig durch euch, wenn und weil ihr die anonyme Registrierung ablehnt, um technisch bedingt mehr Service zu erleben, nämlich:

* Wir speichern die vorgenannten Registrierungsdaten dazu, um euch auf euren Verlangen hin euer vergessenes Passwort zurückzusetzen.

* Daneben können wir bei der Registrierung mittels der Registrierungsdaten ermöglichen, dass ihr euch von jedem Endgerät und von überall auf der Welt in unsere App einloggen könnt, sodass ihr flexibel und frei von Gerätegebundenheit arbeiten könnt.

* Zudem ermöglicht die Angabe der E-Mail-Adresse dich über Aktivitäten in „Sharezone“ (z.B. Löschung von Gruppen, Erstellung von Hausaufgaben) und Aktualisierung der Datenschutzerklärung/AGBs auf dem neuesten Stand zu halten.

* Außerdem können wir dich über sicherheitsrelevante Informationen über deinen Account informieren (z.B. Login von einem fremden Gerät).

Euer frei wählbarer Nickname hilft darüber hinaus anderen Teilnehmer*innen aus eurer Gruppe, euch in den Anwendungsmöglichkeiten der App von anderen Schüler*innen, Lehrkräften und Eltern zu unterscheiden. Ihr könnt dafür auch euren Spitznamen oder einen Fantasienamen wählen.

Die Registrierung und Anmeldung mit den Registrierungsdaten haben den Zweck, dass ihr euch stets von jedem beliebigen Gerät auf euren Account einloggen könnt. Wenn ihr euer Passwort vergessen habt, könnt ihr die Option „Passwort vergessen“ auswählen. Wir schicken euch dann eine E-Mail mit einem Link, über den ihr ein neues Passwort setzen könnt. Des Weiteren kann der Missbrauch der App verhindert bzw. verfolgt werden.

Mit der freiwilligen Angabe eurer Registrierungsdaten, zur Nutzung der technisch bedingten Vorteile der App, erklärt ihr eure Einwilligung zur Verarbeitung der Registrierungsdaten (Rechtsgrundlage Art. 6 Abs. 1 S. 1 lit. a DSGVO). Ohne Abgabe eurer Einwilligung ist die Nutzung dieser App nur gemäß Ziffer 9.a. (anonymer Account) möglich.

## 9. Verarbeitung der IP-Adresse

Die Nutzung unserer App bedarf eines Verbindungsaufbaus zwischen eurem Endgerät und unserem Server, um Informationen aus der App abrufen zu können bzw. in der App bereitstellen zu können.

Hierfür wird technisch zwingend die IP-Adresse verwendet, damit die Kommunikation zwischen eurem Endgerät und unseren Servern funktioniert. Dies stellt zugleich den Zweck der Verarbeitung der IP-Adresse dar.

Ein weiterer Zweck für die Verarbeitung der IP-Adresse besteht darin, Sicherheit vor Angriffen zu gewährleisten. So kann verhindert werden, dass nicht valide Zugriffe getätigt werden, indem wir automatisierte Sicherheitsmechanismen einsetzen, welche die Nutzerdaten vor dem Missbrauch schützen.

Ein Hinweis zu IP-Adressen und Personenzuordnung: Die technisch bedingte und bei Google Firebase gespeicherte IP-Adresse ist für uns nicht einsehbar. Einen eindeutigen Zusammenhang zwischen einer IP-Adresse und einem genauen Internetanschluss samt dessen Inhaber kann nur der jeweiliger Internet-Anbieter des Nutzers für einen begrenzten Zeitraum herstellen. Als Privatperson oder Unternehmen könnte man dann an den Inhaber des Internetanschlusses nur mittels eines hoheitlichen/behördlichen Aktes des Staates heran (z.B. Urteile, Behördenentscheidung etc.) auf Antrag heran, wenn man ein berechtigtes Interesse (etwa Verfolgung von Verletzungen von Urheberrechten oder Straftaten) hat.

Daneben kann es Fälle geben, wo viele Geräte nur eine IP-Adresse haben, sodass eine zielgenaue Identifizierung einer Person nicht möglich ist (z. B. Nutzung der App über das Schul-WLAN).

Die Speicherung der IP-Adresse erfolgt auf den Servern von Google und ist nach Angaben von Google nur temporär. Eine nähere Bestimmung der Speicherdauer war trotz schriftlicher Nachfrage seitens Googles nicht möglich.

Zusätzlich speichern wir die IP-Adresse, wenn du die Datenschutzerklärung akzeptierst, um unserer Nachweispflicht nachzugehen.

Aufgrund gesetzlicher Verjährungsfristen sind wir dazu angehalten, diese Daten 3 Jahre zu speichern. Die Frist zur Löschung beginnt mit dem Schluss des Jahres, in dem die Daten gespeichert wurden.

Rechtsgrundlage für die technisch zwingend erforderliche Verarbeitung der IP-Adresse stellt in Fällen Ziffer 9.a. unser berechtigtes Interesse (Art. 6 Abs. 1 S. 1 lit. f DSGVO) dar, euch die App und dessen Anwendungsmöglichkeiten dauerhaft verfügbar zu machen, sowie die App performant darzubieten, aufrecht zu halten und zu betreiben, um euer berechtigtes Interesse (Art. 6 Abs. 1 S. 1 lit. f DSGVO) an der Nutzung der App zu erfüllen, dass ihr euren Schulalltag schnell, einfach und digital mit unserer App organisieren könnt.

In Fällen den Ziffer 9.b. besteht die Rechtsgrundlage für die Verarbeitung eurer IP-Adresse neben dem berechtigten Interesse des Weiteren in eurer Einwilligung gemäß Art. 6 Abs. 1 S.1 lit. a DSGVO)

Wenn ihr mit der Speicherung nicht einverstanden seid, kann die App technisch bedingt nicht genutzt werden.

## 10. Speicherdauer und Speicherfristen

Soweit in dieser Datenschutzerklärung nicht anders angegeben, werden die im Rahmen von Support-Anfragen über unsere eigenen Dienste erhobenen Daten für einen Zeitraum von 3 Monaten gespeichert, soweit wir kein Aufbewahrungsrecht oder –Pflicht aufgrund von Gesetzen haben.

Sämtliche Fristen beginnen mit Ablauf des Monats, in welchem die Bearbeitung der Anfrage abgeschlossen wird.

Im Übrigen bemisst sich die Dauer der Speicherung von personenbezogenen Daten anhand der gesetzlichen Aufbewahrungsrechte und –Pflichten (etwa aus dem Handels- oder Steuerrecht). Nach Ablauf der Frist werden die Daten zum Ende des Monats gelöscht, sofern sie nicht für die Anbahnung, Durchführung und Beendigung eines Vertrages erforderlich sind und / oder kein berechtigtes Interesse unsererseits an der Verarbeitung besteht.

Wird die App länger als zwei Jahre nicht mehr verwendet, wird das Konto automatisch gelöscht. Bei anonymen Accounts tritt diese Löschung bereits nach sechs Monaten anstatt zwei Jahren ein.

## 11. Verarbeitung des gewählten Account-Typs und des Bundeslandes

Ihr könnt bei der App freiwillig euer Bundesland angeben. Dies hat den Zweck, dass euch die App den Countdown zu den nächsten Ferien des jeweiligen Bundeslandes zeigt. Zudem können wir Push-Nachrichten an Benutzer aus einzelnen Bundesländern (z.B. zum Ferienstart) verschicken. Zusätzlich nutzen wir die Angabe des Bundeslandes zur anonymen Analyse, um herauszufinden, aus welchen Regionen die Nutzer kommen.

Ihr könnt die Angabe des Bundeslandes jederzeit löschen, in dem ihr unter den Einstellungen bei der Option „Bundesland“ „Anonym bleiben“ auswählt. Die Angabe wird spätestens gelöscht, wenn ihr euren Account löscht.

Die Verarbeitung der freiwilligen Angabe eures Bundeslandes erfolgt auf der Rechtsgrundlage eures berechtigten Interesses (Art. 6 Abs. 1 S. 1 lit. f DSGVO), um den Zeitraum bis zu den nächsten Ferien zu sehen und wenn ihr älter als 16 Jahre seid, auch auf der Rechtsgrundlage der Einwilligung (Art. 6 Abs. 1 S. 1 lit. a DSGVO), da ihr das Bundesland freiwillig angebt.

## 12. Anonyme statistische Auswertung der App-Nutzung

Damit wir unsere App stets verbessern und benutzerfreundlicher gestalten können, speichert die App völlig anonym und ohne, dass es eine Möglichkeit der Rückverfolgung gibt, statistische Werte über die Nutzung der App ab. So kann beispielsweise besser gesehen werden, unter welchem Menüpunkt der App es häufig zu Fehlern der Anwender kommt, sodass dieser Menüpunkt überarbeitet werden kann.

Zu dieser anonymen Auswertung wird Firebase/Google Analytics, Firebase Crashlytics, Firebase Performance und Firebase Predictions verwendet.

Ihr könnt dieser statistischen Auswertung in den App-Einstellungen jederzeit widerrufen.

## 13. Push-Nachrichten

Die App verwendet Google Firebase Cloud Messaging, um dir, speziellen Nutzergruppen oder allen Nutzern eine Push-Nachricht zu schicken (z.B. neue Hausaufgabe, neue Nachricht, etc.).

Beim Start der App wird ein Registration-Token gespeichert. Dieser Token erlaubt, Push-Nachrichten an ein bestimmtes Gerät zu schicken. Ohne Token können wir dir aus technischen Gründen keine speziellen Push-Nachrichten für dich zu schicken. Dieser Token besitzt keine Informationen über deine Person und ist eine Reihenfolge an Buchstaben und Zahlen.

Diese Information erfolgt ausschließlich zur Klarstellung. Eine Datenverarbeitung oder eine Datenweitergabe an Google erfolgt hiermit nicht, sodass die Datenschutzgesetze nicht berührt werden.

Rechtsgrundlage der Verarbeitung ist Art. 6 Abs. S. 1 lit. b DSGVO, der besagt, dass die Daten zur Durchführung unseres Dienstes erforderlich sind.

> **Kenntnisnahme**
>
> Ich habe zur Kenntnis genommen, dass Google Firebase zum Verschicken von Push-Nachrichten einen Token verwendet.
>
> Dabei werden keine personenbezogenen Daten an Google übermittelt.
>
> Google hat lediglich einen Token, um die Meldungen den richtigen Empfängerkreis zukommen zu lassen.

## 14. Instance ID

Mehrere von uns genutzte Dienste von Firebase nutzen sogenannte "Instance-IDs", um eine spezifische Installation einer App (also Sharezone) zu identifizieren. Jede Instance-ID ist einzigartig zur einer App und einem Gerät.

[Laut Google](https://firebase.google.com/support/privacy/manage-iids#manage_app_data_associated_with_instance_ids) sollten die erfassten Daten zusammen mit der Instance-ID nicht auf eine Person rückschließen lassen.

Diese Dienste nutzen die Instance-IDs in der folgenden Weise:

### Firebase Cloud Messaging

Nutzt Instance-IDs, um daraus die oben ([13. Push Nachrichten](#13-push-nachrichten)) genannten Registration-Tokens zu generieren, damit wir dir Push-Nachrichten zusenden können. Nach dem Verschicken einer Nachricht wird die Instance-ID aus dem System entfernt, kann jedoch bis zu 180 Tagen in Backup-Systemen verbleiben.

### Firebase Crashlytics

Nutzt Instance-IDs, um zu messen wie viele Nutzer von einem Crash betroffen sind und um mit dem Fehler verbundene Error- und gerätespezifische Daten zu speichern. Die Instance-ID bleibt bis zu 90 Tage gespeichert.

### Firebase Performance Monitoring

Nutzt Instance-IDs, um sicherzustellen, dass genügend verschiedene Installationen Daten erzeugen, damit Datensätze anonym genug sind, um keine Rückverfolgung zu einzelnen Personen zu ermöglichen. Weiterhin wird die ID genutzt, um die Häufigkeit dieser Daten-Reports der App-Instanz zu regulieren. Die Instance-ID bleibt bis zu 90 Tage gespeichert.

### Firebase Predictions

Nutzt Instance-IDs, um für die App spezifische Nutzungsdaten (Events) abzurufen und analysieren zu können.
Daraus werden Vorhersagen generiert, wie z.B., dass ein Nutzer bald die App deinstallieren wird. Die Instance-ID kann bis zu 180 in Backup-Systemen verbleiben.

### Firebase Remote Config

Benutzt Instance-IDs, um für das Gerät spezielle Konfigurationswerte abzurufen. Die Aufteilung nach Instance IDs ist sinnvoll, da z.B. für sogenannte A/B- oder Split-Tests manche Nutzer eine andere Konfiguration als andere Nutzer erhalten können. Die Instance-ID kann bis zu 180 Tage in Backup-Systemen verbleiben.

### Google/Firebase Analytics

Nutzt die Instance-IDs, um Daten eines Nutzers zu sammeln. Die Instance-ID kann bis zu 14 Monate gespeichert werden.

---

Rechtsgrundlage der Verarbeitung ist Art. 6, Absatz 1(b) der DSGVO, der besagt, dass die Daten zur Durchführung unseres Dienstes erforderlich sind.

> **Kenntnisnahme**
>
> Ich habe zur Kenntnis genommen, dass Google Firebase für die genannten Dienste eine Instance-ID erstellt und verarbeitet.
>
> Dabei werden keine personenbezogenen Daten an Google übermittelt.

## 15. Empfänger oder Kategorien von Empfängern

In der Regel werden personenbezogene Daten, die du uns zu deiner Person mitteilst, nur durch uns verarbeitet. Zur Erfüllung unserer Aufgaben und Pflichten kann es aber erforderlich sein, dass wir die zu eurer Person gespeicherten personenbezogenen Daten gegebenenfalls gegenüber natürlichen und juristischen Personen, Behörden, Einrichtungen oder anderen Stellen gegenüber offenlegen müssen. In Betracht kommen dabei insbesondere folgende Kategorien von Empfängern:

* Google Cloud, siehe oben [4. Hosting, Backend-Infrastruktur und Speicherort für eure Daten](#4-hosting-backend-infrastruktur-und-speicherort-fr-eure-daten)
* Gerichte (z.B. bei streitigen Verfahren)
* Nicht-öffentliche Stellen sofern es sich hierbei um einen Auftragsverarbeiter handelt
* Rechtsanwälte, Steuerberater, Notare, Wirtschaftsprüfer

## 16. SSL/TLS-Verschlüsselung

Diese App nutzt aus Gründen der Sicherheit von Daten und zum Schutz der Übertragung vertraulicher Inhalte, wie zum Beispiel der Anfragen, die du an uns sendest, eine SSL/TLS-Verschlüsselung, die von Google Firebase standardmäßig zur Verfügung gestellt wird. Eine verschlüsselte Verbindung erkennt ihr z.B. daran, dass die Adresszeile des Browsers von "http://" auf "https://" wechselt und an dem Schloss-Symbol in der Browserzeile. Über die SSL/TLS-Verschlüsselung können die Daten, die ihr an uns übermittelt, nicht von Dritten bei der Übertragung mitgelesen werden.

## 17. Videokonferenzen

Die App ermöglicht ebenfalls die freiwillige Nutzung von Videokonferenzen, damit ihr z.B. Fernunterricht über „Sharezone“ durchführen könnt. Dafür wird der Dienst Jitsi Meet verwendet, eine Open Source Videokonferenzlösung der Firma 8x8 Inc. (2125 O'Nel Dr, San Jose, CA 95131, Vereinigte Staaten – nachfolgend kurz 8X8), die lokal auf einem Server gespeichert wird.

Nutzer können so sichere und mit umfassenden Funktionen ausgestattete Videokonferenzen abhalten. Dies kann mit der App passieren oder über den Browser (https://meet.sharezone.net). Tritt der Nutzer über den Browser bei, wird die App „Sharezone“ nicht benötigt.

Die Software Jitsi Meet ist lokal auf unseren Server mit Standort **Belgien** (siehe Ziffer 4. Hosting, Backend-Infrastruktur und Speicherplatz für eure Daten) installiert und sendet keine Daten an die Firma 8x8 Inc.

Bei der Nutzung wird deine Stimme (falls Mikrofon aktiviert) und dein Videobild (falls Videofunktion aktiviert ist) während der Videokonferenz temporär während der Nutzung verarbeitet, damit du mit anderen Personen kommunizieren kannst.

Auf der Grundlage von WebRTC werden Daten über Datagram Transport Layer Security (DTLS) und Secure Real-Time Transport Protocol (SRTP) verschlüsselt übertragen. WebRTC bietet jedoch (noch) keine stabile Möglichkeit, Videokonferenzen mit mehr als zwei Teilnehmer*innen Ende-zu-Ende zu verschlüsseln. Das bedeutet: Auf dem Transportweg ist die Videokonferenz verschlüsselt, auf dem Videokonferenz-Server hingegen wird der gesamte Datenverkehr entschlüsselt und ist damit theoretisch für uns einsehbar, falls Jitsi über unsere Server genutzt wird. Jedoch werden wir zu keiner Zeit davon Gebrauch machen und speichern keinerlei Informationen zu den Videokonferenzen.

Bei Nutzung des Dienstes erfolgt die kurzzeitige Zwischenspeicherung der Daten zu dem Zweck, den Teilnehmer*innen die Nutzung der Videokonferenz zu ermöglichen.

Rechtsgrundlage für die kurzzeitige Zwischenspeicherung stellt für den Fall einer Registrierung nach Ziffer 9 lit. b. eure Einwilligung (Art. 6 Abs. 1 lit. a DSGVO) für die Nutzung des Dienstes dar. Im Übrigen erfolgt die technisch zwingend erforderliche Zwischenspeicherung aufgrund eures und unseres berechtigten Interesses (Art. 6 Abs. 1 lit. f DSGVO), euch eine Videokonferenzlösung aus Deutschland heraus anzubieten, damit ihr etwa Fernunterricht wahrnehmen könnt.

## 18. Datenübertragung in Drittländer außerhalb der EU

### a. Firebase Authentication

Zur Nutzung von Sharezone ist es erforderlich ein Benutzerkonto zu haben (warum dies notwendig ist, wurde detailliert in [8. Account, Nickname und Passwort](#8-account-nickname-und-passwort) erläutert).

Aus Sicherheitsgründen wird dabei die IP-Adresse kurzfristig geloggt und kann in den Backups [laut Google](https://firebase.google.com/support/privacy#examples_of_end-user_personal_data_processed_by_firebase) bis zu 180 Tagen verbleiben.

Solltest du dein Konto mit einer E-Mail-Adresse oder einem Google-Konto verknüpft haben, wird diese E-Mail-Adresse (bei Google-Konten die E-Mail-Adresse des Google-Kontos) bei Firebase Authentication gespeichert, weil diese Information beim Einloggen erforderlich ist.

Der Dienst Firebase Authentication wird in den USA von Google gehostet. Um eine datenschutzgerechte Verarbeitung zu ermöglichen, haben wir mit Google die EU-Standardvertragsklauseln abgeschlossen.

Rechtsgrundlage für die befristete Speicherung der IP-Adresse stellt für den Fall einer Registrierung nach Ziffer 9 lit. b. eure Einwilligung (Art. 6 Abs. 1 lit. a DSGVO) für die Nutzung des Dienstes dar. Im Übrigen erfolgt die technisch zwingend erforderliche Speicherung aufgrund eures und unseres berechtigten Interesses (Art. 6 Abs. 1 lit. f DSGVO), euch die App performant zur Verfügung zu stellen.

### b. Firebase Hosting

Über Firebase Hosting läuft das Web-Hosting der Web-App (https://web.sharezone.net). Solltest du die Web-App von Sharezone nutzen, schickst du eine Anfrage an Firebase Hosting, um die Seite zu laden.

Bei jedem Zugriff wird die IP-Adresse aus Sicherheitsgründen in den Logs gespeichert. Diese IP-Adresse bleibt [laut Google](https://firebase.google.com/support/privacy#examples_of_end-user_personal_data_processed_by_firebase) für ein paar Monate gespeichert.

Der Dienst Firebase Hosting wird in den USA von Google gehostet. Um eine datenschutzgerechte Verarbeitung zu ermöglichen, haben wir mit Google die EU-Standardvertragsklauseln abgeschlossen.

Rechtsgrundlage für die befristete Speicherung der IP-Adresse stellt für den Fall einer Registrierung nach Ziffer 9 lit. b. eure Einwilligung (Art. 6 Abs. 1 lit. a DSGVO) für die Nutzung des Dienstes dar. Im Übrigen erfolgt die technisch zwingend erforderliche Speicherung aufgrund eures und unseres berechtigten Interesses (Art. 6 Abs. 1 lit. f DSGVO), euch die Web-App performant zur Verfügung zu stellen.

## 19. Datenschutzbeauftragter

Der Verantwortliche hat die Kontaktdaten seines ggf. gem. Art. 37 DSGVO benannten Datenschutzbeauftragten mitzuteilen, wenn die Pflicht zur Ernennung eines Datenschutzbeauftragten besteht.

Wir sind derzeit nicht verpflichtet einen Datenschutzbeauftragten zu haben.

## 20. Vorbehalt der Änderung dieser Informationen

Änderung der Rechtslage oder Gesetze können eine Anpassung dieser Informationen erforderlich machen. Wir bitten dich daher höflich, diese Informationen bei jedem Besuch unserer Internetseiten zur Kenntnis zu nehmen.""";
