// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

/// BW	Baden-Württemberg
/// BY	Bayern
/// BE	Berlin
/// BB	Brandenburg
/// HB	Bremen
/// HH	Hamburg
/// HE	Hessen
/// MV	Mecklenburg-Vorpommern
/// NI	Niedersachsen
/// NW	Nordrhein-Westfalen
/// RP	Rheinland-Pfalz
/// SL	Saarland
/// SN	Sachsen
/// ST	Sachsen-Anhalt
/// SH	Schleswig-Holstein
/// TH	Thüringen
/// DE	Deutschland (Nur bei Feiertagen verfügbar)
library;

abstract class State {
  const State();

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is State && code == other.code;
  }

  @override
  int get hashCode {
    return code.hashCode;
  }

  String get code;
}

class BadenWuerttemberg extends State {
  const BadenWuerttemberg();
  @override
  String get code => "BW";
}

class Bayern extends State {
  const Bayern();
  @override
  String get code => "BY";
}

class Berlin extends State {
  const Berlin();
  @override
  String get code => "BE";
}

class Brandenburg extends State {
  const Brandenburg();
  @override
  String get code => "BB";
}

class Bremen extends State {
  const Bremen();
  @override
  String get code => "HB";
}

class Hamburg extends State {
  const Hamburg();
  @override
  String get code => "HH";
}

class Hessen extends State {
  const Hessen();
  @override
  String get code => "HE";
}

class MecklenburgVorpommern extends State {
  const MecklenburgVorpommern();
  @override
  String get code => "MV";
}

class Niedersachsen extends State {
  const Niedersachsen();
  @override
  String get code => "NI";
}

class NordrheinWestfalen extends State {
  const NordrheinWestfalen();
  @override
  String get code => "NW";
}

class RheinlandPfalz extends State {
  const RheinlandPfalz();
  @override
  String get code => "RP";
}

class Saarland extends State {
  const Saarland();
  @override
  String get code => "SL";
}

class Sachsen extends State {
  const Sachsen();
  @override
  String get code => "SN";
}

class SachsenAnhalt extends State {
  const SachsenAnhalt();
  @override
  String get code => "ST";
}

class SchleswigHolstein extends State {
  const SchleswigHolstein();
  @override
  String get code => "SH";
}

class Thueringen extends State {
  const Thueringen();
  @override
  String get code => "TH";
}
