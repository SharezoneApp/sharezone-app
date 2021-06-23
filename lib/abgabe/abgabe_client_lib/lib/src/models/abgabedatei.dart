import 'package:common_domain_models/common_domain_models.dart';
import 'package:files_basics/files_models.dart';
import 'package:meta/meta.dart';

import 'dateiname.dart';

abstract class Abgabedatei {
  final AbgabedateiId id;
  final Dateiname name;
  final Dateigroesse dateigroesse;
  final DateTime erstellungsdatum;

  FileFormat get format =>
      fileFormatEnumFromFilenameWithExtension(name.mitExtension);

  Abgabedatei({
    @required this.id,
    @required this.name,
    @required this.dateigroesse,
    @required this.erstellungsdatum,
  }) {
    ArgumentError.checkNotNull(id, 'AbgabedateiId');
    ArgumentError.checkNotNull(name, 'name');
    ArgumentError.checkNotNull(dateigroesse, 'dateigroesse');
    ArgumentError.checkNotNull(erstellungsdatum, 'erstellungsdatum');
  }

  @override
  int get hashCode => name.hashCode ^ format.hashCode;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is Abgabedatei && other.name == name && other.format == format;
  }

  Abgabedatei nenneUm(Dateiname neuerDateiname);

  @override
  String toString() {
    return 'Abgabedatei(id: $id, name: ${name.mitExtension})';
  }
}

class Dateigroesse {
  final int inBytes;
  // In Zukunft könnte man hier auch noch inMegabytes etc hinzufügen

  Dateigroesse(this.inBytes) {
    ArgumentError.checkNotNull(inBytes, 'groesseInBytes');
    if (inBytes.isNegative) {
      throw ArgumentError('Die Dateigroesse in Bytes muss positiv sein');
    }
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Dateigroesse && o.inBytes == inBytes;
  }

  @override
  int get hashCode => inBytes.hashCode;

  @override
  String toString() => 'Dateigroesse(inBytes: $inBytes)';
}
