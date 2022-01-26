// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/src/erstellung/api_authentication/firebase_auth_token_retreiver.dart';
import 'package:abgabe_http_api/api/abgabedatei_api.dart';
import 'package:common_domain_models/common_domain_models.dart';

abstract class AbgabendateiLoescher {
  Future<void> loescheDatei(AbgabedateiId dateiId);
}

class HttpAbgabendateiLoescher extends AbgabendateiLoescher {
  final AbgabedateiApi api;
  final AbgabeId abgabeId;
  final FirebaseAuthHeaderRetreiver _authHeaderRetreiver;

  HttpAbgabendateiLoescher(this.api, this.abgabeId, this._authHeaderRetreiver);

  @override
  Future<void> loescheDatei(AbgabedateiId dateiId) async {
    await api.deleteFile(
      '$abgabeId',
      '$dateiId',
      headers: await _authHeaderRetreiver.getAuthHeader(),
    );
  }
}
