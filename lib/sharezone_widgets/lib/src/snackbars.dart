// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

SharezoneLocalizations? _resolveLocalizations({
  BuildContext? context,
  GlobalKey<ScaffoldMessengerState>? key,
}) {
  final resolvedContext = context ?? key?.currentContext;
  return resolvedContext != null
      ? SharezoneLocalizations.of(resolvedContext)
      : null;
}

void snackbarSoon({
  BuildContext? context,
  GlobalKey<ScaffoldMessengerState>? key,
}) {
  final l10n = _resolveLocalizations(context: context, key: key);
  showSnackSec(
    text: l10n?.sharezoneWidgetsSnackbarComingSoon,
    seconds: 3,
    context: context,
    key: key,
  );
}

/// [behavior] ist hier standardmäßig fixed, da die [showDataArrivalConfirmedSnackbar]
/// ob aufgerufen wird, wenn es einen FAB gib. Gibt einen FAB, sehen die floating
/// Snackbars absolut kacke aus ._. Deswegen wird dann für diesen Fall das
/// [behavior] auf fixed gewechselt.
void showDataArrivalConfirmedSnackbar({
  GlobalKey<ScaffoldMessengerState>? key,
  BuildContext? context,
  SnackBarBehavior behavior = SnackBarBehavior.fixed,
}) {
  final l10n = _resolveLocalizations(context: context, key: key);
  showSnack(
    context: context,
    key: key,
    text: l10n?.sharezoneWidgetsSnackbarDataArrivalConfirmed,
    duration: const Duration(milliseconds: 1500),
    behavior: behavior,
  );
}

void sendDataToFrankfurtSnackBar(
  BuildContext context, {
  SnackBarBehavior? behavior,
}) {
  showSnackSec(
    context: context,
    seconds: 3600,
    withLoadingCircle: true,
    behavior: behavior,
    text: context.l10n.sharezoneWidgetsSnackbarSendingDataToFrankfurt,
  );
}

void sendLoginDataEncryptedSnackBar(BuildContext context) {
  showSnackSec(
    context: context,
    text: context.l10n.sharezoneWidgetsSnackbarLoginDataEncrypted,
    seconds: 120,
    withLoadingCircle: true,
  );
}

void savedChangesSnackBar(
  BuildContext context, {
  Duration duration = const Duration(milliseconds: 1750),
}) {
  showSnack(
    context: context,
    text: context.l10n.sharezoneWidgetsSnackbarSaved,
    duration: duration,
  );
}

void patienceSnackBar(BuildContext context) {
  showSnackSec(
    context: context,
    seconds: 2,
    text: context.l10n.sharezoneWidgetsSnackbarPatience,
  );
}

void showSnackSec({
  String? text,
  int seconds = 3,
  BuildContext? context,
  GlobalKey<ScaffoldMessengerState>? key,
  bool withLoadingCircle = false,
  SnackBarAction? action,
  bool hideCurrentSnackBar = true,
  SnackBarBehavior? behavior,
}) {
  showSnack(
    key: key,
    duration: Duration(seconds: seconds),
    context: context,
    text: text,
    withLoadingCircle: withLoadingCircle,
    action: action,
    hideCurrentSnackBar: hideCurrentSnackBar,
    behavior: behavior,
  );
}

void showSnack({
  String? text,
  Duration duration = const Duration(seconds: 3),
  BuildContext? context,
  GlobalKey<ScaffoldMessengerState>? key,
  bool withLoadingCircle = false,
  SnackBarAction? action,
  bool hideCurrentSnackBar = true,
  SnackBarBehavior? behavior = SnackBarBehavior.floating,
}) {
  assert(
    context != null || key != null,
    'A snackbar needs a context or a key!',
  );

  final snackBar = SnackBar(
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (withLoadingCircle)
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 4),
            child: SizedBox(
              width: 25,
              height: 25,
              child: AccentColorCircularProgressIndicator(),
            ),
          ),
        if (text != null) Flexible(child: Text(text)),
      ],
    ),
    duration: duration,
    action: action,
    behavior: behavior,
    width: getSnackBarWidth(context, behavior),
  );

  if (key != null) {
    try {
      if (hideCurrentSnackBar) key.currentState!.removeCurrentSnackBar();
      key.currentState!.showSnackBar(snackBar);
    } catch (e) {
      log(
        "Fehler beim anzeigen der SnackBar über den Key: ${e.toString()}",
        error: e,
      );
    }
  } else if (context != null) {
    try {
      if (hideCurrentSnackBar) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      }
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      log(
        "Fehler beim anzeigen der SnackBar über den Kontext: ${e.toString()}",
        error: e,
      );
    }
  } else {
    debugPrint("Fehler! Die SnackBar hat keinen Key und keinen Context!");
  }
}

double? getSnackBarWidth(BuildContext? context, SnackBarBehavior? behavior) {
  if (context == null) {
    return null;
  }

  final isSmallScreen = MediaQuery.of(context).size.width < 550;
  if (isSmallScreen) {
    // For small screens, the snackbar should be full width.
    return null;
  }

  // The width of the snackbar can only be set if the behavior is floating.
  behavior ??= Theme.of(context).snackBarTheme.behavior;
  return behavior == SnackBarBehavior.floating ? 450 : null;
}
