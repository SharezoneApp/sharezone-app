// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:ui';

import 'url_launcher_extended.dart';

/// Mocks [UrlLauncherExtended] to be used in testing environment.
class MockUrlLauncherExtended extends UrlLauncherExtended {
  /// If method [launch] is called, it will be set to true.
  bool logCalledLaunch = false;

  /// When [launch] is called with an url, this url will be stored in
  /// [launchedUrl].
  String launchedUrl;

  /// If method [launchMail] is called, it will be set to true.
  bool logCalledLaunchMail = false;

  bool _canLaunch = true;

  @override
  Future<bool> canLaunch(String urlString) async {
    return _canLaunch;
  }

  void setCanLaunch(bool canLaunch) {
    _canLaunch = canLaunch;
  }

  @override
  Future<bool> launch(
    String urlString, {
    bool forceSafariVC,
    bool forceWebView,
    bool enableJavaScript,
    bool enableDomStorage,
    bool universalLinksOnly,
    Map<String, String> headers,
    Brightness statusBarBrightness,
  }) async {
    logCalledLaunch = true;
    launchedUrl = urlString;
    return true;
  }

  @override
  Future<bool> tryLaunchMailOrThrow(String address,
      {String subject, String body}) async {
    logCalledLaunchMail = true;
    return true;
  }

  void setLaunchMail(bool launchMail) {
    logCalledLaunchMail = launchMail;
  }

  @override
  Future<bool> tryLaunchOrThrow(
    String urlString, {
    bool forceSafariVC,
    bool forceWebView,
    bool enableJavaScript,
    bool enableDomStorage,
    bool universalLinksOnly,
    Map<String, String> headers,
    Brightness statusBarBrightness,
  }) async {
    if (!(await canLaunch(urlString))) {
      CouldNotLaunchUrlException(urlString);
    }

    return launch(
      urlString,
      forceSafariVC: forceSafariVC,
      forceWebView: forceWebView,
      enableJavaScript: enableJavaScript,
      enableDomStorage: enableDomStorage,
      universalLinksOnly: universalLinksOnly,
      headers: headers,
      statusBarBrightness: statusBarBrightness,
    );
  }
}
