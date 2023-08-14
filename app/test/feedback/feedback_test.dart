// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';

void main() {
  group('Feedback', () {
    test('equality', () {
      UserFeedback a = UserFeedback.create().copyWith(
          rating: 5.0,
          dislikes: "d",
          heardFrom: "h",
          likes: "l",
          missing: "m",
          uid: "u",
          userContactInformation: "uci");

      UserFeedback b = UserFeedback.create().copyWith(
          rating: 5.0,
          dislikes: "d",
          heardFrom: "h",
          likes: "l",
          missing: "m",
          uid: "u",
          userContactInformation: "uci");

      UserFeedback c = UserFeedback.create().copyWith(dislikes: "d");
      expect(a, equals(b));
      expect(a.copyWith(dislikes: "dd"), isNot(equals(c)));
    });
  });
}
