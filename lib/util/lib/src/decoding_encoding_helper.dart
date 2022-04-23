// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

bool parseBool(String boolString) {
  var lowerCase = boolString.toLowerCase();
  if (lowerCase == 'true') return true;
  if (lowerCase == 'false') return false;
  throw Exception('Konnte bool von dem String $boolString nicht parsen');
}
