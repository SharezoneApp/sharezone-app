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

class Burgenland extends State {
  const Burgenland();
  @override
  String get code => "AT-BL";
}

class Kaernten extends State {
  const Kaernten();
  @override
  String get code => "AT-KÄ";
}

class Niederoesterreich extends State {
  const Niederoesterreich();
  @override
  String get code => "AT-NÖ";
}

class Oberoesterreich extends State {
  const Oberoesterreich();
  @override
  String get code => "AT-OÖ";
}

class Salzburg extends State {
  const Salzburg();
  @override
  String get code => "AT-SB";
}

class Steiermark extends State {
  const Steiermark();
  @override
  String get code => "AT-SM";
}

class Tirol extends State {
  const Tirol();
  @override
  String get code => "AT-TI";
}

class Vorarlberg extends State {
  const Vorarlberg();
  @override
  String get code => "AT-VA";
}

class Wien extends State {
  const Wien();
  @override
  String get code => "AT-WI";
}

class Aargau extends State {
  const Aargau();
  @override
  String get code => "CH-AG";
}

class AppenzellAusserrhoden extends State {
  const AppenzellAusserrhoden();
  @override
  String get code => "CH-AR";
}

class AppenzellInnerrhoden extends State {
  const AppenzellInnerrhoden();
  @override
  String get code => "CH-AI";
}

class BaselLandschaft extends State {
  const BaselLandschaft();
  @override
  String get code => "CH-BL";
}

class BaselStadt extends State {
  const BaselStadt();
  @override
  String get code => "CH-BS";
}

class Bern extends State {
  const Bern();
  @override
  String get code => "CH-BE";
}

class Fribourg extends State {
  const Fribourg();
  @override
  String get code => "CH-FR";
}

class Geneva extends State {
  const Geneva();
  @override
  String get code => "CH-GE";
}

class Glarus extends State {
  const Glarus();
  @override
  String get code => "CH-GL";
}

class Graubuenden extends State {
  const Graubuenden();
  @override
  String get code => "CH-GR";
}

class Jura extends State {
  const Jura();
  @override
  String get code => "CH-JU";
}

class Luzern extends State {
  const Luzern();
  @override
  String get code => "CH-LU";
}

class Neuchatel extends State {
  const Neuchatel();
  @override
  String get code => "CH-NE";
}

class Nidwalden extends State {
  const Nidwalden();
  @override
  String get code => "CH-NW";
}

class Obwalden extends State {
  const Obwalden();
  @override
  String get code => "CH-OW";
}

class Schaffhausen extends State {
  const Schaffhausen();
  @override
  String get code => "CH-SH";
}

class Schwyz extends State {
  const Schwyz();
  @override
  String get code => "CH-SZ";
}

class Solothurn extends State {
  const Solothurn();
  @override
  String get code => "CH-SO";
}

class StGallen extends State {
  const StGallen();
  @override
  String get code => "CH-SG";
}

class Thurgau extends State {
  const Thurgau();
  @override
  String get code => "CH-TG";
}

class Ticino extends State {
  const Ticino();
  @override
  String get code => "CH-TI";
}

class Uri extends State {
  const Uri();
  @override
  String get code => "CH-UR";
}

class Valais extends State {
  const Valais();
  @override
  String get code => "CH-VS";
}

class Vaud extends State {
  const Vaud();
  @override
  String get code => "CH-VD";
}

class Zug extends State {
  const Zug();
  @override
  String get code => "CH-ZG";
}

class Zurich extends State {
  const Zurich();
  @override
  String get code => "CH-ZH";
}
