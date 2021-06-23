import 'package:common_domain_models/common_domain_models.dart';
import 'package:meta/meta.dart';

class Beitrittsversuch {
  final Sharecode sharecode;

  Beitrittsversuch({@required this.sharecode});

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is Beitrittsversuch && sharecode == other.sharecode;
  }

  @override
  int get hashCode => sharecode.hashCode;

  @override
  String toString() {
    return "Beitrittsversuch(publicKey: $sharecode)";
  }
}
