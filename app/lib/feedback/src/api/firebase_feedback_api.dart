// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
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
    final stream =
        feedbackCollection.where('uid', isEqualTo: userId).snapshots();
    return stream.map((snapshot) => snapshot.docs
        .map((doc) => UserFeedback.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }
}
