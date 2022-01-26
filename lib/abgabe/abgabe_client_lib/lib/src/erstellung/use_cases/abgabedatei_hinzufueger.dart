// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/src/erstellung/api_authentication/firebase_auth_token_retreiver.dart';
import 'package:abgabe_client_lib/src/models/models.dart';
import 'package:abgabe_http_api/api/abgabedatei_api.dart';
import 'package:abgabe_http_api/model/datei_hinzufuegen_command_dto.dart';

abstract class AbgabedateiHinzufueger {
  Future<void> fuegeAbgabedateiHinzu(DateiHinzufuegenCommand befehl);
}

class HttpAbgabedateiHinzufueger extends AbgabedateiHinzufueger {
  HttpAbgabedateiHinzufueger(
    this.api,
    this._authHeaderRetreiver,
  );

  final AbgabedateiApi api;
  final FirebaseAuthHeaderRetreiver _authHeaderRetreiver;

  @override
  Future<void> fuegeAbgabedateiHinzu(DateiHinzufuegenCommand befehl) async {
    await api.addFile(
      '${befehl.abgabeId}',
      DateiHinzufuegenCommandDto((dto) {
        dto.id = '${befehl.dateiId}';
        dto.name = '${befehl.dateiname}';
      }),
      headers: await _authHeaderRetreiver.getAuthHeader(),
    );
  }
}
