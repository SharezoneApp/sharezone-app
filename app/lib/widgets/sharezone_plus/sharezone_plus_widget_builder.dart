// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';

/// Builds a widget depending on the user's Sharezone Plus status.
class SharezonePlusWidgetBuilder extends StatelessWidget {
  const SharezonePlusWidgetBuilder({
    super.key,
    required this.onHasPlus,
    required this.onHasNoPlus,
  });

  /// Widget to build if the user has Sharezone Plus.
  final Widget onHasPlus;

  /// Widget to build if the user has no Sharezone Plus.
  final Widget onHasNoPlus;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<SubscriptionService>().isSubscriptionActiveStream(),
      builder: (context, snapshot) {
        final hasPlus = snapshot.data ?? false;
        return hasPlus ? onHasPlus : onHasNoPlus;
      },
    );
  }
}
