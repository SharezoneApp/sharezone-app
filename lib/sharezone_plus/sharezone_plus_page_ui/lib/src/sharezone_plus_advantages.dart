// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class SharezonePlusAdvantages extends StatelessWidget {
  const SharezonePlusAdvantages({
    super.key,
    required this.isHomeworkReminderFeatureVisible,
    required this.isHomeworkDoneListsFeatureVisible,
    this.onOpenedAdvantage,
    this.onGitHubOpen,
  });

  final bool isHomeworkReminderFeatureVisible;
  final bool isHomeworkDoneListsFeatureVisible;
  final ValueChanged<String>? onOpenedAdvantage;
  final VoidCallback? onGitHubOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Grades(onOpen: onOpenedAdvantage),
        _MoreColors(onOpen: onOpenedAdvantage),
        _QuickHomeworkDueDate(onOpen: onOpenedAdvantage),
        if (isHomeworkReminderFeatureVisible)
          _HomeworkReminder(onOpen: onOpenedAdvantage),
        _Substitutions(onOpen: onOpenedAdvantage),
        _PastEvents(onOpen: onOpenedAdvantage),
        _AddEventsToLocalCalendar(onOpen: onOpenedAdvantage),
        _IcalFeature(onOpen: onOpenedAdvantage),
        if (isHomeworkDoneListsFeatureVisible)
          _HomeworkDoneLists(onOpen: onOpenedAdvantage),
        _ReadByInformationSheets(onOpen: onOpenedAdvantage),
        _SelectTimetableBySchoolClass(onOpen: onOpenedAdvantage),
        _MoreStorage(onOpen: onOpenedAdvantage),
        _PlusSupport(onOpen: onOpenedAdvantage),
        _DiscordPlusRang(onOpen: onOpenedAdvantage),
        _SupportOpenSource(
          onOpen: onOpenedAdvantage,
          onGitHubOpen: onGitHubOpen,
        ),
      ],
    );
  }
}

class _Grades extends StatelessWidget {
  const _Grades({
    required this.onOpen,
  });

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('grades');
      },
      icon: const Icon(Icons.emoji_events),
      title: const Text('Noten'),
      description: const Text(
          'Speichere deine Schulnoten mit Sharezone Plus und behalte den Überblick über deine Leistungen. Schriftliche Prüfungen, mündliche Mitarbeit, Halbjahresnoten - alles an einem Ort.'),
    );
  }
}

class _MoreColors extends StatelessWidget {
  const _MoreColors({
    required this.onOpen,
  });

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('more_colors');
      },
      icon: const Icon(Icons.color_lens),
      title: const Text('Mehr Farben für die Gruppen'),
      description: const Text(
          'Sharezone Plus bietet dir über 200 (statt 19) Farben für deine Gruppen. Setzt du mit Sharezone Plus eine Farbe für deine Gruppe, so können auch deine Gruppenmitglieder diese Farbe sehen.'),
    );
  }
}

class _SelectTimetableBySchoolClass extends StatelessWidget {
  const _SelectTimetableBySchoolClass({
    required this.onOpen,
  });

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('select_timetable_by_school_class');
      },
      icon: const Icon(Icons.calendar_month),
      title: const Text('Stundenplan nach Klasse auswählen'),
      description: const Text(
          'Du bist in mehreren Klassen? Mit Sharezone Plus kannst du den Stundenplan für jede Klasse einzeln auswählen. So siehst du immer den richtigen Stundenplan.'),
    );
  }
}

class _Substitutions extends StatelessWidget {
  const _Substitutions({
    required this.onOpen,
  });

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('substitutions');
      },
      icon: const Icon(Icons.cancel),
      title: const Text('Vertretungsplan'),
      description: const MarkdownBody(
        data: '''Schalte mit Sharezone Plus den Vertretungsplan frei:
* Entfall einer Schulstunden markieren
* Raumänderungen

Sogar Kursmitglieder ohne Sharezone Plus können den Vertretungsplan einsehen (jedoch nicht ändern). Ebenfalls können Kursmitglieder mit nur einem 1-Klick über die Änderung informiert werden. 

Beachte, dass der Vertretungsplan manuell eingetragen werden muss und nicht automatisch importiert wird.''',
      ),
    );
  }
}

