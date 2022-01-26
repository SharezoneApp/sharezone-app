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
  String get title => "Download für ${platform.getName()}";

  String get description =>
      "Installiere jetzt Sharezone als ${platform.getName()}-App. Die ${platform.getName()}-App läuft deutlicher stabiler & schneller als die Web-App.";

  String get actionText => "Download für ${platform.getName()}";

  String get actionLink => "$baseUrl/${platform.getName().toUpperCase()}";

  final TargetPlatform platform;

  DownloadAppTip(this.platform) : assert(platform != null);

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
  String get actionText => "Download für Mac";

  @override
  String get title => "Neu: Download für Mac";
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
    throw UnimplementedError('There is no platform name for $this');
  }
}
