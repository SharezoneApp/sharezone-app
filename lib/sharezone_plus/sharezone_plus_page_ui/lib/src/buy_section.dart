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
import 'package:sharezone_plus_page_ui/src/styled_markdown_text.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

enum PurchasePeriod {
  /// A monthly subscription for Sharezone Plus.
  monthly,

  /// A lifetime purchase for Sharezone Plus.
  ///
  /// This is a one-time purchase that gives the user Sharezone Plus for a
  /// lifetime.
  lifetime,
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
    required this.onPressedTermsOfService,
    required this.onPressedPrivacyPolicy,
    this.isPriceLoading = false,
    this.isPurchaseButtonLoading = false,
    this.onLetParentsBuy,
    this.showLetParentsBuyButton = false,
    this.isLetParentsBuyButtonLoading = false,
    this.bottom,
  });

  final bool isPriceLoading;
  final bool isPurchaseButtonLoading;
  final String? monthlyPrice;
  final String? lifetimePrice;
  final VoidCallback? onPurchase;
  final VoidCallback? onLetParentsBuy;
  final bool showLetParentsBuyButton;
  final bool isLetParentsBuyButtonLoading;
  final PurchasePeriod currentPeriod;
  final ValueChanged<PurchasePeriod> onPeriodChanged;
  final Widget? bottom;
  final VoidCallback? onPressedTermsOfService;
  final VoidCallback? onPressedPrivacyPolicy;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          // We need to align the children at the top to prevent the children
          // from being centered when the previous child is removed. Otherwise,
          // the new child will be centered and then move to the top (which
          // looks weird).
          alignment: Alignment.topCenter,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: Column(
        key: ValueKey([isPriceLoading, currentPeriod]),
        children: [
          MaxWidthConstraintBox(
            maxWidth: 500,
            child: RadioGroup(
              groupValue: currentPeriod,
              onChanged: (value) {
                if (value != null && !isPriceLoading) onPeriodChanged(value);
              },
              child: Column(
                children: [
                  _PeriodOption(
                    name: 'Monatlich',
                    price: monthlyPrice,
                    period: PurchasePeriod.monthly,
                    onPeriodChanged: onPeriodChanged,
                    isLoading: isPriceLoading,
                  ),
                  const SizedBox(height: 6),
                  _PeriodOption(
                    name: 'Lebenslang (einmaliger Kauf)',
                    price: lifetimePrice,
                    period: PurchasePeriod.lifetime,
                    onPeriodChanged: onPeriodChanged,
                    isLoading: isPriceLoading,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _PurchaseButton(
            period: currentPeriod,
            onPressed: onPurchase,
            isEnabled: !isPriceLoading && !isPurchaseButtonLoading,
            isLoading: isPriceLoading || isPurchaseButtonLoading,
          ),
          if (showLetParentsBuyButton && onLetParentsBuy != null) ...[
            const SizedBox(height: 6),
            _LetParentsBuyButton(
              onPressed: onLetParentsBuy!,
              isLoading: isLetParentsBuyButtonLoading,
            ),
          ],
          const SizedBox(height: 12),
          _LegalText(
            period: currentPeriod,
            monthlyPrice: monthlyPrice,
            lifetimePrice: lifetimePrice,
            onPressedTermsOfService: onPressedTermsOfService,
            onPressedPrivacyPolicy: onPressedPrivacyPolicy,
          ),
          if (bottom != null) bottom!,
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
    return IgnorePointer(
      ignoring: isLoading,
      child: CallToActionButton(
        text:
            isLoading
                ? const _LoadingSpinner(color: Colors.white)
                : Text(switch (period) {
                  PurchasePeriod.monthly => 'Abonnieren',
                  PurchasePeriod.lifetime => 'Kaufen',
                }),
        onPressed: onPressed,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _LetParentsBuyButton extends StatelessWidget {
  const _LetParentsBuyButton({
    required this.onPressed,
    required this.isLoading,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return IgnorePointer(
      ignoring: isLoading,
      child: CallToActionButton(
        text:
            isLoading
                ? _LoadingSpinner(color: primaryColor)
                : const Text('Eltern bezahlen lassen'),
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        borderColor: primaryColor,
        textColor: primaryColor,
      ),
    );
  }
}

class _LoadingSpinner extends StatelessWidget {
  const _LoadingSpinner({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.5,
      width: 24.5,
      child: CircularProgressIndicator(color: color),
    );
  }
}

class _PeriodOption extends StatelessWidget {
  const _PeriodOption({
    required this.name,
    required this.price,
    required this.period,
    required this.onPeriodChanged,
    required this.isLoading,
  });

  final String name;
  final String? price;
  final PurchasePeriod period;
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
          trailing: Radio<PurchasePeriod>(value: period),
          subtitle: Text(
            price ?? '...',
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegalText extends StatelessWidget {
  const _LegalText({
    required this.period,
    required this.monthlyPrice,
    required this.lifetimePrice,
    required this.onPressedTermsOfService,
    required this.onPressedPrivacyPolicy,
  });

  final PurchasePeriod period;
  final String? monthlyPrice;
  final String? lifetimePrice;
  final VoidCallback? onPressedTermsOfService;
  final VoidCallback? onPressedPrivacyPolicy;

  @override
  Widget build(BuildContext context) {
    return switch (period) {
      PurchasePeriod.monthly => _MonthlySubscriptionLegalText(
        price: monthlyPrice,
        onPressedTermsOfService: onPressedTermsOfService,
        onPressedPrivacyPolicy: onPressedPrivacyPolicy,
      ),
      PurchasePeriod.lifetime => _LifetimeLegalText(
        price: lifetimePrice,
        onPressedTermsOfService: onPressedTermsOfService,
        onPressedPrivacyPolicy: onPressedPrivacyPolicy,
      ),
    };
  }
}

const _termsOfServiceSentence =
    'Durch den Kauf bestätigst du, dass du die [ANBs](https://sharezone.net/terms-of-service) gelesen hast. Wir verarbeiten deine Daten gemäß unserer [Datenschutzerklärung](https://sharezone.net/privacy-policy)';

class _LifetimeLegalText extends StatelessWidget {
  const _LifetimeLegalText({
    required this.price,
    required this.onPressedTermsOfService,
    required this.onPressedPrivacyPolicy,
  });

  final String? price;
  final VoidCallback? onPressedTermsOfService;
  final VoidCallback? onPressedPrivacyPolicy;

  @override
  Widget build(BuildContext context) {
    final price = this.price ?? '...';
    return StyledMarkdownText(
      text:
          'Einmalige Zahlung von $price (kein Abo o. ä.). $_termsOfServiceSentence',
      onPressedPrivacyPolicy: onPressedPrivacyPolicy,
      onPressedTermsOfService: onPressedTermsOfService,
    );
  }
}

class _MonthlySubscriptionLegalText extends StatelessWidget {
  const _MonthlySubscriptionLegalText({
    required this.price,
    required this.onPressedTermsOfService,
    required this.onPressedPrivacyPolicy,
  });

  final String? price;
  final VoidCallback? onPressedTermsOfService;
  final VoidCallback? onPressedPrivacyPolicy;

  @override
  Widget build(BuildContext context) {
    final currentPlatform = PlatformCheck.currentPlatform;
    final price = this.price ?? '...';
    return StyledMarkdownText(
      text: switch (currentPlatform) {
        Platform.android =>
          'Dein Abo ($price/Monat) ist monatlich kündbar. Es wird automatisch verlängert, wenn du es nicht mindestens 24 Stunden vor Ablauf der aktuellen Zahlungsperiode über Google Play kündigst. $_termsOfServiceSentence',
        Platform.iOS || Platform.macOS =>
          'Dein Abo ($price/Monat) ist monatlich kündbar. Es wird automatisch verlängert, wenn du es nicht mindestens 24 Stunden vor Ablauf der aktuellen Zahlungsperiode über den App Store kündigst. $_termsOfServiceSentence',
        _ =>
          'Dein Abo ($price/Monat) ist monatlich kündbar. Es wird automatisch verlängert, wenn du es nicht vor Ablauf der aktuellen Zahlungsperiode über die App kündigst. $_termsOfServiceSentence',
      },
      onPressedPrivacyPolicy: onPressedPrivacyPolicy,
      onPressedTermsOfService: onPressedTermsOfService,
    );
  }
}
