// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:feedback_shared_implementation/src/api/feedback_api.dart';
import 'package:feedback_shared_implementation/src/models/feedback_chat_message.dart';
import 'package:feedback_shared_implementation/src/models/feedback_chat_message_id.dart';
import 'package:feedback_shared_implementation/src/models/feedback_id.dart';
import 'package:feedback_shared_implementation/src/models/user_feedback.dart';

class FirebaseFeedbackApi implements FeedbackApi {
  FirebaseFeedbackApi(FirebaseFirestore firestore)
    : feedbackCollection = firestore.collection('Feedback');

  final CollectionReference feedbackCollection;

  @override
  Future<void> sendFeedback(UserFeedback feedback) async {
    feedbackCollection.add(feedback.toJson());
    return;
  }

  @override
  Stream<List<UserFeedback>> streamFeedbacks(String userId) {
    final stream =
        feedbackCollection
            .where('uid', isEqualTo: userId)
            .orderBy('createdOn', descending: true)
            .snapshots();
    return stream.map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) => UserFeedback.fromJson(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  @override
  Stream<UserFeedback> streamFeedback(FeedbackId feedbackId) {
    return feedbackCollection
        .doc('$feedbackId')
        .snapshots()
        .map(
          (doc) =>
              UserFeedback.fromJson(doc.id, doc.data() as Map<String, dynamic>),
        );
  }

  FeedbackChatMessageId _generateMessageId() {
    return FeedbackChatMessageId(feedbackCollection.doc().id);
  }

  @override
  void sendResponse({
    required FeedbackId feedbackId,
    required UserId userId,
    required String message,
  }) async {
    final dto = FeedbackChatMessage(
      id: _generateMessageId(),
      text: message,
      senderId: userId,
      sentAt: DateTime.now(), // Will be overwritten in the toJson method
    );
    // We don't await this because in offline mode we don't want to block the UI
    // (request will await until online again).
    feedbackCollection
        .doc('$feedbackId')
        .collection('Messages')
        .add(dto.toCreateJson());
  }

  @override
  Stream<List<FeedbackChatMessage>> streamChatMessages(FeedbackId feedbackId) {
    return feedbackCollection
        .doc('$feedbackId')
        .collection('Messages')
        .orderBy('sentAt')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => FeedbackChatMessage.fromJson(doc.id, doc.data()),
                  )
                  .toList(),
        );
  }

  @override
  void markMessageAsRead(FeedbackId feedbackId, UserId userId) {
    feedbackCollection.doc('$feedbackId').update({
      'unreadMessagesStatus.$userId': {
        'hasUnreadMessages': false,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    });
  }

  @override
  Stream<bool> streamHasUnreadFeedbackMessages(UserId userId) {
    return feedbackCollection
        .where('uid', isEqualTo: '$userId')
        .where(
          'unreadMessagesStatus.$userId.hasUnreadMessages',
          isEqualTo: true,
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  @override
  Future<List<UserFeedback>> getFeedbacksForSupportTeam({
    DateTime? startAfter,
    int limit = 0,
    SupportFeedbackFilter filter = SupportFeedbackFilter.all,
  }) {
    const supportTeamUnreadPath =
        'unreadMessagesStatus.support-team.hasUnreadMessages';
    Query query = feedbackCollection.orderBy('createdOn', descending: true);
    switch (filter) {
      case SupportFeedbackFilter.all:
        break;
      case SupportFeedbackFilter.unreadMessages:
        query = query.where(supportTeamUnreadPath, isEqualTo: true);
        break;
      case SupportFeedbackFilter.noMessages:
        query = query.where('unreadMessagesStatus', isNull: true);
        break;
    }
    if (startAfter != null) {
      query = query.startAfter([startAfter]);
    }
    if (limit > 0) {
      query = query.limit(limit);
    }
    return query.get().then(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) => UserFeedback.fromJson(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}
