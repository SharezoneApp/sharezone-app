// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'models/platform.dart';

import 'platform_check_stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'mobile_platform_check.dart'
    // ignore: uri_does_not_exist
    if (dart.library.js) 'web_platform_check.dart' as implementation;

Platform getPlatform() {
  return implementation.getPlatform();
}

class PlatformCheck {
  PlatformCheck._();

  static Platform get currentPlatform {
    return _mockedCurrentPlatformForTesting ?? getPlatform();
  }

  @visibleForTesting
  static void setCurrentPlatformForTesting(Platform currentPlatform) {
    _mockedCurrentPlatformForTesting = currentPlatform;
  }

  static Platform _mockedCurrentPlatformForTesting;

  static bool get isAndroid => currentPlatform == Platform.android;
  static bool get isIOS => currentPlatform == Platform.iOS;
  static bool get isMacOS => currentPlatform == Platform.macOS;
  static bool get isWindows => currentPlatform == Platform.windows;
  static bool get isLinux => currentPlatform == Platform.linux;
  static bool get isWeb => currentPlatform == Platform.web;

  // These are a Combination between different Platforms;

  /// Checks whether Platform is Windows, Linux or MacOS
  static bool get isDesktop => isWindows || isLinux || isMacOS;

  /// Checks whether Platform is Android or IOS
  static bool get isMobile => isAndroid || isIOS;

  /// Checks whether Platform is Web, Windows, Linux or MacOS
  static bool get isDesktopOrWeb => isDesktop || isWeb;

  /// Checks whether Platform is iOS or macOS
  static bool get isMacOsOrIOS => isIOS || isMacOS;
}

/// A [TestVariant] that runs tests with
/// [PlatformCheck.setCurrentPlatformForTesting] set to different values of
/// [Platform]. It can only be used in widget tests.
///
/// Code example:
/// ```dart
/// testWidgets('my test', (tester) async {
///     // do something...
///   },
///   variant: PlatformCheckVariant.mobile(),
/// );
/// ```
/// This will run the Tests several times with [PlatformCheck] returning
/// different mobile platforms (android, ios).
class PlatformCheckVariant extends TestVariant<Platform> {
  /// Creates a [PlatformCheckVariant] that tests the given [values].
  const PlatformCheckVariant(this.values);

  /// Creates a [PlatformCheckVariant] that tests all values from
  /// the [Platform] enum.
  PlatformCheckVariant.all() : values = Platform.values.toSet();

  /// Creates a [PlatformCheckVariant] that includes platforms that are
  /// considered desktop platforms.
  PlatformCheckVariant.desktop()
      : values = <Platform>{
          Platform.linux,
          Platform.macOS,
          Platform.windows,
        };

  /// Creates a [PlatformCheckVariant] that includes platforms that are
  /// considered desktop & web platforms.
  PlatformCheckVariant.desktopAndWeb()
      : values = <Platform>{
          Platform.linux,
          Platform.macOS,
          Platform.windows,
          Platform.web,
        };

  /// Creates a [PlatformCheckVariant] that includes platforms that are
  /// considered web platforms.
  PlatformCheckVariant.web() : values = <Platform>{Platform.web};

  /// Creates a [PlatformCheckVariant] that includes platforms that are
  /// considered mobile platforms.
  PlatformCheckVariant.mobile()
      : values = <Platform>{
          Platform.android,
          Platform.iOS,
        };

  /// Creates a [PlatformCheckVariant] that tests only the given value of
  /// [Platform].
  PlatformCheckVariant.only(Platform platform) : values = <Platform>{platform};

  @override
  final Set<Platform> values;

  @override
  String describeValue(Platform platform) => platform.toString();

  /// This method behaviour is copied from TargetPlatformVariant
  @override
  Future<Platform> setUp(Platform platform) async {
    final previous = PlatformCheck.currentPlatform;
    PlatformCheck.setCurrentPlatformForTesting(platform);
    // Why returing [previous]? See in [TestVariant.setUp]
    return previous;
  }

  /// This method behaviour is copied from TargetPlatformVariant
  @override
  Future<void> tearDown(Platform value, Platform memento) async {
    // Why setting [memento] as current platform? See in [TestVariant.tearDown]
    PlatformCheck.setCurrentPlatformForTesting(memento);
  }
}
