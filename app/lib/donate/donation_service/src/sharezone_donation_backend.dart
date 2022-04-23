// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:app_functions/app_functions.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/donate/donation_service/donation_item.dart';

import '../donation_service.dart';

abstract class SharezoneDonationBackend {
  Future<void> notifyUserDonated(DonationItemId productId);
}

class AppFunctionSharezoneDonationBackend extends SharezoneDonationBackend {
  final AppFunctions appFunctions;
  final CrashAnalytics crashAnalytics;

  AppFunctionSharezoneDonationBackend({
    @required this.appFunctions,
    @required this.crashAnalytics,
  });

  @override
  Future<void> notifyUserDonated(DonationItemId productId) async {
    await _callOnDonationFunction(productId);
  }

  Future<Map<String, dynamic>> _callOnDonationFunction(
      DonationItemId donationItemId) async {
    final res = await appFunctions.callCloudFunction(
      functionName: 'onDonationCreated',
      parameters: {'donationItemId': '$donationItemId'},
    );
    if (res.hasException) {
      throw res.exception;
    }
    return res.data as Map<String, dynamic>;
  }
}
