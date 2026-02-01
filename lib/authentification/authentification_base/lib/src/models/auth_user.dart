// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

enum Provider { email, google, anonymous, apple }

extension ProviderExtension on Provider {
  /// Wenn der Nutzer die Anmeldemethode Google oder E-Mail verwendet, hat der
  /// Nutzer eine E-Mail. Bei anderen Anmeldemethoden wie z.B. Apple wird keine
  /// E-Mail Adresse gespeichert.
  bool get hasEmailAddress => this == Provider.google || this == Provider.email;
}

class AuthUser {
  final String uid;
  final User firebaseUser;

  const AuthUser({required this.uid, required this.firebaseUser});

  static AuthUser? fromFirebaseUser(User? firebaseUser) {
    if (firebaseUser == null) return null;
    return AuthUser(uid: firebaseUser.uid, firebaseUser: firebaseUser);
  }

  String? get email {
    return firebaseUser.email;
  }

  bool get isAnonymous {
    return firebaseUser.isAnonymous;
  }

  Provider get provider {
    if (firebaseUser.isAnonymous || firebaseUser.providerData.isEmpty) {
      return Provider.anonymous;
    } else {
      if (firebaseUser.providerData.last.providerId == "google.com") {
        return Provider.google;
      }
      if (firebaseUser.providerData.last.providerId == "apple.com") {
        return Provider.apple;
      }
      return Provider.email;
    }
  }
}

String providerToUiString(Provider provider, SharezoneLocalizations l10n) {
  switch (provider) {
    case Provider.anonymous:
      return l10n.authProviderAnonymous;
    case Provider.google:
      return l10n.authProviderGoogle;
    case Provider.apple:
      return l10n.authProviderApple;
    case Provider.email:
      return l10n.authProviderEmailPassword;
  }
}
