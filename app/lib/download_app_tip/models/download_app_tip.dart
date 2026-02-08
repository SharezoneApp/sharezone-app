// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';

const baseUrl = "https://sharezone.net";

abstract class DownloadAppTip {
  String get title => "Download for ${platform.getName()}";

  String get description =>
      "Install Sharezone as a ${platform.getName()} app. It runs more stable and faster than the web app.";

  String get actionText => "Download for ${platform.getName()}";

  String get actionLink => "$baseUrl/${platform.getName().toUpperCase()}";

  final TargetPlatform platform;

  DownloadAppTip(this.platform);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DownloadAppTip && other.platform == platform;
  }

  @override
  int get hashCode => platform.hashCode;
}

class MacOsTip extends DownloadAppTip {
  MacOsTip() : super(TargetPlatform.macOS);

  @override
  String get actionLink => "$baseUrl/macos-direct";

  @override
  String get actionText => "Download for Mac";

  @override
  String get title => "Download for Mac";
}

class IOsTip extends DownloadAppTip {
  IOsTip() : super(TargetPlatform.iOS);
}

class AndroidTip extends DownloadAppTip {
  AndroidTip() : super(TargetPlatform.android);
}

extension on TargetPlatform {
  String getName() {
    switch (this) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.linux:
        return 'Linux';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
    }
  }
}
