import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';

import 'subscription_service/subscription_service.dart';

/// A widget that only shows its child if the [paidFeature] is unlocked.
///
/// By default it reroutes the user to the subscription page if the
/// [paidFeature] is not unlocked.
class SharezonePlusFeatureGuard extends StatelessWidget {
  const SharezonePlusFeatureGuard({
    Key key,
    @required this.child,
    @required this.paidFeature,
    this.onFeatureNotUnlocked,
    this.fallback = const _DefaultNotSubscribedFallbackPage(),
  }) : super(key: key);

  final Widget child;
  final PaidFeature paidFeature;
  final VoidCallback onFeatureNotUnlocked;

  /// Shown if [paidFeature] is not unlocked and [onFeatureNotUnlocked] did not
  /// redirect the user.
  final Widget fallback;

  void popAndNavigateToSubscriptionPage(BuildContext context) {
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    // TODO: Add explanation why we use popUntil here
    Navigator.of(context).popUntil((route) => route.isFirst);
    navigationBloc.navigateTo(NavigationItem.sharezonePlus);
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionService = Provider.of<SubscriptionService>(context);
    if (subscriptionService.hasFeatureUnlocked(paidFeature)) {
      return child;
    } else {
      onFeatureNotUnlocked != null
          ? onFeatureNotUnlocked()
          : popAndNavigateToSubscriptionPage(context);
      return fallback;
    }
  }
}

class _DefaultNotSubscribedFallbackPage extends StatelessWidget {
  const _DefaultNotSubscribedFallbackPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Dieses Feature ist nur mit "Sharezone Plus" verfügbar.'),
      ),
    );
  }
}