class _PastEvents extends StatelessWidget {
  const _PastEvents({
    required this.onOpen,
  });

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('past_events');
      },
      icon: const Icon(Icons.history),
      title: const Text('Vergangene Termine einsehen'),
      description: const Text(
          'Mit Sharezone Plus kannst du alle vergangenen Termine, wie z.B. Prüfungen, einsehen.'),
    );
  }
}

class _AddEventsToLocalCalendar extends StatelessWidget {
  const _AddEventsToLocalCalendar({
    required this.onOpen,
  });

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('add_events_to_calendar');
      },
      icon: const Icon(Icons.calendar_today),
      title: const Text('Termine zum lokalen Kalender hinzufügen'),
      description: const Text(
          'Füge mit nur einem Klick einen Termin zu deinem lokalen Kalender hinzu (z.B. Apple oder Google Kalender).\n\nBeachte, dass die Funktion nur auf Android & iOS verfügbar ist. Zudem aktualisiert sich der Termin in deinem Kalender nicht automatisch, wenn dieser in Sharezone geändert wird.'),
    );
  }
}

class _IcalFeature extends StatelessWidget {
  const _IcalFeature({
    required this.onOpen,
  });

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('ical_links');
      },
      icon: const Icon(Icons.link),
      title: const Text('Stundenplan exportieren (iCal)'),
      description: const Text(
          'Mit einem iCal-Link kannst du deinen Stundenplan und deine Termine in andere Kalender-Apps (wie z.B. Google Kalender, Apple Kalender) einbinden. Sobald sich dein Stundenplan oder deine Termine ändern, werden diese auch in deinen anderen Kalender Apps aktualisiert.\n\nAnders als beim "Zum Kalender hinzufügen" Button, musst du dich nicht darum kümmern, den Termin in deiner Kalender App zu aktualisieren, wenn sich etwas in Sharezone ändert.\n\niCal-Links ist nur für dich sichtbar und können nicht von anderen Personen eingesehen werden.\n\nBitte beachte, dass aktuell nur Termine und Prüfungen exportiert werden können. Die Schulstunden können noch nicht exportiert werden.'),
    );
  }
}

class _MoreStorage extends StatelessWidget {
  const _MoreStorage({
    required this.onOpen,
  });

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('more_storage');
      },
      icon: const Icon(Icons.storage),
      title: const Text('30 GB Speicherplatz'),
      description: const Text(
          'Mit Sharezone Plus erhältst du 30 GB Speicherplatz (statt 100 MB) für deine Dateien & Anhänge (bei Hausaufgaben & Infozetteln). Dies entspricht ca. 15.000 Fotos (2 MB pro Bild).\n\nDie Begrenzung gilt nicht für Dateien, die als Abgabe bei Hausaufgaben hochgeladen wird.'),
    );
  }
}

class _PlusSupport extends StatelessWidget {
  const _PlusSupport({
    required this.onOpen,
  });

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('support');
      },
      icon: const Icon(Icons.support_agent),
      title: const Text('Premium Support'),
      description: const MarkdownBody(
        data:
            '''Mit Sharezone Plus erhältst du Zugriff auf unseren Premium Support:
- Innerhalb von wenigen Stunden eine Rückmeldung per E-Mail (anstatt bis zu 2 Wochen)
- Videocall-Support nach Terminvereinbarung (ermöglicht das Teilen des Bildschirms)''',
      ),
    );
  }
}

class _HomeworkReminder extends StatelessWidget {
  const _HomeworkReminder({
    required this.onOpen,
  });

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('homework_reminder');
      },
      icon: const Icon(Icons.notifications),
      title: const Text('Individuelle Uhrzeit für Hausaufgaben-Erinnerungen'),
      description: const Text(
          'Mit Sharezone Plus kannst du die Erinnerung am Vortag für die Hausaufgaben individuell im 30-Minuten-Tack einstellen, z.B. 15:00 oder 15:30 Uhr. Dieses Feature ist nur für Schüler*innen verfügbar.'),
    );
  }
}

