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

  String toLocalizedString(BuildContext context) {
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
  String toLocalizedString(BuildContext context) {
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
