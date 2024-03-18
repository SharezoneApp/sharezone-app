// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_helper/cloud_firestore_helper.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:feedback_shared_implementation/src/models/feedback_id.dart';
import 'package:helper_functions/helper_functions.dart';
import 'feedback_chat_message.dart';

class UserFeedback {
  /// The date and time the feedback was created.
  ///
  /// Old feedbacks might not have this field set because it was added later.
  final DateTime? createdOn;

  /// The id of the feedback.
  final FeedbackId id;
  final double? rating;
  final String likes;
  final String dislikes;
  final String missing;
  final String heardFrom;
  final String uid;
  final FeedbackDeviceInformation? deviceInformation;
  final Map<UserId, UnreadMessageStatus>? unreadMessagesStatus;
  final FeedbackChatMessage? lastMessage;

  bool get requiredUserInputIsEmpty =>
      _isWhitespaceOrNull(likes) &&
      _isWhitespaceOrNull(dislikes) &&
      _isWhitespaceOrNull(missing) &&
      _isWhitespaceOrNull(heardFrom);

  bool _isWhitespaceOrNull(String s) => isEmptyOrNull(s.trim());

  const UserFeedback._({
    required this.id,
    required this.createdOn,
    required this.rating,
    required this.likes,
    required this.dislikes,
    required this.missing,
    required this.heardFrom,
    required this.uid,
    required this.deviceInformation,
    required this.unreadMessagesStatus,
    required this.lastMessage,
  });

  factory UserFeedback.create() {
    return UserFeedback._(
      id: FeedbackId("feedbackId"),
      createdOn: null,
      rating: null,
      likes: "",
      dislikes: "",
      missing: "",
      heardFrom: "",
      uid: "",
      deviceInformation: null,
      unreadMessagesStatus: null,
      lastMessage: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': _ratingToString(),
      'likes': likes,
      'dislikes': dislikes,
      'missing': missing,
      'heardFrom': heardFrom,
      'uid': uid,
      'createdOn': FieldValue.serverTimestamp(),
      'deviceInformation': deviceInformation?.toJson(),
    }..removeWhere((string, object) =>
        object == null || (object is String && object.isEmpty));
  }

  factory UserFeedback.fromJson(String feedbackId, Map<String, dynamic> map) {
    return UserFeedback._(
      id: FeedbackId(feedbackId),
      createdOn: dateTimeFromTimestampOrNull(map['createdOn']),
      rating: map['rating'] == null ? null : double.tryParse(map['rating']),
      likes: map['likes'] ?? '',
      dislikes: map['dislikes'] ?? '',
      missing: map['missing'] ?? '',
      heardFrom: map['heardFrom'] ?? '',
      uid: map['uid'] ?? '',
      deviceInformation: map['deviceInformation'] != null
          ? FeedbackDeviceInformation.fromJson(map['deviceInformation'])
          : null,
      unreadMessagesStatus: map['unreadMessagesStatus'] == null
          ? null
          : (map['unreadMessagesStatus'] as Map<String, dynamic>).map((key,
                  value) =>
              MapEntry(UserId(key), UnreadMessageStatus.fromJson(key, value))),
      lastMessage: map['lastMessage'] != null
          ? FeedbackChatMessage.fromJson(
              map['lastMessage']['id'], map['lastMessage'])
          : null,
    );
  }

  String? _ratingToString() {
    if (rating != null) return rating.toString();
    return null;
  }

  bool hasUnreadMessages(UserId userId) {
    return unreadMessagesStatus?[userId]?.hasUnreadMessages ?? false;
  }

  UserFeedback copyWith({
    FeedbackId? id,
    double? rating,
    String? likes,
    String? dislikes,
    String? missing,
    String? heardFrom,
    String? uid,
    FeedbackDeviceInformation? deviceInformation,
    Map<UserId, UnreadMessageStatus>? unreadMessagesStatus,
    FeedbackChatMessage? lastMessage,
  }) {
    return UserFeedback._(
      id: id ?? this.id,
      createdOn: createdOn,
      rating: rating ?? this.rating,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      missing: missing ?? this.missing,
      heardFrom: heardFrom ?? this.heardFrom,
      uid: uid ?? this.uid,
      deviceInformation: deviceInformation ?? this.deviceInformation,
      unreadMessagesStatus: unreadMessagesStatus ?? this.unreadMessagesStatus,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserFeedback &&
        other.createdOn == createdOn &&
        other.id == id &&
        other.rating == rating &&
        other.likes == likes &&
        other.dislikes == dislikes &&
        other.missing == missing &&
        other.heardFrom == heardFrom &&
        other.uid == uid &&
        other.deviceInformation == deviceInformation;
  }

  @override
  int get hashCode {
    return createdOn.hashCode ^
        id.hashCode ^
        rating.hashCode ^
        likes.hashCode ^
        dislikes.hashCode ^
        missing.hashCode ^
        heardFrom.hashCode ^
        uid.hashCode ^
        deviceInformation.hashCode;
  }

  @override
  String toString() {
    return 'UserFeedback(createdOn: $createdOn, id: $id, rating: $rating, likes: $likes, dislikes: $dislikes, missing: $missing, heardFrom: $heardFrom, uid: $uid, deviceInformation: $deviceInformation)';
  }
}

class UnreadMessageStatus extends Equatable {
  final UserId userId;
  final bool hasUnreadMessages;

  const UnreadMessageStatus({
    required this.hasUnreadMessages,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'hasUnreadMessages': hasUnreadMessages,
    };
  }

  factory UnreadMessageStatus.fromJson(
      String userId, Map<String, dynamic> map) {
    return UnreadMessageStatus(
      userId: UserId(userId),
      hasUnreadMessages: map['hasUnreadMessages'] ?? false,
    );
  }

  @override
  List<Object?> get props => [hasUnreadMessages];
}

class FeedbackDeviceInformation {
  final String appName;
  final String packageName;
  final String versionName;
  final String versionNumber;

  const FeedbackDeviceInformation._({
    required this.appName,
    required this.packageName,
    required this.versionName,
    required this.versionNumber,
  });

  FeedbackDeviceInformation copyWith({
    String? appName,
    String? packageName,
    String? versionName,
    String? versionNumber,
  }) {
    return FeedbackDeviceInformation._(
      appName: appName ?? this.appName,
      packageName: packageName ?? this.packageName,
      versionName: versionName ?? this.versionName,
      versionNumber: versionNumber ?? this.versionNumber,
    );
  }

  factory FeedbackDeviceInformation.create() {
    return const FeedbackDeviceInformation._(
      appName: "",
      packageName: "",
      versionName: "",
      versionNumber: "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'packageName': packageName,
      'versionName': versionName,
      'versionNumber': versionNumber,
    };
  }

  factory FeedbackDeviceInformation.fromJson(Map<String, dynamic> map) {
    return FeedbackDeviceInformation._(
      appName: map['appName'] ?? '',
      packageName: map['packageName'] ?? '',
      versionName: map['versionName'] ?? '',
      versionNumber: map['versionNumber'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FeedbackDeviceInformation &&
            appName == other.appName &&
            packageName == other.packageName &&
            versionName == other.versionName &&
            versionNumber == other.versionNumber);
  }

  @override
  int get hashCode =>
      appName.hashCode ^
      packageName.hashCode ^
      versionName.hashCode ^
      versionNumber.hashCode;

  @override
  String toString() {
    return "FeedbackDeviceInformation(appName: $appName, packageName: $packageName, versionName: $versionName, versionNumber: $versionNumber)";
  }
}
