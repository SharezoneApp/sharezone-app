// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:url_launcher/url_launcher.dart' as launcher;

import 'url_launcher_extended.dart';

/// Mocks [UrlLauncherExtended] to be used in testing environment.
class MockUrlLauncherExtended extends UrlLauncherExtended {
  /// If method [launchUrl] is called, it will be set to true.
  bool logCalledLaunch = false;

  /// When [launchUrl] is called with an url, this url will be stored in
  /// [launchedUrl].
  Uri? launchedUrl;

  /// If method [launchMail] is called, it will be set to true.
  bool logCalledLaunchMail = false;

  bool _canLaunch = true;

  @override
  Future<bool> canLaunchUrl(Uri url) async {
    return _canLaunch;
  }

  void setCanLaunch(bool canLaunch) {
    _canLaunch = canLaunch;
  }

  @override
  Future<bool> launchUrl(
    Uri url, {
    launcher.LaunchMode mode = launcher.LaunchMode.platformDefault,
    launcher.WebViewConfiguration webViewConfiguration =
        const launcher.WebViewConfiguration(),
    String? webOnlyWindowName,
  }) async {
    logCalledLaunch = true;
    launchedUrl = url;
    return true;
  }

  @override
  Future<bool> tryLaunchMailOrThrow(
    String address, {
    String? subject,
    String? body,
  }) async {
    logCalledLaunchMail = true;
    return true;
  }

  void setLaunchMail(bool launchMail) {
    logCalledLaunchMail = launchMail;
  }

  @override
  Future<bool> tryLaunchOrThrow(
    Uri url, {
    launcher.LaunchMode mode = launcher.LaunchMode.platformDefault,
    launcher.WebViewConfiguration webViewConfiguration =
        const launcher.WebViewConfiguration(),
    String? webOnlyWindowName,
  }) async {
    if (!(await canLaunchUrl(url))) {
      CouldNotLaunchUrlException(url);
    }

    return launchUrl(
      url,
      mode: mode,
      webViewConfiguration: webViewConfiguration,
      webOnlyWindowName: webOnlyWindowName,
    );
  }
}
