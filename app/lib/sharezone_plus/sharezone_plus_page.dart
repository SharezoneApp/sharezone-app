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

class SharezonePlusPage extends StatelessWidget {
  static String tag = 'sharezone-plus-page';
  const SharezonePlusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final purchaseService = RevenueCatPurchaseService();
    final subscriptionService = Provider.of<SubscriptionService>(context);

    return SharezoneMainScaffold(
      navigationItem: NavigationItem.sharezonePlus,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Jetzt Sharezone Plus holen!'),

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
            )
          ],
        ),
      ),
    );
  }
}
