import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_helper/cloud_firestore_helper.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:sharezone/feedback/src/models/feedback_chat_message_id.dart';

class FeedbackChatMessage extends Equatable {
  final FeedbackChatMessageId id;
  final DateTime sendAt;
  final String text;
  final UserId senderId;
  final bool isRead;

  const FeedbackChatMessage({
    required this.id,
    required this.text,
    required this.sendAt,
    required this.senderId,
    required this.isRead,
  });

  factory FeedbackChatMessage.fromJson(String id, Map<String, dynamic> map) {
    return FeedbackChatMessage(
      id: FeedbackChatMessageId(map['id']),
      sendAt: dateTimeFromTimestamp(map['sendAt']),
      text: map['body']['plain'],
      senderId: UserId(map['senderId']),
      isRead: map['isRead'],
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'sendAt': FieldValue.serverTimestamp(),
      'body': {
        'plain': text,
      },
      'senderId': '$senderId',
      'isRead': false,
      'readAt': null,
    };
  }

  @override
  List<Object?> get props => [id, sendAt, text, senderId, isRead];
}
