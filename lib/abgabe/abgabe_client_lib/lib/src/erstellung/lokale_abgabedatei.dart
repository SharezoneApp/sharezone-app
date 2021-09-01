import 'package:abgabe_client_lib/src/models/abgabedatei.dart';
import 'package:abgabe_client_lib/src/models/dateiname.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:meta/meta.dart';
import 'package:optional/optional.dart';

class LokaleAbgabedatei extends Abgabedatei {
  /// Might not be available on the web.
  final Optional<String> pfad;

  /// Used to pass to the [SingletonLocalFileSaver].
  /// Used to get the data of the file. The other attributes might differ
  /// (e.g. [name]).
  final LocalFile localFile;

  LokaleAbgabedatei({
    @required AbgabedateiId id,
    @required Dateiname name,
    @required Dateigroesse dateigroesse,
    @required DateTime erstellungsdatum,
    @required this.localFile,
    String pfad,
  })  : this.pfad = Optional.ofNullable(pfad),
        super(
            id: id,
            name: name,
            dateigroesse: dateigroesse,
            erstellungsdatum: erstellungsdatum) {
    ArgumentError.checkNotNull(erstellungsdatum, 'erstellungsdatum');
    ArgumentError.checkNotNull(localFile, 'localFile');
  }

  @override
  LokaleAbgabedatei nenneUm(Dateiname neuerDateiname) {
    return LokaleAbgabedatei(
      id: id,
      name: neuerDateiname,
      dateigroesse: dateigroesse,
      pfad: pfad.orElse(null),
      erstellungsdatum: erstellungsdatum,
      localFile: localFile,
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
