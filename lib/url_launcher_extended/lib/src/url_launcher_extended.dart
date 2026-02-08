// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher_string.dart';

/// [UrlLauncherExtended] adds the ability to mocks the `url_launcher` by
/// wrapping the methods into a class and adds some helpful methods.
class UrlLauncherExtended {
  static const _allowedSchemes = [
    'http',
    'https',
    'mailto',
    'tel',
    'sms',
  ];

  /// Passes [url] to the underlying platform for handling.
  ///
  /// [mode] support varies significantly by platform:
  ///   - [LaunchMode.platformDefault] is supported on all platforms:
  ///     - On iOS and Android, this treats web URLs as
  ///       [LaunchMode.inAppWebView], and all other URLs as
  ///       [LaunchMode.externalApplication].
  ///     - On Windows, macOS, and Linux this behaves like
  ///       [LaunchMode.externalApplication].
  ///     - On web, this uses `webOnlyWindowName` for web URLs, and behaves like
  ///       [LaunchMode.externalApplication] for any other content.
  ///   - [LaunchMode.inAppWebView] is currently only supported on iOS and
  ///     Android. If a non-web URL is passed with this mode, an [ArgumentError]
  ///     will be thrown.
  ///   - [LaunchMode.externalApplication] is supported on all platforms.
  ///     On iOS, this should be used in cases where sharing the cookies of the
  ///     user's browser is important, such as SSO flows, since Safari View
  ///     Controller does not share the browser's context.
  ///   - [LaunchMode.externalNonBrowserApplication] is supported on iOS 10+.
  ///     This setting is used to require universal links to open in a non-browser
  ///     application.
  ///
  /// For web, [webOnlyWindowName] specifies a target for the launch. This
  /// supports the standard special link target names. For example:
  ///  - "_blank" opens the new URL in a new tab.
  ///  - "_self" opens the new URL in the current tab.
  /// Default behaviour when unset is to open the url in a new tab.
  ///
  /// Returns true if the URL was launched successful, otherwise either returns
  /// false or throws a [PlatformException] depending on the failure.
  ///
  /// (Copied form launch url_launcher)
  Future<bool> launchUrl(
    Uri url, {
    LaunchMode mode = LaunchMode.platformDefault,
    WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
    String? webOnlyWindowName,
  }) async {
    if (!_allowedSchemes.contains(url.scheme)) {
      throw ArgumentError(
        'Scheme \'${url.scheme}\' is not allowed. Allowed schemes: ${_allowedSchemes.join(', ')}',
      );
    }

    return url_launcher.launchUrl(
      url,
      mode: mode,
      webViewConfiguration: webViewConfiguration,
      webOnlyWindowName: webOnlyWindowName,
    );
  }

  /// Checks with `canLaunch` method if the url can be launched. If yes it will
  /// be launch and if it not possible a `CloudNotLaunchUrlException` will be
  /// thrown.
  Future<bool> tryLaunchOrThrow(
    Uri url, {
    LaunchMode mode = LaunchMode.platformDefault,
    WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
    String? webOnlyWindowName,
  }) async {
    final canLaunch = await canLaunchUrl(url);
    if (!canLaunch) {
      throw CouldNotLaunchUrlException(url);
    }

    return url_launcher.launchUrl(
      url,
      mode: mode,
      webViewConfiguration: webViewConfiguration,
      webOnlyWindowName: webOnlyWindowName,
    );
  }

  /// Checks whether the specified URL can be handled by some app installed on the
  /// device.
  ///
  /// (Copied form url_launcher)
  Future<bool> canLaunchUrl(Uri url) {
    if (!_allowedSchemes.contains(url.scheme)) {
      return Future.value(false);
    }

    return url_launcher.canLaunchUrl(url);
  }

  /// Encodes the given parameters into a query string.
  ///
  /// [Uri.queryParameters] constructor should be avoid due to [a
  /// bug](https://github.com/dart-lang/sdk/issues/43838) in Dart. See
  /// https://pub.dev/packages/url_launcher#encoding-urls.
  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (entry) =>
              '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}',
        )
        .join('&');
  }

  /// Create email draft to the default email app by converting the parameters
  /// into an uri, like
  /// "mailto:smith@example.com?subject=Example+Subject+%26+Symbols+are+allowed%21"
  ///
  /// Throws [CouldNotLaunchMailException] if [canLaunchUrl] returns false.
  ///
  /// [address] is the email address of the receiver, like
  /// "support@sharezone.net".
  ///
  /// [subject] is the subject (German: Betreff) of the email.
  ///
  /// [body] is the message / text of the email.
  ///
  /// Returns true if launch url is successful.
  Future<bool> tryLaunchMailOrThrow(
    String address, {
    String? subject,
    String? body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: address,
      query: _encodeQueryParameters({
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      }),
    );

    final canLaunch = await canLaunchUrl(uri);
    if (!canLaunch) {
      throw CouldNotLaunchMailException(address, subject: subject, body: body);
    }

    return launchUrl(uri);
  }
}

class CouldNotLaunchMailException implements Exception {
  final String address;
  final String? subject;
  final String? body;

  CouldNotLaunchMailException(this.address, {this.subject, this.body});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CouldNotLaunchMailException &&
        other.address == address &&
        other.subject == subject &&
        other.body == body;
  }

  @override
  int get hashCode => address.hashCode ^ subject.hashCode ^ body.hashCode;

  @override
  String toString() =>
      'CouldNotLaunchMailException(address: $address, subject: $subject, body: $body)';
}

class CouldNotLaunchUrlException implements Exception {
  /// [url] which couldn't be launched.
  final Uri url;

  CouldNotLaunchUrlException(this.url);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CouldNotLaunchUrlException && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => 'CloudNotLaunchUrlException(url: $url)';
}
