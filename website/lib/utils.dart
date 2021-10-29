import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Hpyerlink fürs Web
Future<void> launchURL(String url, {BuildContext? context}) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    if (context != null) {
      print("Der Link konnte nicht geöffnet werden!");
    } else {
      throw Exception("Could not launch $url");
    }
  }
}

/// Hyperlink für E-Mail;
/// [email] = Example: nils@codingbrain.de
/// [subject] = Example: Sharezone: Feedback geben
/// [body] = Example: Hey, was geht ab?
Future<void> launchMail(String email,
    [String subject = "", String body = ""]) async {
  String url = Uri.encodeFull("mailto:$email?subject=$subject&body=$body");
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw Exception("Could not launch $url");
  }
}
