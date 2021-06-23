import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';

import 'feedback_api.dart';

class FirebaseFeedbackApi implements FeedbackApi {
  final FirebaseFirestore _firestore;

  FirebaseFeedbackApi(this._firestore);

  @override
  Future<void> sendFeedback(UserFeedback feedback) async {
    CollectionReference feedbackCollection = _firestore.collection("Feedback");
    feedbackCollection.add(feedback.toJson());
    return;
  }
}
