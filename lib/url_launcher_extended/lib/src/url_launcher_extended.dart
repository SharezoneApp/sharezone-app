// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:ui';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

/// [UrlLauncherExtended] adds the ability to mocks the `url_launcher` by
/// wrapping the methods into a class and adds some helpful methods.
class UrlLauncherExtended {
  /// Parses the specified URL string and delegates handling of it to the
  /// underlying platform.
  ///
  /// The returned future completes with a [PlatformException] on invalid URLs and
  /// schemes which cannot be handled, that is when [canLaunch] would complete
  /// with false.
  ///
  /// [forceSafariVC] is only used in iOS with iOS version >= 9.0. By default (when unset), the launcher
  /// opens web URLs in the Safari View Controller, anything else is opened
  /// using the default handler on the platform. If set to true, it opens the
  /// URL in the Safari View Controller. If false, the URL is opened in the
  /// default browser of the phone. Note that to work with universal links on iOS,
  /// this must be set to false to let the platform's system handle the URL.
  /// Set this to false if you want to use the cookies/context of the main browser
  /// of the app (such as SSO flows). This setting will nullify [universalLinksOnly]
  /// and will always launch a web content in the built-in Safari View Controller regardless
  /// if the url is a universal link or not.
  ///
  /// [universalLinksOnly] is only used in iOS with iOS version >= 10.0. This setting is only validated
  /// when [forceSafariVC] is set to false. The default value of this setting is false.
  /// By default (when unset), the launcher will either launch the url in a browser (when the
  /// url is not a universal link), or launch the respective native app content (when
  /// the url is a universal link). When set to true, the launcher will only launch
  /// the content if the url is a universal link and the respective app for the universal
  /// link is installed on the user's device; otherwise throw a [PlatformException].
  ///
  /// [forceWebView] is an Android only setting. If null or false, the URL is
  /// always launched with the default browser on device. If set to true, the URL
  /// is launched in a WebView. Unlike iOS, browser context is shared across
  /// WebViews.
  /// [enableJavaScript] is an Android only setting. If true, WebView enable
  /// javascript.
  /// [enableDomStorage] is an Android only setting. If true, WebView enable
  /// DOM storage.
  /// [headers] is an Android only setting that adds headers to the WebView.
  ///
  /// Note that if any of the above are set to true but the URL is not a web URL,
  /// this will throw a [PlatformException].
  ///
  /// [statusBarBrightness] Sets the status bar brightness of the application
  /// after opening a link on iOS. Does nothing if no value is passed. This does
  /// not handle resetting the previous status bar style.
  ///
  /// Returns true if launch url is successful; false is only returned when [universalLinksOnly]
  /// is set to true and the universal link failed to launch.
  ///
  /// (Copied form launch url_launcher)
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
    return url_launcher.launch(
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

  /// Checks with `canLaunch` method if the url can be launched. If yes it will
  /// be launch and if it not possible a `CloudNotLaunchUrlException` will be
  /// thrown.
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
    final _canLaunch = await canLaunch(urlString);
    if (!_canLaunch) {
      throw CouldNotLaunchUrlException(urlString);
    }

    return url_launcher.launch(
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

  /// Checks whether the specified URL can be handled by some app installed on the
  /// device.
  ///
  /// (Copied form url_launcher)
  Future<bool> canLaunch(String urlString) {
    return url_launcher.canLaunch(urlString);
  }

  /// Create email draft to the default email app by converting the parameters
  /// into an uri, like
  /// "mailto:smith@example.com?subject=Example+Subject+%26+Symbols+are+allowed%21"
  ///
  /// Throws [CouldNotLaunchMailException] if [canLaunch] returns false.
  ///
  /// [address] is the email address of the receiver, like
  /// "support@sharezone.net".
  ///
  /// [subject] is the subject (German: Betreff) of the email.
  ///
  /// [body] is the message / text of the email.
  ///
  /// Returns true if launch url is successful.
  Future<bool> tryLaunchMailOrThrow(String address,
      {String subject, String body}) async {
    assert(address != null);

    final emailLaunchString = Uri(
      scheme: 'mailto',
      path: address,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    ).toString();

    final _canLaunch = await canLaunch(emailLaunchString);
    if (!_canLaunch) {
      throw CouldNotLaunchMailException(address, subject: subject, body: body);
    }

    return launch(emailLaunchString);
  }
}

class CouldNotLaunchMailException implements Exception {
  final String address;
  final String subject;
  final String body;

  CouldNotLaunchMailException(this.address, {this.subject, this.body});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CouldNotLaunchMailException &&
        o.address == address &&
        o.subject == subject &&
        o.body == body;
  }

  @override
  int get hashCode => address.hashCode ^ subject.hashCode ^ body.hashCode;

  @override
  String toString() =>
      'CouldNotLaunchMailException(address: $address, subject: $subject, body: $body)';
}

class CouldNotLaunchUrlException implements Exception {
  /// URL as string which couldn't be launched.
  final String url;

  CouldNotLaunchUrlException(this.url);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CouldNotLaunchUrlException && o.url == url;
  }

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => 'CloudNotLaunchUrlException(url: $url)';
}
