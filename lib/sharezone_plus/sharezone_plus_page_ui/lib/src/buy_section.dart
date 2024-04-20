// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone_plus_page_ui/sharezone_plus_page_ui.dart';
import 'package:sharezone_plus_page_ui/src/markdown_centered_text.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

enum PurchasePeriod {
  /// A monthly subscription for Sharezone Plus.
  monthlySubscription,

  /// A lifetime purchase for Sharezone Plus.
  ///
  /// This is a one-time purchase that gives the user Sharezone Plus for a
  /// lifetime.
  lifetimePurchase,
}

/// A section where the user can the select the plan they want to buy and start
/// the purchase process.
class BuySection extends StatelessWidget {
  const BuySection({
    super.key,
    required this.monthlyPrice,
    required this.lifetimePrice,
    required this.onPurchase,
    required this.currentPeriod,
    required this.onPeriodChanged,
    this.isLoading = false,
  });

  final bool isLoading;
  final String? monthlyPrice;
  final String? lifetimePrice;
  final VoidCallback? onPurchase;
  final PurchasePeriod currentPeriod;
  final ValueChanged<PurchasePeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: Column(
        key: ValueKey([isLoading, currentPeriod]),
        children: [
          _PeriodOption(
            name: 'Monatlich',
            price: monthlyPrice,
            period: PurchasePeriod.monthlySubscription,
            currentPeriod: currentPeriod,
            onPeriodChanged: onPeriodChanged,
            isLoading: isLoading,
          ),
          const SizedBox(height: 6),
          _PeriodOption(
            name: 'Lifetime (einmaliger Kauf)',
            price: lifetimePrice,
            period: PurchasePeriod.lifetimePurchase,
            currentPeriod: currentPeriod,
            onPeriodChanged: onPeriodChanged,
            isLoading: isLoading,
          ),
          const SizedBox(height: 12),
          _PurchaseButton(
            period: currentPeriod,
            onPressed: onPurchase,
            isEnabled: !isLoading,
            isLoading: isLoading,
          ),
          const SizedBox(height: 12),
          _LegalText(period: currentPeriod),
        ],
      ),
    );
  }
}

class _PurchaseButton extends StatelessWidget {
  const _PurchaseButton({
    required this.period,
    required this.onPressed,
    required this.isEnabled,
    required this.isLoading,
  });

  final PurchasePeriod period;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GrayShimmer(
      enabled: isLoading,
      child: CallToActionButton(
        text: Text(
          switch (period) {
            PurchasePeriod.monthlySubscription => 'Abonnieren',
            PurchasePeriod.lifetimePurchase => 'Kaufen',
          },
        ),
        onPressed: isEnabled ? onPressed : null,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _PeriodOption extends StatelessWidget {
  const _PeriodOption({
    required this.name,
    required this.price,
    required this.period,
    required this.currentPeriod,
    required this.onPeriodChanged,
    required this.isLoading,
  });

  final String name;
  final String? price;
  final PurchasePeriod period;
  final PurchasePeriod currentPeriod;
  final ValueChanged<PurchasePeriod> onPeriodChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GrayShimmer(
      enabled: isLoading,
      child: CustomCard(
        child: ListTile(
          title: Text(name),
          onTap: isLoading ? null : () => onPeriodChanged(period),
          trailing: Radio<PurchasePeriod>(
            groupValue: currentPeriod,
            value: period,
            onChanged: (v) {
              if (v != null && !isLoading) onPeriodChanged(v);
            },
          ),
          subtitle: Text(
            price ?? '...',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegalText extends StatelessWidget {
  const _LegalText({required this.period});

  final PurchasePeriod period;

  @override
  Widget build(BuildContext context) {
    return switch (period) {
      PurchasePeriod.monthlySubscription =>
        const _MonthlySubscriptionLegalText(),
      PurchasePeriod.lifetimePurchase => const _LifetimeLegalText(),
    };
  }
}

const _termsOfServiceSentence =
    'Durch den Kauf bestätigst du, dass du die [ANBs](https://sharezone.net/terms-of-service) gelesen hast.';

class _LifetimeLegalText extends StatelessWidget {
  const _LifetimeLegalText();

  @override
  Widget build(BuildContext context) {
    return const MarkdownCenteredText(
      text: 'Einmalige Zahlung (kein Abo o. ä.). $_termsOfServiceSentence',
    );
  }
}

class _MonthlySubscriptionLegalText extends StatelessWidget {
  const _MonthlySubscriptionLegalText();

  @override
  Widget build(BuildContext context) {
    final currentPlatform = PlatformCheck.currentPlatform;
    return MarkdownCenteredText(
        text: switch (currentPlatform) {
      Platform.android =>
        'Dein Abo ist monatlich kündbar. Es wird automatisch verlängert, wenn du es nicht mindestens 24 Stunden vor Ablauf der aktuellen Zahlungsperiode über Google Play kündigst. $_termsOfServiceSentence',
      Platform.iOS ||
      Platform.macOS =>
        'Dein Abo ist monatlich kündbar. Es wird automatisch verlängert, wenn du es nicht mindestens 24 Stunden vor Ablauf der aktuellen Zahlungsperiode über den App Store kündigst. $_termsOfServiceSentence',
      _ =>
        'Dein Abo ist monatlich kündbar. Es wird automatisch verlängert, wenn du es nicht vor Ablauf der aktuellen Zahlungsperiode über die App kündigst. $_termsOfServiceSentence',
    });
  }
}
