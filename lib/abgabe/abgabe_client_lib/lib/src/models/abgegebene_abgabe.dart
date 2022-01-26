// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/files_models.dart';
import 'package:meta/meta.dart';
import 'package:optional/optional.dart';
import 'package:common_domain_models/common_domain_models.dart';

import 'dateiname.dart';
import 'download_url.dart';
import 'hochgeladene_abgabedatei.dart';
import 'nutzername.dart';

class AbgegebeneAbgabe {
  final AbgabeId id;
  final Author author;
  final List<HochgeladeneAbgabedatei> abgegebeneDateien;
  final DateTime abgabezeitpunkt;
  final Optional<DateTime> zuletztBearbeitet;
  DateTime get letzteAktion =>
      zuletztBearbeitet.isPresent ? zuletztBearbeitet.value : abgabezeitpunkt;

  AbgegebeneAbgabe({
    @required this.id,
    @required this.author,
    @required this.abgegebeneDateien,
    @required this.abgabezeitpunkt,
    DateTime zuletztBearbeitet,
  }) : zuletztBearbeitet = Optional.ofNullable(zuletztBearbeitet) {
    ArgumentError.checkNotNull(author, 'author');
    ArgumentError.checkNotNull(abgegebeneDateien, 'abgegebeneDateien');
  }

  bool wurdeAbgegebenNach(DateTime dateTime) =>
      abgabezeitpunkt.isAfter(dateTime);
}

class Author {
  final UserId id;
  final Nutzername name;

  Author(this.id, this.name);
}

class AbgegebeneDatei {
  final FileId id;
  final DateTime einreichDatum;
  FileFormat get format =>
      FileUtils.getFileFormatFromExtension(name.nurExtension);
  final Dateiname name;
  final DateiDownloadUrl downloadUrl;

  AbgegebeneDatei({
    @required this.id,
    @required this.einreichDatum,
    @required this.name,
    @required this.downloadUrl,
  }) {
    ArgumentError.checkNotNull(id, 'fileId');
    ArgumentError.checkNotNull(einreichDatum, 'einreichDatum');
    ArgumentError.checkNotNull(name, 'dateiname');
    ArgumentError.checkNotNull(downloadUrl, 'downloadUrl');
  }
}
