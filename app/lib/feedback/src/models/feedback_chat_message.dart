import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_helper/cloud_firestore_helper.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:sharezone/feedback/src/models/feedback_chat_message_id.dart';

class FeedbackChatMessage extends Equatable {
  final FeedbackChatMessageId id;
  final DateTime sentAt;
  final String text;
  final UserId senderId;

  const FeedbackChatMessage({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.senderId,
  });

  factory FeedbackChatMessage.fromJson(String id, Map<String, dynamic> map) {
    return FeedbackChatMessage(
      id: FeedbackChatMessageId(id),
      sentAt: dateTimeFromTimestamp(map['sentAt']),
      text: map['body']['plain'],
      senderId: UserId(map['senderId']),
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'sentAt': FieldValue.serverTimestamp(),
      'body': {
        'plain': text,
      },
      'senderId': '$senderId',
    };
  }

  @override
  List<Object?> get props => [id, sentAt, text, senderId];
}
