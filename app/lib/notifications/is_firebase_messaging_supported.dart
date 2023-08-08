// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone_utils/platform.dart';

/// Returns true if the current platform supports Firebase Messaging.
bool isFirebaseMessagingSupported() {
  if (PlatformCheck.isMobile) return true;
  if (PlatformCheck.isMacOS) return true;

  // Currently, we are not able to set up Firebase Messaging on web because of
  // https://github.com/firebase/flutterfire/issues/10870.
  //
  // if (PlatformCheck.isWeb) return true;

  return false;
}
