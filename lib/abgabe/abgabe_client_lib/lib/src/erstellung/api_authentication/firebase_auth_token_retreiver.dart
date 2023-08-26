// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

/// Lädt den aktuellen Token vom Firebase-User.
/// Ist ein Interface, weil wir in dem Package nicht auf Flutteer dependen wollen.
abstract class FirebaseAuthTokenRetriever {
  Future<String> getToken();
}

class FirebaseAuthHeaderRetriever {
  FirebaseAuthHeaderRetriever(this._tokenRetriever);

  final FirebaseAuthTokenRetriever _tokenRetriever;

  Future<Map<String, String>> getAuthHeader() async {
    final token = await _tokenRetriever.getToken();
    return {'authorization': 'Bearer $token'};
  }
}
