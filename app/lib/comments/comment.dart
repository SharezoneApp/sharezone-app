// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:meta/meta.dart';

import 'misc.dart';

class Comment {
  final String id;
  final String content;
  final CommentAuthor author;
  final List<Rating> ratings;
  final CommentAge age;
  int get score => likes - dislikes;
  int get likes => positiveRatings.length;
  int get dislikes => negativeRatings.length;
  List<Rating> get positiveRatings =>
      ratings.where((rating) => rating.isLike).toList();
  List<Rating> get negativeRatings =>
      ratings.where((rating) => rating.isDislike).toList();

  Comment({
    @required this.content,
    @required this.author,
    this.ratings = const [],
    this.age = CommentAge.zero,
    this.id,
  });

  CommentStatus getCommentStatusOfUser(String uid) {
    try {
      final rating = ratings.firstWhere((r) => r.uid == uid);
      return _ratingStatusToCommentStatus(rating.status);
      // ignore: avoid_catching_errors
    } on StateError {
      return CommentStatus.notRated;
    }
  }

  CommentStatus _ratingStatusToCommentStatus(RatingStatus ratingStatus) =>
      ratingStatus == RatingStatus.liked
          ? CommentStatus.liked
          : CommentStatus.disliked;
}

class CommentAge extends Duration {
  static const approximateDaysPerMonth = 30;
  static const daysPerYear = 365; // Don't care about Schaltjahre
  static const CommentAge zero = CommentAge(seconds: 0);

  const CommentAge({
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) : super(
          days: days,
          hours: hours,
          minutes: minutes,
          seconds: seconds,
          milliseconds: milliseconds,
          microseconds: microseconds,
        );

  factory CommentAge.fromDuration(Duration duration) {
    return CommentAge(microseconds: duration.inMicroseconds);
  }

  int get inApproximateYears => (inDays / approximateDaysPerMonth).round();

  DateTime get writtenOnDateTime => DateTime.now().subtract(this);
}

class CommentAuthor {
  final String name;
  final String abbreviation;
  final String uid;

  const CommentAuthor({
    @required this.uid,
    this.name = "",
    this.abbreviation = "",
  });
}

enum RatingStatus { liked, disliked }

class Rating {
  final RatingStatus status;
  final String uid;
  bool get isLike => status == RatingStatus.liked;
  bool get isDislike => status == RatingStatus.disliked;

  Rating({@required this.status, @required this.uid});
  Rating.positive({@required this.uid}) : status = RatingStatus.liked;
  Rating.negative({@required this.uid}) : status = RatingStatus.disliked;
}
