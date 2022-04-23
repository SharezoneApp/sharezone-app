// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

void main() {
  test("validate", () {
    final period1_900_959 = Period(
        number: 1,
        startTime: Time(hour: 9, minute: 0),
        endTime: Time(hour: 9, minute: 59));

    expect(period1_900_959.validate(), true);
  });
}
