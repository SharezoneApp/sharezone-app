import 'package:common_domain_models/common_domain_models.dart';

import 'auto_id_generator.dart';

class AbgabeEventId extends Id {
  AbgabeEventId(String id) : super(id, 'AbgabeEventId');
}

abstract class AbgabeCommand {
  final AbgabeEventId id;
  final AbgabeId abgabeId;
  UserId get abgeberId => abgabeId.nutzerId;

  AbgabeCommand(
    this.id,
    this.abgabeId,
  ) {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(abgabeId, 'abgabeId');
  }

  AbgabeCommand.randomId(this.abgabeId)
      : id = AbgabeEventId(AutoIdGenerator.autoId());

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is AbgabeCommand && other.id == id && other.abgabeId == abgabeId;
  }

  @override
  int get hashCode => id.hashCode ^ abgabeId.hashCode;

  @override
  String toString() {
    return 'AbgabeCommand(id: $id, abgabeId: $abgabeId)';
  }
}
