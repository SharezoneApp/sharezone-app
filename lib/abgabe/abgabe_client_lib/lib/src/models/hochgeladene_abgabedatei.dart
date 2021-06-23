import 'package:common_domain_models/common_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:optional/optional.dart';

import 'abgabedatei.dart';
import 'dateiname.dart';
import 'download_url.dart';

class HochgeladeneAbgabedatei extends Abgabedatei {
  final DateiDownloadUrl downloadUrl;
  final Optional<DateTime> zuletztBearbeitet;

  HochgeladeneAbgabedatei({
    @required AbgabedateiId id,
    @required Dateiname name,
    @required Dateigroesse groesse,
    @required this.downloadUrl,
    @required DateTime erstellungsdatum,
    DateTime zuletztBearbeitet,
  })  : zuletztBearbeitet = Optional.ofNullable(zuletztBearbeitet),
        super(
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
      zuletztBearbeitet: zuletztBearbeitet.orElse(null),
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HochgeladeneAbgabedatei &&
        o.downloadUrl == downloadUrl &&
        o.erstellungsdatum == erstellungsdatum &&
        o.zuletztBearbeitet == zuletztBearbeitet;
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
