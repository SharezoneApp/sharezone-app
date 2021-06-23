import 'package:common_domain_models/common_domain_models.dart';
import 'package:meta/meta.dart';

import 'abgaben_commands.dart';
import 'dateiname.dart';

class DateiHinzufuegenCommand extends AbgabeCommand {
  final AbgabedateiId dateiId;
  final Dateiname dateiname;

  DateiHinzufuegenCommand({
    @required AbgabeId abgabeId,
    @required this.dateiId,
    @required this.dateiname,
  }) : super.randomId(abgabeId) {
    ArgumentError.checkNotNull(dateiId, 'dateiId');
    ArgumentError.checkNotNull(dateiname, 'dateiname');
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is DateiHinzufuegenCommand &&
            other.dateiId == dateiId &&
            other.dateiname == dateiname;
  }

  @override
  int get hashCode => dateiId.hashCode ^ dateiname.hashCode;

  @override
  String toString() {
    return '$runtimeType(abgabeId:$abgabeId, dateiId: $dateiId, dateiname: $dateiname)';
  }
}
