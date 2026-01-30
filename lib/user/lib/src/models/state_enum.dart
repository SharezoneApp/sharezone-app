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
  notSelected,
  burgenland,
  kaernten,
  niederoesterreich,
  oberoesterreich,
  salzburg,
  steiermark,
  tirol,
  vorarlberg,
  wien,
  aargau,
  appenzellAusserrhoden,
  appenzellInnerrhoden,
  baselLandschaft,
  baselStadt,
  bern,
  fribourg,
  geneva,
  glarus,
  graubuenden,
  jura,
  luzern,
  neuchatel,
  nidwalden,
  obwalden,
  schaffhausen,
  schwyz,
  solothurn,
  stGallen,
  thurgau,
  ticino,
  uri,
  valais,
  vaud,
  zug,
  zurich;

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
      StateEnum.burgenland => context.l10n.stateBurgenland,
      StateEnum.kaernten => context.l10n.stateKaernten,
      StateEnum.niederoesterreich => context.l10n.stateNiederoesterreich,
      StateEnum.oberoesterreich => context.l10n.stateOberoesterreich,
      StateEnum.salzburg => context.l10n.stateSalzburg,
      StateEnum.steiermark => context.l10n.stateSteiermark,
      StateEnum.tirol => context.l10n.stateTirol,
      StateEnum.vorarlberg => context.l10n.stateVorarlberg,
      StateEnum.wien => context.l10n.stateWien,
      StateEnum.aargau => context.l10n.stateAargau,
      StateEnum.appenzellAusserrhoden =>
        context.l10n.stateAppenzellAusserrhoden,
      StateEnum.appenzellInnerrhoden => context.l10n.stateAppenzellInnerrhoden,
      StateEnum.baselLandschaft => context.l10n.stateBaselLandschaft,
      StateEnum.baselStadt => context.l10n.stateBaselStadt,
      StateEnum.bern => context.l10n.stateBern,
      StateEnum.fribourg => context.l10n.stateFribourg,
      StateEnum.geneva => context.l10n.stateGeneva,
      StateEnum.glarus => context.l10n.stateGlarus,
      StateEnum.graubuenden => context.l10n.stateGraubuenden,
      StateEnum.jura => context.l10n.stateJura,
      StateEnum.luzern => context.l10n.stateLuzern,
      StateEnum.neuchatel => context.l10n.stateNeuchatel,
      StateEnum.nidwalden => context.l10n.stateNidwalden,
      StateEnum.obwalden => context.l10n.stateObwalden,
      StateEnum.schaffhausen => context.l10n.stateSchaffhausen,
      StateEnum.schwyz => context.l10n.stateSchwyz,
      StateEnum.solothurn => context.l10n.stateSolothurn,
      StateEnum.stGallen => context.l10n.stateStGallen,
      StateEnum.thurgau => context.l10n.stateThurgau,
      StateEnum.ticino => context.l10n.stateTicino,
      StateEnum.uri => context.l10n.stateUri,
      StateEnum.valais => context.l10n.stateValais,
      StateEnum.vaud => context.l10n.stateVaud,
      StateEnum.zug => context.l10n.stateZug,
      StateEnum.zurich => context.l10n.stateZurich,
    };
  }

  int toFirestoreIndex() {
    return switch (this) {
      StateEnum.badenWuerttemberg => 0,
      StateEnum.bayern => 1,
      StateEnum.berlin => 2,
      StateEnum.brandenburg => 3,
      StateEnum.bremen => 4,
      StateEnum.hamburg => 5,
      StateEnum.hessen => 6,
      StateEnum.mecklenburgVorpommern => 7,
      StateEnum.niedersachsen => 8,
      StateEnum.nordrheinWestfalen => 9,
      StateEnum.rheinlandPfalz => 10,
      StateEnum.saarland => 11,
      StateEnum.sachsen => 12,
      StateEnum.sachsenAnhalt => 13,
      StateEnum.schleswigHolstein => 14,
      StateEnum.thueringen => 15,
      StateEnum.notFromGermany => 16,
      StateEnum.anonymous => 17,
      StateEnum.notSelected => 18,
      StateEnum.burgenland => 19,
      StateEnum.kaernten => 20,
      StateEnum.niederoesterreich => 21,
      StateEnum.oberoesterreich => 22,
      StateEnum.salzburg => 23,
      StateEnum.steiermark => 24,
      StateEnum.tirol => 25,
      StateEnum.vorarlberg => 26,
      StateEnum.wien => 27,
      StateEnum.aargau => 28,
      StateEnum.appenzellAusserrhoden => 29,
      StateEnum.appenzellInnerrhoden => 30,
      StateEnum.baselLandschaft => 31,
      StateEnum.baselStadt => 32,
      StateEnum.bern => 33,
      StateEnum.fribourg => 34,
      StateEnum.geneva => 35,
      StateEnum.glarus => 36,
      StateEnum.graubuenden => 37,
      StateEnum.jura => 38,
      StateEnum.luzern => 39,
      StateEnum.neuchatel => 40,
      StateEnum.nidwalden => 41,
      StateEnum.obwalden => 42,
      StateEnum.schaffhausen => 43,
      StateEnum.schwyz => 44,
      StateEnum.solothurn => 45,
      StateEnum.stGallen => 46,
      StateEnum.thurgau => 47,
      StateEnum.ticino => 48,
      StateEnum.uri => 49,
      StateEnum.valais => 50,
      StateEnum.vaud => 51,
      StateEnum.zug => 52,
      StateEnum.zurich => 53,
    };
  }

  static StateEnum fromFirestoreIndex(int index) {
    return switch (index) {
      0 => StateEnum.badenWuerttemberg,
      1 => StateEnum.bayern,
      2 => StateEnum.berlin,
      3 => StateEnum.brandenburg,
      4 => StateEnum.bremen,
      5 => StateEnum.hamburg,
      6 => StateEnum.hessen,
      7 => StateEnum.mecklenburgVorpommern,
      8 => StateEnum.niedersachsen,
      9 => StateEnum.nordrheinWestfalen,
      10 => StateEnum.rheinlandPfalz,
      11 => StateEnum.saarland,
      12 => StateEnum.sachsen,
      13 => StateEnum.sachsenAnhalt,
      14 => StateEnum.schleswigHolstein,
      15 => StateEnum.thueringen,
      16 => StateEnum.notFromGermany,
      17 => StateEnum.anonymous,
      18 => StateEnum.notSelected,
      19 => StateEnum.burgenland,
      20 => StateEnum.kaernten,
      21 => StateEnum.niederoesterreich,
      22 => StateEnum.oberoesterreich,
      23 => StateEnum.salzburg,
      24 => StateEnum.steiermark,
      25 => StateEnum.tirol,
      26 => StateEnum.vorarlberg,
      27 => StateEnum.wien,
      28 => StateEnum.aargau,
      29 => StateEnum.appenzellAusserrhoden,
      30 => StateEnum.appenzellInnerrhoden,
      31 => StateEnum.baselLandschaft,
      32 => StateEnum.baselStadt,
      33 => StateEnum.bern,
      34 => StateEnum.fribourg,
      35 => StateEnum.geneva,
      36 => StateEnum.glarus,
      37 => StateEnum.graubuenden,
      38 => StateEnum.jura,
      39 => StateEnum.luzern,
      40 => StateEnum.neuchatel,
      41 => StateEnum.nidwalden,
      42 => StateEnum.obwalden,
      43 => StateEnum.schaffhausen,
      44 => StateEnum.schwyz,
      45 => StateEnum.solothurn,
      46 => StateEnum.stGallen,
      47 => StateEnum.thurgau,
      48 => StateEnum.ticino,
      49 => StateEnum.uri,
      50 => StateEnum.valais,
      51 => StateEnum.vaud,
      52 => StateEnum.zug,
      53 => StateEnum.zurich,
      _ => StateEnum.notSelected,
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
  StateEnum.burgenland: "Burgenland",
  StateEnum.kaernten: "Kärnten",
  StateEnum.niederoesterreich: "Niederösterreich",
  StateEnum.oberoesterreich: "Oberösterreich",
  StateEnum.salzburg: "Salzburg",
  StateEnum.steiermark: "Steiermark",
  StateEnum.tirol: "Tirol",
  StateEnum.vorarlberg: "Vorarlberg",
  StateEnum.wien: "Wien",
  StateEnum.aargau: "Aargau",
  StateEnum.appenzellAusserrhoden: "Appenzell Ausserrhoden",
  StateEnum.appenzellInnerrhoden: "Appenzell Innerrhoden",
  StateEnum.baselLandschaft: "Basel-Landschaft",
  StateEnum.baselStadt: "Basel-Stadt",
  StateEnum.bern: "Bern",
  StateEnum.fribourg: "Freiburg",
  StateEnum.geneva: "Genf",
  StateEnum.glarus: "Glarus",
  StateEnum.graubuenden: "Graubünden",
  StateEnum.jura: "Jura",
  StateEnum.luzern: "Luzern",
  StateEnum.neuchatel: "Neuenburg",
  StateEnum.nidwalden: "Nidwalden",
  StateEnum.obwalden: "Obwalden",
  StateEnum.schaffhausen: "Schaffhausen",
  StateEnum.schwyz: "Schwyz",
  StateEnum.solothurn: "Solothurn",
  StateEnum.stGallen: "St. Gallen",
  StateEnum.thurgau: "Thurgau",
  StateEnum.ticino: "Tessin",
  StateEnum.uri: "Uri",
  StateEnum.valais: "Wallis",
  StateEnum.vaud: "Waadt",
  StateEnum.zug: "Zug",
  StateEnum.zurich: "Zürich",
};

enum HolidayCountry { germany, austria, switzerland }

extension HolidayCountryDisplayName on HolidayCountry {
  String getDisplayName(BuildContext context) {
    return switch (this) {
      HolidayCountry.germany => context.l10n.countryGermany,
      HolidayCountry.austria => context.l10n.countryAustria,
      HolidayCountry.switzerland => context.l10n.countrySwitzerland,
    };
  }

  String getFlagEmoji() {
    return switch (this) {
      HolidayCountry.germany => "🇩🇪",
      HolidayCountry.austria => "🇦🇹",
      HolidayCountry.switzerland => "🇨🇭",
    };
  }
}

extension HolidayStateCountry on StateEnum {
  HolidayCountry? get country {
    switch (this) {
      case StateEnum.badenWuerttemberg ||
          StateEnum.bayern ||
          StateEnum.berlin ||
          StateEnum.brandenburg ||
          StateEnum.bremen ||
          StateEnum.hamburg ||
          StateEnum.hessen ||
          StateEnum.mecklenburgVorpommern ||
          StateEnum.niedersachsen ||
          StateEnum.nordrheinWestfalen ||
          StateEnum.rheinlandPfalz ||
          StateEnum.saarland ||
          StateEnum.sachsen ||
          StateEnum.sachsenAnhalt ||
          StateEnum.schleswigHolstein ||
          StateEnum.thueringen:
        return HolidayCountry.germany;
      case StateEnum.burgenland ||
          StateEnum.kaernten ||
          StateEnum.niederoesterreich ||
          StateEnum.oberoesterreich ||
          StateEnum.salzburg ||
          StateEnum.steiermark ||
          StateEnum.tirol ||
          StateEnum.vorarlberg ||
          StateEnum.wien:
        return HolidayCountry.austria;
      case StateEnum.aargau ||
          StateEnum.appenzellAusserrhoden ||
          StateEnum.appenzellInnerrhoden ||
          StateEnum.baselLandschaft ||
          StateEnum.baselStadt ||
          StateEnum.bern ||
          StateEnum.fribourg ||
          StateEnum.geneva ||
          StateEnum.glarus ||
          StateEnum.graubuenden ||
          StateEnum.jura ||
          StateEnum.luzern ||
          StateEnum.neuchatel ||
          StateEnum.nidwalden ||
          StateEnum.obwalden ||
          StateEnum.schaffhausen ||
          StateEnum.schwyz ||
          StateEnum.solothurn ||
          StateEnum.stGallen ||
          StateEnum.thurgau ||
          StateEnum.ticino ||
          StateEnum.uri ||
          StateEnum.valais ||
          StateEnum.vaud ||
          StateEnum.zug ||
          StateEnum.zurich:
        return HolidayCountry.switzerland;
      case StateEnum.notFromGermany ||
          StateEnum.anonymous ||
          StateEnum.notSelected:
        return null;
    }
  }

  bool get isSelectable =>
      this != StateEnum.anonymous && this != StateEnum.notSelected;
}

const List<StateEnum> germanyStates = [
  StateEnum.badenWuerttemberg,
  StateEnum.bayern,
  StateEnum.berlin,
  StateEnum.brandenburg,
  StateEnum.bremen,
  StateEnum.hamburg,
  StateEnum.hessen,
  StateEnum.mecklenburgVorpommern,
  StateEnum.niedersachsen,
  StateEnum.nordrheinWestfalen,
  StateEnum.rheinlandPfalz,
  StateEnum.saarland,
  StateEnum.sachsen,
  StateEnum.sachsenAnhalt,
  StateEnum.schleswigHolstein,
  StateEnum.thueringen,
];

const List<StateEnum> austriaStates = [
  StateEnum.burgenland,
  StateEnum.kaernten,
  StateEnum.niederoesterreich,
  StateEnum.oberoesterreich,
  StateEnum.salzburg,
  StateEnum.steiermark,
  StateEnum.tirol,
  StateEnum.vorarlberg,
  StateEnum.wien,
];

const List<StateEnum> switzerlandStates = [
  StateEnum.aargau,
  StateEnum.appenzellAusserrhoden,
  StateEnum.appenzellInnerrhoden,
  StateEnum.baselLandschaft,
  StateEnum.baselStadt,
  StateEnum.bern,
  StateEnum.fribourg,
  StateEnum.geneva,
  StateEnum.glarus,
  StateEnum.graubuenden,
  StateEnum.jura,
  StateEnum.luzern,
  StateEnum.neuchatel,
  StateEnum.nidwalden,
  StateEnum.obwalden,
  StateEnum.schaffhausen,
  StateEnum.schwyz,
  StateEnum.solothurn,
  StateEnum.stGallen,
  StateEnum.thurgau,
  StateEnum.ticino,
  StateEnum.uri,
  StateEnum.valais,
  StateEnum.vaud,
  StateEnum.zug,
  StateEnum.zurich,
];

const Map<HolidayCountry, List<StateEnum>> holidayStatesByCountry = {
  HolidayCountry.germany: germanyStates,
  HolidayCountry.austria: austriaStates,
  HolidayCountry.switzerland: switzerlandStates,
};
