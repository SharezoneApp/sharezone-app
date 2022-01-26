// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

/// Lädt den aktuellen Token vom Firebase-User.
/// Ist ein Interface, weil wir in dem Package nicht auf Flutteer dependen wollen.
abstract class FirebaseAuthTokenRetreiver {
  Future<String> getToken();
}

class FirebaseAuthHeaderRetreiver {
  FirebaseAuthHeaderRetreiver(this._tokenRetreiver);

  final FirebaseAuthTokenRetreiver _tokenRetreiver;

  Future<Map<String, String>> getAuthHeader() async {
    final token = await _tokenRetreiver.getToken();
    return {'authorization': 'Bearer $token'};
  }
}
