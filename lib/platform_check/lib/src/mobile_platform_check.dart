// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io' as io;
import 'models/platform.dart';

Platform getPlatform() {
  if (io.Platform.isAndroid) return Platform.android;
  if (io.Platform.isIOS) return Platform.iOS;
  if (io.Platform.isMacOS) return Platform.macOS;
  if (io.Platform.isWindows) return Platform.windows;
  if (io.Platform.isLinux) return Platform.linux;
  return Platform.other;
}
