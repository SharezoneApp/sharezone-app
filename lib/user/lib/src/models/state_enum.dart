// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
