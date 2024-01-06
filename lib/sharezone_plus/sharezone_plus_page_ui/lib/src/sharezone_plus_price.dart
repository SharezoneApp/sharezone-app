// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SharezonePlusPriceLoadingIndicator extends StatelessWidget {
  const SharezonePlusPriceLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const GrayShimmer(child: SharezonePlusPrice('-,-- €'));
  }
}

class SharezonePlusPrice extends StatelessWidget {
  const SharezonePlusPrice(
    this.monthlyPriceWithCurrencySign, {
    super.key,
  });

  final String monthlyPriceWithCurrencySign;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          monthlyPriceWithCurrencySign,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            '/Monat',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
