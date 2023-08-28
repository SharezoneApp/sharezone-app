// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/groups/src/widgets/contact_support.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

TextStyle _descriptionStyle(BuildContext context) => TextStyle(
      color: context.isDarkThemeEnabled ? Colors.grey[300] : Colors.grey[700],
      fontSize: 16,
    );

class CourseHelpPage extends StatelessWidget {
  static const String tag = "course-help-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hilfe: Gruppen"), centerTitle: true),
      body: SingleChildScrollView(child: CourseHelpInnerPage()),
      bottomNavigationBar: ContactSupport(),
    );
  }
}

class CourseHelpInnerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _WhatIsAPublicKey(),
          _HowToJoinAGroup(),
          _WhyHasEveryMemberOfAGroupADifferentSharecode(),
          _WhatIsTheDifferenceBetweenAGroupACourseAndASchoolClass(),
          _GroupRolesExplained(),
        ],
      ),
    );
  }
}

class _WhatIsAPublicKey extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const ExpansionTileTitle(
        title: 'Was ist ein Sharecode?',
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16)
              .add(const EdgeInsets.only(bottom: 16)),
          child: Text(
            "Der Sharecode ist ein Zugangsschlüssel für einen Kurs. Mit diesem "
            "können Mitschüler und Lehrer dem Kurs beitreten."
            ""
            "\n\nDank des Sharecodes "
            "braucht es kein Austauschen persönlicher Daten, wie z.B. der E-Mail Adresse oder der privaten "
            "Handynummer, unter den Kursmitgliedern - anders als es z.B. bei WhatsApp-Gruppen oder den "
            "meisten E-Mail Verteilern der Fall ist."
            ""
            "\n\nEin Kursmitglied sieht nur den Namen (kann auch ein Pseudonym sein) der anderen "
            "Kursmitglieder.",
            style: _descriptionStyle(context),
          ),
        )
      ],
    );
  }
}

class _HowToJoinAGroup extends StatefulWidget {
  @override
  _HowToJoinAGroupState createState() => _HowToJoinAGroupState();
}

