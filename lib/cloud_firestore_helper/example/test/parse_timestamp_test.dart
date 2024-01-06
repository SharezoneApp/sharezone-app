// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_helper/cloud_firestore_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // This method is not tested in the 'could_firestore_helper' package, because
  // we don't want to depend on the 'cloud_firestore' package in the
  // 'cloud_firestore_helper' package.
  group('dateTimeFromTimestampOrNull()', () {
    test('should return null if timestamp is null', () {
      final result = dateTimeFromTimestampOrNull(null);
      expect(result, null);
    });

    test('should return DateTime if timestamp is not null', () {
      final dateTime = DateTime(2024, 1, 1);
      final timestamp = Timestamp.fromDate(dateTime);

      final result = dateTimeFromTimestampOrNull(timestamp);
      expect(result, dateTime);
    });
  });
}
