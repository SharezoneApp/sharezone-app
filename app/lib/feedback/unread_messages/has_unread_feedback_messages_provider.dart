import 'dart:async';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:feedback_shared_implementation/feedback_shared_implementation.dart';
import 'package:flutter/foundation.dart';

class HasUnreadFeedbackMessagesProvider extends ChangeNotifier {
  final FeedbackApi feedbackApi;
  final UserId userId;

  bool _hasUnreadFeedbackMessages = false;
  StreamSubscription<bool>? _unreadMessagesSubscription;

  HasUnreadFeedbackMessagesProvider({
    required this.feedbackApi,
    required this.userId,
  }) {
    _unreadMessagesSubscription = feedbackApi
        .streamHasUnreadFeedbackMessages(userId)
        .listen((hasUnreadMessages) {
      _hasUnreadFeedbackMessages = hasUnreadMessages;
      notifyListeners();
    });
  }

  bool get hasUnreadFeedbackMessages => _hasUnreadFeedbackMessages;

  @override
  void dispose() {
    _unreadMessagesSubscription?.cancel();
    super.dispose();
  }
}
