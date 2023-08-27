// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// Hpyerlink fürs Web
Future<void> launchURL(String url, {BuildContext? context}) async {
  try {
    await launchUrl(
      Uri.parse(url),
      // We are not using [LaunchMode.platformDefault] because this opens by
      // default the link in an in-app webview on iOS and Android, which is not
      // what we want. This prevents opening the apps of the links, e.g.
      // Discord, Twitter, etc. are opened in the in-app webview instead of the
      // app.
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    if (context != null) {
      showSnackSec(
        context: context,
        text: "Der Link konnte nicht geöffnet werden!",
      );
    } else {
      throw Exception("Could not launchUrl $url");
    }
  }
}
