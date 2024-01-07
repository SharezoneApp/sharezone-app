// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

/// Launches the given [url] in the browser.
///
/// If the [url] can't be launched, a [SnackBar] is shown.
Future<void> launchUrl(String url, {BuildContext? context}) async {
  try {
    await url_launcher.launchUrl(Uri.parse(url));
  } catch (e) {
    if (context == null) return;
    if (!context.mounted) return;

    showSnackSec(
      context: context,
      text: 'Link konnte nicht geöffnet werden!',
    );
  }
}
