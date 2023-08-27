// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:flutter/material.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';

class DownloadAppTipCache {
  final StreamingKeyValueStore _streamingKeyValueStore;

  static const macOsKey = 'already-showed-macos-app-tip';
  static const androidKey = 'already-showed-android-app-tip';
  static const iOsKey = 'already-showed-ios-app-tip';

  DownloadAppTipCache(this._streamingKeyValueStore);

  Stream<bool> alreadyShowedTip(TargetPlatform platform) =>
      _streamingKeyValueStore.getBool(_getPlatformKey(platform),
          defaultValue: false);

  void markTipAsShown(TargetPlatform platform) =>
      _streamingKeyValueStore.setBool(_getPlatformKey(platform), true);

  String _getPlatformKey(TargetPlatform platform) {
    if (platform.isAndroid) return androidKey;
    if (platform.isMacOS) return macOsKey;
    if (platform.isIOS) return iOsKey;

    throw UnimplementedError("No key for $platform");
  }
}

extension on TargetPlatform {
  bool get isAndroid => this == TargetPlatform.android;
  bool get isIOS => this == TargetPlatform.iOS;
  bool get isMacOS => this == TargetPlatform.macOS;
}