class _HowToJoinAGroupState extends State<_HowToJoinAGroup> {
  Color? _svgColor = Colors.grey[600];
  Color? _typeInPublicKeyIconColor = Colors.grey[600];

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: ExpansionTileTitle(title: "Wie trete ich einer Gruppe bei?"),
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Um einer Gruppe von deinen Mitschüler oder Lehrern beizutreten, gibt es zwei "
              "Möglichkeiten:"
              ""
              "\n\n1. Sharecode über einen QR-Code scannen"
              "\n2. Händisch den Sharecode eingeben",
              style: _descriptionStyle(context),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ExpansionTile(
          title: ExpansionTileTitle(
            title: "Sharecode mit einem QR-Code scannen",
            icon: Padding(
              padding: const EdgeInsets.only(left: 2),
              child: PlatformSvg.asset(
                "assets/icons/qr-code.svg",
                color: _svgColor,
                width: 20,
                height: 20,
              ),
            ),
          ),
          onExpansionChanged: (value) {
            if (value)
              setState(() {
                // Expansion is open: so let's make the svg black
                _svgColor = isDarkThemeEnabled(context)
                    ? Colors.white
                    : Theme.of(context).colorScheme.secondary;
              });
            else
              // Expansion is closed: so let's make the svg grey
              setState(() {
                _svgColor = Colors.grey[600];
              });
          },
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16)
                  .add(const EdgeInsets.only(bottom: 16)),
              child: Column(
                children: <Widget>[
                  Text(
                    "1. Eine Person, die sich schon in diesem Kurs befindet, klickt unter der "
                    "Seite \"Gruppe\" auf den gewünschten Kurs.\n"
                    "2. Diese Person klickt nun auf den Button \"QR-Code anzeigen\".\n"
                    "3. Nun öffnet sich unten eine neue Anzeige mit einem QR-Code.\n"
                    "4. Die Person, die dem Kurs beitreten möchte, klickt unten auf der Seite \"Gruppen\" auf den roten Button.\n"
                    "5. Als nächstes wählt die Person \"Kurs/Klasse beitreten\".\n"
                    "6. Jetzt öffnet sich ein Fenster - dort klickt der Nutzer auf die blaue Grafik, um den QR-Code zu scannen.\n"
                    "7. Abschließend nur noch die Kamera auf den QR-Code der anderen Person halten.",
                    style: _descriptionStyle(context),
                  ),
                ],
              ),
            )
          ],
        ),
        ExpansionTile(
          title: ExpansionTileTitle(
            title: "Händisch den Sharecode eingeben",
            icon: Icon(Icons.keyboard, color: _typeInPublicKeyIconColor),
          ),
          onExpansionChanged: (value) {
            if (value)
              setState(() {
                // Expansion is open: so let's make the svg black
                _typeInPublicKeyIconColor = isDarkThemeEnabled(context)
                    ? Colors.white
                    : Theme.of(context).colorScheme.secondary;
              });
            else
              // Expansion is closed: so let's make the svg grey
              setState(() {
                _typeInPublicKeyIconColor = Colors.grey[600];
              });
          },
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16)
                  .add(const EdgeInsets.only(bottom: 16)),
              child: Text(
                "1. Eine Person, die sich schon in diesem Kurs befindet, klickt unter der "
                "Seite \"Gruppen\" auf den gewünschten Kurs.\n"
                "2. Auf dieser Seite wird nun direkt unter dem Kursnamen der Sharecode angezeigt.\n"
                "3. Die Person, die dem Kurs beitreten möchte, klickt unten auf der Seite \"Gruppen\" auf den roten Button.\n"
                "4. Als nächstes wählt die Person \"Kurs/Klasse beitreten\".\n"
                "5. Jetzt öffnet sich ein Fenster - dort muss dann nur noch der Sharecode von der anderen Person in das Textfeld unten eingeben werden.\n",
                style: _descriptionStyle(context),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class _WhyHasEveryMemberOfAGroupADifferentSharecode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const ExpansionTileTitle(
        title:
            'Warum hat jeder Teilnehmer aus einer Gruppe einen anderen Sharecode?',
      ),
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              "Jeder Teilnehmer aus einem Kurs hat einen individuellen Sharecode.\n\n"
              "Das hat den Grund, dass getrackt werden kann, welcher Nutzer wen eingeladen hat.\n\n"
              "Dank dieser Funktion zählen auch Weiterempfehlungen ohne die Verwendung eines "
              "Empfehlunglinks.",
              style: _descriptionStyle(context),
            ),
          ),
        )
      ],
    );
  }
}

class _WhatIsTheDifferenceBetweenAGroupACourseAndASchoolClass
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const ExpansionTileTitle(
        title:
            'Was ist der Unterschied zwischen einer Gruppe, einem Kurs und einer Schulklasse?',
      ),
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              "Kurs: Spiegelt ein Schulfach wieder.\n\n"
              "Schulklasse: Besteht aus mehreren Kursen und ermöglicht das Beitreten all dieser Kurse mit nur einem Sharecode.\n\n"
              "Gruppe: Ist der Oberbegriff für einen Kurs und eine Schulklasse.",
              style: _descriptionStyle(context),
            ),
          ),
        )
      ],
    );
  }
}

class _GroupRolesExplained extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const ExpansionTileTitle(
        title:
            'Gruppenrollen erklärt: Was ist ein passives Mitglied, aktives Mitglied, Administrator?',
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            "Administrator:\n"
            "Ein Admin verwaltet eine Gruppe. Das bedeutet, dass er diese bearbeiten, löschen und Teilnehmer rauswerfen kann. "
            "Zudem kann ein Admin alle weiteren Einstellungen für die Gruppe treffen, wie z.B. das Beitreten "
            "aktivieren/deaktivieren.\n\n"
            ""
            "Aktives Mitglied:\n"
            "Ein aktives Mitglied in einer Gruppe darf Inhalte erstellen und bearbeiten, sprich Hausaufgaben eintragen, "
            "Termine eintragen, Schulstunden bearbeiten, etc. Er hat somit Schreib- und Leserechte.\n\n"
            ""
            "Passives Mitglied:\n"
            "Ein passives Mitglied in einer Gruppe hat ausschließlich Leserechte. Somit dürfen keine Inhalte erstellt oder bearbeitet werden.",
            style: _descriptionStyle(context),
          ),
        )
      ],
    );
  }
}
