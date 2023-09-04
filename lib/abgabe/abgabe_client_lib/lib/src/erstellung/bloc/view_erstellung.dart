// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/src/erstellung/bloc/homework_user_submissions_bloc.dart';
import 'package:abgabe_client_lib/src/erstellung/views.dart';
import 'package:abgabe_client_lib/src/models/models.dart';

extension AbgabedateiToView on Abgabedatei {
  FileView toView() {
    if (this is HochladeneLokaleAbgabedatei) {
      // Sodass Dart die Extension-Methoden unten benutzt.
      HochladeneLokaleAbgabedatei d = this as HochladeneLokaleAbgabedatei;
      return d.toView();
    } else if (this is HochgeladeneAbgabedatei) {
      HochgeladeneAbgabedatei d = this as HochgeladeneAbgabedatei;
      return d.toView();
    }
    throw UnimplementedError('$runtimeType to $FileView is not implemented');
  }
}

extension HochladeneDateiToView on HochladeneLokaleAbgabedatei {
  FileView toView() => FileView(
        id: '$id',
        path: pfad.orElseNull,
        basename: name.ohneExtension,
        extentionName: name.nurExtension,
        fileFormat: format,
        status: fortschritt.status,
        uploadProgess: fortschritt.inProzent.orElseNull,
      );
}

extension HochgeladeneAbgabedateiToView on HochgeladeneAbgabedatei {
  FileView toView() => FileView(
        id: '$id',
        extentionName: name.nurExtension,
        basename: name.ohneExtension,
        status: FileViewStatus.successfullyUploaded,
        fileFormat: format,
        downloadUrl: downloadUrl.toString(),
      );
}
