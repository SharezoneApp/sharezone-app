// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

enum StateEnum {
  // Caution! If adding value it also has to be added in many other places.
  badenWuerttemberg,
  bayern,
  berlin,
  brandenburg,
  bremen,
  hamburg,
  hessen,
  mecklenburgVorpommern,
  niedersachsen,
  nordrheinWestfalen,
  rheinlandPfalz,
  saarland,
  sachsen,
  sachsenAnhalt,
  schleswigHolstein,
  thueringen,
  notFromGermany,
  anonymous,
  notSelected;

  String getDisplayName(BuildContext context) {
    return switch (this) {
      StateEnum.badenWuerttemberg => context.l10n.stateBadenWuerttemberg,
      StateEnum.bayern => context.l10n.stateBayern,
      StateEnum.berlin => context.l10n.stateBerlin,
      StateEnum.brandenburg => context.l10n.stateBrandenburg,
      StateEnum.bremen => context.l10n.stateBremen,
      StateEnum.hamburg => context.l10n.stateHamburg,
      StateEnum.hessen => context.l10n.stateHessen,
      StateEnum.mecklenburgVorpommern =>
        context.l10n.stateMecklenburgVorpommern,
      StateEnum.niedersachsen => context.l10n.stateNiedersachsen,
      StateEnum.nordrheinWestfalen => context.l10n.stateNordrheinWestfalen,
      StateEnum.rheinlandPfalz => context.l10n.stateRheinlandPfalz,
      StateEnum.saarland => context.l10n.stateSaarland,
      StateEnum.sachsen => context.l10n.stateSachsen,
      StateEnum.sachsenAnhalt => context.l10n.stateSachsenAnhalt,
      StateEnum.schleswigHolstein => context.l10n.stateSchleswigHolstein,
      StateEnum.thueringen => context.l10n.stateThueringen,
      StateEnum.notFromGermany => context.l10n.stateNotFromGermany,
      StateEnum.anonymous => context.l10n.stateAnonymous,
      StateEnum.notSelected => context.l10n.stateNotSelected,
    };
  }
}

const Map<StateEnum, String> stateEnumToString = {
  StateEnum.badenWuerttemberg: "Baden-Württemberg",
  StateEnum.bayern: "Bayern",
  StateEnum.berlin: "Berlin",
  StateEnum.brandenburg: "Brandenburg",
  StateEnum.bremen: "Bremen",
  StateEnum.hamburg: "Hamburg",
  StateEnum.hessen: "Hessen",
  StateEnum.mecklenburgVorpommern: "Mecklenburg-Vorpommern",
  StateEnum.niedersachsen: "Niedersachsen",
  StateEnum.nordrheinWestfalen: "Nordrhein-Westfalen",
  StateEnum.rheinlandPfalz: "Rheinland-Pfalz",
  StateEnum.saarland: "Saarland",
  StateEnum.sachsen: "Sachsen",
  StateEnum.sachsenAnhalt: "Sachsen-Anhalt",
  StateEnum.schleswigHolstein: "Schleswig-Holstein",
  StateEnum.thueringen: "Thüringen",
  StateEnum.notFromGermany: "Nicht aus Deutschland",
  StateEnum.anonymous: "Anonym bleiben",
  StateEnum.notSelected: "Nicht ausgewählt",
};
