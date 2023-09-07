// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/src/erstellung/api_authentication/firebase_auth_token_retreiver.dart';
import 'package:abgabe_http_api/api/abgabe_api.dart';
import 'package:abgabe_http_api/model/submission_dto.dart';
import 'package:common_domain_models/common_domain_models.dart';

abstract class AbgabeVeroeffentlicher {
  Future<void> veroeffentlicheAbgabe(AbgabeId abgabeId);
}

class HttpAbgabeVeroeffentlicher implements AbgabeVeroeffentlicher {
  final AbgabeApi _api;
  final FirebaseAuthHeaderRetriever _authHeaderRetriever;

  HttpAbgabeVeroeffentlicher(this._api, this._authHeaderRetriever);

  @override
  Future<void> veroeffentlicheAbgabe(AbgabeId abgabeId) async {
    await _api.publishSubmission(
      '$abgabeId',
      SubmissionDto(
        (dto) => dto.published = true,
      ),
      headers: await _authHeaderRetriever.getAuthHeader(),
    );
  }
}
