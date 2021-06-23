import 'package:abgabe_client_lib/src/models/abgabedatei.dart';
import 'package:abgabe_client_lib/src/models/dateiname.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:meta/meta.dart';

class LokaleAbgabedatei extends Abgabedatei {
  final String pfad;

  LokaleAbgabedatei({
    @required AbgabedateiId id,
    @required Dateiname name,
    @required Dateigroesse dateigroesse,
    @required DateTime erstellungsdatum,
    @required this.pfad,
  }) : super(
            id: id,
            name: name,
            dateigroesse: dateigroesse,
            erstellungsdatum: erstellungsdatum) {
    ArgumentError.checkNotNull(erstellungsdatum, 'erstellungsdatum');
    ArgumentError.checkNotNull(pfad, 'pfad');
  }

  @override
  LokaleAbgabedatei nenneUm(Dateiname neuerDateiname) {
    return LokaleAbgabedatei(
      id: id,
      name: neuerDateiname,
      dateigroesse: dateigroesse,
      pfad: pfad,
      erstellungsdatum: erstellungsdatum,
    );
  }

  @override
  String toString() => 'LokaleAbgabedatei(id: $id, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LokaleAbgabedatei && o.pfad == pfad;
  }

  @override
  int get hashCode => pfad.hashCode;
}
