// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/homework/shared/shared.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

/// Show animated Game Controller
class GameController extends StatelessWidget {
  const GameController({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderWidgetWithAnimation(
      iconSize: Size(175, 175),
      title: "Jetzt ist Zeit für die wirklich wichtigen Dinge im Leben! 🤘💪",
      description: Column(
        children: <Widget>[
          Text("Sehr gut! Du hast keine Hausaufgaben zu erledigen"),
          SizedBox(height: 12),
          AddHomeworkCard(),
        ],
      ),
      svgPath: 'assets/icons/game-controller.svg',
      animateSVG: true,
    );
  }
}

/// Show animated fire --> user should be motivated to do his homeworks
class FireMotivation extends StatelessWidget {
  const FireMotivation({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderWidgetWithAnimation(
      iconSize: Size(175, 175),
      title: "AUF GEHT'S! 💥👊",
      description: Text(
          "Du musst noch die Hausaufgaben erledigen! Also schau mich nicht weiter an und erledige die Aufgaben! Do it!"),
      svgPath: 'assets/icons/fire.svg',
      animateSVG: true,
    );
  }
}
