// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:sharezone/feedback/shared/feedback_id.dart';
import 'package:sharezone/feedback/src/models/feedback_chat_message.dart';
import 'package:sharezone/feedback/src/models/feedback_chat_message_id.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';

import 'feedback_api.dart';

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
    final stream = feedbackCollection
        .where('uid', isEqualTo: userId)
        .orderBy('createdOn', descending: true)
        .snapshots();
    return stream.map((snapshot) => snapshot.docs
        .map((doc) =>
            UserFeedback.fromJson(doc.id, doc.data() as Map<String, dynamic>))
        .toList());
  }

  @override
  Future<UserFeedback> getFeedback(FeedbackId feedbackId) {
    return feedbackCollection.doc('$feedbackId').get().then((doc) =>
        UserFeedback.fromJson(doc.id, doc.data() as Map<String, dynamic>));
  }

  FeedbackChatMessageId _generateMessageId() {
    return FeedbackChatMessageId(feedbackCollection.doc().id);
  }

  @override
  void sendResponse({
    required FeedbackId feedbackId,
    required UserId userId,
    required String message,
  }) {
    final dto = FeedbackChatMessage(
      id: _generateMessageId(),
      text: message,
      senderId: userId,
      isRead: false,
      sendAt: DateTime.now(), // Will be overwritten in the toJson method
    );
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
        .orderBy('sendAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FeedbackChatMessage.fromJson(doc.id, doc.data()))
            .toList());
  }
}
