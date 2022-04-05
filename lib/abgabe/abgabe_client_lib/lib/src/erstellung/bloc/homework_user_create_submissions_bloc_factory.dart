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
import 'package:meta/meta.dart';

class HomeworkUserCreateSubmissionsBlocFactory extends BlocBase {
  final String userId;
  final AbgabedateiUploader uploader;
  final SingletonLocalFileSaver saver;
  final AbnahmeErstellungGateway gateway;
  final AbgabeHttpApi abgabeHttpApi;
  final Future<void> Function(dynamic exception, StackTrace stack) recordError;
  final FirebaseAuthTokenRetreiver authTokenRetreiver;

  HomeworkUserCreateSubmissionsBlocFactory({
    @required this.uploader,
    @required this.saver,
    @required this.recordError,
    @required this.userId,
    @required this.gateway,
    @required this.abgabeHttpApi,
    @required this.authTokenRetreiver,
  });

  HomeworkUserCreateSubmissionsBloc create(String homeworkId) {
    var _homeworkId = HomeworkId(homeworkId);
    final abgabeId =
        AbgabeId(AbgabezielId.homework(_homeworkId), UserId(userId));
    final abgabedateiApi = abgabeHttpApi.getAbgabedateiApi();
    final headerRetreiver = FirebaseAuthHeaderRetreiver(authTokenRetreiver);
    final umbenenner =
        HttpAbgabendateiUmbenenner(abgabedateiApi, abgabeId, headerRetreiver);
    final loescher =
        HttpAbgabendateiLoescher(abgabedateiApi, abgabeId, headerRetreiver);
    final veroeffentlicher = HttpAbgabeVeroeffentlicher(
        abgabeHttpApi.getAbgabeApi(), headerRetreiver);

    return HomeworkUserCreateSubmissionsBloc(
      AbgabeId(AbgabezielId.homework(_homeworkId), UserId(userId)),
      recordError,
      saver,
      uploader,
      gateway.streamAbgabe(HomeworkId(homeworkId)),
      loescher,
      umbenenner,
      veroeffentlicher,
      gateway.streamAbgabezeitpunktFuerHausaufgabe(_homeworkId),
      () => DateTime.now(),
    );
  }

  @override
  void dispose() {}
}
