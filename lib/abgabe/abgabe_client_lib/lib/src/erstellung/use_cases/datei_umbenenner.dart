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
import 'package:abgabe_http_api/model/dateiname_dto.dart';

import 'package:common_domain_models/common_domain_models.dart';

abstract class AbgabendateiUmbenenner {
  Future<void> nenneDateiUm(AbgabedateiId dateiId, Dateiname neuerName);
}

class HttpAbgabendateiUmbenenner extends AbgabendateiUmbenenner {
  final AbgabedateiApi api;
  final AbgabeId abgabeId;
  final FirebaseAuthHeaderRetriever _authHeaderRetriever;

  HttpAbgabendateiUmbenenner(
      this.api, this.abgabeId, this._authHeaderRetriever);

  @override
  Future<void> nenneDateiUm(AbgabedateiId dateiId, Dateiname neuerName) async {
    await api.renameFile(
        '$abgabeId',
        '$dateiId',
        DateinameDto(
          (dto) => dto.name = neuerName.mitExtension,
        ),
        headers: await _authHeaderRetriever.getAuthHeader());
  }
}
