// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_bloc.dart';

class SharezonePlusPageView {
  final bool hasPlus;

  /// The price of the Sharezone Plus subscription including the currency
  /// symbol.
  final String price;

  const SharezonePlusPageView({
    required this.hasPlus,
    required this.price,
  });

  const SharezonePlusPageView.empty()
      : hasPlus = false,
        price = kFallbackPrice;

  SharezonePlusPageView copyWith({
    bool? hasPlus,
    String? price,
  }) {
    return SharezonePlusPageView(
      hasPlus: hasPlus ?? this.hasPlus,
      price: price ?? this.price,
    );
  }
}
