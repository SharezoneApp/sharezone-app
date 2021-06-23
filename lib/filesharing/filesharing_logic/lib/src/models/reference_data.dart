import 'package:meta/meta.dart';
import 'reference_type.dart';

class ReferenceData {
  String id;
  ReferenceType type;

  ReferenceData({
    @required this.id,
    @required this.type,
  });

  factory ReferenceData.fromData(Map<String, dynamic> data) {
    return ReferenceData(
      id: data['id'],
      type: data['type'],
    );
  }

  factory ReferenceData.fromMapData(
      {@required String id, @required Map<String, dynamic> data}) {
    return ReferenceData(
      id: id,
      type: referenceTypeEnumFromString(data['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': referenceTypeEnumToString(type),
    };
  }

  ReferenceData copyWith({
    String id,
    ReferenceType type,
  }) {
    return ReferenceData(
      id: id ?? this.id,
      type: type ?? this.type,
    );
  }
}
