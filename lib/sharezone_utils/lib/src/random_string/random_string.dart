// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

String randomString(int length) {
  var rand = Random();
  var codeUnits = List.generate(length, (index) {
    return rand.nextInt(33) + 89;
  });

  return String.fromCharCodes(codeUnits);
}

String randomIDString(int length) {
  var rand = Random();
  const chars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  String result = "";
  for (var i = 0; i < length; i++) {
    result += chars[rand.nextInt(chars.length)];
  }
  return result;
}
