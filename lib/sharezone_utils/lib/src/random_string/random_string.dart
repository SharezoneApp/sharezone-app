// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

final _rand = Random();

String randomString(int length) {
  final buffer = StringBuffer();
  for (var i = 0; i < length; i++) {
    buffer.writeCharCode(_rand.nextInt(33) + 89);
  }

  return buffer.toString();
}

String randomIDString(int length) {
  const chars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  final buffer = StringBuffer();
  for (var i = 0; i < length; i++) {
    buffer.write(chars[_rand.nextInt(chars.length)]);
  }
  return buffer.toString();
}
