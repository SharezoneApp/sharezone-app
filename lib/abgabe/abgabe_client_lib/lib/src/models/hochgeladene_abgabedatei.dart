// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';

import 'abgabedatei.dart';
import 'dateiname.dart';
import 'download_url.dart';

class HochgeladeneAbgabedatei extends Abgabedatei {
  final DateiDownloadUrl downloadUrl;
  final DateTime? zuletztBearbeitet;

  HochgeladeneAbgabedatei({
    required AbgabedateiId id,
    required Dateiname name,
    required Dateigroesse groesse,
    required this.downloadUrl,
    required DateTime erstellungsdatum,
    this.zuletztBearbeitet,
  }) : super(
          id: id,
          name: name,
          dateigroesse: groesse,
          erstellungsdatum: erstellungsdatum,
        ) {
    ArgumentError.checkNotNull(downloadUrl, 'downloadUrl');
    ArgumentError.checkNotNull(erstellungsdatum, 'erstellungsdatum');
  }

  @override
  HochgeladeneAbgabedatei nenneUm(Dateiname neuerDateiname) {
    return HochgeladeneAbgabedatei(
      id: id,
      name: neuerDateiname,
      groesse: dateigroesse,
      downloadUrl: downloadUrl,
      erstellungsdatum: erstellungsdatum,
      zuletztBearbeitet: zuletztBearbeitet,
    );
  }

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return other is HochgeladeneAbgabedatei &&
        other.downloadUrl == downloadUrl &&
        other.erstellungsdatum == erstellungsdatum &&
        other.zuletztBearbeitet == zuletztBearbeitet;
  }

  @override
  int get hashCode =>
      downloadUrl.hashCode ^
      erstellungsdatum.hashCode ^
      zuletztBearbeitet.hashCode;

  @override
  String toString() =>
      'HochgeladeneAbgabedatei(id: $id, name: $name, downloadUrl: $downloadUrl, erstellungsdatum: $erstellungsdatum, zuletztBearbeitet: $zuletztBearbeitet)';
}
