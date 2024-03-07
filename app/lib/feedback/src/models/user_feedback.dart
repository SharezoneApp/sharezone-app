// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_helper/cloud_firestore_helper.dart';
import 'package:helper_functions/helper_functions.dart';

class UserFeedback {
  /// The date and time the feedback was created.
  ///
  /// Old feedbacks might not have this field set because it was added later.
  final DateTime? createdOn;

  final double? rating;
  final String likes;
  final String dislikes;
  final String missing;
  final String heardFrom;
  final String uid;
  final String userContactInformation;
  final FeedbackDeviceInformation? deviceInformation;

  bool get requiredUserInputIsEmpty =>
      _isWhitespaceOrNull(likes) &&
      _isWhitespaceOrNull(dislikes) &&
      _isWhitespaceOrNull(missing) &&
      _isWhitespaceOrNull(heardFrom);

  bool _isWhitespaceOrNull(String s) => isEmptyOrNull(s.trim());

  const UserFeedback._({
    required this.createdOn,
    required this.rating,
    required this.likes,
    required this.dislikes,
    required this.missing,
    required this.heardFrom,
    required this.uid,
    required this.userContactInformation,
    required this.deviceInformation,
  });

  factory UserFeedback.create() {
    return const UserFeedback._(
      createdOn: null,
      rating: null,
      likes: "",
      dislikes: "",
      missing: "",
      heardFrom: "",
      uid: "",
      userContactInformation: "",
      deviceInformation: null,
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
      'userContactInformation': userContactInformation,
      'createdOn': FieldValue.serverTimestamp(),
      'deviceInformation': deviceInformation?.toJson(),
    }..removeWhere((string, object) =>
        object == null || (object is String && object.isEmpty));
  }

  factory UserFeedback.fromJson(Map<String, dynamic> map) {
    return UserFeedback._(
      createdOn: dateTimeFromTimestampOrNull(map['createdOn']),
      rating: double.tryParse(map['rating']),
      likes: map['likes'] ?? '',
      dislikes: map['dislikes'] ?? '',
      missing: map['missing'] ?? '',
      heardFrom: map['heardFrom'] ?? '',
      uid: map['uid'] ?? '',
      userContactInformation: map['userContactInformation'] ?? '',
      deviceInformation: map['deviceInformation'] != null
          ? FeedbackDeviceInformation.fromJson(map['deviceInformation'])
          : null,
    );
  }

  String? _ratingToString() {
    if (rating != null) return rating.toString();
    return null;
  }

  UserFeedback copyWith({
    double? rating,
    String? likes,
    String? dislikes,
    String? missing,
    String? heardFrom,
    String? uid,
    String? userContactInformation,
    FeedbackDeviceInformation? deviceInformation,
  }) {
    return UserFeedback._(
      createdOn: createdOn,
      rating: rating ?? this.rating,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      missing: missing ?? this.missing,
      heardFrom: heardFrom ?? this.heardFrom,
      uid: uid ?? this.uid,
      userContactInformation:
          userContactInformation ?? this.userContactInformation,
      deviceInformation: deviceInformation ?? this.deviceInformation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserFeedback &&
        other.createdOn == createdOn &&
        other.rating == rating &&
        other.likes == likes &&
        other.dislikes == dislikes &&
        other.missing == missing &&
        other.heardFrom == heardFrom &&
        other.uid == uid &&
        other.userContactInformation == userContactInformation &&
        other.deviceInformation == deviceInformation;
  }

  @override
  int get hashCode {
    return createdOn.hashCode ^
        rating.hashCode ^
        likes.hashCode ^
        dislikes.hashCode ^
        missing.hashCode ^
        heardFrom.hashCode ^
        uid.hashCode ^
        userContactInformation.hashCode ^
        deviceInformation.hashCode;
  }

  @override
  String toString() {
    return 'UserFeedback(createdOn: $createdOn, rating: $rating, likes: $likes, dislikes: $dislikes, missing: $missing, heardFrom: $heardFrom, uid: $uid, userContactInformation: $userContactInformation, deviceInformation: $deviceInformation)';
  }
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
