// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:sharezone/ical_links/dialog/ical_links_dialog_controller.dart';
import 'package:sharezone/ical_links/shared/ical_link_analytics.dart';
import 'package:sharezone/ical_links/shared/ical_links_gateway.dart';

class ICalLinksDialogControllerFactory {
  final ICalLinksGateway gateway;
  final ICalLinksAnalytics analytics;
  final UserId userId;

  const ICalLinksDialogControllerFactory({
    required this.gateway,
    required this.analytics,
    required this.userId,
  });

  ICalLinksDialogController create() {
    return ICalLinksDialogController(
      gateway: gateway,
      analytics: analytics,
      userId: userId,
    );
  }
}
