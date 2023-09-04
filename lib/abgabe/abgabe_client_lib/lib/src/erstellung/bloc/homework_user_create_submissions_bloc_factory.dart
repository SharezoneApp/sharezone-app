// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/src/erstellung/abnahme_erstellung_gateway.dart';
import 'package:abgabe_client_lib/src/erstellung/api_authentication/firebase_auth_token_retreiver.dart';
import 'package:abgabe_client_lib/src/erstellung/bloc/homework_user_submissions_bloc.dart';
import 'package:abgabe_client_lib/src/erstellung/local_file_saver.dart';
import 'package:abgabe_client_lib/src/erstellung/uploader/abgabedatei_uploader.dart';
import 'package:abgabe_client_lib/src/erstellung/use_cases/abgabe_veroeffentlicher.dart';
import 'package:abgabe_client_lib/src/erstellung/use_cases/datei_loescher.dart';
import 'package:abgabe_client_lib/src/erstellung/use_cases/datei_umbenenner.dart';
import 'package:abgabe_http_api/api.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:common_domain_models/common_domain_models.dart';

class HomeworkUserCreateSubmissionsBlocFactory extends BlocBase {
  final String userId;
  final AbgabedateiUploader uploader;
  final SingletonLocalFileSaver saver;
  final AbnahmeErstellungGateway gateway;
  final AbgabeHttpApi abgabeHttpApi;
  final Future<void> Function(dynamic exception, StackTrace stack) recordError;
  final FirebaseAuthTokenRetriever authTokenRetriever;

  HomeworkUserCreateSubmissionsBlocFactory({
    required this.uploader,
    required this.saver,
    required this.recordError,
    required this.userId,
    required this.gateway,
    required this.abgabeHttpApi,
    required this.authTokenRetriever,
  });

  HomeworkUserCreateSubmissionsBloc create(String homeworkId) {
    var id = HomeworkId(homeworkId);
    final abgabeId = AbgabeId(AbgabezielId.homework(id), UserId(userId));
    final abgabedateiApi = abgabeHttpApi.getAbgabedateiApi();
    final headerRetriever = FirebaseAuthHeaderRetriever(authTokenRetriever);
    final umbenenner =
        HttpAbgabendateiUmbenenner(abgabedateiApi, abgabeId, headerRetriever);
    final loescher =
        HttpAbgabendateiLoescher(abgabedateiApi, abgabeId, headerRetriever);
    final veroeffentlicher = HttpAbgabeVeroeffentlicher(
        abgabeHttpApi.getAbgabeApi(), headerRetriever);

    return HomeworkUserCreateSubmissionsBloc(
      AbgabeId(AbgabezielId.homework(id), UserId(userId)),
      recordError,
      saver,
      uploader,
      gateway.streamAbgabe(HomeworkId(homeworkId)),
      loescher,
      umbenenner,
      veroeffentlicher,
      gateway.streamAbgabezeitpunktFuerHausaufgabe(id),
      () => DateTime.now(),
    );
  }

  @override
  void dispose() {}
}
