// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:intl/intl.dart';
import 'package:sharezone/feedback/shared/feedback_id.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';

class FeedbackView extends Equatable {
  final FeedbackId id;
  final String? createdOn;
  final String? rating;
  final String? likes;
  final String? dislikes;
  final String? heardFrom;
  final String? missing;

  bool get hasCreatedOn => isNotEmptyOrNull(createdOn);
  bool get hasRating => isNotEmptyOrNull(rating);
  bool get hasLikes => isNotEmptyOrNull(likes);
  bool get hasDislikes => isNotEmptyOrNull(dislikes);
  bool get hasHeardFrom => isNotEmptyOrNull(heardFrom);
  bool get hasMissing => isNotEmptyOrNull(missing);

  const FeedbackView({
    required this.id,
    required this.createdOn,
    required this.rating,
    required this.likes,
    required this.dislikes,
    required this.heardFrom,
    required this.missing,
  });

  factory FeedbackView.fromUserFeedback(UserFeedback feedback) {
    return FeedbackView(
      id: feedback.id,
      rating: feedback.rating == null ? null : '${feedback.rating}/5.0',
      likes: feedback.likes,
      dislikes: feedback.dislikes,
      heardFrom: feedback.heardFrom,
      missing: feedback.missing,
      createdOn: feedback.createdOn == null
          ? null
          : DateFormat.yMd().format(feedback.createdOn!),
    );
  }

  @override
  List<Object?> get props => [
        id,
        createdOn,
        rating,
        likes,
        dislikes,
        heardFrom,
        missing,
      ];
}

extension UserFeedbacksToViews on List<UserFeedback> {
  List<FeedbackView> toFeedbackViews() {
    return map((feedback) => FeedbackView.fromUserFeedback(feedback)).toList();
  }
}

class FeedbackMessageView extends Equatable {
  final String message;
  final bool isMyMessage;
  final String sentAt;

  const FeedbackMessageView({
    required this.message,
    required this.isMyMessage,
    required this.sentAt,
  });

  @override
  List<Object?> get props => [message, isMyMessage];
}
