// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

final _secureRandom = Random.secure();
const _idChars =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
final _idCharCodes = _idChars.codeUnits;

String randomString(int length) {
  var codeUnits = List.generate(length, (index) {
    return _secureRandom.nextInt(33) + 89;
  });

  return String.fromCharCodes(codeUnits);
}

String randomIDString(int length) {
  final codes = List<int>.generate(
    length,
    (_) => _idCharCodes[_secureRandom.nextInt(_idCharCodes.length)],
  );
  return String.fromCharCodes(codes);
}
