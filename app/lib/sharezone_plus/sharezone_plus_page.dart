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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: MaxWidthConstraintBox(
              maxWidth: 750,
              child: Column(
                children: [
                  _Header(),
                  const SizedBox(height: 18),
                  _WhyPlusSharezoneCard(),
                  const SizedBox(height: 18),
                  _Advantages(),

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
            color: Colors.grey[600],
          ),
          headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
            fontSize: 18,
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

class _WhyPlusSharezoneCard extends StatelessWidget {
  const _WhyPlusSharezoneCard();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 710,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.5),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
          child: Column(
            children: const [
              _WhyPlusSharezoneImage(),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    _WhyPlusSharezoneHeadline(),
                    SizedBox(height: 8),
                    _WhyPlusSharezoneText(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class _WhyPlusSharezoneText extends StatelessWidget {
  const _WhyPlusSharezoneText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Neben einem Studium können wir, Jonas und Nils, die monatlichen Kosten von 1.000 € für Sharezone nicht selbst tragen. Daher haben wir Sharezone Plus entwickelt - der Schlüssel zur Fortführung und Werbefreiheit unserer App.',
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );
  }
}

class _WhyPlusSharezoneHeadline extends StatelessWidget {
  const _WhyPlusSharezoneHeadline();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Warum kostet Sharezone Plus Geld?',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}

class _WhyPlusSharezoneImage extends StatelessWidget {
  const _WhyPlusSharezoneImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17.5),
        child: Image.asset(
          'assets/images/jonas-nils.png',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}

class _Advantages extends StatelessWidget {
  const _Advantages({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AdvantageTile(
          icon: Icon(Icons.favorite),
          title: Text('Untersützung von Open-Source'),
          description: Text(
              'Sharezone ist Open-Source. Das bedeutet, dass jeder den Quellcode von Sharezone einsehen und sogar verbessern kann. Wir glauben, dass Open-Source die Zukunft ist und wollen Sharezone zu einem Vorzeigeprojekt machen.'),
        ),
      ],
    );
  }
}

class _AdvantageTile extends StatelessWidget {
  const _AdvantageTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.description,
  });

  final Icon icon;
  final Widget title;
  final Widget? subtitle;
  final Widget description;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF6FCF97);
    return ExpansionCard(
      header: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconTheme(
                data: IconThemeData(color: green),
                child: icon,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              if (subtitle != null) subtitle!,
            ],
          ),
        ],
      ),
      body: description,
      backgroundColor: Colors.transparent,
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 710,
      child: Column(
        children: const [
          _WhoIsBehindSharezone(),
        ],
      ),
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
