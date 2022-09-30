// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:meta/meta.dart';

/// Version values of the current Android operating system build derived from
/// `android.os.Build.VERSION`.
///
/// See: https://developer.android.com/reference/android/os/Build.VERSION.html
class AndroidDeviceInformation {
  AndroidDeviceInformation({
    required this.version,
    required this.board,
    required this.bootloader,
    required this.brand,
    required this.device,
    required this.display,
    required this.fingerprint,
    required this.hardware,
    required this.host,
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.product,
    required List<String?> supported32BitAbis,
    required List<String?> supported64BitAbis,
    required List<String?> supportedAbis,
    required this.tags,
    required this.type,
    required this.isPhysicalDevice,
    required this.androidId,
  })  : supported32BitAbis = List<String>.unmodifiable(supported32BitAbis),
        supported64BitAbis = List<String>.unmodifiable(supported64BitAbis),
        supportedAbis = List<String>.unmodifiable(supportedAbis);

  /// Android operating system version values derived from `android.os.Build.VERSION`.
  final AndroidBuildVersion version;

  /// The name of the underlying board, like "goldfish".
  final String? board;

  /// The system bootloader version number.
  final String? bootloader;

  /// The consumer-visible brand with which the product/hardware will be associated, if any.
  final String? brand;

  /// The name of the industrial design.
  final String? device;

  /// A build ID string meant for displaying to the user.
  final String? display;

  /// A string that uniquely identifies this build.
  final String? fingerprint;

  /// The name of the hardware (from the kernel command line or /proc).
  final String? hardware;

  /// Hostname.
  final String? host;

  /// Either a changelist number, or a label like "M4-rc20".
  final String? id;

  /// The manufacturer of the product/hardware.
  final String? manufacturer;

  /// The end-user-visible name for the end product.
  final String? model;

  /// The name of the overall product.
  final String? product;

  /// An ordered list of 32 bit ABIs supported by this device.
  final List<String> supported32BitAbis;

  /// An ordered list of 64 bit ABIs supported by this device.
  final List<String> supported64BitAbis;

  /// An ordered list of ABIs supported by this device.
  final List<String> supportedAbis;

  /// Comma-separated tags describing the build, like "unsigned,debug".
  final String? tags;

  /// The type of build, like "user" or "eng".
  final String? type;

  /// `false` if the application is running in an emulator, `true` otherwise.
  final bool? isPhysicalDevice;

  /// The Android hardware device ID that is unique between the device + user and app signing.
  final String? androidId;
}

class AndroidBuildVersion {
  AndroidBuildVersion({
    this.baseOS,
    this.codename,
    this.incremental,
    this.previewSdkInt,
    this.release,
    this.sdkInt,
    this.securityPatch,
  });

  /// The base OS build the product is based on.
  final String? baseOS;

  /// The current development codename, or the string "REL" if this is a release build.
  final String? codename;

  /// The internal value used by the underlying source control to represent this build.
  final String? incremental;

  /// The developer preview revision of a prerelease SDK.
  final int? previewSdkInt;

  /// The user-visible version string.
  final String? release;

  /// The user-visible SDK version of the framework.
  ///
  /// Possible values are defined in: https://developer.android.com/reference/android/os/Build.VERSION_CODES.html
  final int? sdkInt;

  /// The user-visible security patch level.
  final String? securityPatch;
}