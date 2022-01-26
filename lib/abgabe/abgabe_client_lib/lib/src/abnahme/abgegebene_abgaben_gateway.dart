// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/src/models/abgegebene_abgabe.dart';
import 'package:abgabe_client_lib/src/shared/abgabefrist_streamer.dart';
import 'package:common_domain_models/common_domain_models.dart';

import 'view_submissions_page_bloc.dart';

abstract class AbgabenAbnahmeGateway implements AbgabefristStreamer {
  Stream<List<AbgegebeneAbgabe>> streamAbgabenFuerHausaufgabe(
      final HomeworkId homeworkId);
  Stream<List<Nutzer>> vonAbgabeBetroffendeNutzer(AbgabeId abgabeId);
}
