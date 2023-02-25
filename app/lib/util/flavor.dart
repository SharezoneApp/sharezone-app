// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

/// The flavor of the application.
///
/// The flavor is used to determine which environment the application is running
/// in.
enum Flavor {
  /// The flavor for the production environment.
  ///
  /// Should be used for the release build.
  prod,

  /// The flavor for the development environment.
  ///
  /// Should be used for the debug build.
  dev,
}
