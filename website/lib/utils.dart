// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

/// Launches the given [url] in the browser.
///
/// If the [url] can't be launched, a [SnackBar] is shown.
Future<void> launchUrl(
  String url, {
  BuildContext? context,
  String? webOnlyWindowName,
}) async {
  try {
    await url_launcher.launchUrl(
      Uri.parse(url),
      webOnlyWindowName: webOnlyWindowName,
    );
  } catch (e) {
    if (context == null) return;
    if (!context.mounted) return;

    showSnackSec(context: context, text: context.l10n.websiteLaunchUrlFailed);
  }
}

String withLangQuery(BuildContext context, String location) {
  final currentUri = Uri.parse(GoRouter.of(context).state.uri.toString());
  final currentLang = currentUri.queryParameters['lang'];
  if (currentLang == null || currentLang.isEmpty) {
    return location;
  }

  final targetUri = Uri.parse(location);
  final updatedQuery = Map<String, String>.from(targetUri.queryParameters);
  updatedQuery.putIfAbsent('lang', () => currentLang);
  return targetUri.replace(queryParameters: updatedQuery).toString();
}

void goWithLang(BuildContext context, String location) {
  context.go(withLangQuery(context, location));
}
