// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:legal/legal.dart';

class TermsOfServicePage extends StatelessWidget {
  static const tag = "terms-of-service-page";

  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivacyPolicyPage(
      privacyPolicy: termsOfServicePolicy,
      headingText: 'Allgemeine Nutzungsbedingungen',
    );
  }
}

final termsOfServicePolicy = PrivacyPolicy(
  markdownText: tocMarkdown,
  tableOfContentSections: tocDocumentSections.toIList(),
  version: '1.0.0',
  downloadUrl: Uri.parse('https://sharezone.net/anb-v1-0-0-pdf'),
  lastChanged: DateTime(2024, 04, 22),
);

final tocDocumentSections = [
  _section(
      'vorbemerkungen--geltungsbereich', 'Vorbemerkungen / Geltungsbereich'),
  _section('nutzungsvoraussetzungen', 'Nutzungsvoraussetzungen', [
    _section('angebotene-funktionen', 'Angebotene Funktionen'),
    _section('registrierung--zustandekommen-des-nutzungsvertrags',
        'Registrierung / Zustandekommen des Nutzungsvertrags'),
    _section('sharezone-plus', 'Sharezone Plus'),
    _section('nutzungsrechte', 'Nutzungsrechte'),
    _section('veroeffentlichen-von-inhalten', 'Veröffentlichen von Inhalten'),
    _section('verfuegbarkeit-der-plattform', 'Verfügbarkeit der Plattform'),
  ]),
  _section('pflichten-der-nutzer--nutzerverhalten',
      'Pflichten der Nutzer / Nutzerverhalten'),
  _section('verantwortlichkeit-fuer-inhalte-der-nutzer',
      'Verantwortlichkeit für Inhalte der Nutzer'),
  _section('haftung--freistellungsanspruch', 'Haftung / Freistellungsanspruch'),
  _section('beendigung-des-nutzungsvertrags--kuendigung',
      'Beendigung des Nutzungsvertrags / Kündigung'),
  _section('aenderungen-der-allgemeinen-nutzungsbedingungen',
      'Änderungen der Allgemeinen Nutzungsbedingungen'),
  _section('datenschutz', 'Datenschutz'),
  _section('schlussbestimmungen', 'Schlussbestimmungen'),
];

DocumentSection _section(
  String id,
  String name, [
  List<DocumentSection> subsections = const [],
]) =>
    DocumentSection(DocumentSectionId(id), name, subsections.toIList());

