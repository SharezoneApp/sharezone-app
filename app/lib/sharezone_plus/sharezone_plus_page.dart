// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/sharezone_plus/subscription_service/purchase_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/revenue_cat_sharezone_plus_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SharezonePlusPage extends StatelessWidget {
  static String tag = 'sharezone-plus-page';
  const SharezonePlusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final purchaseService = RevenueCatPurchaseService();
    final subscriptionService = Provider.of<SubscriptionService>(context);

    return SharezoneMainScaffold(
      navigationItem: NavigationItem.sharezonePlus,
      body: _PageTheme(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _Header(),

                /// Gets plus product and shows name and price and subscription payment interval
                FutureBuilder<StoreProduct>(
                  future: purchaseService.getPlusSubscriptionProduct(),
                  builder: (context, snapshot) => ListTile(
                    leading: subscriptionService.isSubscriptionActive()
                        ? Icon(Icons.check)
                        : Icon(Icons.close),
                    title: Text('Sharezone Plus'),
                    trailing: Text(snapshot.data?.priceString ?? '...'),
                  ),
                ),
                ElevatedButton(
                  child: Text('Abonnieren'),
                  onPressed: () async {
                    final purchaseService = RevenueCatPurchaseService();
                    final products = await purchaseService.getProducts();
                    print(products);

                    await purchaseService
                        .purchase(ProductId('default-dev-plus-subscription'));
                  },
                ),
                _FaqSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageTheme extends StatelessWidget {
  const _PageTheme({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    return Theme(
      data: baseTheme.copyWith(
        textTheme: baseTheme.textTheme.copyWith(
          bodyMedium: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
      child: child,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.star,
              color: darkPrimaryColor,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Entfalte das gesamte Potential für einen stressfreien Schulalltag.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _WhoIsBehindSharezone(),
      ],
    );
  }
}

class _WhoIsBehindSharezone extends StatelessWidget {
  const _WhoIsBehindSharezone();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text('Wer steht hinter Sharezone?'),
      body: Text('Nils & Jonas :)'),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
    );
  }
}
