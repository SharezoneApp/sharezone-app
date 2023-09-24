import 'package:flutter/material.dart';
import 'package:sharezone_website/widgets/snackbars.dart';
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
