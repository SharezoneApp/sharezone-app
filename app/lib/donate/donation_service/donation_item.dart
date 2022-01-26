// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:meta/meta.dart';

class DonationItemId extends Id {
  DonationItemId(String id) : super(id, 'DonationItemId');
}

class DonationItem {
  final DonationItemId id;
  final String title;
  final String formattedPrice;

  DonationItem({
    @required this.id,
    @required this.title,
    @required this.formattedPrice,
  });
}
