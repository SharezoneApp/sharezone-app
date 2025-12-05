// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:feedback_shared_implementation/src/models/feedback_id.dart';
import 'package:feedback_shared_implementation/src/models/user_feedback.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:intl/intl.dart';

class FeedbackView extends Equatable {
  final FeedbackId id;
  final String? createdOn;
  final String? rating;
  final String? likes;
  final String? dislikes;
  final String? heardFrom;
  final String? missing;
  final String? lastMessage;
  final bool? hasUnreadMessages;
  final String? deviceInformation;

  bool get hasCreatedOn => isNotEmptyOrNull(createdOn);
  bool get hasRating => isNotEmptyOrNull(rating);
  bool get hasLikes => isNotEmptyOrNull(likes);
  bool get hasDislikes => isNotEmptyOrNull(dislikes);
  bool get hasHeardFrom => isNotEmptyOrNull(heardFrom);
  bool get hasMissing => isNotEmptyOrNull(missing);
  bool get hasLastMessage => isNotEmptyOrNull(lastMessage);
  bool get hasDeviceInformation => isNotEmptyOrNull(deviceInformation);

  const FeedbackView({
    required this.id,
    required this.createdOn,
    required this.rating,
    required this.likes,
    required this.dislikes,
    required this.heardFrom,
    required this.missing,
    required this.lastMessage,
    required this.hasUnreadMessages,
    this.deviceInformation,
  });

  factory FeedbackView.fromUserFeedback(UserFeedback feedback, UserId userId) {
    final lastMessage = feedback.lastMessage;
    final isMyMessage = lastMessage?.senderId == userId;
    return FeedbackView(
      id: feedback.id,
      rating: feedback.rating == null ? null : '${feedback.rating}/5.0',
      likes: feedback.likes,
      dislikes: feedback.dislikes,
      heardFrom: feedback.heardFrom,
      missing: feedback.missing,
      createdOn:
          feedback.createdOn == null
              ? null
              : DateFormat.yMd().format(feedback.createdOn!),
      lastMessage:
          lastMessage == null
              ? null
              : _addAuthorToMessage(lastMessage.text, isMyMessage),
      hasUnreadMessages:
          feedback.unreadMessagesStatus?[userId] == null
              ? false
              : feedback.unreadMessagesStatus?[userId]?.hasUnreadMessages ==
                  true,
      deviceInformation: feedback.deviceInformation.toString(),
    );
  }

  static String _addAuthorToMessage(String message, bool isMyMessage) {
    return isMyMessage ? 'Du: $message' : message;
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
  List<FeedbackView> toFeedbackViews(UserId userId) {
    return map(
      (feedback) => FeedbackView.fromUserFeedback(feedback, userId),
    ).toList();
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
