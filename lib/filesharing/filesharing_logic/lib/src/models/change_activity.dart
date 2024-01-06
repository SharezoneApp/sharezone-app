// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone_common/firebase_helper.dart';

class ChangeActivity {
  final String? authorID;
  final String? authorName;
  final DateTime changedOn;

  ChangeActivity({
    required this.authorID,
    required this.authorName,
    required this.changedOn,
  });

  factory ChangeActivity.fromData(Map<String, dynamic> data) {
    return ChangeActivity(
        authorID: data['authorID'],
        authorName: data['authorName'],
        changedOn: dateTimeFromTimestamp(data['changedOn']));
  }

  Map<String, dynamic> toJson() {
    return {
      'authorID': authorID,
      'authorName': authorName,
      'changedOn': changedOn,
    };
  }

  ChangeActivity copyWith({
    String? authorID,
    String? authorName,
    DateTime? changedOn,
  }) {
    return ChangeActivity(
      authorID: authorID ?? this.authorID,
      authorName: authorName ?? this.authorName,
      changedOn: changedOn ?? this.changedOn,
    );
  }
}
