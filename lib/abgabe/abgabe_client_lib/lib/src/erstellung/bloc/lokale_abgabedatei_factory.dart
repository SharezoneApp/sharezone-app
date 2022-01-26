// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/src/erstellung/lokale_abgabedatei.dart';
import 'package:abgabe_client_lib/src/models/models.dart';

import 'package:files_basics/local_file.dart';

import 'homework_user_submissions_bloc.dart';

class LokaleAbgabedateiFactory {
  final AbgabedateiIdGenerator generiereId;
  final DateTime Function() _getCurrentDateTime;

  LokaleAbgabedateiFactory(
    this.generiereId,
    this._getCurrentDateTime,
  );

  LokaleAbgabedatei vonLocalFile(LocalFile localFile) {
    return LokaleAbgabedatei(
      id: generiereId(localFile),
      name: Dateiname(localFile.getName()),
      dateigroesse: Dateigroesse(localFile.getSizeBytes()),
      pfad: localFile.getPath(),
      erstellungsdatum: _getCurrentDateTime(),
      localFile: localFile,
    );
  }
}
