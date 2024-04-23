// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

enum ICalLinkStatus {
  /// The link is in the process of being created or updated.
  building,

  /// The link is available for use.
  available,

  /// The link is locked and cannot be used.
  ///
  /// This could be because the Sharezone Plus subscription has expired. Once
  /// the subscription is renewed, the link will be available again.
  locked,
}
