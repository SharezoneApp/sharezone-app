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
  });

  final bool isHomeworkReminderFeatureVisible;
  final bool isHomeworkDoneListsFeatureVisible;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Grades(),
        const _MoreColors(),
        if (isHomeworkReminderFeatureVisible) const _HomeworkReminder(),
        const _PastEvents(),
        const _AddEventsToLocalCalendar(),
        if (isHomeworkDoneListsFeatureVisible) const _HomeworkDoneLists(),
        const _ReadByInformationSheets(),
        const _SelectTimetableBySchoolClass(),
        const _MoreStorage(),
        const _PlusSupport(),
        const _DiscordPlusRang(),
        const _SupportOpenSource(),
      ],
    );
  }
}

class _Grades extends StatelessWidget {
  const _Grades();

  @override
  Widget build(BuildContext context) {
    return const _AdvantageTile(
      icon: Icon(Icons.emoji_events),
      title: Text('Noten'),
      description: Text(
          'Speichere deine Schulnoten mit Sharezone Plus und behalte den Überblick über deine Leistungen. Schriftliche Prüfungen, mündliche Mitarbeit, Halbjahresnoten - alles an einem Ort.'),
    );
  }
}

class _MoreColors extends StatelessWidget {
  const _MoreColors();

  @override
  Widget build(BuildContext context) {
    return const _AdvantageTile(
      icon: Icon(Icons.color_lens),
      title: Text('Mehr Farben für die Gruppen'),
      description: Text(
          'Sharezone Plus bietet dir über 200 (statt 19) Farben für deine Gruppen. Setzt du mit Sharezone Plus eine Farbe für deine Gruppe, so können auch deine Gruppenmitglieder diese Farbe sehen.'),
    );
  }
}

class _SelectTimetableBySchoolClass extends StatelessWidget {
  const _SelectTimetableBySchoolClass();

  @override
  Widget build(BuildContext context) {
    return const _AdvantageTile(
      icon: Icon(Icons.calendar_month),
      title: Text('Stundenplan nach Klasse auswählen'),
      description: Text(
          'Du bist in mehreren Klassen? Mit Sharezone Plus kannst du den Stundenplan für jede Klasse einzeln auswählen. So siehst du immer den richtigen Stundenplan.'),
    );
  }
}

class _PastEvents extends StatelessWidget {
  const _PastEvents();

  @override
  Widget build(BuildContext context) {
    return const _AdvantageTile(
      icon: Icon(Icons.history),
      title: Text('Vergangene Termine einsehen'),
      description: Text(
          'Mit Sharezone Plus kannst du alle vergangenen Termine, wie z.B. Prüfungen, einsehen.'),
    );
  }
}

class _AddEventsToLocalCalendar extends StatelessWidget {
  const _AddEventsToLocalCalendar();

  @override
  Widget build(BuildContext context) {
    return const _AdvantageTile(
      icon: Icon(Icons.calendar_today),
      title: Text('Termine zum lokalen Kalender hinzufügen'),
      description: Text(
          'Füge mit nur einem Klick einen Termin zu deinem lokalen Kalender hinzu (z.B. Apple oder Google Kalender).\n\nBeachte, dass die Funktion nur auf Android & iOS verfügbar ist. Zudem aktualisiert sich der Termin in deinem Kalender nicht automatisch, wenn dieser in Sharezone geändert wird.'),
    );
  }
}

class _MoreStorage extends StatelessWidget {
  const _MoreStorage();

  @override
  Widget build(BuildContext context) {
    return const _AdvantageTile(
      icon: Icon(Icons.storage),
      title: Text('30 GB Speicherplatz'),
      description: Text(
          'Mit Sharezone Plus erhältst du 30 GB Speicherplatz (statt 100 MB) für deine Dateien & Anhänge (bei Hausaufgaben & Infozetteln). Dies entspricht ca. 15.000 Fotos (2 MB pro Bild).\n\nDie Begrenzung gilt nicht für Dateien, die als Abgabe bei Hausaufgaben hochgeladen wird.'),
    );
  }
}

class _PlusSupport extends StatelessWidget {
  const _PlusSupport();

  @override
  Widget build(BuildContext context) {
    return const _AdvantageTile(
      icon: Icon(Icons.support_agent),
      title: Text('Premium Support'),
      description: MarkdownBody(
        data:
            '''Mit Sharezone Plus erhältst du Zugriff auf unseren Premium Support:
- Innerhalb von wenigen Stunden eine Rückmeldung per E-Mail (anstatt bis zu 2 Wochen)
- Videocall-Support nach Terminvereinbarung (ermöglicht das Teilen des Bildschirms)''',
      ),
    );
  }
}

class _HomeworkReminder extends StatelessWidget {
  const _HomeworkReminder();

  @override
  Widget build(BuildContext context) {
    return const _AdvantageTile(
      icon: Icon(Icons.notifications),
      title: Text('Individuelle Uhrzeit für Hausaufgaben-Erinnerungen'),
      description: Text(
          'Mit Sharezone Plus kannst du die Erinnerung am Vortag für die Hausaufgaben individuell im 30-Minuten-Tack einstellen, z.B. 15:00 oder 15:30 Uhr. Dieses Feature ist nur für Schüler*innen verfügbar.'),
    );
  }
}

class _HomeworkDoneLists extends StatelessWidget {
  const _HomeworkDoneLists();

  @override
  Widget build(BuildContext context) {
    return const _AdvantageTile(
      icon: Icon(Icons.checklist),
      title: Text('Erledigt-Status bei Hausaufgaben'),
      description: Text(
          'Erhalte eine Liste mit allen Schüler*innen samt Erledigt-Status für jede Hausaufgabe. Dieses Feature ist nur für Lehrkräfte verfügbar.'),
    );
  }
}

class _ReadByInformationSheets extends StatelessWidget {
  const _ReadByInformationSheets();

  @override
  Widget build(BuildContext context) {
    return const _AdvantageTile(
      icon: Icon(Icons.format_list_bulleted),
      title: Text('Gelesen-Status bei Infozetteln'),
      description: Text(
          'Erhalte eine Liste mit allen Gruppenmitgliedern samt Lesestatus für jeden Infozettel - und stelle somit sicher, dass wichtige Informationen bei allen Mitgliedern angekommen sind.'),
    );
  }
}

class _DiscordPlusRang extends StatelessWidget {
  const _DiscordPlusRang();

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
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
  const _SupportOpenSource();

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
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
          await launchUrl(Uri.parse(href));
        },
      ),
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
  });

  final Icon icon;
  final Widget title;
  final Widget? subtitle;
  final Widget description;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF6FCF97);
    return ExpansionCard(
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
