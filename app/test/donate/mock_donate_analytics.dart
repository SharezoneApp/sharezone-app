// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/donate/analytics/donation_analytics.dart';
import 'package:sharezone/donate/donation_service/donation_service.dart';
import 'package:sharezone_utils/src/platform/models/platform.dart';

class MockDonateAnalytics implements DonationAnalytics {
  bool donationLogged = false;
  bool donationPageOpenedLogged = false;
  bool donationViaMacOsLogged = false;

  @override
  void logDonation(DonationItemId id) {
    donationLogged = true;
  }

  @override
  void logDonationPageOpened(Platform platform) {
    donationPageOpenedLogged = true;
  }

  @override
  void logPressedDonationButtonOnMacOs() {
    donationViaMacOsLogged = true;
  }
}
