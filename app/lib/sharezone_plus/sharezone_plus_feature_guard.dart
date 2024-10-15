// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';

import 'subscription_service/subscription_service.dart';

/// A widget that only shows its child if the [feature] is unlocked.
///
/// By default it reroutes the user to the subscription page if the
/// [feature] is not unlocked.
class SharezonePlusFeatureGuard extends StatelessWidget {
  const SharezonePlusFeatureGuard({
    super.key,
    required this.child,
    required this.feature,
    this.onFeatureNotUnlocked,
    this.fallback = const _DefaultNotSubscribedFallbackPage(),
  });

  final Widget child;
  final SharezonePlusFeature feature;
  final VoidCallback? onFeatureNotUnlocked;

  /// Shown if [feature] is not unlocked and [onFeatureNotUnlocked] did not
  /// redirect the user.
  final Widget fallback;

  void popAndNavigateToSubscriptionPage(BuildContext context) {
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    // Pop until were at the top level route (where the bottom navigation bar or
    // desktop navigation is visible)...
    Navigator.of(context).popUntil((route) => route.isFirst);
    // ...and navigate to the subscription page.
    navigationBloc.navigateTo(NavigationItem.sharezonePlus);
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionService = Provider.of<SubscriptionService>(context);
    if (subscriptionService.hasFeatureUnlocked(feature)) {
      return child;
    } else {
      // Otherwise we run into this problem:
      // ```
      // setState() or markNeedsBuild() called during build.
      // This Overlay widget cannot be marked as needing to build because the framework is already in the process of building widgets.
      // A widget can be marked as needing to be built during the build phase only if one of its ancestors is currently building.
      // This exception is allowed because the framework builds parent widgets before children, which means a dirty descendant will always be built.
      // Otherwise, the framework might not visit this widget during this build phase.
      //
      // The widget on which setState() or markNeedsBuild() was called was:
      //  Overlay-[LabeledGlobalKey<OverlayState>#06500]
      //
      // The widget which was currently being built when the offending call was made was:
      //  SharezonePlusFeatureGuard
      // ```
      Future.delayed(Duration.zero).then((_) {
        if (!context.mounted) return;
        onFeatureNotUnlocked != null
            ? onFeatureNotUnlocked!()
            : popAndNavigateToSubscriptionPage(context);
      });
      return fallback;
    }
  }
}

class _DefaultNotSubscribedFallbackPage extends StatelessWidget {
  const _DefaultNotSubscribedFallbackPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Dieses Feature ist nur mit "Sharezone Plus" verfügbar.'),
      ),
    );
  }
}
