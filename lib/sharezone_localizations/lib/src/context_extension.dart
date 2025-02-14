// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

extension SharezoneLocalizationsContextExtension on BuildContext {
  /// Extension on [BuildContext] to access the [SharezoneLocalizations] object.
  ///
  /// Requires the SharezoneLocalizations to be available in the context,
  /// otherwise it will throw an exception. Add
  /// [SharezoneLocalizations.delegate] to the underlying App
  /// localizationsDelegates, for access in the context of the app.
  SharezoneLocalizations get l10n {
    final localizations = SharezoneLocalizations.of(this);
    if (localizations == null) {
      throw FlutterError(
        'SharezoneLocalizations not found.\n'
        'Did you forget to add SharezoneLocalizations.delegate to your '
        'MaterialApp/CupertinoApp localizationsDelegates?',
      );
    }
    return localizations;
  }
}
