// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

/// Information derived from `UIDevice`.
///
/// See: https://developer.apple.com/documentation/uikit/uidevice
class IosDeviceInformation {
  IosDeviceInformation({
    required this.name,
    required this.systemName,
    required this.systemVersion,
    required this.model,
    required this.localizedModel,
    required this.identifierForVendor,
    required this.isPhysicalDevice,
    required this.utsname,
  });

  /// Device name.
  final String? name;

  /// The name of the current operating system.
  final String? systemName;

  /// The current operating system version.
  final String? systemVersion;

  /// Device model.
  final String? model;

  /// Localized name of the device model.
  final String? localizedModel;

  /// Unique UUID value identifying the current device.
  final String? identifierForVendor;

  /// `false` if the application is running in a simulator, `true` otherwise.
  final bool isPhysicalDevice;

  /// Operating system information derived from `sys/utsname.h`.
  final IosUtsname utsname;
}

/// Information derived from `utsname`.
/// See http://pubs.opengroup.org/onlinepubs/7908799/xsh/sysutsname.h.html for details.
class IosUtsname {
  IosUtsname({
    required this.sysname,
    required this.nodename,
    required this.release,
    required this.version,
    required this.machine,
  });

  /// Operating system name.
  final String? sysname;

  /// Network node name.
  final String? nodename;

  /// Release level.
  final String? release;

  /// Version level.
  final String? version;

  /// Hardware type (e.g. 'iPhone7,1' for iPhone 6 Plus).
  final String? machine;
}