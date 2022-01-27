// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

class Nutzername {
  final String ausgeschrieben;
  final String abbreviation;

  Nutzername(this.ausgeschrieben, this.abbreviation) {
    ArgumentError.checkNotNull(ausgeschrieben, 'name');
    ArgumentError.checkNotNull(abbreviation, 'abbreviation');
    if (ausgeschrieben.isEmpty) {
      throw ArgumentError('Nutzername darf nicht leer sein');
    }
    if (abbreviation.isEmpty) {
      throw ArgumentError('Abbreviation darf nicht leer sein');
    }
  }

  factory Nutzername.generiereAbkuerzung(String name) {
    return Nutzername(name, name.substring(0, 1));
  }
}
