// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:helper_functions/helper_functions.dart';
import 'package:intl/intl.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';

class FeedbackView {
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
    required this.createdOn,
    required this.rating,
    required this.likes,
    required this.dislikes,
    required this.heardFrom,
    required this.missing,
  });

  factory FeedbackView.fromUserFeedback(UserFeedback feedback) {
    return FeedbackView(
      rating: '${feedback.rating}/5.0',
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FeedbackView &&
        other.rating == rating &&
        other.likes == likes &&
        other.dislikes == dislikes &&
        other.heardFrom == heardFrom &&
        other.missing == missing;
  }

  @override
  int get hashCode {
    return rating.hashCode ^
        likes.hashCode ^
        dislikes.hashCode ^
        heardFrom.hashCode ^
        missing.hashCode;
  }

  @override
  String toString() {
    return 'FeedbackView(rating: $rating, likes: $likes, dislikes: $dislikes, heardFrom: $heardFrom, missing: $missing)';
  }
}

extension UserFeedbacksToViews on List<UserFeedback> {
  List<FeedbackView> toFeedbackViews() {
    return map((feedback) => FeedbackView.fromUserFeedback(feedback)).toList();
  }
}
