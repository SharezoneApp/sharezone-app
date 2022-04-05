// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:convert';

extension StreamToUtf8String on Stream<List<int>> {
  Stream<String> toUtf8() => transform(utf8.decoder);
  Future<String> toUtf8String() => transform(utf8.decoder)
      .reduce((previous, element) => '$previous $element');
}

extension FutureTouUtf8String on Future<List<int>> {
  Future<String> toUtf8String() {
    return then((value) => value.toUtf8String());
  }
}

extension IntListToUtf8String on List<int> {
  String toUtf8String() {
    return utf8.decoder.convert(this);
  }
}
