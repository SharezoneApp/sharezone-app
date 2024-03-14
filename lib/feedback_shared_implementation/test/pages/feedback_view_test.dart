// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:feedback_shared_implementation/feedback_shared_implementation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(FeedbackView, () {
    test('.fromUserFeedback() empty', () {
      final feedback = UserFeedback.create();
      final view = FeedbackView.fromUserFeedback(feedback, UserId('1'));

      expect(view.rating, isNull);
      expect(view.likes, '');
      expect(view.dislikes, '');
      expect(view.heardFrom, '');
      expect(view.missing, '');
      expect(view.createdOn, isNull);
    });

    test('.fromUserFeedback() with data', () {
      final feedback = UserFeedback.create().copyWith(
        rating: 5.0,
        dislikes: 'd',
        heardFrom: 'h',
        likes: 'l',
        missing: 'm',
      );
      final view = FeedbackView.fromUserFeedback(feedback, UserId('1'));

      expect(view.rating, '5.0/5.0');
      expect(view.likes, 'l');
      expect(view.dislikes, 'd');
      expect(view.heardFrom, 'h');
      expect(view.missing, 'm');
      expect(view.createdOn, isNull);
    });

    test('.hasX returns null even it is empty', () {
      final view = FeedbackView(
        id: FeedbackId('id'),
        createdOn: '',
        rating: '',
        likes: '',
        dislikes: '',
        heardFrom: '',
        missing: '',
        hasUnreadMessages: null,
        lastMessage: null,
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
