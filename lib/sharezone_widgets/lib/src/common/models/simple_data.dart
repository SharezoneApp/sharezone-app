// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

/// Ein Datenobjekt für Widgets wie zum Beispiel [StateDialogSimpleBody] oder [StateSheetSimpleBody].
class SimpleData {
  final String title;
  final String? description;
  final IconData iconData;
  final Color? iconColor;

  const SimpleData({
    required this.title,
    this.description,
    required this.iconData,
    this.iconColor,
  });

  static SimpleData successful(BuildContext context) {
    return SimpleData(
      title: context.l10n.commonStatusSuccessful,
      iconData: Icons.done,
      iconColor: Colors.green,
    );
  }

  static SimpleData failed(BuildContext context) {
    return SimpleData(
      title: context.l10n.commonStatusFailed,
      iconData: Icons.error_outline,
      iconColor: Colors.red,
    );
  }

  static SimpleData unkonwnException(BuildContext context) {
    return SimpleData(
      title: context.l10n.commonStatusUnknownErrorTitle,
      iconData: Icons.error_outline,
      iconColor: Colors.red,
      description: context.l10n.commonStatusUnknownErrorDescription,
    );
  }

  static SimpleData noInternet(BuildContext context) {
    return SimpleData(
      title: context.l10n.commonStatusNoInternetTitle,
      iconData: Icons.error_outline,
      iconColor: Colors.red,
      description: context.l10n.commonStatusNoInternetDescription,
    );
  }
}
