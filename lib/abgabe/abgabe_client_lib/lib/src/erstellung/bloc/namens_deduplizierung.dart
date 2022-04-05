// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/src/erstellung/lokale_abgabedatei.dart';
import 'package:abgabe_client_lib/src/models/models.dart';

import 'package:meta/meta.dart';

/// Nennt alle Dateien in [dateien] mit einem einzigartigen Namen um, deren Name
/// doppelt in [dateien] oder bereits in [bereitsVorhandeneDateinamen] vorkommt.
/// Der Rückgabewert sind alle [dateien] (inklusive den umbenannten Dateien).
List<LokaleAbgabedatei> benenneEinzigartig(List<LokaleAbgabedatei> dateien,
    {@required Set<Dateiname> bereitsVorhandeneDateinamen}) {
  final uniquelyNamed = <LokaleAbgabedatei>[];
  for (final file in dateien) {
    if (bereitsVorhandeneDateinamen.contains(file.name)) {
      final abgabedatei = _renameUniquely(file, bereitsVorhandeneDateinamen);
      uniquelyNamed.add(abgabedatei);
      bereitsVorhandeneDateinamen.add(abgabedatei.name);
    } else {
      uniquelyNamed.add(file);
      bereitsVorhandeneDateinamen.add(file.name);
    }
  }

  return uniquelyNamed;
}

/// Versucht so lange einen neuen Namen für die Datei zu generieren bis ein
/// unbenutzer gefunden wird.
LokaleAbgabedatei _renameUniquely(
    LokaleAbgabedatei abgabedatei, Set<Dateiname> bereitsVorhandeneDateinamen) {
  Dateiname generateReplacementName(int currentDuplicationSuffix) =>
      abgabedatei.name.neuerBasename(
          '${abgabedatei.name.ohneExtension} ($currentDuplicationSuffix)');

  for (var replacementNr = 1;; replacementNr++) {
    final name = generateReplacementName(replacementNr);

    final nameAlreadyTaken = bereitsVorhandeneDateinamen.contains(name);

    if (!nameAlreadyTaken) {
      return abgabedatei.nenneUm(name);
    }
  }
}
