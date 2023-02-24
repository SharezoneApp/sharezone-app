// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:url_launcher/url_launcher.dart';

/// Hpyerlink fürs Web
Future<void> launchURL(String url, {BuildContext context}) async {
  final _url = Uri.parse(url);
  if (await canLaunchUrl(_url)) {
    await launchUrl(_url);
  } else {
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
