import 'package:flutter/material.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:url_launcher/url_launcher.dart';

/// Hpyerlink fürs Web
Future<void> launchURL(String url, {BuildContext context}) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    if (context != null) {
      showSnackSec(
        context: context,
        text: "Der Link konnte nicht geöffnet werden!",
      );
    } else {
      throw Exception("Could not launch $url");
    }
  }
}
