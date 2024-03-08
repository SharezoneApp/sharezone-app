// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/feedback/history/feedback_view.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';

void main() {
  group(FeedbackView, () {
    test('.fromUserFeedback()', () {
      final feedback = UserFeedback.create();
      final view = FeedbackView.fromUserFeedback(feedback);

      expect(view.rating, isNull);
      expect(view.likes, '');
      expect(view.dislikes, '');
      expect(view.heardFrom, '');
      expect(view.missing, '');
      expect(view.createdOn, isNull);
    });

    test('.hasX returns null even it is empty', () {
      const view = FeedbackView(
        createdOn: '',
        rating: '',
        likes: '',
        dislikes: '',
        heardFrom: '',
        missing: '',
      );

      expect(view.hasCreatedOn, isFalse);
      expect(view.hasRating, isFalse);
      expect(view.hasLikes, isFalse);
      expect(view.hasDislikes, isFalse);
      expect(view.hasHeardFrom, isFalse);
      expect(view.hasMissing, isFalse);
    });
  });
}