const tocMarkdown = '''
# Allgemeine Nutzungsbedingungen Sharezone

## Vorbemerkungen / Geltungsbereich

Sharezone UG (haftungsbeschränkt) (nachfolgend „Sharezone”) betreibt unter der Domain sharezone.net (nachfolgend „Plattform“) eine Schul-App für den Schulalltag, die es Schülern und deren Eltern sowie Klassen und deren Lehrkräften ermöglicht, die Organisation und Kommunikation innerhalb der Schule bzw. Klasse abzubilden. Der Begriff “Plattform” bezeichnet die Webseite unter https://sharezone.net, die Web-App (erreichbar unter https://web.sharezone.net), die mobile iOS- und Android-App, sowie die App für macOS-Geräte.

Über die Plattform können sowohl Verbraucher i.S.d. § 13 BGB als auch Unternehmer i.S.d. § 14 BGB die Dienste von Sharezone nutzen.

Die nachfolgenden Allgemeinen Nutzungsbedingungen („ANB“) regeln die Nutzung der Plattform von Sharezone und der damit verbundenen Dienste („Dienste“), welche insbesondere die Abwicklung der Kommunikation im Zusammenhang mit dem Schulbetrieb beinhaltet.

Diese ANB gelten für Lehrkräfte, Schüler und Eltern (zusammen die „Nutzer“). Aus Gründen der besseren Lesbarkeit wird auf die gleichzeitige Verwendung der Sprachformen männlich, weiblich und divers (m/w/d) verzichtet. Sämtliche Personenbezeichnungen gelten gleichermaßen für alle Geschlechter. Soweit notwendig, wird nachfolgend entsprechend zwischen den Schulen und ihren Lehrkräften und Schülerinnen und Schülern und deren Eltern differenziert:

* Lehrkräfte sind Personen, die aktuell dem Lehrkörper einer Schule angehören
* Schüler sind solche, die aktuell aufgrund bestehender Schulpflicht oder des freiwilligen Besuchs eine Schule besuchen
* Eltern sind Eltern oder Erziehungsberechtigte von Schülern

Diesen ANB entgegenstehende oder von diesen abweichende Bedingungen der Nutzer erkennt Sharezone nicht an, es sei denn, der Geltung wird ausdrücklich zugestimmt. Diese ANB gelten auch dann, wenn Sharezone in Kenntnis entgegenstehender oder von diesen Bedingungen abweichender Bedingungen der Nutzer die Dienstleistung vorbehaltlos ausführt.

## Nutzungsvoraussetzungen

### Angebotene Funktionen

Sharezone bietet eine Schul-App für den Schulalltag an, die es den Nutzern ermöglicht, die Kommunikation innerhalb der Schule bzw. Klasse im virtuellen Raum abzubilden.

Sharezone ermöglicht es, Klassen und Kurse („Gruppen") zu erstellen. Innerhalb dieser Gruppen kann der aktuelle Stundenplan & Termine (beispielsweise Termine für Klausuren) eingetragen und eingesehen werden.

Zu jeder Gruppe können zudem Dateien abgelegt und von jedem berechtigten Nutzer abgerufen werden.

Die Nutzer haben die Möglichkeit, den Schülern Hausaufgaben zuzuweisen, die dann bei allen Schülern der entsprechenden Klasse bzw. des Kurses im Aufgabenheft erscheinen. Bei der Erstellung einer Hausaufgabe kann festgelegt werden, ob auch eine Abgabe der Hausaufgabe erfolgen soll. Diese Abgabe kann von einer Lehrkraft eingesehen werden. Zusätzlich können die Nutzer die Hausaufgaben kommentieren, um beispielsweise Nachfragen zu klären.

Zudem gibt es Infozettel, über die relevante Neuigkeiten für alle Nutzer der Gruppen eingespielt werden können. In den Einstellungen kann der Nutzer festlegen, ob dieser über Neuigkeiten per Push-Mitteilung informiert werden möchte. Die Nutzer haben zudem die Möglichkeit, die im Infozettel eingespielten Meldungen zu kommentieren.

Schüler können, sofern sie eine "Sharezone Plus"-Mitgliedschaft besitzen, die eigenen Schulnoten in Sharezone eintragen, um einen Überblick über die eigenen Leistungen zu bekommen.

Sharezone behält sich das Recht vor, die Plattform oder Dienste jederzeit ganz oder teilweise zu ändern, zu erweitern oder einzustellen, sofern dies den Nutzern nicht unzumutbar ist. In diesen Fällen wird Sharezone die Nutzer rechtzeitig im Voraus informieren. Änderungen mit lediglich unwesentlichen Auswirkungen auf die Plattform oder einzelne Dienste, insbesondere rein grafische oder programmiertechnische Änderungen, stellen insoweit keine Änderungen der Leistungen dar.

### Registrierung / Zustandekommen des Nutzungsvertrags

Grundlage der Nutzung der Plattform Sharezone und der Dienste ist das Zustandekommen eines Nutzungsvertrags zwischen dem Nutzer und Sharezone. Die Möglichkeit zur Nutzung der Plattform Sharezone stellt kein Angebot, sondern nur eine Aufforderung zur Abgabe eines Angebots dar. Durch den Abschluss des Registrierungsvorgangs gibt der Nutzer ein Angebot zum Abschluss des Vertrages über die Nutzung ab. Der Registrierungsvorgang ist abgeschlossen, wenn der Nutzer seinen Account-Typ (Schüler, Lehrkraft oder Elternteil) auswählt. Sharezone nimmt dieses Angebot des Nutzers durch Bereitstellung der entsprechenden Dienste an. Erst durch diese Annahme kommt der Vertrag zwischen dem Nutzer und Sharezone zustande.

Die Registrierung ist für die Nutzer kostenlos, d.h. ohne Zahlung eines Registrierungs- oder laufenden Entgelts möglich. Die Nutzung derjenigen Funktionen der Plattform, die nur auf Grundlage von Sharezone Plus angeboten werden, ist jedoch nur nach Erwerb einer entgeltpflichtigen “Sharezone Plus”-Mitgliedschaft möglich. Im Rahmen der Registrierung werden personenbezogene Daten verarbeitet. Diesbezüglich können weitere Informationen der Datenschutzerklärung (https://sharezone.net/datenschutzerklaerung) entnommen werden.

Die Registrierung steht allen natürlichen und juristischen Personen offen. Die Registrierung einer Person, die das 16 Lebensjahr noch nicht vollendet hat, bedarf der Zustimmung Ihrer gesetzlichen Vertretern. Die Registrierung einer juristischen Person darf nur von einer vertretungsberechtigten Person in vertretungsberechtigter Anzahl vorgenommen werden, die namentlich genannt werden muss. Auf Verlangen von Sharezone sind Personen, die eine Registrierung vorgenommen haben, verpflichtet, die entsprechenden Voraussetzungen nachzuweisen.

Bei der Registrierung wird unterschieden zwischen dem Nutzerkonto (auch "Account-Typ" genannt) für Schülern, Eltern und Lehrkräfte.

Bei der Registrierung muss jeder Nutzer einen Account-Typ festlegen und stimmt damit diesen ANB zu. Zusätzlich kann ein Nutzer sein Konto mit einer Anmeldemethode (E-Mail-Adresse & Passwort, Google Sign In oder Apple Sign In) verknüpfen. Die Nutzer sind verpflichtet, die Zugangsdaten für die Anmeldemethode geheim zu halten. Beispielsweise bei E-Mail & Passwort das Passwort geheim halten oder bei einem Drittanbieter (z.B. Google, Apple) die jeweiligen Zugangsdaten geheim halten. Sharezone weist daraufhin, dass Ansprüche bei Nichteinhaltung gegenüber dem Anschlussinhaber geltend gemacht werden können. Die Nutzer verpflichten sich, Sharezone unverzüglich bei einem Verdacht der unbefugten Nutzung des Nutzerkontos zu informieren und umgehend die Zugangsdaten oder die Anmeldemethode zu ändern. Sharezone ist berechtigt, den Zugang zu den registrierungspflichtigen Diensten zu sperren, wenn der begründete Verdacht besteht, dass die Zugangsdaten eines Nutzers durch unberechtigte Dritte genutzt wird.

Jegliche bei der Registrierung angegebenen Daten müssen der Wahrheit entsprechen. Die Nutzer sichern zu, dass alle von ihnen angegebenen Daten und Informationen der Wahrheit entsprechen. Die Nutzer sind zudem verpflichtet, alle angegebenen Daten fortlaufend auf ihre Aktualität zu überprüfen.

Jeder Nutzer darf sich nur einmal registrieren und nur über einen einzelnen Account verfügen. Sollte Sharezone feststellen, dass ein Nutzer mehrere Accounts besitzt, wird Sharezone alle Accounts bis auf einen einzelnen Account löschen. Auch die endgültige Löschung des betroffenen Nutzers behält sich Sharezone vor.

Es besteht kein Anspruch auf eine Registrierung.

### Sharezone Plus

Sharezone bietet neben den Standardfunktionen, die für die Nutzer kostenlos zugänglich sind, eine erweiterte Version namens „Sharezone Plus“ als Mitgliedschaft (nachfolgend “Mitgliedschaft”) innerhalb der Sharezone App an. Mit Sharezone Plus erhalten die Nutzer Zugriff auf zusätzliche Funktionen (auch Plus-Funktionen genannt), die in der kostenlosen Version nicht verfügbar sind.

Die genauen Kosten für die Mitgliedschaft können jederzeit auf der Plattform eingesehen werden. Die Preise werden entweder monatlich oder jährlich per Abonnement abgebucht oder als Einmalzahlung, je nach Auswahl des Nutzers. Sämtliche Preise sind Endpreise und enthalten die gesetzliche Mehrwertsteuer.

Die Zahlung für die Mitgliedschaft erfolgt über die jeweilige Plattform, auf der die App heruntergeladen wurde, sei es der Google Play Store oder der Apple App Store. Zahlungen über die Web-App werden mittels Stripe (Stripe Payments Europe, Limited (SPEL), 1 Grand Canal Street Lower, Grand Canal Dock, Dublin, D02 H210, Irland) abgewickelt. Die spezifischen Zahlungsbedingungen und -methoden sind den jeweiligen Geschäftsbedingungen dieser Plattformen zu entnehmen.

Bei Abschluss einer Mitgliedschaft über den Google Play Store oder den Apple App Store gelten zusätzlich zu diesen AGB auch die Allgemeinen Geschäftsbedingungen und Datenschutzrichtlinien des jeweiligen Anbieters. Es liegt in der Verantwortung des Nutzers, sich mit diesen Bedingungen vertraut zu machen.

* Google Play Store AGB: https://play.google.com/about/play-terms/
* App Store AGB: https://www.apple.com/legal/internet-services/itunes/de/terms.html
* Stripe AGB: https://stripe.com/de/legal/consumer

Nutzer können die Mitgliedschaft jederzeit über die Einstellungen in ihrem Account kündigen, falls die Mitgliedschaft ein Abonnement ist. Bei einer Kündigung bleibt der Zugang zu den Plus-Funktionen bis zum Ende des bereits bezahlten Zeitraums bestehen. Eine Rückerstattung für bereits bezahlte Zeiträume erfolgt nicht.

Sharezone behält sich das Recht vor, die Preise, Funktionen oder andere Aspekte des Abonnements zu ändern. Solche Änderungen werden den Nutzern rechtzeitig im Voraus mitgeteilt.

### Nutzungsrechte

Zum Zwecke der Nutzung der Plattform und der Dienste im vertraglich vorgesehenen Umfang räumt Sharezone den Nutzern das einfache, räumlich unbeschränkte, zeitlich auf die Laufzeit des jeweiligen Nutzungsvertrags beschränkte, widerrufliche, nicht-übertragbare Recht zur Nutzung der Plattform sowie der Dienste in der jeweils durch Sharezone zur Verfügung gestellten Version ein. Bei Änderungen der Plattform oder der Dienste durch Sharezone erlöschen an dieser Version gewährte Nutzungsrechte der Nutzer.

Die Nutzer erwerben keinerlei Eigentumsrechte an der Plattform. Sämtliche Rechte an der Plattform und den Diensten verbleiben bei Sharezone.

Die Nutzer sind nicht berechtigt, die Plattform und die Dienste zu kommerziellen Zwecken zu nutzen. Die Nutzung zur Auslesung, Speicherung oder Weitergabe personenbezogener Daten anderer registrierter Nutzer zu anderen Zwecken als der bestimmungsgemäßen Nutzung des Angebots ist verboten.

Die Nutzung der Plattform und der Dienste zu dem Zweck, anderen Nutzern Werbung in jedweder Form zu unterbreiten, ist verboten. Dies bezieht sich auch auf das Setzen von entsprechenden Links und insbesondere auf Werbung für Kettenbriefe, Schenkkreise, Umfragen sowie Pyramiden- und Schneeballsysteme.

### Veröffentlichen von Inhalten

Mit dem Einstellen von Texten und anderen Inhalten erklären sich die Nutzer mit der Speicherung, der Veröffentlichung bzw. dem öffentlichen Zugänglichmachen ihrer Inhalte auf der Plattform und den Diensten einverstanden. Dies bedeutet jedoch keine Verantwortungsübernahme durch Sharezone. Für sämtliche Inhalte bleiben die Nutzer allein verantwortlich. Sharezone stellt insoweit lediglich Speicherplatz zur Verfügung.

Es liegt allein in der Verantwortung der Nutzer, die nötigen Rechte für das Einstellen von Inhalten auf der Plattform und die Dienste von Sharezone zu erwerben.

Das Einverständnis der Nutzer gilt zeitlich unbeschränkt, soweit die Nutzer gegenüber Sharezone keine Umstände nachweisen, die eine weitere Abrufbarkeit der Inhalte als für die Zukunft unzumutbar erscheinen lassen. Nutzer können eigene Inhalte selbst löschen oder ändern.

### Verfügbarkeit der Plattform

Sharezone verpflichtet sich zur Abwicklung des Nutzungsvertrages entsprechend dieser ANB. Sharezone stellt die Plattform in der jeweils vorhandenen Funktion und Form zur Nutzung bereit. Die Nutzer erkennen an, dass eine 100%ige Verfügbarkeit der Plattform und der Dienste technisch nicht zu realisieren ist. Sharezone bemüht sich stets um eine hohe Verfügbarkeit der Plattform, sodass die Funktionen allen Nutzern möglichst jederzeit zur Verfügung stehen. Ebenfalls nehmen die Nutzer zur Kenntnis, dass es bei einer freiwilligen Teilnahme an dem Beta- und Alpha-Programm (weitere Informationen unter https://sharezone.net /beta und https://sharezone.net/alpha) zu deutlich häufigeren Einschränkungen oder sogar Datenverlust kommen kann.

## Pflichten der Nutzer / Nutzerverhalten

Die Nutzer verpflichten sich entsprechend B.3. lit. b+c dieser ANB, die Plattform und die Dienste nicht zu kommerziellen Zwecken und nur im Rahmen der vertraglichen Zweckbestimmung zu nutzen.

Die Nutzer sind verpflichtet, ausschließlich wahre und nicht irreführende Angaben zu machen.

Die Nutzer sind verpflichtet, im Rahmen der Nutzung der Plattform und der Dienste geltendes Recht sowie alle Rechte Dritter zu beachten. Insbesondere ist dem Nutzer Folgendes untersagt:

* Verwendung beleidigender oder verleumderischer Inhalte, unabhängig davon, ob diese Inhalte andere Nutzer, Sharezone und seine Mitarbeiter oder andere Personen oder Unternehmen betreffen;
* Verwendung pornografischer, gewaltverherrlichender, missbräuchlicher, sittenwidriger oder Jugendschutzgesetze verletzender Inhalte oder Bewerbung, Angebot und/oder Vertrieb von pornografischen, gewaltverherrlichenden, missbräuchlichen, sittenwidrigen oder Jugendschutzgesetze verletzenden Waren oder Dienstleistungen;
* Unzumutbare Belästigungen anderer Nutzer, insbesondere durch Spam (§ 7 Gesetz gegen den unlauteren Wettbewerb – UWG);
* Verwendung von gesetzlich (z.B. durch das Urheber-, Marken-, Patent-, Geschmacksmuster- oder Gebrauchsmusterrecht) geschützten Inhalten, ohne dazu berechtigt zu sein, oder Bewerbung, Angebot und/oder Vertrieb von gesetzlich geschützten Waren oder Dienstleistungen, ebenfalls ohne dazu berechtigt zu sein; oder
* Vornahme oder Förderung wettbewerbswidriger Handlungen, einschließlich progressiver Kundenwerbung (wie Kettenbrief-, Schneeball- oder Pyramidensysteme).

Folgende Handlungen sind den Nutzern insbesondere untersagt:

* Verwendung von Mechanismen, Software oder Skripten in Verbindung mit der Nutzung der Plattform oder der Dienste; die direkte oder indirekte Bewerbung oder Verbreitung solcher Mechanismen, Software oder Skripten ist ebenfalls untersagt;
* Blockieren, Überschreiben, Modifizieren, Kopieren, soweit dies nicht für die ordnungs- und vertragsgemäße Nutzung der Plattform oder der Dienste erforderlich ist;
* Verbreitung oder öffentliche Wiedergabe von Inhalten der Plattform oder der Dienste oder von anderen Nutzern, außer die Verbreitung oder öffentliche Wiedergabe ist im Rahmen der ordnungs- und vertragsgemäßen Nutzung der Plattform oder der Dienste vorgesehen oder der andere Nutzer hat der Verbreitung oder der öffentlichen Wiedergabe zugestimmt; oder
* Jede Handlung, die geeignet ist, die Funktionalität der Plattform oder der Dienste zu beeinträchtigen, insbesondere diese übermäßig zu belasten.

Soweit Nutzer eine gesetzes- oder vertragswidrige Benutzung der Plattform oder der Dienste bemerken, können Nutzer dies an Sharezone per E-Mail an support@sharezone.net melden. Sofern und soweit Sharezone Kenntnis von entsprechend gesetzes- oder vertragswidrigen Benutzungen der Plattform oder der Dienste erhält, werden die betroffenen Inhalte, Daten und/oder Informationen durch Sharezone entfernt. Zu diesem Zweck behält sich Sharezone das Recht vor, von den Nutzern veröffentlichte oder zugänglich gemachte Inhalte, Daten und/oder Informationen zu sperren oder zu löschen oder andere geeignete Maßnahmen zu ergreifen.

Sharezone ist berechtigt, von Nutzern veröffentlichte oder zugänglich gemachte Inhalte, Daten und/oder Informationen oder einzelne Nutzer zeitweise zu sperren oder andere geeignete Maßnahmen zu ergreifen, wenn Nutzer gegen geltende Gesetze oder vertragliche Bestimmungen verstoßen. Bei gravierenden oder wiederholten Verstößen einzelner Nutzer ist Sharezone berechtigt, die Inhalte, Daten und/oder Informationen sowie die betreffenden Nutzer dauerhaft zu sperren oder die Inhalte, Daten und/oder Informationen sowie die betreffenden Nutzer zu löschen oder andere geeignete Maßnahmen zu ergreifen. Im Falle der dauerhaften Sperrung oder Löschung eines Nutzers wird Sharezone den betreffenden Nutzer zuvor darauf hinweisen. Entsprechendes gilt für den Fall, dass ein hinreichender Verdacht für solche Verstöße besteht.

Bei schuldhaften Verstößen haften die Nutzer gegenüber Sharezone auf Ersatz sämtlicher daraus entstehender Schäden. Unter diesen Umständen stellen die Nutzer Sharezone auf erstes Anfordern von sämtlichen Ansprüchen Dritter sowie sämtlichen sich daraus ergebenden Kosten frei, die gegen Sharezone geltend gemacht werden. Dies gilt auch für Ansprüche, die gegen gesetzliche Vertreter oder Erfüllungsgehilfen von Sharezone geltend gemacht werden oder Kosten, die diesen entsprechend entstehen. Im Übrigen bleiben weitere Ansprüche vorbehalten.

## Verantwortlichkeit für Inhalte der Nutzer

Sharezone übernimmt keine Haftung für die Verfügbarkeit der Inhalte, die von Nutzern auf der Plattform veröffentlicht oder zugänglich gemacht werden. Um Verluste von Daten, die Nutzer auf der Plattform veröffentlicht oder zugänglich gemacht haben, zu vermeiden, sind die Nutzer verpflichtet, selbständig entsprechende Sicherungskopien zu speichern.

Die Nutzer sind vollumfänglich selbst verantwortlich für sämtliche Inhalte, die sie auf der Plattform oder den Diensten veröffentlicht oder zugänglich gemacht haben. Sharezone übernimmt als Diensteanbieter keinerlei Verantwortung für von Nutzern bereitgestellte Inhalte, Daten und/oder Informationen sowie für Inhalte auf verlinkten Websites. Sharezone gewährleistet insbesondere nicht, dass diese Inhalte wahr sind oder geltendem Recht entsprechen. Soweit Nutzer eine gesetzes- oder vertragswidrige Benutzung der Plattform oder der Dienste bemerken, können Nutzer dies an Sharezone melden.

Sharezone ist nicht verpflichtet, von Nutzern bereitgestellte Inhalte, Daten und/oder Informationen anderen Nutzern zur Verfügung zu stellen, wenn diese Daten und/oder Informationen nicht im Einklang mit den Vorgaben dieser ANB oder geltendem Recht stehen. Sharezone ist berechtigt, nach den Vorgaben der ANB unzulässige Inhalte, Daten und/oder Informationen ohne Vorankündigung gegenüber dem Nutzer von der Plattform zu entfernen.

## Haftung / Freistellungsanspruch

Sharezone haftet gegenüber den Nutzern nur nach Maßgabe der folgenden Bestimmungen. Diese Bestimmungen gelten auch für die Haftung von gesetzlichen Vertretern oder Erfüllungsgehilfen von Sharezone.

Sharezone haftet unbeschränkt

* für Schäden aus der Verletzung des Lebens, des Körpers oder der Gesundheit,
* für Schäden, die durch das Fehlen einer von Sharezone garantierten Beschaffenheit hervorgerufen wurden,
* bei arglistigem, vorsätzlichem oder grob fahrlässigem Verhalten von Sharezone

Für Schäden, die durch eine leicht fahrlässig verursachte Verletzung wesentlicher Vertragspflichten hervorgerufen werden, haftet Sharezone der Höhe nach begrenzt auf denjenigen Schaden, der vertragstypisch vorhersehbar ist. Wesentliche Vertragspflichten sind dabei solche Pflichten, deren Erfüllung die ordnungs- und vertragsgemäße Durchführung des Vertrages erst ermöglicht und auf deren Einhaltung die Vertragsparteien regelmäßig vertrauen dürfen.

Im Übrigen ist eine Haftung von Sharezone ausgeschlossen. Davon bleibt die Haftung nach dem Produkthaftungsgesetz unberührt.

## Beendigung des Nutzungsvertrags / Kündigung

Der Nutzungsvertrag gilt grundsätzlich auf unbestimmte Zeit geschlossen, soweit nicht ausdrücklich Abweichendes bestimmt ist.

Der Nutzungsvertrag kann von beiden Parteien jederzeit ohne Angabe von Gründen durch Kündigung beendet werden. Die Kündigung können Nutzer vornehmen, indem sie ihr Konto löschen. Um das Konto zu löschen, muss ein Nutzer zu den Einstellungen navigieren, nun zu “Mein Konto” und schließlich auf “Konto löschen” drücken. Eine detaillierte Anleitung kann unter folgendem Link abgerufen werden: https://sharezone.net/delete-account. Im Falle der Kündigung durch einen Nutzer kann Sharezone zum Schutz des Nutzers gegen eine unbefugte Löschung seines Nutzungsprofils durch Dritte eine Identitätsverifikation des Nutzers verlangen.

Beide Parteien haben das Recht, den Nutzungsvertrag bei Vorliegen eines wichtigen Grundes jederzeit ohne Einhaltung einer Frist außerordentlich zu kündigen. Ein wichtiger Grund liegt insbesondere vor, wenn die Fortsetzung des Nutzungsverhältnisses bis zum Ablauf der ordentlichen Kündigungsfrist für die kündigende Partei unter Berücksichtigung sämtlicher Umstände des Einzelfalls und unter Abwägung der beiderseitigen Interessen unzumutbar ist. Sharezone ist insbesondere unter folgenden Voraussetzungen zu einer außerordentlichen Kündigung berechtigt:

* Verstoß gegen gesetzliche oder wesentliche vertragliche Pflichten durch einen Nutzer;
* Wesentliche Rufschädigung bezüglich Sharezone durch einen Nutzer;
* Im Falle der Schädigung anderer Nutzer durch einen Nutzer;
* Im Falle der Mitgliedschaft eines Nutzers in einer verbotenen Partei, einer Terrororganisation oder einer das Allgemeinwohl schädigenden Gemeinschaft.

Im Falle einer Kündigung ist Sharezone berechtigt, von dem betreffenden Nutzer veröffentlichte oder zugänglich gemachte Inhalte, Daten und/oder Informationen zu löschen. Sharezone ist nicht zu einer Herausgabe der von einem Nutzer veröffentlichten oder zugänglich gemachten Inhalte, Daten und/oder Informationen verpflichtet.

## Änderungen der Allgemeinen Nutzungsbedingungen

Sharezone behält sich das Recht vor, diese Allgemeinen Nutzungsbedingungen jederzeit teilweise oder ganz zu ändern oder zu erweitern, soweit Nutzer dadurch nicht unangemessenen benachteiligt werden. Sharezone wird die Nutzer rechtzeitig in geeigneter und angemessener Form, zum Beispiel per E-Mail, Push-Nachricht oder beim Einloggen auf der Plattform, über geplante Änderungen informieren, bevor diese in Kraft treten. Im Falle von Änderungen der Allgemeinen Nutzungsbedingungen haben Nutzer das Recht, den Nutzungsvertrag mit Sharezone ohne Einhaltung einer Frist zu kündigen. Die Änderungen der Allgemeinen Nutzungsbedingungen gelten als durch die Nutzer genehmigt, wenn die Nutzer die Plattform oder die Dienste nach Inkrafttreten der Änderungen weiter nutzen. Sharezone wird die Nutzer auf diese Folge hinweisen.

## Datenschutz

Im Rahmen der Nutzung der Plattform und der Dienste verarbeitet Sharezone auch personenbezogene Daten. Informationen über die Datenverarbeitungen enthalten unsere Datenschutzbestimmungen (https://sharezone.net/datenschutzerklaerung)

## Schlussbestimmungen

Sharezone ist berechtigt, Erklärungen gegenüber den Nutzern auch auf elektronischem Wege (z.B. per E-Mail) zu übermitteln.

Sharezone ist berechtigt, Rechte oder Pflichten aus dem Nutzungsvertrag ganz oder teilweise auf Dritte zu übertragen.

Änderungen dieser Bedingungen einschließlich dieser Klausel bedürfen der Textform.

Sollte eine Bestimmung dieser Bedingungen nichtig oder anfechtbar oder aus einem sonstigen Grunde unwirksam sein, so bleiben die übrigen Bestimmungen dennoch wirksam. Es ist den Parteien bekannt, dass nach der Rechtsprechung des Bundesgerichtshofs eine salvatorische Klausel lediglich zu einer Beweislastumkehr führt. Es ist jedoch die ausdrückliche Absicht der Parteien, die Gültigkeit der verbleibenden Bestimmungen in jedem Fall zu erhalten und demgemäß die Anwendbarkeit von § 139 BGB insgesamt auszuschließen. In einem solchen Fall gilt dasjenige als zwischen den Parteien als vereinbart, was diese vereinbart hätten, wenn sie die Unwirksamkeit der Bestimmung gekannt hätten.

Sharezone ist zur Teilnahme an einer alternativen Streitbeilegung nicht verpflichtet und nimmt auch nicht freiwillig daran teil.

Es gilt deutsches Recht unter Ausschluss des UN-Kaufrechts.

Bei Verbrauchern gilt die vorstehend genannte Rechtswahl nur insoweit, als nicht der gewährte Schutz durch zwingende Bestimmungen des Rechts des Staates, in dem der Verbraucher seinen gewöhnlichen Aufenthalt hat, entzogen wird.

Gerichtsstand für Streitigkeiten aus dem Nutzungsverhältnis gegenüber Kaufleuten, juristischen Personen des öffentlichen Rechts oder öffentlich-rechtlicher Sondervermögen aus Verträgen, ist der Sitz von Sharezone.
''';
