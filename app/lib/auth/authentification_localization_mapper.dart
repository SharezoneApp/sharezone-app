// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification.dart';
import 'package:flutter/widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

String? mapAuthentificationValidationErrorMessage(
  BuildContext context,
  Object? error,
) {
  return switch (error) {
    AuthentificationValidationError.invalidEmail =>
      context.l10n.authValidationInvalidEmail,
    AuthentificationValidationError.invalidPasswordTooShort =>
      context.l10n.authValidationInvalidPasswordTooShort,
    AuthentificationValidationError.invalidName =>
      context.l10n.authValidationInvalidName,
    null => null,
    _ => error.toString(),
  };
}

String mapAuthProviderName(BuildContext context, Provider provider) {
  return switch (provider) {
    Provider.anonymous => context.l10n.authProviderAnonymous,
    Provider.google => context.l10n.authProviderGoogle,
    Provider.apple => context.l10n.authProviderApple,
    Provider.email => context.l10n.authProviderEmailAndPassword,
  };
}
