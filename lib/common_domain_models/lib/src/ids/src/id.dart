import 'package:util/util.dart';

class Id {
  final String id;

  Id(this.id, [String idName]) {
    throwIfNullOrEmpty(id, idName ?? 'id');
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || other is Id && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return id;
  }
}