class _HomeworkDoneLists extends StatelessWidget {
  const _HomeworkDoneLists({
    required this.onOpen,
  });

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('homework_done_lists');
      },
      icon: const Icon(Icons.checklist),
      title: const Text('Erledigt-Status bei Hausaufgaben'),
      description: const Text(
          'Erhalte eine Liste mit allen Schüler*innen samt Erledigt-Status für jede Hausaufgabe. Dieses Feature ist nur für Lehrkräfte verfügbar.'),
    );
  }
}

class _ReadByInformationSheets extends StatelessWidget {
  const _ReadByInformationSheets({
    required this.onOpen,
  });

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('read_by_information_sheets');
      },
      icon: const Icon(Icons.format_list_bulleted),
      title: const Text('Gelesen-Status bei Infozetteln'),
      description: const Text(
          'Erhalte eine Liste mit allen Gruppenmitgliedern samt Lesestatus für jeden Infozettel - und stelle somit sicher, dass wichtige Informationen bei allen Mitgliedern angekommen sind.'),
    );
  }
}

class _DiscordPlusRang extends StatelessWidget {
  const _DiscordPlusRang({
    required this.onOpen,
  });

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('discord_plus_rang');
      },
      icon: const Icon(Icons.discord),
      title: const Text('Discord Sharezone Plus Rang'),
      description: MarkdownBody(
        data:
            'Erhalte den Discord Sharezone Plus Rang auf unserem [Discord-Server](https://sharezone.net/discord). Dieser Rang zeigt, dass du Sharezone Plus hast und gibt dir Zugriff auf einen exklusive Channel nur für Sharezone Plus Nutzer.',
        styleSheet: MarkdownStyleSheet(
          a: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).primaryColor,
                decoration: TextDecoration.underline,
              ),
        ),
        onTapLink: (text, href, title) async {
          if (href == null) return;
          await launchUrl(Uri.parse(href));
        },
      ),
    );
  }
}

class _SupportOpenSource extends StatelessWidget {
  const _SupportOpenSource({
    required this.onOpen,
    required this.onGitHubOpen,
  });

  final ValueChanged<String>? onOpen;
  final VoidCallback? onGitHubOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('open_source');
      },
      icon: const Icon(Icons.favorite),
      title: const Text('Unterstützung von Open-Source'),
      description: MarkdownBody(
        data:
            'Sharezone ist Open-Source im Frontend. Das bedeutet, dass jeder den Quellcode von Sharezone einsehen und sogar verbessern kann. Wir glauben, dass Open-Source die Zukunft ist und wollen Sharezone zu einem Vorzeigeprojekt machen.\n\nGitHub: [https://github.com/SharezoneApp/sharezone-app](https://sharezone.net/github)',
        styleSheet: MarkdownStyleSheet(
          a: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).primaryColor,
                decoration: TextDecoration.underline,
              ),
        ),
        onTapLink: (text, href, title) async {
          if (href == null) return;
          if (onGitHubOpen != null) {
            onGitHubOpen!();
          }
          await launchUrl(Uri.parse(href));
        },
      ),
    );
  }
}

class _QuickHomeworkDueDate extends StatelessWidget {
  const _QuickHomeworkDueDate({
    required this.onOpen,
  });

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('smart_homework_due_date');
      },
      icon: const Icon(Icons.check_box),
      title: const Text('Schnellauswahl für Fälligkeitsdatum'),
      description: const Text(
          'Mit Sharezone Plus kannst du das Fälligkeitsdatum einer Hausaufgaben mit nur einem Fingertipp auf den nächsten Schultag oder eine beliebige Stunde in der Zukunft setzen.'),
    );
  }
}

class _AdvantageTile extends StatelessWidget {
  const _AdvantageTile({
    required this.icon,
    required this.title,
    // Can be removed when the subtitle is used.
    //
    // ignore: unused_element
    this.subtitle,
    required this.description,
    required this.onOpen,
  });

  final Icon icon;
  final Widget title;
  final Widget? subtitle;
  final Widget description;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF6FCF97);
    return ExpansionCard(
      onOpen: onOpen,
      header: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconTheme(
                data: const IconThemeData(color: green),
                child: icon,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                if (subtitle != null)
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyMedium!,
                    child: subtitle!,
                  ),
              ],
            ),
          ),
        ],
      ),
      body: description,
      backgroundColor: Colors.transparent,
    );
  }
}
